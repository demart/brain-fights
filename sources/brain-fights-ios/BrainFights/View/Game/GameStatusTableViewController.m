//
//  GameStatusTableViewController.m
//  BrainFights
//
//  Created by Artem Demidovich on 11/11/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import "GameStatusTableViewController.h"

#import "GameStatusPlayersTableViewCell.h"
#import "GameStatusRoundTableViewCell.h"
#import "GameStatusActionTableViewCell.h"

#import "GameCategoriesTableViewController.h"
#import "GameQuestionViewController.h"

@interface GameStatusTableViewController ()

@property UserGameModel *gameModel;
@property GameModel *model;
@property GamerQuestionAnswerResultModel *lastQuestionAnswerResult;

@end

@implementation GameStatusTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Show loading
    [self refreshGameStatus];
   
    if (self.lastQuestionAnswerResult != nil) {
        // Показываем последний результат пользователю (если это победа)
        if ([self.lastQuestionAnswerResult.gamerStatus isEqualToString:GAMER_STATUS_WINNER]) {
            // Победитель
            NSLog(@"Пользователь выиграл");
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Поздравляем"
                                                                           message:@"Вы выиграли эту игру!"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        if ([self.lastQuestionAnswerResult.gamerStatus isEqualToString:GAMER_STATUS_DRAW]) {
            // Ничья
            NSLog(@"Пользователь сыграл в ничью");
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Ничья"
                                                                           message:@"Победа была у вас в руках!"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        if ([self.lastQuestionAnswerResult.gamerStatus isEqualToString:GAMER_STATUS_LOOSER]) {
            // Проиграл
            NSLog(@"Пользователь проиграл");
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Проигрыш"
                                                                           message:@"Вы проигралы эту игру!"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        self.lastQuestionAnswerResult = nil;
    }
}


-(void) refreshGameStatus {
    [GameService retrieveGameInformation:self.gameModel.id onSuccess:^(ResponseWrapperModel *response) {
        if ([response.status isEqualToString:SUCCESS]) {
            self.model = (GameModel*)response.data;
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
        
    }];
}


// Инициализруем статус игры
-(void) setUserGameModel:(UserGameModel*)gameModel {
    self.gameModel = gameModel;
}

- (void) lastQuestionAnswerResult:(GamerQuestionAnswerResultModel*)lastQuestionAnswerResult {
    self.lastQuestionAnswerResult = lastQuestionAnswerResult;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        GameStatusPlayersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GameStatusPlayersCell"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"GameStatusPlayersTableViewCell" bundle:nil]forCellReuseIdentifier:@"GameStatusPlayersCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"GameStatusPlayersCell"];
        }
        
        return cell;
    }

    if (indexPath.row > 0 && indexPath.row < 7) {
        GameStatusRoundTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GameStatusRoundCell"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"GameStatusRoundTableViewCell" bundle:nil]forCellReuseIdentifier:@"GameStatusRoundCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"GameStatusRoundCell"];
        }
        
        if (self.model.gameRounds != nil && indexPath.row < [self.model.gameRounds count]) {
            [cell initGameRound:self.model.gameRounds[indexPath.row-1] withIndex:indexPath.row];
        } else {
            [cell initGameRound:nil withIndex:indexPath.row];
        }
        
        return cell;
    }
    
    if (indexPath.row == 7) {
        GameStatusActionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GameStatusActionCell"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"GameStatusActionTableViewCell" bundle:nil]forCellReuseIdentifier:@"GameStatusActionCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"GameStatusActionCell"];
        }
        
        [cell initCell:self.gameModel onPlayAction:^{
            [self onPlayAction];
        } onSurrenderAction:^{
            [self onSurrenderAction];
        } onAddToFriendsAction:^{
            [self onAddToFriendsAction];
        } onRevancheAction:^{
            [self onRevancheAction];
        }];
        
        
        return cell;
    }
    
    return nil;
}


-(void) onPlayAction {
    NSLog(@"onPlayAction invoked");

    if ([self.gameModel.gamerStatus isEqualToString:GAMER_STATUS_WAITING_ROUND]) {
        // Начинаем новый раунд
        GameCategoriesTableViewController *destinationController = [[GameCategoriesTableViewController alloc] init];
        [destinationController initViewController:self.model fromGameStatus:self];
        [self.navigationController pushViewController:destinationController animated:YES];
    }
    
    if ([self.gameModel.gamerStatus isEqualToString:GAMER_STATUS_WAITING_ANSWERS]) {
        // Подгужаем список вопросов для ответов
        // SHOW LOADING
        [GameService getRoundQuestions:self.model.id withRound:self.model.lastRound.id onSuccess:^(ResponseWrapperModel *response) {
            // Check data and refresh table
            if ([response.status isEqualToString:SUCCESS]) {
                GameRoundModel *gameRoundModel = (GameRoundModel*)response.data;
                
                // Начинаем новый раунд
                GameQuestionViewController *gameQuestionViewController = [[[AppDelegate globalDelegate] drawersStoryboard] instantiateViewControllerWithIdentifier:@"GameQuestionViewController"];
                [gameQuestionViewController initView:self withGameModel:self.model withGameRoundModel:gameRoundModel];
                [self presentViewController:gameQuestionViewController animated:YES completion:nil];
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
            // SHOW ERROR
        }];
    }
    
}

-(void) onSurrenderAction {
    NSLog(@"onSurrenderAction invoked");
    // Confirm question
    // Call API
    // Show result
    // Refresh view
    // Loading bar
    [GameService surrenderGame:self.gameModel.id onSuccess:^(ResponseWrapperModel *response) {
        // Hide loading bar
        // Show new score
        // Refresh table or view, becuse we got updated gameModel from server
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Вы сдались!"
                                                                       message:@"В данной игре вы сдались. Ваш опонент заработал 18 очков."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  [self.navigationController popToRootViewControllerAnimated:YES];
                                                              
                                                              }];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    } onFailure:^(NSError *error) {
        // Hide loading bar
        // Show error
    }];
}

-(void) onAddToFriendsAction {
    NSLog(@"onAddToFriendsAction invoked");
    // Call API
    // Refresh view
    // Maybe popup in the bottom
    // Show loading bar
    NSUInteger userId = self.gameModel.oponent.user.id;
    [[UserService sharedInstance] addUserFriendAsync:userId onSuccess:^(ResponseWrapperModel *response) {
        // Hide loading
        // Show message or doning something
    } onFailure:^(NSError *error) {
        // Hide loading
        // Show Error
    }];
}

-(void) onRevancheAction {
    NSLog(@"onRevancheAction invoked");
    // Create invitation
    // pop to back view with label
    // Show loading bar
    
    NSUInteger oponentId = self.gameModel.oponent.user.id;
    [GameService createGameInvitation:oponentId onSuccess:^(ResponseWrapperModel *response) {
        // Doing something
    } onFailure: ^(NSError *error) {
        // Show Error
    }];
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0)
        return 70;
    if (indexPath.row == 7)
        return 70;
    return 50;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
