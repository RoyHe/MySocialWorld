//
//  UIImage+Addition.h
//  SocialFusion
//
//  Created by He Ruoyun on 12-1-16.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Addition)
+ (void)loadImageFromURL:(NSString *)urlString 
             completion:(void (^)())completion 
         cacheInContext:(NSManagedObjectContext *)context;

- (UIImage *)convertToGrayscale;
@end
