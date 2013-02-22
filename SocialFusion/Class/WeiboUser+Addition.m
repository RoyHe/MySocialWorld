//
//  WeiboUser.m
//  SocialFusion
//
//  Created by 王紫川 on 11-9-9.
//  Copyright (c) 2011年 Tongji Apple Club. All rights reserved.
//

#import "WeiboUser+Addition.h"
#import "NSString+Pinyin.h"
#import "WeiboDetail+Addition.h"


@implementation WeiboUser (Addition)

+ (WeiboUser *)insertUser:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSString *userID = [[dict objectForKey:@"id"] stringValue];
    
    if (!userID || [userID isEqualToString:@""]) {
        return nil;
    }
    
    WeiboUser *result = [WeiboUser userWithID:userID inManagedObjectContext:context];
    if (!result) {
        result = [NSEntityDescription insertNewObjectForEntityForName:@"WeiboUser" inManagedObjectContext:context];
    }
    
    
    result.updateDate = [NSDate date];
    
    result.userID = userID;
    result.name = [NSString stringWithFormat:@"%@", [dict objectForKey:@"screen_name"]];
    result.pinyinName = [result.name pinyinFirstLetterArray];
   // NSDictionary *statusDict = [dict objectForKey:@"status"];
    result.latestStatus = [dict objectForKey:@"description"];
    result.tinyURL = [dict objectForKey:@"profile_image_url"];
    
    WeiboDetail *detail = [WeiboDetail insertDetailInformation:dict inManagedObjectContext:context];
    
    result.detailInfo = detail;
    
    return result;
}

+ (WeiboUser *)userWithID:(NSString *)userID inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:@"WeiboUser" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"userID == %@", userID]];
    
    WeiboUser *res = [[context executeFetchRequest:request error:NULL] lastObject];
    
    [request release];
    
    return res;
}

+ (NSArray *)allUsersInManagedObjectContext:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:@"RenrenUser" inManagedObjectContext:context]];
    NSArray *res = [context executeFetchRequest:request error:NULL];
    [request release];
    
    return res;
}

+ (void)deleteAllObjectsInManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSArray *items = [context executeFetchRequest:fetchRequest error:NULL];
    [fetchRequest release];
    
    for (NSManagedObject *managedObject in items) {
        [context deleteObject:managedObject];
    }
}

- (BOOL)isEqualToUser:(WeiboUser *)user
{
    return [self.userID isEqualToString:user.userID];
}

@end
