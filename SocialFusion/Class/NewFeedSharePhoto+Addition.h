//
//  NewFeedSharePhoto+Addition.h
//  SocialFusion
//
//  Created by He Ruoyun on 12-1-12.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "NewFeedSharePhoto.h"

@interface NewFeedSharePhoto (Addition)
+ (NewFeedSharePhoto *)insertNewFeed:(int)sytle height:(int)height getDate:(NSDate*)getDate Dic:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context;
+ (NewFeedSharePhoto *)feedWithID:(NSString *)statusID inManagedObjectContext:(NSManagedObjectContext *)context;

- (NSString*)getShareComment;
- (NSString*)getPhotoComment;
- (NSString*)getTitle;
- (NSString*)getFromName;
@end
