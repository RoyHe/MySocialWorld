//
//  ShowImage.m
//  SocialFusion
//
//  Created by He Ruoyun on 12-1-16.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "NewFeedTempImageView.h"
#import  <QuartzCore/QuartzCore.h>
#import "Image+Addition.h"
#import "UIImage+Addition.h"
#import "RenrenClient.h"
#import "UIApplication+Addition.h"
#define IMAGE_MAX_WIDTH     260
#define IMAGE_MAX_HEIGHT    480

@implementation NewFeedTempImageView

@synthesize managedObjectContext = _managedObjectContext;
@synthesize bigURL = _bigURL;
@synthesize userID = _userID;
@synthesize photoID = _photoID;



- (void)dealloc {
    NSLog(@"ShowImage dealloc");
    [_bigURL release];
    [_userID release];
    [_photoID release];
    [_imageView release];
    [_scrollView release];
    [_managedObjectContext release];
    [_saveButton release];
    [super dealloc];
}

- (id)init {
    self = [super init];
    if(self) {
        
        self.frame = CGRectMake(0, 0, 320, 480);
        
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.maximumZoomScale = 3;
        _scrollView.delegate = self;
        
        /*
        //设置layer
        CALayer *layer=[_scrollView layer];
        //是否设置边框以及是否可见
        [layer setMasksToBounds:YES];
        //设置边框圆角的弧度
        [layer setCornerRadius:10.0];
    */
        [self addSubview:_scrollView];
        

        
        
        _saveButton = [[UIButton alloc] init];
        _saveButton.frame = CGRectMake(0, 0, 90.0f, 40.0f);
        _saveButton.center = CGPointMake(160.0f, 440.0f);

        [_saveButton setImage:[UIImage imageNamed:@"btn_tmp_pic_save@2x.png"] forState:UIControlStateNormal];
        [_saveButton addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_saveButton];
        self.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8f];
        
        
        UITapGestureRecognizer* gesture;
        gesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissView)];
        [_scrollView addGestureRecognizer:gesture];
        [gesture release];
    }
    return self;
}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if(!error) {
        [[UIApplication sharedApplication] presentToast:@"保存成功了亲。" withVerticalPos:kToastBottomVerticalPosition];
    }
    else {
        [[UIApplication sharedApplication] presentToast:@"保存失败了亲。" withVerticalPos:kToastBottomVerticalPosition];
    }
}

- (void)saveImageInBackground {
    UIImageWriteToSavedPhotosAlbum(_imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)saveImage
{
    [self performSelectorInBackground:@selector(saveImageInBackground) withObject:nil];
}

- (void)dismissView
{
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade   ];
        
                 [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        
        [self removeFromSuperview];
        [self release];
    }];
}

- (void)setImage:(UIImage *)image {
    _imageView = [[UIImageView alloc] initWithImage:image];
    _imageView.frame = CGRectMake(0, 0, IMAGE_MAX_WIDTH, image.size.height / image.size.width * IMAGE_MAX_WIDTH);
    CGFloat imageHeight = _imageView.frame.size.height;
    if (imageHeight >= IMAGE_MAX_HEIGHT) {
        _scrollView.frame = CGRectMake(0, 0, IMAGE_MAX_WIDTH, IMAGE_MAX_HEIGHT);
    }
    else {
        _scrollView.frame = CGRectMake(0, 0, IMAGE_MAX_WIDTH, imageHeight);
    }
    _scrollView.center = CGPointMake(160, 240);
    _scrollView.contentSize = _imageView.frame.size;
    
    /*
    CALayer* layer=[_imageView layer];
    
    
    
    
    
    [layer setMasksToBounds:YES];
    
    [layer setCornerRadius:10.0];
     */
    
    [_scrollView addSubview:_imageView];
}

