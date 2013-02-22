//
//  NewFeedBlog.h
//  SocialFusion
//
//  Created by He Ruoyun on 12-1-30.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NewFeedRootData.h"


@interface NewFeedBlog : NewFeedRootData

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * prefix;
@property (nonatomic, retain) NSString * mydescription;
@property (nonatomic, retain) NSString * shareID;
@property (nonatomic, retain) NSString * sharePersonID;

@end
