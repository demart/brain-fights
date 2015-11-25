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

#import "DejalActivityView.h"

@interface GameStatusTableViewController ()

@property UserGameModel *gameModel;
@property GameModel *model;
@property GamerQuestionAnswerResultModel *lastQuestionAnswerResult;



@end

@implementation GameStatusTableViewController

static UIRefreshControl* refreshControl;

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


-(void) handleRefresh:(UIRefreshControl*) refreshControll {
    [self refreshGameStatus];
    [refreshControl endRefreshing];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSLog(@"Status view will appear");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    // Show loading
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Подождите\nИдет загрузка..."];
    [self refreshGameStatus];
   
    if (self.lastQuestionAnswerResult != nil) {
        // Показываем последний результат пользователю (если это победа)
        if ([self.lastQuestionAnswerResult.gamerStatus isEqualToString:GAMER_STATUS_WINNER]) {
            // Победитель
            NSLog(@"Пользователь выиграл");
            [self presentSimpleAlertViewWithTitle:@"Поздравляем" andMessage:@"Вы выиграли эту игру!"];
        }
        if ([self.lastQuestionAnswerResult.gamerStatus isEqualToString:GAMER_STATUS_DRAW]) {
            // Ничья
            NSLog(@"Пользователь сыграл в ничью");
            [self presentSimpleAlertViewWithTitle:@"Ничья" andMessage:@"Победа была у вас в руках!"];
        }
        if ([self.lastQuestionAnswerResult.gamerStatus isEqualToString:GAMER_STATUS_LOOSER]) {
            // Проиграл
            NSLog(@"Пользователь проиграл");
            [self presentSimpleAlertViewWithTitle:@"Проигрыш" andMessage:@"Вы проигралы эту игру!"];
        }
        self.lastQuestionAnswerResult = nil;
    }
}

-(void) viewWillDisappear:(BOOL)animated {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

-(void) appDidBecomeActive:(NSNotification *)notification {
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Подождите\nИдет загрузка..."];
    [self refreshGameStatus];
}

-(void) refreshGameStatus {
    [GameService retrieveGameInformation:self.gameModel.id onSuccess:^(ResponseWrapperModel *response) {
        if ([response.status isEqualToString:SUCCESS]) {
            self.model = (GameModel*)response.data;
            [self.tableView reloadData];
        }
        
        if ([response.status isEqualToString:AUTHORIZATION_ERROR]) {
            [[AppDelegate globalDelegate] showAuthorizationView:self];
        }
        
        if ([response.status isEqualToString:SERVER_ERROR]) {
            [self presentErrorViewControllerWithTryAgainSelector:@selector(refreshGameStatus)];
        }
        [DejalBezelActivityView removeViewAnimated:NO];
    } onFailure:^(NSError *error) {
        [DejalBezelActivityView removeViewAnimated:NO];
        [self presentErrorViewControllerWithTryAgainSelector:@selector(refreshGameStatus)];
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
    if (self.model == nil)
        return 0;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.model == nil)
        return 0;
    return 8;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        GameStatusPlayersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GameStatusPlayersCell"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"GameStatusPlayersTableViewCell" bundle:nil]forCellReuseIdentifier:@"GameStatusPlayersCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"GameStatusPlayersCell"];
        }
        
        [cell initCell:self.model];
        
        return cell;
    }

    if (indexPath.row > 0 && indexPath.row < 7) {
        GameStatusRoundTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GameStatusRoundCell"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"GameStatusRoundTableViewCell" bundle:nil]forCellReuseIdentifier:@"GameStatusRoundCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"GameStatusRoundCell"];
        }
        
        if (self.model.gameRounds != nil && indexPath.row <= [self.model.gameRounds count]) {
            [cell initGameRound:self.model.gameRounds[indexPath.row-1] andGame:self.model withIndex:indexPath.row];
        } else {
            [cell initGameRound:nil andGame:self.model withIndex:indexPath.row];
        }
        
        return cell;
    }
    
    if (indexPath.row == 7) {
        GameStatusActionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GameStatusActionCell"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"GameStatusActionTableViewCell" bundle:nil]forCellReuseIdentifier:@"GameStatusActionCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"GameStatusActionCell"];
        }
        
        [cell initCell:self.model onPlayAction:^{
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
        [DejalBezelActivityView activityViewForView:self.view withLabel:@"Подождите\nИдет загрузка..."];
        [GameService getRoundQuestions:self.model.id withRound:self.model.lastRound.id onSuccess:^(ResponseWrapperModel *response) {
            if ([response.status isEqualToString:SUCCESS]) {
                GameRoundModel *gameRoundModel = (GameRoundModel*)response.data;
                // Начинаем новый раунд
                GameQuestionViewController *gameQuestionViewController = [[[AppDelegate globalDelegate] drawersStoryboard] instantiateViewControllerWithIdentifier:@"GameQuestionViewController"];
                [gameQuestionViewController initView:self withGameModel:self.model withGameRoundModel:gameRoundModel];
                [self presentViewController:gameQuestionViewController animated:YES completion:nil];
            }
            
            if ([response.status isEqualToString:AUTHORIZATION_ERROR]) {
                [[AppDelegate globalDelegate] showAuthorizationView:self];
            }
            
            if ([response.status isEqualToString:SERVER_ERROR]) {
                [self presentErrorViewControllerWithTryAgainSelector:@selector(onPlayAction)];
            }
            [DejalBezelActivityView removeViewAnimated:NO];
            
        } onFailure:^(NSError *error) {
            [DejalBezelActivityView removeViewAnimated:NO];
            [self presentErrorViewControllerWithTryAgainSelector:@selector(onPlayAction)];
        }];
    }
    
}

