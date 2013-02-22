//
//  LNLabelBarViewController.m
//  SocialFusion
//
//  Created by 王紫川 on 12-1-19.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "LNLabelBarViewController.h"
#import "LabelConverter.h"

#define SCROLL_BG_VIEW_HEIGHT   88.0f
#define SCROLL_VIEW_ORIGIN_Y    44.0f

@interface LNLabelBarViewController()
- (void)pushLabelPages:(NSMutableArray *)labelPages;
- (void)popLabelPages;
- (void)pushLabelInfoArray:(NSMutableArray *)infoArray;
- (void)popLabelInfoArray;
- (void)pushPageIndex:(NSUInteger)pageIndex;
- (void)popPageIndex;
- (void)popPageManually;
- (void)closeOpenPage;
- (BOOL)isLabelIndexInCurrentPage:(NSUInteger)index;
@end

@implementation LNLabelBarViewController

@synthesize scrollView = _scrollView;
@synthesize pageControl = _pageControl;
@synthesize pageCount = _pageCount;
@synthesize delegate = _delegate;
@synthesize selectUserLock = _selectUserLock;
@synthesize loginButton = _loginButton;

- (void)dealloc {
    [_scrollView release];
    [_labelPagesStack release];
    [_labelInfoArrayStack release];
    [_pageControl release];
    [_pageIndexStack release];
    [_popPageManuallyCompletion release];
    [_loginButton release];
    _delegate = nil;
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.scrollView = nil;
    self.pageControl = nil;
    self.loginButton = nil;
}

- (void)createLabelPageWithInfoSubArray:(NSMutableArray *)array index:(NSUInteger)index{
    CGRect frame;
    frame.origin.x = self.scrollView.frame.size.width * index;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    LNLabelPageViewController *pageView = [[LNLabelPageViewController alloc] initWithInfoSubArray:array pageIndex:index];
    pageView.view.frame = frame;
    [self.scrollView addSubview:pageView.view];
    [self.labelPages addObject:pageView];
    pageView.delegate = self;
    [pageView release];
}

- (void)createLabelPageAtIndex:(NSInteger)index {
    NSMutableArray *labelInfoSubArray = [NSMutableArray arrayWithArray:[self.labelInfoArray subarrayWithRange:
                                                                        NSMakeRange(index * 4, self.labelInfoArray.count < (index + 1) * 4 ? self.labelInfoArray.count - index * 4 : 4)]];
    [self createLabelPageWithInfoSubArray:labelInfoSubArray index:index];
}

- (void)createEmptyLabelPage {
    [self createLabelPageWithInfoSubArray:[NSMutableArray array] index:self.pageCount - 1];
}

- (void)refreshLabelBarContentSize {
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * self.pageCount + 1, self.scrollView.frame.size.height);
}

- (void)loadLabelPages{
    self.pageCount = self.labelInfoArray.count / 4;
    if(self.labelInfoArray.count % 4 != 0)
        self.pageCount = self.pageCount + 1;
    for (int i = 0; i < self.pageCount; i++) {
        [self createLabelPageAtIndex:i];
    }
    [self refreshLabelBarContentSize];
    self.pageControl.currentPage = 0;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scrollView.delegate = self;
    [self loadLabelPages];
    
    self.scrollView.scrollsToTop = NO;
}

