//
//  RecordsListTableViewController.h
//  RestKitDev
//
//  Created by Evan Cordell on 6/28/11.
//  Copyright 2011 NewAperio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Three20/Three20.h>
#import "Record.h"

@interface RecordsListTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, RKObjectLoaderDelegate,  RKManagedObjectSyncDelegate>{
    UITableView* _tableView;
    NSMutableArray* _records;
}
- (id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query;
- (void)loadObjectsFromDataStore;
- (void)loadData;
- (void)addButtonWasPressed:(id)sender;
- (void)editButtonWasPressed:(id)sender;

@end
