//
//  NewFeedUserListController.m
//  SocialFusion
//
//  Created by He Ruoyun on 12-1-21.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "NewFeedUserListController.h"
#import "RenrenClient.h"
#import "WeiboClient.h"
@implementation NewFeedUserListController

- (void)dealloc {
    [super dealloc];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.scrollsToTop = NO;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"NewFeedListController" bundle:nil];
    return self;
}

- (void)clearData
{
    if(!_clearDataFlag)
        return;
    _clearDataFlag = NO;
    _noAnimationFlag = YES;
    [self.processRenrenUser removeStatuses:self.processRenrenUser.statuses];
    [self.processWeiboUser removeStatuses:self.processWeiboUser.statuses];
}

- (WeiboUser *)processWeiboUser {
    return self.weiboUser;
}

- (RenrenUser *)processRenrenUser {
    return self.renrenUser;
}

- (NSPredicate *)customPresdicate {
    NSPredicate *predicate;
    if(_style == kRenrenUserFeed) {
        predicate = [NSPredicate predicateWithFormat:@"SELF IN %@", self.processRenrenUser.statuses];
    }
    else if(_style == kWeiboUserFeed) {
        predicate = [NSPredicate predicateWithFormat:@"SELF IN %@", self.processWeiboUser.statuses];
    }
    return predicate;
}

- (void)addNewWeiboData:(NewFeedRootData *)data {
    [self.processWeiboUser addStatusesObject:data];
}

- (void)addNewRenrenData:(NewFeedRootData *)data {
    [self.processRenrenUser addStatusesObject:data];
}

- (void)loadMoreRenrenData {
    self.loadingCount = self.loadingCount + 1;
    RenrenClient *renren = [RenrenClient client];
    
    [renren setCompletionBlock:^(RenrenClient *client) {
        if (!client.hasError) {            
            [self clearData];
            NSArray *array = client.responseJSONObject;
            [self processRenrenData:array];
        }
                self.loadingCount = self.loadingCount - 1;
    }];
    
    [renren getNewFeed:_pageNumber uid:self.processRenrenUser.userID];
}


- (void)loadMoreWeiboData {
    self.loadingCount = self.loadingCount + 1;
    WeiboClient *client = [WeiboClient client];
    [client setCompletionBlock:^(WeiboClient *client) {
        if (!client.hasError) {
            [self clearData];
            NSArray *array = client.responseJSONObject;
            [self processWeiboData:array];
        }
                self.loadingCount = self.loadingCount - 1;
    }];
    [client getUserTimeline:self.processWeiboUser.userID SinceID:nil maxID:nil startingAtPage:_pageNumber count:30 feature:0];
}

- (void)loadMoreData {
    if(_loadingFlag)
        return;
    _pageNumber++;
    [self startLoading];

    _currentTime = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
    
    if (_style == kRenrenUserFeed) {
        [self loadMoreRenrenData];
    }
    else if(_style == kWeiboUserFeed) {
        [self loadMoreWeiboData];
    }
    
}
@end
