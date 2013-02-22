//
//  NewFeedStatusCell.h
//  SocialFusion
//
//  Created by He Ruoyun on 11-10-9.
//  Copyright 2011年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NewFeedRootData+Addition.h"


typedef  enum kFeedType {
    kNormal             = 0,
    kRepost             = 1,
    kNormalWithPhoto    = 2,
    kRepostWithPhoto    = 3,
    kShareAlbum         = 4,
    kUploadPhoto        = 5,
    kSharePhoto         = 6,
    kBlog               = 7
} kFeedType;


@protocol StatusCellDelegate;
@class NewFeedListController;
@interface NewFeedStatusCell : UITableViewCell<UIWebViewDelegate> {

    NewFeedListController* _listController;
    
    UIWebView* _webView;
    
    UIImageView* _photoView;
    UIImageView* _defaultphotoView;
    UIButton* _photoOut;
    
    UIButton* _name;
    UILabel* _time;
    UIImageView* _upCutline;
    
    NSData* _photoData;
    
    id<StatusCellDelegate> _delegate;
    
    BOOL _loaded;
}


@property(nonatomic, retain)  UIImageView* photoView;
@property (nonatomic, assign) id<StatusCellDelegate> delegate;



+ (float)heightForCell:(NewFeedRootData*)feedData;

- (id)initWithType:(kFeedType)type;
- (void)setList:(NewFeedListController*)list;
- (void)configureCell:(NewFeedRootData*)feedData  first:(BOOL)bol;
- (void)exposeCell;
- (void)loadImage:(NSData*)image;
- (void)loadPicture:(NSData*)image;
- (void)setData:(NSData*)image;
-(BOOL)loaded;
@end

@protocol StatusCellDelegate<NSObject>

- (void)statusCellWebViewDidLoad:(UIWebView*)webView  indexPath:(NSIndexPath*)path Cell:(NewFeedStatusCell*)cell;

@end
