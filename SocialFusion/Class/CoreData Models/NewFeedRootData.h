//
//  NewFeedRootData.h
//  SocialFusion
//
//  Created by 王紫川 on 12-2-29.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class StatusCommentData, User;

@interface NewFeedRootData : NSManagedObject

@property (nonatomic, retain) NSNumber * style;
@property (nonatomic, retain) NSString * owner_Name;
@property (nonatomic, retain) NSString * post_ID;
@property (nonatomic, retain) NSNumber * comment_Count;
@property (nonatomic, retain) NSNumber * cellheight;
@property (nonatomic, retain) NSDate * get_Time;
@property (nonatomic, retain) NSString * owner_Head;
@property (nonatomic, retain) NSString * actor_ID;
@property (nonatomic, retain) NSDate * update_Time;
@property (nonatomic, retain) NSString * source_ID;
@property (nonatomic, retain) NSSet *comments;
@property (nonatomic, retain) User *owner;
@property (nonatomic, retain) User *author;
@end

@interface NewFeedRootData (CoreDataGeneratedAccessors)

- (void)addCommentsObject:(StatusCommentData *)value;
- (void)removeCommentsObject:(StatusCommentData *)value;
- (void)addComments:(NSSet *)values;
- (void)removeComments:(NSSet *)values;

@end
