//
//  coredatademoAppDelegate.m
//  coredatademo
//
//  Created by saturday on 2011/9/28.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "coredatademoAppDelegate.h"

@implementation coredatademoAppDelegate


@synthesize window=_window;

- (BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

	[self.window makeKeyAndVisible];
	
	self.window.rootViewController = [[[UINavigationController alloc] initWithRootViewController:[[(UIViewController *)[NSClassFromString(@"CDContactsList") alloc] init] autorelease]] autorelease];
	
	return YES;
	
}

- (void) dealloc {
	
	[_window release];
	[super dealloc];
	
}

@end
