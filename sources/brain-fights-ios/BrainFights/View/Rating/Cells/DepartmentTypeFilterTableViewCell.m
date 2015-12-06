//
//  DepartmentTypeFilterTableViewCell.m
//  BrainFights
//
//  Created by Artem Demidovich on 12/4/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import "DepartmentTypeFilterTableViewCell.h"

@interface DepartmentTypeFilterTableViewCell()

@property (nonatomic, copy) void (^showDropdownMenuActionBlock)(void);

@end

@implementation DepartmentTypeFilterTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void) initWithSelector:(void (^)(void))showDropdownMenuAction {
    self.showDropdownMenuActionBlock = showDropdownMenuAction;
}


- (IBAction)showDepartmentTypeMenu:(UIButton *)sender {
    self.showDropdownMenuActionBlock();
}

@end
