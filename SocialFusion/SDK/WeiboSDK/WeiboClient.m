//
//  WeiboClient.m
//  PushboxHD
//
//  Created by Xie Hasky on 11-7-23.
//  Copyright 2011年 同济大学. All rights reserved.
//

#import "WeiboClient.h"
#import "JSON.h"
#import "NSString+URLEncoding.h"
#import "NSString+WeiboAndRenrenFactialExpression.h"
#import "WBRequest.h"
#import "OADataFetcher.h"
#import "OAToken.h"
#define RequestURL @"http://api.t.sina.com.cn/oauth/request_token" 
#define SINAAccessURL @"http://api.t.sina.com.cn/oauth/access_token" 

#define AuthorizeURL @"http://api.t.sina.com.cn/oauth/authorize"  //获取授权request token


#define AuthorizeURL2 @"https://api.weibo.com/2/oauth2/authorize"  //获取授权request token

#define AccessURL2 @"https://api.weibo.com/2/oauth2/access_token"  //获取access token


#define AccessURL @"http://api.t.sina.com.cn/oauth/access_token"  //获取access token

#define CallBackURL @"oauth://SocialFusion.com"  //回调url

#define kUserDefaultKeyTokenResponseString @"kUserDefaultKeyTokenResponseString"
#define kUserDefaultKeyGetKeyDate @"kUserDefaultKeyGetKeyDate"
#define kUserDefaultKeyExpireTime @"kUserDefaultKeyExpireTime"


static NSString* const APIDomain = @"api.weibo.com/2";

static NSString* OAuthTokenKey = nil;

static NSString* UserID = nil;

typedef enum {
    HTTPMethodPost,
    HTTPMethodForm,
    HTTPMethodGet,
} HTTPMethod;

static NSString* API_DOMAIN = @"json";
NSString *TWITTERFON_FORM_BOUNDARY = @"0194784892923";

@interface WeiboClient()

@property (nonatomic, assign, getter=isAuthRequired) BOOL authRequired;
@property (nonatomic, assign, getter=isSecureConnection) BOOL secureConnection;
@property (nonatomic, retain) NSMutableDictionary *params;
@property (nonatomic, copy) NSString *path;
@property (nonatomic, retain) OAuthHTTPRequest *request;
@property (nonatomic, assign) HTTPMethod httpMethod;
@property (nonatomic, assign, getter=isSynchronized) BOOL synchronized;
@property (nonatomic, copy) WCCompletionBlock preCompletionBlock;

- (void)buildURL;
- (void)sendRequest;


//Roy added
- (void)authorizeWithRRAppAuth:(BOOL)tryRRAppAuth
                    safariAuth:(BOOL)trySafariAuth;

@end

@implementation WeiboClient

@synthesize authRequired = _authRequired;
@synthesize secureConnection = _secureConnection;
@synthesize params = _params;
@synthesize request = _request;
@synthesize path = _path;
@synthesize httpMethod = _httpMethod;
@synthesize synchronized = _synchronized;
@synthesize preCompletionBlock = _preCompletionBlock;

@synthesize responseJSONObject = _responseJSONObject;
@synthesize responseStatusCode = _responseStatusCode;
@synthesize hasError = _hasError;
@synthesize errorDesc = _errorDesc;



#pragma mark Ëé∑ÂæóÊó∂Èó¥Êà≥
- (NSString *)_generateTimestamp 
{
    return [NSString stringWithFormat:@"%d", time(NULL)];
}

#pragma mark Ëé∑ÂæóÈöèÊó∂Â≠óÁ¨¶‰∏≤
- (NSString *)_generateNonce 
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    NSMakeCollectable(theUUID);
    return (NSString *)string;
}



- (void)setCompletionBlock:(void (^)(WeiboClient* client))completionBlock
{
    [_completionBlock autorelease];
    _completionBlock = [completionBlock copy];
}

