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

@interface UserRatingTableViewCell()

@property UserProfileModel* userProfileModel;

@end


@implementation UserRatingTableViewCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void) initCell:(UserProfileModel*)userProfile withIndex:(NSInteger)index {
    self.userProfileModel = userProfile;
    if (index % 2 == 1) {
        self.backgroundColor = [UIColor colorWithRed:242.0/255.0f green:242.0/255.0f blue:242.0/255.0f alpha:1.0];
    }
    
    [self.userNameLabel setText:userProfile.name];
    [self.userPositionLabel setText:userProfile.position];
    [self.userScoreLabel setText: [@(userProfile.score) stringValue]];
    [self.gamePositionLabel setText:[@(userProfile.gamePosition) stringValue]];
    
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    [self prepareAndShowRatingChanges];
}

- (void) prepareAndShowRatingChanges {
    if (self.userProfileModel.lastStatisticsUpdate != nil) {
        // GAME POSITIONS
        NSInteger gamePosistionChanges = self.userProfileModel.gamePosition - self.userProfileModel.lastGamePosition;
        if (gamePosistionChanges < 0) {
            [self.gamePositionChanges setHidden:NO];
            // Green
            [self.gamePositionChanges setText:[[NSString alloc] initWithFormat:@"(+ %li)", labs(gamePosistionChanges)]];
            [self.gamePositionChanges setTextColor:[Constants SYSTEM_COLOR_GREEN]];
        }
        if (gamePosistionChanges > 0) {
            [self.gamePositionChanges setHidden:NO];
            // Red
            [self.gamePositionChanges setText:[[NSString alloc] initWithFormat:@"(- %li)", labs(gamePosistionChanges)]];
            [self.gamePositionChanges setTextColor:[Constants SYSTEM_COLOR_RED]];
        }

        if (gamePosistionChanges == 0) {
            [self.gamePositionChanges setHidden:YES];
            // Red
            [self.gamePositionChanges setText:[[NSString alloc] initWithFormat:@"( %li )", gamePosistionChanges]];
            [self.gamePositionChanges setTextColor:[Constants SYSTEM_COLOR_LIGHT_GREY]];
        }
        
        // GAME POSITIONS
        NSInteger userScoreChanges = self.userProfileModel.score - self.userProfileModel.lastScore;
        if (userScoreChanges > 0) {
            [self.userScoreChanges setHidden:NO];
            // Green
            [self.userScoreChanges setText:[[NSString alloc] initWithFormat:@"(+ %li)", labs(userScoreChanges)]];
            [self.userScoreChanges setTextColor:[Constants SYSTEM_COLOR_GREEN]];
        }
        if (userScoreChanges < 0) {
            [self.userScoreChanges setHidden:NO];
            // Red
            [self.userScoreChanges setText:[[NSString alloc] initWithFormat:@"(- %li)", labs(userScoreChanges)]];
            [self.userScoreChanges setTextColor:[Constants SYSTEM_COLOR_RED]];
        }
        
        if (userScoreChanges == 0) {
            [self.userScoreChanges setHidden:YES];
            // Red
            [self.userScoreChanges setText:[[NSString alloc] initWithFormat:@"( %li )", userScoreChanges]];
            [self.userScoreChanges setTextColor:[Constants SYSTEM_COLOR_LIGHT_GREY]];
        }
        
    } else {
        [self.gamePositionChanges setHidden:YES];
        [self.userScoreChanges setHidden:YES];
    }
}

@end
