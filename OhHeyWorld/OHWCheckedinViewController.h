//
//  OHWCheckedinViewController.h
//  OhHeyWorld
//
//  Created by Eric Roland on 10/22/12.
//  Copyright (c) 2012 Oh Hey World, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OHWAppDelegate.h"
#import "User.h"

@interface OHWCheckedinViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) IBOutlet UITableView *tableView;

@end
