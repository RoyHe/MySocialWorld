//
//  LoginViewController.m
//  SocialFusion
//
//  Created by 王紫川 on 12-2-23.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "LoginViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "LNRootViewController.h"
#import "RenrenUser+Addition.h"
#import "WeiboUser+Addition.h"
#import "WeiboClient.h"
#import "RenrenClient.h"
#import "Image+Addition.h"
#import "UIImageView+Addition.h"
#import "AppInfoViewController.h"
#import "UIApplication+Addition.h"

#define LOGOUT_RENREN NO
#define LOGOUT_WEIBO YES

@interface LoginViewController()
@property(nonatomic, assign) BOOL logoutClient;
- (void)rrDidLogin;
- (void)wbDidLogin;
- (void)refreshRenrenUserInfoUI;
- (void)refreshWeiboUserInfoUI;
@end

@implementation LoginViewController
@synthesize weiboUserNameLabel = _weiboUserNameLabel;
@synthesize renrenUserNameLabel = _renrenUserNameLabel;
@synthesize hasLoggedInAlertView = _hasLoggedInAlertView;
@synthesize logoutClient = _logoutClient;
@synthesize weiboPhotoImageView = _weiboPhotoImageView, renrenPhotoImageView = _renrenPhotoImageView;
@synthesize weiboPhotoView = _weiboPhotoView, renrenPhotoView = _renrenPhotoView;
@synthesize delegate=_delegate;

- (void)dealloc
{
    NSLog(@"loginview release");
    [_weiboUserNameLabel release];
    [_renrenUserNameLabel release];
    if(self.hasLoggedInAlertView.visible) {
		[self.hasLoggedInAlertView dismissWithClickedButtonIndex:-1 animated:NO];
	}
    [_hasLoggedInAlertView release];
    [_weiboPhotoImageView release];
    [_renrenPhotoImageView release];
    [_weiboPhotoView release];
    [_renrenPhotoView release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.weiboUserNameLabel = nil;
    self.renrenUserNameLabel = nil;
    self.weiboPhotoImageView = nil;
    self.renrenPhotoImageView = nil;
    self.weiboPhotoView = nil;
    self.renrenPhotoView = nil;
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.weiboPhotoView.layer.masksToBounds = YES;
    self.weiboPhotoView.layer.cornerRadius = 2.0f;
    self.renrenPhotoView.layer.masksToBounds = YES;
    self.renrenPhotoView.layer.cornerRadius = 2.0f;
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
	if ([RenrenClient authorized]) {
        NSString *renrenID = [ud objectForKey:@"renren_ID"];
        self.currentRenrenUser = [RenrenUser userWithID:renrenID inManagedObjectContext:self.managedObjectContext];
        if(self.currentRenrenUser == nil) {
            [self rrDidLogin];
        }
        else {
            self.renrenUser = self.currentRenrenUser;
            [self refreshRenrenUserInfoUI];
        }
	} 
    else {
		[self.renrenUserNameLabel setText:NSLocalizedString(@"ID_LogIn_All", nil)];
	}
    
	if ([WeiboClient authorized]) {
        NSString *weiboID = [ud objectForKey:@"weibo_ID"];
        self.currentWeiboUser = [WeiboUser userWithID:weiboID inManagedObjectContext:self.managedObjectContext];
        if(self.currentWeiboUser == nil) {
            [self wbDidLogin];
        }
        else {
            self.weiboUser = self.currentWeiboUser;
            [self refreshWeiboUserInfoUI];
        }
	} 
    else {
		[self.weiboUserNameLabel setText:NSLocalizedString(@"ID_LogIn_All", nil)];
	}
}

- (void)showHasLoggedInAlert:(BOOL)whoCalled {
    self.logoutClient = whoCalled;
    NSString *message;
    if(whoCalled == LOGOUT_WEIBO)
        message = self.currentWeiboUser.name;
    else if(whoCalled == LOGOUT_RENREN)
        message = self.currentRenrenUser.name;
    message = [message stringByAppendingString:NSLocalizedString(@"ID_LogOut_All",nil )];
    if(self.hasLoggedInAlertView && self.hasLoggedInAlertView.visible) {
        self.hasLoggedInAlertView.message = message;
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:NSLocalizedString(@"ID_OK",nil) otherButtonTitles:NSLocalizedString(@"ID_Cancel",nil), nil];
        self.hasLoggedInAlertView = alert;
        [alert show];
        [alert release];
    }
}

- (void)wbDidLogin {
    WeiboClient *weibo = [WeiboClient client];
    [weibo setCompletionBlock:^(WeiboClient *client) {
        if (!weibo.hasError) {
            NSDictionary *dict = client.responseJSONObject;
            NSLog(@"%@",dict);

            self.currentWeiboUser = [WeiboUser insertUser:dict inManagedObjectContext:self.managedObjectContext];
            
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            [ud setValue:self.currentWeiboUser.userID forKey:@"weibo_ID"];
            [ud synchronize];
            
            self.weiboUser = self.currentWeiboUser;
            [self refreshWeiboUserInfoUI];
        }
        else{
             [WeiboClient signout];          
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"内测阶段只支持测试账户" delegate:nil cancelButtonTitle:NSLocalizedString(@"ID_OK",nil) otherButtonTitles:nil];
            self.hasLoggedInAlertView = alert;
            [alert show];
            [alert release];
        }
    }];
    [weibo getUser:[WeiboClient currentUserID]];
}

