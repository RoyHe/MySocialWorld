//
//  ROWebDialogViewController.m
//  RenrenSDKDemo
//
//  Created by xiawh on 11-11-11.
//  Copyright (c) 2011年 renren－inc. All rights reserved.
//


#import "WBWebDialogViewController.h"
#import "WeiboClient.h"

static CGFloat kPadding = 10;
static CGFloat kBorderWidth = 10;

static NSString* AccessURL = @"http://api.t.sina.com.cn/oauth/access_token" ;
static NSString* AccessOAUTH2URL=@"https://api.weibo.com/oauth2/access_token";
///////////////////////////////////////////////////////////////////////////////////////////////////


@interface WBWebDialogViewController(Private) 

- (BOOL)isAuthDialog;

- (void)dismissWithError:(NSError*)error animated:(BOOL)animated;

- (void)dialogDidSucceed:(NSURL *)url;

- (void)dialogDidCancel:(NSURL *)url;

@end

@implementation WBWebDialogViewController


@synthesize delegate = _delegate;


- (void)dealloc {
    _webView.delegate = nil;
    [_webView release];
    [_params release];
    [_serverURL release];
    [_spinner release];
    [_loadingURL release];
    [_modalBackgroundView release];
    [_indicatorView release];
  //  NSLog(@"WebDia dealloc");
    [super dealloc];
    
}

- (id)initWithURL: (NSString *) serverURL
           params: (NSMutableDictionary *) params
         delegate: (id <WBDialogDelegate>) delegate {
    
    self = [super init];
    _serverURL = [serverURL retain];
    _params = [params retain];
    _delegate = delegate;
    _webView = [[UIWebView alloc] initWithFrame:[self fitOrientationFrame]];
   _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _webView.delegate = self;

    [self.view addSubview:_webView];
    //        [self.webView release];
    
    _indicatorView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
    _indicatorView.hidesWhenStopped = YES;
    _indicatorView.center = _webView.center;
    [self.view addSubview:_indicatorView];
    return self;
}







- (NSURL*)generateURL:(NSString*)baseURL params:(NSDictionary*)params {
    if (params) {
        NSMutableArray* pairs = [NSMutableArray array];
        for (NSString* key in params.keyEnumerator) {
            NSString* value = [params objectForKey:key];
            NSString* escaped_value = (NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                          NULL, /* allocator */
                                                                                          (CFStringRef)value,
                                                                                          NULL, /* charactersToLeaveUnescaped */
                                                                                          (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                          kCFStringEncodingUTF8);
            
            [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, escaped_value]];
            [escaped_value release];
        }
        
        NSString* query = [pairs componentsJoinedByString:@"&"];
        NSString* url = [NSString stringWithFormat:@"%@?%@", baseURL, query];
        return [NSURL URLWithString:url];
    } else {
        return [NSURL URLWithString:baseURL];
    }
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
// UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType {
	
    NSURL* url = request.URL;

    NSString *q = [url absoluteString];
    
    NSLog(@"%@",q);
    //////
    NSString *accessToken = [self getStringFromUrl:q needle:@"access_token="];
    
    NSString* userID=[self getStringFromUrl:q needle:@"uid="];
    
    int time=[[self getStringFromUrl:q needle:@"expires_in="] intValue];
    
    
    if ([[url absoluteString] isEqualToString:@"http://service.weibo.com/reg/regindex.php?appsrc=1izgHh&backurl="])
    {
        [[UIApplication sharedApplication] openURL:url];
             return NO;
    }

    if (accessToken!=nil&&userID!=nil)
    {
        
        
        
     
        [WeiboClient setTokenWithString:accessToken andID:userID andTime:time];

        [_delegate wbDialogLogin:nil ];
        [self dismissWithSuccess:YES animated:YES];

    }
    
    /*
    
       
    */
    return YES;
}

- (void)dismiss:(BOOL)animated {
    [self close];
}



- (void)updateWebOrientation {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        [_webView stringByEvaluatingJavaScriptFromString:
         @"document.body.setAttribute('orientation', 90);"];
    } else {
        [_webView stringByEvaluatingJavaScriptFromString:
         @"document.body.removeAttribute('orientation');"];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [_spinner stopAnimating];
    _spinner.hidden = YES;
    [self updateWebOrientation];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    // 102 == WebKitErrorFrameLoadInterruptedByPolicyChange
    if (!([error.domain isEqualToString:@"WebKitErrorDomain"] && error.code == 102)) {
        [self dismissWithError:error animated:YES];
    }
}


/**
 * 
 * 解析 url 参数的function
 */
- (NSDictionary*)parseURLParams:(NSString *)query {
    //	NSArray *pairs = [query componentsSeparatedByString:@"&"];
	NSMutableDictionary *params = [[[NSMutableDictionary alloc] init] autorelease];
    //	for (NSString *pair in pairs) {
    //		NSArray *kv = [pair componentsSeparatedByString:@"="];
    //		NSString *val =
    //		[[kv objectAtIndex:1]
    //		 stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //		[params setObject:val forKey:[kv objectAtIndex:0]];
    //	}
	return params;
}

- (void) errormsg:(NSString*) errorReason{
	if (errorReason) {
		//NSLog(@"%@",errorReason);
	}
}



- (BOOL)shouldRotateToOrientation:(UIDeviceOrientation)orientation {
    if (orientation == _orientation) {
        return NO;
    } else {
        return orientation == UIDeviceOrientationLandscapeLeft
        || orientation == UIDeviceOrientationLandscapeRight
        || orientation == UIDeviceOrientationPortrait
        || orientation == UIDeviceOrientationPortraitUpsideDown;
    }
}



