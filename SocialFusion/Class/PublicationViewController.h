//
//  PublicationViewController.h
//  SocialFusion
//
//  Created by 王紫川 on 12-1-29.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataViewController.h"

@interface PublicationViewController : CoreDataViewController {
    UIScrollView *_scrollView;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;

- (IBAction)didClickNewStatusButton:(id)sender;
- (IBAction)didClickNewBlogButton:(id)sender;

@end
