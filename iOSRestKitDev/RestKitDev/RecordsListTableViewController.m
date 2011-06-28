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
		
		_resourcePath = [@"/records" retain];
		_resourceClass = [Record class];
	}
	return self;
}

- (void)loadView {
	[super loadView];
    
    RKObjectTTTableViewDataSource* dataSource = [RKObjectTTTableViewDataSource dataSource];
    RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[TTTableTextItem class]];
    [mapping mapKeyPath:@"name" toAttribute:@"text"];
    [dataSource mapObjectClass:[Record class] toTableItemWithMapping:mapping];
    RKObjectLoader* objectLoader = [[RKObjectManager sharedManager] objectLoaderWithResourcePath:_resourcePath delegate:nil];
    dataSource.model = [RKObjectLoaderTTModel modelWithObjectLoader:objectLoader];
    self.dataSource = dataSource;
    UIBarButtonItem* item = nil;
	self.navigationItem.leftBarButtonItem = item;
	[item release];
    
	UIButton* newButton = [UIButton buttonWithType:UIButtonTypeCustom];
	UIImage* newButtonImage = [UIImage imageNamed:@"add.png"];
	[newButton setImage:newButtonImage forState:UIControlStateNormal];
	[newButton addTarget:self action:@selector(addButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
	[newButton setFrame:CGRectMake(0, 0, newButtonImage.size.width, newButtonImage.size.height)];
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonWasPressed:)];	
    
	//Background
	self.view.backgroundColor = [UIColor whiteColor];
	self.tableView.backgroundColor = [UIColor whiteColor];
    
    //Register for notifications to know when to reload
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(invalidateModel) name:@"NewRecord" object:nil];
    
}
- (void)viewDidUnload {
	[super viewDidUnload];
    //Unregister for notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didLoadModel:(BOOL)firstTime {
	[super didLoadModel:firstTime];
    
    /*if ([self.model isKindOfClass:[RKObjectLoaderTTModel class]]) {
		RKObjectLoaderTTModel* model = (RKObjectLoaderTTModel*)self.model;
        
	}*/
}

- (void)addButtonWasPressed:(id)sender {
	TTOpenURL(@"tt://records/add");
}

@end
