//
//  RenrenUserInfoViewController.m
//  SocialFusion
//
//  Created by 王紫川 on 12-2-17.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "RenrenUserInfoViewController.h"
#import "RenrenUser+Addition.h"
#import "RenrenClient.h"

@interface RenrenUserInfoViewController()
- (void)configureRelationshipUI;
@end

@implementation RenrenUserInfoViewController

@synthesize birthDayLabel = _birthDayLabel;
@synthesize hometownLabel = _hometownLabel;
@synthesize highSchoolLabel = _highSchoolLabel;
@synthesize universityLabel = _universityLabel;
@synthesize companyLabel = _companyLabel;

- (void)dealloc {
    [_birthDayLabel release];
    [_hometownLabel release];
    [_companyLabel release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.birthDayLabel = nil;
    self.hometownLabel = nil;
    self.highSchoolLabel = nil;
    self.universityLabel = nil;
    self.companyLabel = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureUI];
    RenrenClient *renren = [RenrenClient client];
    [renren setCompletionBlock:^(RenrenClient *client) {
        if (!renren.hasError) {
            NSArray *result = client.responseJSONObject;
            NSDictionary* dict = [result lastObject];
            self.renrenUser = [RenrenUser insertUser:dict inManagedObjectContext:self.managedObjectContext];
            [self configureUI];
        };
    }];
	[renren getUserInfoWithUserID:self.renrenUser.userID];
}

- (void)configureUI {
    [super configureUI];
    
    self.birthDayLabel.text = self.renrenUser.detailInfo.birthday;
    self.hometownLabel.text = self.renrenUser.detailInfo.hometownLocation;
    self.universityLabel.text = self.renrenUser.detailInfo.universityHistory;
    self.companyLabel.text = self.renrenUser.detailInfo.workHistory;
    self.highSchoolLabel.text = self.renrenUser.detailInfo.highSchoolHistory;
    self.nameLabel.text = self.renrenUser.name;
    [self configureRelationshipUI];
}

- (void)configureRelationshipUI
{
    if ([self.renrenUser isEqualToUser:self.currentRenrenUser]) {
        self.followButton.hidden = YES;
        self.relationshipLabel.text = @"当前人人网用户。";
        self.atButton.hidden = YES;
    }
    else {
        RenrenClient *client = [RenrenClient client];
        [client setCompletionBlock:^(RenrenClient *client) {
            if(!client.hasError) {
                NSArray *array = client.responseJSONObject;
                NSDictionary *dict = array.lastObject;
                NSString *isFriend = [[dict objectForKey:@"are_friends"] stringValue];
                if([isFriend isEqualToString:@"0"]) {
                    self.relationshipLabel.text = [NSString stringWithFormat:@"%@不是你的好友。", self.renrenUser.name];
                }
                else {
                    self.relationshipLabel.text = [NSString stringWithFormat:@"%@是你的好友。", self.renrenUser.name];
                }
            }
        }];
        [client getRelationshipWithUserID:self.renrenUser.userID andAnotherUserID:self.currentRenrenUser.userID];
    }
}

- (User *)processUser {
    return self.renrenUser;
}

- (NSString *)headImageURL {
    return self.renrenUser.detailInfo.mainURL;
}

- (NSString *)processUserGender {
    return self.renrenUser.detailInfo.gender;
}

@end
