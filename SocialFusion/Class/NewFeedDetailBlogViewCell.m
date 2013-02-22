//
//  NewFeedDetailBlogViewCell.m
//  SocialFusion
//
//  Created by He Ruoyun on 12-1-29.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "NewFeedDetailBlogViewCell.h"

@implementation NewFeedDetailBlogViewCell
@synthesize detailController=_detailController;
- (void)initWithFeedData:(NewFeedRootData*)_feedData  context:(NSManagedObjectContext*)context renren:(RenrenUser*)ren weibo:(WeiboUser*)wei
{
    _detailController.feedData=_feedData;
    _detailController.managedObjectContext=context;
    _detailController.currentRenrenUser=ren;
    _detailController.currentWeiboUser=wei;
    
    //  [self.contentView addSubview:detailController.view];
}




- (void)dealloc {
    //NSLog(@"Friend List Cell Dealloc");
    [_detailController release];
    
    [super dealloc];
}


@end