- (WCCompletionBlock)completionBlock
{
    return _completionBlock;
}



+ (void)setTokenWithString:(NSString *)responseString andID:(NSString*)userID andTime:(int)time
{
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setValue:[NSNumber numberWithInt:time] forKey:kUserDefaultKeyExpireTime];
    [ud setValue:responseString forKey:kUserDefaultKeyTokenResponseString];
    [ud setValue:[NSDate dateWithTimeIntervalSinceNow:0] forKey:kUserDefaultKeyGetKeyDate];
    [ud synchronize];
    
    
            [OAuthTokenKey release];
            OAuthTokenKey = [responseString retain];
 
            UserID = [userID retain];
        
    
}





+ (void)initialize
{
    
}

+ (id)client
{
    //autorelease intentially ommited here
    return [[WeiboClient alloc] init];
}

- (id)init
{
    self = [super init];
    
    _params = [[NSMutableDictionary alloc] initWithCapacity:10];
    _secureConnection = YES;
    _authRequired = YES;
    _hasError = NO;
    _responseStatusCode = 0;
    _synchronized = NO;
    _httpMethod = HTTPMethodGet;
    
    _request = [[OAuthHTTPRequest alloc] initWithURL:nil];
    _request.delegate = self;
    
    return self;
}

- (void)dealloc
{
    NSLog(@"WeiboClient dealloc");
    [_responseJSONObject release];
    [_params release];
    [_request release];
    [_path release];
    [_errorDesc release];
    [_completionBlock release];
    [_preCompletionBlock release];
    [super dealloc];
}

#pragma mark delegates

- (void)reportCompletion
{
    if (_preCompletionBlock) {
        _preCompletionBlock(self);
    }
   // NSLog(@"completion block retain count:%d", [_completionBlock retainCount]);
    if (_completionBlock) {
        _completionBlock(self);
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"Request Finished");
   // NSLog(@"Response raw string:\n%@", [request responseString]);
    
    switch (request.responseStatusCode) {
        case 401: // Not Authorized: either you need to provide authentication credentials, or the credentials provided aren't valid.
            self.hasError = YES;
            self.errorDesc = NSLocalizedString(@"ERROR_AUTH_FAILED", nil);
            goto report_completion;
            
        case 304: // Not Modified: there was no new data to return.
            self.hasError = YES;
            self.errorDesc = NSLocalizedString(@"ERROR_NO_NEW_DATA", nil);
            goto report_completion;
        case 400: // Bad Request: your request is invalid, and we'll return an error message that tells you why. This is the status code returned if you've exceeded the rate limit
        case 200: // OK: everything went awesome.
        case 403: // Forbidden: we understand your request, but are refusing to fulfill it.  An accompanying error message should explain why
            break;
        case 404: // Not Found: either you're requesting an invalid URI or the resource in question doesn't exist (ex: no such user). 
        case 500: // Internal Server Error: we did something wrong.  Please post to the group about it and the Weibo team will investigate.
        case 502: // Bad Gateway: returned if Weibo is down or being upgraded.
        case 503: // Service Unavailable: the Weibo servers are up, but are overloaded with requests.  Try again later.
        default:
        {
            self.hasError = YES;
            self.errorDesc = [NSHTTPURLResponse localizedStringForStatusCode:request.responseStatusCode];
            goto report_completion;
        }
    }
    
    self.responseJSONObject = [request.responseString JSONValue];
    
    if ([self.responseJSONObject isKindOfClass:[NSDictionary class]]) {
        NSDictionary* dic = (NSDictionary*)self.responseJSONObject;
        NSString* errorCodeString = [dic objectForKey:@"error_code"];
        
        if (errorCodeString) {
            self.hasError = YES;
            self.responseStatusCode = [errorCodeString intValue];
            self.errorDesc = [dic objectForKey:@"error"];
           NSLog(@"Server responsed error code: %d\n desc: %@\n url: %@\n", self.responseStatusCode, self.errorDesc, request.url);
        }
    }
    
report_completion:
    [self reportCompletion];
    
    if (!self.synchronized) {
        [self autorelease];
    }
}

