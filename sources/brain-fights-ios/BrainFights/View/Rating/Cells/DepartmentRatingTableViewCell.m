//
//  DepartmentRatingTableViewCell.m
//  BrainFights
//
//  Created by Artem Demidovich on 12/10/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import "DepartmentRatingTableViewCell.h"

@interface DepartmentRatingTableViewCell()

@property DepartmentModel *departmentModel;

@end

@implementation DepartmentRatingTableViewCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void) initCell:(DepartmentModel*)departmentModel withIndex:(NSInteger)index {
    if (index % 2 == 1) {
        self.backgroundColor = [UIColor colorWithRed:240.0/255.0f green:240.0/255.0f blue:240.0/255.0f alpha:1.0];
    }

    [self.departmentTitle setText:departmentModel.name];
    [self.departmentPosition setText:[@(departmentModel.position) stringValue]];
    [self.departmentScore setText: [@(departmentModel.score) stringValue]];
    [self.departmentUserCount setText:[@(departmentModel.userCount) stringValue]];
    
    self.departmentModel = departmentModel;
    [self prepareAndShowRatingChanges];
}

- (void) prepareAndShowRatingChanges {
    if (self.departmentModel.lastStatisticsUpdate != nil) {
        // GAME POSITIONS
        NSInteger posistionChanges = self.departmentModel.position - self.departmentModel.lastPosition;
        if (posistionChanges < 0) {
            [self.departmentPositionChangesLabel setHidden:NO];
            // Green
            [self.departmentPositionChangesLabel setText:[[NSString alloc] initWithFormat:@"(+ %li)", labs(posistionChanges)]];
            [self.departmentPositionChangesLabel setTextColor:[Constants SYSTEM_COLOR_GREEN]];
        }
        if (posistionChanges > 0) {
            [self.departmentPositionChangesLabel setHidden:NO];
            // Red
            [self.departmentPositionChangesLabel setText:[[NSString alloc] initWithFormat:@"(- %li)", labs(posistionChanges)]];
            [self.departmentPositionChangesLabel setTextColor:[Constants SYSTEM_COLOR_RED]];
        }
        
        if (posistionChanges == 0) {
            [self.departmentPositionChangesLabel setHidden:YES];
            // Red
            [self.departmentPositionChangesLabel setText:[[NSString alloc] initWithFormat:@"( %li )", posistionChanges]];
            [self.departmentPositionChangesLabel setTextColor:[Constants SYSTEM_COLOR_LIGHT_GREY]];
        }
        
        // GAME POSITIONS
        NSInteger scoreChanges = self.departmentModel.score - self.departmentModel.lastScore;
        if (scoreChanges > 0) {
            [self.departmentScoreChangesLabel setHidden:NO];
            // Green
            [self.departmentScoreChangesLabel setText:[[NSString alloc] initWithFormat:@"(+ %li)", labs(scoreChanges)]];
            [self.departmentScoreChangesLabel setTextColor:[Constants SYSTEM_COLOR_GREEN]];
        }
        if (scoreChanges < 0) {
            [self.departmentScoreChangesLabel setHidden:NO];
            // Red
            [self.departmentScoreChangesLabel setText:[[NSString alloc] initWithFormat:@"(- %li)", labs(scoreChanges)]];
            [self.departmentScoreChangesLabel setTextColor:[Constants SYSTEM_COLOR_RED]];
        }
        
        if (scoreChanges == 0) {
            [self.departmentScoreChangesLabel setHidden:YES];
            // Red
            [self.departmentScoreChangesLabel setText:[[NSString alloc] initWithFormat:@"( %li )", scoreChanges]];
            [self.departmentScoreChangesLabel setTextColor:[Constants SYSTEM_COLOR_LIGHT_GREY]];
        }
        
    } else {
        [self.departmentPositionChangesLabel setHidden:YES];
        [self.departmentScoreChangesLabel setHidden:YES];
    }
}


@end
