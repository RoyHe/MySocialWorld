//
//  NSString+Addition.m
//  SocialFusion
//
//  Created by He Ruoyun on 12-2-24.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "NSString+Addition.h"

@implementation NSString (Addition)

- (BOOL)isGifURL {
    BOOL result = NO;
    NSString* extName = [self substringFromIndex:([self length] - 3)];
    if ([extName compare:@"gif"] == NSOrderedSame)
        result =  YES;
    return result;
}

@end
