//
//  NewFeedListController.h
//  SocialFusion
//
//  Created by He Ruoyun on 11-10-7.
//  Copyright 2011年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EGOTableViewController.h"
#import "NewFeedRootData.h"
#import "RenrenUser+Addition.h"
#import "WeiboUser+Addition.h"
#import "NewFeedStatusCell.h"

#import "NewFeedDetailViewCell.h"
#import "NewFeedCellHeight.h"
#import "NewFeedDetailBlogViewCell.h"
#import "NewFeedAlbumCell.h"

typedef   enum kUserFeed {
    kRenrenSelfFeed = 0,
    kWeiboSelfFeed  = 1,
    kAllSelfFeed    = 2,
    kRenrenUserFeed = 3,
    kWeiboUserFeed  = 4,
} kUserFeed;

@interface NewFeedListController : EGOTableViewController<StatusCellDelegate,WeiboRenrenSelecter> {
    NSDate* _currentTime;

    IBOutlet NewFeedStatusCell *_feedStatusCel;
    IBOutlet NewFeedDetailViewCell *_newFeedDetailViewCel;
    IBOutlet NewFeedDetailBlogViewCell *_newFeedDetailBlogViewCel;
    IBOutlet NewFeedAlbumCell *_newFeedAlbumCel;
    
    NSIndexPath* _indexPath;
    int _pageNumber;
    int _style;
    NewFeedCellHeight* _cellHeightHelper;
    BOOL _firstLoad;
    
    int _loadingCount;
    

}

@property (nonatomic, readonly) WeiboUser *processWeiboUser;
@property (nonatomic, readonly) RenrenUser *processRenrenUser;

@property (nonatomic) int loadingCount;

+ (NewFeedListController*)getNewFeedListControllerwithStyle:(kUserFeed)style;
- (void)exposeCell:(NSIndexPath*)indexPath;
- (void)showImage:(NSIndexPath*)indexPath;
- (void)showImage:(NSString*)smallURL bigURL:(NSString*)stringURL;
- (void)showImage:(NSString*)smallURL userID:(NSString*)userID photoID:(NSString*)photoID;
- (void)processRenrenData:(NSArray*)array;
- (void)processWeiboData:(NSArray*)array;
- (void)clearData;
- (IBAction)resetToNormalList;
- (void)setStyle:(int)style;
- (void)selectUser:(NSIndexPath*)indexPath;
-(void)loadNewRenrenAt:(NSString*)userID ;
-(void)loadNewWeiboAt:(NSString*)userName;
@end
