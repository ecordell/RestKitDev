//
//  Record.h
//  RestKitDev
//
//  Created by Evan Cordell on 6/28/11.
//  Copyright (c) 2011 NewAperio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Record : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * recordId;

@end
