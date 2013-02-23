//
//  PickAtListViewController.m
//  SocialFusion
//
//  Created by 王紫川 on 12-2-12.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "PickAtListViewController.h"
#import "UIButton+Addition.h"
#import "RenrenUser+Addition.h"

@interface PickAtListViewController()
- (void)configureAtWeiboScreenNamesArray:(NSString*)text;
- (void)configureAtRenrenScreenNamesArray:(NSString*)text;
- (void)updateTableView;

@property (nonatomic, assign) BOOL platformCode;
@end

@implementation PickAtListViewController

@synthesize delegate = _delegate;
@synthesize renrenButton = _renrenButton;
@synthesize weiboButton = _weiboButton;
@synthesize tableView = _tableView;
@synthesize textField = _textField;

@synthesize platformCode = _platformCode;

@synthesize  imageView = _imageView;

- (void)dealloc {
    [_renrenButton release];
    [_weiboButton release];
    [_atScreenNames release];
    [_tableView release];
    [_textField release];
    _delegate = nil;
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.renrenButton = nil;
    self.weiboButton = nil;
    self.tableView = nil;
    self.textField = nil;
    
    self.imageView = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
 //   NSLog(@"%f",[[UIScreen mainScreen] bounds].size.height);
    if ([[UIScreen mainScreen] bounds].size.height>480)
    {
        [self.imageView setImage:[UIImage imageNamed:@"new_status_bg-568h@2x.png"]];
    }
    // Do any additional setup after loading the view from its nib.
    [self.renrenButton setPostPlatformButtonSelected:YES];
    self.textField.text = @"";
    self.platformCode = kPlatformRenren;
    //[self updateTableView];
}

- (id)init {
    self = [super init];
    if(self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    }
    return self;
}

#pragma mark -
#pragma mark logic

- (void)configureAtWeiboScreenNamesArray:(NSString*)text
{    
    if (_atScreenNames) {
        [_atScreenNames removeAllObjects];
    }
    else {
        _atScreenNames = [[NSMutableArray alloc] init];
    }
    
    [_atScreenNames insertObject:[NSString stringWithFormat:@"@%@", text] atIndex:0];
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"WeiboUser" inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[[[NSString alloc] initWithFormat:@"name like[c] \"*%@*\"", text] autorelease]];
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"pinyinName like[c] \"*%@*\"", text]];
    NSPredicate *compoundPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:[NSArray arrayWithObjects:predicate, predicate2, nil]];
    
    [request setPredicate:compoundPredicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    
    [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [sortDescriptor release];
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    for (int i = 0; i < [array count]; i++) {
        [_atScreenNames addObject:[NSString stringWithFormat:@"@%@", [[array objectAtIndex:i] name]]];
    }
}

- (NSArray *)getAllRenrenUserArrayWithHint:(NSString *)text {
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"RenrenUser" inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"name like[c] \"*%@*\"", text]];
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"pinyinName like[c] \"*%@*\"", text]];
    NSPredicate *compoundPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:[NSArray arrayWithObjects:predicate, predicate2, nil]];
    
    [request setPredicate:compoundPredicate];
    
    NSSortDescriptor *sort = [[[NSSortDescriptor alloc] initWithKey:@"pinyinNameFirstLetter" ascending:YES] autorelease];
    NSSortDescriptor *sort2 = [[[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES] autorelease];
    NSSortDescriptor *sort3 = [[[NSSortDescriptor alloc] initWithKey:@"pinyinName" ascending:YES] autorelease];
    NSArray *descriptors = [NSArray arrayWithObjects:sort, sort2, sort3, nil];
    [request setSortDescriptors:descriptors];
    
    NSError *error;
    NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
    return array;
}

- (void)setAtScreenNamesWithRenrenArray:(NSArray *)array {
    for (int i = 0; i < [array count]; i++) {
        User *usr = [array objectAtIndex:i];
        [_atScreenNames addObject:[NSString stringWithFormat:@"@%@(%@)", usr.name, usr.userID]];
    }
}

- (void)configureAtRenrenScreenNamesArray:(NSString*)text {    
    if (_atScreenNames) {
        [_atScreenNames removeAllObjects];
    }
    else {
        _atScreenNames = [[NSMutableArray alloc] init];
    }
    NSArray *array = [self getAllRenrenUserArrayWithHint:text];
    [self setAtScreenNamesWithRenrenArray:array];
}

- (void)updateTableView {
    if(self.platformCode == kPlatformRenren) {
        [self configureAtRenrenScreenNamesArray:self.textField.text];
    }
    else if(self.platformCode == kPlatformWeibo) {
        [self configureAtWeiboScreenNamesArray:self.textField.text];
    }
    [self.tableView reloadData];
}

#pragma mark -
#pragma makr IBAction

- (IBAction)didClickCancelButton:(id)sender {
    [self.delegate cancelPickUser];
}

- (IBAction)didClickFinishButton:(id)sender {
    if(self.platformCode == kPlatformWeibo) {
        NSString *result = [_atScreenNames objectAtIndex:0];
        [self.delegate didPickAtUser:result];
    }
    else if(self.platformCode == kPlatformRenren) {
        [self.delegate cancelPickUser];
    }
}

- (IBAction)didClickRenrenButton:(id)sender {
    self.platformCode = kPlatformRenren;
    [self.renrenButton setPostPlatformButtonSelected:YES];
    [self.weiboButton setPostPlatformButtonSelected:NO];
}

- (IBAction)didClickWeiboButton:(id)sender {
    self.platformCode = kPlatformWeibo;
    [self.renrenButton setPostPlatformButtonSelected:NO];
    [self.weiboButton setPostPlatformButtonSelected:YES];
}

- (IBAction)atTextFieldEditingChanged:(UITextField*)textField {
    [self updateTableView];
}

#pragma mark - 
#pragma mark UITableView data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_atScreenNames count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = @"PickAtTableViewCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] init] autorelease];
    }
    cell.textLabel.text = [_atScreenNames objectAtIndex:[indexPath row]];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}

#pragma mark - 
#pragma mark UITableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath { 
    NSString *result = [_atScreenNames objectAtIndex:[indexPath row]];
    [self.delegate didPickAtUser:result];
}

#pragma mark -
#pragma mark Keyboard notification

- (void)keyboardWillShow:(NSNotification *)notification {
    
    NSDictionary *info = [notification userInfo];
    
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    //NSLog(@"keyboard changed, keyboard width = %f, height = %f", kbSize.width,kbSize.height);
    
    CGRect tableViewFrame = self.tableView.frame;
    tableViewFrame.size.height = self.view.frame.size.height - kbSize.height - tableViewFrame.origin.y;
    self.tableView.frame = tableViewFrame;
}

#pragma mark -
#pragma mark custom getter & setter

- (void)setPlatformCode:(BOOL)platformCode {
    if(_platformCode != platformCode) {
        _platformCode = platformCode;
        [self updateTableView];
    }
}

@end
