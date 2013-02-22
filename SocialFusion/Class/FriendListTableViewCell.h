//
//  FreindProfileTabelViewCell.h
//  SocialFusion
//
//  Created by 王紫川 on 11-8-29.
//  Copyright 2011年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FriendListTableViewCellDelegate;

@interface FriendListTableViewCell : UITableViewCell {
    UIImageView *_defaultHeadImageView;
    UIImageView *_headImageView;
    UILabel *_userName;
    UILabel *_latestStatus;
    UIImageView *_headFrameIamgeView;
    id<FriendListTableViewCellDelegate> _delegate;
}

@property (nonatomic, retain) IBOutlet UIImageView* defaultHeadImageView;
@property (nonatomic, retain) IBOutlet UIImageView* headImageView;
@property (nonatomic, retain) IBOutlet UILabel* userName;
@property (nonatomic, retain) IBOutlet UILabel* latestStatus;
@property (nonatomic, retain) IBOutlet UIImageView* headFrameIamgeView;
@property (nonatomic, assign) id<FriendListTableViewCellDelegate> delegate;

- (IBAction)didClickChatButton:(id)sender;

@end

@protocol FriendListTableViewCellDelegate <NSObject>

- (void)frientListCellDidClickChatButton:(FriendListTableViewCell *)cell;

@end
