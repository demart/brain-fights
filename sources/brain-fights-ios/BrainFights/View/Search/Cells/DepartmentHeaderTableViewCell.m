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


-(void) initCellWithTitle:(NSString*)title {
    [self.departmentTitle setText:title];
}

@end
