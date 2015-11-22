//
//  GameStatusPlayersTableViewCell.h
//  BrainFights
//
//  Created by Artem Demidovich on 11/12/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameModel.h"

@interface GameStatusPlayersTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *gamerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *oponentNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *gamerCorrectAnswerCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *oponentCorrectAnswerLabel;

- (void) initCell:(GameModel*) gameModel;

@end