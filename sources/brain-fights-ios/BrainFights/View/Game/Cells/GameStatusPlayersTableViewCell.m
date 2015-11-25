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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void) initCell:(GameModel*) gameModel {
    [self.gamerNameLabel setText:gameModel.me.user.name];
    [self.oponentNameLabel setText:gameModel.oponent.user.name];
    
    [self.gamerCorrectAnswerCountLabel setText:[@(gameModel.me.correctAnswerCount) stringValue]];
    [self.oponentCorrectAnswerLabel setText:[@(gameModel.oponent.correctAnswerCount) stringValue]];
}



@end
