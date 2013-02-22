//
//  NewFeedUploadPhoto+Addition.m
//  SocialFusion
//
//  Created by He Ruoyun on 12-1-10.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "NewFeedUploadPhoto+Addition.h"
#import "NewFeedRootData+Addition.h"

@implementation NewFeedUploadPhoto (Addition)

- (void)configureNewFeed:(int)style height:(int)height getDate:(NSDate*)getDate Dic:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context {
    [super configureNewFeed:style height:height getDate:getDate Dic:dict inManagedObjectContext:context];
    
    self.photo_big_url = [[[dict objectForKey:@"attachment"] objectAtIndex:0] objectForKey:@"raw_src"];
    
    self.photo_url = [[[dict objectForKey:@"attachment"] objectAtIndex:0] objectForKey:@"src"];
    self.photo_comment=[[[dict objectForKey:@"attachment"] objectAtIndex:0] objectForKey:@"content"];
    
    self.photo_ID=[[[[dict objectForKey:@"attachment"] objectAtIndex:0] objectForKey:@"media_id"] stringValue];

    self.prefix = [dict objectForKey:@"prefix"];
    self.title = [dict objectForKey:@"title"];
    
    self.album_ID=[[dict objectForKey:@"source_id"] stringValue];
    
    
}

+ (NewFeedUploadPhoto *)insertNewFeed:(int)style getDate:(NSDate*)getDate Dic:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context;
{
    NSString *statusID = [NSString stringWithFormat:@"%@", [[dict objectForKey:@"post_id"] stringValue]];
    if (!statusID || [statusID isEqualToString:@""]) {
        return nil;
    }
    
    NewFeedUploadPhoto *result = [NewFeedUploadPhoto feedWithID:statusID inManagedObjectContext:context];
    if (!result) {
        result = [NSEntityDescription insertNewObjectForEntityForName:@"NewFeedUploadPhoto" inManagedObjectContext:context];
    }    
    
    [result configureNewFeed:style height:0 getDate:getDate Dic:dict inManagedObjectContext:context];
  
    
    return result;
}


+ (NewFeedUploadPhoto *)feedWithID:(NSString *)statusID inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"NewFeedUploadPhoto" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"post_ID == %@", statusID]];
    NewFeedUploadPhoto *res = [[context executeFetchRequest:request error:NULL] lastObject];
    [request release];
    return res;
}

- (NSString*)getName
{
    return self.prefix;
     
}


- (NSString*)getPhoto_Comment
{
    
    
    if (![self.photo_comment compare:@""])
    {
        return @"那个人很懒，没有写介绍噢";
    }
    else
    {
     //@人时会出问题
     //   if ([self.photo_comment length]>54)
     //   {
       //     NSString* returnString=[NSString stringWithFormat:@"%@...",[self.photo_comment substringToIndex:50]];
         //   return returnString;
       // }
       // else
        //{
            return self.photo_comment;
        //}
    }
}
- (NSString*)getTitle
{
    return [NSString stringWithFormat:@"来自:《%@》",self.title];;
}
@end
