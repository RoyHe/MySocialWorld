//
//  LoginViewController.h
//  SocialFusion
//
//  Created by 王紫川 on 12-2-23.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "CoreDataViewController.h"
#import "WeiboClient.h"
#import "AppInfoViewController.h"
@protocol LoginViewDelegate;

@interface LoginViewController : CoreDataViewController<UIAlertViewDelegate, WBSessionDelegate, AppInfoViewControllerDelegate>

@property(nonatomic, retain) UIAlertView *hasLoggedInAlertView;
@property(nonatomic, retain) IBOutlet UILabel *weiboUserNameLabel;
@property(nonatomic, retain) IBOutlet UILabel *renrenUserNameLabel;
@property(nonatomic, retain) IBOutlet UIImageView *weiboPhotoImageView;
@property(nonatomic, retain) IBOutlet UIImageView *renrenPhotoImageView;
@property(nonatomic, retain) IBOutlet UIView *weiboPhotoView;
@property(nonatomic, retain) IBOutlet UIView *renrenPhotoView;
@property(nonatomic, readonly) BOOL isLoginValid;
@property (nonatomic, assign) id<LoginViewDelegate> delegate;

- (IBAction)didClickRenrenLoginButton:(id)sender;
- (IBAction)didClickWeiboLoginButton:(id)sender;
- (IBAction)didClickInfoButton:(id)sender;
- (IBAction)didClickHelpButton:(id)sender;

@end

@protocol LoginViewDelegate <NSObject>

- (void) didClickShowHelp;

@end
