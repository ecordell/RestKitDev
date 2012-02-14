//
//  RecordAddViewController.h
//  RestKitDev
//
//  Created by Evan Cordell on 6/28/11.
//  Copyright 2011 NewAperio. All rights reserved.
//

#import <RestKit/RestKit.h>
#import <RestKit/CoreData.h>
#import <UIKit/UIKit.h>
#import "Record.h"

@interface RecordAddViewController : UIViewController <UITextFieldDelegate, RKObjectLoaderDelegate> {
    UIButton IBOutlet *addButton;
    UITextField IBOutlet *addTextField;
    Record* _record;
}
@property (nonatomic, retain) UIButton *addButton;
@property (nonatomic, retain) UITextField *addTextField;
@property (nonatomic, retain) Record *record;
- (IBAction)addButtonPressed;

@end
