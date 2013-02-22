//
//  StatusCommentData+StatusCommentData_Addition.m
//  SocialFusion
//
//  Created by He Ruoyun on 11-11-21.
//  Copyright (c) 2011年 Tongji Apple Club. All rights reserved.
//

#import "StatusCommentData+StatusCommentData_Addition.h"

@implementation StatusCommentData (StatusCommentData_Addition)
+ (StatusCommentData *)insertNewComment:(int)style Dic:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context
{
    
    if (style==0)
    {
  
       // NSLog(@"%@",dict);
        
        
        
        NSString  *comment_ID= [[dict objectForKey:@"comment_id"] stringValue] ;   
        
        
        if (comment_ID==nil || [comment_ID isEqualToString:@""]) {
          comment_ID= [[dict objectForKey:@"id"] stringValue] ;   
        }
        
        StatusCommentData *result = [StatusCommentData feedWithID:comment_ID inManagedObjectContext:context];
        if (!result) {
            result = [NSEntityDescription insertNewObjectForEntityForName:@"StatusCommentData" inManagedObjectContext:context];
        }
        

    result.actor_ID=[[dict objectForKey:@"uid"] stringValue] ;
    
        
        result.style=[NSNumber numberWithInt:0];
   // result.owner_Head= [dict objectForKey:@"tinyurl"];
    
    result.owner_Name=[dict objectForKey:@"name"];
    
    
    NSDateFormatter *form = [[NSDateFormatter alloc] init];
    [form setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    
    NSString* dateString=[dict objectForKey:@"time"];
	result.update_Time=[form dateFromString: dateString];
    
    
    [form release];
    
    
    
    result.comment_ID= comment_ID;
        
        
    
    result.text=[dict objectForKey:@"text"];
    
    if ([[dict objectForKey:@"is_whisper"] intValue]==1)
    {
        result.secret=[NSNumber numberWithBool:YES];
    }
        else
        {
            result.secret=[NSNumber numberWithBool:NO];
        }
 if (result.text==nil)
 {
     result.text=[dict objectForKey:@"content"];
     
 }
    return result;

    }
    else
    {
        
        NSString  *comment_ID= [[dict objectForKey:@"id"] stringValue] ;   
        
        
        if (!comment_ID || [comment_ID isEqualToString:@""]) {
            return nil;
        }
        
        StatusCommentData *result = [StatusCommentData feedWithID:comment_ID inManagedObjectContext:context];
        if (!result) {
            result = [NSEntityDescription insertNewObjectForEntityForName:@"StatusCommentData" inManagedObjectContext:context];
        }

        result.actor_ID=[[[dict objectForKey:@"user"] objectForKey:@"id"] stringValue] ;
        
        //result.owner_Head= [[dict objectForKey:@"user"] objectForKey:@"profile_image_url"];
        
        result.owner_Name=[[dict objectForKey:@"user"] objectForKey:@"screen_name"];
        
        
        NSDateFormatter *form = [[NSDateFormatter alloc] init];
        [form setDateFormat:@"EEE MMM d HH:mm:ss ZZZ yyyy"];
        
        
        NSLocale* tempLocale=[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        [form setLocale:tempLocale];
        [tempLocale release];
        
        NSString* dateString=[dict objectForKey:@"created_at"];

  
        result.update_Time=[form dateFromString: dateString] ;
        [form release];
        
        
        result.comment_ID= [[dict objectForKey:@"id"] stringValue] ;
        
        result.text=[dict objectForKey:@"text"] ;
        result.secret=[NSNumber numberWithBool:NO];
        
        result.style=[NSNumber numberWithInt:1];
        return result;        
        
    }
    
}
+ (StatusCommentData *)feedWithID:(NSString *)statusID inManagedObjectContext:(NSManagedObjectContext *)context;
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"StatusCommentData" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"comment_ID == %@", statusID]];
    StatusCommentData *res = [[context executeFetchRequest:request error:NULL] lastObject];
    [request release];
    return res;
}


+ (void)deleteAllObjectsInManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"StatusCommentData" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSArray *items = [context executeFetchRequest:fetchRequest error:NULL];
    [fetchRequest release];
    
    for (NSManagedObject *managedObject in items) {
        [context deleteObject:managedObject];
    }
}



- (NSDate*)getUpdateTime
{
    return self.update_Time;
}
- (NSString*)getOwner_Name
{
    return self.owner_Name;
}
- (NSString*)getOwner_HEAD
{
    return self.owner_Head;
}
- (NSString*)getText
{
    return self.text;
}
- (NSString*)getHeadURL
{
    return self.owner_Head;
}



@end
