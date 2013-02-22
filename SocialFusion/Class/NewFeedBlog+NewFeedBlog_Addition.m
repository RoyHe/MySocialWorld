//
//  NewFeedBlog+NewFeedBlog_Addition.m
//  SocialFusion
//
//  Created by He Ruoyun on 11-11-7.
//  Copyright (c) 2011年 Tongji Apple Club. All rights reserved.
//

#import "NewFeedBlog+NewFeedBlog_Addition.h"
#import "NewFeedRootData+Addition.h"

@implementation NewFeedBlog (NewFeedBlog_Addition)

- (void)configureNewFeed:(int)style height:(int)height getDate:(NSDate*)getDate Dic:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context {
    [super configureNewFeed:style height:height getDate:getDate Dic:dict inManagedObjectContext:context];
    
    if ([[dict objectForKey:@"feed_type"] intValue] == 21)
    {
        //  NSLog(@"%@",dict);
        self.source_ID=[[[[dict objectForKey:@"attachment"] objectAtIndex:0] objectForKey:@"media_id"] stringValue];
        self.actor_ID=[[[[dict objectForKey:@"attachment"] objectAtIndex:0] objectForKey:@"owner_id"] stringValue];
        self.shareID=[[dict objectForKey:@"source_id"] stringValue]; 
        self.sharePersonID=[[dict objectForKey:@"actor_id"] stringValue];
    }
    
    self.prefix = [dict objectForKey:@"prefix"] ;
    self.title = [dict objectForKey:@"title"] ;
    self.mydescription = [dict objectForKey:@"description"] ;
}

+ (NewFeedBlog *)insertNewFeed:(int)style height:(int)height getDate:(NSDate*)getDate Dic:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context;
{
    NSString *statusID = [NSString stringWithFormat:@"%@", [[dict objectForKey:@"post_id"] stringValue]];
    if (!statusID || [statusID isEqualToString:@""]) {
        return nil;
    }
    
    NewFeedBlog *result = [NewFeedBlog feedWithID:statusID inManagedObjectContext:context];
    if (!result) {
        result = [NSEntityDescription insertNewObjectForEntityForName:@"NewFeedBlog" inManagedObjectContext:context];
    }
    
    [result configureNewFeed:style height:height getDate:getDate Dic:dict inManagedObjectContext:context];
    return result;
}


+ (NewFeedBlog *)feedWithID:(NSString *)statusID inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"NewFeedBlog" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"post_ID == %@", statusID]];
    NewFeedBlog *res = [[context executeFetchRequest:request error:NULL] lastObject];
    [request release];
    return res;
}

- (NSString*)getBlog
{
    return self.mydescription;
}

- (NSString*)getName
{
    
    
    //if (description==nil)
    //description=@"";
    
    
    
    
    
    
    return [NSString stringWithFormat:@"%@《%@》",self.prefix,self.title]  ;
    
}



@end
