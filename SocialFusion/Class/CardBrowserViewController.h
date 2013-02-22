//
//  CardBrowserViewController.h
//  SocialFusion
//
//  Created by 王紫川 on 12-3-1.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardBrowserViewController : UIViewController<UIWebViewDelegate> {
    BOOL _isIpodPlaying;
}

@property (nonatomic, retain) IBOutlet UIWebView* webView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (nonatomic, retain) NSURL *url;
@property (nonatomic, retain) NSURL *showurl;
@property (nonatomic, retain) IBOutlet UITextField *urlTextField;
@property (nonatomic, retain) IBOutlet UIView *webBackView;

+ (void)showCardBrowserWithLink:(NSURL *)link;
- (void)loadLink:(NSURL*)link;

- (IBAction)didClickCloseButton:(id)sender;
- (IBAction)didClickSafariButton:(id)sender;

@end
