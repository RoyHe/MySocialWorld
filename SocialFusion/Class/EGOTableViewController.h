//
//  EGOTableViewController.h
//  PushBox
//
//  Created by Xie Hasky on 11-7-30.
//  Copyright 2011年 同济大学. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "EGORefreshTableHeaderView.h"

@interface EGOTableViewController : CoreDataTableViewController<EGORefreshTableHeaderDelegate> {
    EGORefreshTableHeaderView *_egoHeaderView;
    BOOL _reloadingFlag;
    BOOL _loadingFlag;
    BOOL _clearDataFlag;
    
    UIButton *_loadMoreDataButton;
    UIActivityIndicatorView* _activityView;
}

@property(nonatomic, retain) EGORefreshTableHeaderView *egoHeaderView;
@property(nonatomic, retain) UIButton *loadMoreDataButton;

//to override
- (void)loadMoreData;
- (void)refresh;
- (void)doneLoadingTableViewData;
- (void)showLoadMoreDataButton;
- (void)hideLoadMoreDataButton;
-(void)startLoading;
-(void)stopLoading;
@end
