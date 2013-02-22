//
//  WeiboUserInfoViewController.m
//  SocialFusion
//
//  Created by 王紫川 on 12-2-17.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "WeiboUserInfoViewController.h"
#import "WeiboUser+Addition.h"
#import "WeiboClient.h"
#import "UIApplication+Addition.h"
#import "NSNotificationCenter+Addition.h"
#import "LabelConverter.h"

#define WEIBO_USER_INFO_SCROLL_VIEW_HEIGHT 530.0f

@interface WeiboUserInfoViewController()
- (void)configureRelationshipUI;
@end

@implementation WeiboUserInfoViewController

@synthesize blogLabel = _blogLabel;
@synthesize descriptionTextView = _descriptionTextView;
@synthesize locationLabel = _locationLabel;
@synthesize statusCountLabel = _statusCountLabel;
@synthesize friendCountLabel = _friendCountLabel;
@synthesize followerCountLabel = _followerCountLabel;
@synthesize statusCountButton = _statusCountButton;
@synthesize friendCountButton = _friendCountButton;
@synthesize followerCountButton = _followerCountButton;


- (void)dealloc {
    [_blogLabel release];
    [_descriptionTextView release];
    [_locationLabel release];
    
    [_statusCountLabel release];
    [_friendCountLabel release];
    [_followerCountLabel release];
    
    [_statusCountButton release];
    [_followerCountButton release];
    [_friendCountButton release];
    
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.blogLabel = nil;
    self.descriptionTextView = nil;
    self.locationLabel = nil;
    
    self.statusCountLabel = nil;
    self.friendCountLabel = nil;
    self.followerCountLabel = nil;
    
    self.statusCountButton = nil;
    self.friendCountButton = nil;
    self.followerCountButton = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.descriptionTextView.scrollsToTop = NO;
    
    [self configureUI];
}

- (void)configureUI {
    [super configureUI];
    
    self.friendCountLabel.text = self.weiboUser.detailInfo.friendsCount;
    self.followerCountLabel.text = self.weiboUser.detailInfo.followersCount;
    self.statusCountLabel.text = self.weiboUser.detailInfo.statusesCount;
    
    self.locationLabel.text = self.weiboUser.detailInfo.location;
    self.blogLabel.text = self.weiboUser.detailInfo.blogURL;
    self.descriptionTextView.text = self.weiboUser.detailInfo.selfDescription;
    self.nameLabel.text = self.weiboUser.name;
    
    [self configureRelationshipUI];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, WEIBO_USER_INFO_SCROLL_VIEW_HEIGHT);
}

- (void)adjustFollowButtonHeightImage:(BOOL)followedByMe {
    NSString *highlightImageName = nil;
    if(followedByMe) {
        highlightImageName = @"user_info_btn_not_follow@2x.png";
    }
    else {
        highlightImageName = @"user_info_btn_follow@2x.png";
    }
    [self.followButton setImage:[UIImage imageNamed:highlightImageName] forState:UIControlStateHighlighted];
}

- (void)configureRelationshipUI
{
    if ([self.weiboUser isEqualToUser:self.currentWeiboUser]) {
        self.followButton.hidden = YES;
        self.relationshipLabel.text = @"当前新浪微博用户。";
        self.atButton.hidden = YES;
    }
    else {
        [self.followButton setUserInteractionEnabled:NO];
        WeiboClient *client = [WeiboClient client];
        
        [client setCompletionBlock:^(WeiboClient *client) {
            [self.followButton setUserInteractionEnabled:YES];
            NSDictionary *dict = client.responseJSONObject;
            dict = [dict objectForKey:@"target"];
            
            BOOL followedByMe = [[dict objectForKey:@"followed_by"] boolValue];
            BOOL followingMe = [[dict objectForKey:@"following"] boolValue];
            
            [self.followButton setSelected:followedByMe];
            [self adjustFollowButtonHeightImage:followedByMe];
                                    
            NSString *state = nil;
            if (followingMe) {
                state = [NSString stringWithFormat:@"%@正关注你。", self.weiboUser.name];
            }
            else {
                state = [NSString stringWithFormat:@"%@未关注你。", self.weiboUser.name];
            }
            self.relationshipLabel.text = state;
        }];
        
        [client getRelationshipWithUser:self.weiboUser.userID];
    }
}

- (void)setFollowButtonSelected {
    [self.followButton setSelected:!self.followButton.isSelected];
    [self adjustFollowButtonHeightImage:self.followButton.isSelected];
}

#pragma mark -
#pragma mark IBActions

- (IBAction)didClickFollowButton {
    WeiboClient *client = [WeiboClient client];
    [self.followButton setUserInteractionEnabled:NO];
    [self setFollowButtonSelected];
    if(!self.followButton.isSelected) {
        [client setCompletionBlock:^(WeiboClient *client) {
            if(!client.hasError) {
                [[UIApplication sharedApplication] presentToast:@"已取消关注。" withVerticalPos:kToastBottomVerticalPosition];
            }
            else {
                [[UIApplication sharedApplication] presentErrorToast:@"取消关注失败。" withVerticalPos:kToastBottomVerticalPosition];
                [self setFollowButtonSelected];
            }
            [self.followButton setUserInteractionEnabled:YES];
        }];
        [client unfollow:self.weiboUser.userID];
    }
    else {
        [client setCompletionBlock:^(WeiboClient *client) {
            if(!client.hasError) {
                [[UIApplication sharedApplication] presentToast:@"已添加关注。" withVerticalPos:kToastBottomVerticalPosition];
            }
            else {
                [[UIApplication sharedApplication] presentErrorToast:@"添加关注失败。" withVerticalPos:kToastBottomVerticalPosition];
                [self setFollowButtonSelected];
            }
            [self.followButton setUserInteractionEnabled:YES];
        }];
        [client follow:self.weiboUser.userID];
    }
}    

- (IBAction)didClickBasicInfoButton:(id)sender {
    NSString *identifier = nil;
    BOOL isCurrentUser = [self.currentWeiboUser isEqualToUser:self.weiboUser];
    if([sender isEqual:self.statusCountButton]) {
        identifier = kChildWeiboNewFeed;
    }
    else if([sender isEqual:self.friendCountButton]) {
        if(isCurrentUser)
            identifier = kChildCurrentWeiboFriend;
        else
            identifier = kChildWeiboFriend;
    }
    else if([sender isEqual:self.followerCountButton]) {
        if(isCurrentUser)
            identifier = kChildCurrentWeiboFollower;
        else
            identifier = kChildWeiboFollower;
    }
    [NSNotificationCenter postSelectChildLabelNotificationWithIdentifier:identifier];
}

- (User *)processUser {
    return self.weiboUser;
}

- (NSString *)headImageURL {
    return self.weiboUser.detailInfo.headURL;
}

- (NSString *)processUserGender {
    return self.weiboUser.detailInfo.gender;
}

@end
