//
//  DepartmentTableViewCell.m
//  BrainFights
//
//  Created by Artem Demidovich on 11/10/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import "DepartmentTableViewCell.h"


@interface DepartmentTableViewCell()

@property DepartmentModel *departmentModel;

@end

@implementation DepartmentTableViewCell

- (void)awakeFromNib {
    self.departmentBackgroundView.backgroundColor = [Constants SYSTEM_COLOR_GREEN];
    self.departmentBackgroundView.layer.cornerRadius = 5.0;
    self.departmentBackgroundView.layer.masksToBounds = NO;
    self.departmentBackgroundView.layer.shadowOffset = CGSizeMake(1, 1);
    self.departmentBackgroundView.layer.shadowRadius = 3;
    self.departmentBackgroundView.layer.shadowOpacity = 0.5;
    self.backgroundColor = [Constants SYSTEM_COLOR_WHITE];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void) initCell:(DepartmentModel*)model {
    self.departmentModel = model;
    
    [self.departmentName setText:model.name];
    [self.departmentScore setText: [@(model.score) stringValue]];
    [self.departmentScore sizeToFit];
    [self.departmentUserCount setText: [@(model.userCount) stringValue]];
    [self.departmentUserCount sizeToFit];
    
    if (model.isUserBelongs) {
        [self.userBelongsToDepartment setHidden:NO];
    } else {
        [self.userBelongsToDepartment setHidden:YES];
    }
    
}

@end