-(void) onSurrenderAction {
    NSLog(@"onSurrenderAction invoked");

    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Подождите\nИдет загрузка..."];
    [GameService surrenderGame:self.gameModel.id onSuccess:^(ResponseWrapperModel *response) {
        if ([response.status isEqualToString:SUCCESS]) {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Вы сдались!"
                                                                           message:@"В данной игре вы сдались. Ваш опонент заработал 18 очков."
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                                                                  }];
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
        if ([response.status isEqualToString:AUTHORIZATION_ERROR]) {
            [[AppDelegate globalDelegate] showAuthorizationView:self];
        }
        
        if ([response.status isEqualToString:SERVER_ERROR]) {
            [self presentErrorViewControllerWithTryAgainSelector:@selector(onSurrenderAction)];
        }
        [DejalBezelActivityView removeViewAnimated:NO];
        
    } onFailure:^(NSError *error) {
        [DejalBezelActivityView removeViewAnimated:NO];
        [self presentErrorViewControllerWithTryAgainSelector:@selector(onSurrenderAction)];
    }];
}

-(void) onAddToFriendsAction {
    NSLog(@"onAddToFriendsAction invoked");
    
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Подождите\nИдет загрузка..."];
    NSUInteger userId = self.gameModel.oponent.user.id;
    [[UserService sharedInstance] addUserFriendAsync:userId onSuccess:^(ResponseWrapperModel *response) {
        if ([response.status isEqualToString:SUCCESS]) {
            [self refreshGameStatus];
        }
        
        if ([response.status isEqualToString:AUTHORIZATION_ERROR]) {
            [DejalBezelActivityView removeViewAnimated:NO];
            [[AppDelegate globalDelegate] showAuthorizationView:self];
        }
        
        if ([response.status isEqualToString:SERVER_ERROR]) {
            [DejalBezelActivityView removeViewAnimated:NO];
            [self presentErrorViewControllerWithTryAgainSelector:@selector(onAddToFriendsAction)];
        }
        
    } onFailure:^(NSError *error) {
        [DejalBezelActivityView removeViewAnimated:NO];
        [self presentErrorViewControllerWithTryAgainSelector:@selector(onAddToFriendsAction)];
    }];
}

-(void) onRevancheAction {
    NSLog(@"onRevancheAction invoked");

    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Подождите\nИдет загрузка..."];
    NSUInteger oponentId = self.gameModel.oponent.user.id;
    [GameService createGameInvitation:oponentId onSuccess:^(ResponseWrapperModel *response) {
        if ([response.status isEqualToString:SUCCESS]) {
            [DejalBezelActivityView removeViewAnimated:YES];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        if ([response.status isEqualToString:AUTHORIZATION_ERROR]) {
            [DejalBezelActivityView removeViewAnimated:NO];
            [[AppDelegate globalDelegate] showAuthorizationView:self];
        }
        
        if ([response.status isEqualToString:SERVER_ERROR]) {
            [DejalBezelActivityView removeViewAnimated:NO];
            [self presentErrorViewControllerWithTryAgainSelector:@selector(onRevancheAction)];
        }
        
    } onFailure:^(NSError *error) {
        [DejalBezelActivityView removeViewAnimated:NO];
        [self presentErrorViewControllerWithTryAgainSelector:@selector(onRevancheAction)];
    }];
    
}


static CGFloat HEIGHT = 504;

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"Table View Height: %f", tableView.bounds.size.height);
    //NSLog(@"Proporting View Height: %f", proportion);
    CGFloat proportion = tableView.bounds.size.height / HEIGHT;
    
    if (indexPath.row == 0)
        return 70;
    if (indexPath.row == 7)
        return tableView.bounds.size.height - ((70 + 55*6) * proportion);
    return 55*proportion;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
