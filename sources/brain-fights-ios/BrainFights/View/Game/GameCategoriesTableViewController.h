//
//  GameCategoriesTableViewController.h
//  BrainFights
//
//  Created by Artem Demidovich on 11/12/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameModel.h"
#import "AppDelegate.h"
#import "GameService.h"
#import "BaseTableViewController.h"
#import "UrlHelper.h"

@interface GameCategoriesTableViewController : BaseTableViewController


// Передаем модель игры для того чтобы показать категории для выбора
-(void) initViewController:(GameModel*)gameModel fromGameStatus:(UITableViewController*) gameStatusController;


@end
