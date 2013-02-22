//
//  WBWebDialogViewController.h
//  SocialFusion
//
//  Created by He Ruoyun on 12-2-25.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ROBaseDialogViewController.h"
#import "OAAsynchronousDataFetcher.h"
#import "OAToken.h"
#import "OAServiceTicket.h"

@protocol WBDialogDelegate;

@interface WBWebDialogViewController : ROBaseDialogViewController<UIWebViewDelegate>
{
    id<WBDialogDelegate> _delegate;
    NSMutableDictionary *_params;
    NSString * _serverURL;
    NSURL* _loadingURL;
    UIWebView* _webView;
    UIActivityIndicatorView* _spinner;
    UIImageView* _iconView;
        UIActivityIndicatorView *_indicatorView;
    //UIDeviceOrientation _orientation;
   // BOOL _showingKeyboard;
    UIView* _modalBackgroundView;
}
@property(nonatomic,assign) id<WBDialogDelegate> delegate;



- (NSString *) getStringFromUrl: (NSString*) url needle:(NSString *) needle;

- (id)initWithURL: (NSString *) loadingURL
           params: (NSMutableDictionary *) params
         delegate: (id <WBDialogDelegate>) delegate;

- (NSDictionary*)parseURLParams:(NSString *)query;

- (void) errormsg:(NSString*) errorReason;



- (void)load;

- (void)loadURL:(NSString*)url
            get:(NSDictionary*)getParams;

//隐藏视图并通知委托成功或者取消
- (void)dismissWithSuccess:(BOOL)success animated:(BOOL)animated;

//隐藏视图并通知委托出现错误
- (void)dismissWithError:(NSError*)error animated:(BOOL)animated;

//子类重载并在显示对话前执行
- (void)dialogWillAppear;

//子类重载并在隐藏对话前执行
- (void)dialogWillDisappear;


- (void)dialogDidSucceed:(NSURL *)url;


- (void)dialogDidCancel:(NSURL *)url;
@end

///////////////////////////////////////////////////////////////////////////////////////////////////

/*
 * 你的应用要实现以下委托
 */
@protocol WBDialogDelegate <NSObject>

@optional

/**
 * dialog 成功调用.
 */
- (void)dialogDidComplete:(WBWebDialogViewController *)dialog;

/**
 * 
 * 当dialog成功调用返回一个url时调用
 */
- (void)dialogCompleteWithUrl:(NSURL *)url;

/**
 * 
 * 当dialog 让用户取消时调用
 */
- (void)dialogDidNotCompleteWithUrl:(NSURL *)url;

- (void)dialogDidNotComplete:(WBWebDialogViewController *)dialog;

/**
 * 当dialog 加载时遇到错误时调用.
 */
- (void)dialog:(WBWebDialogViewController*)dialog didFailWithError:(NSError *)error;

- (BOOL)dialog:(WBWebDialogViewController*)dialog shouldOpenURLInExternalBrowser:(NSURL *)url;

- (void)widgetDialogCompleteWithDict:(NSDictionary*)params;

/**
 * dialog登录授权成功执行
 */
- (void)wbDialogLogin:(NSString*)token;
/**
 * 取消登录时执行
 */
- (void)wbDialogNotLogin:(BOOL)cancelled;
@end
