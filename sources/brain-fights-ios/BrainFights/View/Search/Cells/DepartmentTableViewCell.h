//
//  DepartmentTableViewCell.h
//  BrainFights
//
//  Created by Artem Demidovich on 11/10/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DepartmentModel.h"
#import "UserProfileModel.h"

@interface DepartmentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *departmentName;
@property (weak, nonatomic) IBOutlet UILabel *departmentScore;
@property (weak, nonatomic) IBOutlet UILabel *userBelongsToDepartment;
@property (weak, nonatomic) IBOutlet UILabel *departmentUserCount;

// Инициализирует ячейку данными департамента
- (void) initCell:(DepartmentModel*)model;

@end
