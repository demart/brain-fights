//
//  GameStatusActionTableViewCell.m
//  BrainFights
//
//  Created by Artem Demidovich on 11/12/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import "GameStatusActionTableViewCell.h"
#import "UserGameModel.h"


@interface GameStatusActionTableViewCell()

@property UserGameModel* model;

@property (nonatomic, copy) void (^playActionBlock)(void);
@property (nonatomic, copy) void (^revancheActionBlock)(void);
@property (nonatomic, copy) void (^addToFriendsActionBlock)(void);
@property (nonatomic, copy) void (^surrenderActionBlock)(void);


@end

@implementation GameStatusActionTableViewCell


- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (void) initCell:(UserGameModel*) gameModel onPlayAction:(void (^)(void))playAction onSurrenderAction:(void (^)(void))surrenderAction onAddToFriendsAction:(void (^)(void))addToFriendsAction onRevancheAction:(void (^)(void))onRevancheAction {
    self.model = gameModel;
    self.playActionBlock = playAction;
    self.revancheActionBlock = onRevancheAction;
    self.surrenderActionBlock = surrenderAction;
    self.addToFriendsActionBlock = addToFriendsAction;
    
    if ([gameModel.gameStatus isEqualToString:GAME_STATUS_FINISHED]) {
        [self.surrenderActionButton setHidden:YES];
        [self.playButton setTitle:@"Реванш" forState:UIControlStateNormal];
    }
    
    if ([gameModel.gameStatus isEqualToString:GAME_STATUS_WAITING]) {
        // Не корректная ситация нужно убрать все кнопки
        [self.surrenderActionButton setHidden:YES];
        [self.playButton setHidden:YES];
        [self.addToFriendsButton setHidden:YES];
    }
    
    if ([gameModel.gameStatus isEqualToString:GAME_STATUS_STARTED]) {
        if ([gameModel.gamerStatus isEqualToString:GAMER_STATUS_WAITING_ANSWERS] ||
            [gameModel.gamerStatus isEqualToString:GAMER_STATUS_WAITING_ROUND]) {
            // Ход текущего игрока
            [self.playButton setTitle:@"Ваш ход!" forState:UIControlStateNormal];
        }
        
        if ([gameModel.gamerStatus isEqualToString:GAMER_STATUS_WAITING_OPONENT]) {
            // Ожидаем игрока
            [self.playButton setTitle:@"Ждем" forState:UIControlStateNormal];
            [self.playButton setEnabled:NO];
        }
    }
    
    if ([gameModel.oponent.user.type isEqualToString:USER_TYPE_FRIEND]) {
        [self.addToFriendsButton setHidden:YES];
    }
    
}


- (IBAction)surrenderAction:(id)sender {
    NSLog(@"surrender action invoked");
    self.surrenderActionBlock();
}

- (IBAction)addToFrindsAction:(UIButton *)sender {
    NSLog(@"addToFriends action invoked");
    self.addToFriendsActionBlock();
}

- (IBAction)playAction:(UIButton *)sender {
    if ([self.model.gameStatus isEqualToString:GAME_STATUS_FINISHED]){
        NSLog(@"revanche action invoked");
        self.revancheActionBlock();
    } else {
        NSLog(@"play action invoked");
        self.playActionBlock();
    }
}



@end
