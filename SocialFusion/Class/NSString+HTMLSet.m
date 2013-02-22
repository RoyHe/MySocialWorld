//
//  NSString+HTMLSet.m
//  SocialFusion
//
//  Created by He Ruoyun on 12-1-19.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "NSString+HTMLSet.h"

//static NSString *renrenAtRegEx = @"@[^@]*\\([0-9]{9,}\\)\\u0020";
static NSString *renrenAtRegEx = @"@[^@]*\\([0-9]{9,}\\)";
static NSString *weiboAtRegEx = @"@[[a-z][A-Z][0-9][\\u4E00-\\u9FA5]-_]*";
static NSString *linkRegEx = @"https?://[[a-z][A-Z][0-9]\?/%&=.]+";

@implementation NSString (HTMLSet)

- (NSString*)replaceJSSign
{
    NSString* returnString;
    returnString = [self stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\'"];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"'" withString:@"\\'"];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    return  returnString;
}

- (NSString *)replaceRegEx:(NSString *)regEx withString:(NSString *)substitute {
    NSString *returnString = [NSString stringWithFormat:@"%@", self];
    NSRange searchRange = NSMakeRange(0, returnString.length);
    NSRange range = [returnString rangeOfString:regEx options:NSRegularExpressionSearch];
    BOOL isReplacingWeiboAtRegEx = [regEx isEqualToString:weiboAtRegEx];
    BOOL isReplacingRenrenAtRegEx = [regEx isEqualToString:renrenAtRegEx];
    while(range.location != NSNotFound) {
        NSString* subStr = [returnString substringWithRange:range];
       // NSLog(@"substr:%@", subStr);
        NSString *substituteStr = nil;
        if(isReplacingRenrenAtRegEx) {
            substituteStr = [NSString stringWithFormat:substitute, [subStr substringWithRange:NSMakeRange(subStr.length - 10, 9)], [subStr substringToIndex:subStr.length - 11]];
        }
        else if(isReplacingWeiboAtRegEx) {
            substituteStr = [NSString stringWithFormat:substitute, [subStr substringFromIndex:1], subStr];
        }
        else {
            substituteStr = [NSString stringWithFormat:substitute, subStr, subStr];
        }
      //  NSLog(@"substituteStr:%@", substituteStr);
        //NSLog(@"substitute str:%@", substituteStr);
        returnString = [returnString stringByReplacingCharactersInRange:range withString:substituteStr];
        NSUInteger newRangeLoc = range.location + substituteStr.length;
        searchRange = NSMakeRange(newRangeLoc, returnString.length - newRangeLoc);
        range = [returnString rangeOfString:regEx options:NSRegularExpressionSearch range:searchRange];
    }
    return returnString;
}


-(NSString*)replaceHTMPostSign

{
    
    NSString* returnString = [self stringByReplacingOccurrencesOfString:@"&" withString:@"&amp"];
     returnString = [returnString stringByReplacingOccurrencesOfString:@"<" withString:@"&lt"];
     returnString = [returnString stringByReplacingOccurrencesOfString:@">" withString:@"&gt"];
     returnString = [returnString stringByReplacingOccurrencesOfString:@"¢" withString:@"&cent"];
     returnString = [returnString stringByReplacingOccurrencesOfString:@"£" withString:@"&pound"];
     returnString = [returnString stringByReplacingOccurrencesOfString:@"¥" withString:@"&yen"];
     returnString = [returnString stringByReplacingOccurrencesOfString:@"€" withString:@"&euro"];
     returnString = [returnString stringByReplacingOccurrencesOfString:@"§" withString:@"&sect"];
     returnString = [returnString stringByReplacingOccurrencesOfString:@"©" withString:@"&copy"];
     returnString = [returnString stringByReplacingOccurrencesOfString:@"®" withString:@"&reg"];
     returnString = [returnString stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot"];
    return returnString;

}

- (NSString*)replaceHTMLSignWithoutJS:(kReplayHTMLStyle)style
{
    NSString* returnString = [NSString stringWithString:self];
    if (style == kWeibo) {
        returnString = [returnString replaceRegEx:weiboAtRegEx withString:@"<span class='highlight'><a  href='//weibo/%@' onclick=\"event.cancelBubble=true;\">%@</a></span>"];
    }
    else if(style == kRenren){
        returnString = [returnString replaceRegEx:renrenAtRegEx withString:@"<span class='highlight'><a  href='//renren/%@' onclick=\"event.cancelBubble=true;\">%@</a></span>"];
    }
    returnString = [returnString replaceRegEx:linkRegEx withString:@"<span class='highlight'><a href='%@' onclick=\"event.cancelBubble=true;\">%@</a></span>"];
    return returnString;
    
}
- (NSString*)replaceHTMLSign:(kReplayHTMLStyle)style
{
    NSString* returnString = [self replaceHTMLSignWithoutJS:style];
   
    returnString = [returnString replaceJSSign];
   //  NSLog(@"%@",returnString);
    return returnString;
}

- (NSString*)decodeHTMLSign 
{
    NSString* returnString;
    returnString = [self stringByReplacingOccurrencesOfString:@"&amp" withString:@"&"];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"&lt" withString:@"<"];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"&gt" withString:@">"];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"&cent" withString:@"¢"];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"&pound" withString:@"£"];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"&yen" withString:@"¥"];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"&euro" withString:@"€"];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"&sect" withString:@"§"];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"&copy" withString:@"©"];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"&reg" withString:@"®"];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"&quot" withString:@"\""];
    return returnString;
}

