//
//  NewFeedShareAlbum+Addition.m
//  SocialFusion
//
//  Created by He Ruoyun on 12-1-11.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "NewFeedShareAlbum+Addition.h"
#import "NewFeedRootData+Addition.h"

@implementation NewFeedShareAlbum (Addition)

- (void)configureNewFeed:(int)style height:(int)height getDate:(NSDate*)getDate Dic:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context {
    [super configureNewFeed:style height:height getDate:getDate Dic:dict inManagedObjectContext:context];
    
    self.photo_url = [[[dict objectForKey:@"attachment"] objectAtIndex:0] objectForKey:@"src"];
    self.album_count = [NSNumber numberWithInt:[[[[dict objectForKey:@"attachment"] objectAtIndex:0] objectForKey:@"photo_count"] intValue]];
    self.album_title = [dict objectForKey:@"title"];
    self.share_comment = [dict objectForKey:@"message"];
    self.fromID = [[[[dict objectForKey:@"attachment"] objectAtIndex:0] objectForKey:@"owner_id"] stringValue];
    
    self.fromName = [[[dict objectForKey:@"attachment"] objectAtIndex:0] objectForKey:@"owner_name"];
    
    self.media_ID = [[[[dict objectForKey:@"attachment"] objectAtIndex:0] objectForKey:@"media_id"] stringValue];
}

+ (NewFeedShareAlbum *)insertNewFeed:(int)style  height:(int)height getDate:(NSDate*)getDate Dic:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context;
{
    NSString *statusID = [NSString stringWithFormat:@"%@", [[dict objectForKey:@"post_id"] stringValue]];
    if (!statusID || [statusID isEqualToString:@""]) {
        return nil;
    }
    
    NewFeedShareAlbum *result = [NewFeedShareAlbum feedWithID:statusID inManagedObjectContext:context];
    if (!result) {
        result = [NSEntityDescription insertNewObjectForEntityForName:@"NewFeedShareAlbum" inManagedObjectContext:context];
    }
    
    [result configureNewFeed:style height:height getDate:getDate Dic:dict inManagedObjectContext:context];
    
    return result;
    
    // 将自己添加到对应user的statuses里
    // NSString *authorID = [NSString stringWithFormat:@"%@", [dict objectForKey:@"uid"]];
    // result.author = [RenrenUser userWithID:authorID inManagedObjectContext:context];
    
    
    
}


+ (NewFeedShareAlbum *)feedWithID:(NSString *)statusID inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"NewFeedShareAlbum" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"post_ID == %@", statusID]];
    NewFeedShareAlbum *res = [[context executeFetchRequest:request error:NULL] lastObject];
    [request release];
    return res;
}

- (NSString*)getShareComment
{
    if (![self.share_comment compare:@""])
    {
        return @"分享相册";
    }
    else
    {
        return self.share_comment;
    }
    //return self.prefix;
    
}
- (int)getAlbumQuan
{
    return [self.album_count intValue];
}
- (NSString*)getAubumName
{
    return [NSString stringWithFormat:@"相册:《%@》",self.album_title];
    
}


- (NSString*)getAblbumQuantity
{
    return [NSString stringWithFormat:@"共%d张照片",[self getAlbumQuan]];

}

- (NSString*)getFromName
{
      return [NSString stringWithFormat:@"来自:%@", self.fromName];
}


@end
