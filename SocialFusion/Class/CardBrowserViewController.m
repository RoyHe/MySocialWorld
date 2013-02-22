//
//  CardBrowserViewController.m
//  SocialFusion
//
//  Created by 王紫川 on 12-3-1.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "CardBrowserViewController.h"
#import "UIApplication+Addition.h"
#import <MediaPlayer/MPMusicPlayerController.h>
#import <QuartzCore/QuartzCore.h>
#define BAIDU_LINK_TRANSFER @"http://gate.baidu.com/tc?from=opentc&src="
#define SINA_IASK_TRANSFER @"http://h2w.iask.cn/hd.php?u="
#define SINA_IASK_VIDEO_TRANSFER @"http://3g.sina.com.cn/3g/site/proc/video/show_convert_videoV2.php?url="
@interface CardBrowserViewController ()

@end

@implementation CardBrowserViewController

@synthesize webView = _webView;
@synthesize loadingIndicator = _loadingIndicator;
@synthesize url = _url;
@synthesize urlTextField = _urlTextField;
@synthesize webBackView = _webBackView;
@synthesize showurl=_showurl;

- (void)dealloc
{
    [_webView stopLoading];
    _webView.delegate = nil;
    [_webView release];
    [_loadingIndicator release];
    [_url release];
    [_urlTextField release];
    [_webBackView release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.webView = nil;
    self.loadingIndicator = nil;
    self.urlTextField = nil;
    self.webBackView = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    MPMusicPlayerController* ipodMusicPlayer = [MPMusicPlayerController iPodMusicPlayer];
    if ([ipodMusicPlayer playbackState] == MPMusicPlaybackStatePlaying) {
        _isIpodPlaying = YES;
    }
    else {
        _isIpodPlaying = NO;
    }
    
    self.webBackView.layer.masksToBounds = YES;
    self.webBackView.layer.cornerRadius = 5.0f;  
    self.webView.allowsInlineMediaPlayback = YES;
    self.webView.delegate = self;
    
    if(self.url) {
        self.urlTextField.text = [[self.showurl absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [self loadLink:self.url];
    }
}

- (void)loadLink:(NSURL*)link
{
    NSURLRequest* request = [[NSURLRequest alloc] initWithURL:link];
    [self.webView loadRequest:request];
	[request release];
}

- (IBAction)didClickCloseButton:(id)sender
{
    [[UIApplication sharedApplication] dismissModalViewController];
    [self.webView loadRequest:[[[NSURLRequest alloc] initWithURL:[[[NSURL alloc] initWithString:@"about:blank"] autorelease]] autorelease]];
    if (_isIpodPlaying) {
        MPMusicPlayerController* ipodMusicPlayer = [MPMusicPlayerController iPodMusicPlayer];
     //   NSLog(@"%@", [[ipodMusicPlayer nowPlayingItem] description]);
        [ipodMusicPlayer play];
    }
}

- (IBAction)didClickSafariButton:(id)sender
{
    [[UIApplication sharedApplication] openURL:[[self.webView request] URL]];
}

#pragma mark - 
#pragma mark UIWebView delegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.loadingIndicator startAnimating];
    self.loadingIndicator.hidden = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.loadingIndicator stopAnimating];
    self.loadingIndicator.hidden = YES;
}

+ (void)showCardBrowserWithLink:(NSURL *)link {
    CardBrowserViewController *browser = [[CardBrowserViewController alloc] init];
    
    NSString* wapString = [NSString stringWithFormat:@"%@",link];
    wapString = [NSString stringWithFormat:@"%@%@",SINA_IASK_TRANSFER,wapString];
    browser.showurl = link;
    browser.url = [NSURL URLWithString:wapString];
    [[UIApplication sharedApplication] presentModalViewController:browser];
    [browser release];
}

@end
