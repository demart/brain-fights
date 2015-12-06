//
//  UserRatingTableViewCell.m
//  BrainFights
//
//  Created by Artem Demidovich on 11/21/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import "UserRatingTableViewCell.h"
#import "DepartmentModel.h"

@implementation UserRatingTableViewCell

- (void)awakeFromNib {
    //self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void) initCell:(UserProfileModel*)userProfile {
    [self.userNameLabel setText:userProfile.name];
    [self.userPositionLabel setText:userProfile.position];
    [self.userScoreLabel setText: [@(userProfile.score) stringValue]];
    [self.gamePositionLabel setText:[@(userProfile.gamePosition) stringValue]];
    
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void) initCellWithDepartment:(DepartmentModel*)departmentModel {
    [self.userNameLabel setText:departmentModel.name];
    [self.userPositionLabel setText:nil];
    [self.userScoreLabel setText: [@(departmentModel.score) stringValue]];
    [self.gamePositionLabel setText:@"-"];
    
    self.accessoryType = UITableViewCellAccessoryNone;
}

@end
