//
//  RecordAddViewController.m
//  RestKitDev
//
//  Created by Evan Cordell on 6/28/11.
//  Copyright 2011 NewAperio. All rights reserved.
//

#import "RecordAddViewController.h"


@implementation RecordAddViewController
@synthesize addButton, addTextField, record = _record;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)initWithNavigatorURL:(NSURL*)URL query:(NSDictionary*)query {
	if(query){
		if([query objectForKey:@"record"]){ 
			_record = (Record*) [query objectForKey:@"record"]; 
		}
	} 
    [self initWithNibName:@"RecordAddViewController" bundle:[NSBundle mainBundle]];
    
	return self;
}

- (void)dealloc
{
    [super dealloc];
    [_record release];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (_record) {
        addTextField.text = _record.name;
        addButton.titleLabel.text = @"Edit Record";
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)addButtonPressed {
    NSError *error = nil;
    if (_record) {
        _record.name = addTextField.text;
        [[[RKObjectManager sharedManager] objectStore] save];
        //[[RKManagedObjectSyncObserver sharedSyncObserver] shouldPutObject:_record error:&error];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NewRecord" object:_record];
        //TTOpenURL(@"tt://records");
    } else {
        Record *record = [[Record object] retain];
        record.name = addTextField.text;
        //[[RKManagedObjectSyncObserver sharedSyncObserver] shouldPostObject:record error:&error];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NewRecord" object:record];
        //TTOpenURL(@"tt://records");
    }
}
#pragma mark RKObjectLoaderDelegate methods

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
	// Post notification telling view controllers to reload.
	[[NSNotificationCenter defaultCenter] postNotificationName:@"NewRecord" object:[objects lastObject]];
	//TTOpenURL(@"tt://records");
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
	[[[[UIAlertView alloc] initWithTitle:@"Error" 
								 message:[error localizedDescription] 
								delegate:nil 
					   cancelButtonTitle:@"OK" 
					   otherButtonTitles:nil] autorelease] show];
}

@end
