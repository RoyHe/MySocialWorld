//
//  CommonFunction.m
//  SocialFusion
//
//  Created by He Ruoyun on 11-10-19.
//  Copyright (c) 2011年 Tongji Apple Club. All rights reserved.
//

#import "CommonFunction.h"

@implementation CommonFunction
+(NSString*)getTimeBefore:(NSDate*)date
{
    
    
    //NSLog(@"%@",FeedDate);
    int time=-[date timeIntervalSinceNow];
    
    NSString* tempString;
    
    
    
    if (time<0)
    {
        tempString=[NSString  stringWithFormat:@"0秒前"];
    }
    else if (time<60)
    {
        tempString=[NSString  stringWithFormat:@"%d秒前",time];
    }
    else if (time<3600)
    {
        tempString=[NSString stringWithFormat:@"%d分钟前",time/60];
    }
    else if (time<(3600*24))
    {
        tempString= [NSString   stringWithFormat:@"%d小时前",time/3600];
    }
    else
    {
        tempString= [NSString stringWithFormat:@"%d天前",time/(3600*24)];
    }
    
    return tempString;
}


@end
