//
//  HudView.m
// 
//
//  Created by Eric Roland on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HudView.h"
#import <QuartzCore/QuartzCore.h>

@implementation HudView
@synthesize hasSecondHeaderBar = _hasSecondHeaderBar;

- (void)loadActivityIndicator {
    int hudHeightOffset = 85;
    /*if (self.hasSecondHeaderBar) {
        hudHeightOffset = 85;
    }*/
    _hudView = [[UIView alloc] initWithFrame:CGRectMake(75, hudHeightOffset, 170, 170)];
    _hudView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    _hudView.clipsToBounds = YES;
    _hudView.layer.cornerRadius = 10.0;

    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _spinner.frame = CGRectMake(65, 40, _spinner.bounds.size.width, _spinner.bounds.size.height);
    [_hudView addSubview:_spinner];

    _captionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 115, 130, 22)];
    _captionLabel.backgroundColor = [UIColor clearColor];
    _captionLabel.textColor = [UIColor whiteColor];
    _captionLabel.adjustsFontSizeToFitWidth = YES;
    _captionLabel.textAlignment = kCTCenterTextAlignment;
    _captionLabel.text = @"Loading...";
    [_hudView addSubview:_captionLabel];
}

- (void)startActivityIndicator:(UIView*)view {
    [_spinner startAnimating];
    [view addSubview:_hudView];
}

- (void)stopActivityIndicator {
    [_spinner stopAnimating];
    [_hudView removeFromSuperview];
}

@end
