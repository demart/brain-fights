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

@property NSMutableDictionary *loadImageOperations;
@property NSOperationQueue *loadImageOperationQueue;

@end

@implementation GameStatusTableViewController

static UIRefreshControl* refreshControl;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initRefreshControl];
    self.tableView.separatorColor = [UIColor clearColor];
    self.loadImageOperationQueue = [[NSOperationQueue alloc] init];
    [self.loadImageOperationQueue setMaxConcurrentOperationCount:2];
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
    [self refreshGameStatus:refreshControl];
//    [refreshControl endRefreshing];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSLog(@"Status view will appear");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    // Show loading
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Подождите\nИдет загрузка..."];
    [self refreshGameStatus:nil];
}

-(void) viewWillDisappear:(BOOL)animated {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [_loadImageOperationQueue cancelAllOperations];
    [_loadImageOperations removeAllObjects];

}

-(void) appDidBecomeActive:(NSNotification *)notification {
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Подождите\nИдет загрузка..."];
    [self refreshGameStatus:nil];
}

-(void) refreshGameStatus:(UIRefreshControl*) refreshControll {
    [GameService retrieveGameInformation:self.gameModel.id onSuccess:^(ResponseWrapperModel *response) {
        if (refreshControl != nil)
            [refreshControl endRefreshing];
        [DejalBezelActivityView removeViewAnimated:YES];
        
        if ([response.status isEqualToString:SUCCESS]) {
            self.model = (GameModel*)response.data;
            [self.tableView reloadData];
            [self checkAndShowFinalResultPromtMessage];
        }
        
        if ([response.status isEqualToString:AUTHORIZATION_ERROR]) {
            [[AppDelegate globalDelegate] showAuthorizationView:self];
        }
        
        if ([response.status isEqualToString:SERVER_ERROR]) {
            //[self presentErrorViewControllerWithTryAgainSelector:@selector(refreshGameStatus)];
            NSString* message = [[NSString alloc] initWithFormat:@"Ошибка при попытке обновить статус игры. Проверьте соединение с интернетом и попробуйте еще раз, Описание ошибки: %@ : %@", response.errorCode, response.errorMessage];
            [self presentSimpleAlertViewWithTitle:@"Ошибка" andMessage:message];
        }
        
    } onFailure:^(NSError *error) {
        if (refreshControl != nil) {
            [refreshControl endRefreshing];
        }
        [DejalBezelActivityView removeViewAnimated:NO];
        NSString* message = [[NSString alloc] initWithFormat:@"Ошибка при попытке обновить статус игры. Проверьте соединение с интернетом и попробуйте еще раз, Описание ошибки: %li : %@", error.code, error.localizedDescription.description];
        [self presentSimpleAlertViewWithTitle:@"Ошибка" andMessage:message];
        //[self presentErrorViewControllerWithTryAgainSelector:@selector(refreshGameStatus)];
    }];
}


// Проверяет есть ли завершенные игры и нужно ли показать результаты игры
// Показывает каждый раз только первую игру
- (void) checkAndShowFinalResultPromtMessage {
    if (self.model == nil)
        return;
    if ([self.model.status isEqualToString:GAME_STATUS_FINISHED]) {
        if (self.model.me.resultWasViewed == NO) {
            // Show Prompt message
            [self showPromtMessageWithViewedResultConfirmation:self.model];
            return;
        }
    }
}

// Показывает окошко с результатом игры
-(void) showPromtMessageWithViewedResultConfirmation:(GameModel*) gameModel {
    NSString* title = @"Игра закончилась";
    NSString* message;
    
    if ([gameModel.me.status isEqualToString:GAMER_STATUS_DRAW]) {
        message = [[NSString alloc] initWithFormat: @"Вы закончили игру в ничью с %@ \n Ваши очки: %li", gameModel.oponent.user.name, gameModel.me.resultScore];
    }
    if ([gameModel.me.status isEqualToString:GAMER_STATUS_LOOSER]) {
        message = [[NSString alloc] initWithFormat: @"Вы проиграли игру с %@ \n Ваши очки: %li", gameModel.oponent.user.name, gameModel.me.resultScore];
    }
    if ([gameModel.me.status isEqualToString:GAMER_STATUS_WINNER]) {
        message = [[NSString alloc] initWithFormat: @"Вы выиграли игру с %@ \n Ваши очки: %li", gameModel.oponent.user.name, gameModel.me.resultScore];
    }
    if ([gameModel.me.status isEqualToString:GAMER_STATUS_OPONENT_SURRENDED]) {
        message = [[NSString alloc] initWithFormat: @"Ваш опонент %@ сдался.\n Ваши очки: %li", gameModel.oponent.user.name, gameModel.me.resultScore];
    }
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [self markGameResultAsViewed:self.model];
                                                          }];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

