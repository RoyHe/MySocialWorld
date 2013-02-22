//
//  NSString+WeiboSubString.m
//  SocialFusion
//
//  Created by He Ruoyun on 12-2-25.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "NSString+WeiboSubString.h"

@implementation NSString (WeiboSubString)

- (NSString*)getStatusSubstringWithCount:(int)count
{
    int i,n = [self length];
    unichar c;
    int a = 0;
    int b = 0;
    int l = 0;
    for(i = 0; i < n; i++){
        c = [self characterAtIndex:i];
        if(isblank(c)) {
            a++;
        }
        else if(isascii(c)){
            b++;
        }
        else {
            l++;
        }
        if(l + (int)floorf((float)(a + b) / 2.0f) >= count) {
            break;
        }
    }
    return [self substringToIndex:a + b + l];
}


@end
