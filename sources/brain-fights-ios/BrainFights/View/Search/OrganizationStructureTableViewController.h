//
//  OrganizationStructureTableViewController.h
//  BrainFights
//
//  Created by Artem Demidovich on 11/9/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DepartmentModel.h"

@interface OrganizationStructureTableViewController : UITableViewController

/*
 Идентификатор родителя, для того чтобы выгрузить детей
 */
@property DepartmentModel *parentDepartmentModel;

// Указываем родителя
-(void) setParentDepartment:(DepartmentModel*)department;

@end
