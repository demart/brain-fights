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
@property NSInteger gameRoundIndex;
@property UIViewController* parentController;

@end

@implementation GameStatusRoundTableViewCell

- (void)awakeFromNib {
    [self initQuestionView:self.gamerQuestion1View];
    [self initQuestionView:self.gamerQuestion2View];
    [self initQuestionView:self.gamerQuestion3View];
    
    [self initQuestionView:self.oponentQuestion1View];
    [self initQuestionView:self.oponentQuestion2View];
    [self initQuestionView:self.oponentQuestion3View];
    
    self.backGroundViewHeader.layer.cornerRadius = 5.0;
    self.backGroundViewBottom.layer.cornerRadius = 5.0;
    
    [self initTapOnQuestionViews];

}

-(void) initQuestionView:(UIView*) view {
    view.layer.cornerRadius = 5.0;
    view.layer.masksToBounds = NO;
    view.layer.shadowOffset = CGSizeMake(1, 1);
    view.layer.shadowRadius = 1;
    view.layer.shadowOpacity = 0.5;
}

- (void) initTapOnQuestionViews {
    [self initTapOnQuestionView:self.gamerQuestion1View withSelector:@selector(tappedQuestion1View:)];
    [self initTapOnQuestionView:self.oponentQuestion1View withSelector:@selector(tappedQuestion1View:)];
    
    [self initTapOnQuestionView:self.gamerQuestion2View withSelector:@selector(tappedQuestion2View:)];
    [self initTapOnQuestionView:self.oponentQuestion2View withSelector:@selector(tappedQuestion2View:)];
    
    [self initTapOnQuestionView:self.gamerQuestion3View withSelector:@selector(tappedQuestion3View:)];
    [self initTapOnQuestionView:self.oponentQuestion3View withSelector:@selector(tappedQuestion3View:)];
}

- (void) initTapOnQuestionView:(UIView*)questionView withSelector:(SEL)selector {
    UITapGestureRecognizer *tapRecognizerForQuestionView = [[UITapGestureRecognizer alloc] initWithTarget:self action:selector];
    [tapRecognizerForQuestionView setNumberOfTapsRequired:1];
    [questionView addGestureRecognizer:tapRecognizerForQuestionView];
}

- (void) presentQuestionsResultAlertView:(NSInteger) roundQuestionIndex {
    NSInteger questionNumber = 0;
        questionNumber = (self.gameRoundIndex - 1) * 3 + roundQuestionIndex;
    NSString *title = [[NSString alloc] initWithFormat:@"Вопрос %li", questionNumber];
    
    GameRoundQuestionModel *questionModel = (GameRoundQuestionModel*)self.gameRoundModel.questions[roundQuestionIndex-1];
    
    NSString *message = [[NSString alloc] initWithFormat:@"%@", questionModel.text];
    
    if (questionModel.answer != nil) {
        if (questionModel.answer.isMissingAnswer) {
            message = [[NSString alloc] initWithFormat:@"%@\n\n%@: Не ответил на этот вопрос", message, self.gameModel.me.user.name];
        } else {
            message = [[NSString alloc] initWithFormat:@"%@\n\n%@: %@", message, self.gameModel.me.user.name, questionModel.answer.text];
        }
    }
    
    if (questionModel.oponentAnswer != nil) {
        if (questionModel.oponentAnswer.isMissingAnswer) {
            message = [[NSString alloc] initWithFormat:@"%@\n\n%@: Не ответил на этот вопрос", message, self.gameModel.oponent.user.name];
        } else {
            message = [[NSString alloc] initWithFormat:@"%@\n\n%@: %@", message, self.gameModel.oponent.user.name, questionModel.oponentAnswer.text];
        }
    }
    
    for (GameRoundQuestionAnswerModel *answer in questionModel.answers) {
        if (answer.isCorrect) {
            message = [[NSString alloc] initWithFormat:@"%@\n\nПравильный ответ: %@", message, answer.text];
            break;
        }
    }
    
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    [self.parentController presentViewController:alert animated:YES completion:nil];
}

- (void) tappedQuestion1View:(UITapGestureRecognizer *)recognizer {
    [self presentQuestionsResultAlertView:1];
}

