//
//  GameTableViewCell.h
//  BrainFights
//
//  Created by Artem Demidovich on 11/9/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserGameModel.h"

@interface GameTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userPosition;
@property (weak, nonatomic) IBOutlet UILabel *gameStatus;
@property (weak, nonatomic) IBOutlet UIImageView *playGameView;
@property (weak, nonatomic) IBOutlet UIView *gamerBackGroundView;
@property (weak, nonatomic) IBOutlet UILabel *waitingTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userAvatar;

// Инициализируем ячейку игры
-(void) initCell:(UserGameModel*) model;

@end
