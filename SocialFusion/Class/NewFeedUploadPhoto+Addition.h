//
//  NewFeedUploadPhoto+Addition.h
//  SocialFusion
//
//  Created by He Ruoyun on 12-1-10.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "NewFeedUploadPhoto.h"

@interface NewFeedUploadPhoto (Addition)
+ (NewFeedUploadPhoto *)insertNewFeed:(int)sytle getDate:(NSDate*)getDate Dic:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context;
+ (NewFeedUploadPhoto *)feedWithID:(NSString *)statusID inManagedObjectContext:(NSManagedObjectContext *)context;
- (NSString*)getName;
- (NSString*)getPhoto_Comment;
- (NSString*)getTitle;
@end
