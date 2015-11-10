//
//  GameMainTableViewController.m
//  BrainFights
//
//  Created by Artem Demidovich on 11/6/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import "GameMainTableViewController.h"

#import "JVFloatingDrawerSpringAnimator.h"
#import "AppDelegate.h"
#import "NewGameTableViewCell.h"
#import "GameTableViewCell.h"

#import "GameService.h"
#import "UserService.h"
#import "UserGamesGroupedModel.h"
#import "UserGameGroupModel.h"
#import "UserGameModel.h"
#import "ResponseWrapperModel.h"

@interface GameMainTableViewController ()

// Загруженные игры пользователя
@property NSMutableArray *gameGroups;

@end

@implementation GameMainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void) viewWillAppear:(BOOL)animated {
    // Загружаем игры при появлении сцены
    [GameService retrieveGamesGrouped:^(ResponseWrapperModel *response) {
        // Check data and refresh table
        if ([response.status isEqualToString:SUCCESS]) {
            UserGamesGroupedModel *userGamesGrouppedModel = (UserGamesGroupedModel*)response.data;
            // Выставляем новый профиль пользователя (например баллы поменялись или еще что)
            [[UserService sharedInstance] setUserProfile:userGamesGrouppedModel.user];
            // Обновляем список игр
            self.gameGroups = userGamesGrouppedModel.gameGroups;
            // Обновляем таблицу
            [self.tableView reloadData];
        }
        
        if ([response.status isEqualToString:AUTHORIZATION_ERROR]) {
            // Show Authorization View
            [[AppDelegate globalDelegate] showAuthorizationView:self];
        }
        
        if ([response.status isEqualToString:SERVER_ERROR]) {
            // Show Error Alert
            // TODO
        }
        
    } onFailure:^(NSError *error) {
        // Show Erro Alert
        // TODO
    }];
}

- (IBAction)showMenuAction:(UIBarButtonItem *)sender {
    [[AppDelegate globalDelegate] toggleLeftDrawer:self animated:YES];
}

- (IBAction)showAuthScene:(UIBarButtonItem *)sender {
    [[AppDelegate globalDelegate] showAuthorizationView:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.gameGroups == nil)
        return 1;
    return [self.gameGroups count] + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
        return 1;

    if (self.gameGroups != nil) {
        UserGameGroupModel *gameGroup = (UserGameGroupModel*)self.gameGroups[section-1];
        if (gameGroup.games != nil)
            return [gameGroup.games count];
        return 0;
    }
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Новая игра
    if (indexPath.section == 0) {
        NewGameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewGameCell"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"NewGameTableViewCell" bundle:nil]forCellReuseIdentifier:@"NewGameCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"NewGameCell"];
        }
        
        return cell;
    }
    
    GameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GameCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"GameTableViewCell" bundle:nil]forCellReuseIdentifier:@"GameCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"GameCell"];
    }
    
    // Достаем игру
    UserGameGroupModel *gameGroupModel = (UserGameGroupModel*)self.gameGroups[indexPath.section-1];
    UserGameModel *userGame = gameGroupModel.games[indexPath.row];
    // Инициализируем ячейку
    [cell initCell:userGame];
    
    
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0)
        return 20;
    return 40;
}

-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
   if (section == 0)
       return nil;
    
    if (self.gameGroups != nil) {
        UserGameGroupModel *gameGroup = (UserGameGroupModel*)self.gameGroups[section-1];
        
        if ([gameGroup.status isEqualToString:GAME_STATUS_STARTED])
            return @"Активные";
        if ([gameGroup.status isEqualToString:GAME_STATUS_WAITING])
            return @"Ожидающие";
        if ([gameGroup.status isEqualToString:GAME_STATUS_FINISHED])
            return @"Завершенные";
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0)
        return 70;
    return 70;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        [self performSegueWithIdentifier:@"FromGamesToNewGame" sender:self];
    }
    
    if (indexPath.section == 1) {
        // Link to profile if it is not a waiting game
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
