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

@interface GameStatusTableViewController : UITableViewController

// Инициализруем статус игры
- (void) setUserGameModel:(UserGameModel*)gameModel;

// Принимает последний ответ пользователя, для того чтобы показать результат игры и поздравить пользователя
- (void) lastQuestionAnswerResult:(GamerQuestionAnswerResultModel*)lastQuestionAnswerResult;

@end
