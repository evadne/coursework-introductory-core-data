//
//  CDContactAddViewController.h
//  coredatademo
//
//  Created by saturday on 2011/9/28.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CDContactAddViewController : UIViewController

@property (nonatomic, readwrite, copy) void (^doneBlock)();
@property (nonatomic, readwrite, retain) IBOutlet UITextField *nameField;
@property (nonatomic, readwrite, retain) IBOutlet UITextField *addressField;

@end
