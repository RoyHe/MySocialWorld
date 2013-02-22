//
//  LNRootViewController.h
//  SocialFusion
//
//  Created by 王紫川 on 12-1-19.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataViewController.h"
#import "LNLabelBarViewController.h"
#import "LNContentViewController.h"
#import "SpashViewController.h"
#import "LoginViewController.h"
@interface LNRootViewController : CoreDataViewController<LNLabelBarViewControllerDelegate, LNContentViewControllerDelegate,SplashViewDelegate, LoginViewDelegate> {
    LNLabelBarViewController *_labelBarViewController;
    LNContentViewController *_contentViewController;
    NSMutableDictionary *_openedUserHeap;
}

@property (nonatomic, retain) LNLabelBarViewController *labelBarViewController;
@property (nonatomic, retain) LNContentViewController *contentViewController;

@end
