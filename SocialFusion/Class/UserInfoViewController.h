//
//  UserInfoViewController.h
//  SocialFusion
//
//  Created by 王紫川 on 12-2-12.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataViewController.h"
#import "User.h"

typedef enum {
    kRenrenUserInfo = 0,
    kWeiboUserInfo  = 1,
} kUserInfoType;

@interface UserInfoViewController : CoreDataViewController {
    kUserInfoType _type;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIImageView *photoImageView;
@property (nonatomic, retain) IBOutlet UIView *photoView;

@property (nonatomic, retain) IBOutlet UILabel *genderLabel;
@property (nonatomic, retain) IBOutlet UIButton *followButton;
@property (nonatomic, retain) IBOutlet UIButton *atButton;
@property (nonatomic, retain) IBOutlet UILabel *relationshipLabel;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;

@property (nonatomic, readonly) User *processUser;
@property (nonatomic, readonly) NSString *headImageURL;
@property (nonatomic, readonly) NSString *processUserGender;

- (id)initWithType:(kUserInfoType)type;
+ (UserInfoViewController *)getUserInfoViewControllerWithType:(kUserInfoType)type;

- (void)configureUI;

- (IBAction)didClickAtButton;
- (IBAction)didClickPhotoFrameButton;

@end
