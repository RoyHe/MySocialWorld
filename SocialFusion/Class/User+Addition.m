//
//  User+Addition.m
//  SocialFusion
//
//  Created by 王紫川 on 11-9-17.
//  Copyright 2011年 Tongji Apple Club. All rights reserved.
//

#import "User+Addition.h"
#import "NSString+Pinyin.h"

@implementation User (Addition)

+ (User *)userWithID:(NSString *)userID inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:@"User" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"userID == %@", userID]];
    
    User *res = [[context executeFetchRequest:request error:NULL] lastObject];
    
    [request release];
    
    return res;
}

@end
