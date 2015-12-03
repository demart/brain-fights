//
//  FriendsHeaderTableViewCell.m
//  BrainFights
//
//  Created by Artem Demidovich on 11/22/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import "FriendsHeaderTableViewCell.h"
#import "AppDelegate.h"

@implementation FriendsHeaderTableViewCell

- (void)awakeFromNib {
    [self.friendsTitle setTextColor:[Constants SYSTEM_COLOR_ORANGE]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
