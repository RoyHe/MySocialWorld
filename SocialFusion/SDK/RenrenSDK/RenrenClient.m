//
//  RenrenClient.m
//  SocialFusion
//
//  Created by 王紫川 on 11-9-9.
//  Copyright 2011年 Tongji Apple Club. All rights reserved.
//

#import "RenrenClient.h"
#import <CommonCrypto/CommonDigest.h>
#import "ROPasswordFlowRequestParam.h"
#import "ROPublishPhotoRequestParam.h"
#include "ROUtility.h"
#import "NSString+WeiboAndRenrenFactialExpression.h"

static NSString* kAuthBaseURL = @"http://graph.renren.com/oauth/authorize";
//static NSString* kDialogBaseURL = @"http://widget.renren.com/dialog/";
static NSString* kRestserverBaseURL = @"http://api.renren.com/restserver.do";
static NSString* kRRSessionKeyURL=@"http://graph.renren.com/renren_api/session_key";
static NSString* kRRSuccessURL=@"http://widget.renren.com/callback.html";
static NSString* kSDKversion=@"1.0";

static NSString* const AppID = @"150399";
static NSString* const AppKey = @"02f195588a7645db8f1862d989020d88";

//static NSString* UserID = nil;

@interface RenrenClient(Private)
- (void)authorizeWithRRAppAuth:(BOOL)tryRRAppAuth safariAuth:(BOOL)trySafariAuth permissions:(NSArray *)pm;
- (void)reportCompletion;
+ (void)delUserSessionInfo;
@end

@implementation RenrenClient

@synthesize accessToken = _accessToken,
expirationDate = _expirationDate,
secret = _secret,
sessionKey = _sessionKey,
responseJSONObject = _responseJSONObject,
hasError = _hasError;

- (void)dealloc {
    //NSLog(@"RenrenClient dealloc");
    [_sessionKey release];
    [_secret release];
    [_accessToken release];
    [_expirationDate release];
    [_request release];
    [_responseJSONObject release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	
        self.accessToken = [defaults objectForKey:@"access_Token"];
        self.expirationDate = [defaults objectForKey:@"expiration_Date"];
        self.sessionKey = [defaults objectForKey:@"session_Key"];
        self.secret = [defaults objectForKey:@"secret_Key"];
    }
    
    return self;
}

- (void)setCompletionBlock:(void (^)(RenrenClient* client))completionBlock {
    [_completionBlock release];
    _completionBlock = [completionBlock copy];
}

- (RRCompletionBlock)completionBlock {
    return _completionBlock;
}

// 类方法 判断是否已经授权
+ (BOOL)authorized
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *accessToken = [defaults objectForKey:@"access_Token"];
    NSDate *expirationDate = [defaults objectForKey:@"expiration_Date"];
    NSString *sessionKey = [defaults objectForKey:@"session_Key"];
    return (accessToken != nil && expirationDate != nil && sessionKey != nil
			&& NSOrderedDescending == [expirationDate compare:[NSDate date]]);
}

+ (id)client {
    //autorelease intentially ommited here
    return [[RenrenClient alloc] init];
}

+ (void)signout {
    [RenrenClient delUserSessionInfo];
}

// please modify your permissions here
- (void)authorize {
    if (![RenrenClient authorized]) {
        NSArray *permissions = [NSArray arrayWithObjects:@"read_user_feed photo_upload publish_feed status_update operate_like read_user_status read_user_status read_user_photo read_user_blog read_user_comment read_user_share read_user_album  publish_share publish_comment publish_blog",nil];
        [self authorizeWithRRAppAuth:YES safariAuth:YES permissions:permissions]; 
    }
}

#pragma mark - 
#pragma mark Authorize methods

