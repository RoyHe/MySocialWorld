//
//  OAuthHTTPRequest.h
//  PushboxHD
//
//  Created by Xie Hasky on 11-7-23.
//  Copyright 2011年 同济大学. All rights reserved.
//

#import "ASIFormDataRequest.h"

@interface OAuthHTTPRequest : ASIFormDataRequest {
    BOOL _authNeeded;
    
       
    NSString *_access_token;
    
    NSDictionary *_extraOAuthParams;
    NSDictionary *_requestParams;

    
}

@property(nonatomic, assign, getter=isAuthNeeded) BOOL authNeeded;
@property(nonatomic, retain) NSString* access_token;
@property(nonatomic, retain) NSDictionary* extraOAuthParams;
@property(nonatomic, retain) NSDictionary* requestParams;

@end
