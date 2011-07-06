//
//  RecordListTableViewController.m
//  landscapes
//
//  Created by Evan Cordell on 5/25/11.
//  Copyright 2011 National Park Service/NCPTT. All rights reserved.
//

#import "RecordsListTableViewController.h"


@implementation RecordsListTableViewController

- (id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query {
	if ((self = [super initWithNavigatorURL:URL query:query])) {
		self.title = @"Records";
        _records = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)loadView {
	[super loadView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 480-64) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;		
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    // Load statuses from core data
    [self loadObjectsFromDataStore];
    
    UIBarButtonItem* item = nil;
	self.navigationItem.leftBarButtonItem = item;
	[item release];
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonWasPressed:)];	
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(syncButtonWasPressed:)];
    
	//Background
	self.view.backgroundColor = [UIColor whiteColor];
    
    //Register for notifications to know when to reload
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadObjectsFromDataStore) name:@"NewRecord" object:nil];
    
    //set self as delegate for syncing
    [[RKManagedObjectSyncObserver sharedSyncObserver] setDelegate:self];
    
    [self loadData];
    
}
//sync delegate methods
- (void)didStartSyncing {
    
}

- (void)didFinishSyncing {
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [self loadObjectsFromDataStore];
    [_tableView reloadData];
}

- (void)dealloc {
	[_tableView release];
	[_records release];
    [super dealloc];
}

- (void)loadObjectsFromDataStore {
	[_records release];
	NSFetchRequest* request = [[[[[RKObjectManager sharedManager] objectStore] managedObjectCache] fetchRequestsForResourcePath:@"/records"] objectAtIndex:0];
	_records = [[NSMutableArray arrayWithArray:[Record objectsWithFetchRequest:request]] retain];
}

- (void)loadData {
    // Load the object model via RestKit	
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    [objectManager loadObjectsAtResourcePath:@"/records" delegate:self];
}

- (void)viewDidUnload {
	[super viewDidUnload];
    //Unregister for notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)addButtonWasPressed:(id)sender {
	TTOpenURL(@"tt://records/add");
}

- (void)syncButtonWasPressed:(id)sender {
    [[RKManagedObjectSyncObserver sharedSyncObserver] sync];
}

#pragma mark RKObjectLoaderDelegate methods

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
	[self loadObjectsFromDataStore];
	[_tableView reloadData];
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
	UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Error" 
                                                     message:[error localizedDescription] 
                                                    delegate:nil 
                                           cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
	[alert show];
	NSLog(@"Hit error: %@", error);
}

#pragma mark UITableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	CGSize size = [[[_records objectAtIndex:indexPath.row] name] sizeWithFont:[UIFont systemFontOfSize:22] constrainedToSize:CGSizeMake(300, 9000)];
	return size.height + 10;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSError *error;
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[RKManagedObjectSyncObserver sharedSyncObserver] shouldDeleteObject:[_records objectAtIndex:indexPath.row] error:&error];
        [_records removeObjectAtIndex:indexPath.row];
        [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	NSDictionary *query = [NSDictionary dictionaryWithObjectsAndKeys:[_records objectAtIndex:indexPath.row], @"record", nil];
	[[TTNavigator navigator] openURLAction:[[[TTURLAction actionWithURLPath:@"tt://records/add?"] applyQuery:query] applyAnimated:YES]];
}

#pragma mark UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
	return [_records count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString* reuseIdentifier = @"Record Cell";
	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
	if (nil == cell) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier] autorelease];
		cell.textLabel.font = [UIFont systemFontOfSize:14];
		cell.textLabel.numberOfLines = 0;
		cell.textLabel.backgroundColor = [UIColor clearColor];
	}
    Record* record = [_records objectAtIndex:indexPath.row];
	cell.textLabel.text = [NSString stringWithFormat:@"%@, %i", record.name, [record._rkManagedObjectSyncStatus intValue]];
	return cell;
}

@end
