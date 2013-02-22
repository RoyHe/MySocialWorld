//
//  UserInfoViewController.m
//  SocialFusion
//
//  Created by 王紫川 on 12-2-12.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UserInfoViewController.h"
#import "RenrenUser+Addition.h"
#import "WeiboUser+Addition.h"
#import "RenrenUserInfoViewController.h"
#import "WeiboUserInfoViewController.h"
#import "UIImageView+Addition.h"
#import "Image+Addition.h"
#import "UIApplication+Addition.h"
#import "DetailImageViewController.h"
#import "NewStatusViewController.h"

#define PHOTO_FRAME_SIDE_LENGTH 100.0f

@interface UserInfoViewController()
@end

@implementation UserInfoViewController

@synthesize scrollView = _scrollView;
@synthesize photoImageView = _photoImageView;
@synthesize photoView = _photoView;

@synthesize genderLabel = _genderLabel;
@synthesize followButton = _followButton;
@synthesize atButton = _atButton;
@synthesize relationshipLabel = _relationshipLabel;
@synthesize nameLabel = _nameLabel;

- (void)dealloc {
    [_scrollView release];
    [_photoImageView release];
    [_genderLabel release];
    [_photoView release];
    [_followButton release];
    [_atButton release];
    [_relationshipLabel release];
    [_nameLabel release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.scrollView = nil;
    self.photoImageView = nil;
    self.genderLabel = nil;
    self.photoView = nil;
    self.followButton = nil;
    self.atButton = nil;
    self.relationshipLabel = nil;
    self.nameLabel = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.frame = CGRectMake(0, 0, 306, 389+[UIScreen mainScreen].bounds.size.height-480);
    self.scrollView.frame = self.view.frame;
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height + 1);
    
    self.photoView.layer.masksToBounds = YES;
    self.photoView.layer.cornerRadius = 5.0f;
    
    self.relationshipLabel.text = nil;
    
    self.scrollView.scrollsToTop = NO;
    

}

+ (UserInfoViewController *)getUserInfoViewControllerWithType:(kUserInfoType)type {
    UserInfoViewController *vc;
    if(type == kRenrenUserInfo)
        vc = [[[RenrenUserInfoViewController alloc] initWithType:type] autorelease];
    else if(type == kWeiboUserInfo)
        vc = [[[WeiboUserInfoViewController alloc] initWithType:type] autorelease];
    return vc;
}

- (id)initWithType:(kUserInfoType)type {
    self = [super init];
    if(self) {
        _type = type;
    }
    return self;
}

- (void)configureUI {
    self.nameLabel.text = self.processUser.name;
    
    if(self.photoImageView.image == nil) {
        Image *image = [Image imageWithURL:self.headImageURL inManagedObjectContext:self.managedObjectContext];
        if (image == nil) {
            [self.photoImageView loadImageFromURL:self.headImageURL completion:^{
                [self.photoImageView centerizeWithSideLength:PHOTO_FRAME_SIDE_LENGTH];
                [self.photoImageView fadeIn];
            } cacheInContext:self.managedObjectContext];
        }
        else {
            self.photoImageView.image = [UIImage imageWithData:image.imageData.data];
            [self.photoImageView centerizeWithSideLength:PHOTO_FRAME_SIDE_LENGTH];
        }
    }
    
    if([self.processUserGender isEqualToString:@"m"]) 
        self.genderLabel.text = @"男";
    else if([self.processUserGender isEqualToString:@"f"]) 
        self.genderLabel.text = @"女";
    else
        self.genderLabel.text = @"未知";
}

#pragma mark -
#pragma mark IBActions

- (IBAction)didClickAtButton {
    NewStatusViewController *vc = [[NewStatusViewController alloc] init];
    vc.managedObjectContext = self.managedObjectContext;
    vc.processUser = self.processUser;
    [[UIApplication sharedApplication] presentModalViewController:vc];
    [vc release];
}

- (IBAction)didClickPhotoFrameButton {
    if(self.photoImageView.image) {
        [DetailImageViewController showDetailImageWithImage:self.photoImageView.image];
    }
}

- (User *)processUser {
    return nil;
}

- (NSString *)headImageURL {
    return nil;
}

- (NSString *)processUserGender {
    return nil;
}

@end
