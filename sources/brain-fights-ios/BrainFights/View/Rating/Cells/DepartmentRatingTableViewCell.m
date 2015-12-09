//
//  DepartmentRatingTableViewCell.m
//  BrainFights
//
//  Created by Artem Demidovich on 12/10/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import "DepartmentRatingTableViewCell.h"

@implementation DepartmentRatingTableViewCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void) initCell:(DepartmentModel*)departmentModel withIndex:(NSInteger)index {
    if (index % 2 == 1) {
        self.backgroundColor = [UIColor colorWithRed:240.0/255.0f green:240.0/255.0f blue:240.0/255.0f alpha:1.0];
    }
    
    [self.departmentTitle setText:departmentModel.name];
    [self.departmentPosition setText:@"-"];
    [self.departmentScore setText: [@(departmentModel.score) stringValue]];
    [self.departmentUserCount setText:[@(departmentModel.userCount) stringValue]];

}

@end
