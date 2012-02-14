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

- (NSFetchRequest *)fetchRequestForResourcePath:(NSString *)resourcePath {
    if ([resourcePath isEqualToString:@"/records"]) {
		NSFetchRequest* request = [Record fetchRequest];
		NSSortDescriptor* sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"recordId" ascending:NO] autorelease];
		[request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        //[request setPredicate:[NSPredicate predicateWithFormat:@"_rkManagedObjectSyncStatus < 3"]];
		return request;
	}
    
    // match on /records/:id
	NSArray* components = [resourcePath componentsSeparatedByString:@"/"];
	if ([components count] == 3 &&
		[[components objectAtIndex:1] isEqualToString:@"records"]) {
		NSNumber* recordId = [NSNumber numberWithInt:[[components objectAtIndex:2] intValue]];
		NSFetchRequest* request = [Record fetchRequest];
		NSPredicate* predicate = [NSPredicate predicateWithFormat:@"recordId = %@", recordId, nil];
		[request setPredicate:predicate];
		return request;
	}
    return nil;
}

@end
