//
//  OHWEditProfileViewController.m
//  OhHeyWorld
//
//  Created by Eric Roland on 12/7/12.
//  Copyright (c) 2012 Oh Hey World, Inc. All rights reserved.
//

#import "OHWEditProfileViewController.h"
#define appDelegate (OHWAppDelegate *)[[UIApplication sharedApplication] delegate]

@interface OHWEditProfileViewController ()

@end

@implementation OHWEditProfileViewController
@synthesize tableView = _tableView;
@synthesize loggedInUser = _loggedInUser;
@synthesize hudView = _hudView;
@synthesize profilePicture = _profilePicture;
@synthesize selectedImage = _selectedImage;
@synthesize userAsset = _userAsset;
@synthesize languages = _languages;
@synthesize currentLanguages = _currentLanguages;
@synthesize currentLanguageNames = _currentLanguageNames;
@synthesize firstNameField = _firstNameField;
@synthesize lastNameField = _lastNameField;
@synthesize blurbField = _blurbField;
@synthesize interestsField = _interestsField;

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
  NSLog(@"%@", error);
  [_hudView stopActivityIndicator];
}

- (void)setCurrentCoreLanguages:(NSSet *)currentCoreLanguages {
  if (currentCoreLanguages.count > 0) {
    NSMutableArray *languageIds = [[NSMutableArray alloc] initWithCapacity:currentCoreLanguages.count];
    for (UserLanguage* userLanguage in currentCoreLanguages) {
      [languageIds addObject:userLanguage.languageId];
    }
    
    NSArray* languages = [ModelHelper getLanguagesByIds:languageIds];
    _currentLanguageNames = [[NSMutableString alloc] init];
    for (Language* language in languages) {
      NSPredicate *pred = [NSPredicate predicateWithFormat:@"selectValue = %@", [language.externalId stringValue]];
      NSArray *selectorItems = [_languages filteredArrayUsingPredicate:pred];
      KNSelectorItem *selectorItem = [selectorItems objectAtIndex:0];
      selectorItem.selected = YES;
      [_currentLanguageNames appendFormat:@"%@ ", language.name];
    }
  }
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
  if ([objectLoader.userData isEqualToString:@"userAsset"]) {
    [ModelHelper setOldAssetDefaultsFalse:_loggedInUser];
    
    _userAsset = [objects objectAtIndex:0];
    _userAsset.user = _loggedInUser;
    _userAsset.userId = _loggedInUser.externalId;
    _userAsset.isDefault = [NSNumber numberWithBool:YES];
    _userAsset.asset = UIImageJPEGRepresentation(_selectedImage, 1.0);
    if (_userAsset.externalId != nil) {
      [appDelegate saveContext];
    }
  } else if ([objectLoader.userData isEqualToString:@"userLanguages"]) {
    [_loggedInUser removeUserUserLanguages:_loggedInUser.userUserLanguages];
    for (UserLanguage* userLanguage in objects) {
      [_loggedInUser addUserUserLanguagesObject:userLanguage];
    }
    [appDelegate saveContext];
    [self setCurrentCoreLanguages:_loggedInUser.userUserLanguages];
    [_tableView reloadData];
  }
  [_hudView stopActivityIndicator];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];
  return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
  [self animateTextField:textField :YES];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
  [self animateTextField:textField :NO];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    float xOffset = 90;
    float textLength = 170;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    switch (indexPath.row) {
      case 0:
      {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 100, 35)];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"First Name";
        label.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        label.textColor = [UIColor colorWithWhite:.28 alpha:1];
        [cell.contentView addSubview:label];
        
        _firstNameField = [[UITextField alloc] initWithFrame:CGRectMake(xOffset, 0, textLength, 35)];
        _firstNameField.font = [UIFont fontWithName:@"Helvetica" size:15];
        _firstNameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _firstNameField.text = _loggedInUser.firstName;
        _firstNameField.textColor = [UIColor lightGrayColor];
        _firstNameField.returnKeyType = UIReturnKeyDone;
        _firstNameField.delegate = self;
        _firstNameField.tag = 0;
        [cell.contentView addSubview:_firstNameField];
        break;
      }
      case 1:
      {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 100, 35)];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"Last Name";
        label.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        label.textColor = [UIColor colorWithWhite:.28 alpha:1];
        [cell.contentView addSubview:label];
        
        _lastNameField = [[UITextField alloc] initWithFrame:CGRectMake(xOffset, 0, textLength, 35)];
        _lastNameField.font = [UIFont fontWithName:@"Helvetica" size:15];
        _lastNameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _lastNameField.text = _loggedInUser.lastName;
        _lastNameField.textColor = [UIColor lightGrayColor];
        _lastNameField.returnKeyType = UIReturnKeyDone;
        _lastNameField.delegate = self;
        _lastNameField.tag = 1;
        [cell.contentView addSubview:_lastNameField];
        break;
      }
      case 2:
      {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 100, 35)];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"Languages";
        label.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        label.textColor = [UIColor colorWithWhite:.28 alpha:1];
        [cell.contentView addSubview:label];
        
        UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(xOffset, 0, textLength, 35)];
        text.font = [UIFont fontWithName:@"Helvetica" size:15];
        
        text.textColor = [UIColor lightGrayColor];
        text.tag = 2;
        [cell.contentView addSubview:text];
        text.backgroundColor = [UIColor clearColor];
        
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;

        break;
      }
      case 3:
      {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 100, 35)];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"About";
        label.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        label.textColor = [UIColor colorWithWhite:.28 alpha:1];
        [cell.contentView addSubview:label];
        
        _blurbField = [[UITextField alloc] initWithFrame:CGRectMake(xOffset, 0, textLength, 35)];
        _blurbField.font = [UIFont fontWithName:@"Helvetica" size:15];
        _blurbField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _blurbField.text = _loggedInUser.blurb;
        _blurbField.textColor = [UIColor lightGrayColor];
        _blurbField.returnKeyType = UIReturnKeyDone;
        _blurbField.delegate = self;
        _blurbField.tag = 3;
        [cell.contentView addSubview:_blurbField];
        break;
      }
      case 4:
      {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 100, 35)];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"Interests";
        label.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        label.textColor = [UIColor colorWithWhite:.28 alpha:1];
        [cell.contentView addSubview:label];
        
        _interestsField = [[UITextField alloc] initWithFrame:CGRectMake(xOffset, 0, textLength, 35)];
        _interestsField.font = [UIFont fontWithName:@"Helvetica" size:15];
        _interestsField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _interestsField.text = _loggedInUser.interests;
        _interestsField.textColor = [UIColor lightGrayColor];
        _interestsField.returnKeyType = UIReturnKeyDone;
        _interestsField.delegate = self;
        _interestsField.tag = 4;
        [cell.contentView addSubview:_interestsField];
        break;
      }
      default:
        break;
    }
    
  }
  
  if (indexPath.row == 2) {
    UILabel *label = (UILabel*)[cell viewWithTag:3];
    label.text = (_currentLanguageNames.length > 0) ? _currentLanguageNames : @"None selected";
  }
  
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.row == 2) {
    KNMultiItemSelector * selector = [[KNMultiItemSelector alloc] initWithItems:_languages
                                                               preselectedItems: _currentLanguages
                                                                          title:@"Select your languages"
                                                                placeholderText:nil
                                                                       delegate:self];
    [self presentModalHelper:selector];
  }
}

