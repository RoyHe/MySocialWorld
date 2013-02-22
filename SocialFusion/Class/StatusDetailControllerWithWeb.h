//
//  StatusDetailControllerWithWeb.h
//  SocialFusion
//
//  Created by He Ruoyun on 12-2-11.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "StatusDetailController.h"
@interface StatusDetailControllerWithWeb : StatusDetailController<UIWebViewDelegate>
{
     IBOutlet UIWebView* _webView;
  
}
- (void)loadWebView;


@end
