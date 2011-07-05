//
//  RestKitDevManagedObjectCache.m
//  RestKitDev
//
//  Created by Evan Cordell on 7/2/11.
//  Copyright 2011 NewAperio. All rights reserved.
//

#import "RestKitDevManagedObjectCache.h"
#import "Record.h"

@implementation RestKitDevManagedObjectCache
- (NSArray*)fetchRequestsForResourcePath:(NSString*)resourcePath {
	if ([resourcePath isEqualToString:@"/records"]) {
		NSFetchRequest* request = [Record fetchRequest];
		NSSortDescriptor* sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"recordId" ascending:NO] autorelease];
		[request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        [request setPredicate:[NSPredicate predicateWithFormat:@"_rkManagedObjectSyncStatus < 3"]];
		return [NSArray arrayWithObject:request];
	}
    
	return nil;
}
@end
