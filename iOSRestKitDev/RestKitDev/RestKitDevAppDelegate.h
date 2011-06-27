//
//  RestKitDevAppDelegate.h
//  RestKitDev
//
//  Created by Evan Cordell on 6/27/11.
//  Copyright 2011 NewAperio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RestKitDevAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
