//
//  UserRatingTableViewCell.h
//  BrainFights
//
//  Created by Artem Demidovich on 11/21/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserProfileModel.h"

@interface UserRatingTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *gamePositionLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userPositionLabel;
@property (weak, nonatomic) IBOutlet UILabel *userScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *gamePositionChanges;
@property (weak, nonatomic) IBOutlet UILabel *userScoreChanges;
@property (weak, nonatomic) IBOutlet UILabel *thisIsYouLabel;

- (void) initCell:(UserProfileModel*)userProfile withIndex:(NSInteger)index;

@end