// Отправляет отметку о прочтении на сервер
-(void) markGameResultAsViewed:(GameModel*)gameModel {
    if (gameModel == nil) {
        NSLog(@"MarkAsViewed gameModel null");
        return;
    }
    
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Подождите\nИдет загрузка..."];
    
    [GameService markAsViewed:gameModel.id andGamer:gameModel.me.id onSuccess:^(ResponseWrapperModel *response) {
        if ([response.status isEqualToString:SUCCESS]) {
            [self refreshGameStatus:nil];
        }
        
        if ([response.status isEqualToString:AUTHORIZATION_ERROR]) {
            [[AppDelegate globalDelegate] showAuthorizationView:self];
        }
        
        if ([response.status isEqualToString:SERVER_ERROR]) {
            [DejalBezelActivityView removeViewAnimated:NO];
        }
    } onFailure:^(NSError *error) {
        [DejalBezelActivityView removeViewAnimated:NO];
        NSLog(@"error mark as viewed");
    }];
    
}

// Инициализруем статус игры
-(void) setUserGameModel:(UserGameModel*)gameModel {
    self.gameModel = gameModel;
}

- (void) loadUserAvatarInImageView:(UIImageView*)imageView withImageUrl:(NSString*)imageUrl {
    UIImage *loadedImage =(UIImage *)[LocalStorageService  loadImageFromLocalCache:imageUrl];
    
    if (loadedImage != nil) {
        imageView.image = loadedImage;
    } else {
        NSBlockOperation *loadImageOperation = [[NSBlockOperation alloc] init];
        __weak NSBlockOperation *weakOperation = loadImageOperation;
        
        [loadImageOperation addExecutionBlock:^(void){
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:
                                                                                   [UrlHelper imageUrlForAvatarWithPath:imageUrl]
                                                                                   ]]];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^(void) {
                if (! weakOperation.isCancelled) {
                    if (image != nil) {
                        imageView.image = image;
                        [LocalStorageService  saveImageToLocalCache:imageUrl withData:image];
                    }
                    [self.loadImageOperations removeObjectForKey:imageUrl];
                }
            }];
        }];
        
        [_loadImageOperations setObject: loadImageOperation forKey:imageUrl];
        if (loadImageOperation) {
            [_loadImageOperationQueue addOperation:loadImageOperation];
        }
    }
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
        
        [self loadUserAvatarInImageView:cell.gamerAvatar withImageUrl:self.model.me.user.imageUrl];
        [self loadUserAvatarInImageView:cell.oponentAvatar withImageUrl:self.model.oponent.user.imageUrl];
        
        return cell;
    }

    if (indexPath.row > 0 && indexPath.row < 7) {
        GameStatusRoundTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GameStatusRoundCell"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"GameStatusRoundTableViewCell" bundle:nil]forCellReuseIdentifier:@"GameStatusRoundCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"GameStatusRoundCell"];
        }
        
        if (self.model.gameRounds != nil && indexPath.row <= [self.model.gameRounds count]) {
            [cell initGameRound:self.model.gameRounds[indexPath.row-1] andGame:self.model withIndex:indexPath.row fromController:self];
        } else {
            [cell initGameRound:nil andGame:self.model withIndex:indexPath.row fromController:self];
        }
        
        return cell;
    }
    
    if (indexPath.row == 7) {
        GameStatusActionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GameStatusActionCell"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"GameStatusActionTableViewCell" bundle:nil]forCellReuseIdentifier:@"GameStatusActionCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"GameStatusActionCell"];
        }
        /*
        [cell initCell:self.model onPlayAction:^{
            [self onPlayAction];
        } onSurrenderAction:^{
            [self onSurrenderAction];
        } onAddToFriendsAction:^{
            [self onAddToFriendsAction];
        } onRevancheAction:^{
            [self onRevancheAction];
        }];
        */
        [cell initCell:self.model parentTableViewController:self];
        
        return cell;
    }
    
    return nil;
}


-(void) onPlayAction {
    NSLog(@"onPlayAction invoked");

    if ([self.model.me.status isEqualToString:GAMER_STATUS_WAITING_ROUND]) {
        // Начинаем новый раунд
        GameCategoriesTableViewController *destinationController = [[GameCategoriesTableViewController alloc] init];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Назад" style:UIBarButtonItemStylePlain target:nil action:nil];
        [destinationController initViewController:self.model fromGameStatus:self];
        [self.navigationController pushViewController:destinationController animated:YES];
    }
    
    if ([self.model.me.status isEqualToString:GAMER_STATUS_WAITING_ANSWERS]) {
        // Подгужаем список вопросов для ответов
        [DejalBezelActivityView activityViewForView:self.view withLabel:@"Подождите\nИдет загрузка..."];
        [GameService getRoundQuestions:self.model.id withRound:self.model.lastRound.id onSuccess:^(ResponseWrapperModel *response) {
            
            [DejalBezelActivityView removeViewAnimated:NO];
            
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
                //[self presentErrorViewControllerWithTryAgainSelector:@selector(onPlayAction)];
                NSString* message = [[NSString alloc] initWithFormat:@"Ошибка при попытке начать игру. Проверьте соединение с интернетом и попробуйте еще раз, Описание ошибки: %@ : %@", response.errorCode, response.errorMessage];
                [self presentSimpleAlertViewWithTitle:@"Ошибка" andMessage:message];
            }
            
        } onFailure:^(NSError *error) {
            [DejalBezelActivityView removeViewAnimated:NO];
            //[self presentErrorViewControllerWithTryAgainSelector:@selector(onPlayAction)];
            NSString* message = [[NSString alloc] initWithFormat:@"Ошибка при попытке начать игру. Проверьте соединение с интернетом и попробуйте еще раз, Описание ошибки: %li : %@", error.code, error.localizedDescription.description];
            [self presentSimpleAlertViewWithTitle:@"Ошибка" andMessage:message];
        }];
    }
    
}

