//
//  NSString+Pinyin.m
//  SocialFusion
//
//  Created by 王紫川 on 11-9-12.
//  Copyright 2011年 Tongji Apple Club. All rights reserved.
//

#import "NSString+Pinyin.h"
#import "pinyin.h"

@implementation NSString(Pinyin)

- (BOOL)compareCharacterAtIndex:(NSUInteger)index withString:(NSString *)string {
    if([self characterAtIndex:index] == [string characterAtIndex:0])
        return YES;
    return NO;
}

- (NSString *)pinyinFirstLetterAtIndex:(NSUInteger)i {
    NSString *firstLetter = nil;
    // 手动添加的多音字
    if([self compareCharacterAtIndex:i withString:@"曾"])
        firstLetter = @"Z";
    else if([self compareCharacterAtIndex:i withString:@"解"])
        firstLetter = @"X";
    else if([self compareCharacterAtIndex:i withString:@"仇"])
        firstLetter = @"Q";
    else if([self compareCharacterAtIndex:i withString:@"朴"])
        firstLetter = @"P";
    else if([self compareCharacterAtIndex:i withString:@"乐"])
        firstLetter = @"Y";
    else if([self compareCharacterAtIndex:i withString:@"单"])
        firstLetter = @"S";
    else
        firstLetter = [[NSString stringWithFormat:@"%c", pinyinFirstLetter([self characterAtIndex:i])] uppercaseString];
    return firstLetter;
}

- (NSString *)pinyinFirstLetterArray {
    NSMutableString *pinyin = [NSMutableString string];
    for(NSUInteger i = 0; i < self.length; i++) {
        NSString *firstLetter = [self pinyinFirstLetterAtIndex:i];
        [pinyin appendString:firstLetter];
    }
    //NSLog(@"pinyin%@",pinyin);
    return pinyin;
}

@end
