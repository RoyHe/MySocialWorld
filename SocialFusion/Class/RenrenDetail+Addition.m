//
//  RenrenDetail+Addition.m
//  SocialFusion
//
//  Created by 王紫川 on 11-10-5.
//  Copyright 2011年 Tongji Apple Club. All rights reserved.
//

#import "RenrenDetail+Addition.h"

@implementation RenrenDetail (Addition)

+ (RenrenDetail *)insertDetailInformation:(NSDictionary *)dict userID:(NSString *)userID inManagedObjectContext:(NSManagedObjectContext *)context
{
    if (!userID || [userID isEqualToString:@""]) {
        return nil;
    }
    
    RenrenDetail *result = [RenrenDetail detailWithID:userID inManagedObjectContext:context];
    if (!result) {
        result = [NSEntityDescription insertNewObjectForEntityForName:@"RenrenDetail" inManagedObjectContext:context];
    }
    
    result.ownerID = userID;
    
    result.headURL = [dict objectForKey:@"headURL"];
    result.mainURL = [dict objectForKey:@"mainURL"];
    
    NSString *sex = [dict objectForKey:@"sex"];
    if(sex) {
        bool isMan = [sex boolValue];
        if(isMan)
            result.gender = [NSString stringWithString:@"m"];
        else
            result.gender = [NSString stringWithString:@"f"];
    }
    result.birthday = [dict objectForKey:@"birthday"];
    result.headURL = [dict objectForKey:@"headurl"];
    result.mainURL = [dict objectForKey:@"mainurl"];
    
    NSDictionary *hometown = [dict objectForKey:@"hometown_location"];
    if(hometown) {
        NSString *province = [hometown objectForKey:@"province"];
        NSString *city = [hometown objectForKey:@"city"];
        NSString *hometownLocation = nil;
        if(province && city)
            hometownLocation = [NSString stringWithFormat:@"%@ %@", province, city];
        result.hometownLocation = hometownLocation;
    }
    
    NSDictionary *university = [[dict objectForKey:@"university_history"] lastObject];
    if(university) {
        NSString *department = [university objectForKey:@"department"];
        NSString *name = [university objectForKey:@"name"];
        NSString *year = [university objectForKey:@"year"];
        NSString *universityInfo = [NSString stringWithFormat:@"%@ %@ %@", name, department, year];
        result.universityHistory = universityInfo;
    }
    
    NSDictionary *highschool = [[dict objectForKey:@"hs_history"] lastObject];
    if(highschool) {
        NSString *name = [highschool objectForKey:@"name"];
        NSString *year = [highschool objectForKey:@"grad_year"];
        NSString *hsInfo = [NSString stringWithFormat:@"%@ %@", name, year];
        result.highSchoolHistory = hsInfo;
    }
    
    NSDictionary *company = [[dict objectForKey:@"work_info"] lastObject];
    if(company) {
        NSString *name = [company objectForKey:@"company_name"];
        NSString *date = [company objectForKey:@"start_date"];
        NSString *companyInfo = [NSString stringWithFormat:@"%@ %@", name, date];
        result.workHistory = companyInfo;
    }
    
    return result;
}

+ (RenrenDetail *)detailWithID:(NSString *)userID inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:@"RenrenDetail" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"ownerID == %@", userID]];
    
    RenrenDetail *res = [[context executeFetchRequest:request error:NULL] lastObject];
    
    [request release];
    
    return res;
}

@end
