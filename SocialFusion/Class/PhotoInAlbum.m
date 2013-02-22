//
//  PhotoInAlbum.m
//  SocialFusion
//
//  Created by He Ruoyun on 12-2-14.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "PhotoInAlbum.h"

#define IMAGE_OUT_V_SPACE 20
#define IMAGE_OUT_WIDTH 83
#define IMAGE_OUT_H_SPACE 17
#define IMAGE_OUT_HEIGHT 66

@implementation PhotoInAlbum
@synthesize imageOut=_imageOut;
@synthesize imageView=_imageView;
@synthesize captian=_captian;


-(void)dealloc
{
    [_captian release];
    [_imageOut release];
    [_imageView release];
    [super dealloc];
}
- (id)init
{
    self=[super init];
    
    
    _captian=[[UILabel alloc] init];
    _captian.textAlignment=UITextAlignmentCenter;
    _captian.font=[UIFont systemFontOfSize:10];
    
    _imageOut=[[UIButton alloc] init];
    _imageView=[[UIImageView alloc] init];

    
    _imageOut.adjustsImageWhenHighlighted=NO;
    _imageOut.frame=CGRectMake(0,0,IMAGE_OUT_WIDTH, IMAGE_OUT_HEIGHT);
    [_imageOut setImage:[UIImage imageNamed:@"detail_photo"] forState:UIControlStateNormal];

    _imageView.frame=CGRectMake(3, 5, IMAGE_OUT_WIDTH-6, IMAGE_OUT_HEIGHT-10);
    [self addSubview:_imageView];
    [self addSubview:_imageOut];
    
    _imageView.contentMode=UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds=YES;
    
    
    CGRect textRect=_imageOut.frame;
    textRect.origin.y=textRect.origin.y+IMAGE_OUT_HEIGHT;
    textRect.size.height=15;
    _captian.frame=textRect;
    _captian.backgroundColor=[UIColor clearColor];
    [self showCaptian];
    
    return self;
}

- (void)hideCaptian
{
    [_captian removeFromSuperview];
}
- (void)showCaptian
{
    if (_captian.superview==nil)
    {
    [self addSubview:_captian];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
