//
//  LNLabelBarViewController.h
//  SocialFusion
//
//  Created by 王紫川 on 12-1-19.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LNLabelPageViewController.h"

@protocol LNLabelBarViewControllerDelegate;
typedef void (^PopPageMnuallyCompletion)(void);

@interface LNLabelBarViewController : UIViewController<UIScrollViewDelegate ,LNLabelPageViewControllerDelegate> {
    NSMutableArray *_labelPagesStack;
    NSMutableArray *_labelInfoArrayStack;
    NSUInteger _pageCount;
    NSMutableArray *_pageIndexStack;
    NSUInteger _currentParentLabelIndex;
    id<LNLabelBarViewControllerDelegate> _delegate;
    PopPageMnuallyCompletion _popPageManuallyCompletion;
    BOOL _selectUserLock;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;
@property (nonatomic, retain) IBOutlet UIButton *loginButton;

@property (nonatomic, readonly) NSMutableArray *labelInfoArray;
@property (nonatomic, readonly) NSMutableArray *labelPages;
@property (nonatomic, readonly) NSUInteger pageIndex;
@property (nonatomic) NSUInteger pageCount;
@property (nonatomic, assign) id<LNLabelBarViewControllerDelegate> delegate;
@property (nonatomic, readonly) NSUInteger parentLabelCount;
@property (nonatomic, readonly,getter = isSelectUserLock) BOOL selectUserLock;

- (IBAction)didClickLoginButton:(id)sender;

- (id)initWithLabelInfoArray:(NSArray *)infoArray;
- (void)createLabelWithInfo:(LabelInfo *)info;
- (void)selectParentLabelAtIndex:(NSUInteger)index;
- (void)selectChildLabelWithIdentifier:(NSString *)identifier;

- (void)showLoginLabelAnimated:(BOOL)animated;
- (void)hideLoginLabelAnimated:(BOOL)animated;
- (void)showLoginLabelAnimated:(BOOL)animated completion:(void (^)(void))completion;

@end

@protocol LNLabelBarViewControllerDelegate <NSObject>

@optional
- (void)labelBarView:(LNLabelBarViewController *)labelBar didOpenParentLabelAtIndex:(NSUInteger)index;

@required
- (void)labelBarView:(LNLabelBarViewController *)labelBar didSelectParentLabelAtIndex:(NSUInteger)index;
- (void)labelBarView:(LNLabelBarViewController *)labelBar didSelectChildLabelWithIndentifier:(NSString *)identifier inParentLabelAtIndex:(NSUInteger)index;
- (void)labelBarView:(LNLabelBarViewController *)labelBar didRemoveParentLabelAtIndex:(NSUInteger)index;
- (void)labelBarView:(LNLabelBarViewController *)labelBar willOpenParentLabelAtIndex:(NSUInteger)index;
- (void)didSelectLoginLabel;

@end
