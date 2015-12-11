//
//  UserProfileTableViewCell.h
//  BrainFights
//
//  Created by Artem Demidovich on 12/11/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface UserProfileTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userPosition;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userTotalGames;
@property (weak, nonatomic) IBOutlet UILabel *userWinGames;
@property (weak, nonatomic) IBOutlet UILabel *userLostGames;
@property (weak, nonatomic) IBOutlet UIView *userImageContainerView;
@property (weak, nonatomic) IBOutlet UILabel *userScore;
@property (weak, nonatomic) IBOutlet UILabel *userGamePosition;

- (void) initCell:(UserProfileModel*) userProfile;

@end
