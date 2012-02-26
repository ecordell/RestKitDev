//
//  RestKitDevAppDelegate.m
//  RestKitDev
//
//  Created by Evan Cordell on 6/27/11.
//  Copyright 2011 NewAperio. All rights reserved.
//

#import "RestKitDevAppDelegate.h"
#import "RecordsListTableViewController.h"
#import "RecordAddViewController.h"
#import "RestKitDevManagedObjectCache.h"

@implementation RestKitDevAppDelegate
@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
    //Configure RestKit Logging
    //RKLogConfigureByName("RestKit", RKLogLevelInfo);
    //RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    //RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);
    //RKLogConfigureByName("RestKit/CoreData", RKLogLevelTrace);
    
    RKObjectManager* objectManager = [RKObjectManager objectManagerWithBaseURL:[NSURL URLWithString: @"http://restkitbackend.dev"]];
    objectManager.objectStore = [RKManagedObjectStore objectStoreWithStoreFilename:@"RestKitDev.sqlite" usingSeedDatabaseName:nil managedObjectModel:nil delegate:nil];
    objectManager.objectStore.managedObjectCache = [[RestKitDevManagedObjectCache new] autorelease];
    [RKObjectManager setSharedManager:objectManager];
    
    RKManagedObjectMapping* recordMapping = [RKManagedObjectMapping mappingForEntityWithName:@"Record" inManagedObjectStore:objectManager.objectStore];
    recordMapping.setNilForMissingRelationships = YES; 
    recordMapping.primaryKeyAttribute = @"recordId";
    [recordMapping mapKeyPathsToAttributes:
     @"id", @"recordId",
     @"name", @"name",
     nil];
    recordMapping.syncMode = RKSyncModeTransparent;
    
    [objectManager.mappingProvider registerMapping:recordMapping withRootKeyPath:@"record"];
    
    [objectManager.router routeClass:[Record class] toResourcePath:@"/records" forMethod:RKRequestMethodGET];
    [objectManager.router routeClass:[Record class] toResourcePath:@"/records" forMethod:RKRequestMethodPOST];
	[objectManager.router routeClass:[Record class] toResourcePath:@"/records/:recordId" forMethod:RKRequestMethodPUT];
	[objectManager.router routeClass:[Record class] toResourcePath:@"/records/:recordId" forMethod:RKRequestMethodDELETE];
    
    // We don't want zombies on the device, so alert if zombies are enabled
	if(getenv("NSZombieEnabled")) {
		NSLog(@"NSZombie Enabled!");
	}
    if(getenv("NSAutoreleaseFreedObjectCheckEnabled")) {
		NSLog(@"NSAutoreleaseFreedObjectCheck Enabled!");
	}
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
}

- (void)dealloc
{
    [super dealloc];
}

- (void)awakeFromNib
{
    /*
     Typically you should set up the Core Data stack here, usually by passing the managed object context to the first view controller.
     self.<#View controller#>.managedObjectContext = self.managedObjectContext;
    */
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
