//
//  OAuthHTTPRequest.m
//  PushboxHD
//
//  Created by Xie Hasky on 11-7-23.
//  Copyright 2011年 同济大学. All rights reserved.
//

#import "OAuthHTTPRequest.h"
#import <CommonCrypto/CommonHMAC.h>
#import "NSString+URLEncoding.h"
#import "Base64Transcoder.h"

@implementation OAuthHTTPRequest

@synthesize authNeeded = _authNeeded;

@synthesize extraOAuthParams = _extraOAuthParams;
@synthesize requestParams = _requestParams;
@synthesize access_token=_access_token;



- (id)initWithURL:(NSURL *)newURL
{
    self = [super initWithURL:newURL];
    
 
    
    return self;
}



- (void)dealloc
{

    [_extraOAuthParams release];
    [_requestParams release];

    [super dealloc];
}

@end
