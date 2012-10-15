//
//  HudView.h
// 
//
//  Created by Eric Roland on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HudView : NSObject {
    UIActivityIndicatorView *_spinner;
    UIView *_hudView;
    UILabel *_captionLabel;
    BOOL _hasSecondHeaderBar;
}

@property (nonatomic, assign) BOOL hasSecondHeaderBar;

- (void)loadActivityIndicator;
- (void)startActivityIndicator:(UIView*)view;
- (void)stopActivityIndicator;

@end
