//
//  NewFeedCellHeight.h
//  SocialFusion
//
//  Created by He Ruoyun on 12-1-15.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NewFeedListController;
@interface NewFeedCellHeight : NSObject<UIWebViewDelegate>
{
    UIWebView* _webView;
    NewFeedListController* _dele;
}

- (void)myinit:(NewFeedListController*)deleControl;
- (int)getHeight:(NSDictionary*) dic style:(int)style;
@end
