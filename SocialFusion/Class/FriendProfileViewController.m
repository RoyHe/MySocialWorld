//
//  FriendProfileViewController.m
//  SocialFusion
//
//  Created by 王紫川 on 11-8-28.
//  Copyright 2011年 Tongji Apple Club. All rights reserved.
//

#import "FriendProfileViewController.h"
#import "RenrenUser+Addition.h"
#import "WeiboUser+Addition.h"
#import "Image+Addition.h"
#import "UIImageView+Addition.h"
#import "User+Addition.h"
#import "RenrenClient.h"
#import "WeiboClient.h"
#import "UIApplication+Addition.h"

@interface FriendProfileViewController()

@end

@implementation FriendProfileViewController

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [super dealloc];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [Image clearAllCacheInContext:self.managedObjectContext];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.scrollsToTop = NO;
}

#pragma mark -
#pragma mark EGORefresh Method
- (void)refresh {
    _clearDataFlag = YES;
    [self hideLoadMoreDataButton];
    _nextCursor = 0;
    [self loadMoreData];
}

- (void)clearData
{
    if(!_clearDataFlag)
        return;
    _clearDataFlag = NO;
    if(_type == RelationshipViewTypeRenrenFriends) {
        _noAnimationFlag = YES;
        [self.renrenUser removeFriends:self.renrenUser.friends];
    }
    else if(_type == RelationshipViewTypeWeiboFriends) {
        [self.weiboUser removeFriends:self.weiboUser.friends];
    }
    else if(_type == RelationshipViewTypeWeiboFollowers) {
        [self.weiboUser removeFollowers:self.weiboUser.followers];
    }
}

- (id)initWithType:(RelationshipViewType)type
{
    self = [super init];
    if(self) {
        _type = type;
    }
    return self;
}

- (void)loadMoreRenrenData {
    RenrenClient *renren = [RenrenClient client];
    [renren setCompletionBlock:^(RenrenClient *client) {
        if(!client.hasError) {
            [self clearData];
            [self stopLoading];
            NSArray *array = client.responseJSONObject;
            for(NSDictionary *dict in array) {
                RenrenUser *friend = [RenrenUser insertFriend:dict inManagedObjectContext:self.managedObjectContext];
                [self.renrenUser addFriendsObject:friend];
            }
            if(array.count > 0)
                [[UIApplication sharedApplication] presentToast:[NSString stringWithFormat:@"加载%d位人人网好友。", array.count] withVerticalPos:kToastBottomVerticalPosition];
            else 
                [[UIApplication sharedApplication] presentToast:[NSString stringWithFormat:@"您在人人网没有好友。", array.count] withVerticalPos:kToastBottomVerticalPosition];
        }
        [self doneLoadingTableViewData];
        _loadingFlag = NO;
        
    }];
    [renren getFriendsProfile];
}

- (void)loadMoreWeiboData {
    WeiboClient *client = [WeiboClient client];
    [client setCompletionBlock:^(WeiboClient *client) {
        if (!client.hasError) {
            [self clearData];
            [self stopLoading];
            //NSLog(@"dict:%@", client.responseJSONObject);
            NSArray *dictArray = [client.responseJSONObject objectForKey:@"users"];
            //NSLog(@"count:%d", [dictArray count]);
            for (NSDictionary *dict in dictArray) {
                WeiboUser *usr = [WeiboUser insertUser:dict inManagedObjectContext:self.managedObjectContext];
                if (_type == RelationshipViewTypeWeiboFollowers) {
                    [self.weiboUser addFollowersObject:usr];
                }
                else if (_type == RelationshipViewTypeWeiboFriends) {
                    [self.weiboUser addFriendsObject:usr];
                }
            }
            int perCursor = _nextCursor;
            _nextCursor = [[client.responseJSONObject objectForKey:@"next_cursor"] intValue];
            //NSLog(@"new cursor:%d", _nextCursor);
            if (_nextCursor == 0) {
                [self hideLoadMoreDataButton];
                if(dictArray.count == 0 && perCursor == 0) {
                    NSString *weiboType;
                    if (_type == RelationshipViewTypeWeiboFollowers) 
                        weiboType = @"粉丝";
                    else if (_type == RelationshipViewTypeWeiboFriends)
                        weiboType = @"关注";
                    [[UIApplication sharedApplication] presentToast:[NSString stringWithFormat:@"当前用户在新浪微博没有%@。", weiboType] withVerticalPos:kToastBottomVerticalPosition];
                }
            }
            else {
                [self showLoadMoreDataButton];
            }
        }
        [self doneLoadingTableViewData];
        _loadingFlag = NO;
    }];
    if (_type == RelationshipViewTypeWeiboFriends) {
        [client getFriendsOfUser:self.weiboUser.userID cursor:_nextCursor count:20];
    }
    else if(_type == RelationshipViewTypeWeiboFollowers) {
        [client getFollowersOfUser:self.weiboUser.userID cursor:_nextCursor count:20];
    }
}

- (void)loadMoreData {
    if(_loadingFlag)
        return;
    _loadingFlag = YES;
    [self startLoading];
    if(_type == RelationshipViewTypeRenrenFriends) {
        [self loadMoreRenrenData];
    }
    else {
        [self loadMoreWeiboData];
    }
}

// 优化显示，每次滑动停止才载入数据
- (void)loadExtraDataForOnScreenRowsHelp:(NSIndexPath *)indexPath {
}

- (void)loadExtraDataForOnscreenRows 
{
    NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
    NSTimeInterval i = 0;
    for (NSIndexPath *indexPath in visiblePaths)
    {
        i += 0.05;
        [self performSelector:@selector(loadExtraDataForOnScreenRowsHelp:) withObject:indexPath afterDelay:i];
    }
}

#pragma mark -
#pragma mark Deferred image loading (UIScrollViewDelegate)
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //NSLog(@"scrollViewDidEndDragging");
    [super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    if (!decelerate)
	{
        [self loadExtraDataForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //NSLog(@"scrollViewDidEndDecelerating");
    [self loadExtraDataForOnscreenRows];
}

@end
