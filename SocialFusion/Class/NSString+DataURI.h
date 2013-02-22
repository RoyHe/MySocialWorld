//
//  NSString+DataURI.h
//  SocialFusion
//
//  Created by He Ruoyun on 12-1-9.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DataURI)
- (NSString *)pngDataURIWithContent;
- (NSString *)jpgDataURIWithContent;
@end
