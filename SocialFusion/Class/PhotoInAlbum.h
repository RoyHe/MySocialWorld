//
//  PhotoInAlbum.h
//  SocialFusion
//
//  Created by He Ruoyun on 12-2-14.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoInAlbum : UIView
{
    UIImageView* _imageView;
    UIButton* _imageOut;
    UILabel* _captian;
    
}
@property(nonatomic, retain)  UIImageView* imageView;
@property(nonatomic, retain)  UIButton* imageOut;
@property(nonatomic, retain)  UILabel* captian;
- (id)init;
- (void)hideCaptian;
- (void)showCaptian;

@end