//failed due to network connection or other issues
- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Request Failed");
    NSLog(@"%@", _request.error);
    
    if (_request.error.code == 3) {
        self.errorDesc = @"请先登录新浪微博。";
    }
    
    if (_request.error.code == 1) {
        self.errorDesc = @"网络故障。";
    }
    
    
    self.hasError = YES;
    
    //same block called when failed
    [self reportCompletion];
    
    if (!self.synchronized) {
        [self autorelease];
    }
}

#pragma mark URL-generation

- (NSString *)queryString
{
    NSMutableString *str = [NSMutableString stringWithCapacity:0];
    
    NSArray *names = [_params allKeys];
    for (int i = 0; i < [names count]; i++) {
        if (i > 0) {
            [str appendString:@"&"];
        }
        NSString *name = [names objectAtIndex:i];
        [str appendString:[NSString stringWithFormat:@"%@=%@", [name URLEncodedString], 
                           [[self.params objectForKey:name] URLEncodedString]]];
    }
    [str appendString:@"&"];
    [str appendString:[NSString stringWithFormat:@"%@=%@", [[NSString stringWithString:@"access_token"] URLEncodedString], 
                       [OAuthTokenKey URLEncodedString]]];
    return str;
}

- (void)buildURL
{
    NSString* url = [NSString stringWithFormat:@"%@://%@/%@", 
                     self.secureConnection ? @"https" : @"http", 
                     APIDomain, self.path];
    
    if (self.httpMethod == HTTPMethodGet && [self.params count]) {
        url = [NSString stringWithFormat:@"%@?%@", url, [self queryString]];
    }
    NSURL *finalURL = [NSURL URLWithString:url];
    
 //   NSLog(@"finalURL:%@",finalURL);
    [_request setURL:finalURL];
}

- (void)sendRequest
{
    if ([_request url] && self.httpMethod!=HTTPMethodForm) {
        return;
    }
    
    if (self.secureConnection) {
        [self.request setValidatesSecureCertificate:NO];
    }
    
    [self buildURL];
    
    self.request.requestParams = self.params;
    
    if (self.httpMethod == HTTPMethodPost || self.httpMethod == HTTPMethodForm) {
        if (self.httpMethod == HTTPMethodPost) {
            [self.request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
            self.request.requestMethod = @"POST";
            NSString *postBody = [self queryString];
            NSMutableData *postData = [[[NSMutableData alloc] initWithData:[postBody dataUsingEncoding:NSUTF8StringEncoding]] autorelease];
            [self.request setPostBody:postData];
        }
        else {
            NSString* contentType = [[[NSString alloc] initWithFormat:@"multipart/form-data; boundary=%@", TWITTERFON_FORM_BOUNDARY] autorelease];
            [self.request addRequestHeader:@"Content-Type" value:contentType];
            self.request.requestMethod = @"POST";

        }
    }
    
    if (self.authRequired) {
        _request.access_token=[OAuthTokenKey URLEncodedString];
        
    //    NSLog(@"access_token:%@",_request.access_token);
    }
    
    if (self.isSynchronized) {
        [_request startSynchronous];
    }
    else {
        [_request startAsynchronous];
    }
}

#pragma mark APIs

+ (BOOL)authorized
{
    if (UserID != nil) {
        return YES;
    }
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    

    
    int expire_time=[ud integerForKey:kUserDefaultKeyExpireTime];
    NSDate* date=[ud objectForKey:kUserDefaultKeyGetKeyDate];
   if ( [[date dateByAddingTimeInterval:expire_time] compare:[NSDate dateWithTimeIntervalSinceNow:0]]== NSOrderedDescending)
   {
    UserID=[ud stringForKey:@"weibo_ID"];
    OAuthTokenKey=[ud stringForKey:kUserDefaultKeyTokenResponseString];
   }
    return UserID != nil;
}

+ (void)signout
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:nil forKey:kUserDefaultKeyTokenResponseString];
    [ud setObject:nil forKey:kUserDefaultKeyExpireTime];
        [ud setObject:nil forKey:kUserDefaultKeyGetKeyDate];
        [ud setObject:nil forKey:@"weibo_ID"];

    [ud synchronize];
    
    OAuthTokenKey = nil;

    UserID = nil;
}

