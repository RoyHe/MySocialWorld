//
//  NewStatusViewController.m
//  SocialFusion
//
//  Created by 王紫川 on 12-1-29.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "NewStatusViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIApplication+Addition.h"
#import "RenrenClient.h"
#import "WeiboClient.h"
#import "UIImageView+Addition.h"
#import "UIButton+Addition.h"
#import "NSString+WeiboSubString.h"
#import "RenrenUser+Addition.h"
#import "WeiboUser+Addition.h"

#define USER_PHOTO_CENTER CGPointMake(260.0f, 29.0f)
#define USER_PHOTO_HIDDEN_CENTER CGPointMake(260.0f, 150.0f)

#define USER_PHOTO_SIDE_LENGTH 40.0f

@interface NewStatusViewController()
- (void)dismissUserPhoto;
@end

@implementation NewStatusViewController

@synthesize postRenrenButton = _postRenrenButton;
@synthesize postWeiboButton = _postWeiboButton;
@synthesize navigation = _navigation;

@synthesize photoView = _photoView;
@synthesize photoImageView = _photoImageView;
@synthesize photoCancelButton = _photoCancelButton; 
@synthesize processUser = _processUser;

- (void)dealloc {
    [_postRenrenButton release];
    [_postWeiboButton release];
    [_photoView release];
    [_photoImageView release];
    [_photoCancelButton release];
    [_processUser release];
    [_navigation release];
    [super dealloc];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.postRenrenButton = nil;
    self.postWeiboButton = nil;
    self.photoView = nil;
    self.photoImageView = nil;
    self.photoCancelButton = nil;
}

- (id)init {
    self = [super init];
    if(self) {
        _postToRenren = NO;
        _postToWeibo = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.postRenrenButton setSelected:_postToRenren];
    [self.postWeiboButton setSelected:_postToWeibo];
    
    self.photoView.hidden = YES;
    
    if (self.processUser) {
        if([self.processUser isKindOfClass:[WeiboUser class]])
            self.textView.text = [NSString stringWithFormat:@"@%@ ", self.processUser.name];
        else if([self.processUser isKindOfClass:[RenrenUser class]])
            self.textView.text = [NSString stringWithFormat:@"@%@(%@) ", self.processUser.name, self.processUser.userID];
    }
}

#pragma mark -
#pragma mark IBActions

- (IBAction)didClickPostButton:(id)sender {
    _postCount = 0;
    _postStatusErrorCode = PostStatusErrorNone;
    if(!_postToWeibo && !_postToRenren) {
        [[UIApplication sharedApplication] presentToast:@"请选择发送平台。" withVerticalPos:TOAST_POS_Y];
        return;
    }
    if([self.textView.text isEqualToString:@""] && !self.photoImageView.image) {
        [[UIApplication sharedApplication] presentToast:@"请输入内容或添加照片。" withVerticalPos:TOAST_POS_Y];
        return;
    }
    
    if(_postToWeibo) {
        WeiboClient *client = [WeiboClient client];
        [client setCompletionBlock:^(WeiboClient *client) {
            if(client.hasError)
                _postStatusErrorCode |= PostStatusErrorWeibo;
            [self postStatusCompletion];
        }];
        _postCount++;
        if (self.photoImageView.image) {
            if (_located == NO)
            {
                [client postStatus:[self.textView.text getStatusSubstringWithCount:WEIBO_MAX_WORD] withImage:self.photoImageView.image];
            }
            else
            {
                [client postStatus:[self.textView.text getStatusSubstringWithCount:WEIBO_MAX_WORD] withImage:self.photoImageView.image latitude:_location2D.latitude longitude:_location2D.longitude];
            }
        }
        else {
            if (_located == NO)
            {
                [client postStatus:[self.textView.text getStatusSubstringWithCount:WEIBO_MAX_WORD] ];
            }
            else
            {
                [client postStatus:[self.textView.text getStatusSubstringWithCount:WEIBO_MAX_WORD] latitude:_location2D.latitude longitude:_location2D.longitude ];
                
            }
        }
    }
    
    if(_postToRenren) {
        RenrenClient *client = [RenrenClient client];
        [client setCompletionBlock:^(RenrenClient *client) {
            if(client.hasError)
                _postStatusErrorCode |= PostStatusErrorRenren;
            [self postStatusCompletion];
        }];
        _postCount++;
        if (self.photoImageView.image) {
            [client postStatus:self.textView.text withImage:self.photoImageView.image];
        }
        else {
            [client postStatus:self.textView.text];
        }
    }
    [self dismissView];
}

- (IBAction)didClickPostToRenrenButton:(id)sender {
    _postToRenren = !_postToRenren;
    [self.postRenrenButton setPostPlatformButtonSelected:_postToRenren];
}

