//
//  PublicationViewController.m
//  SocialFusion
//
//  Created by 王紫川 on 12-1-29.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "PublicationViewController.h"
#import "NewStatusViewController.h"
#import "UIApplication+Addition.h"
#import "NewBlogViewController.h"

@implementation PublicationViewController

@synthesize scrollView = _scrollView;

- (void)dealloc {
    [_scrollView release];
    [super dealloc];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.scrollView = nil;
}

- (void)viewDidLoad {
   [super viewDidLoad];

    
    self.view.frame = CGRectMake(0, 0, 306, [UIScreen mainScreen].bounds.size.height-480+389);
    self.scrollView.scrollsToTop = NO;
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height + 1);
}

#pragma mark -
#pragma mark IBActions

- (IBAction)didClickNewStatusButton:(id)sender  {
    NewStatusViewController *vc = [[NewStatusViewController alloc] init];
    
    vc.managedObjectContext = self.managedObjectContext;
    [[UIApplication sharedApplication] presentModalViewController:vc];
    [vc release];
}

- (IBAction)didClickNewBlogButton:(id)sender {
    NewBlogViewController *vc = [[NewBlogViewController alloc] init];
    vc.managedObjectContext = self.managedObjectContext;
    [[UIApplication sharedApplication] presentModalViewController:vc];
    [vc release];
}

@end