+ (NewFeedTempImageView *)tempImageViewWithImage:(UIImage*)image BigURL:(NSString*)bigURL context:(NSManagedObjectContext *)context {
    NewFeedTempImageView *result = nil;
    if(image && bigURL) {
        result = [[NewFeedTempImageView alloc] init];
        result.bigURL = bigURL;
        result.managedObjectContext = context;
        [result setImage:image];
    }
    return result;
}

+ (NewFeedTempImageView *)tempImageViewWithImage:(UIImage*)image userID:(NSString*)userID photoID:(NSString*)photoID context:(NSManagedObjectContext *)context {
    NewFeedTempImageView *result = nil;
    if(image && userID && photoID) {
        result = [[NewFeedTempImageView alloc] init];
        result.userID = userID;
        result.photoID = photoID;
        result.managedObjectContext = context;
        [result setImage:image];
    }
    return result;
}



+ (NewFeedTempImageView *)tempImageViewWithImage:(UIImage*)image
{
    NewFeedTempImageView *result = nil;
    if(image) {
        result = [[NewFeedTempImageView alloc] init];

        [result setImage:image];
    }
    return result; 
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self dismissView];
}
 

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    
  

    scrollView.frame=CGRectMake(scrollView.frame.origin.x, scrollView.frame.origin.y, _imageView.frame.size.width, _imageView.frame.size.height);
    
    if (scrollView.frame.size.width>320)
    {
        scrollView.frame=CGRectMake(scrollView.frame.origin.x, scrollView.frame.origin.y,320   , scrollView.frame.size.height);
    }
    if  (scrollView.frame.size.height>480)
    {
        scrollView.frame=CGRectMake(scrollView.frame.origin.x, scrollView.frame.origin.y,scrollView.frame.size.width  , 480);

    }
    scrollView.center=CGPointMake(160, 240);
}

- (void)loadImage {
    if (_bigURL != nil) {
        Image* image = [Image imageWithURL:_bigURL inManagedObjectContext:_managedObjectContext];
        if (!image) {
            [UIImage loadImageFromURL:_bigURL completion:^{
                Image *image1 = [Image imageWithURL:_bigURL inManagedObjectContext:_managedObjectContext];
                [_imageView setImage:[UIImage imageWithData:image1.imageData.data]];
                
            } cacheInContext:_managedObjectContext];
        }
        else {
            [_imageView setImage:[UIImage imageWithData:image.imageData.data]];
        }
    }   
    else {
        
        if (_userID!=nil)
        {
        RenrenClient *renren = [RenrenClient client];
        
        [renren setCompletionBlock:^(RenrenClient *client) {
            if (!client.hasError) {
                
                NSArray *array = client.responseJSONObject;
                for(NSDictionary *dict in array) {
                    NSString* bigPhoto=[dict objectForKey:@"url_large"];
                    
                    Image  * image = [Image imageWithURL:bigPhoto inManagedObjectContext:_managedObjectContext];
                    if (!image) {
                        [UIImage loadImageFromURL:bigPhoto completion:^{
                            Image *image1 = [Image imageWithURL:bigPhoto inManagedObjectContext:_managedObjectContext];
                            [_imageView setImage:[UIImage imageWithData:image1.imageData.data]];
                            
                        } cacheInContext:_managedObjectContext];
                    }
                    else {
                        [_imageView setImage:[UIImage imageWithData:image.imageData.data]];
                    }
                }
            }
        }];
        [renren getSinglePhoto:_userID photoID:_photoID];
        }
    }
}

- (void)startAnimation {
    _scrollView.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
    [UIView animateWithDuration:0.3f animations:^{
        _scrollView.transform=CGAffineTransformMakeScale(1.0f, 1.0f);
    }];
    [self loadImage];
}

- (void)didMoveToWindow {
    [self startAnimation];
}

- (void)show {
    self.alpha = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade   ];
    [UIApplication sharedApplication].keyWindow.frame=CGRectMake(0, 0, 320, 480);
    
 
    // [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = 1;
    }];
}

@end
