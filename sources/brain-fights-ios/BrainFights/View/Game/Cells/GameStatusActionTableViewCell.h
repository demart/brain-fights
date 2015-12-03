//
//  GameStatusActionTableViewCell.h
//  BrainFights
//
//  Created by Artem Demidovich on 11/12/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameModel.h"

@interface GameStatusActionTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *surrenderActionButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *addToFriendsButton;

- (IBAction)playAction:(UIButton *)sender;
- (IBAction)surrenderAction:(UIButton *)sender;
- (IBAction)addToFrindsAction:(UIButton *)sender;

- (void) initCell:(GameModel*) gameModel onPlayAction:(void (^)(void))playAction onSurrenderAction:(void (^)(void))surrenderAction onAddToFriendsAction:(void (^)(void))addToFriendsAction onRevancheAction:(void (^)(void))onRevancheAction;

@end
