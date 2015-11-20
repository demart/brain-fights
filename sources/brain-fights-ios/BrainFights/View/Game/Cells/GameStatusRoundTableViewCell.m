//
//  GameStatusRoundTableViewCell.m
//  BrainFights
//
//  Created by Artem Demidovich on 11/12/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import "GameStatusRoundTableViewCell.h"

@implementation GameStatusRoundTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) initGameRound:(GameRoundModel*)gameRound withIndex:(NSInteger)gameRoundIndex {
    [self.gameRoundTitle setText: [[NSString alloc] initWithFormat:@"Раунд %li", gameRoundIndex]];
    if (gameRound == nil) {
        [self initEmptyRound];
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
        [self hightlightQuestion:gameRound.questions[0] withGamerView:self.gamerQuestion1View andOponentView:nil];
        [self hightlightQuestion:gameRound.questions[1] withGamerView:self.gamerQuestion2View andOponentView:nil];
        [self hightlightQuestion:gameRound.questions[2] withGamerView:self.gamerQuestion3View andOponentView:nil];
        // Показываем свои вопросы елси есть, и показываем "Играет" у противника
    }
    
}

-(void) hightlightQuestion:(GameRoundQuestionModel*) question withGamerView:(UIView*)gamerView andOponentView:(UIView*)oponentView {
    GameRoundQuestionAnswerModel *gamerAnswer = question.answer;
    GameRoundQuestionAnswerModel *oponentAnswer = question.oponentAnswer;
    if (gamerAnswer != nil) {
        if (gamerAnswer.isMissingAnswer == YES || gamerAnswer.isCorrect == NO) {
            [gamerView setBackgroundColor:[UIColor redColor]];
        } else {
            [gamerView setBackgroundColor:[UIColor greenColor]];
        }
    }
    
    if (oponentView != nil) {
        if (oponentAnswer.isMissingAnswer == YES || oponentAnswer.isCorrect == NO) {
            [oponentView setBackgroundColor:[UIColor redColor]];
        } else {
            [oponentView setBackgroundColor:[UIColor greenColor]];
        }
    }
    
}


-(void) initEmptyRound {
    [self.gamerQuestion1View setHidden:YES];
    [self.gamerQuestion2View setHidden:YES];
    [self.gamerQuestion3View setHidden:YES];
    [self.oponentQuestion1View setHidden:YES];
    [self.oponentQuestion2View setHidden:YES];
    [self.oponentQuestion3View setHidden:YES];
    [self.gameRoundCategoryTitle setText:nil];
}

@end
