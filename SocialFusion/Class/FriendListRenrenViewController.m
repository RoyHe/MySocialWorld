//
//  FriendListRenrenViewController.m
//  SocialFusion
//
//  Created by 王紫川 on 12-1-31.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "FriendListRenrenViewController.h"
#import "FriendListTableViewCell.h"
#import "RenrenUser+Addition.h"

@implementation FriendListRenrenViewController

- (void)dealloc {
    [super dealloc];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:@"FriendListViewController" bundle:nil];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if(self.renrenUser.friends.count == 0) 
        [self refresh];
}



#pragma mark -
#pragma mark NSFetchRequestController

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    [super configureCell:cell atIndexPath:indexPath];
    FriendListTableViewCell *relationshipCell = (FriendListTableViewCell *)cell;
    relationshipCell.headFrameIamgeView.image = [UIImage imageNamed:@"head_renren.png"];
    
    User *usr = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if(!usr.latestStatus) {
        if (self.tableView.dragging == NO && self.tableView.decelerating == NO) {
            if(indexPath.row < kCustomRowCount && [usr isMemberOfClass:[RenrenUser class]]) {
                RenrenUser *renreUser = (RenrenUser *)usr;
                [renreUser loadLatestStatus];
            }
        }
    }
    else {
        relationshipCell.latestStatus.text = usr.latestStatus;
    }
}

- (NSString *)customSectionNameKeyPath {
    return @"pinyinNameFirstLetter";
}

#pragma mark -
#pragma mark UITableView delegates

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 20)] autorelease];
    [headerView setBackgroundColor:[UIColor colorWithRed:225.0f / 255.0f green:217.0f / 255.0f blue:195.0f / 255.0f alpha:0.8f]];
    NSString *section_name = [[[self.fetchedResultsController sections] objectAtIndex:section] name];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, 306, 18)];
    label.text = section_name;
    label.font = [UIFont fontWithName:@"MV Boli" size:16.0f];
    label.textColor = [UIColor whiteColor];
    label.shadowColor = [UIColor darkGrayColor];
    label.shadowOffset = CGSizeMake(0, 1.0f);
    label.backgroundColor = [UIColor clearColor];
    [headerView addSubview:label];
    [label release];
    return headerView;
}

#pragma mark -
#pragma mark Animations

- (void)loadExtraDataForOnScreenRowsHelp:(NSIndexPath *)indexPath {
    [super loadExtraDataForOnScreenRowsHelp:indexPath];
    if(self.tableView.dragging || self.tableView.decelerating || _reloadingFlag)
        return;
    User *usr = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if(!usr.latestStatus) {
        if([usr isMemberOfClass:[RenrenUser class]]) {
            RenrenUser *renreUser = (RenrenUser *)usr;
            [renreUser loadLatestStatus];
        }
    }
}

#pragma mark -
#pragma mark NSFetchRequestController

- (void)configureRequest:(NSFetchRequest *)request
{
    [request setEntity:[NSEntityDescription entityForName:@"RenrenUser" inManagedObjectContext:self.managedObjectContext]];
    NSPredicate *predicate;
    NSArray *descriptors;
    if(_type == RelationshipViewTypeRenrenFriends) {
        predicate = [NSPredicate predicateWithFormat:@"SELF IN %@", self.renrenUser.friends];
        NSSortDescriptor *sort = [[[NSSortDescriptor alloc] initWithKey:@"pinyinNameFirstLetter" ascending:YES] autorelease];
        NSSortDescriptor *sort2 = [[[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES] autorelease];
        NSSortDescriptor *sort3 = [[[NSSortDescriptor alloc] initWithKey:@"pinyinName" ascending:YES] autorelease];
        descriptors = [NSArray arrayWithObjects:sort, sort2, sort3, nil];
    }
    [request setPredicate:predicate];
    [request setSortDescriptors:descriptors]; 
}

@end
