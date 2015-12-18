//
//  GameTableViewCell.m
//  BrainFights
//
//  Created by Artem Demidovich on 11/9/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import "GameTableViewCell.h"
#import "UserGameModel.h"
#import "AppDelegate.h"

@interface GameTableViewCell()

// Модель игры
@property UserGameModel *gameModel;

@end

@implementation GameTableViewCell

- (void)awakeFromNib {
    [self initView:self.gamerBackGroundView];
    [self.gamerBackGroundView setBackgroundColor:[Constants SYSTEM_COLOR_GREEN]];
    
    self.userAvatar.layer.borderWidth = 1.0f;
    self.userAvatar.layer.borderColor = [Constants SYSTEM_COLOR_WHITE].CGColor;
    self.userAvatar.layer.cornerRadius = self.userAvatar.frame.size.width / 2;
    self.userAvatar.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void) initView:(UIView*) view {
    view.layer.cornerRadius = 5.0;
    view.layer.masksToBounds = NO;
    view.layer.shadowOffset = CGSizeMake(2, 2);
    view.layer.shadowRadius = 1;
    view.layer.shadowOpacity = 0.5;
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
    [self.gamerBackGroundView setBackgroundColor:[Constants SYSTEM_COLOR_GREEN]];
    
    if ([self.gameModel.gamerStatus isEqualToString:GAMER_STATUS_WAITING_OPONENT_DECISION]) {
        [self.gameStatus setText:@"Ждем игрока"];
        [self.playGameView setImage:[UIImage imageNamed:@"waitingIcon"]];
    }
    
    if ([self.gameModel.gamerStatus isEqualToString:GAMER_STATUS_WAITING_OWN_DECISION]) {
        [self.gameStatus setText:@"Сыграем?"];
        [self.playGameView setHidden:NO];
    }
    [self calculateWaitingTime];
    
}

// Инициализируем запущеную игру
-(void) initStartedGame {
    [self.userName setText:self.gameModel.oponent.user.name];
    [self.userPosition setText:self.gameModel.oponent.user.position];
    [self calculateWaitingTime];
    
    [self.gamerBackGroundView setBackgroundColor:[Constants SYSTEM_COLOR_ORANGE]];
//  [self.gamerBackGroundView setBackgroundColor:[Constants SYSTEM_COLOR_GREEN]];
    
    if ([self.gameModel.gamerStatus isEqualToString:GAMER_STATUS_WAITING_ROUND]) {
        [self.gameStatus setText:@"Ваш ход!"];
        [self.playGameView setImage:[UIImage imageNamed:@"rightCircleIcon"]];        
        [self.playGameView setHidden:NO];
    }
    
    if ([self.gameModel.gamerStatus isEqualToString:GAMER_STATUS_WAITING_ANSWERS]) {
        [self.gameStatus setText:@"Ваш ход!"];
        [self.playGameView setImage:[UIImage imageNamed:@"rightCircleIcon"]];
        [self.playGameView setHidden:NO];
    }
    
    if ([self.gameModel.gamerStatus isEqualToString:GAMER_STATUS_WAITING_OPONENT]) {
        [self.gameStatus setText:@"Ждем игрока"];
        [self.playGameView setImage:[UIImage imageNamed:@"waitingIcon"]];
    }
    
    
}


// Инициализируем законченную игру
-(void) initFinishedGame {
    [self.userName setText:self.gameModel.oponent.user.name];
    [self.userPosition setText:self.gameModel.oponent.user.position];
    
    [self.gamerBackGroundView setBackgroundColor:[Constants SYSTEM_COLOR_DARK_GREY]];
    
    [self.waitingTimeLabel setHidden:YES];
    
    if ([self.gameModel.gamerStatus isEqualToString:GAMER_STATUS_DRAW]) {
        [self.gameStatus setText:@"Ничья"];
        [self.playGameView setImage:[UIImage imageNamed:@"handshakeIcon"]];
    }

    if ([self.gameModel.gamerStatus isEqualToString:GAMER_STATUS_LOOSER]) {
        [self.gameStatus setText:@"Вы проиграли"];
        [self.playGameView setImage:[UIImage imageNamed:@"looserIcon"]];
    }
    if ([self.gameModel.gamerStatus isEqualToString:GAMER_STATUS_OPONENT_SURRENDED]) {
        [self.gameStatus setText:@"Игрок сдался"];
        [self.playGameView setImage:[UIImage imageNamed:@"winnerIcon"]];
    }
    if ([self.gameModel.gamerStatus isEqualToString:GAMER_STATUS_SURRENDED]) {
        [self.gameStatus setText:@"Вы сдались"];
        [self.playGameView setImage:[UIImage imageNamed:@"looserIcon"]];
    }
    
    if ([self.gameModel.gamerStatus isEqualToString:GAMER_STATUS_WINNER]) {
        [self.gameStatus setText:@"Победа!"];
        [self.playGameView setImage:[UIImage imageNamed:@"winnerIcon"]];
    }
    
}

// Выводит сколько времени уже ждем игрока
- (void) calculateWaitingTime {
    NSDate *lastUpdateDate = [self.gameModel.me getLastUpdateStatusDate];
    NSDate *currentTime = [NSDate date];
    NSTimeInterval secondsBetween = [currentTime timeIntervalSinceDate:lastUpdateDate];
    
    if (secondsBetween > 86400) {
        // Больше дня
        int numberOfDays = secondsBetween / 86400;
        if (numberOfDays == 1)
            [self.waitingTimeLabel setText:@"1 день"];
        if (numberOfDays > 1)
            [self.waitingTimeLabel setText:[[NSString alloc] initWithFormat:@"%i дня", numberOfDays]];
            
    } else {
        if (secondsBetween > 3600) {
            // Больше часа
            int numberOfHours = secondsBetween / 3600;
            [self.waitingTimeLabel setText:[[NSString alloc] initWithFormat:@"%i час.", numberOfHours]];
        } else {
            // Меньше часа
            int numberOfMinutes = secondsBetween / 60;
            [self.waitingTimeLabel setText:[[NSString alloc] initWithFormat:@"%i мин.", numberOfMinutes]];
        }
    }
}



@end
