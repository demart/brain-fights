//
//  GameStatusRoundTableViewCell.m
//  BrainFights
//
//  Created by Artem Demidovich on 11/12/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import "GameStatusRoundTableViewCell.h"
#import "Constants.h"

@interface GameStatusRoundTableViewCell()

@property GameRoundModel* gameRoundModel;
@property GameModel* gameModel;

@end

@implementation GameStatusRoundTableViewCell

- (void)awakeFromNib {
    self.gamerQuestion1View.layer.cornerRadius = 5.0;
    self.gamerQuestion2View.layer.cornerRadius = 5.0;
    self.gamerQuestion3View.layer.cornerRadius = 5.0;
    
    self.oponentQuestion1View.layer.cornerRadius = 5.0;
    self.oponentQuestion2View.layer.cornerRadius = 5.0;
    self.oponentQuestion3View.layer.cornerRadius = 5.0;

    self.backGroundViewHeader.layer.cornerRadius = 5.0;
    self.backGroundViewBottom.layer.cornerRadius = 5.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void) initGameRound:(GameRoundModel*)gameRound andGame:(GameModel*)gameModel withIndex:(NSInteger)gameRoundIndex {
    self.gameModel = gameModel;
    self.gameRoundModel = gameRound;
    [self.gameRoundTitle setText: [[NSString alloc] initWithFormat:@"Раунд %li", gameRoundIndex]];
    if (gameRound == nil) {
        [self initEmptyRound];
        if (gameRoundIndex == 1) {
            [self.gamerStepLabel setHidden:NO];
            [self.gamerStepLabel setText:@"Играет"];
        }
    } else {
        [self initRoundData:gameRound];
    }
}


-(void) initRoundData:(GameRoundModel*) gameRound {
    [self.gameRoundCategoryTitle setText:gameRound.categoryName];
    
    if ([gameRound.status isEqualToString:GAME_ROUND_STATUS_COMPLETED]) {
        // Показываем всё
        [self hightlightQuestion:gameRound.questions[0] withGamerView:self.gamerQuestion1View andOponentView:self.oponentQuestion1View];
        [self hightlightQuestion:gameRound.questions[1] withGamerView:self.gamerQuestion2View andOponentView:self.oponentQuestion2View];
        [self hightlightQuestion:gameRound.questions[2] withGamerView:self.gamerQuestion3View andOponentView:self.oponentQuestion3View];
    } else {
        if ([self.gameModel.me.status isEqualToString:GAMER_STATUS_WAITING_ROUND]) {
            // 1. Возможно нужно начать раунд
            [self.gamerStepLabel setHidden:NO];
            [self.gamerStepLabel setText:@"Играет"];
        }
        if ([self.gameModel.me.status isEqualToString:GAMER_STATUS_WAITING_ANSWERS]) {
            // 1. Возможно нужно мне отвечать
            [self.gamerStepLabel setHidden:NO];
            [self.gamerStepLabel setText:@"Играет"];
        }
        if ([self.gameModel.me.status isEqualToString:GAMER_STATUS_WAITING_OPONENT]) {
            // 2. Возможно нужно противнику отвечать
            [self.oponentStepLabel setHidden:NO];
            [self.oponentStepLabel setText:@"Играет"];
            [self hightlightQuestion:gameRound.questions[0] withGamerView:self.gamerQuestion1View andOponentView:nil];
            [self hightlightQuestion:gameRound.questions[1] withGamerView:self.gamerQuestion2View andOponentView:nil];
            [self hightlightQuestion:gameRound.questions[2] withGamerView:self.gamerQuestion3View andOponentView:nil];
        }
        
        // Показываем свои вопросы елси есть, и показываем "Играет" у противника
    }
    
}

-(void) hightlightQuestion:(GameRoundQuestionModel*) question withGamerView:(UIView*)gamerView andOponentView:(UIView*)oponentView {
    GameRoundQuestionAnswerModel *gamerAnswer = question.answer;
    GameRoundQuestionAnswerModel *oponentAnswer = question.oponentAnswer;
    if (gamerAnswer != nil) {
        [gamerView setHidden:NO];
        if (gamerAnswer.isMissingAnswer == YES || gamerAnswer.isCorrect == NO) {
            [gamerView setBackgroundColor:[Constants SYSTEM_COLOR_RED]];
        } else {
            [gamerView setBackgroundColor:[Constants SYSTEM_COLOR_GREEN]];
        }
    }
    
    if (oponentView != nil) {
        [oponentView setHidden:NO];
        if (oponentAnswer.isMissingAnswer == YES || oponentAnswer.isCorrect == NO) {
            [oponentView setBackgroundColor:[Constants SYSTEM_COLOR_RED]];
        } else {
            [oponentView setBackgroundColor:[Constants SYSTEM_COLOR_GREEN]];
        }
    }
    
}


-(void) initEmptyRound {
    [self.gamerStepLabel setHidden:YES];
    [self.oponentStepLabel setHidden:YES];
    
    [self.gamerQuestion1View setHidden:YES];
    [self.gamerQuestion2View setHidden:YES];
    [self.gamerQuestion3View setHidden:YES];
    [self.oponentQuestion1View setHidden:YES];
    [self.oponentQuestion2View setHidden:YES];
    [self.oponentQuestion3View setHidden:YES];
    [self.gameRoundCategoryTitle setText:nil];
}

@end