- (NSString*)setName:(NSString*)name  
{
    //   NSArray* array = [self componentsSeparatedByString:@"@#Name#@"];
    //   [self release];
    // NSLog(@"%@",name);
    //  NSString* returnString = [[NSString alloc] initWithFormat:@"%@%@%@",[array objectAtIndex:0],name,[array objectAtIndex:1]];
    
    return self;
}


- (NSString*)setTime:(NSString*)time 
{
    /*  NSArray* array = [self componentsSeparatedByString:@"@#Time#@"];
     [self release];
     
     // NSLog(@"%@",time);
     NSString* returnString = [[NSString alloc] initWithFormat:@"%@%@%@",[array objectAtIndex:0],time,[array objectAtIndex:1]];
     return returnString;*/
    return self;
}



- (NSString*)setWeibo:(NSString*)weibo  
{
    NSArray* array = [self componentsSeparatedByString:@"@#Weibo#@"];
    [self release];
    
    //NSLog(@"%@",weibo);
    NSString* returnString = [[NSString alloc] initWithFormat:@"%@%@%@",[array objectAtIndex:0],weibo,[array objectAtIndex:1]];
    return returnString;
}



- (NSString*)setRepost:(NSString*)repost
{
    // NSLog(@"%@",self);
    NSArray* array = [self componentsSeparatedByString:@"@#Repost#@"];
    [self release];
    
    //NSLog(@"%@",repost);
    NSString* returnString = [[NSString alloc] initWithFormat:@"%@%@%@",[array objectAtIndex:0],repost,[array objectAtIndex:1]];
    return returnString;
}

- (NSString*)setAlbum:(NSString*)album 
{
    NSArray* array = [self componentsSeparatedByString:@"@#Album#@"];
    [self release];
    
    // NSLog(@"%@",album);
    NSString* returnString = [[NSString alloc] initWithFormat:@"%@%@%@",[array objectAtIndex:0],album,[array objectAtIndex:1]];
    return returnString;
}


- (NSString*)setPhotoMount:(NSString*)photomount 
{
    NSArray* array = [self componentsSeparatedByString:@"@#PhotoMount#@"];
    [self release];
    
    
    // NSLog(@"%@",photomount);
    NSString* returnString = [[NSString alloc] initWithFormat:@"%@%@%@",[array objectAtIndex:0],photomount,[array objectAtIndex:1]];
    return returnString;
}


- (NSString*)setAuthor:(NSString*)author
{
    NSArray* array = [self componentsSeparatedByString:@"@#Author#@"];
    [self release];
    
    // NSLog(@"%@",author);
    NSString* returnString = [[NSString alloc] initWithFormat:@"%@%@%@",[array objectAtIndex:0],author,[array objectAtIndex:1]];
    return returnString;
}

- (NSString*)setComment:(NSString*)comment 
{
    NSArray* array = [self componentsSeparatedByString:@"@#Comment#@"];
    [self release];
    
    
    //  NSLog(@"%@",comment);
    NSString* returnString = [[NSString alloc] initWithFormat:@"%@%@%@",[array objectAtIndex:0],comment,[array objectAtIndex:1]];
    return returnString;
}

- (NSString*)setCount:(NSString*)count
{
    NSArray* array = [self componentsSeparatedByString:@"@#Count#@"];
    [self release];
    
    NSString* returnString = [[NSString alloc] initWithFormat:@"%@%@%@",[array objectAtIndex:0],count,[array objectAtIndex:1]];
    return returnString;
}


- (NSString*)setBlogTitle:(NSString*)title 
{
    NSArray* array = [self componentsSeparatedByString:@"@#Title#@"];
    [self release];
    NSString* returnString = [[NSString alloc] initWithFormat:@"%@%@%@",[array objectAtIndex:0],title,[array objectAtIndex:1]];
    return returnString;
}


- (NSString*)setBlogDetail:(NSString*)blog 
{
    NSArray* array = [self componentsSeparatedByString:@"@#blog#@"];
    [self release];
    NSString* returnString = [[NSString alloc] initWithFormat:@"%@%@%@",[array objectAtIndex:0],blog,[array objectAtIndex:1]];
    return returnString;
}



@end
