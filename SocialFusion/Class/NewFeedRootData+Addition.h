//
//  NewFeedRootData+Addition.h
//  SocialFusion
//
//  Created by He Ruoyun on 11-11-7.
//  Copyright (c) 2011年 Tongji Apple Club. All rights reserved.
//

#import "NewFeedRootData.h"

#define kNewFeedStyleRenren 0
#define kNewFeedStyleWeibo  1

@interface NewFeedRootData (NewFeedRootData_Addition)

+ (NewFeedRootData *)feedWithID:(NSString *)statusID inManagedObjectContext:(NSManagedObjectContext *)context;
- (void)configureNewFeed:(int)sytle height:(int)height getDate:(NSDate*)getDate Dic:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context;
- (NSString*)getAuthorName;

- (NSString*)getHeadURL;
- (NSDate*)getDate;
- (NSString*)getActor_ID;
- (NSString*)getSource_ID;
- (NSString*)getBlog;
- (int)getComment_Count;
- (int)getStyle;
- (void)setCount:(int)count;
- (NSString*)getCountString;
@end
