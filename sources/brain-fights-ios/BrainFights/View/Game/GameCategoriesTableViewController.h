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

@interface GameCategoriesTableViewController : UITableViewController


// Передаем модель игры для того чтобы показать категории для выбора
-(void) initViewController:(GameModel*)gameModel fromGameStatus:(UITableViewController*) gameStatusController;


@end
