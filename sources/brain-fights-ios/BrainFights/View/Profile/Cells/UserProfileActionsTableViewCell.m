//
//  UserProfileActionsTableViewCell.m
//  BrainFights
//
//  Created by Artem Demidovich on 12/11/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import "UserProfileActionsTableViewCell.h"

@interface UserProfileActionsTableViewCell()


@property UserProfileModel *userProfile;

@property (nonatomic, copy) void (^addToFriendsActionBlock)(void);
@property (nonatomic, copy) void (^removeFromFriendsActionBlock)(void);
@property (nonatomic, copy) void (^playActionBlock)(void);

@property UITapGestureRecognizer *friendsTap;
@property UITapGestureRecognizer *playTap;

@end

@implementation UserProfileActionsTableViewCell

- (void)awakeFromNib {
    [self initButtonView:self.friendActionView];
    [self initButtonView:self.playActionView];
    
    // Слушаем нажание на "Друга"
    self.friendsTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(friendActionTap:)];
    [self.friendsTap setNumberOfTapsRequired:1];
    [self.friendActionView addGestureRecognizer:self.friendsTap];
    
    // Слушаем нажание на "Играть"
    self.playTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playActionTap:)];
    [self.playTap setNumberOfTapsRequired:1];
    [self.playActionView addGestureRecognizer:self.playTap];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void) initCell:(UserProfileModel*)userProfileModel onPlayAction:(void (^)(void))playAction  onAddToFriedsAction:(void (^)(void))addToFriendAction onRemoveFromFriedsAction:(void (^)(void))removeFromFriendAction {
    
    self.playActionBlock = playAction;
    self.addToFriendsActionBlock = addToFriendAction;
    self.removeFromFriendsActionBlock = removeFromFriendAction;
    
    self.userProfile = userProfileModel;
    
    /*
    if ([userProfileModel.type isEqualToString:USER_TYPE_ME]) {
        [self.friendActionView setHidden:YES];
        [self.playActionView setHidden:YES];
        return;
    }
     */
    
    
    // Проверки для кнопки "В ДРУЗЬЯ"
    if ([userProfileModel.type isEqualToString:USER_TYPE_OPONENT]) {
        [self.friendActionLabel setText:@"В ДРУЗЬЯ"];
        [self.friendActionImage setImage:[UIImage imageNamed:@"addFriendIcon"]];
        [self.friendActionLabel setTextColor:[Constants SYSTEM_COLOR_GREEN]];
    }
    if ([userProfileModel.type isEqualToString:USER_TYPE_FRIEND]) {
        [self.friendActionLabel setText:@"УБРАТЬ"];
        [self.friendActionImage setImage:[UIImage imageNamed:@"removeFriendIcon"]];
        [self.friendActionLabel setTextColor:[Constants SYSTEM_COLOR_RED]];
    }
    
    // Проверки для кнопки "Играть"
    if ([self.userProfile.playStatus isEqualToString:USER_GAME_PLAYING_STATUS_INVITED]) {
        [self.playActionLabel setText:@"ПРИГЛАШЕНИЕ ОТПРАВЛЕНО"];
        [self.playActionView setBackgroundColor:[Constants SYSTEM_COLOR_LIGHT_GREY]];
    }
    if ([self.userProfile.playStatus isEqualToString:USER_GAME_PLAYING_STATUS_PLAYING]) {
        [self.playActionLabel setText:@"ВЫ УЖЕ ИГРАЕТЕ"];
        [self.playActionView setBackgroundColor:[Constants SYSTEM_COLOR_LIGHT_GREY]];
    }
    if ([self.userProfile.playStatus isEqualToString:USER_GAME_PLAYING_STATUS_WAITING]) {
        [self.playActionLabel setText:@"ИГРОК ОЖИДАЕТ ВАС"];
        [self.playActionView setBackgroundColor:[Constants SYSTEM_COLOR_ORANGE]];
    }
    if ([self.userProfile.playStatus isEqualToString:USER_GAME_PLAYING_STATUS_READY]) {
        [self.playActionLabel setText:@"ПРИГЛАСИТЬ СЫГРАТЬ?"];
    }
}

- (void) initCell:(UserProfileModel*) userProfile {
    
}

-(void) initButtonView:(UIView*) view {
    view.layer.cornerRadius = 5.0;
    view.layer.masksToBounds = NO;
    view.layer.shadowOffset = CGSizeMake(2, 2);
    view.layer.shadowRadius = 2.5;
    view.layer.shadowOpacity = 0.5;
}


- (void)playActionTap:(UITapGestureRecognizer *)recognizer {
    if ([self.userProfile.playStatus isEqualToString:USER_GAME_PLAYING_STATUS_INVITED]) {
        return;
    }
    if ([self.userProfile.playStatus isEqualToString:USER_GAME_PLAYING_STATUS_PLAYING]) {
        return;
    }
    if ([self.userProfile.playStatus isEqualToString:USER_GAME_PLAYING_STATUS_WAITING]) {
        return;
    }
    if ([self.userProfile.playStatus isEqualToString:USER_GAME_PLAYING_STATUS_READY]) {
        self.playActionBlock();
    }
}

- (void)friendActionTap:(UITapGestureRecognizer *)recognizer {
    if ([self.userProfile.type isEqualToString:USER_TYPE_FRIEND]) {
        self.removeFromFriendsActionBlock();
    } else {
        self.addToFriendsActionBlock();
    }
    
}

@end
