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
    self.backgroundColor = [Constants SYSTEM_COLOR_GREEN];
    [self.departmentTitle setTextColor:[Constants SYSTEM_COLOR_WHITE]];
    [self.departmentValueTitle setTextColor:[Constants SYSTEM_COLOR_WHITE]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


-(void) initCell:(UserProfileModel*)userProfileModel {
    [self.departmentValueTitle setText:[self hierarchyBuilder:userProfileModel.department]];
}

-(NSString*) hierarchyBuilder:(DepartmentModel*)department {
    if (department == nil)
        return @"";
    return [[NSString alloc]initWithFormat:@"%@\n -> %@", [self hierarchyBuilder:department.parent], department.name ];
}

@end
