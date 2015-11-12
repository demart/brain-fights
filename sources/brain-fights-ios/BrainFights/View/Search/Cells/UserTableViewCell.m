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
