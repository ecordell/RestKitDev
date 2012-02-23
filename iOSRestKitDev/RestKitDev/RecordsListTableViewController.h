//
//  RecordsListTableViewController.h
//  RestKitDev
//
//  Created by Evan Cordell on 6/28/11.
//  Copyright 2011 NewAperio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestKitDevAppDelegate.h"
#import "Record.h"
#import "RecordAddViewController.h"

@interface RecordsListTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, RKObjectLoaderDelegate>{
    UITableView* _tableView;
    NSMutableArray* _records;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;

- (void)loadObjectsFromDataStore;
- (void)loadData;
- (IBAction)syncButtonWasPressed:(id)sender;

@end
