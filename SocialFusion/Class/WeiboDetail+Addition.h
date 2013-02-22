//
//  WeiboDetail+Addition.h
//  SocialFusion
//
//  Created by 王紫川 on 11-10-5.
//  Copyright 2011年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboDetail.h"

@interface WeiboDetail (Addition)

+ (WeiboDetail *)insertDetailInformation:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context;
+ (WeiboDetail *)detailWithID:(NSString *)userID inManagedObjectContext:(NSManagedObjectContext *)context;

@end
