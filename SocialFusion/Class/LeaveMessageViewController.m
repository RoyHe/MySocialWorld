//
//  NewStatusViewController.m
//  SocialFusion
//
//  Created by 王紫川 on 12-1-29.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "LeaveMessageViewController.h"
#import "UIApplication+Addition.h"
#import "RenrenUser+Addition.h"
#import "WeiboUser+Addition.h"
#import "UIButton+Addition.h"
#import "WeiboClient.h"
#import "RenrenClient.h"

@interface LeaveMessageViewController()

@end

@implementation LeaveMessageViewController

@synthesize secretWordsTitleButton = _secretWordsTitleButton;
@synthesize secretWordsLightButton = _secretWordsLightButton;

- (void)dealloc {
    [_secretWordsTitleButton release];
    [_secretWordsLightButton release];
    [_processUser release];
    [super dealloc];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.secretWordsTitleButton = nil;
    self.secretWordsLightButton = nil;
}

- (id)init {
    self = [super init];
    if(self) {
        _useSecretWords = NO;
    }
    return self;
}

- (id)initWithUser:(User *)usr{
    self = [self init];
    if(self) {
        _processUser = [usr retain];
        self.managedObjectContext = usr.managedObjectContext;
        if([usr isMemberOfClass:[RenrenUser class]]) {
            _platformCode = kPlatformRenren;
        }
        else if([usr isMemberOfClass:[WeiboUser class]]) {
            _platformCode = kPlatformWeibo;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if(_platformCode == kPlatformWeibo) {
        self.secretWordsLightButton.hidden = YES;
        self.secretWordsTitleButton.hidden = YES;
        self.textView.text = [NSString stringWithFormat:@"@%@ ", _processUser.name];
    }
    else if(_platformCode == kPlatformRenren) {
        self.secretWordsLightButton.hidden = YES;
        self.secretWordsTitleButton.hidden = YES;
        self.textView.text = [NSString stringWithFormat:@"@%@(%@) ", _processUser.name, _processUser.userID];
    }
}

#pragma mark - 
#pragma mark IBAction

- (IBAction)didClickSecretWordsButton:(id)sender {
    _useSecretWords = !_useSecretWords;
    [self.secretWordsLightButton setPostPlatformButtonSelected:_useSecretWords];
}

- (IBAction)didClickPostButton:(id)sender {
    _postCount = 1;
    if(_platformCode == kPlatformWeibo) {
        WeiboClient *client = [WeiboClient client];
        [client setCompletionBlock:^(WeiboClient *client) {
            if(client.hasError)
                _postStatusErrorCode |= PostStatusErrorWeibo;
            [self postStatusCompletion];
        }];
        [client postStatus:self.textView.text];
    }
    else if(_platformCode == kPlatformRenren) {
        RenrenClient *client = [RenrenClient client];
        [client setCompletionBlock:^(RenrenClient *client) {
            if(client.hasError)
                _postStatusErrorCode |= PostStatusErrorRenren;
            [self postStatusCompletion];
        }];
        [client postStatus:self.textView.text];
    }
    [self dismissView];
}

@end