+ (NSString *)currentUserID
{
    return UserID;
}

- (void)authorize:(NSArray *)permissions
         delegate:(id<WBSessionDelegate>)delegate {
    
    _sessionDelegate = delegate;
    [self authorizeWithRRAppAuth:YES safariAuth:YES]; 
}



- (void)authorizeWithRRAppAuth:(BOOL)tryRRAppAuth
                    safariAuth:(BOOL)trySafariAuth {
    
    
    NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];

    NSHTTPCookie *cookieB; 
    for (cookieB in [cookies cookies]) { 
        [cookies deleteCookie:cookieB]; 
    }  
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   AppKey,@"client_id",
                                   @"http://oauth://SocialFusion.com", @"redirect_uri",
                                   @"mobile", @"display",
                                   @"token",@"response_type",
                                   nil];
    
    
    
    WBWebDialogViewController *rrDialog = [[WBWebDialogViewController alloc] initWithURL:AuthorizeURL2 params:params delegate:self];
    [rrDialog show];
    
}





- (void)wbDialogLogin:(NSString *)token {
    [_sessionDelegate wbDidLogin];
}



- (void)authWithUsername:(NSString *)username password:(NSString *)password autosave:(BOOL)autosave
{
    self.path = @"oauth/access_token";
    self.httpMethod = HTTPMethodPost;
    
    [self.params setObject:username forKey:@"x_auth_username"];
    [self.params setObject:password forKey:@"x_auth_password"];
    [self.params setObject:@"client_auth" forKey:@"x_auth_mode"];
    
    self.request.extraOAuthParams = self.params;
    
    [self setPreCompletionBlock:^(WeiboClient *client) {
        if (!client.hasError) {
            NSString *responseString = client.request.responseString;
            
            if (UserID) {
                if (autosave) {
                    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                    [ud setObject:responseString
                           forKey:kUserDefaultKeyTokenResponseString];
                    [ud synchronize];
                }
            }
            else {
                client.hasError = YES;
                client.errorDesc = NSLocalizedString(@"ERROR_AUTH_FAILED", nil);
            }
        }
    }];
    
    [self sendRequest];
}

- (void)getCommentsAndRepostsCountForStatusesDict:(NSArray *)statusesDict
{
    NSMutableArray *statusIDArray = [NSMutableArray arrayWithCapacity:[statusesDict count]];
    for (NSDictionary *statusDict in statusesDict) {
        NSString *statusID = [statusDict objectForKey:@"id"];
        [statusIDArray addObject:statusID];
    }
    
    [self setPreCompletionBlock:^(WeiboClient *client) {
        if (!client.hasError) {
            NSArray *countsArray = client.responseJSONObject;
            NSMutableArray *resultStatusesDict = [NSMutableArray arrayWithCapacity:[countsArray count]];
            
            for (NSDictionary *countsDict in countsArray) {
                
                NSString *statusID = [[countsDict objectForKey:@"id"] stringValue];
                NSDictionary *originalStatusDict = nil;
                
                for (NSDictionary *statusDict in statusesDict) {
                    if ([[[statusDict objectForKey:@"id"] stringValue] isEqualToString:statusID]) {
                        originalStatusDict = statusDict;
                        break;
                    }
                }
                
                NSMutableDictionary *resultStatusDict = [NSMutableDictionary dictionaryWithDictionary:originalStatusDict];
                
                NSString *commentsCount = [[countsDict objectForKey:@"comments"] stringValue];
                [resultStatusDict setObject:commentsCount forKey:@"comment_count"];
                
                NSString *repostsCount = [[countsDict objectForKey:@"rt"] stringValue];
                [resultStatusDict setObject:repostsCount forKey:@"repost_count"];
                
                [resultStatusesDict addObject:resultStatusDict];
            }
            
            client.responseJSONObject = resultStatusesDict;
        }
    }];
    
    [self getCommentsAndRepostsCount:statusIDArray];
    
}

