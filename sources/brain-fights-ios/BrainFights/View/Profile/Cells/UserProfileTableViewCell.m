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
    
    [self initCircleImageView:self.userImage];
}

-(void)initCircleImageView:(UIImageView*)imageView {
    imageView.layer.borderWidth = 2.0f;
    imageView.layer.borderColor = [Constants SYSTEM_COLOR_GREEN].CGColor;
    imageView.layer.cornerRadius = imageView.frame.size.width / 2;
    imageView.clipsToBounds = YES;
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
    [self.userScore sizeToFit];
    
    if (userProfile.lastActivityTime == nil || [userProfile.lastActivityTime isEqualToString:@""]) {
        [self.lastActivityTimeLabel setHidden:YES];
    } else {
        if (![userProfile.type isEqualToString:USER_TYPE_ME]) {
            [self.lastActivityTimeLabel setHidden:NO];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"dd LLLL yyyy 'в' HH:mm"];
//        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
            NSString *stringFromDate = [formatter stringFromDate:[userProfile getLastActivityTime]];
            NSString *lastActivityTime = [[NSString alloc] initWithFormat:@"Заходил %@", stringFromDate];
            [self.lastActivityTimeLabel setText:lastActivityTime];
        }
    }
}

@end