- (void)presentModalHelper:(UIViewController*)controller {
  UINavigationController * uinav = [[UINavigationController alloc] initWithRootViewController:controller];
  uinav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
  uinav.modalPresentationStyle = UIModalPresentationFormSheet;
  [self presentModalViewController:uinav animated:YES];
}

-(void)selectorDidSelectItem:(KNSelectorItem *)selectedItem {
}

-(void)selectorDidDeselectItem:(KNSelectorItem *)selectedItem {
}

-(void)selectorDidFinishSelectionWithItems:(NSArray *)selectedItems {
  // Do whatever you want with the selected items
  NSString * text = @"Selected: ";
  for (KNSelectorItem * i in selectedItems) {
    text = [text stringByAppendingFormat:@"%@,", i.selectValue];
  }
  
  _currentLanguages = selectedItems;
  
  NSString *languageIds = @"";
  NSMutableString *currentLanguageIds = [[NSMutableString alloc] init];
  for (KNSelectorItem *item in _currentLanguages) {
    [currentLanguageIds appendFormat:@"%@,", item.selectValue];
  }
  
  if ( [currentLanguageIds length] > 0)
    languageIds = [currentLanguageIds substringToIndex:[currentLanguageIds length] - 1];

  NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
  [params setValue:[appDelegate authToken] forKey:@"auth_token" ];
  [params setValue:languageIds forKey:@"language_ids"];
  [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/api/user_languages/mass_update" usingBlock:^(RKObjectLoader *loader) {
    loader.method = RKRequestMethodPUT;
    loader.userData = @"userLanguages";
    loader.params = params;
    loader.delegate = self;
  }];
  
  [self dismissModalViewControllerAnimated:YES];
}

