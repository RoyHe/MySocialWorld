//
//  NewBlogViewController.m
//  SocialFusion
//
//  Created by He Ruoyun on 12-2-26.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "NewBlogViewController.h"
#import "UIButton+Addition.h"
#import <QuartzCore/QuartzCore.h>
#import "WebStringToImageConverter.h"
#import "WeiboClient.h"
#import "NSString+WeiboSubString.h"
#import "RenrenClient.h"
#import "UIApplication+Addition.h"
#import "NSString+HTMLSet.h"
#define RENREN_BLOG_TITLE_MAX_WORD 100

@interface NewBlogViewController()
@end

@implementation NewBlogViewController

@synthesize blogTextView = _blogTextView;
@synthesize postRenrenButton = _postRenrenButton;
@synthesize postWeiboButton = _postWeiboButton;
@synthesize blogBodyButton = _blogBodyButton;
@synthesize blogTitleButton = _blogTitleButton;
@synthesize scrollView = _scrollView;

- (void)dealloc {
    //NSLog(@"NewBlogViewController dealloc");
    [_blogTextView release];
    [_postRenrenButton release];
    [_postWeiboButton release];
    [_blogBodyButton release];
    [_blogTitleButton release];
    [_scrollView release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.blogTextView = nil;
    self.postRenrenButton = nil;
    self.postWeiboButton = nil;
    self.blogBodyButton = nil;
    self.blogTitleButton = nil;
    self.scrollView = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * 2, self.scrollView.frame.size.height);
    self.blogTextView.text = @"";
    [self didClickBlogTitleButton:nil];
}

#pragma mark -
#pragma mark IBActions

- (IBAction)didClickPostToRenrenButton:(id)sender {
    _postToRenren = !_postToRenren;
    [self.postRenrenButton setPostPlatformButtonSelected:_postToRenren];
}

- (IBAction)didClickPostToWeiboButton:(id)sender {
    _postToWeibo = !_postToWeibo;
    [self.postWeiboButton setPostPlatformButtonSelected:_postToWeibo];
}

- (IBAction)didClickBlogTitleButton:(id)sender {
    _currentPage = 0;
    [self updateTextCount];
    [self.blogBodyButton setPostPlatformButtonSelected:NO];
    [self.blogTitleButton setPostPlatformButtonSelected:YES];
    [self.scrollView scrollRectToVisible:CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];
    [self.textView becomeFirstResponder];
}

- (IBAction)didClickBlogBodyButton:(id)sender {
    _currentPage = 1;
    [self updateTextCount];
    [self.blogBodyButton setPostPlatformButtonSelected:YES];
    [self.blogTitleButton setPostPlatformButtonSelected:NO];
    [self.scrollView scrollRectToVisible:CGRectMake(self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];
    [self.blogTextView becomeFirstResponder];
}


- (IBAction)didClickPostButton:(id)sender {
    
    _postCount = 0;
    _postStatusErrorCode = PostStatusErrorNone;
    
    if(!_postToWeibo && !_postToRenren) {
        [[UIApplication sharedApplication] presentToast:@"请选择发送平台。" withVerticalPos:TOAST_POS_Y];
        return;
    }
    if([self.blogTextView.text isEqualToString:@""]) {
        [[UIApplication sharedApplication] presentToast:@"请输入日志正文。" withVerticalPos:TOAST_POS_Y];
        return;
    }
    if([self.textView.text isEqualToString:@""] && _postToRenren == YES) {
        [[UIApplication sharedApplication] presentToast:@"请输入日志标题。" withVerticalPos:TOAST_POS_Y];
        return;
    }

    
    if (_postToRenren == YES)
    {
        RenrenClient *client = [RenrenClient client];
        [client setCompletionBlock:^(RenrenClient *client) {
            if(client.hasError)
                _postStatusErrorCode |= PostStatusErrorRenren;
            [self postStatusCompletion];
        }];
        _postCount++;
        
        [client postBlog:self.textView.text content:[self.blogTextView.text stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"]];
        
    }
    
    if (_postToWeibo == YES)
    {
        WebStringToImageConverter* webStringConverter = [WebStringToImageConverter webStringToImage];
        webStringConverter.delegate = self;
        NSString* detailstring=[self.blogTextView.text replaceHTMPostSign];
        [webStringConverter startConvertBlogWithTitle:nil detail:detailstring];
    }
    else {
        [self dismissView];
    }
}



#pragma mark -
#pragma mark UIScrollView delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
    _currentPage = index;
    if(_currentPage == 0) {
        [self didClickBlogTitleButton:nil];
    }
    else if(_currentPage == 1) {
        [self didClickBlogBodyButton:nil];
    }
}

#pragma mark -
#pragma mark UITextView delegate 
- (void)textViewDidChange:(UITextView *)textView
{
    [super textViewDidChange:textView];
    [self.view.layer removeAllAnimations];
    if(_currentPage == 0)
        [self.scrollView scrollRectToVisible:CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:NO];
    else if(_currentPage == 1)
        [self.scrollView scrollRectToVisible:CGRectMake(self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:NO];
}

- (UITextView *)processTextView {
    if(_currentPage == 0)
        return self.textView;
    else if(_currentPage == 1) {
        return self.blogTextView;
    }
    else {
        return nil;
    }
}

#pragma mark -
#pragma mark Keyboard notification

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    CGRect toolbarFrame = self.toolBarView.frame;
    toolbarFrame.origin.y = self.view.frame.size.height - kbSize.height - toolbarFrame.size.height;
    self.toolBarView.frame = toolbarFrame;
    
    CGRect scrollViewFrame = self.scrollView.frame;
    scrollViewFrame.size.height = self.view.frame.size.height - kbSize.height - scrollViewFrame.origin.y - TOOLBAR_HEIGHT;
    self.scrollView.frame = scrollViewFrame;
    
    CGRect textViewFrame = self.textView.frame;
    textViewFrame.size.height = scrollViewFrame.size.height;
    self.textView.frame = textViewFrame;
    
    CGRect blogTextViewFrame = self.blogTextView.frame;
    blogTextViewFrame.size.height = scrollViewFrame.size.height;
    self.blogTextView.frame = blogTextViewFrame;
}

- (void)webStringToImageConverter:(WebStringToImageConverter *)converter  didFinishLoadWebViewWithImage:(UIImage*)image
{
    WeiboClient *client = [WeiboClient client];
    [client setCompletionBlock:^(WeiboClient *client) {
        if(client.hasError)
        {
            _postStatusErrorCode |= PostStatusErrorWeibo;
        }
        [self postStatusCompletion];
    }];
    _postCount++;
    [client postStatus:[self.textView.text getStatusSubstringWithCount:WEIBO_MAX_WORD] withImage:image];
    [self dismissView];
}

#pragma mark - 
#pragma mark Override methods

- (void)showTextWarning
{
    NSInteger textCount = [self.textCountLabel.text integerValue];
    if (_currentPage == 0 && (textCount >= WEIBO_MAX_WORD) && (_lastTextViewCount < WEIBO_MAX_WORD))
    {
        [[UIApplication sharedApplication] presentToast:@"超出140字部分将不会发送至新浪微博。" withVerticalPos:TOAST_POS_Y];
    }
    if (_currentPage == 0 && (textCount >= RENREN_BLOG_TITLE_MAX_WORD) && (_lastTextViewCount < RENREN_BLOG_TITLE_MAX_WORD))
    {
        [[UIApplication sharedApplication] presentToast:@"超出100字部分将不会发送至人人网。" withVerticalPos:TOAST_POS_Y];
    }
    _lastTextViewCount = textCount;
}

@end
