//
//  RenrenDetail.h
//  SocialFusion
//
//  Created by 王紫川 on 12-2-18.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "DetailInformation.h"

@class RenrenUser;

@interface RenrenDetail : DetailInformation

@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * mainURL;
@property (nonatomic, retain) NSString * headURL;
@property (nonatomic, retain) NSString * hometownLocation;
@property (nonatomic, retain) NSString * workHistory;
@property (nonatomic, retain) NSString * birthday;
@property (nonatomic, retain) NSString * emailHash;
@property (nonatomic, retain) NSString * universityHistory;
@property (nonatomic, retain) NSString * highSchoolHistory;
@property (nonatomic, retain) RenrenUser *owner;

@end
