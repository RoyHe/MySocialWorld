//
//  FreindProfileTabelViewCell.m
//  SocialFusion
//
//  Created by 王紫川 on 11-8-29.
//  Copyright 2011年 Tongji Apple Club. All rights reserved.
//

#import "FriendListTableViewCell.h"

@implementation FriendListTableViewCell
@synthesize defaultHeadImageView = _defaultHeadImageView;
@synthesize headImageView = _headImageView;
@synthesize userName = _userName;
@synthesize latestStatus = _latestStatus;
@synthesize headFrameIamgeView = _headFrameIamgeView;
@synthesize delegate = _delegate;


- (void)awakeFromNib {

}

- (void)dealloc {
    //NSLog(@"Friend List Cell Dealloc");
    [_defaultHeadImageView release];
    [_headImageView release];
    [_userName release];
    [_latestStatus release];
    [super dealloc];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    //NSLog(@"highlight:%d", highlighted);
    if(highlighted == NO && self.selected == YES)
        return;
    self.userName.highlighted = highlighted;
}   

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    //NSLog(@"selected:%d", selected);
    self.userName.highlighted = selected;
}

- (IBAction)didClickChatButton:(id)sender {
    //NSIndexPath* indexpath = [_listController.tableView indexPathForCell:self];
    [self.delegate frientListCellDidClickChatButton:self];
}

@end