- (void)rrDidLogin {
    RenrenClient *renren = [RenrenClient client];
    [renren setCompletionBlock:^(RenrenClient *client) {
        if (!renren.hasError) {
            NSArray *result = client.responseJSONObject;
            NSDictionary* dict = [result lastObject];
            self.currentRenrenUser = [RenrenUser insertUser:dict inManagedObjectContext:self.managedObjectContext];
           
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            [ud setValue:self.currentRenrenUser.userID forKey:@"renren_ID"];
            [ud synchronize];

            self.renrenUser = self.currentRenrenUser;
            [self refreshRenrenUserInfoUI];
        };
    }];
	[renren getUserInfo];
}

- (void)wbDidLogout {
    [self.weiboUserNameLabel setText:NSLocalizedString(@"ID_LogIn_All", nil)];
    [self.weiboPhotoImageView fadeOutWithCompletion:^(BOOL finished) {
        self.weiboPhotoImageView.image = nil;
    }];
    self.currentWeiboUser = nil;
}

- (void)rrDidLogout {
    [self.renrenUserNameLabel setText:NSLocalizedString(@"ID_LogIn_All", nil)];
    [self.renrenPhotoImageView fadeOutWithCompletion:^(BOOL finished) {
        self.renrenPhotoImageView.image = nil;
    }];
    self.currentRenrenUser = nil;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if(self.logoutClient == LOGOUT_RENREN) {
        if (buttonIndex == 0) {
            [RenrenClient signout];
            [self rrDidLogout];
            
        }
    }
    else if(self.logoutClient == LOGOUT_WEIBO)
    {
        if (buttonIndex == 0) {
            [WeiboClient signout];
            [self wbDidLogout];
        }
    }
    self.hasLoggedInAlertView = nil;
}

- (BOOL)isLoginValid {
    return ([RenrenClient authorized] && [WeiboClient authorized]);
}

- (void)refreshRenrenUserInfoUI {
    self.renrenUserNameLabel.text = self.currentRenrenUser.name;
    if(self.renrenPhotoImageView.image)
        return;
    Image *image = [Image imageWithURL:self.currentRenrenUser.tinyURL inManagedObjectContext:self.managedObjectContext];
    if (image == nil) {
        [self.renrenPhotoImageView loadImageFromURL:self.currentRenrenUser.tinyURL completion:^{
            [self.renrenPhotoImageView fadeIn];
        } cacheInContext:self.managedObjectContext];
    }
    else {
        [self.renrenPhotoImageView setImage:[UIImage imageWithData:image.imageData.data]];
        [self.renrenPhotoImageView fadeIn];
    }
}

- (void)refreshWeiboUserInfoUI {
    self.weiboUserNameLabel.text = self.currentWeiboUser.name;
    if(self.weiboPhotoImageView.image)
        return;
    Image *image = [Image imageWithURL:self.currentWeiboUser.tinyURL inManagedObjectContext:self.managedObjectContext];
    if (image == nil) {
        [self.weiboPhotoImageView loadImageFromURL:self.currentWeiboUser.tinyURL completion:^{
            [self.weiboPhotoImageView fadeIn];
        } cacheInContext:self.managedObjectContext];
    }
    else {
        [self.weiboPhotoImageView setImage:[UIImage imageWithData:image.imageData.data]];
        [self.weiboPhotoImageView fadeIn];
    }
}

#pragma mark -
#pragma mark IBActions 

- (IBAction)didClickWeiboLoginButton:(id)sender
{
	if (![WeiboClient authorized]) {        
        WeiboClient *weibo = [WeiboClient client];
        [weibo authorize:nil delegate:self];
    }
    else {
        [self showHasLoggedInAlert:LOGOUT_WEIBO];
    }
}


- (IBAction)didClickRenrenLoginButton:(id)sender
{    
	if (![RenrenClient authorized]) {
        RenrenClient *renren = [RenrenClient client];
        [renren setCompletionBlock:^(RenrenClient *client) {
            [self rrDidLogin];
        }];
        [renren authorize];
	}
    else {
        [self showHasLoggedInAlert:LOGOUT_RENREN];
    }
}

- (IBAction)didClickInfoButton:(id)sender {
        
    AppInfoViewController *vc = [[AppInfoViewController alloc] init];
    vc.delegate = self;
    vc.modalPresentationStyle = UIModalPresentationCurrentContext;
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:vc animated:YES];
    [vc release];
}

- (IBAction)didClickHelpButton:(id)sender
{
    [self.delegate didClickShowHelp];
}

#pragma mark -
#pragma mark AppInfoViewController delegate

- (void)didFinishShow {
    [self dismissModalViewControllerAnimated:YES];
}

@end