- (IBAction)didClickPostToWeiboButton:(id)sender {
    _postToWeibo = !_postToWeibo;
    [self.postWeiboButton setPostPlatformButtonSelected:_postToWeibo];
}

- (IBAction)didClickPhotoCancelButton:(id)sender {
    [self dismissUserPhoto];
}

- (IBAction)didClickPickImageButton:(id)sender {
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
    ipc.delegate = self;
    ipc.allowsEditing = NO;
    [self presentModalViewController:ipc animated:YES]; 
}

- (IBAction)didClickPhotoFrameButton:(id)sender {
    [self.textView resignFirstResponder];
    DetailImageViewController *vc = [DetailImageViewController showDetailImageWithImage:self.photoImageView.image];
    vc.saveButton.hidden = YES;
    vc.delegate = self;
}

#pragma mark -
#pragma mark DetailImageViewController delegate

- (void)didFinishShow {
    [self.textView becomeFirstResponder];
}

#pragma mark -
#pragma mark pick photo methods

- (void)showPhotoCancelButton {
    self.photoCancelButton.hidden = NO;
    self.photoCancelButton.alpha = 0;
    [UIView animateWithDuration:0.3f delay:0.2f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.photoCancelButton.alpha = 1;
    } completion:^(BOOL finished) {
        self.photoCancelButton.userInteractionEnabled = YES;
    }];
}

- (void)hidePhotoCancelButton {
    self.photoCancelButton.alpha = 1;
    self.photoCancelButton.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.3f delay:0.2f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.photoCancelButton.alpha = 0;
    } completion:^(BOOL finished) {
        self.photoCancelButton.hidden = YES;
    }];
}

- (void)presentUserPhoto:(UIImage *)image {
    self.photoView.hidden = NO;
    if(!self.photoImageView.image) {
        self.photoImageView.image = image;
        [self.photoImageView centerizeWithSideLength:USER_PHOTO_SIDE_LENGTH];
        self.photoView.center = USER_PHOTO_HIDDEN_CENTER;
        [UIView animateWithDuration:0.3f animations:^{
            self.photoView.center = USER_PHOTO_CENTER;
        } completion:^(BOOL finished) {
            [self showPhotoCancelButton];
        }];
    }
    else {
        UIImageView *oldImageView = [[UIImageView alloc] initWithImage:self.photoImageView.image];
        oldImageView.frame = self.photoImageView.frame;
        self.photoImageView.image = image;
        [self.photoImageView centerizeWithSideLength:USER_PHOTO_SIDE_LENGTH];
        self.photoImageView.alpha = 0;
        [self.photoView insertSubview:oldImageView aboveSubview:self.photoImageView];
        [UIView animateWithDuration:0.3f animations:^{
            self.photoImageView.alpha = 1;
        }];
        oldImageView.alpha = 1;
        [UIView animateWithDuration:0.3f animations:^{
            oldImageView.alpha = 0;
        } completion:^(BOOL finished) {
            [oldImageView removeFromSuperview];
        }];
    }
}

- (void)dismissUserPhoto {
    self.photoView.center = USER_PHOTO_CENTER;
    [UIView animateWithDuration:0.3f animations:^{
        self.photoView.center = USER_PHOTO_HIDDEN_CENTER;
    } completion:^(BOOL finished) {
        self.photoImageView.image = nil;
        self.photoView.hidden = YES;
    }];
    [self hidePhotoCancelButton];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        [self presentUserPhoto:image];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - 
#pragma mark Override methods

- (void)showTextWarning
{
    NSInteger textCount = [self.textCountLabel.text integerValue];
    if ((textCount >= WEIBO_MAX_WORD) && (_lastTextViewCount < WEIBO_MAX_WORD))
    {
        [[UIApplication sharedApplication] presentToast:@"超出140字部分将不会发送至新浪微博。" withVerticalPos:TOAST_POS_Y];
    }
    if ((textCount >= RENREN_MAX_WORD) && (_lastTextViewCount < RENREN_MAX_WORD))
    {
        [[UIApplication sharedApplication] presentToast:@"超出240字部分将不会发送至人人网。" withVerticalPos:TOAST_POS_Y];
    }
    _lastTextViewCount=textCount;
}



- (IBAction)didClickNavigationButton
{
    if (_located == NO)
    {
        CLLocationManager* locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        // 启动GPS信息回调
        [locationManager startUpdatingLocation];
        _navigation.selected = YES;
    }
    else
    {
        _located = NO;
        _navigation.selected = NO;
        
    }
}


//实现代理方法
- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    _located = YES;
    _location2D = newLocation.coordinate;    
    
    [manager stopUpdatingLocation];
    [manager release];
}

@end
