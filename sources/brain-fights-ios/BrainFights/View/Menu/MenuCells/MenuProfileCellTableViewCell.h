//
//  MenuProfileCellTableViewCell.h
//  BrainFights
//
//  Created by Artem Demidovich on 11/8/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "UserProfileModel.h"

@interface MenuProfileCellTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *totalGameCount;
@property (weak, nonatomic) IBOutlet UILabel *wonGameCount;
@property (weak, nonatomic) IBOutlet UILabel *looseGameCount;
@property (weak, nonatomic) IBOutlet UILabel *userPosition;
@property (weak, nonatomic) IBOutlet UILabel *userScore;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userJobPosition;
@property (weak, nonatomic) IBOutlet UIView *sectionView1;
@property (weak, nonatomic) IBOutlet UIView *sectionView2;
@property (weak, nonatomic) IBOutlet UIView *sectionView3;

- (void) initCell:(UserProfileModel*) userProfile;

@end
