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
#import <RestKit/RestKit.h>
#import <RestKit/RKRequestSerialization.h>
#import "OHWAppDelegate.h"
#import "KNMultiItemSelector.h"

@interface OHWEditProfileViewController : OHWBaseViewController <RKObjectLoaderDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, KNMultiItemSelectorDelegate>

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) User *loggedInUser;
@property (nonatomic, retain) HudView *hudView;
@property (strong, nonatomic) IBOutlet UIImageView *profilePicture;
@property (nonatomic, retain) UIImage *selectedImage;
@property (nonatomic, retain) UserAsset *userAsset;
@property (nonatomic, retain) NSArray *currentLanguages;
@property (nonatomic, retain) NSMutableArray *languages;
@property (nonatomic, retain) NSMutableString *currentLanguageNames;

- (void)animateTextField:(UITextField*)textFieldup:(BOOL)up;
- (IBAction)saveProfile:(id)sender;
- (IBAction)changeProfilePicture:(id)sender;
- (void)presentModalHelper:(UIViewController*)controller;

@end
