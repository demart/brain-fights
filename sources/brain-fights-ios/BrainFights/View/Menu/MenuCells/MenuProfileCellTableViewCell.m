//
//  MenuProfileCellTableViewCell.m
//  BrainFights
//
//  Created by Artem Demidovich on 11/8/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import "MenuProfileCellTableViewCell.h"

@interface MenuProfileCellTableViewCell()

@property UserProfileModel *userProfileModel;

@end


@implementation MenuProfileCellTableViewCell

- (void)awakeFromNib {
    UIColor *greenColor =  [UIColor colorWithRed:0.0/255.0f green:176.0/255.0f blue:80.0/255.0f alpha:1.0f];
    self.backgroundColor = greenColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void) initCell:(UserProfileModel*) userProfile {
    self.userProfileModel = userProfile;
    
    [self.userName setText:userProfile.name];
    [self.userJobPosition setText:userProfile.position];
    [self.userPosition setText:[@(userProfile.gamePosition) stringValue] ];
    [self.userScore setText:[@(userProfile.score) stringValue]];
    
    [self.totalGameCount setText:[@(userProfile.totalGames) stringValue]];
    [self.wonGameCount setText:[@(userProfile.wonGames) stringValue]];
    [self.looseGameCount setText:[@(userProfile.loosingGames) stringValue]];
    
    
    
}

@end
