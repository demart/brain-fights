//
//  GameStatusPlayersTableViewCell.m
//  BrainFights
//
//  Created by Artem Demidovich on 11/12/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import "GameStatusPlayersTableViewCell.h"

@implementation GameStatusPlayersTableViewCell

- (void)awakeFromNib {
    [self initCircleImageView:self.gamerAvatar];
    [self initCircleImageView:self.oponentAvatar];
}

-(void)initCircleImageView:(UIImageView*)imageView {
    imageView.layer.borderWidth = 1.0f;
    imageView.layer.borderColor = [Constants SYSTEM_COLOR_GREEN].CGColor;
    imageView.layer.cornerRadius = imageView.frame.size.width / 2;
    imageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void) initCell:(GameModel*) gameModel {
    [self.gamerNameLabel setText:gameModel.me.user.name];
    [self.oponentNameLabel setText:gameModel.oponent.user.name];
    
    [self.gamerCorrectAnswerCountLabel setText:[@(gameModel.me.correctAnswerCount) stringValue]];
    
    // Берем последний раунд
    if (gameModel.gameRounds!= nil && gameModel.gameRounds.count > 0) {
        GameRoundModel *gameRound = (GameRoundModel*)gameModel.gameRounds[gameModel.gameRounds.count -1];
        
        // Если он еще не завершен то показывать результат нельзя игроку. Так как он его либо сам не закончил
        // Либо его не закончил опонент
        if ([gameRound.status isEqualToString:GAME_ROUND_STATUS_COMPLETED]) {
            [self.oponentCorrectAnswerLabel setText:[@(gameModel.oponent.correctAnswerCount) stringValue]];
        } else {
            int oponentCorrectAnswerCount = 0;
            for (GameRoundQuestionModel *questionModel in gameRound.questions) {
                if (questionModel.oponentAnswer != nil && questionModel.oponentAnswer.isCorrect == YES) {
                    oponentCorrectAnswerCount +=1;
                }
            }
            [self.oponentCorrectAnswerLabel setText:[@(gameModel.oponent.correctAnswerCount-oponentCorrectAnswerCount) stringValue]];
        }
    } else {
        [self.oponentCorrectAnswerLabel setText:[@(gameModel.oponent.correctAnswerCount) stringValue]];
    }    
}



@end
