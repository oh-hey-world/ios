//
//  OHWBaseViewController.m
//  OhHeyWorld
//
//  Created by Eric Roland on 12/4/12.
//  Copyright (c) 2012 Oh Hey World, Inc. All rights reserved.
//

#import "OHWBaseViewController.h"

@interface OHWBaseViewController ()

@end

@implementation OHWBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav-bar.png"] forBarMetrics: UIBarMetricsDefault];
  UIBarButtonItem *revealButton = [[UIBarButtonItem alloc]
                                   initWithImage:[UIImage imageNamed:@"button-label-menu.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(revealSidebar:)];
  self.navigationItem.leftBarButtonItem = revealButton;
}

- (IBAction)revealSidebar:(UIBarButtonItem *)sender {
  [self.viewDeckController toggleLeftViewAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
