//
//  OHWProviderFriendWebViewController.h
//  OhHeyWorld
//
//  Created by Eric Roland on 11/13/12.
//  Copyright (c) 2012 Oh Hey World, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OHWAppDelegate.h"
#import "HudView.h"

@interface OHWProviderFriendWebViewController : OHWBaseViewController <UIWebViewDelegate>

@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) HudView *hudView;
@property (nonatomic, retain) NSURL *url;

- (IBAction)openBrowser:(id)sender;

@end
