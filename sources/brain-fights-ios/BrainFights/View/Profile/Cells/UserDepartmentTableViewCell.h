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
@property (weak, nonatomic) IBOutlet UILabel *departmentValueTitle;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconLeftConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *lastLevelIcon;

-(void) initCell:(DepartmentModel*)departmentModel withIndex:(NSInteger)index lastLevel:(BOOL)last;

@end