- (id)init {
    self = [super init];
    if(self) {
        _labelPagesStack = [[NSMutableArray alloc] init];
        NSMutableArray *labelPages = [[[NSMutableArray alloc] init] autorelease];
        [_labelPagesStack addObject:labelPages];
        _labelInfoArrayStack = [[NSMutableArray alloc] init];
        _pageIndexStack = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithLabelInfoArray:(NSArray *)infoArray {
    self = [self init];
    if(self) {
        [self pushLabelInfoArray:[NSMutableArray arrayWithArray:infoArray]];
    }
    return self;
}

- (void)popPageManuallyWithCompletion:(void (^)(void))completion {
    if(_pageIndexStack.count != 0) {
        if(_popPageManuallyCompletion != nil) {
            return;
        }
        if(completion == nil) {
            _popPageManuallyCompletion = [^{
              //  NSLog(@"empty pop page manually completion");
            } copy];
        }
        else {
            _popPageManuallyCompletion = [completion copy];
        }
        [self popPageManually];
    }
    else {
        if(completion)
            completion();
    }
}

- (void)createLabelWithInfo:(LabelInfo *)info {
    if(_selectUserLock) 
        return;
    _selectUserLock = YES;
    [self popPageManuallyWithCompletion:^{
        [self.labelInfoArray addObject:info];
        if(self.labelInfoArray.count % 4 == 1) {
            self.pageCount = self.pageCount + 1;
            [self createEmptyLabelPage];
            [self refreshLabelBarContentSize];
        }
        LNLabelPageViewController *page = [self.labelPages objectAtIndex:self.pageCount - 1];
        [page activateLastLabel:info delayed:![self isLabelIndexInCurrentPage:self.labelInfoArray.count - 1]];
        self.pageControl.currentPage = self.pageCount;
        _selectUserLock = NO;
        [self selectParentLabelAtIndex:self.labelInfoArray.count - 1];
    }];
}

- (void)selectLabelAtIndex:(NSUInteger)labelToSelectIndex {
    NSUInteger labelToSelectPage = labelToSelectIndex / 4;
    NSUInteger labelToSelectIndexInPage = labelToSelectIndex % 4;
    LNLabelPageViewController *labelPageToSelect = [self.labelPages objectAtIndex:labelToSelectPage];
    LNLabelViewController *labelToSelect = [labelPageToSelect.labelViews objectAtIndex:labelToSelectIndexInPage];
    [labelToSelect clickTitleButton:nil];
}

#pragma mark -
#pragma mark LNLabelPageViewController delegate

- (void)labelPageView:(LNLabelPageViewController *)pageView didSelectLabel:(LNLabelViewController *)label {
    NSUInteger page = pageView.page;
    for (int i = 0; i < self.pageCount; i++) {
        LNLabelPageViewController *pv = (LNLabelPageViewController *)[self.labelPages objectAtIndex:i];
        [pv selectOtherPage:page];
    }
    if(label.isParentLabel && [self.delegate respondsToSelector:@selector(labelBarView: didSelectParentLabelAtIndex:)]) {
        [self.delegate labelBarView:self didSelectParentLabelAtIndex:page * 4 + label.index];
        _currentParentLabelIndex = page * 4 + label.index;
    }
    else if(label.isChildLabel && [self.delegate respondsToSelector:@selector(labelBarView: didSelectChildLabelWithIndentifier: inParentLabelAtIndex:)]) {
        [self.delegate labelBarView:self didSelectChildLabelWithIndentifier:label.info.identifier inParentLabelAtIndex:_currentParentLabelIndex];
    }
    self.pageControl.currentPage = pageView.page;
}

- (void)labelPageView:(LNLabelPageViewController *)pageView didRemoveLabel:(LNLabelViewController *)removedLabel {
    NSUInteger index = pageView.page * 4 + removedLabel.index;
    NSUInteger page = pageView.page;
    [self.labelInfoArray removeObjectAtIndex:index];
    if([self.delegate respondsToSelector:@selector(labelBarView:didRemoveParentLabelAtIndex:)]) {
        [self.delegate labelBarView:self didRemoveParentLabelAtIndex:index];
    }
    
    if(removedLabel.isSelected) {
        NSUInteger labelToSelect = index - 1;
        if(labelToSelect == [LabelConverter getSystemDefaultLabelCount] - 1)
            labelToSelect--;
        [self selectLabelAtIndex:labelToSelect];
    }
    
    if(self.labelInfoArray.count % 4 == 0) {
        self.pageCount = self.pageCount - 1;
        LNLabelPageViewController *lastPage = [self.labelPages lastObject];
        [lastPage.view removeFromSuperview];
        [self.labelPages removeLastObject];
        if(page >= self.pageCount)
            [self.scrollView scrollRectToVisible:CGRectMake(self.scrollView.frame.size.width * (self.pageCount - 1), 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];
        else 
            [self refreshLabelBarContentSize];
    }
    
    for(int i = page; i < self.pageCount; i++) {
        NSMutableArray *labelInfoSubArray = [NSMutableArray arrayWithArray:[self.labelInfoArray subarrayWithRange:
                                                                            NSMakeRange(i * 4, self.labelInfoArray.count < (i + 1) * 4 ? self.labelInfoArray.count - i * 4 : 4)]];
        LNLabelPageViewController *pageView = [self.labelPages objectAtIndex:i];
        pageView.labelInfoSubArray = labelInfoSubArray;
    }
    for(int i = 0; i < self.pageCount; i++) {
        for(int j = 0; j < 4; j++) {
            LNLabelPageViewController *page = [self.labelPages objectAtIndex:i];
            LNLabelViewController *label = [page.labelViews objectAtIndex:j];
            if(label.isSelected) {
                [label clickTitleButton:nil];
            }
        }
    }
}

- (void)labelPageView:(LNLabelPageViewController *)pageView willOpenLabel:(LNLabelViewController *)label {
    
}

- (void)labelPageView:(LNLabelPageViewController *)pageView didOpenLabel:(LNLabelViewController *)label {
    
    for(NSUInteger i = 0; i < self.labelPages.count; i++) {
        LNLabelPageViewController *page = [self.labelPages objectAtIndex:i];
        [page reserveParentLabelPageData];
    } 
    
    _currentParentLabelIndex = pageView.page * 4 + label.index;
    [_scrollView scrollRectToVisible:CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:NO];
    
    NSMutableArray *labelPages = [[[NSMutableArray alloc] init] autorelease];
    [self pushLabelPages:labelPages];
    [self pushPageIndex:pageView.page];
    NSString *identifier = label.info.identifier;
    NSArray *labelInfo = [LabelConverter getChildLabelsInfoWithParentLabelIndentifier:identifier andParentLabelName:label.labelName];
    LabelInfo *returnLabelInfo = [labelInfo objectAtIndex:0];
    returnLabelInfo.bgImage = label.info.bgImage;
    [self pushLabelInfoArray:[NSMutableArray arrayWithArray:labelInfo]];
    [self loadLabelPages];
    LNLabelPageViewController *firstPage = [self.labelPages objectAtIndex:0];
    if([self.delegate respondsToSelector:@selector(labelBarView:willOpenParentLabelAtIndex:)]) {
        [self.delegate labelBarView:self willOpenParentLabelAtIndex:_currentParentLabelIndex];
    }
    [firstPage openLabelPostAnimation];
}

- (void)labelPageView:(LNLabelPageViewController *)pageView willCloseLabel:(LNLabelViewController *)label {
    NSUInteger pageIndex = self.pageIndex;
    [self popLabelInfoArray];
    [self popPageIndex];
    [self popLabelPages];
    [_scrollView scrollRectToVisible:CGRectMake(self.scrollView.frame.size.width * pageIndex, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:NO];
    self.pageControl.currentPage = pageIndex;
    
    for(NSUInteger i = 0; i < self.labelPages.count; i++) {
        LNLabelPageViewController *page = [self.labelPages objectAtIndex:i];
        [page forceRefreshParentLabelPageData];
    }
    
    LNLabelPageViewController *page = [self.labelPages objectAtIndex:pageIndex];
    [page closeParentLabelAnimation];
}

- (void)labelPageView:(LNLabelPageViewController *)pageView didCloseLabel:(LNLabelViewController *)label {
    if(_popPageManuallyCompletion) {
        if(_popPageManuallyCompletion) {
            _popPageManuallyCompletion();
            [_popPageManuallyCompletion release];
            _popPageManuallyCompletion = nil;
        }
    }
}

#pragma mark -
#pragma mark UIScrollView delegate

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self refreshLabelBarContentSize];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int offsetX = scrollView.contentOffset.x;
    int inaccuracy = offsetX % (int)scrollView.frame.size.width;
    offsetX -= inaccuracy;
    [scrollView setContentOffset:CGPointMake(offsetX, scrollView.contentOffset.y) animated:NO];
    int index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
    self.pageControl.currentPage = index;
}

- (void)setPageCount:(NSUInteger)pageCount {
    _pageCount = pageCount;
    self.pageControl.numberOfPages = pageCount;
}

- (NSMutableArray *)labelPages {
    return _labelPagesStack.lastObject;
}

- (NSMutableArray *)labelInfoArray {
    return _labelInfoArrayStack.lastObject;
}

- (NSUInteger)pageIndex {
    return ((NSNumber *)_pageIndexStack.lastObject).unsignedIntValue;
}

- (void)pushLabelPages:(NSMutableArray *)labelPages {
    for(int i = 0; i < self.pageCount; i++) {
        LNLabelPageViewController *page = [self.labelPages objectAtIndex:i];
        [page.view removeFromSuperview];
    }
    if(labelPages != nil)
        [_labelPagesStack addObject:labelPages];
}

- (void)popLabelPages {
    [self pushLabelPages:nil];
    [_labelPagesStack removeLastObject];
   //NSLog(@"pop label info array. array count:%d", _labelPagesStack.count);
    self.pageCount = self.labelPages.count;
    [self refreshLabelBarContentSize];
    for(int i = 0; i < self.pageCount; i++) {
        LNLabelPageViewController *page = [self.labelPages objectAtIndex:i];
        [_scrollView addSubview:page.view];
    }
}

- (void)pushLabelInfoArray:(NSMutableArray *)infoArray {
   // NSLog(@"push label info array. array count:%d", _labelPagesStack.count);
    [_labelInfoArrayStack addObject:infoArray];
}

- (void)popLabelInfoArray {
    [_labelInfoArrayStack removeLastObject];
}

- (void)pushPageIndex:(NSUInteger)pageIndex {
    [_pageIndexStack addObject:[NSNumber numberWithUnsignedInteger:pageIndex]];
}

- (void)popPageIndex {
    [_pageIndexStack removeLastObject];
}

- (void)closeOpenPage {
    LNLabelPageViewController *page = [self.labelPages objectAtIndex:0];
    [page closePageWithReturnLabel:nil];
}

- (void)movePageToTopWithCompletion:(void(^)(void))completion {
    [UIView animateWithDuration:0.3f animations:^{
        self.scrollView.contentOffset = CGPointMake(0, 0);
    } completion:^(BOOL finished) {
        if(completion)
            completion();
    }];
}

- (void)popPageManually {    
    if(self.pageControl.currentPage == 0) {
        [self closeOpenPage];
    }
    else {
        [self movePageToTopWithCompletion:^{
            [self closeOpenPage];
        }];
    }
}

- (BOOL)isLabelIndexInCurrentPage:(NSUInteger)index {
    BOOL result = NO;
    NSUInteger page = index / 4;
    if(_currentParentLabelIndex / 4 == page) 
        result = YES;
    return result;
}

- (void)selectParentLabelAtIndex:(NSUInteger)index{
    if(_selectUserLock) 
        return;
    if(index == _currentParentLabelIndex) {
        return;
    }
    _selectUserLock = YES;
    [self popPageManuallyWithCompletion:^{
        if([self isLabelIndexInCurrentPage:index]) {
            [self selectLabelAtIndex:index];
            _currentParentLabelIndex = index;
            _selectUserLock = NO;
        }
        else {
            [UIView animateWithDuration:0.3f animations:^{
                NSUInteger page = index / 4;
                self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width * page, 0);
            } completion:^(BOOL finished) {
                [self selectLabelAtIndex:index];
                _currentParentLabelIndex = index;
                _selectUserLock = NO;
            }];
        }
    }];
}

- (void)selectChildLabelWithIdentifier:(NSString *)identifier {
    if(_pageIndexStack.count <= 0) 
        return;
    [self.labelInfoArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        LabelInfo *info = obj;
        if ([info.identifier isEqualToString:identifier]) {
            [self selectLabelAtIndex:idx];
            *stop = YES;
        }
    }];
}