- (void)getFriendsTimelineSinceID:(NSString *)sinceID 
                            maxID:(NSString *)maxID 
                   startingAtPage:(int)page 
                            count:(int)count
                          feature:(int)feature
{
    self.path = @"statuses/friends_timeline.json";
    
    if (sinceID) {
        [self.params setObject:sinceID forKey:@"since_id"];
    }
    if (maxID) {
        [self.params setObject:maxID forKey:@"max_id"];
    }
    if (page > 0) {
        [self.params setObject:[NSString stringWithFormat:@"%d", page] forKey:@"page"];
    }
    if (count > 0) {
        [self.params setObject:[NSString stringWithFormat:@"%d", count] forKey:@"count"];
    }
    if (feature > 0) {
        [self.params setObject:[NSString stringWithFormat:@"%d", feature] forKey:@"feature"];
    }
    
    [self setPreCompletionBlock:^(WeiboClient *client1) {
        if (!client1.hasError) {            
            NSDictionary *statusesDict = client1.responseJSONObject;
           
            if (statusesDict) {
                WeiboClient *client2 = [WeiboClient client];
                [client2 setCompletionBlock:client1.completionBlock];
                [client1 setCompletionBlock:NULL];
                [client2 getCommentsAndRepostsCountForStatusesDict:[statusesDict objectForKey:@"statuses"]];
            }
        }
    }];
    
    [self sendRequest];
}

- (void)getUserTimeline:(NSString *)userID 
                SinceID:(NSString *)sinceID 
                  maxID:(NSString *)maxID 
         startingAtPage:(int)page 
                  count:(int)count
                feature:(int)feature
{
    self.path = @"statuses/user_timeline.json";
    [self.params setObject:userID forKey:@"uid"];
    
    if (sinceID) {
        [self.params setObject:sinceID forKey:@"since_id"];
    }
    if (maxID) {
        [self.params setObject:maxID forKey:@"max_id"];
    }
    if (page > 0) {
        [self.params setObject:[NSString stringWithFormat:@"%d", page] forKey:@"page"];
    }
    if (count > 0) {
        [self.params setObject:[NSString stringWithFormat:@"%d", count] forKey:@"count"];
    }
    if (feature > 0) {
        [self.params setObject:[NSString stringWithFormat:@"%d", feature] forKey:@"feature"];
    }
    
    [self setPreCompletionBlock:^(WeiboClient *client1) {
        if (!client1.hasError) {
            NSDictionary *statusesDict = client1.responseJSONObject;
            if ([statusesDict count]) {
                WeiboClient *client2 = [WeiboClient client];
                [client2 setCompletionBlock:client1.completionBlock];
                [client1 setCompletionBlock:NULL];
                [client2 getCommentsAndRepostsCountForStatusesDict:[statusesDict objectForKey:@"statuses"]];
            }
        }
    }];
    
    [self sendRequest];
}

- (void)getCommentsOfStatus:(NSString *)statusID
                       page:(int)page
                      count:(int)count
{
    self.path = @"comments/show.json";
    [self.params setObject:statusID forKey:@"id"];
    if (page) {
        [self.params setObject:[NSString stringWithFormat:@"%d", page] forKey:@"page"];
    }
    if (count) {
        [self.params setObject:[NSString stringWithFormat:@"%d", count] forKey:@"count"];
    }
    [self sendRequest];
}

