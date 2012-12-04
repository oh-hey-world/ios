//
//  OHWLoginViewController.h
//  OhHeyWorld
//
//  Created by Eric Roland on 10/8/12.
//  Copyright (c) 2012 Oh Hey World, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OHWAppDelegate.h"

@class FBSession;

@interface OHWLoginViewController : OHWBaseViewController

@property (strong, nonatomic) IBOutlet UIButton *loginButton;

- (void)loginFailed;
- (IBAction)performLogin:(id)sender;

@end
