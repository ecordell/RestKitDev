//
//  RecordsListTableViewController.h
//  RestKitDev
//
//  Created by Evan Cordell on 6/28/11.
//  Copyright 2011 NewAperio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Three20/Three20.h>
#import <RestKit/Three20/Three20.h>
#import "Record.h"

@interface RecordsListTableViewController : TTTableViewController {
    NSString* _resourcePath;
	Class _resourceClass;
}
- (void)addButtonWasPressed:(id)sender;

@end
