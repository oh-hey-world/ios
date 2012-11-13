//
//  OHWProviderFriendWebViewController.m
//  OhHeyWorld
//
//  Created by Eric Roland on 11/13/12.
//  Copyright (c) 2012 Oh Hey World, Inc. All rights reserved.
//

#import "OHWProviderFriendWebViewController.h"
#define appDelegate (OHWAppDelegate *)[[UIApplication sharedApplication] delegate]

@implementation OHWProviderFriendWebViewController
@synthesize webView = _webView;
@synthesize hudView = _hudView;

- (void)webViewDidFinishLoad:(UIWebView *)webView {
  [_hudView stopActivityIndicator];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
  [_hudView stopActivityIndicator];
}

- (IBAction)openBrowser:(id)sender {
  [[UIApplication sharedApplication] openURL:_url];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  ProviderFriend *providerFriend = [appDelegate userProviderFriend].providerFriend;
  _url = [NSURL URLWithString:providerFriend.link];
  NSURLRequest *requestObj = [NSURLRequest requestWithURL:_url];
  [_hudView startActivityIndicator:self.view];
  [_webView loadRequest:requestObj];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [_webView setDelegate:self];
  _hudView = [[HudView alloc] init];
  [_hudView loadActivityIndicator];
  UIBarButtonItem *browserButton = [[UIBarButtonItem alloc]
                                    initWithTitle:@"Browser"
                                    style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(openBrowser:)];
  self.navigationItem.rightBarButtonItem = browserButton;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
