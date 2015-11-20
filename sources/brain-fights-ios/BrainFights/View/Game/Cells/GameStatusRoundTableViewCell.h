//
//  GameStatusRoundTableViewCell.h
//  BrainFights
//
//  Created by Artem Demidovich on 11/12/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameModel.h"

@interface GameStatusRoundTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *gameRoundTitle;
@property (weak, nonatomic) IBOutlet UILabel *gameRoundCategoryTitle;

@property (weak, nonatomic) IBOutlet UIView *gamerQuestion1View;
@property (weak, nonatomic) IBOutlet UIView *gamerQuestion2View;
@property (weak, nonatomic) IBOutlet UIView *gamerQuestion3View;
@property (weak, nonatomic) IBOutlet UIView *oponentQuestion1View;
@property (weak, nonatomic) IBOutlet UIView *oponentQuestion2View;
@property (weak, nonatomic) IBOutlet UIView *oponentQuestion3View;

// Инициализируем ячейку
-(void) initGameRound:(GameRoundModel*)gameRound withIndex:(NSInteger)gameRoundIndex;

@end
