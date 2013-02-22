//
//  NewFeedRootData+Addition.m
//  SocialFusion
//
//  Created by He Ruoyun on 11-11-7.
//  Copyright (c) 2011年 Tongji Apple Club. All rights reserved.
//

#import "NewFeedRootData+Addition.h"
#import "RenrenUser+Addition.h"
#import "WeiboUser+Addition.h"

@implementation NewFeedRootData (NewFeedRootData_Addition)


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

- (int)getComment_Count {
    return [self.comment_Count intValue];
}


- (void)setCount:(int)count {
    self.comment_Count=[NSNumber numberWithInt:  count];
}

- (NSDate*)getDate {
    return self.update_Time;
}



- (int)getStyle {
    return [self.style intValue];
}

- (NSString*)getAuthorName {
    return self.author.name;
}



- (NSString*)getHeadURL {
    return self.owner_Head;
}


- (int)getCellHeight
{
    return [self.cellheight intValue];
}

- (void)configureNewFeed:(int)style height:(int)height getDate:(NSDate*)getDate Dic:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context {
    
    self.style = [NSNumber numberWithInt:style];
    self.cellheight = [NSNumber numberWithInt:height];
    
    // 此处是为了解决创建新标签时原新鲜事排序的变动问题
    if (!self.get_Time || self.owner == nil) {
        self.get_Time = getDate;
    }
    
    if(style == kNewFeedStyleRenren) {
        
        NSString *statusID = [NSString stringWithFormat:@"%@", [dict objectForKey:@"post_id"]];
        self.post_ID = statusID;
        
        self.actor_ID = [[dict objectForKey:@"actor_id"] stringValue];
        self.source_ID = [[dict objectForKey:@"source_id"] stringValue]; 
        
        NSDateFormatter *form = [[NSDateFormatter alloc] init];
        [form setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSString* dateString = [dict objectForKey:@"update_time"];
        self.update_Time = [form dateFromString: dateString];
        [form release];
        
        self.owner_Head = [dict objectForKey:@"headurl"];
        self.owner_Name = [dict objectForKey:@"name"];
        self.comment_Count = [NSNumber numberWithInt:[[[dict objectForKey:@"comments"] objectForKey:@"count"] intValue]];
        
        self.author = [RenrenUser insertUserWithName:self.owner_Name userID:self.actor_ID inManagedObjectContext:context];
        
    }
    else if(style == kNewFeedStyleWeibo)
    {        
        NSString *statusID = [NSString stringWithFormat:@"%@", [dict objectForKey:@"id"]];
        
        self.author = [WeiboUser insertUser:[dict objectForKey:@"user"] inManagedObjectContext:context];
        
        self.owner_Name = self.author.name;
        self.post_ID = statusID;
        
        self.actor_ID = [[[dict objectForKey:@"user"] objectForKey:@"id"] stringValue] ;
        
        self.owner_Head = [[dict objectForKey:@"user"] objectForKey:@"profile_image_url"];
        
        NSDateFormatter *form = [[NSDateFormatter alloc] init];
        [form setDateFormat:@"EEE MMM dd HH:mm:ss ZZZ yyyy"];
        
        // Sat Oct 15 21:22:56 +0800 2011
        
        NSLocale* tempLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        [form setLocale:tempLocale];
        [tempLocale release];
        
        NSString* dateString=[dict objectForKey:@"created_at"];
        self.update_Time = [form dateFromString: dateString];    
        [form release];
        
        self.comment_Count = [NSNumber numberWithInt:[[dict objectForKey:@"comment_count"] intValue]];
        self.source_ID = [[dict objectForKey:@"id"] stringValue];
    }
}

- (NSString*)getCountString
{
    return [NSString stringWithFormat:@"评论:%d",[self.comment_Count intValue]];
}

+ (NewFeedRootData *)feedWithID:(NSString *)statusID inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"NewFeedRootData" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"post_ID == %@", statusID]];
    NewFeedRootData *res = [[context executeFetchRequest:request error:NULL] lastObject];
    [request release];
    return res;
}




@end