- (void)getCommentsToMeSinceID:(NSString *)sinceID 
                         maxID:(NSString *)maxID 
                          page:(int)page 
                         count:(int)count
{
    self.path = @"statuses/comments_to_me.json";
    if (sinceID) {
        [self.params setObject:sinceID forKey:@"since_id"];
    }
    if (maxID) {
        [self.params setObject:maxID forKey:@"max_id"];
    }
    if (page) {
        [self.params setObject:[NSString stringWithFormat:@"%d", page] forKey:@"page"];
    }
    if (count) {
        [self.params setObject:[NSString stringWithFormat:@"%d", count] forKey:@"count"];
    }
    [self sendRequest];
}

- (void)getCommentsAndRepostsCount:(NSArray *)statusIDs
{
    self.path = @"statuses/counts.json";
    NSString *ids = [statusIDs componentsJoinedByString:@","];
    [self.params setObject:ids forKey:@"ids"];
    [self sendRequest];
    
}

- (void)getUser:(NSString *)userID
{
    self.path = @"users/show.json";
    [self.params setObject:userID forKey:@"uid"];
    [self sendRequest];
}

                  
- (void)getUserWithName:(NSString *)name
{
    self.path = @"users/show.json";
    [self.params setObject:name forKey:@"screen_name"];
    [self sendRequest];
}

                  
                  
- (void)getFriendsOfUser:(NSString *)userID cursor:(int)cursor count:(int)count
{
    self.path = @"friendships/friends.json";
    [self.params setObject:userID forKey:@"uid"];
    [self.params setObject:[NSString stringWithFormat:@"%d", cursor] forKey:@"cursor"];
    if (count) {
        [self.params setObject:[NSString stringWithFormat:@"%d", count] forKey:@"count"];
    }
    [self sendRequest];
}

- (void)getFollowersOfUser:(NSString *)userID cursor:(int)cursor count:(int)count
{
    self.path = @"friendships/followers.json";
    [self.params setObject:userID forKey:@"uid"];
    [self.params setObject:[NSString stringWithFormat:@"%d", cursor] forKey:@"cursor"];
    if (count) {
        [self.params setObject:[NSString stringWithFormat:@"%d", count] forKey:@"count"];
    }
    [self sendRequest];
}

- (void)follow:(NSString *)userID
{
    self.httpMethod = HTTPMethodPost;
    self.path = @"friendships/create.json";
    [self.params setObject:userID forKey:@"uid"];
    [self sendRequest];
}

- (void)unfollow:(NSString *)userID
{
    self.httpMethod = HTTPMethodPost;
    self.path = @"friendships/destroy.json";
    [self.params setObject:userID forKey:@"uid"];
    [self sendRequest];
}

- (void)favorite:(NSString *)statusID
{
    self.httpMethod = HTTPMethodPost;
    self.path = @"favorites/create.json";
    [self.params setObject:statusID forKey:@"id"];
    [self sendRequest];
}

- (void)unFavorite:(NSString *)statusID
{
    self.httpMethod = HTTPMethodPost;
    self.path = [NSString stringWithFormat:@"favorites/destroy/%@.json", statusID];
    [self sendRequest];
}

- (void)postStatus:(NSString *)status latitude:(float)lat longitude:(float)lon
{
    self.httpMethod = HTTPMethodPost;
    status=[status renren2weibo];
    self.path = @"statuses/update.json";
    [self.params setObject:status  forKey:@"status"];
    if (lat<180)
    {
        [self.params setObject:[NSString stringWithFormat:@"%f",lat] forKey:@"lat"];
        [self.params setObject:[NSString stringWithFormat:@"%f",lon] forKey:@"long"];
    }
    [self sendRequest];
}

