//
//  LNLabelViewController.h
//  SocialFusion
//
//  Created by 王紫川 on 12-1-19.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LabelConverter.h"

@protocol LNLabelViewControllerDelegate;

@class User;

@interface LabelInfo : NSObject {
@private
    NSString *_identifier;
    NSString *_labelName;
    BOOL _isRemovable;
    BOOL _isSelected;
    BOOL _isReturnLabel;
    BOOL _isParent;
    
    User *_targetUser;
    UIImage *_bgImage;
}

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *labelName;
@property (nonatomic) BOOL isRetractable;
@property (nonatomic) BOOL isRemovable;
@property (nonatomic) BOOL isSelected;
@property (nonatomic) BOOL isReturnLabel;
@property (nonatomic) BOOL isParent;
@property (nonatomic, retain) User *targetUser;
@property (nonatomic, retain) UIImage *bgImage;



+ (LabelInfo *)labelInfoWithIdentifier:(NSString *)identifier labelName:(NSString *)name isRetractable:(BOOL)retractable isParent:(BOOL)isParent;

@end

@interface LNLabelViewController : UIViewController {
    UIButton *_titleButton;
    NSUInteger _index;
    id<LNLabelViewControllerDelegate> _delegate;
    UILabel *_titleLabel;
    UIImageView *_photoImageView;
    UIImageView *_bgImageView;
    LabelInfo *_info;
    
    CGRect _reservedFrame;
}

@property (nonatomic, retain) IBOutlet UIButton *titleButton;
@property (nonatomic) NSUInteger index;
@property (nonatomic) BOOL isSelected;
@property (nonatomic, readonly) BOOL isRetractable;
@property (nonatomic, readonly) BOOL isRemovable;
@property (nonatomic, readonly) BOOL isReturnLabel;
@property (nonatomic, readonly) BOOL isParentLabel;
@property (nonatomic, readonly) BOOL isChildLabel;
@property (nonatomic, copy) NSString *labelName;
@property (nonatomic, assign) id<LNLabelViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UIImageView *photoImageView;
@property (nonatomic, retain) IBOutlet UIImageView *bgImageView;
@property (nonatomic, retain) LabelInfo *info;
@property (nonatomic, assign) CGRect reservedFrame;

- (IBAction)clickTitleButton:(id)sender;

@end

@protocol LNLabelViewControllerDelegate <NSObject>

- (void)labelView:(LNLabelViewController *)labelView didSelectLabelAtIndex:(NSUInteger)index;
- (void)labelView:(LNLabelViewController *)labelView didOpenLabelAtIndex:(NSUInteger)index;
- (void)labelView:(LNLabelViewController *)labelView didCloseLabelAtIndex:(NSUInteger)index;
- (void)labelView:(LNLabelViewController *)labelView didRemoveLabelAtIndex:(NSUInteger)index;

@end