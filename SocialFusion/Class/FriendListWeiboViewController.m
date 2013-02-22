//
//  FriendListWeiboViewController.m
//  SocialFusion
//
//  Created by 王紫川 on 12-1-31.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "FriendListWeiboViewController.h"
#import "FriendListTableViewCell.h"
#import "WeiboUser.h"

@implementation FriendListWeiboViewController

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
    [self refresh];
}

#pragma mark -
#pragma mark NSFetchRequestController

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    [super configureCell:cell atIndexPath:indexPath];
    FriendListTableViewCell *relationshipCell = (FriendListTableViewCell *)cell;
    relationshipCell.headFrameIamgeView.image = [UIImage imageNamed:@"head_wb.png"];
    
    User *usr = [self.fetchedResultsController objectAtIndexPath:indexPath];
    relationshipCell.latestStatus.text = usr.latestStatus;
}

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    if(_managedObjectContext != managedObjectContext) {
        [_managedObjectContext release];
        _managedObjectContext = [managedObjectContext retain];
        [self clearData];
    }
}

#pragma mark -
#pragma mark NSFetchRequestController

- (void)configureRequest:(NSFetchRequest *)request
{
    [request setEntity:[NSEntityDescription entityForName:@"WeiboUser" inManagedObjectContext:self.managedObjectContext]];
    NSPredicate *predicate;
    NSArray *descriptors;
    if(_type == RelationshipViewTypeWeiboFriends) {
        predicate = [NSPredicate predicateWithFormat:@"SELF IN %@", self.weiboUser.friends];
        NSSortDescriptor *sort = [[[NSSortDescriptor alloc] initWithKey:@"updateDate" ascending:YES] autorelease];
        descriptors = [NSArray arrayWithObject:sort];
    }
    else if(_type == RelationshipViewTypeWeiboFollowers) {
        predicate = [NSPredicate predicateWithFormat:@"SELF IN %@", self.weiboUser.followers];
        NSSortDescriptor *sort = [[[NSSortDescriptor alloc] initWithKey:@"updateDate" ascending:YES] autorelease];;
        descriptors = [NSArray arrayWithObject:sort];
    }
    [request setPredicate:predicate];
    [request setSortDescriptors:descriptors]; 
    request.fetchBatchSize = 20;
}

@end
