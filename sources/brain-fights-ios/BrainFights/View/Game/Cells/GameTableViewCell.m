//
//  GameTableViewCell.m
//  BrainFights
//
//  Created by Artem Demidovich on 11/9/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import "GameTableViewCell.h"

@interface GameTableViewCell()

// Модель игры
@property UserGameModel *gameModel;

@end

@implementation GameTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


// Инициализируем ячейку игры
-(void) initCell:(UserGameModel*) model {
    self.gameModel = model;
    if ([model.gameStatus isEqualToString:GAME_STATUS_WAITING])
        [self initWaitingGame];
    if ([model.gameStatus isEqualToString:GAME_STATUS_STARTED])
        [self initStartedGame];
    if ([model.gameStatus isEqualToString:GAME_STATUS_FINISHED])
        [self initFinishedGame];
}


// Инициализируем ожидающую игру
-(void) initWaitingGame {
    [self.userName setText:self.gameModel.oponent.user.name];
    [self.userPosition setText:self.gameModel.oponent.user.position];
    
    [self.gameStatus setText:self.gameModel.gamerStatus];
}

// Инициализируем запущеную игру
-(void) initStartedGame {
    [self.userName setText:self.gameModel.oponent.user.name];
    [self.userPosition setText:self.gameModel.oponent.user.position];
    
    [self.gameStatus setText:self.gameModel.gamerStatus];
}

// Инициализируем законченную игру
-(void) initFinishedGame {
    [self.userName setText:self.gameModel.oponent.user.name];
    [self.userPosition setText:self.gameModel.oponent.user.position];
    
    [self.gameStatus setText:self.gameModel.gamerStatus];
}



@end