- (void) tappedQuestion2View:(UITapGestureRecognizer *)recognizer {
    [self presentQuestionsResultAlertView:2];
}

- (void) tappedQuestion3View:(UITapGestureRecognizer *)recognizer {
    [self presentQuestionsResultAlertView:3];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void) initGameRound:(GameRoundModel*)gameRound andGame:(GameModel*)gameModel withIndex:(NSInteger)gameRoundIndex fromController:(UIViewController*)parentController{
    self.parentController = parentController;
    self.gameModel = gameModel;
    self.gameRoundModel = gameRound;
    self.gameRoundIndex = gameRoundIndex;
    [self.gameRoundTitle setText: [[NSString alloc] initWithFormat:@"Раунд %li", gameRoundIndex]];
    [self initEmptyRound];
    if (gameRound == nil) {
        // Если кто-то сдался, то нужно написать что тот сдался
        if ([gameModel.me.status isEqualToString:GAMER_STATUS_SURRENDED]) {
            [self.oponentStepLabel setHidden:NO];
            [self.oponentStepLabel setText:@""];
            [self.gamerStepLabel setHidden:NO];
            [self.gamerStepLabel setText:@"Сдался"];
            return;
        }
        
        if ([gameModel.oponent.status isEqualToString:GAMER_STATUS_SURRENDED]) {
            [self.oponentStepLabel setHidden:NO];
            [self.oponentStepLabel setText:@"Сдался"];
            [self.gamerStepLabel setHidden:NO];
            [self.gamerStepLabel setText:@""];
            return;
        }
        
        // Нормальный процесс
        if ((gameModel.gameRounds == nil && gameRoundIndex == 1) || ([gameModel.gameRounds count] == gameRoundIndex-1 && [((GameRoundModel*)gameModel.gameRounds[gameRoundIndex-2]).status isEqualToString:GAME_ROUND_STATUS_COMPLETED])) {
            if ([gameModel.me.status isEqualToString:GAMER_STATUS_WAITING_OPONENT]) {
                [self.oponentStepLabel setHidden:NO];
                [self.oponentStepLabel setText:@"Играет"];
                [self.gamerStepLabel setHidden:NO];
                [self.gamerStepLabel setText:@"Ждем"];
            } else {
                [self.gamerStepLabel setHidden:NO];
                [self.gamerStepLabel setText:@"Ваш ход!"];
            }
        }
    } else {
        [self initRoundData:gameRound];
    }
}


-(void) initRoundData:(GameRoundModel*) gameRound {
    [self.gameRoundCategoryTitle setText:gameRound.categoryName];
    
    if ([gameRound.status isEqualToString:GAME_ROUND_STATUS_COMPLETED]) {
        /*
        if ([self.gameModel.me.status isEqualToString:GAMER_STATUS_SURRENDED]) {
            [self.gamerStepLabel setHidden:NO];
            [self.gamerStepLabel setText:@"Сдался!"];
        }
        
        if ([self.gameModel.me.status isEqualToString:GAMER_STATUS_OPONENT_SURRENDED]) {
            [self.oponentStepLabel setHidden:NO];
            [self.oponentStepLabel setText:@"Сдался"];
        }
         */
        
        // Показываем всё
        [self hightlightQuestion:gameRound.questions[0] withGamerView:self.gamerQuestion1View andOponentView:self.oponentQuestion1View];
        [self hightlightQuestion:gameRound.questions[1] withGamerView:self.gamerQuestion2View andOponentView:self.oponentQuestion2View];
        [self hightlightQuestion:gameRound.questions[2] withGamerView:self.gamerQuestion3View andOponentView:self.oponentQuestion3View];
        
    } else {
        if ([self.gameModel.me.status isEqualToString:GAMER_STATUS_WAITING_ROUND]) {
            // 1. Возможно нужно начать раунд
            [self.gamerStepLabel setHidden:NO];
            [self.gamerStepLabel setText:@"Ваш ход!"];
        }
        if ([self.gameModel.me.status isEqualToString:GAMER_STATUS_WAITING_ANSWERS]) {
            // 1. Возможно нужно мне отвечать
            [self.gamerStepLabel setHidden:NO];
            [self.gamerStepLabel setText:@"Ваш ход"];
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
