//
//  Image.m
//  SocialFusion
//
//  Created by 王紫川 on 11-9-14.
//  Copyright (c) 2011年 Tongji Apple Club. All rights reserved.
//

#import "Image+Addition.h"
#import "ImageData.h"

@implementation Image (Addition)

+ (Image *)imageWithURL:(NSString *)url inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:@"Image" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"url == %@", url]];
    
    Image *res = [[context executeFetchRequest:request error:NULL] lastObject];
    
    [request release];
    
    return res;
}

+ (Image *)insertImage:(NSData *)data withURL:(NSString *)url inManagedObjectContext:(NSManagedObjectContext *)context
{
    
    if (!url || [url isEqualToString:@""]) {
        return nil;
    }
    
    Image *image = [self imageWithURL:url inManagedObjectContext:context];
    
    if (!image) {
        image = [NSEntityDescription insertNewObjectForEntityForName:@"Image" inManagedObjectContext:context];
        ImageData *imageData = [NSEntityDescription insertNewObjectForEntityForName:@"ImageData" inManagedObjectContext:context];
        image.imageData = imageData;
    }
    
    image.imageData.data = data;
    image.url = url;
    image.updateDate = [NSDate date];
    
    [Image clearCacheInContext:context];
    
    return image;
}

+ (void)clearCacheInContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:@"Image" inManagedObjectContext:context]];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"updateDate"
                                                                     ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSArray *resultArray = [context executeFetchRequest:request error:NULL];
    
    if (resultArray.count > 40) {
        [resultArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            //NSLog(@"date:%@", ((Image *)obj).updateDate);
            Image *image = (Image *)obj;
            [context deleteObject:image.imageData];
            [context deleteObject:image];
            if (idx > 30) {
                *stop = YES;
            }
        }];
    }
    [request release];
}

+ (void)clearAllCacheInContext:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:@"Image" inManagedObjectContext:context]];    
    NSArray *resultArray = [context executeFetchRequest:request error:NULL];
    
    [resultArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Image *image = (Image *)obj;
        [context deleteObject:image.imageData];
        [context deleteObject:image];
    }];
    [request release];
}

@end
