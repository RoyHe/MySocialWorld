//
//  CoreDataTableViewController.h
//  PushBox
//
//  Created by Xie Hasky on 11-7-24.
//  Copyright 2011年 同济大学. All rights reserved.
//

#import "CoreDataViewController.h"

@interface CoreDataTableViewController : CoreDataViewController<NSFetchedResultsControllerDelegate, 
UITableViewDelegate, UITableViewDataSource> {
    NSFetchedResultsController *_fetchedResultsController;
    UITableView *_tableView;
    NSInteger _playingAnimationCount;
    BOOL _noAnimationFlag;
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

//methods to override
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)configureRequest:(NSFetchRequest *)request;
- (void)updateCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (NSString *)customCellClassName;
- (NSString *)customSectionNameKeyPath;

@end
