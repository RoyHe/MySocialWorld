//
//  BlogDetailController.m
//  SocialFusion
//
//  Created by He Ruoyun on 12-1-29.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "BlogDetailController.h"
#import "NewFeedData.h"
#import "Image+Addition.h"
#import "CommonFunction.h"
#import "RenrenClient.h"
#import "NSString+HTMLSet.h"
#import "NewFeedBlog+NewFeedBlog_Addition.h"
#import "RepostViewController.h"
#import "UIApplication+Addition.h"
@implementation BlogDetailController


-(void) dealloc{
    [_blogDetail release];
    [super dealloc];
}
- (void)loadWebView
{
    
    RenrenClient *renren = [RenrenClient client];
    [renren setCompletionBlock:^(RenrenClient *client) {
        if(!client.hasError) {
            NSDictionary *dic = client.responseJSONObject;
            NSString* content=[dic objectForKey:@"content"];
            NSString *infoSouceFile = [[NSBundle mainBundle] pathForResource:@"blogcelldetail" ofType:@"html"];
            NSString *infoText=[[NSString alloc] initWithContentsOfFile:infoSouceFile encoding:NSUTF8StringEncoding error:nil];
            infoText=[infoText setWeibo:content];
            _blogDetail=[[NSString alloc] initWithString:content];
            infoText=[infoText setBlogTitle:((NewFeedBlog*)self.feedData).title];
            [_webView loadHTMLString:infoText baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
            [infoText release];
            
        }
    }];
    [renren getBlog:[self.feedData getActor_ID] status_ID:[self.feedData getSource_ID]];
    
}


- (void)loadData {
    if(_loadingFlag)
        return;
    _loadingFlag = YES;
    
    RenrenClient *renren = [RenrenClient client];
    [renren setCompletionBlock:^(RenrenClient *client) {
        if(!client.hasError) {
            [self clearData];
            NSArray *array;
            if  (((NewFeedBlog*)self.feedData).shareID!=nil)
            {
                array=[client.responseJSONObject objectForKey:@"comments"];
                
            }
            else
            {
                array   = client.responseJSONObject;
            }
            //    NSLog(@"%@",array);
            [self ProcessRenrenData:array];
            
        }
    }];
    
    if  (((NewFeedBlog*)self.feedData).shareID!=nil)
    {
        [renren getShareComments:((NewFeedBlog*)self.feedData).sharePersonID share_ID:((NewFeedBlog*)self.feedData).shareID pageNumber:_pageNumber];
    }
    else
    {
        
        [renren getBlogComments:[self.feedData getActor_ID] status_ID:[self.feedData getSource_ID] pageNumber:_pageNumber];
    }       
    
}

-(IBAction)repost
{
    RepostViewController *vc = [[RepostViewController alloc] init];
    vc.managedObjectContext = self.managedObjectContext;
    

   
    
        [vc setStyle:kNewBlog];
    
    
    vc.feedData=self.feedData;
    
    vc.blogData=_blogDetail;
    
    [vc setcommentPage:NO];
    [[UIApplication sharedApplication] presentModalViewController:vc];
    [vc release];
}
-(IBAction)comment:(id)sender
{
    UITableViewCell* cell=(UITableViewCell*)((UIButton*)sender).superview.superview;
    NSIndexPath* indexPath=[self.tableView indexPathForCell:cell];
    
    if (_showMoreButton == YES)
    {
        indexPath = [NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section];
    }

    StatusCommentData* data=[self.fetchedResultsController objectAtIndexPath:indexPath];
    RepostViewController *vc = [[RepostViewController alloc] init];
    vc.managedObjectContext = self.managedObjectContext;
    [vc setStyle:kNewBlog];
    
    vc.feedData=self.feedData;
    
    vc.commetData=data;
    vc.blogData=_blogDetail;
    
    [vc setcommentPage:YES];
    [[UIApplication sharedApplication] presentModalViewController:vc];
    [vc release];
}





@end
