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
#import "GameGroupHeaderTableViewCell.h"

#import "GameStatusTableViewController.h"

#import "GameService.h"
#import "UserService.h"
#import "UserGamesGroupedModel.h"
#import "UserGameGroupModel.h"
#import "UserGameModel.h"
#import "ResponseWrapperModel.h"

#import "DejalActivityView.h"

@interface GameMainTableViewController ()

// Загруженные игры пользователя
@property NSMutableArray *gameGroups;

@end

@implementation GameMainTableViewController

static UIRefreshControl *refreshControl;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initRefreshControl];
    self.tableView.separatorColor = [UIColor clearColor];
}


-(void) initRefreshControl {
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.backgroundColor = [Constants SYSTEM_COLOR_GREEN];
    refreshControl.tintColor = [Constants SYSTEM_COLOR_WHITE];
    
    NSMutableAttributedString *mutableString = [[NSMutableAttributedString alloc] initWithString:@"Идет загрузка..."];
    NSRange range = NSMakeRange(0,mutableString.length);
    [mutableString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Gill Sans" size:(12.0)] range:range];
    [mutableString addAttribute:NSForegroundColorAttributeName value:[Constants SYSTEM_COLOR_WHITE] range:range];
    refreshControl.attributedTitle = mutableString;
    [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
}


- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Подождите\nИдет загрузка..."];
    [self loadGames];
}

-(void) viewWillDisappear:(BOOL)animated {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

-(void) handleRefresh:(UIRefreshControl*) refreshControll {
    [self loadGames];
    [refreshControl endRefreshing];
}

-(void) appDidBecomeActive:(NSNotification *)notification {
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Подождите\nИдет загрузка..."];
    [self loadGames];
}


-(void) loadGames {
    // Загружаем игры при появлении сцены
    [GameService retrieveGamesGrouped:^(ResponseWrapperModel *response) {
        [DejalBezelActivityView removeViewAnimated:NO];
        if ([response.status isEqualToString:SUCCESS]) {
            UserGamesGroupedModel *userGamesGrouppedModel = (UserGamesGroupedModel*)response.data;
            // Выставляем новый профиль пользователя (например баллы поменялись или еще что)
            [[UserService sharedInstance] setUserProfile:userGamesGrouppedModel.user];
            // Обновляем список игр
            self.gameGroups = userGamesGrouppedModel.gameGroups;
            [self.tableView reloadData];
        }
        
        if ([response.status isEqualToString:AUTHORIZATION_ERROR]) {
            [[AppDelegate globalDelegate] showAuthorizationView:self];
        }
        
        if ([response.status isEqualToString:SERVER_ERROR]) {
            [DejalBezelActivityView removeViewAnimated:NO];
            [self presentErrorViewController];
        }
        
    } onFailure:^(NSError *error) {
        [DejalBezelActivityView removeViewAnimated:NO];
        [self presentErrorViewController];
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
    
    UserGameGroupModel *gameGroupModel = (UserGameGroupModel*)self.gameGroups[indexPath.section-1];
    UserGameModel *userGame = gameGroupModel.games[indexPath.row];

    [cell initCell:userGame];
    
    
    return cell;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    GameGroupHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GameGroupHeaderCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"GameGroupHeaderTableViewCell" bundle:nil]forCellReuseIdentifier:@"GameGroupHeaderCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"GameGroupHeaderCell"];
    }
    
    if (section == 0) {
        [cell initCell:nil];
        return cell;
    }
    
    if (self.gameGroups[section-1] != nil){
        UserGameGroupModel *gameGroupModel = (UserGameGroupModel*)self.gameGroups[section-1];
        if ([gameGroupModel.status isEqualToString:GAME_STATUS_WAITING]) {
            [cell  initCell:@"Ожидающие"];
            return cell;
        }
        if ([gameGroupModel.status isEqualToString:GAME_STATUS_STARTED]) {
            [cell  initCell:@"Активные"];
            return cell;
        }
        if ([gameGroupModel.status isEqualToString:GAME_STATUS_FINISHED]) {
            [cell  initCell:@"Завершенные"];
            return cell;
        }
    }
    
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0)
        return 10;
    return 30;
}

/*
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
 */

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0)
        return 70;
    return 70;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        [self performSegueWithIdentifier:@"FromGamesToNewGame" sender:self];
    }
    
    if (indexPath.section > 0) {
        [self processSelectedRow];
    }
}


-(void) processSelectedRow {
    NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
    UserGameGroupModel *gameGroupModel = (UserGameGroupModel*)self.gameGroups[indexPath.section-1];
    UserGameModel *userGame = gameGroupModel.games[indexPath.row];
    if ([userGame.gamerStatus isEqualToString:GAMER_STATUS_WAITING_OWN_DECISION]) {
        // Если нам нужно принять решение
        [DejalBezelActivityView activityViewForView:self.view withLabel:@"Принимаем приглашение..."];
        [GameService acceptGameInvitation:userGame.id onSuccess:^(ResponseWrapperModel *response) {
            if ([response.status isEqualToString:SUCCESS]) {
                gameGroupModel.games[indexPath.row] = (UserGameModel*)response.data;
                [self performSegueWithIdentifier:@"FromGamesToGameStatus" sender:self];
            }
            
            if ([response.status isEqualToString:AUTHORIZATION_ERROR]) {
                [[AppDelegate globalDelegate] showAuthorizationView:self];
            }
            
            if ([response.status isEqualToString:SERVER_ERROR]) {
                // Show Error Alert
                [self presentErrorViewControllerWithTryAgainSelector:@selector(processSelectedRow)];
                [DejalBezelActivityView removeViewAnimated:NO];
            }
        } onFailure:^(NSError *error) {
            [self presentErrorViewControllerWithTryAgainSelector:@selector(processSelectedRow)];
            [DejalBezelActivityView removeViewAnimated:NO];
        }];
    } else
        if ([userGame.gamerStatus isEqualToString:GAMER_STATUS_WAITING_OPONENT_DECISION]) {
            // Если мы ждем принятия решения
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Внимание"
                                                                           message:@"Ожидаем решение опонента."
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        } else {
            // Check Status
            [self performSegueWithIdentifier:@"FromGamesToGameStatus" sender:self];
        }
}


 #pragma mark - Navigation

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if ([segue.destinationViewController isKindOfClass:[GameStatusTableViewController class]]) {
         GameStatusTableViewController *viewController = (GameStatusTableViewController*)segue.destinationViewController;
         // TODO add Back button title
         NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
         
         UserGameGroupModel *gameGroupModel = (UserGameGroupModel*)self.gameGroups[indexPath.section-1];
         UserGameModel *gameModel = gameGroupModel.games[indexPath.row];
         [viewController setUserGameModel:gameModel];
     }
 }

@end
