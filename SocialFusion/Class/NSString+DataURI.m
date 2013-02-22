//
//  NSString+DataURI.m
//  SocialFusion
//
//  Created by He Ruoyun on 12-1-9.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "NSString+DataURI.h"

@implementation NSString (DataURI)
- (NSString *)pngDataURIWithContent;
{
    NSString * result = [NSString stringWithFormat: @"data:image/png;base64,%@", self];
    return result;
}

- (NSString *)jpgDataURIWithContent;
{
    NSString * result = [NSString stringWithFormat: @"data:image/jpg;base64,%@", self];
    return result;
}
@end
