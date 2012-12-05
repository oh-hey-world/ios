//
//  OHWLeftViewController.m
//  OhHeyWorld
//
//  Created by Eric Roland on 12/4/12.
//  Copyright (c) 2012 Oh Hey World, Inc. All rights reserved.
//

#import "OHWLeftViewController.h"

@interface OHWLeftViewController ()

@end

@implementation OHWLeftViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)navigate:(id)sender {
  NSString *viewName = nil;
  NSInteger tag = ((UIButton*)sender).tag;
  switch (tag) {
    case 0:
      viewName = @"CheckinView";
      break;
    case 1:
      viewName = nil;
      break;
    case 2:
      viewName = @"HistoryView";
      break;
    case 3:
      viewName = @"FriendsView";
      break;
    case 4:
      viewName = nil;
      break;
    case 5:
      viewName = nil;
      break;
    default:
      break;
  }
  
  //TODO remove check after i have implemented the views
  if (viewName != nil) {
    UIViewController *centerController = [self.storyboard instantiateViewControllerWithIdentifier:viewName];
    self.viewDeckController.centerController = [[UINavigationController alloc]initWithRootViewController:centerController];
    [self.viewDeckController toggleLeftViewAnimated:YES];
  }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
