//
//  UserTableViewCell.m
//  BrainFights
//
//  Created by Artem Demidovich on 11/9/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import "UserTableViewCell.h"

@implementation UserTableViewCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.roundView.backgroundColor = [Constants SYSTEM_COLOR_GREEN];
    self.roundView.layer.cornerRadius = 5.0;
    self.roundView.layer.masksToBounds = NO;
    self.roundView.layer.shadowOffset = CGSizeMake(1, 1);
    self.roundView.layer.shadowRadius = 3;
    self.roundView.layer.shadowOpacity = 0.5;
    self.backgroundColor = [Constants SYSTEM_COLOR_WHITE];
    
    self.userName.textColor = [Constants SYSTEM_COLOR_WHITE];
    self.userPosition.textColor = [Constants SYSTEM_COLOR_WHITE];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

// Инициализируем ячейкам
- (void) initCell:(UserProfileModel*) userProfile {
    self.userProfile = userProfile;
    
    [self.userName setText: userProfile.name];
    [self.userPosition setText:userProfile.position];
    
}

@end
