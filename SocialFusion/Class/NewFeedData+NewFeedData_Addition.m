//
//  NewFeedData+NewFeedData_Addition.m
//  SocialFusion
//
//  Created by He Ruoyun on 11-11-7.
//  Copyright (c) 2011年 Tongji Apple Club. All rights reserved.
//

#import "NewFeedData+NewFeedData_Addition.h"
#import "NewFeedRootData+Addition.h"
#import "NSString+HTMLSet.h"
//#import "CalculateHeight.h"
@implementation NewFeedData (NewFeedData_Addition)

- (NSString*)getBlog
{
    return nil;
}
- (NSString*)getActor_ID
{
    return self.actor_ID;
}
- (NSString*)getSource_ID
{
    return self.source_ID;
}

- (int)getComment_Count
{
    return [self.comment_Count intValue];
}


- (void)setCount:(int)count
{
    self.comment_Count=[NSNumber numberWithInt:count];
}
- (NSDate*)getDate
{
    return self.update_Time;
}



- (int)getStyle
{
    return [self.style intValue];
}

- (NSString*)getAuthorName
{
    return self.owner_Name;
}



- (NSString*)getHeadURL
{
    return self.owner_Head;
}
- (NSString*)getPostMessagewithOutJS
{
    
    
    NSString* string=self.repost_Name;
    string=[string replaceHTMLSignWithoutJS:[self.style intValue]];
    
    
    NSString* string1=self.repost_Status;
    string1=[string1 replaceHTMLSignWithoutJS :[self.style intValue]];
    
    
    return [NSString stringWithFormat:@"<span style=\"font-weight:bold;\">%@:</span>%@",string,string1];
    
    // NSLog(@"%@",[tempString stringByAppendingFormat:@"%@",post_Status]);
    // return [tempString stringByAppendingFormat:@":%@",self.repost_Status] ;
    
    
}

- (NSString*)getPostMessage
{

    
    NSString* string=self.repost_Name;
    string=[string replaceHTMLSign:[self.style intValue]];

    
    NSString* string1=self.repost_Status;
    string1=[string1 replaceHTMLSign :[self.style intValue]];

    
    return [NSString stringWithFormat:@"<span style=\"font-weight:bold;\">%@:</span>%@",string,string1];
    
    // NSLog(@"%@",[tempString stringByAppendingFormat:@"%@",post_Status]);
   // return [tempString stringByAppendingFormat:@":%@",self.repost_Status] ;
    
    
}


- (NSString*)getPostName
{
    return self.repost_Name;
}


- (NSString*)getName
{
    return [self.message replaceHTMLSign:[self.style intValue]];
}


- (void)configureNewFeed:(int)style height:(int)height getDate:(NSDate*)getDate Dic:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context {
    [super configureNewFeed:style height:height getDate:getDate Dic:dict inManagedObjectContext:context];
    if(style == kNewFeedStyleWeibo) {
        self.pic_URL = [dict objectForKey:@"thumbnail_pic"];
        self.pic_big_URL = [dict objectForKey:@"bmiddle_pic"];
        
        NSDictionary* attachment = [dict objectForKey:@"retweeted_status"];
        if ([attachment count] != 0)
        {
            if ([attachment count] != 0)
            {
                self.repost_ID = [[[attachment  objectForKey:@"user"] objectForKey:@"id"] stringValue];
                self.repost_StatusID = [[attachment objectForKey:@"id"] stringValue ];
                self.repost_Name = [[attachment objectForKey:@"user"] objectForKey:@"screen_name"] ;
                self.repost_Status = [attachment objectForKey:@"text"] ;
                self.pic_URL = [attachment objectForKey:@"thumbnail_pic"];
                self.pic_big_URL = [attachment objectForKey:@"bmiddle_pic"];
            }
        }
        
        self.message = [dict objectForKey:@"text"];
    }
    else if(style == kNewFeedStyleRenren) {
   
        self.message=[dict objectForKey:@"message"];
        
        NSArray* attachments=[dict objectForKey:@"attachment"];
        if ([attachments count]!=0)
        {
            NSDictionary* attachment=[attachments objectAtIndex:0];
            if ([attachment count]!=0)
            {
                self.repost_ID=[[attachment objectForKey:@"owner_id"] stringValue];
                self.repost_Name=[attachment objectForKey:@"owner_name"];
                self.repost_Status=[attachment objectForKey:@"content"];                
                self.repost_StatusID=[[attachment objectForKey:@"media_id"] stringValue];
            }
        }
    }
}

+ (NewFeedData *)insertNewFeed:(int)style height:(int)height getDate:(NSDate*)getDate Dic:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context
{
    if (style==0)//renren
    {
        NSString *statusID = [NSString stringWithFormat:@"%@", [[dict objectForKey:@"post_id"] stringValue]];
        if (!statusID || [statusID isEqualToString:@""]) {
            return nil;
        }
        
        NewFeedData *result = [NewFeedData feedWithID:statusID inManagedObjectContext:context];
        if (!result) {
            result = [NSEntityDescription insertNewObjectForEntityForName:@"NewFeedData" inManagedObjectContext:context];
        }
        
        [result configureNewFeed:style height:height getDate:getDate Dic:dict inManagedObjectContext:context];
        
        return result;
    }
    else
    {
        NSString *statusID = [NSString stringWithFormat:@"%@", [dict objectForKey:@"id"]];
        if (!statusID || [statusID isEqualToString:@""]) {
            return nil;
        }
        
        NewFeedData *result = [NewFeedData feedWithID:statusID inManagedObjectContext:context];
        if (!result) {
            result = [NSEntityDescription insertNewObjectForEntityForName:@"NewFeedData" inManagedObjectContext:context];
        }
        
        [result configureNewFeed:style height:height getDate:getDate Dic:dict inManagedObjectContext:context];
        
        return result;
    }
}


+ (NewFeedData *)feedWithID:(NSString *)statusID inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"NewFeedData" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"post_ID == %@", statusID]];
    NewFeedData *res = [[context executeFetchRequest:request error:NULL] lastObject];
    [request release];
    return res;
}



@end
