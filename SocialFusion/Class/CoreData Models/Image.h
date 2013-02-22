//
//  Image.h
//  SocialFusion
//
//  Created by He Ruoyun on 11-11-18.
//  Copyright (c) 2011年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ImageData;

@interface Image : NSManagedObject

@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSDate * updateDate;
@property (nonatomic, retain) ImageData *imageData;

@end
