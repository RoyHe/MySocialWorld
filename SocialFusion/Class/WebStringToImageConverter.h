//
//  WebStringToImageConverter.h
//  SocialFusion
//
//  Created by He Ruoyun on 12-2-17.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol WebStringToImageConverterDelegate;

@interface WebStringToImageConverter : NSObject<UIWebViewDelegate>
{
    id<WebStringToImageConverterDelegate> _delegate;
}

@property (nonatomic, assign) id<WebStringToImageConverterDelegate> delegate;

-(void)startConvertBlogWithTitle:(NSString*)title detail:(NSString*)string;
+(WebStringToImageConverter*) webStringToImage;

@end


@protocol WebStringToImageConverterDelegate<NSObject>

- (void)webStringToImageConverter:(WebStringToImageConverter *)converter  didFinishLoadWebViewWithImage:(UIImage*)image;

@end

