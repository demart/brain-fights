//
//  GameTableViewCell.m
//  BrainFights
//
//  Created by Artem Demidovich on 11/9/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import "GameTableViewCell.h"
#import "UserGameModel.h"

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
    
    if ([self.gameModel.gamerStatus isEqualToString:GAMER_STATUS_WAITING_OPONENT_DECISION]) {
        [self.gameStatus setText:@"Ждем подтвержения"];
        // Show play icon
        [self.playGameView setHidden:YES];
    }
    
    if ([self.gameModel.gamerStatus isEqualToString:GAMER_STATUS_WAITING_OWN_DECISION]) {
        [self.gameStatus setText:@"Будете играть со мной?"];
        // Show play icon
        [self.playGameView setHidden:NO];
    }
    
}

// Инициализируем запущеную игру
-(void) initStartedGame {
    [self.userName setText:self.gameModel.oponent.user.name];
    [self.userPosition setText:self.gameModel.oponent.user.position];

    if ([self.gameModel.gamerStatus isEqualToString:GAMER_STATUS_WAITING_ROUND]) {
        [self.gameStatus setText:@"Ваш ход!"];
        // Show play icon
        [self.playGameView setHidden:NO];
    }
    
    if ([self.gameModel.gamerStatus isEqualToString:GAMER_STATUS_WAITING_ANSWERS]) {
        [self.gameStatus setText:@"Ваш ход!"];
        // Show play icon
        [self.playGameView setHidden:NO];
    }
    
    if ([self.gameModel.gamerStatus isEqualToString:GAMER_STATUS_WAITING_OPONENT]) {
        [self.gameStatus setText:@"Ждем игрока"];
        // Hide play icon
        [self.playGameView setHidden:YES];
    }
    
    
}

// Инициализируем законченную игру
-(void) initFinishedGame {
    [self.userName setText:self.gameModel.oponent.user.name];
    [self.userPosition setText:self.gameModel.oponent.user.position];
    
    if ([self.gameModel.gamerStatus isEqualToString:GAMER_STATUS_DRAW]) {
        [self.gameStatus setText:@"Ничья"];
        // Show play icon
        [self.playGameView setHidden:YES];
    }

    if ([self.gameModel.gamerStatus isEqualToString:GAMER_STATUS_LOOSER]) {
        [self.gameStatus setText:@"Вы проиграли"];
        // Show play icon
        [self.playGameView setHidden:YES];
    }
    if ([self.gameModel.gamerStatus isEqualToString:GAMER_STATUS_OPONENT_SURRENDED]) {
        [self.gameStatus setText:@"Игрок сдался"];
        // Show play icon
        [self.playGameView setHidden:YES];
    }
    if ([self.gameModel.gamerStatus isEqualToString:GAMER_STATUS_SURRENDED]) {
        [self.gameStatus setText:@"Вы сдались"];
        // Show play icon
        [self.playGameView setHidden:YES];
    }
    
    if ([self.gameModel.gamerStatus isEqualToString:GAMER_STATUS_WINNER]) {
        [self.gameStatus setText:@"Вы победили!"];
        // Show play icon
        [self.playGameView setHidden:YES];
        // Show triumph
    }
    
}



@end
