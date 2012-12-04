//
//  OHWHistoryViewController.h
//  OhHeyWorld
//
//  Created by Eric Roland on 11/14/12.
//  Copyright (c) 2012 Oh Hey World, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <RestKit/RestKit.h>
#import <RestKit/RKRequestSerialization.h>
#import <KKGridView/KKGridView.h>
#import "OHWAppDelegate.h"

@interface OHWHistoryViewController : OHWBaseViewController <RKObjectLoaderDelegate, KKGridViewDataSource, KKGridViewDelegate>

@property (nonatomic, retain) NSArray* userLocations;
@property (nonatomic, retain) IBOutlet UICollectionView* collectionView;
@property (nonatomic, retain) IBOutlet UIButton *friendsViewButton;
@property (nonatomic, retain) Location *location;
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) User *loggedInUser;
@property (nonatomic, retain) UserFriend *userFriend;
@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *locationLabel;
@property (nonatomic, retain) id selectedModel;
@property (strong, nonatomic) IBOutlet UIButton *followButton;
@property (strong, nonatomic) IBOutlet UIButton *sendMessageButton;
@property (strong, nonatomic) IBOutlet UIImageView *profilePicture;
@property (strong, nonatomic) IBOutlet UILabel *blurbLabel;
@property (strong, nonatomic) IBOutlet KKGridView *gridView;

- (IBAction)showFriendsMapView:(id)sender;
- (IBAction)followUser:(id)sender;
- (IBAction)sendMessage:(id)sender;

@end
