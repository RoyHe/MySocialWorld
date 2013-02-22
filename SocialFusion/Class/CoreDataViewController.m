//
//  CoreDataViewController.m
//  PushBox
//
//  Created by Xie Hasky on 11-7-24.
//  Copyright 2011年 同济大学. All rights reserved.
//

#import "CoreDataViewController.h"
#import "RenrenUser.h"
#import "WeiboUser.h"

@implementation CoreDataViewController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize currentRenrenUser = _currentRenrenUser;
@synthesize currentWeiboUser = _currentWeiboUser;
@synthesize renrenUser = _renrenUser;
@synthesize weiboUser = _weiboUser;

- (void)dealloc
{
    [_managedObjectContext release];
    [_currentRenrenUser release];
    [_currentWeibosUser release];
    [_renrenUser release];
    [_weiboUser release];
    [super dealloc];
}

- (void)setCurrentRenrenUser:(RenrenUser *)renrenUser
{
    if (_currentRenrenUser != renrenUser) {
        [_currentRenrenUser release];
        _currentRenrenUser = [renrenUser retain];
        if (!self.managedObjectContext) {
            self.managedObjectContext = renrenUser.managedObjectContext;
        }
    }
}

- (void)setCurrentWeiboUser:(WeiboUser *)weiboUser
{
    if (_currentWeiboUser != weiboUser) {
        [_currentWeiboUser release];
        _currentWeiboUser = [weiboUser retain];
        if (!self.managedObjectContext) {
            self.managedObjectContext = weiboUser.managedObjectContext;
        }
    }
}

- (void)setRenrenUser:(RenrenUser *)renrenUser
{
    if (_renrenUser != renrenUser) {
        [_renrenUser release];
        _renrenUser = [renrenUser retain];
        if (!self.managedObjectContext) {
            self.managedObjectContext = renrenUser.managedObjectContext;
        }
    }
}

- (void)setWeiboUser:(WeiboUser *)weiboUser
{
    if (_weiboUser != weiboUser) {
        [_weiboUser release];
        _weiboUser = [weiboUser retain];
        if (!self.managedObjectContext) {
            self.managedObjectContext = weiboUser.managedObjectContext;
        }
    }
}

- (NSDictionary *)userDict {
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:self.currentUserDict];
    if(self.renrenUser)
        [result setObject:self.renrenUser forKey:kRenrenUser];
    if(self.weiboUser)
        [result setObject:self.weiboUser forKey:kWeiboUser];
    return result;
}

- (void)setUserDict:(NSDictionary *)userDict {
    self.currentRenrenUser = [userDict objectForKey:kCurrentRenrenUser];
    self.currentWeiboUser = [userDict objectForKey:kCurrentWeiboUser];
    self.renrenUser = [userDict objectForKey:kRenrenUser];
    self.weiboUser = [userDict objectForKey:kWeiboUser];
}

- (NSDictionary *)currentUserDict {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            self.currentRenrenUser, kCurrentRenrenUser,
            self.currentWeiboUser, kCurrentWeiboUser, nil];
}

- (void)setCurrentUserDict:(NSDictionary *)currentUserDict {
    self.currentRenrenUser = [currentUserDict objectForKey:kCurrentRenrenUser];
    self.currentWeiboUser = [currentUserDict objectForKey:kCurrentWeiboUser];
}

@end
