//
//  StatusCommentData+StatusCommentData_Addition.h
//  SocialFusion
//
//  Created by He Ruoyun on 11-11-21.
//  Copyright (c) 2011年 Tongji Apple Club. All rights reserved.
//

#import "StatusCommentData.h"

@interface StatusCommentData (StatusCommentData_Addition)
+ (StatusCommentData *)insertNewComment:(int)style Dic:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context;
+ (StatusCommentData *)feedWithID:(NSString *)statusID inManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)deleteAllObjectsInManagedObjectContext:(NSManagedObjectContext *)context;
- (NSString*)getText;
- (NSDate*)getUpdateTime;
- (NSString*)getOwner_Name;
- (NSString*)getOwner_HEAD;
@end
