//
//  ShowImage.h
//  SocialFusion
//
//  Created by He Ruoyun on 12-1-16.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewFeedTempImageView : UIView<UIScrollViewDelegate>
{
    UIImageView* _imageView;
    UIButton* _saveButton;
    UIScrollView* _scrollView;
    NSString* _bigURL;
    NSManagedObjectContext *_managedObjectContext;

    NSString* _userID;
    NSString* _photoID;
    

}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, copy) NSString *bigURL;
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *photoID;

+ (NewFeedTempImageView *)tempImageViewWithImage:(UIImage*)image BigURL:(NSString*)bigURL context:(NSManagedObjectContext *)context;

+ (NewFeedTempImageView *)tempImageViewWithImage:(UIImage*)image userID:(NSString*)userID photoID:(NSString*)photoID context:(NSManagedObjectContext *)context;

+ (NewFeedTempImageView *)tempImageViewWithImage:(UIImage*)image ;
- (void)show;


@end

