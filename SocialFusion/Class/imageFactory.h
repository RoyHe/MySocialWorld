//
//  imageFactory.h
//  SocialFusion
//
//  Created by He Ruoyun on 11-10-25.
//  Copyright (c) 2011年 TJU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface imageFactory : NSObject

{
    imageFactory* _imageFactory;
    NSMutableDictionary* _image;
}
-(id)init;
+(imageFactory*)SharedImageFactory;
-(UIImage*)GetImage:(NSString*)url;
@end