- (void)authorizeWithRRAppAuth:(BOOL)tryRRAppAuth safariAuth:(BOOL)trySafariAuth permissions:(NSArray *)permissions {
    
    NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	NSArray* graphCookies = [cookies cookiesForURL:
                             [NSURL URLWithString:@"http://graph.renren.com"]];
	
	for (NSHTTPCookie* cookie in graphCookies) {
		[cookies deleteCookie:cookie];
	}
	NSArray* widgetCookies = [cookies cookiesForURL:[NSURL URLWithString:@"http://widget.renren.com"]];
	
	for (NSHTTPCookie* cookie in widgetCookies) {
		[cookies deleteCookie:cookie];
	}
    
    if(![RenrenClient authorized]) {
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       AppKey, @"client_id",
                                       @"token", @"response_type",
                                       kRRSuccessURL, @"redirect_uri",
                                       @"touch", @"display",
                                       nil];
        if (permissions != nil) {
            NSString* scope = [permissions componentsJoinedByString:@","];
            [params setValue:scope forKey:@"scope"];
        }
        
        ROWebDialogViewController *viewController = [[ROWebDialogViewController alloc] init];
        viewController.params = params;
        viewController.delegate = self;
        viewController.serverURL = kAuthBaseURL;
        
        [viewController show];
    }
}

#pragma mark - 
#pragma mark Utility methods

+ (NSString *)getSecretKeyByToken:(NSString *) token{
	NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								   token, @"oauth_token",
								   nil];
	NSString *getKeyUrl = [RORequest serializeURL:kRRSessionKeyURL params:params];
    id result = [RORequest getRequestSessionKeyWithParams:getKeyUrl];
	if ([result isKindOfClass:[NSDictionary class]]) {
		NSString *secretkey=[[result objectForKey:@"renren_token"] objectForKey:@"session_secret"];
		return secretkey;
	}
	return nil;
}


+ (NSString *)getSessionKeyByToken:(NSString *) token{
	NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								   token, @"oauth_token",
								   nil];
	NSString *getKeyUrl = [RORequest serializeURL:kRRSessionKeyURL params:params];
    id result = [RORequest getRequestSessionKeyWithParams:getKeyUrl];
	if ([result isKindOfClass:[NSDictionary class]]) {
		NSString* sessionkey=[[result objectForKey:@"renren_token"] objectForKey:@"session_key"];
		return sessionkey;
	}
	return nil;
}

/**
 * 保存用户用oauth登录后的信息
 */
- (void)saveUserSessionInfo{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];	
    if (self.accessToken) {
        [defaults setObject:self.accessToken forKey:@"access_Token"];
    }
	if (self.expirationDate) {
		[defaults setObject:self.expirationDate forKey:@"expiration_Date"];
	}	
    if (self.sessionKey) {
        [defaults setObject:self.sessionKey forKey:@"session_Key"];
        [defaults setObject:self.secret forKey:@"secret_Key"];
    }
    [defaults synchronize];	
}

/**
 * 删除本地保存的用户 oauth信息 
 */
+ (void)delUserSessionInfo {
	NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"access_Token"];
	[defaults removeObjectForKey:@"secret_Key"];
	[defaults removeObjectForKey:@"session_Key"];
	[defaults removeObjectForKey:@"expiration_Date"];
	NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	NSArray* graphCookies = [cookies cookiesForURL:
                             [NSURL URLWithString:@"http://graph.renren.com"]];
	
	for (NSHTTPCookie* cookie in graphCookies) {
		[cookies deleteCookie:cookie];
	}
	NSArray* widgetCookies = [cookies cookiesForURL:
                              [NSURL URLWithString:@"http://widget.renren.com"]];
	
	for (NSHTTPCookie* cookie in widgetCookies) {
		[cookies deleteCookie:cookie];
	}
	[defaults synchronize];
}

#pragma mark - RODialogDelegate Methods -

- (void)authDialog:(id)dialog withOperateType:(RODialogOperateType )operateType{
    if (![dialog isKindOfClass:[ROWebDialogViewController class]])
        return;
    
    ROWebDialogViewController *viewController = (ROWebDialogViewController *)dialog;
    ROResponse *response = viewController.response;
    NSDictionary* authDictionary = nil;
    
    switch (operateType) {
        case RODialogOperateSuccess:
            authDictionary = response.rootObject;
            NSString* token = [authDictionary objectForKey:@"token"];
            NSDate* expirationDate = [authDictionary objectForKey:@"expirationDate"];
            self.accessToken = token;
            self.expirationDate = expirationDate;
            self.secret = [RenrenClient getSecretKeyByToken:token];
            self.sessionKey = [RenrenClient getSessionKeyByToken:token];	
            //用户信息保存到本地
            [self saveUserSessionInfo];
            [self reportCompletion];
            break;
        case RODialogOperateFailure:
            _hasError = YES;
            [self reportCompletion];
            break;
        default:
            break;
    }
}

