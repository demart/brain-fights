//
//  GameStatusTableViewController.h
//  BrainFights
//
//  Created by Artem Demidovich on 11/11/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"
#import "UserGameModel.h"
#import "GameModel.h"
#import "GameService.h"
#import "UserService.h"
#import "GamerQuestionAnswerResultModel.h"
#import "BaseTableViewController.h"

@interface GameStatusTableViewController : BaseTableViewController

// Инициализруем статус игры
- (void) setUserGameModel:(UserGameModel*)gameModel;

@end
