//
//  FriendProfileViewController.h
//  SocialFusion
//
//  Created by 王紫川 on 11-8-28.
//  Copyright 2011年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOTableViewController.h"
#import "User.h"

typedef enum {
    RelationshipViewTypeWeiboFriends,
    RelationshipViewTypeWeiboFollowers,
    RelationshipViewTypeRenrenFriends,
} RelationshipViewType;

@interface FriendProfileViewController : EGOTableViewController {
    int _nextCursor;
    RelationshipViewType _type;
}

- (id)initWithType:(RelationshipViewType)type;
- (void)loadExtraDataForOnScreenRowsHelp:(NSIndexPath *)indexPath;
- (void)clearData;

@end
