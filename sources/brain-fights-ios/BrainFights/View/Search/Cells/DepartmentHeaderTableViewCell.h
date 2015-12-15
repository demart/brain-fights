//
//  DepartmentHeaderTableViewCell.h
//  BrainFights
//
//  Created by Artem Demidovich on 12/3/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DepartmentHeaderTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *departmentTitle;
@property (weak, nonatomic) IBOutlet UIImageView *departmentIcon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *departmentTitleLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *departmentTitleWithoutIconConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *departmentIconLeftContraint;

-(void) initCellWithTitle:(NSString*)title withMainHeader:(BOOL) isMainHeader isDepartment:(BOOL)isDepartment;

@end
