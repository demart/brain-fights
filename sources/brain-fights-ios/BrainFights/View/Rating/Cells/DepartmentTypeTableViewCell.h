//
//  DepartmentTypeTableViewCell.h
//  BrainFights
//
//  Created by Artem Demidovich on 12/4/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DepartmentTypeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *departmentTypeTitle;

- (void) initCell:(NSString*)title isSelected:(BOOL)selected;

@end
