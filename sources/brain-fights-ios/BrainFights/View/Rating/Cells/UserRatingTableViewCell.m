//
//  UserRatingTableViewCell.m
//  BrainFights
//
//  Created by Artem Demidovich on 11/21/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import "UserRatingTableViewCell.h"
#import "DepartmentModel.h"
#import "AppDelegate.h"

@implementation UserRatingTableViewCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void) initCell:(UserProfileModel*)userProfile withIndex:(NSInteger)index {
    if (index % 2 == 1) {
        self.backgroundColor = [UIColor colorWithRed:242.0/255.0f green:242.0/255.0f blue:242.0/255.0f alpha:1.0];
    }
    
    [self.userNameLabel setText:userProfile.name];
    [self.userPositionLabel setText:userProfile.position];
    [self.userScoreLabel setText: [@(userProfile.score) stringValue]];
    [self.gamePositionLabel setText:[@(userProfile.gamePosition) stringValue]];
    
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

@end