-(void)selectorDidCancelSelection {
  // You should dismiss modal controller here, it doesn't do that by itself
  [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)saveProfile:(id)sender {
  [_hudView startActivityIndicator:self.view];

  _loggedInUser.firstName = _firstNameField.text;
  _loggedInUser.lastName = _lastNameField.text;
  _loggedInUser.blurb = _blurbField.text;
  _loggedInUser.interests = _interestsField.text;

  [appDelegate saveContext];
  
  RKObjectMapping *serializationMapping = [[[RKObjectManager sharedManager] mappingProvider] serializationMappingForClass:[User class]];
  NSError* error = nil;
  NSMutableDictionary* dictionary = [[RKObjectSerializer serializerWithObject:_loggedInUser mapping:serializationMapping] serializedObject:&error];
  NSMutableDictionary *userDictionary = [dictionary valueForKey:@"user"];
  [userDictionary removeObjectForKey:@"id"];
  [userDictionary removeObjectForKey:@"slug"];
  [userDictionary removeObjectForKey:@"updated_at"];
  [userDictionary removeObjectForKey:@"created_at"];
  [userDictionary removeObjectForKey:@"roles_mask"];
  [userDictionary removeObjectForKey:@"residence_location"];
  [userDictionary removeObjectForKey:@"home_location"];
  [userDictionary removeObjectForKey:@"authentication_token"];
  NSMutableDictionary* params = [NSMutableDictionary dictionaryWithDictionary:dictionary];
  [params setValue:@"auth_token" forKey: [appDelegate authToken]];
  [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[NSString stringWithFormat:@"/api/users/%@", _loggedInUser.externalId] usingBlock:^(RKObjectLoader *loader) {
    loader.method = RKRequestMethodPUT;
    loader.params = params;
    loader.userData = @"updateUser";
    loader.delegate = self;
  }];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
  UIImagePickerControllerSourceType sourceType;
  
  switch (buttonIndex) {
    case 0:
      sourceType = UIImagePickerControllerSourceTypeCamera;;
      break;
    case 1:
      sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
      break;
  }
  
  if (buttonIndex != 2) {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    if ([UIImagePickerController isSourceTypeAvailable:sourceType])
    {
      imagePickerController.sourceType = sourceType;
      //NSArray* mediaTypes = [NSArray arrayWithObject:(id)kUTTypeImage];
      //imagePickerController.mediaTypes = mediaTypes;
      
      [self presentModalViewController:imagePickerController animated:YES];
    } else {
      BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Photo error" message:@"Option unavailable on this device"];
      [alert setCancelButtonWithTitle:@"Okay" block:^{
      }];
      [alert show];
    }
  }
}

- (IBAction)changeProfilePicture:(id)sender {
  UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take a photo", @"Choose from Library", nil];
	popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	[popupQuery showInView:self.view];
}

#pragma mark - UIImagePickerControllerDelegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
  [picker dismissModalViewControllerAnimated:YES];
  _selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
  _profilePicture.image = _selectedImage;
  UserAsset* userAsset = [UserAsset object];
  userAsset.user = _loggedInUser;
  userAsset.userId = _loggedInUser.externalId;
  userAsset.type = @"UserPhotoAsset";
  userAsset.isDefault = [NSNumber numberWithBool:YES];
  NSData *data = UIImageJPEGRepresentation(_selectedImage, 1.0);
  
  RKParams* params = [RKParams params];
  [params setData:data MIMEType:@"image/png" forParam:@"asset"];
  [params setValue:userAsset.userId forParam:@"userId"];
  [params setValue:userAsset.type forParam:@"type"];
  [params setValue:userAsset.isDefault forParam:@"isDefault"];
  [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/api/user_assets" usingBlock:^(RKObjectLoader *loader) {
    loader.method = RKRequestMethodPOST;
    loader.userData = @"userAsset";
    loader.params = params;
    loader.delegate = self;
  }];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo
{
  if (error == NULL) {
    
  } else {
    BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Photo error" message:@"We were unable to save your photo"];
    [alert setCancelButtonWithTitle:@"Okay" block:^{
    }];
    [alert show];
  }
}

