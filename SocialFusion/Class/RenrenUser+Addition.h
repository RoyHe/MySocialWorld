//
//  RenrenUser.h
//  SocialFusion
//
//  Created by 王紫川 on 11-9-9.
//  Copyright (c) 2011年 Tongji Apple Club. All rights reserved.
//


#import "RenrenUser.h"
#import "RenrenDetail.h"

@interface RenrenUser (Addition)

+ (RenrenUser *)insertUser:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context;
+ (RenrenUser *)insertFriend:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context;
+ (RenrenUser *)insertUserWithName:(NSString *)name userID:(NSString *)userID inManagedObjectContext:(NSManagedObjectContext *)context;
+ (RenrenUser *)userWithID:(NSString *)userID inManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)deleteAllObjectsInManagedObjectContext:(NSManagedObjectContext *)context;
+ (NSArray *)allUsersInManagedObjectContext:(NSManagedObjectContext *)context;
+ (NSArray *)getAllFriendsOfUser:(RenrenUser *)user inManagedObjectContext:(NSManagedObjectContext *)context;

- (BOOL)isEqualToUser:(RenrenUser *)user;
- (void)loadLatestStatus;

@end
