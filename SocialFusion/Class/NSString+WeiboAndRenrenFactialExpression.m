//
//  NSString+WeiboAndRenrenFactialExpression.m
//  SocialFusion
//
//  Created by He Ruoyun on 12-2-28.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "NSString+WeiboAndRenrenFactialExpression.h"



@implementation NSString (WeiboAndRenrenFactialExpression)
-(NSString*)renren2weibo
{
    NSString* returnString;
    returnString = [self stringByReplacingOccurrencesOfString:@"(调皮)" withString:@"[挤眼]"];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"(尴尬)" withString:@"[黑线]"];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"(汗)" withString:@"[吃惊]"];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"(囧)" withString:@"[囧]"];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"(可爱)" withString:@"[抱抱]"];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"(酷)" withString:@"[酷]"];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"(流口水)" withString:@"[钱]"];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"(色)" withString:@"[花心]"];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"(生病)" withString:@"[生病]"];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"(淘气)" withString:@"[可怜]"];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"(舔)" withString:@"[馋嘴]"];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"(吐)" withString:@"[吐]"];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"(吻)" withString:@"[爱你]"];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"(晕)" withString:@"[晕]"];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"(住嘴)" withString:@"[闭嘴]"];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"(大笑)" withString:@"[嘻嘻]"];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"(害羞) " withString:@"[害羞]"];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"(口罩)" withString:@"[感冒]"];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"(哭)" withString:@"[泪]"];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"(困)" withString:@"[睡觉]"];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"(难过)" withString:@"[悲伤]"];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"(生气)" withString:@"[愤怒]"];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"(书呆子)" withString:@"[书呆子]"];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"(微笑)" withString:@"[呵呵]"];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"(不)" withString:@"[不要]"];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"(kb)" withString:@"[挖鼻屎]"];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"(sx)" withString:@"[太开心]"];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"(gl)" withString:@"[给力]"];
    
    return  returnString;

}
-(NSString*)weibo2renren
{
    NSString* returnString;
    returnString = [self stringByReplacingOccurrencesOfString:@"[挤眼]" withString:@"(调皮)"];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"[黑线]" withString:@"(尴尬)"];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"[吃惊]" withString:@"(汗)"];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"[囧]" withString:@"(囧)"];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"[抱抱]" withString:@"(可爱)"];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"[酷]" withString:@"(酷)"];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"[钱]" withString:@"(流口水)"];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"[花心]" withString:@"(色)"];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"[生病]" withString:@"(生病)"];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"[可怜]" withString:@"(淘气)"];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"[馋嘴]" withString:@"(舔)"];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"[吐]" withString:@"(吐)"];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"[爱你]" withString:@"(吻)"];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"[晕]" withString:@"(晕)"];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"[闭嘴]" withString:@"(住嘴)"];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"[嘻嘻]" withString:@"(大笑)"];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"[害羞] " withString:@"(害羞)"];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"[感冒]" withString:@"(口罩)"];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"[泪]" withString:@"(哭)"];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"[睡觉]" withString:@"(困)"];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"[悲伤]" withString:@"(难过)"];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"[愤怒]" withString:@"(生气)"];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"[书呆子]" withString:@"(书呆子)"];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"[呵呵]" withString:@"(微笑)"];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"[不要]" withString:@"(不)"];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"[挖鼻屎]" withString:@"(kb)"];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"[太开心]" withString:@"(sx)"];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"[给力]" withString:@"(gl)"];
    return returnString;
}
@end
