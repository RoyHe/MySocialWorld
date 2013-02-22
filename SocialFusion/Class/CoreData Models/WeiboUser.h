//
//  WeiboUser.h
//  SocialFusion
//
//  Created by 王紫川 on 12-2-29.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "User.h"

@class WeiboDetail, WeiboUser;

@interface WeiboUser : User

@property (nonatomic, retain) WeiboDetail *detailInfo;
@property (nonatomic, retain) NSSet *friends;
@property (nonatomic, retain) NSSet *followers;
@end

@interface WeiboUser (CoreDataGeneratedAccessors)

- (void)addFriendsObject:(WeiboUser *)value;
- (void)removeFriendsObject:(WeiboUser *)value;
- (void)addFriends:(NSSet *)values;
- (void)removeFriends:(NSSet *)values;

- (void)addFollowersObject:(WeiboUser *)value;
- (void)removeFollowersObject:(WeiboUser *)value;
- (void)addFollowers:(NSSet *)values;
- (void)removeFollowers:(NSSet *)values;

@end
