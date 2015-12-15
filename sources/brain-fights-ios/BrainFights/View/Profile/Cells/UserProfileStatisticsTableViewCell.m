//
//  UserProfileStatisticsTableViewCell.m
//  BrainFights
//
//  Created by Artem Demidovich on 12/11/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import "UserProfileStatisticsTableViewCell.h"

@implementation UserProfileStatisticsTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void) initCell:(UserProfileModel*) userProfile {
    [self.totalGamesCount setText:[@(userProfile.totalGames) stringValue]];
    [self.wonGamesCount setText:[@(userProfile.wonGames) stringValue]];
    [self.lostGameCount setText:[@(userProfile.loosingGames) stringValue]];
}

@end