////////////
///////////////////////////////////////////////////////////////////////////////////////
// UIDeviceOrientationDidChangeNotification

- (void)deviceOrientationDidChange:(void*)object {
    UIDeviceOrientation orientation = (UIDeviceOrientation)[UIApplication sharedApplication].statusBarOrientation;
    if (!_showingKeyboard && [self shouldRotateToOrientation:orientation]) {
        [self updateWebOrientation];
        
        CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:duration];
        [self sizeToFitOrientation:YES];
        [UIView commitAnimations];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIKeyboardNotifications

- (void)keyboardWillShow:(NSNotification*)notification {
    
    _showingKeyboard = YES;
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        _webView.frame = CGRectInset(_webView.frame,
                                     - (kPadding + kBorderWidth),
                                     - (kPadding + kBorderWidth));
    }
}

- (void)keyboardWillHide:(NSNotification*)notification {
    _showingKeyboard = NO;
    
    //if (RRIsDeviceIPad()) {
    // return;
    // }
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        _webView.frame = CGRectInset(_webView.frame,
                                     kPadding + kBorderWidth,
                                     kPadding + kBorderWidth) ;
    }
}


-(void)show
{
    [super show];
      [self load];
}

- (NSString *) getStringFromUrl: (NSString*) url needle:(NSString *) needle {
    NSString * str = nil;
    NSRange start = [url rangeOfString:needle];
    if (start.location != NSNotFound) {
        NSRange end = [[url substringFromIndex:start.location+start.length] rangeOfString:@"&"];
        NSUInteger offset = start.location+start.length;
        str = end.location == NSNotFound
        ? [url substringFromIndex:offset]
        : [url substringWithRange:NSMakeRange(offset, end.location)];
        str = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    return str;
}





- (void)load {
    [self loadURL:_serverURL get:_params];
}

- (void)loadURL:(NSString*)url get:(NSDictionary*)getParams {
    [_loadingURL release];
    _loadingURL = [[self generateURL:url params:getParams] retain];	
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:_loadingURL];
    [_webView loadRequest:request];
}



- (void)dismissWithSuccess:(BOOL)success animated:(BOOL)animated {
    if (success) {
        if ([_delegate respondsToSelector:@selector(dialogDidComplete:)]) {
            [_delegate dialogDidComplete:self];
        }
    } else {
        if ([_delegate respondsToSelector:@selector(dialogDidNotComplete:)]) {
            [_delegate dialogDidNotComplete:self];
        }
    }
    
    [self dismiss:animated];
}

- (void)dismissWithError:(NSError*)error animated:(BOOL)animated {
    if ([_delegate respondsToSelector:@selector(dialog:didFailWithError:)]) {
        [_delegate dialog:self didFailWithError:error];
    }
    
    [self dismiss:animated];
}

- (void)dialogWillAppear {
}

- (void)dialogWillDisappear {
}


- (NSString *)_generateTimestamp 
{
    return [NSString stringWithFormat:@"%d", time(NULL)];
}

- (NSString *)_generateNonce 
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    NSMakeCollectable(theUUID);
    return (NSString *)string;
}



- (void)dialogDidSucceed:(NSURL *)url {
	NSString *q = [url absoluteString];
    
    //NSLog(@"q=%@",q);
	//NSString* isOk=[url.resourceSpecifier hasPrefix:kWidgetDialogURL]?@"yes":@"no";
	//if([isOk isEqualToString:@"no"]) {
    // NSString *tokenString = [self getStringFromUrl:q needle:@"oauth_token="];
    NSString *expTime = [self getStringFromUrl:q needle:@"oauth_verifier="];
    
    
    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:AppKey secret:AppSecret];
    
    
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
	OAToken *token = [[OAToken alloc] initWithHTTPResponseBody:[info valueForKey:@"responseBody"]];
    OAHMAC_SHA1SignatureProvider *hmacSha1Provider = [[OAHMAC_SHA1SignatureProvider alloc] init];
    
	OAMutableURLRequest *hmacSha1Request = [[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?oauth_verifier=%@",AccessURL,expTime]]
                                                                           consumer:consumer
                                                                              token:token
                                                                              realm:NULL
                                                                  signatureProvider:hmacSha1Provider
                                                                              nonce:[self _generateNonce]
                                                                          timestamp:[self _generateTimestamp]];
	[hmacSha1Request setHTTPMethod:@"GET"];
	
    // NSAssert(0, @"\n\n\n\n\n==================Ê≥®ÊÑèsinaÁâπÊÆäÔºåÈúÄË¶Åoauth_verifier======================\n\n\n\n\n\n");
    
	
	OAAsynchronousDataFetcher *fetcher = [[OAAsynchronousDataFetcher alloc] initWithRequest:hmacSha1Request delegate:self didFinishSelector:@selector(requestTokenTicket:finishedWithData:) didFailSelector:@selector(requestTokenTicket:failedWithError:)];
    
    [fetcher start];
    [fetcher release];
}







- (void)dialogDidCancel:(NSURL *)url {
    if ([_delegate respondsToSelector:@selector(dialogDidNotCompleteWithUrl:)]) {
        [_delegate dialogDidNotCompleteWithUrl:url];
    }
    [self dismissWithSuccess:NO animated:YES];
}

@end
