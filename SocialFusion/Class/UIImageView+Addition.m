//
//  UIImageView+Addition.m
//  SocialFusion
//
//  Created by 王紫川 on 12-2-4.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "UIImageView+Addition.h"
#import "Image+Addition.h"

@implementation UIImageView (Addition)



- (void)fadeIn {
    [self fadeInWithCompletion:nil];
}

- (void)fadeInWithCompletion:(void (^)(BOOL finished))completion {
    self.alpha = 0;
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^(void) {
        self.alpha = 1;
    } completion:completion];
}

- (void)fadeOut {
    [self fadeOutWithCompletion:nil];
}

- (void)fadeOutWithCompletion:(void (^)(BOOL finished))completion {
    self.alpha = 1;
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^(void) {
        self.alpha = 0;
    } completion:completion];
}

- (void)halfFadeIn {
    self.alpha = 0;
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^(void) {
        self.alpha = kCustomHalfAlpha;
    } completion:nil];
}

- (void)setImageFromUrl:(NSString*)urlString {
    [self setImageFromUrl:urlString completion:nil];
}

- (void)setImageFromUrl:(NSString*)urlString 
             completion:(void (^)(void))completion {
    dispatch_queue_t downloadQueue = dispatch_queue_create("downloadImageQueue", NULL);
    dispatch_async(downloadQueue, ^{
        
        UIImage *avatarImage = nil; 
        NSURL *url = [NSURL URLWithString:urlString];
        NSData *responseData = [NSData dataWithContentsOfURL:url];
        avatarImage = [UIImage imageWithData:responseData];
        
        if (avatarImage) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.image = avatarImage;
                if (completion) {
                    completion();
                }	
            });
        }
        else {
            //NSLog(@"download failed: %@", urlString);
        }
    });   
    dispatch_release(downloadQueue);
}


- (void)loadImageFromURL:(NSString *)urlString 
              completion:(void (^)())completion 
          cacheInContext:(NSManagedObjectContext *)context
{
	/*Image *imageObject = [Image imageWithURL:urlString inManagedObjectContext:context];
     if (imageObject) {
     NSData *imageData = imageObject.imageData.data;
     UIImage *img = [UIImage imageWithData:imageData];
     self.image = img;
     if (completion) {
     completion();
     }
     return;
     }*/
	
    NSURL *url = [NSURL URLWithString:urlString];    
    dispatch_queue_t downloadQueue = dispatch_queue_create("downloadImageQueue", NULL);
    dispatch_async(downloadQueue, ^{ 
        //NSLog(@"download image:%@", urlString);
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        if(!imageData) {
           // NSLog(@"download image failed:%@", urlString);
            return;
        }
        UIImage *img = [UIImage imageWithData:imageData];
        dispatch_async(dispatch_get_main_queue(), ^{
            if([Image imageWithURL:urlString inManagedObjectContext:context] == nil) {
                [Image insertImage:imageData withURL:urlString inManagedObjectContext:context];
                //NSLog(@"cache image url:%@", urlString);
                self.image = img;
                if (completion) {
                    completion();
                }			
            }
        });
    });
    dispatch_release(downloadQueue);
}

- (void)centerizeWithSideLength:(CGFloat)length {
    if(self.image == nil) 
        return;
    UIImage *image = self.image;
    CGPoint center =  self.center;
    if(image.size.width < image.size.height)
        self.frame = CGRectMake(0, 0, length, length * image.size.height / image.size.width);
    else
        self.frame = CGRectMake(0, 0, length * image.size.width / image.size.height, length);
    self.center = center;
}

@end
