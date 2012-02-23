//
//  RecordListTableViewController.m
//  landscapes
//
//  Created by Evan Cordell on 5/25/11.
//  Copyright 2011 National Park Service/NCPTT. All rights reserved.
//

#import "RecordsListTableViewController.h"


@implementation RecordsListTableViewController

@synthesize tableView = _tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		self.title = @"Records";
        _records = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)loadView {
	[super loadView];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;		
    
    // Load records from core data
    [self loadObjectsFromDataStore];
    
	//Background
	self.view.backgroundColor = [UIColor whiteColor];
    
    //Register for notifications to know when to reload
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadObjectsFromDataStore) name:@"NewRecord" object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishSyncing) name:RKAutoSyncDidSync 
  //                                             object:[RKManagedObjectSyncObserver sharedSyncObserver]];
    
    //[self loadData];
    
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
    if (_records) {
        [_records release];
    }
    NSFetchRequest* request = [[[[RKObjectManager sharedManager] objectStore] managedObjectCache] fetchRequestForResourcePath:@"/records"];
    
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

- (void)syncButtonWasPressed:(id)sender {
    //[[RKManagedObjectSyncObserver sharedSyncObserver] syncWithDelegate:self];
}

#pragma mark RKManagedObjectSyncDelegate methods
- (void)didStartSyncing {
    RKLogInfo("Syncing has started");
}
- (void)didFinishSyncing {
    RKLogInfo("Syncing has completed successfully.");
    [self loadData];
}
- (void)didFailSyncingWithError:(NSError*)error {
    RKLogInfo("An error occured while syncing: %@", [error localizedDescription]);
    UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Error" 
                                                     message:[error localizedDescription] 
                                                    delegate:nil 
                                           cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
	[alert show];
	NSLog(@"Hit error: %@", error);
}
- (void)didSyncNothing {
    //fetch from the server even if nothing is synced
    RKLogInfo(@"No records to sync.");
    [self loadData];
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
    return 50;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSError *error;
        Record *toDelete = [_records objectAtIndex:indexPath.row];
        NSManagedObjectContext *context = [toDelete managedObjectContext];
        [toDelete deleteEntity];
        [context save:&error];
        [_records removeObjectAtIndex:indexPath.row];
        [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	//NSDictionary *query = [NSDictionary dictionaryWithObjectsAndKeys:[_records objectAtIndex:indexPath.row], @"record", nil];
	//[[TTNavigator navigator] openURLAction:[[[TTURLAction actionWithURLPath:@"tt://records/add?"] applyQuery:query] applyAnimated:YES]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"EditRecord"])
    {
        RecordAddViewController *destination = [segue destinationViewController];
        [destination setRecord:[_records objectAtIndex:[self.tableView indexPathForSelectedRow].row]];
    }
}

#pragma mark UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
	return [_records count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"RecordCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	Record* record = [_records objectAtIndex:indexPath.row];
    cell.textLabel.text = record.name;

    
    //NSString *syncStatus;
   /* switch ([record._rkManagedObjectSyncStatus intValue]) {
        case RKSyncStatusShouldNotSync:
            syncStatus = [NSString stringWithFormat:@"Will not sync"];
            break;
        case RKSyncStatusShouldPost:
            syncStatus = [NSString stringWithFormat:@"Will create"];
            break;
        case RKSyncStatusShouldPut:
            syncStatus = [NSString stringWithFormat:@"Will update"];
            break;
        //This won't be seen since we're removing records from the table on delete
        //Also the fetchrequest in the managedobjectcache excludes deleted records
        case RKSyncStatusShouldDelete:
            syncStatus = [NSString stringWithFormat:@"Will delete"];
            break;
        default:
            break;
    }*/
    //cell.detailTextLabel.text = [NSString stringWithFormat:@"Sync Status: %@", syncStatus];
    
	return cell;
}


@end
