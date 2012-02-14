//
//  RestKitDevAppDelegate.h
//  RestKitDev
//
//  Created by Evan Cordell on 6/27/11.
//  Copyright 2011 NewAperio. All rights reserved.
//

#import <RestKit/RestKit.h>
#import <RestKit/CoreData.h>

@interface RestKitDevAppDelegate : NSObject <UIApplicationDelegate> {
    
}

@property (nonatomic, retain) UIWindow *window;

- (NSURL *)applicationDocumentsDirectory;


@end
