//
//  DepartmentRatingTableViewCell.h
//  BrainFights
//
//  Created by Artem Demidovich on 12/10/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserProfileModel.h"
#import "AppDelegate.h"

@interface DepartmentRatingTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *departmentPosition;
@property (weak, nonatomic) IBOutlet UILabel *departmentTitle;
@property (weak, nonatomic) IBOutlet UILabel *departmentUserCount;
@property (weak, nonatomic) IBOutlet UILabel *departmentScore;
@property (weak, nonatomic) IBOutlet UILabel *departmentPositionChangesLabel;
@property (weak, nonatomic) IBOutlet UILabel *departmentScoreChangesLabel;

- (void) initCell:(DepartmentModel*)departmentModel withIndex:(NSInteger)index;

@end
