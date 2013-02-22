//
//  LeaveMessageViewController.h
//  SocialFusion
//
//  Created by 王紫川 on 12-1-29.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostViewController.h"
#import "User.h"

@interface LeaveMessageViewController : PostViewController {
    BOOL _useSecretWords;
    BOOL _platformCode;
    User *_processUser;
}

@property (nonatomic, retain) IBOutlet UIButton *secretWordsTitleButton;
@property (nonatomic, retain) IBOutlet UIButton *secretWordsLightButton;

- (id)initWithUser:(User *)usr;

- (IBAction)didClickSecretWordsButton:(id)sender;

@end
