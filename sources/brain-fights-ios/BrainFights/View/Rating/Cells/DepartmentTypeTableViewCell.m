//
//  DepartmentTypeTableViewCell.m
//  BrainFights
//
//  Created by Artem Demidovich on 12/4/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import "DepartmentTypeTableViewCell.h"

@implementation DepartmentTypeTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) initCell:(NSString*)title isSelected:(BOOL)selected {
    [self.departmentTypeTitle setText:title];
    self.selected = selected;
}
@end
