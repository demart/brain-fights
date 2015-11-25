//
//  UserDepartmentTableViewCell.h
//  BrainFights
//
//  Created by Artem Demidovich on 11/22/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface UserDepartmentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *departmentTitle;
@property (weak, nonatomic) IBOutlet UILabel *departmentValueTitle;

-(void) initCell:(UserProfileModel*)userProfileModel;

@end
