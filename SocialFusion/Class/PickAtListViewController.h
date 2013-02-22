//
//  PickAtListViewController.h
//  SocialFusion
//
//  Created by 王紫川 on 12-2-12.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataViewController.h"

@protocol PickAtListViewControllerDelegate;

@interface PickAtListViewController : CoreDataViewController<UITextFieldDelegate> {
    UIButton *_renrenButton;
    UIButton *_weiboButton;
    BOOL _platformCode;
    UITableView *_tableView;
    UITextField *_textField;
    
    NSMutableArray *_atScreenNames;
    id<PickAtListViewControllerDelegate> _delegate;
}

@property (nonatomic, assign) id<PickAtListViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIButton *renrenButton;
@property (nonatomic, retain) IBOutlet UIButton *weiboButton;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UITextField *textField;

- (IBAction)didClickCancelButton:(id)sender;
- (IBAction)didClickFinishButton:(id)sender;

- (IBAction)didClickRenrenButton:(id)sender;
- (IBAction)didClickWeiboButton:(id)sender;

- (IBAction)atTextFieldEditingChanged:(UITextField*)textField;

- (void)updateTableView;

@end

@protocol PickAtListViewControllerDelegate <NSObject>

- (void)didPickAtUser:(NSString *)result;
- (void)cancelPickUser;

@end