#pragma mark request

// 新的接口。
- (void)sendRequestWithUrl:(NSString *)url param:(RORequestParam *)param httpMethod:(NSString *)httpMethod delegate:(id<RORequestDelegate>)delegate{
    
    delegate = delegate?delegate:self;
    _request = [[RORequest getRequestWithParam:param httpMethod:httpMethod delegate:delegate requestURL:url] retain];
    [_request connect];
    return;
}

// 旧的接口。
- (RORequest*)openUrl:(NSString *)url
               params:(NSMutableDictionary *)params
           httpMethod:(NSString *)httpMethod
             delegate:(id<RORequestDelegate>)delegate {
    
    [_request release];
    _request = [[RORequest getRequestWithParams:params
                                     httpMethod:httpMethod
                                       delegate:delegate
                                     requestURL:url] retain];
    [_request connect];
    return _request;
}

#pragma mark - Util Methods -
- (void)setGeneralRequestArgs: (RORequestParam *)inRequestParam{
    // 这里假设此前已经调用[self isSessionValid],并且返回Ture。
    inRequestParam.sessionKey = self.sessionKey;
    inRequestParam.apiKey = AppKey;
    inRequestParam.callID = [ROUtility generateCallId];
    inRequestParam.xn_ss = @"1";
    inRequestParam.format = @"json";
    inRequestParam.apiVersion = kSDKversion;
	
    inRequestParam.sig = [ROUtility generateSig:[inRequestParam requestParamToDictionary] secretKey:self.secret]; 
}

