//
//  CDDataStore.h
//  coredatademo
//
//  Created by saturday on 2011/9/28.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CDDataStore : NSObject

//	Singleton pattern implementation

+ (id) sharedDataStore;
- (NSManagedObjectContext *) disposableMOC;

@end
