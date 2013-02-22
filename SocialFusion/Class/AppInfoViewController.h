//
//  AppInfoViewController.h
//  SocialFusion
//
//  Created by 王紫川 on 12-2-25.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "WeiboClient.h"
@protocol AppInfoViewControllerDelegate;

@interface AppInfoViewController : UIViewController<MFMailComposeViewControllerDelegate>

@property (nonatomic, retain) IBOutlet UIImageView *iconImageView;
@property (nonatomic, assign) id<AppInfoViewControllerDelegate> delegate;

- (IBAction)didClickFeedbackButton;
- (IBAction)didClickFollowUsButton;
- (IBAction)didClickEvaluateUsButton;

@end

@protocol AppInfoViewControllerDelegate <NSObject>

- (void)didFinishShow;

@end