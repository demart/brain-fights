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

@end

@implementation GameStatusTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Show loading
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
        // Ожидаем ответов игрока
        // Начинаем новый раунд
        GameQuestionViewController *gameQuestionViewController = [[[AppDelegate globalDelegate] drawersStoryboard] instantiateViewControllerWithIdentifier:@"GameQuestionViewController"];
        [gameQuestionViewController initView:self];
        [self presentViewController:gameQuestionViewController animated:YES completion:nil];
    }
    
}

-(void) onSurrenderAction {
    NSLog(@"onSurrenderAction invoked");
}

-(void) onAddToFriendsAction {
    NSLog(@"onAddToFriendsAction invoked");
}

-(void) onRevancheAction {
    NSLog(@"onRevancheAction invoked");
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
