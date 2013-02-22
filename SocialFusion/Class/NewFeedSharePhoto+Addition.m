//
//  NewFeedSharePhoto+Addition.m
//  SocialFusion
//
//  Created by He Ruoyun on 12-1-12.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "NewFeedSharePhoto+Addition.h"
#import "NewFeedRootData+Addition.h"

@implementation NewFeedSharePhoto (Addition)

- (void)configureNewFeed:(int)style height:(int)height getDate:(NSDate*)getDate Dic:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context {
    [super configureNewFeed:style height:height getDate:getDate Dic:dict inManagedObjectContext:context];

    self.photo_url=[[[dict objectForKey:@"attachment"] objectAtIndex:0] objectForKey:@"src"];
    self.share_comment=[dict objectForKey:@"message"];
    self.photo_comment=[dict objectForKey:@"description"];
    
    self.mediaID=[[[[dict objectForKey:@"attachment"] objectAtIndex:0] objectForKey:@"media_id"] stringValue];
    
    
    self.fromID=[[[[dict objectForKey:@"attachment"] objectAtIndex:0] objectForKey:@"owner_id"] stringValue];
    
    self.fromName=[[[dict objectForKey:@"attachment"] objectAtIndex:0] objectForKey:@"owner_name"];
    
    self.title=[dict objectForKey:@"title"];
    
    NSString* albumString=[dict objectForKey:@"href"];
  
    self.albumID=[[albumString lastPathComponent] substringFromIndex:6];
}

+ (NewFeedSharePhoto *)insertNewFeed:(int)style height:(int)height getDate:(NSDate*)getDate Dic:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context;
{
    NSString *statusID = [NSString stringWithFormat:@"%@", [[dict objectForKey:@"post_id"] stringValue]];
    if (!statusID || [statusID isEqualToString:@""]) {
        return nil;
    }
    
    NewFeedSharePhoto *result = [NewFeedSharePhoto feedWithID:statusID inManagedObjectContext:context];
    if (!result) {
        result = [NSEntityDescription insertNewObjectForEntityForName:@"NewFeedSharePhoto" inManagedObjectContext:context];
    }
    
    [result configureNewFeed:style height:height getDate:getDate Dic:dict inManagedObjectContext:context];
    
    return result;
}


+ (NewFeedSharePhoto *)feedWithID:(NSString *)statusID inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"NewFeedSharePhoto" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"post_ID == %@", statusID]];
    NewFeedSharePhoto *res = [[context executeFetchRequest:request error:NULL] lastObject];
    [request release];
    return res;
}

- (NSString*)getShareComment
{
    if (![self.share_comment compare:@""])
    {
        return @"分享照片";
    }
    else
    {
        return self.share_comment;
    }
    //return self.prefix;
    
}

- (NSString*)getPhotoComment
{
    if (![self.photo_comment compare:@""])
    {
        return @"那个人很懒，没有写介绍噢";
    }
    else
    {
        if ([self.photo_comment length]>54)
        {
            NSString* returnString=[NSString stringWithFormat:@"%@...",[self.photo_comment substringToIndex:50]];
            return returnString;
        }
        else
        {
        return self.photo_comment;
        }
    }
    //return self.prefix;
    
}
- (NSString*)getTitle
{
 
    return  [NSString stringWithFormat:@"相册:《%@》",self.title];
}
- (NSString*)getFromName
{
    return  [NSString stringWithFormat:@"来自:%@",self.fromName];   
}

@end
