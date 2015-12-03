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
