//
//  RecordAddViewController.h
//  RestKitDev
//
//  Created by Evan Cordell on 6/28/11.
//  Copyright 2011 NewAperio. All rights reserved.
//

#import <Three20/Three20.h>
#import <RestKit/RestKit.h>
#import <UIKit/UIKit.h>
#import "Record.h"
#import <RestKit/CoreData/CoreData.h>

@interface RecordAddViewController : TTViewController <UITextFieldDelegate, RKObjectLoaderDelegate> {
    UIButton IBOutlet *addButton;
    UITextField IBOutlet *addTextField;
    Record* _record;
}
@property (nonatomic, retain) UIButton *addButton;
@property (nonatomic, retain) UITextField *addTextField;
@property (nonatomic, retain) Record *record;
- (IBAction)addButtonPressed;

@end