- (NSDictionary*)parseURLParams:(NSString *)query {
	NSArray *pairs = [query componentsSeparatedByString:@"&"];
	NSMutableDictionary *params = [[[NSMutableDictionary alloc] init] autorelease];
	for (NSString *pair in pairs) {
		NSArray *kv = [pair componentsSeparatedByString:@"="];
		NSString *val =[[kv objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		[params setObject:val forKey:[kv objectAtIndex:0]];
	}
    return params;
}

- (NSString*)md5HexDigest:(NSString*)input {
	const char* str = [input UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5(str, strlen(str), result);
	
	return [NSString stringWithFormat:
			@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
			result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
			];
}

- (NSString*)generateSig:(NSMutableDictionary*)_params {
	NSMutableString* joined = [NSMutableString string]; 
	NSArray* keys = [_params.allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	for (id obj in [keys objectEnumerator]) {
		id value = [_params valueForKey:obj];
		if ([value isKindOfClass:[NSString class]]) {
			[joined appendString:obj];
			[joined appendString:@"="];
			[joined appendString:value];
		}
	}
	[joined appendString:self.secret];
	return [self md5HexDigest:joined];
}

- (NSString*)generateCallId {
	return [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
}

- (RORequest *)requestWithParams:(NSMutableDictionary *)params
                     andDelegate:(id <RORequestDelegate>)delegate {
    
    if ([params objectForKey:@"method"] == nil) {
       // NSLog(@"API Method must be specified");
        return nil;
    }
	if ([RenrenClient authorized]) {
		[params setObject:self.sessionKey forKey:@"session_key"];
    } else {
		[RenrenClient delUserSessionInfo];
	//	NSLog(@"session not valid");
		return nil;
	}
	
	[params setObject:[self generateCallId] forKey:@"call_id"];//增加键与值
	[params setObject:AppKey forKey:@"api_key"];	
	[params setObject:kSDKversion forKey:@"v"];
	[params setObject:@"json" forKey:@"format"];
	[params setObject:@"1" forKey:@"xn_ss"];
	
	NSString *sig=[self generateSig:params];
	[params setObject:sig forKey:@"sig"];
    
    return [self openUrl:kRestserverBaseURL
				  params:params
			  httpMethod:@"POST"
				delegate:delegate];	
}

- (void)requestWithParam:(RORequestParam *)param andDelegate:(id <RORequestDelegate>)delegate {
    if (nil == param.method || [param.method length] <= 0) {
    //    NSLog(@"API Method must be specified");
        return;
    }
    
    if (![RenrenClient authorized]) {
     //   NSLog(@"Session is not valid! Request abort!!");
        return;
    }
    
    [self setGeneralRequestArgs:param];
    
    [self sendRequestWithUrl:kRestserverBaseURL param:param httpMethod:@"POST" delegate:delegate];
	
    return;
}

//回调
- (void)reportCompletion
{
    /*if (_preCompletionBlock) {
     _preCompletionBlock(self);
     }*/
    //NSLog(@"block retain count:%d", [_completionBlock retainCount]);
    if (_completionBlock) {
        _completionBlock(self);
    }
}

#pragma mark -
#pragma mark RORequestDelegate

- (void)request:(RORequest *)request didLoad:(id)result {
	//NSLog(@"数据请求成功 解析数据");
	self.responseJSONObject = result;
    [self reportCompletion];
    [self autorelease];
}

- (void)request:(RORequest *)request didFailWithError:(NSError *)error {
//	NSLog(@"renren request fail with error:%@",[error localizedDescription]);
    _hasError = YES;
    [self reportCompletion];
    [self autorelease];
}

- (void)request:(RORequest *)request didFailWithROError:(ROError *)error{
	//password flow授权错误的处理
	if([request.requestParamObject isKindOfClass:[ROPasswordFlowRequestParam class]]) {
        // 默认错误处理。
      //  NSString *title = [NSString stringWithFormat:@"Error code:%d", [error code]];
       // NSString *description = [NSString stringWithFormat:@"%@", [error localizedDescription]];
       // NSLog(@"renren request error:%@, %@", title, description);
	}
    
    else {
        // 默认错误处理。
    //    NSString *title = [NSString stringWithFormat:@"Error code:%d", [error code]];
     //   NSString *description = [NSString stringWithFormat:@"%@", [error localizedDescription]];
      //  NSLog(@"renren request error:%@, %@", title, description);
    }
    _hasError = YES;
    [self reportCompletion];
    [self autorelease];
}

#pragma mark -
#pragma mark Public methods

//请求好友信息列表
- (void)getFriendsProfile {
    NSMutableDictionary *params=[NSMutableDictionary dictionaryWithObjectsAndKeys:
								 @"friends.getFriends",@"method",
                                 @"7000", @"count",
								 nil];
	[self requestWithParams:params andDelegate:self];
}

//请求好友ID列表
- (void)getFriendsID {
    NSMutableDictionary *params=[NSMutableDictionary dictionaryWithObjectsAndKeys:
								 @"friends.get",@"method",
                                 @"7000", @"count",
								 nil];
	[self requestWithParams:params andDelegate:self];
}

//请求用户信息
- (void)getUserInfo {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"users.getInfo", @"method",
                                   @"uid,name,sex,birthday,email_hash,tinyurl,headurl,mainurl,hometown_location,work_history,hs_history,university_history", @"fields", nil];
    [self requestWithParams:params andDelegate:self];
}

//请求用户信息
- (void)getUserInfoWithUserID:(NSString *)uid {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"users.getInfo", @"method",
                                   @"uid,name,sex,birthday,email_hash,tinyurl,headurl,mainurl,hometown_location,work_history,hs_history,university_history", @"fields", 
                                   uid, @"uids", nil];
    [self requestWithParams:params andDelegate:self];
}

//请求最近的一条状态
- (void)getLatestStatus:(NSString *)userID {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"status.get", @"method",
                                   userID, @"owner_id",
                                   nil];
	[self requestWithParams:params andDelegate:self];
}

- (void)getNewFeed:(int)pageNumber
{
    NSString* tempString = [[NSString alloc] initWithFormat:@"%d",pageNumber];
    NSMutableDictionary *params=[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 @"feed.get",@"method",
                                 @"10,20,21,30,32,33",@"type",
                                 tempString,@"page",
                                 @"30",@"count",
                                 nil];
    [tempString release];
	[self requestWithParams:params andDelegate:self];
}

- (void)getNewFeed:(int)pageNumber  uid:(NSString*)id
{
    NSString* tempString=[[NSString alloc] initWithFormat:@"%d",pageNumber];
    NSMutableDictionary *params=[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 @"feed.get",@"method",
                                 @"10,20,21,30,32,33",@"type",
                                 id,@"uid",
                                 tempString,@"page",
                                 @"30",@"count",
                                 nil];
    [tempString release];
	[self requestWithParams:params andDelegate:self];
}


- (void)getComments:(NSString*)userID status_ID:(NSString*)status pageNumber:(int)pageNumber
{
    
    NSString* tempString=[[NSString alloc] initWithFormat:@"%d",pageNumber];
    NSMutableDictionary *params=[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 @"status.getComment",@"method",
                                 status,@"status_id",
                                 userID,@"owner_id",
                                 tempString,@"page",
                                 @"0",@"order",
                                 nil];
    [tempString release];
	[self requestWithParams:params andDelegate:self];
}

- (void)getBlogComments:(NSString*)userID status_ID:(NSString*)status pageNumber:(int)pageNumber
{
    NSString* tempString=[[NSString alloc] initWithFormat:@"%d",pageNumber];
    NSMutableDictionary *params=[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 @"blog.getComments",@"method",
                                 status,@"id",
                                 userID,@"uid",
                                 tempString,@"page",
                                 @"1",@"order",
                                 nil];
    [tempString release];
	[self requestWithParams:params andDelegate:self];
}


- (void)getStatus:(NSString*)userID status_ID:(NSString*)status
{
    
    NSMutableDictionary *params=[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 @"status.get",@"method",
                                 status,@"status_id",
                                 userID,@"owner_id",
                                 nil];
  	[self requestWithParams:params andDelegate:self];
}


- (void)getSinglePhoto:(NSString*)userID photoID:(NSString*)photoID
{
    NSMutableDictionary *params=[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 @"photos.get",@"method",
                                 userID,@"uid",
                                 photoID,@"pids",
                                 nil];
  	[self requestWithParams:params andDelegate:self];
}

- (void)getBlog:(NSString*)userID status_ID:(NSString*)status
{
    NSMutableDictionary *params=[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 @"blog.get",@"method",
                                 status,@"id",
                                 userID,@"uid",
                                 nil];
  	[self requestWithParams:params andDelegate:self];
    
}

- (void)getShareComments:(NSString*)userID share_ID:(NSString*)share pageNumber:(int)pageNumber
{
    NSString* tempString=[[NSString alloc] initWithFormat:@"%d",pageNumber];
    NSMutableDictionary *params=[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 @"share.getComments",@"method",
                                 share,@"share_id",
                                 userID,@"user_id",
                                 tempString,@"page",
                                 @"1",@"order",
                                 nil];
    [tempString release];
	[self requestWithParams:params andDelegate:self];
}

- (void)postStatus:(NSString *)status {
    status=[status weibo2renren];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"status.set", @"method",
                                   status, @"status", nil];
    [self requestWithParams:params andDelegate:self];
    
}

- (void)postStatus:(NSString *)status withImage:(UIImage *)image {
    
    status=[status weibo2renren];
    ROPublishPhotoRequestParam *param = [[ROPublishPhotoRequestParam alloc] init];
    param.imageFile = image;
    param.caption = status;
    [self requestWithParam:param andDelegate:self];
    [param release];
}


- (void)getAlbum:(NSString*)userID a_ID:(NSString*)a_ID pageNumber:(int)pageNumber
{
    NSString* tempString=[[NSString alloc] initWithFormat:@"%d",pageNumber];
    NSMutableDictionary *params=[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 @"photos.get",@"method",
                                 userID,@"uid",
                                 a_ID,@"aid",
                                 tempString,@"page",
                                 @"9",@"count",
                                 nil];
    [tempString release];
	[self requestWithParams:params andDelegate:self];
}

- (void)getPhotoComments:(NSString*)userID photo_ID:(NSString*)p_ID pageNumber:(int)pageNumber
{
    NSString* tempString=[[NSString alloc] initWithFormat:@"%d",pageNumber];
    NSMutableDictionary *params=[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 @"photos.getComments", @"method",
                                 userID, @"uid",
                                 p_ID, @"pid",
                                 tempString, @"page",
                                 
                                 nil];
    [tempString release];
	[self requestWithParams:params andDelegate:self];
}

-(void)getAlbumInfo:(NSString*)userID a_ID:(NSString*)a_ID
{

    NSMutableDictionary *params=[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 @"photos.getAlbums", @"method",
                                 userID, @"uid",
                                 a_ID, @"aids",
                                 nil];

	[self requestWithParams:params andDelegate:self];
}

- (void)postMessage:(NSString *)msg guestBookOwnerID:(NSString *)uid useSecretWord:(BOOL)isSecret {

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"guestbook.post", @"method",
                                   uid, @"uid", 
                                   msg, @"content",
                                   [NSString stringWithFormat:@"%d", isSecret], @"type", nil];
	[self requestWithParams:params andDelegate:self];
}

