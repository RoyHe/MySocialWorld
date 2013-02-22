//
//  NewFeedDetailBlogViewCell.h
//  SocialFusion
//
//  Created by He Ruoyun on 12-1-29.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlogDetailController.h"
@interface NewFeedDetailBlogViewCell : UITableViewCell
{
     IBOutlet BlogDetailController* _detailController;
}
@property (nonatomic, retain) BlogDetailController* detailController;

- (void)initWithFeedData:(NewFeedRootData*)_feedData  context:(NSManagedObjectContext*)context renren:(RenrenUser*)ren weibo:(WeiboUser*)wei;
@end
