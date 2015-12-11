//
//  UserProfileTableViewCell.m
//  BrainFights
//
//  Created by Artem Demidovich on 12/11/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import "UserProfileTableViewCell.h"

@interface UserProfileTableViewCell()

@property UserProfileModel *userProfileModel;

@end

@implementation UserProfileTableViewCell

- (void)awakeFromNib {
    self.userImageContainerView.alpha = 1.0;
    self.userImageContainerView.layer.cornerRadius = 50;
    self.userImageContainerView.backgroundColor = [UIColor whiteColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void) initCell:(UserProfileModel*) userProfile {
    self.userProfileModel = userProfile;
    
    [self.userName setText:userProfile.name];
    [self.userPosition setText:userProfile.position];
    [self.userGamePosition setText:[@(userProfile.gamePosition) stringValue] ];
    [self.userScore setText:[@(userProfile.score) stringValue]];
    
    [self.userTotalGames setText:[@(userProfile.totalGames) stringValue]];
    [self.userWinGames setText:[@(userProfile.wonGames) stringValue]];
    [self.userLostGames setText:[@(userProfile.loosingGames) stringValue]];
    [self.userScore sizeToFit];
    

}

@end
