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
#import "../../../LNNotificationsUI/LNNotificationsUI/LNNotificationsUI.h"

@interface GameMainTableViewController ()

// Загруженные игры пользователя
@property NSMutableArray *gameGroups;

@property NSMutableDictionary *loadImageOperations;
@property NSOperationQueue *loadImageOperationQueue;

@end

@implementation GameMainTableViewController

static UIRefreshControl *refreshControl;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initRefreshControl];
    self.tableView.separatorColor = [UIColor clearColor];
    self.loadImageOperationQueue = [[NSOperationQueue alloc] init];
    [self.loadImageOperationQueue setMaxConcurrentOperationCount:3];
    self.showAuthSceneButton.image = nil;
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
    [self loadGames:nil];
        
}

-(void) viewWillDisappear:(BOOL)animated {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [_loadImageOperationQueue cancelAllOperations];
    [_loadImageOperations removeAllObjects];

}

-(void) handleRefresh:(UIRefreshControl*) refreshControll {
    [self loadGames:refreshControl];
}

-(void) appDidBecomeActive:(NSNotification *)notification {
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Подождите\nИдет загрузка..."];
    [self loadGames:nil];
}


-(void) loadGames:(UIRefreshControl*)refreshControl {
    // Загружаем игры при появлении сцены
    [GameService retrieveGamesGrouped:^(ResponseWrapperModel *response) {
        [DejalBezelActivityView removeViewAnimated:YES];
        if (refreshControl != nil)
            [refreshControl endRefreshing];
        
        if ([response.status isEqualToString:SUCCESS]) {
            UserGamesGroupedModel *userGamesGrouppedModel = (UserGamesGroupedModel*)response.data;
            // Выставляем новый профиль пользователя (например баллы поменялись или еще что)
            [[UserService sharedInstance] setUserProfile:userGamesGrouppedModel.user];
            // Обновляем список игр
            self.gameGroups = userGamesGrouppedModel.gameGroups;
            [self.tableView reloadData];
            [self findAndShowFinalResultPromtMessage];
        }
        
        if ([response.status isEqualToString:AUTHORIZATION_ERROR]) {
            [[AppDelegate globalDelegate] showAuthorizationView:self];
        }
        
        if ([response.status isEqualToString:SERVER_ERROR]) {
            [DejalBezelActivityView removeViewAnimated:NO];
            [self presentErrorViewController];
        }
        
    } onFailure:^(NSError *error) {
        if (refreshControl != nil)
            [refreshControl endRefreshing];
        [DejalBezelActivityView removeViewAnimated:NO];
        [self presentErrorViewController];
    }];
}


// Проверяет есть ли завершенные игры и нужно ли показать результаты игры
// Показывает каждый раз только первую игру
- (void) findAndShowFinalResultPromtMessage {
    if (self.gameGroups == nil || [self.gameGroups count] < 1)
        return;
    for (UserGameGroupModel *gameGroup in self.gameGroups) {
        if ([gameGroup.status isEqualToString:GAME_STATUS_FINISHED]) {
            if (gameGroup.games == nil || [gameGroup.games count] < 1)
                return;
            
            for (UserGameModel *gameModel in gameGroup.games) {
                if (gameModel.me.resultWasViewed == NO) {
                    // Show Prompt message
                    [self showPromtMessageWithViewedResultConfirmation:gameModel];
                    return;
                }
            }
            
        }
    }
}

