//
//  CDDataStore.m
//  coredatademo
//
//  Created by saturday on 2011/9/28.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "CDDataStore.h"


@interface CDDataStore ()
@property (nonatomic, readwrite, retain) NSPersistentStoreCoordinator *coordinator;
@end

@implementation CDDataStore
@synthesize coordinator;

+ (id) sharedDataStore {

	static __typeof__(self) returnedInstance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^ {
		returnedInstance = [[self alloc] init];
	});
	
	return returnedInstance;

}

- (void) dealloc {

	[coordinator release];
	[super dealloc];

}

- (id) init {

	self = [super init];
	if (!self)
		return nil;
		
	NSURL *modelURL = [[NSBundle bundleForClass:[self class]] URLForResource:@"Model" withExtension:@"momd"];
	NSString *documentDirectory =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
	NSURL *storeURL = [NSURL fileURLWithPath:[documentDirectory stringByAppendingPathComponent:@"Model.sqlite"]];
	
	NSManagedObjectModel *model = [[[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL] autorelease];
	
	self.coordinator = [[[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model] autorelease];
	
	NSError *storeAddingError = nil;
	if (![coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:[NSDictionary dictionaryWithObjectsAndKeys:
	
		[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
		[NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption,
	
	nil] error:&storeAddingError]) {
		
		NSLog(@"storeAddingError %@", storeAddingError);
	
	}
	
	return self;

}

- (NSManagedObjectContext *) disposableMOC {

	NSManagedObjectContext *context = [[[NSManagedObjectContext alloc] init] autorelease];

	[context setPersistentStoreCoordinator:self.coordinator];

	return context;

}

@end
