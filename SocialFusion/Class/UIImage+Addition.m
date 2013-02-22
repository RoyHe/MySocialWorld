//
//  UIImage+Addition.m
//  SocialFusion
//
//  Created by He Ruoyun on 12-1-16.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "UIImage+Addition.h"
#import "Image+Addition.h"
@implementation UIImage (Addition)

typedef enum {
	ALPHA = 0,
	BLUE = 1,
	GREEN = 2,
	RED = 3
} PIXELS;

- (UIImage *)convertToGrayscale {
	CGSize size = [self size];
	int width = size.width;
	int height = size.height;
    
	// the pixels will be painted to this array
	uint32_t *pixels = (uint32_t *) malloc(width * height * sizeof(uint32_t));
    
	// clear the pixels so any transparency is preserved
	memset(pixels, 0, width * height * sizeof(uint32_t));
    
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
	// create a context with RGBA pixels
	CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8, width * sizeof(uint32_t), colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
    
	// paint the bitmap to our context which will fill in the pixels array
	CGContextDrawImage(context, CGRectMake(0, 0, width, height), self.CGImage);
    
	for(int y = 0; y < height; y++) {
		for(int x = 0; x < width; x++) {
			uint8_t *rgbaPixel = (uint8_t *) &pixels[y * width + x];
            
			// convert to grayscale using recommended method: http://en.wikipedia.org/wiki/Grayscale#Converting_color_to_grayscale
			uint32_t gray = 0.3 * rgbaPixel[RED] + 0.59 * rgbaPixel[GREEN] + 0.11 * rgbaPixel[BLUE];
            
			// set the pixels to gray
			rgbaPixel[RED] = gray;
			rgbaPixel[GREEN] = gray;
			rgbaPixel[BLUE] = gray;
		}
	}
    
	// create a new CGImageRef from our context with the modified pixels
	CGImageRef image = CGBitmapContextCreateImage(context);
    
	// we're done with the context, color space, and pixels
	CGContextRelease(context);
	CGColorSpaceRelease(colorSpace);
	free(pixels);
    
	// make a new UIImage to return
	UIImage *resultUIImage = [UIImage imageWithCGImage:image];
    
	// we're done with image now too
	CGImageRelease(image);
    
	return resultUIImage;
}

+ (void)loadImageFromURL:(NSString *)urlString 
              completion:(void (^)())completion 
          cacheInContext:(NSManagedObjectContext *)context
{
    
	
    NSURL *url = [NSURL URLWithString:urlString];    
    dispatch_queue_t downloadQueue = dispatch_queue_create("downloadImageQueue", NULL);
    dispatch_async(downloadQueue, ^{ 
        //NSLog(@"download image:%@", urlString);
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        if(!imageData) {
          //  NSLog(@"download image failed:%@", urlString);
            return;
        }
        //    UIImage *img = [UIImage imageWithData:imageData];
        dispatch_async(dispatch_get_main_queue(), ^{
            if([Image imageWithURL:urlString inManagedObjectContext:context] == nil) {
                [Image insertImage:imageData withURL:urlString inManagedObjectContext:context];
                //NSLog(@"cache image url:%@", urlString);
                //  self.image = img;
                if (completion) {
                    completion();
                }			
            }
        });
    });
    dispatch_release(downloadQueue);
}

@end
