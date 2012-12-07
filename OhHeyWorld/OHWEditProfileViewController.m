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

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
  NSLog(@"%@", error);
  [_hudView stopActivityIndicator];
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
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
    switch (indexPath.row) {
      case 0:
      {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 100, 35)];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"First Name";
        label.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        label.textColor = [UIColor colorWithWhite:.28 alpha:1];
        [cell.contentView addSubview:label];
        
        UITextField *text = [[UITextField alloc] initWithFrame:CGRectMake(xOffset, 0, textLength, 35)];
        text.font = [UIFont fontWithName:@"Helvetica" size:15];
        text.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        text.text = _loggedInUser.firstName;
        text.textColor = [UIColor lightGrayColor];
        text.returnKeyType = UIReturnKeyDone;
        text.delegate = self;
        text.tag = 1;
        [cell.contentView addSubview:text];
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
        
        UITextField *text = [[UITextField alloc] initWithFrame:CGRectMake(xOffset, 0, textLength, 35)];
        text.font = [UIFont fontWithName:@"Helvetica" size:15];
        text.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        text.text = _loggedInUser.lastName;
        text.textColor = [UIColor lightGrayColor];
        text.returnKeyType = UIReturnKeyDone;
        text.delegate = self;
        text.tag = 2;
        [cell.contentView addSubview:text];
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
        
        UITextField *text = [[UITextField alloc] initWithFrame:CGRectMake(xOffset, 0, textLength, 35)];
        text.font = [UIFont fontWithName:@"Helvetica" size:15];
        text.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        //text.text = @"tests";
        text.textColor = [UIColor lightGrayColor];
        text.returnKeyType = UIReturnKeyDone;
        text.delegate = self;
        text.tag = 3;
        [cell.contentView addSubview:text];

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
        
        UITextField *text = [[UITextField alloc] initWithFrame:CGRectMake(xOffset, 0, textLength, 35)];
        text.font = [UIFont fontWithName:@"Helvetica" size:15];
        text.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        text.text = _loggedInUser.blurb;
        text.textColor = [UIColor lightGrayColor];
        text.returnKeyType = UIReturnKeyDone;
        text.delegate = self;
        text.tag = 4;
        [cell.contentView addSubview:text];
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
        
        UITextField *text = [[UITextField alloc] initWithFrame:CGRectMake(xOffset, 0, textLength, 35)];
        text.font = [UIFont fontWithName:@"Helvetica" size:15];
        text.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        //text.text = _loggedInUser;
        text.textColor = [UIColor lightGrayColor];
        text.returnKeyType = UIReturnKeyDone;
        text.delegate = self;
        text.tag = 5;
        [cell.contentView addSubview:text];
        break;
      }
      default:
        break;
    }
    
  }
  
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  cell.accessoryType = UITableViewCellAccessoryNone;
  
  return cell;
}

- (IBAction)saveProfile:(id)sender {
  [_hudView startActivityIndicator:self.view];
  for (NSInteger j = 0; j < [_tableView numberOfSections]; ++j)
  {
    for (NSInteger i = 0; i < [_tableView numberOfRowsInSection:j]; ++i)
    {
      UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]];
      UITextField *textField = (UITextField*)[cell viewWithTag:i];
      switch (i) {
        case 1:
          _loggedInUser.firstName = textField.text;
          break;
        case 2:
          _loggedInUser.lastName = textField.text;
          break;
        case 3:
          //_loggedInUser.firstName = textField.text;
          break;
        case 4:
          _loggedInUser.firstName = textField.text;
          break;
        case 5:
          //_loggedInUser.firstName = textField.text;
          break;
        default:
          break;
      }
    }
  }
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
  NSMutableDictionary* params = [NSMutableDictionary dictionaryWithDictionary:dictionary];
  [params setValue:@"auth_token" forKey: [appDelegate authToken]];
  [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[NSString stringWithFormat:@"/api/users/%@", _loggedInUser.externalId] usingBlock:^(RKObjectLoader *loader) {
    loader.method = RKRequestMethodPUT;
    loader.params = params;
    loader.userData = @"follow";
    loader.delegate = self;
  }];
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
  
  _hudView = [[HudView alloc] init];
  [_hudView loadActivityIndicator];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
