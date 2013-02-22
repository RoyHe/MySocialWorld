//
//  NSNotificationCenter+Addition.h
//  SocialFusion
//
//  Created by 王紫川 on 12-1-24.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kSelectFriendNotification @"kSelectFriendNotification"
#define kSelectChildLabelNotification @"kSelectChildLabelNotification"
#define kSelectBackToLoginNotification @"kSelectBackToLoginNotification"

@interface NSNotificationCenter (Addition)

+ (void)postSelectFriendNotificationWithUserDict:(NSDictionary *)userDict;
+ (void)postSelectChildLabelNotificationWithIdentifier:(NSString *)identifier;
+ (void)postSelectBackToLoginNotification;

+ (void)registerSelectFriendNotificationWithSelector:(SEL)selector target:(id)aTarget;
+ (void)registerSelectChildLabelNotificationWithSelector:(SEL)aSelector target:(id)aTarget;
+ (void)registerSelectBackToLoginNotificationWithSelector:(SEL)aSelector target:(id)aTarget;

@end
