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
    self.backgroundColor = [Constants SYSTEM_COLOR_GREEN];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self initSectionView:self.sectionView1];
    [self initSectionView:self.sectionView2];
    [self initSectionView:self.sectionView3];
}

-(void) initSectionView:(UIView*) view {
    view.layer.cornerRadius = 5.0;
    view.layer.masksToBounds = NO;
    view.layer.shadowOffset = CGSizeMake(1, 1);
    view.layer.shadowRadius = 5;
    view.layer.shadowOpacity = 0.5;
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
