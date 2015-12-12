//
//  UserDepartmentTableViewCell.m
//  BrainFights
//
//  Created by Artem Demidovich on 11/22/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import "UserDepartmentTableViewCell.h"

@implementation UserDepartmentTableViewCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


-(void) initCell:(DepartmentModel*)departmentModel withIndex:(NSInteger)index lastLevel:(BOOL)last {
    if (index == 0) {
        [self.departmentValueTitle setText:@"Транстелеком"];
        [self.iconImageView setHidden:YES];
        self.iconLeftConstraint.constant = -18;
    } else {
        [self.departmentValueTitle setText:departmentModel.name];
        self.iconLeftConstraint.constant = -18 + (45 * (index));
        [self.iconImageView setHidden:NO];
    }
    
    if (last) {
        // show icon
        [self.lastLevelIcon setHidden:NO];
    } else {
        [self.lastLevelIcon setHidden:YES];
    }
}


@end
