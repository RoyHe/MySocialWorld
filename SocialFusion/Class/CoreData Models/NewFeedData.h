//
//  NewFeedData.h
//  SocialFusion
//
//  Created by He Ruoyun on 12-1-13.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NewFeedRootData.h"


@interface NewFeedData : NewFeedRootData

@property (nonatomic, retain) NSString * repost_StatusID;
@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) NSString * repost_Status;
@property (nonatomic, retain) NSString * repost_ID;
@property (nonatomic, retain) NSString * pic_URL;
@property (nonatomic, retain) NSString * repost_Name;
@property (nonatomic, retain) NSString * pic_big_URL;

@end