- (void)postStatus:(NSString *)status 
{
    [self postStatus:status latitude:360.0f longitude:0.0f];
}



- (NSString*)nameValString: (NSDictionary*) dict {
    NSArray* keys = [dict allKeys];
    NSString* result = [NSString string];
    int i;
    for (i = 0; i < [keys count]; i++) {
        result = [result stringByAppendingString:
                  [@"--" stringByAppendingString:
                   [TWITTERFON_FORM_BOUNDARY stringByAppendingString:
                    [@"\r\nContent-Disposition: form-data; name=\"" stringByAppendingString:
                     [[keys objectAtIndex: i] stringByAppendingString:
                      [@"\"\r\n\r\n" stringByAppendingString:
                       [[dict valueForKey: [keys objectAtIndex: i]] stringByAppendingString: @"\r\n"]]]]]]];
    }
    result = [result stringByAppendingString:
              [@"--" stringByAppendingString:
               [TWITTERFON_FORM_BOUNDARY stringByAppendingString:
                [@"\r\nContent-Disposition: form-data; name=\"" stringByAppendingString:
                 [@"access_token" stringByAppendingString:
                  [@"\"\r\n\r\n" stringByAppendingString:
                   [OAuthTokenKey stringByAppendingString: @"\r\n"]]]]]]];

    return result;
}

- (NSString *)_encodeString:(NSString *)string
{
    NSString *result = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, 
                                                                           (CFStringRef)string, 
                                                                           NULL, 
                                                                           (CFStringRef)@";/?:@&=$+{}<>,",
                                                                           kCFStringEncodingUTF8);
    return [result autorelease];
}

- (NSString *)_queryStringWithBase:(NSString *)base parameters:(NSDictionary *)params prefixed:(BOOL)prefixed
{
    // Append base if specified.
    NSMutableString *str = [NSMutableString stringWithCapacity:0];
    if (base) {
        [str appendString:base];
    }
    
    // Append each name-value pair.
    if (params) {
        int i;
        NSArray *names = [params allKeys];
        for (i = 0; i < [names count]; i++) {
            if (i == 0 && prefixed) {
                [str appendString:@"?"];
            } else if (i > 0) {
                [str appendString:@"&"];
            }
            NSString *name = [names objectAtIndex:i];
            [str appendString:[NSString stringWithFormat:@"%@=%@", 
                               name, [self _encodeString:[params objectForKey:name]]]];
        }
    }
    
    return str;                   
}

- (NSString *)getURL:(NSString *)path queryParameters:(NSMutableDictionary*)params {
    NSString* fullPath = [NSString stringWithFormat:@"%@://%@/%@", 
                          (_secureConnection) ? @"https" : @"http",
                          APIDomain, path];
    if (params) {
        fullPath = [self _queryStringWithBase:fullPath parameters:params prefixed:YES];
    }
    return fullPath;
}



