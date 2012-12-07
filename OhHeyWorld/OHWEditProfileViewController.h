//
//  OHWEditProfileViewController.h
//  OhHeyWorld
//
//  Created by Eric Roland on 12/7/12.
//  Copyright (c) 2012 Oh Hey World, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OHWAppDelegate.h"
#import "User.h"

@interface OHWEditProfileViewController : OHWBaseViewController <RKObjectLoaderDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) User *loggedInUser;
@property (nonatomic, retain) HudView *hudView;

- (void)animateTextField:(UITextField*)textFieldup:(BOOL)up;
- (IBAction)saveProfile:(id)sender;

@end
