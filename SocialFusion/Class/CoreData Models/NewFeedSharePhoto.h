//
//  NewFeedSharePhoto.h
//  SocialFusion
//
//  Created by He Ruoyun on 12-2-18.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NewFeedRootData.h"


@interface NewFeedSharePhoto : NewFeedRootData

@property (nonatomic, retain) NSString * fromName;
@property (nonatomic, retain) NSString * fromID;
@property (nonatomic, retain) NSString * photo_url;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * share_comment;
@property (nonatomic, retain) NSString * photo_comment;
@property (nonatomic, retain) NSString * mediaID;
@property (nonatomic, retain) NSString * albumID;

@end