- (NSUInteger)parentLabelCount {
    return ((NSArray *)[_labelInfoArrayStack objectAtIndex:0]).count;
}

#pragma mark -
#pragma mark Login animations

- (void)showBasicLabelsAnimationWithCompletion:(void (^)(void))completion {
    CGRect frame = self.scrollView.frame;
    if(frame.origin.y == SCROLL_VIEW_ORIGIN_Y) {
        if(completion)
            completion();
        return;
    }
    frame.origin.y = SCROLL_VIEW_ORIGIN_Y;
    [UIView animateWithDuration:0.3f animations:^{
        self.scrollView.frame = frame;
    } completion:^(BOOL finished) {
        if(completion)
            completion();
    }];
}

- (void)hideBasicLabelsAnimationWithCompletion:(void (^)(void))completion {
    CGRect frame = self.scrollView.frame;
    if(frame.origin.y == SCROLL_BG_VIEW_HEIGHT) {
        if(completion)
            completion();
        return;
    }
    frame.origin.y = SCROLL_BG_VIEW_HEIGHT;
    [UIView animateWithDuration:0.3f animations:^{
        self.scrollView.frame = frame;
    } completion:^(BOOL finished) {
        if(completion)
            completion();
    }];
}

- (void)showLoginLabelAnimationWithCompletion:(void (^)(void))completion {
    CGRect frame = self.loginButton.frame;
    if(frame.origin.y == SCROLL_VIEW_ORIGIN_Y) {
        if(completion)
            completion();
        return;
    }
    frame.origin.y = SCROLL_VIEW_ORIGIN_Y;
    [UIView animateWithDuration:0.3f animations:^{
        self.loginButton.frame = frame;
    } completion:^(BOOL finished) {
        if(completion)
            completion();
    }];
}