- (void)postStatus:(NSString *)status withImage:(UIImage *)image latitude:(float)lat longitude:(float)lon
{
    if (status==nil)
    {
        status=[NSString stringWithString:@"分享图片"];
    }
    self.path = @"statuses/upload.json";
    self.httpMethod = HTTPMethodForm;
    status=[status renren2weibo];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
    NSDictionary* dic;
    if (lat<180)
    {
     dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         status, @"status",
                         AppKey, @"source",
                        [NSString stringWithFormat:@"%f",lat], @"lat",
                         [NSString stringWithFormat:@"%f",lon],@"long",
                         nil];
    }
    else
    {
        dic = [NSDictionary dictionaryWithObjectsAndKeys:
               status, @"status",
               AppKey, @"source",
               nil];  
    }
    NSString *param = [self nameValString:dic];
    
    NSString *footer = [NSString stringWithFormat:@"\r\n--%@--\r\n", TWITTERFON_FORM_BOUNDARY];
    
    param = [param stringByAppendingString:[NSString stringWithFormat:@"--%@\r\n", TWITTERFON_FORM_BOUNDARY]];
    param = [param stringByAppendingString:@"Content-Disposition: form-data; name=\"pic\";filename=\"image.jpg\"\r\nContent-Type: image/jpeg\r\nContent-Transfer-Encoding: binary\r\n\r\n"];
    
    NSMutableData *data = [NSMutableData data];
    [data appendData:[param dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:imageData];
    
    [data appendData:[footer dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self.request setPostBody:data];
    
    // NSLog(@"data:%@",data);
    [self sendRequest];
}


- (void)postStatus:(NSString *)status withImage:(UIImage *)image;
{
    [self postStatus:status withImage:image latitude:360 longitude:0];
}

- (void)repost:(NSString *)statusID 
          text:(NSString *)text 
 commentStatus:(BOOL)commentStatus 
 commentOrigin:(BOOL)commentOrigin
{
    self.path = @"statuses/repost.json";
    self.httpMethod = HTTPMethodPost;
    [self.params setObject:statusID forKey:@"id"];
    [self.params setObject:text forKey:@"status"];
    text=[text renren2weibo]; 
    int value = 0;
    if (commentStatus) {
        value += 1;
    }
    if (commentOrigin) {
        value += 2;
    }
    
    [self.params setObject:[NSString stringWithFormat:@"%d", value] forKey:@"is_comment"];
    [self sendRequest];
}

- (void)comment:(NSString *)statusID 
            cid:(NSString *)cid 
           text:(NSString *)text
  commentOrigin:(BOOL)commentOrigin
{
    self.httpMethod = HTTPMethodPost;
    if (cid==nil)
    {
          self.path =@"comments/create.json";
    }
    else
    {
    self.path = @"comments/reply.json";
    }
    if (statusID) {
        [self.params setObject:statusID forKey:@"id"];
    }
    if (cid) {
        [self.params setObject:cid forKey:@"cid"];
    }
    [self.params setObject:text forKey:@"comment"];
    if (commentOrigin) {
        [self.params setObject:@"1" forKey:@"comment_ori"];
    }
    [self sendRequest];
}

- (void)destroyStatus:(NSString *)statusID
{
    self.httpMethod = HTTPMethodPost;
    self.path = [NSString stringWithFormat:@"statuses/destroy/%@.json", statusID];
    [self sendRequest];
}

- (void)getFavoritesByPage:(int)page
{
    self.path = [NSString stringWithFormat:@"favorites.json"];
    if (page > 0) {
        [self.params setObject:[NSString stringWithFormat:@"%d", page] forKey:@"page"];
    }
    
    [self setPreCompletionBlock:^(WeiboClient *client1) {
        if (!client1.hasError) {            
            NSArray *statusesDict = client1.responseJSONObject;
            if ([statusesDict count]) {
                WeiboClient *client2 = [WeiboClient client];
                [client2 setCompletionBlock:client1.completionBlock];
                [client1 setCompletionBlock:NULL];
                [client2 getCommentsAndRepostsCountForStatusesDict:statusesDict];
            };
        }
    }];
    
    [self sendRequest];
}

- (void)getRelationshipWithUser:(NSString *)userID
{
    self.path = @"friendships/show.json";
    [self.params setObject:userID forKey:@"target_id"];
    [self sendRequest];
}

- (void)getUnreadCountSinceStatusID:(NSString *)statusID
{
    self.path = @"statuses/unread.json";
    if (statusID) {
        [self.params setObject:@"1" forKey:@"with_new_status"];
        [self.params setObject:statusID forKey:@"since_id"];
    }
    [self sendRequest];
}

- (void)resetUnreadCount:(int)type
{
    self.path = @"statuses/reset_count.json";
    self.httpMethod = HTTPMethodPost;
    [self.params setObject:[NSString stringWithFormat:@"%d", type] forKey:@"type"];
    [self sendRequest];
}

@end

