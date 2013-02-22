//
//  NewFeedUploadPhoto.h
//  SocialFusion
//
//  Created by He Ruoyun on 12-2-18.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NewFeedRootData.h"


@interface NewFeedUploadPhoto : NewFeedRootData

@property (nonatomic, retain) NSString * photo_big_url;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * prefix;
@property (nonatomic, retain) NSString * photo_comment;
@property (nonatomic, retain) NSString * photo_url;
@property (nonatomic, retain) NSString * photo_ID;
@property (nonatomic, retain) NSString * album_ID;

@end
