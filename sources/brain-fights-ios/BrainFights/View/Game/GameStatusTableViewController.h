//
//  GameStatusTableViewController.h
//  BrainFights
//
//  Created by Artem Demidovich on 11/11/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UserGameModel.h"

@interface GameStatusTableViewController : UITableViewController

// Инициализруем статус игры
-(void) setUserGameModel:(UserGameModel*)gameModel;

@end
