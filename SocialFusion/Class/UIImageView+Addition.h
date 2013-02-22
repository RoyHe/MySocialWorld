//
//  UIImageView+Addition.h
//  SocialFusion
//
//  Created by 王紫川 on 12-2-4.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCustomHalfAlpha 0.5f

@interface UIImageView (Addition)

- (void)fadeIn;
- (void)halfFadeIn;
- (void)fadeInWithCompletion:(void (^)(BOOL finished))completion;
- (void)fadeOut;
- (void)fadeOutWithCompletion:(void (^)(BOOL finished))completion;

- (void)setImageFromUrl:(NSString*)urlString;
- (void)setImageFromUrl:(NSString*)urlString 
             completion:(void (^)(void))completion;

- (void)loadImageFromURL:(NSString *)urlString 
              completion:(void (^)())completion 
          cacheInContext:(NSManagedObjectContext *)context;

- (void)centerizeWithSideLength:(CGFloat)length;

@end
