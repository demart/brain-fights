//
//  DepartmentHeaderTableViewCell.m
//  BrainFights
//
//  Created by Artem Demidovich on 12/3/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import "DepartmentHeaderTableViewCell.h"
#import "AppDelegate.h"

@implementation DepartmentHeaderTableViewCell

- (void)awakeFromNib {
    [self.departmentTitle setTextColor:[Constants SYSTEM_COLOR_ORANGE]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


-(void) initCellWithTitle:(NSString*)title  withMainHeader:(BOOL) isMainHeader isDepartment:(BOOL)isDepartment{
    if (isMainHeader) {
        self.backgroundColor = [Constants SYSTEM_COLOR_GREEN];
        self.departmentTitle.textColor = [Constants SYSTEM_COLOR_WHITE];
        self.departmentIcon.image = [UIImage imageNamed:@"organizationStructureIcon"];
        self.departmentTitleLeftConstraint.priority = 1000;
        self.departmentTitleWithoutIconConstraint.priority = 500;
        self.departmentIconLeftContraint.constant = 14;
    } else {
        /*
        if (isDepartment) {
            self.departmentTitle.textColor = [Constants SYSTEM_COLOR_ORANGE];
            self.departmentIcon.image = [UIImage imageNamed:@"organizationStructureIconGreen"];
        } else {
            self.departmentIcon.image = [UIImage imageNamed:@"gamerIcon"];
        }*/
        self.departmentTitleLeftConstraint.priority = 500;
        self.departmentTitleWithoutIconConstraint.priority = 1000;
        
        [self.departmentIcon removeFromSuperview];

    }

    [self.departmentTitle setText:title];
}

@end
