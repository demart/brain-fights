//
//  DepartmentTypeFilterTableViewCell.h
//  BrainFights
//
//  Created by Artem Demidovich on 12/4/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DepartmentTypeFilterTableViewCell : UITableViewCell

- (IBAction)showDepartmentTypeMenu:(UIButton *)sender;

- (void) initWithSelector:(void (^)(void))showDropdownMenuAction;

@end
