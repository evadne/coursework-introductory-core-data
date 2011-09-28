//
//  CDContactsList.m
//  coredatademo
//
//  Created by saturday on 2011/9/28.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "CDDataStore.h"
#import "CDContactsList.h"


@interface CDContactsList () <NSFetchedResultsControllerDelegate>
@property (nonatomic, readwrite, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, readwrite, retain) NSFetchedResultsController *fetchedResultsController;
@end

@implementation CDContactsList
@synthesize managedObjectContext, fetchedResultsController;

- (id) initWithStyle:(UITableViewStyle)style {

	self = [super initWithStyle:style];
	if (!self)
		return nil;
	
	self.title = @"Contacts";
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(handleAdd:)] autorelease]; 
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMOCDidSave:) name:NSManagedObjectContextDidSaveNotification object:nil];

	managedObjectContext = [[[CDDataStore sharedDataStore] disposableMOC] retain];

	fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:((^ {

		NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
		[request setEntity:[NSEntityDescription entityForName:@"Person" inManagedObjectContext:self.managedObjectContext]];
		[request setSortDescriptors:[NSArray arrayWithObjects:
			[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES],
		nil]];
		
		return request;
		
	})()) managedObjectContext:((^{
		
		return self.managedObjectContext;
		
	})()) sectionNameKeyPath:nil cacheName:nil];

	NSError *initialFetchingError = nil;
	if (![fetchedResultsController performFetch:&initialFetchingError])
		NSLog(@"error performing initial fetch: %@", initialFetchingError);
		
	fetchedResultsController.delegate = self;

	return self;
		
}

- (void) dealloc {

	[[NSNotificationCenter defaultCenter] removeObserver:self];

	[fetchedResultsController release];
	[super dealloc];
	
}

- (void) handleMOCDidSave:(NSNotification *)aNotification {

	if ([aNotification object] == self.managedObjectContext)
		return;
	
	[self.managedObjectContext mergeChangesFromContextDidSaveNotification:aNotification];

}

- (void) handleAdd:(id)sender {

	__block CDContactAddViewController *contactAddVC = [[CDContactAddViewController alloc] initWithNibName:NSStringFromClass([CDContactAddViewController class]) bundle:[NSBundle bundleForClass:[CDContactAddViewController class]]];
	
	contactAddVC.doneBlock = ^ {
	
		NSManagedObjectContext *context = [[CDDataStore sharedDataStore] disposableMOC];
	
		NSManagedObject *savedPerson = [[[NSManagedObject alloc] initWithEntity:[NSEntityDescription entityForName:@"Person" inManagedObjectContext:context] insertIntoManagedObjectContext:context] autorelease];
		
		[savedPerson setValue:contactAddVC.nameField.text forKey:@"name"];
		
		[savedPerson setValue:contactAddVC.addressField.text forKey:@"address"];
		
		NSError *savingError = nil;
		if (![context save:&savingError])
			NSLog(@"Error saving: %@", savingError);
	
		[contactAddVC.navigationController dismissModalViewControllerAnimated:YES];
	
	};

	UIViewController *presentedVC = [[[UINavigationController alloc] initWithRootViewController:contactAddVC] autorelease];
	
	presentedVC.modalPresentationStyle = UIModalPresentationFullScreen;
	presentedVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
	
	[(UIViewController *)(self.navigationController ? self.navigationController : self) presentModalViewController:presentedVC animated:YES];

}

- (void) controllerDidChangeContent:(NSFetchedResultsController *)controller {

	if ([self isViewLoaded])
		[self.tableView reloadData];

}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {

	return [self.fetchedResultsController.sections count];

}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

	return [(id<NSFetchedResultsSectionInfo>)[self.fetchedResultsController.sections objectAtIndex:section] numberOfObjects];

}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	
	NSManagedObject *personEntity = [self.fetchedResultsController objectAtIndexPath:indexPath];
	
	cell.textLabel.text = [personEntity valueForKey:@"name"];
    
	return cell;
	
}

@end
