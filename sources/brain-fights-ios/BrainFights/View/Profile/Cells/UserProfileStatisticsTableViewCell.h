//
//  UserProfileStatisticsTableViewCell.h
//  BrainFights
//
//  Created by Artem Demidovich on 12/11/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface UserProfileStatisticsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *totalGamesCount;
@property (weak, nonatomic) IBOutlet UILabel *wonGamesCount;
@property (weak, nonatomic) IBOutlet UILabel *lostGameCount;


- (void) initCell:(UserProfileModel*) userProfile;


@end
