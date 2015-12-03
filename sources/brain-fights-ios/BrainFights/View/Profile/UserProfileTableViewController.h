//
//  UserProfileTableViewController.h
//  BrainFights
//
//  Created by Artem Demidovich on 11/8/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UserProfileModel.h"

#import "BaseTableViewController.h"

@interface UserProfileTableViewController : BaseTableViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *showMenuButton;
- (IBAction)showMenuAction:(UIBarButtonItem *)sender;

// Указываем профиль пользователя
- (void) setUserProfile:(UserProfileModel*)user;

@end
