//
//  FriendListViewController.m
//  SocialFusion
//
//  Created by 王紫川 on 11-10-4.
//  Copyright 2011年 Tongji Apple Club. All rights reserved.
//

#import "FriendListViewController.h"
#import "FriendListTableViewCell.h"
#import "RenrenUser.h"
#import "WeiboUser.h"
#import "Image+Addition.h"
#import "UIImageView+Addition.h"
#import "User+Addition.h"
#import "FriendListRenrenViewController.h"
#import "FriendListWeiboViewController.h"
#import "NSNotificationCenter+Addition.h"
#import "LeaveMessageViewController.h"
#import "UIApplication+Addition.h"

@implementation FriendListViewController

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [super dealloc];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

+ (FriendListViewController *)getNewFeedListControllerWithType:(RelationshipViewType)type {
    FriendListViewController *result;
    if(type == RelationshipViewTypeRenrenFriends) {
        result = [[FriendListRenrenViewController alloc] initWithType:type];
    }
    else {
        result = [[FriendListWeiboViewController alloc] initWithType:type];
    }
    [result autorelease];
    return result;
}

#pragma mark -
#pragma mark NSFetchRequestController

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    FriendListTableViewCell *relationshipCell = (FriendListTableViewCell *)cell;
    relationshipCell.delegate = self;
    relationshipCell.headImageView.image = nil;
    relationshipCell.latestStatus.text = nil;
    User *usr = [self.fetchedResultsController objectAtIndexPath:indexPath];
    relationshipCell.userName.text = usr.name;
    
    NSData *imageData = nil;
    if([Image imageWithURL:usr.tinyURL inManagedObjectContext:self.managedObjectContext]) {
        imageData = [Image imageWithURL:usr.tinyURL inManagedObjectContext:self.managedObjectContext].imageData.data;
    }
    if(imageData == nil) {
        if(self.tableView.dragging == NO && self.tableView.decelerating == NO) {
            if(indexPath.row < kCustomRowCount) {
                [relationshipCell.headImageView loadImageFromURL:usr.tinyURL completion:^{
                    [relationshipCell.headImageView fadeIn];
                } cacheInContext:self.managedObjectContext];
            }
        }
    }
    else {
        relationshipCell.headImageView.image = [UIImage imageWithData:imageData];
    }
}

- (NSString *)customCellClassName
{
    return @"FriendListTableViewCell";
}

#pragma mark -
#pragma mark UITableView delegates

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    // 清空选中状态
    cell.highlighted = NO;
    cell.selected = NO;
    
    User *usr = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSMutableDictionary *userDict = [NSMutableDictionary dictionaryWithDictionary:self.currentUserDict];
    if([usr isMemberOfClass:[RenrenUser class]])
        [userDict setObject:usr forKey:kRenrenUser];
    else if([usr isMemberOfClass:[WeiboUser class]]) 
        [userDict setObject:usr forKey:kWeiboUser];
    [NSNotificationCenter postSelectFriendNotificationWithUserDict:userDict];
}

#pragma mark -
#pragma mark Animations

- (void)loadExtraDataForOnScreenRowsHelp:(NSIndexPath *)indexPath {
    if(self.tableView.dragging || self.tableView.decelerating || _reloadingFlag)
        return;
    User *usr = [self.fetchedResultsController objectAtIndexPath:indexPath];
    Image *image = [Image imageWithURL:usr.tinyURL inManagedObjectContext:self.managedObjectContext];
    if (image == nil)
    {
        FriendListTableViewCell *relationshipCell = (FriendListTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [relationshipCell.headImageView loadImageFromURL:usr.tinyURL completion:^{
            [relationshipCell.headImageView fadeIn];
        } cacheInContext:self.managedObjectContext];
    }
}

- (void)updateCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {    
    FriendListTableViewCell *relationshipCell = (FriendListTableViewCell *)cell;
    User *usr = [self.fetchedResultsController objectAtIndexPath:indexPath];
    //NSLog(@"update user name:%@", usr.name);
    if(![relationshipCell.latestStatus.text isEqualToString:usr.latestStatus]) {
        relationshipCell.latestStatus.text = usr.latestStatus;
        relationshipCell.latestStatus.alpha = 0.3f;
        [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^(void) {
            relationshipCell.latestStatus.alpha = 1;
        } completion:nil];
    }
}

#pragma mark -
#pragma mark FriendListTableViewCell delegate

- (void)frientListCellDidClickChatButton:(FriendListTableViewCell *)cell {
    if(_type == RelationshipViewTypeRenrenFriends)
        [[UIApplication sharedApplication] presentToast:@"当前版本暂不支持留言。" withVerticalPos:kToastBottomVerticalPosition];
    else
        [[UIApplication sharedApplication] presentToast:@"当前版本暂不支持私信。" withVerticalPos:kToastBottomVerticalPosition];
    return;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    User *usr = [self.fetchedResultsController objectAtIndexPath:indexPath];
    LeaveMessageViewController *vc = [[LeaveMessageViewController alloc] initWithUser:usr];
    [[UIApplication sharedApplication] presentModalViewController:vc];
    [vc release];
}

@end