// Показывает окошко с результатом игры
-(void) showPromtMessageWithViewedResultConfirmation:(UserGameModel*) gameModel {
    NSString* title = @"Игра закончилась";
    NSString* message;
    
    if ([gameModel.gamerStatus isEqualToString:GAMER_STATUS_DRAW]) {
        message = [[NSString alloc] initWithFormat: @"Вы закончили игру в ничью с %@ \n Ваши очки: %li", gameModel.oponent.user.name, gameModel.me.resultScore];
    }
    if ([gameModel.gamerStatus isEqualToString:GAMER_STATUS_LOOSER]) {
        message = [[NSString alloc] initWithFormat: @"Вы проиграли игру с %@ \n Ваши очки: %li", gameModel.oponent.user.name, gameModel.me.resultScore];
    }
    if ([gameModel.gamerStatus isEqualToString:GAMER_STATUS_WINNER]) {
        message = [[NSString alloc] initWithFormat: @"Вы выиграли игру с %@ \n Ваши очки: %li", gameModel.oponent.user.name, gameModel.me.resultScore];
    }
    if ([gameModel.gamerStatus isEqualToString:GAMER_STATUS_OPONENT_SURRENDED]) {
        message = [[NSString alloc] initWithFormat: @"Ваш опонент %@ сдался.\n Ваши очки: %li", gameModel.oponent.user.name, gameModel.me.resultScore];
    }
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [self markGameResultAsViewed:gameModel];
                                                          }];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void) markGameResultAsViewed:(UserGameModel*)gameModel {
    if (gameModel == nil) {
        NSLog(@"MarkAsViewed gameModel null");
        return;
    }
    
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Подождите\nИдет загрузка..."];
    
    [GameService markAsViewed:gameModel.id andGamer:gameModel.me.id onSuccess:^(ResponseWrapperModel *response) {
        if ([response.status isEqualToString:SUCCESS]) {
            [self loadGames:nil];
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


- (IBAction)showMenuAction:(UIBarButtonItem *)sender {
    [[AppDelegate globalDelegate] toggleLeftDrawer:self animated:YES];
}

- (IBAction)showAuthScene:(UIBarButtonItem *)sender {
    [[AppDelegate globalDelegate] showAuthorizationView:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void) loadUserAvatarInCell:(GameTableViewCell*) cell onIndexPath:(NSIndexPath*)indexPath withImageUrl:(NSString*)imageUrl {
    UIImage *loadedImage =(UIImage *)[LocalStorageService  loadImageFromLocalCache:imageUrl];
    
    if (loadedImage != nil) {
        cell.userAvatar.image = loadedImage;
    } else {
        NSBlockOperation *loadImageOperation = [[NSBlockOperation alloc] init];
        __weak NSBlockOperation *weakOperation = loadImageOperation;
        
        [loadImageOperation addExecutionBlock:^(void){
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:
                                                                                   [UrlHelper imageUrlForAvatarWithPath:imageUrl]
                                                                                   ]]];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^(void) {
                if (! weakOperation.isCancelled) {
                    GameTableViewCell *updateCell = (GameTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                    if (updateCell != nil && image != nil) {
                        updateCell.userAvatar.image = image;
                    }
                    
                    if (image != nil) {
                        [LocalStorageService  saveImageToLocalCache:imageUrl withData:image];
                    }
                    [self.loadImageOperations removeObjectForKey:indexPath];
                }
            }];
        }];
        
        [_loadImageOperations setObject: loadImageOperation forKey:indexPath];
        if (loadImageOperation) {
            [_loadImageOperationQueue addOperation:loadImageOperation];
        }
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.gameGroups == nil) {
        UIView *messageContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0,
                                                                            self.tableView.bounds.size.width,
                                                                            self.tableView.bounds.size.height)];
        UILabel *messageLbl = [[UILabel alloc] initWithFrame:CGRectMake(self.tableView.bounds.size.width*0.1, self.tableView.bounds.size.height*.4,
                                                                        self.tableView.bounds.size.width*0.8,
                                                                        self.tableView.bounds.size.height)];
        messageLbl.numberOfLines = 0;
        NSString *text = @"Добро пожаловать! \n\nУ Вас нет ни одной активной игры... Нажмите \"Начать новую игру\" для того, чтобы найти себе соперника.";
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentJustified;
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:15.f],
                                     NSBaselineOffsetAttributeName: @0,
                                     NSParagraphStyleAttributeName: paragraphStyle};
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text
                                                                             attributes:attributes];
        messageLbl.attributedText = attributedText;
        messageLbl.textColor = [Constants SYSTEM_COLOR_DARK_GREY];
        [messageLbl sizeToFit];
        [messageContainer addSubview:messageLbl];
        [messageContainer sizeToFit];
        self.tableView.backgroundView = messageContainer;

        return 1;
    } else {
        self.tableView.backgroundView = nil;
    }
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
    [self loadUserAvatarInCell:cell onIndexPath:indexPath withImageUrl:userGame.oponent.user.imageUrl];
    
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
        // SHOW PROMPT
        [self showAcceptAgreementAlertConfirmation];
    } else
        if ([userGame.gamerStatus isEqualToString:GAMER_STATUS_WAITING_OPONENT_DECISION]) {
            // Если мы ждем принятия решения
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Статус игры"
                                                                           message:@"Ожидаем решение игрока."
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


-(void) showAcceptAgreementAlertConfirmation {
    NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
    UserGameGroupModel *gameGroupModel = (UserGameGroupModel*)self.gameGroups[indexPath.section-1];
    UserGameModel *userGame = gameGroupModel.games[indexPath.row];

    NSString *alertTitle = @"Новая игра";
    NSString *alertMessage = [[NSString alloc] initWithFormat:@"%@ бросил вам вызов. Вы согласны играть?", userGame.oponent.user.name];
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:alertTitle
                                          message:alertMessage
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *acceptAction = [UIAlertAction
                                   actionWithTitle:@"Да"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action) {
                                       [self acceptGameInvitationWithResult:YES];
                                   }];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                  actionWithTitle:@"Нет"
                                  style:UIAlertActionStyleDestructive
                                  handler:^(UIAlertAction *action) {
                                      NSLog(@"Cancel action");
                                       [self acceptGameInvitationWithResult:NO];
                                  }];
    
    [alertController addAction:acceptAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void) acceptGameInvitationWithResult:(BOOL)result {
    NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
    UserGameGroupModel *gameGroupModel = (UserGameGroupModel*)self.gameGroups[indexPath.section-1];
    UserGameModel *userGame = gameGroupModel.games[indexPath.row];

    // Если нам нужно принять решение
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Подождите..."];
    [GameService acceptGameInvitation:userGame.id onSuccess:^(ResponseWrapperModel *response) {
        if ([response.status isEqualToString:SUCCESS]) {
            if (result) {
                gameGroupModel.games[indexPath.row] = (UserGameModel*)response.data;
                [self performSegueWithIdentifier:@"FromGamesToGameStatus" sender:self];
            } else {
                [self loadGames:nil];
            }
        }
        
        if ([response.status isEqualToString:AUTHORIZATION_ERROR]) {
            [[AppDelegate globalDelegate] showAuthorizationView:self];
        }
        
        if ([response.status isEqualToString:SERVER_ERROR]) {
            // Show Error Alert
            //[self presentErrorViewControllerWithTryAgainSelector:@selector(processSelectedRow)];
            [DejalBezelActivityView removeViewAnimated:NO];
        }
    } onFailure:^(NSError *error) {
        //[self presentErrorViewControllerWithTryAgainSelector:@selector(processSelectedRow)];
        [DejalBezelActivityView removeViewAnimated:NO];
    } withResult:result];
}


 #pragma mark - Navigation

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if ([segue.destinationViewController isKindOfClass:[GameStatusTableViewController class]]) {
         GameStatusTableViewController *viewController = (GameStatusTableViewController*)segue.destinationViewController;
         NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
         UserGameGroupModel *gameGroupModel = (UserGameGroupModel*)self.gameGroups[indexPath.section-1];
         UserGameModel *gameModel = gameGroupModel.games[indexPath.row];
         [viewController setUserGameModel:gameModel];
     }
 }

@end
