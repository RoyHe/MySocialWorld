//
//  NewFeedAlbumCell.m
//  SocialFusion
//
//  Created by He Ruoyun on 12-2-12.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "NewFeedAlbumCell.h"

@implementation NewFeedAlbumCell
@synthesize detailController=_detailController;

- (void)initWithFeedData:(NewFeedRootData*)_feedData  context:(NSManagedObjectContext*)context renren:(RenrenUser*)ren weibo:(WeiboUser*)wei
{
    _detailController.feedData=_feedData;
    _detailController.managedObjectContext=context;
    _detailController.currentRenrenUser=ren;
    _detailController.currentWeiboUser=wei;
    
}




- (void)dealloc {
    //NSLog(@"Friend List Cell Dealloc");
    
    [_detailController release];
    [super dealloc];
}


@end
