//
//  NSNotificationCenter+Addition.m
//  SocialFusion
//
//  Created by 王紫川 on 12-1-24.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "NSNotificationCenter+Addition.h"

@implementation NSNotificationCenter (Addition)

+ (void)postSelectFriendNotificationWithUserDict:(NSDictionary *)userDict {
    [[NSNotificationCenter defaultCenter] postNotificationName:kSelectFriendNotification object:userDict userInfo:nil];
}

+ (void)postSelectChildLabelNotificationWithIdentifier:(NSString *)identifier {
    [[NSNotificationCenter defaultCenter] postNotificationName:kSelectChildLabelNotification object:identifier userInfo:nil];
}

+ (void)postSelectBackToLoginNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:kSelectBackToLoginNotification object:nil userInfo:nil];
}

+ (void)registerSelectFriendNotificationWithSelector:(SEL)aSelector target:(id)aTarget {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:aTarget selector:aSelector
                   name:kSelectFriendNotification 
                 object:nil];
}

+ (void)registerSelectChildLabelNotificationWithSelector:(SEL)aSelector target:(id)aTarget{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:aTarget selector:aSelector
                   name:kSelectChildLabelNotification  
                 object:nil];
}

+ (void)registerSelectBackToLoginNotificationWithSelector:(SEL)aSelector target:(id)aTarget {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:aTarget selector:aSelector
                   name:kSelectBackToLoginNotification 
                 object:nil];
}

@end