-(void) onSurrenderAction {
    NSLog(@"onSurrenderAction invoked");

    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Подождите\nИдет загрузка..."];
    [GameService surrenderGame:self.model.id onSuccess:^(ResponseWrapperModel *response) {
        [DejalBezelActivityView removeViewAnimated:NO];
        if ([response.status isEqualToString:SUCCESS]) {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Поражение!"
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
            //[self presentErrorViewControllerWithTryAgainSelector:@selector(onSurrenderAction)];
            NSString* message = [[NSString alloc] initWithFormat:@"Ошибка при попытке завершить игру. Проверьте соединение с интернетом и попробуйте еще раз, Описание ошибки: %@ : %@", response.errorCode, response.errorMessage];
            [self presentSimpleAlertViewWithTitle:@"Ошибка" andMessage:message];
        }
        
    } onFailure:^(NSError *error) {
        [DejalBezelActivityView removeViewAnimated:NO];
        NSString* message = [[NSString alloc] initWithFormat:@"Ошибка при попытке завершить игру. Проверьте соединение с интернетом и попробуйте еще раз, Описание ошибки: %li : %@", error.code, error.localizedDescription.description];
        [self presentSimpleAlertViewWithTitle:@"Ошибка" andMessage:message];
//        [self presentErrorViewControllerWithTryAgainSelector:@selector(onSurrenderAction)];
    }];
}

-(void) onAddToFriendsAction {
    NSLog(@"onAddToFriendsAction invoked");
    
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Подождите\nИдет загрузка..."];
    NSUInteger userId = self.model.oponent.user.id;
    [[UserService sharedInstance] addUserFriendAsync:userId onSuccess:^(ResponseWrapperModel *response) {
        if ([response.status isEqualToString:SUCCESS]) {
            [self refreshGameStatus:nil];
        }
        
        if ([response.status isEqualToString:AUTHORIZATION_ERROR]) {
            [DejalBezelActivityView removeViewAnimated:NO];
            [[AppDelegate globalDelegate] showAuthorizationView:self];
        }
        
        if ([response.status isEqualToString:SERVER_ERROR]) {
            [DejalBezelActivityView removeViewAnimated:NO];
            //[self presentErrorViewControllerWithTryAgainSelector:@selector(onAddToFriendsAction)];
            NSString* message = [[NSString alloc] initWithFormat:@"Ошибка при попытке добавить в друзья. Проверьте соединение с интернетом и попробуйте еще раз, Описание ошибки: %@ : %@", response.errorCode, response.errorMessage];
            [self presentSimpleAlertViewWithTitle:@"Ошибка" andMessage:message];
        }
        
    } onFailure:^(NSError *error) {
        [DejalBezelActivityView removeViewAnimated:NO];
        //[self presentErrorViewControllerWithTryAgainSelector:@selector(onAddToFriendsAction)];
        NSString* message = [[NSString alloc] initWithFormat:@"Ошибка при попытке добавить в друзья. Проверьте соединение с интернетом и попробуйте еще раз, Описание ошибки: %li : %@", error.code, error.localizedDescription.description];
        [self presentSimpleAlertViewWithTitle:@"Ошибка" andMessage:message];
    }];
}

-(void) onRevancheAction {
    NSLog(@"onRevancheAction invoked");

    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Подождите\nИдет загрузка..."];
    NSUInteger oponentId = self.model.oponent.user.id;
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
            //[self presentErrorViewControllerWithTryAgainSelector:@selector(onRevancheAction)];
            NSString* message = [[NSString alloc] initWithFormat:@"Ошибка при попытке начать новую игру. Проверьте соединение с интернетом и попробуйте еще раз, Описание ошибки: %@ : %@", response.errorCode, response.errorMessage];
            [self presentSimpleAlertViewWithTitle:@"Ошибка" andMessage:message];
        }
        
    } onFailure:^(NSError *error) {
        [DejalBezelActivityView removeViewAnimated:NO];
        //[self presentErrorViewControllerWithTryAgainSelector:@selector(onRevancheAction)];
        NSString* message = [[NSString alloc] initWithFormat:@"Ошибка при попытке добавить в друзья. Проверьте соединение с интернетом и попробуйте еще раз, Описание ошибки: %li : %@", error.code, error.localizedDescription.description];
        [self presentSimpleAlertViewWithTitle:@"Ошибка" andMessage:message];
    }];
    
}


static CGFloat HEIGHT = 504;

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
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
