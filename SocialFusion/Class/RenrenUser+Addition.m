//
//  RenrenUser.m
//  SocialFusion
//
//  Created by 王紫川 on 11-9-9.
//  Copyright (c) 2011年 Tongji Apple Club. All rights reserved.
//

#import "RenrenUser+Addition.h"
#import "NSString+Pinyin.h"
#import "RenrenDetail+Addition.h"
#import "RenrenClient.h"

@implementation RenrenUser (Addition)

+ (RenrenUser *)insertUserHelp:(NSDictionary *)dict userID:(NSString *)userID inManagedObjectContext:(NSManagedObjectContext *)context {
    if (!userID || [userID isEqualToString:@""]) {
        return nil;
    }
    RenrenUser *result = [RenrenUser userWithID:userID inManagedObjectContext:context];
    if (!result) {
        result = [NSEntityDescription insertNewObjectForEntityForName:@"RenrenUser" inManagedObjectContext:context];
    }
    
    result.userID = userID;
    result.name = [NSString stringWithFormat:@"%@", [dict objectForKey:@"name"]];
    result.firstName = [NSString stringWithFormat:@"%c", [result.name characterAtIndex:0]];
    result.pinyinNameFirstLetter = [result.name pinyinFirstLetterAtIndex:0];
    result.pinyinName = [result.name pinyinFirstLetterArray];
    result.tinyURL = [dict objectForKey:@"tinyurl"];
    
    return result;
}

+ (RenrenUser *)insertFriend:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context {
    NSString *userID = [[dict objectForKey:@"id"] stringValue];
    return [RenrenUser insertUserHelp:dict userID:userID inManagedObjectContext:context];
}

+ (RenrenUser *)insertUser:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSString *userID = [[dict objectForKey:@"uid"] stringValue];
    RenrenUser *result = [RenrenUser insertUserHelp:dict userID:userID inManagedObjectContext:context];
    RenrenDetail *detail = [RenrenDetail insertDetailInformation:dict userID:userID inManagedObjectContext:context];
    result.detailInfo = detail;
    return result;
}

+ (RenrenUser *)userWithID:(NSString *)userID inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:@"RenrenUser" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"userID == %@", userID]];
    
    RenrenUser *res = [[context executeFetchRequest:request error:NULL] lastObject];
    
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
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"RenrenUser" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSArray *items = [context executeFetchRequest:fetchRequest error:NULL];
    [fetchRequest release];
    
    for (NSManagedObject *managedObject in items) {
        [context deleteObject:managedObject];
    }
}

- (BOOL)isEqualToUser:(RenrenUser *)user
{
    return [self.userID isEqualToString:user.userID];
}

+ (NSArray *)getAllFriendsOfUser:(RenrenUser *)user inManagedObjectContext:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"RenrenUser" inManagedObjectContext:context]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF IN %@", user.friends];
    [request setPredicate:predicate];
    NSArray *res = [context executeFetchRequest:request error:NULL];
    [request release];
    return res;
}

+ (RenrenUser *)insertUserWithName:(NSString *)name userID:(NSString *)userID inManagedObjectContext:(NSManagedObjectContext *)context {
    RenrenUser *result = [RenrenUser userWithID:userID inManagedObjectContext:context];
    if (!result) {
        result = [NSEntityDescription insertNewObjectForEntityForName:@"RenrenUser" inManagedObjectContext:context];
    }
    result.name = name;
    result.userID = userID;
    return result;
}

- (void)loadLatestStatus {
    NSString *userID = self.userID;
    RenrenClient *renren = [RenrenClient client];
    [renren setCompletionBlock:^(RenrenClient *client) {
        if(!client.hasError) {
            NSDictionary *dict = client.responseJSONObject;
            NSString *authorID = [NSString stringWithFormat:@"%@", [dict objectForKey:@"uid"]];
            User *author = [RenrenUser userWithID:authorID inManagedObjectContext:self.managedObjectContext];
            author.latestStatus = [NSString stringWithFormat:@"%@",[dict objectForKey:@"message"]];
        }
    }];
    [renren getLatestStatus:userID];
}

@end
