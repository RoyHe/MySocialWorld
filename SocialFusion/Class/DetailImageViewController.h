//
//  DetailImageViewController.h
//  SocialFusion
//
//  Created by He Ruoyun on 12-1-16.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DetailImageViewControllerDelegate;

@interface DetailImageViewController : UIViewController<UIScrollViewDelegate, UIWebViewDelegate>

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIButton *saveButton;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityView;
@property (nonatomic, assign) id<DetailImageViewControllerDelegate> delegate;

- (IBAction)didClickSaveButton:(id)sender;

+ (DetailImageViewController *)showDetailImageWithURL:(NSString*)bigURL context:(NSManagedObjectContext *)context;
+ (DetailImageViewController *)showDetailImageWithRenrenUserID:(NSString*)userID photoID:(NSString *)photoID context:(NSManagedObjectContext *)context;
+ (DetailImageViewController *)showDetailImageWithImage:(UIImage *)image;

@end

@protocol DetailImageViewControllerDelegate <NSObject>

@optional
- (void)didFinishShow;

@end

