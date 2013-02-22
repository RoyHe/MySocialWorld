//
//  NewFeedShareAlbum.h
//  SocialFusion
//
//  Created by He Ruoyun on 12-2-12.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NewFeedRootData.h"


@interface NewFeedShareAlbum : NewFeedRootData

@property (nonatomic, retain) NSString * album_title;
@property (nonatomic, retain) NSNumber * album_count;
@property (nonatomic, retain) NSString * photo_url;
@property (nonatomic, retain) NSString * fromID;
@property (nonatomic, retain) NSString * share_comment;
@property (nonatomic, retain) NSString * fromName;
@property (nonatomic, retain) NSString * media_ID;

@end