- (void)getRelationshipWithUserID:(NSString *)uid1 andAnotherUserID:(NSString *)uid2 {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"friends.areFriends", @"method",
                                   uid1, @"uids1", 
                                   uid2, @"uids2", nil];
	[self requestWithParams:params andDelegate:self];
}


-(void)forwardStatus:(NSString*)user_ID statusID:(NSString*)status_ID andStatusString:(NSString*)status
{
    status=[status weibo2renren];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"status.forward", @"method",
                                   status, @"status", 
                                   status_ID, @"forward_id", 
                                   user_ID,@"forward_owner",nil];
	[self requestWithParams:params andDelegate:self];
}



-(void)share:(int)type  share_ID:(NSString*)share_ID  user_ID:(NSString*)user_ID comment:(NSString *)comment
{
    NSString* tempString=[[NSString alloc] initWithFormat:@"%d",type];
    comment=[comment weibo2renren];
   // NSLog(@"%@    %@    %@",tempString,share_ID,user_ID);
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"share.share", @"method",
                                   tempString,@"type",
                                   share_ID, @"ugc_id", 
                                   user_ID, @"user_id",
                                   comment,@"comment",
                                   nil];
	[self requestWithParams:params andDelegate:self];
    [tempString release];
}


- (void)comment:(NSString *)statusID
         userID:(NSString*)user_ID
           text:(NSString *)text
           toID:(NSString*)to_ID;
{
    
     text=[text weibo2renren];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"status.addComment", @"method",
                                   user_ID, @"owner_id", 
                                   statusID, @"status_id",
                                   text,@"content",
                                   to_ID,@"rid",
                                   nil];
	[self requestWithParams:params andDelegate:self];
}