- (void)hideLoginLabelAnimationWithCompletion:(void (^)(void))completion {
    CGRect frame = self.loginButton.frame;
    if(frame.origin.y == SCROLL_BG_VIEW_HEIGHT) {
        if(completion)
            completion();
        return;
    }
    frame.origin.y = SCROLL_BG_VIEW_HEIGHT;
    [UIView animateWithDuration:0.3f animations:^{
        self.loginButton.frame = frame;
    } completion:^(BOOL finished) {
        if(completion)
            completion();
    }];
}

- (void)showLoginLabelAnimated:(BOOL)animated {
    [self showLoginLabelAnimated:animated completion:nil];
}

- (void)showLoginLabelAnimated:(BOOL)animated completion:(void (^)(void))completion{
    if(animated) {
        self.scrollView.userInteractionEnabled = NO;
        [self hideBasicLabelsAnimationWithCompletion:^{
            [self showLoginLabelAnimationWithCompletion:^{
                self.loginButton.userInteractionEnabled = YES;
                if(completion)
                    completion();
            }];
        }];
    }
    else {
        CGRect frame;
        frame = self.scrollView.frame;
        frame.origin.y = SCROLL_BG_VIEW_HEIGHT;
        self.scrollView.frame = frame;
        frame = self.loginButton.frame;
        frame.origin.y = SCROLL_VIEW_ORIGIN_Y;
        self.loginButton.frame = frame;
        self.scrollView.userInteractionEnabled = NO;
        self.loginButton.userInteractionEnabled = YES;
    }
    self.pageControl.alpha = 1.0f;
    [UIView animateWithDuration:0.3f animations:^{
        self.pageControl.alpha = 0;
    }];
}

- (void)hideLoginLabelAnimated:(BOOL)animated {
    if(animated) {
        self.loginButton.userInteractionEnabled = NO;
        [self hideLoginLabelAnimationWithCompletion:^{
            [self showBasicLabelsAnimationWithCompletion:^{
                self.scrollView.userInteractionEnabled = YES;
            }];
        }];
    }
    else {
        CGRect frame;
        frame = self.scrollView.frame;
        frame.origin.y = SCROLL_VIEW_ORIGIN_Y;
        self.scrollView.frame = frame;
        frame = self.loginButton.frame;
        frame.origin.y = SCROLL_BG_VIEW_HEIGHT;
        self.loginButton.frame = frame;
        self.scrollView.userInteractionEnabled = YES;
        self.loginButton.userInteractionEnabled = NO;
    }
    self.pageControl.alpha = 0;
    [UIView animateWithDuration:0.3f animations:^{
        self.pageControl.alpha = 1.0f;
    }];
}

#pragma mark -
#pragma mark IBActions

- (IBAction)didClickLoginButton:(id)sender {
    [self.delegate didSelectLoginLabel];
}

@end