- (void)animateTextField:(UITextField*)textFieldup:(BOOL)up
{
  const int movementDistance = (textFieldup.tag > 2) ? 170 : 100;
  const float movementDuration = 0.3f;
  
  int movement = (up ? -movementDistance : movementDistance);
  
  [UIView beginAnimations: @"anim" context: nil];
  [UIView setAnimationBeginsFromCurrentState: YES];
  [UIView setAnimationDuration: movementDuration];
  self.view.frame = CGRectOffset(self.view.frame, 0, movement);
  [UIView commitAnimations];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  _loggedInUser = [appDelegate loggedInUser];
  NSArray *languages = [CoreDataHelper searchObjectsInContext:@"Language" :nil :nil :NO :[appDelegate managedObjectContext]];
  _languages = [[NSMutableArray alloc] initWithCapacity:languages.count];
  for (Language *language in languages) {
    [_languages addObject:[[KNSelectorItem alloc] initWithDisplayValue:language.name selectValue:[language.externalId stringValue] imageUrl:nil]];
  }
  [self setCurrentCoreLanguages:_loggedInUser.userUserLanguages];
  _userAsset = [ModelHelper getDefaultUserAsset:_loggedInUser];
  
  if (_userAsset != nil) {
    if (_userAsset.asset.length == 0) {
      NSString *assetUrl = [NSString stringWithFormat:@"%@%@", [appDelegate baseUrl], _userAsset.assetUrl];
      [_profilePicture setImageWithURL:[NSURL URLWithString:assetUrl] placeholderImage:[UIImage imageNamed:@"profile-photo-default.png"] success:^(UIImage *image, BOOL chached) {
        _userAsset.asset = UIImageJPEGRepresentation(image, 1.0);
        [appDelegate saveContext];
      } failure:nil];
    } else {
      _profilePicture.image = [UIImage imageWithData:_userAsset.asset];
    }
  }
  
  _hudView = [[HudView alloc] init];
  [_hudView loadActivityIndicator];
}

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
	_tableView.backgroundView = nil;
  _tableView.backgroundColor = [UIColor clearColor];
  
  UIImage *image = [UIImage imageNamed:@"nav-bar-button.png"];
  UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
  saveButton.bounds = CGRectMake( 0, 0, image.size.width, image.size.height);
  [saveButton setImage:image forState:UIControlStateNormal];
  [saveButton addTarget:self action:@selector(saveProfile:) forControlEvents:UIControlEventTouchUpInside];
  UIBarButtonItem *saveBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
  self.navigationItem.rightBarButtonItem = saveBarButtonItem;
  
  UIImageView* img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title-edit-profile.png"]];
  self.navigationItem.titleView = img;
  
  _profilePicture = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile-photo-default.png"]];
  UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self action:@selector(changeProfilePicture:)];
  [tapRecognizer setNumberOfTouchesRequired:1];
  [tapRecognizer setDelegate:self];
  _profilePicture.userInteractionEnabled = YES;
  [_profilePicture addGestureRecognizer:tapRecognizer];
  _profilePicture.frame = CGRectMake(0, 0, self.view.bounds.size.width, 164.0f);
  _profilePicture.contentMode = UIViewContentModeScaleAspectFit;
  
  [self.view addSubview:_profilePicture];
  
  _hudView = [[HudView alloc] init];
  [_hudView loadActivityIndicator];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