-(void)commentBlog:(NSString*)blog_ID
               uid:(NSString*)u_ID
           content:(NSString*)content
              toID:(NSString*)to_ID
            secret:(int)secret
{
    
    content=[content weibo2renren];

    NSString* tempString=[[NSString alloc] initWithFormat:@"%d",secret];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"blog.addComment", @"method",
                                   blog_ID, @"id", 
                                   u_ID, @"uid",
                                   content,@"content",
                                   to_ID,@"rid",
                                   tempString,@"type",nil];
	[self requestWithParams:params andDelegate:self];
    [tempString release];
}


-(void)commentShare:(NSString*)share_id
                uid:(NSString*)u_ID
            content:(NSString*)content
               toID:(NSString*)to_ID
{
    
     content=[content weibo2renren];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"share.addComment", @"method",
                                   share_id, @"share_id", 
                                   u_ID, @"user_id",
                                   content,@"content",
                                   to_ID,@"to_user_id",
                                    nil];
	[self requestWithParams:params andDelegate:self];
}


-(void)postBlog:(NSString*)title  content:(NSString*)content;
{
    title=[title weibo2renren];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"blog.addBlog", @"method",
                                   title, @"title", 
                                   content,@"content",
                                   nil];
	[self requestWithParams:params andDelegate:self];
}
-(void)commentPhoto:(NSString*)share_id
                uid:(NSString*)u_ID
            content:(NSString*)content
               toID:(NSString*)to_ID;

{
    content=[content weibo2renren];

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"photos.addComment", @"method",
                                   share_id, @"pid", 
                                   u_ID, @"uid",
                                   content,@"content",
                                   to_ID,@"rid",
                                   nil];
	[self requestWithParams:params andDelegate:self];
}


@end
