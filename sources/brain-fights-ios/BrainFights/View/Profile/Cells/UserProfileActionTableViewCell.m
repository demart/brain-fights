//
//  UserProfileActionTableViewCell.m
//  BrainFights
//
//  Created by Artem Demidovich on 11/22/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import "UserProfileActionTableViewCell.h"

@interface UserProfileActionTableViewCell()

@property UserProfileModel *userProfile;

@property (nonatomic, copy) void (^addToFriendsActionBlock)(void);
@property (nonatomic, copy) void (^removeFromFriendsActionBlock)(void);
@property (nonatomic, copy) void (^playActionBlock)(void);

@end

@implementation UserProfileActionTableViewCell

- (void)awakeFromNib {
    self.backgroundColor = [Constants SYSTEM_COLOR_GREEN];
    self.oneActionView.backgroundColor = [Constants SYSTEM_COLOR_GREEN];
    self.twoActionsView.backgroundColor = [Constants SYSTEM_COLOR_GREEN];
    
    [self initButtonView:self.oneActionViewPlayButton];
    [self initButtonView:self.twoActionsViewAddToFriendButton];
    [self initButtonView:self.twoActionsViewPlayButton];    
}

-(void) initButtonView:(UIView*) view {
    view.layer.cornerRadius = 5.0;
    view.layer.masksToBounds = NO;
    view.layer.shadowOffset = CGSizeMake(1, 1);
    view.layer.shadowRadius = 8;
    view.layer.shadowOpacity = 0.5;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void) initCell:(UserProfileModel*)userProfileModel  onPlayAction:(void (^)(void))playAction  onAddToFriedsAction:(void (^)(void))addToFriendAction onRemoveFromFriedsAction:(void (^)(void))removeFromFriendAction {
    
    self.playActionBlock = playAction;
    self.addToFriendsActionBlock = addToFriendAction;
    self.removeFromFriendsActionBlock = removeFromFriendAction;
    
    self.userProfile = userProfileModel;
    if ([userProfileModel.type isEqualToString:USER_TYPE_OPONENT]) {
        [self.twoActionsView setHidden:NO];
//        [self.oneActionView setHidden:YES];
        [self.twoActionsViewAddToFriendButton setTitle:@"В друзья" forState:UIControlStateNormal];
        [self.twoActionsViewAddToFriendButton setBackgroundColor:[Constants SYSTEM_COLOR_ORANGE]];
    }
    if ([userProfileModel.type isEqualToString:USER_TYPE_FRIEND]) {
//        [self.twoActionsView setHidden:YES];
//        [self.oneActionView setHidden:NO];
        
        [self.twoActionsViewAddToFriendButton setTitle:@"Убрать из друзей" forState:UIControlStateNormal];
        [self.twoActionsViewAddToFriendButton setBackgroundColor:[Constants SYSTEM_COLOR_RED]];
    }
    
    if ([userProfileModel.type isEqualToString:USER_TYPE_ME]) {
        [self.twoActionsView setHidden:YES];
        [self.oneActionView setHidden:YES];
    }
}


- (IBAction)twoActionsViewPlayAction:(UIButton *)sender {
    self.playActionBlock();
}

- (IBAction)oneActionViewPlayAction:(UIButton *)sender {
    self.playActionBlock();
}

- (IBAction)twoActionsViewAddToFriendAction:(UIButton *)sender {
    if ([self.userProfile.type isEqualToString:USER_TYPE_FRIEND]) {
        self.removeFromFriendsActionBlock();
    } else {
        self.addToFriendsActionBlock();
    }
    
}

@end
