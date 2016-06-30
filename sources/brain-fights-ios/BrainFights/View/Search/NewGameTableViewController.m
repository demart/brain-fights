//
//  NewGameTableViewController.m
//  BrainFights
//
//  Created by Artem Demidovich on 11/9/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import "NewGameTableViewController.h"

#import "ChoiceSearchActionTableViewCell.h"
#import "UserTableViewCell.h"
#import "UserProfileTableViewController.h"

#import "OrganizationStructureTableViewController.h"
#import "FriendsHeaderTableViewCell.h"
#import "EmptySectionFooterTableViewCell.h"

#import "AppDelegate.h"
#import "GameService.h"
#import "UserService.h"
#import "UserFriendsModel.h"
#import "UserProfileModel.h"

#import "DejalActivityView.h"


@interface NewGameTableViewController ()

// Список друзей
@property NSMutableArray *friends;

@property NSMutableDictionary *loadImageOperations;
@property NSOperationQueue *loadImageOperationQueue;

@end

@implementation NewGameTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorColor = [UIColor clearColor];
    
    self.loadImageOperationQueue = [[NSOperationQueue alloc] init];
    [self.loadImageOperationQueue setMaxConcurrentOperationCount:1];
    
}

- (void) viewWillAppear:(BOOL)animated  {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    // Загружаем список друзей
    [self loadFriendsAsync];
}

-(void) viewWillDisappear:(BOOL)animated {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [_loadImageOperationQueue cancelAllOperations];
    [_loadImageOperations removeAllObjects];
        
}

-(void) appDidBecomeActive:(NSNotification *)notification {
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Подождите\nИдет загрузка..."];
    [self loadFriendsAsync];
}

- (void) loadFriendsAsync {
    // Retrieve data
    [[UserService sharedInstance] retrieveUserFriendsAsync:^(ResponseWrapperModel *response) {
        if ([response.status isEqualToString:SUCCESS]) {
            UserFriendsModel *model = (UserFriendsModel*)response.data;
            if (model != nil)
                self.friends = model.friends;
            [self.tableView reloadData];
            [DejalBezelActivityView removeViewAnimated:YES];
        }
        
        if ([response.status isEqualToString:NO_CONTENT]) {
            // Не должно быть такого статуса
        }
        
        if ([response.status isEqualToString:AUTHORIZATION_ERROR]) {
            [DejalBezelActivityView removeViewAnimated:NO];
            [[AppDelegate globalDelegate] showAuthorizationView:self];
        }
        
        if ([response.status isEqualToString:BAD_REQUEST]) {
            [DejalBezelActivityView removeViewAnimated:NO];
        }
        
        if ([response.status isEqualToString:SERVER_ERROR]) {
            [DejalBezelActivityView removeViewAnimated:NO];
            //[self presentSimpleAlertViewWithTitle:@"Ошибка" andMessage:@"Не удалось загрузить список друзей."];
            NSString* message = [[NSString alloc] initWithFormat:@"Ошибка при попытке загрузить список друзей. Проверьте соединение с интернетом и попробуйте еще раз, Описание ошибки: %@ : %@", response.errorCode, response.errorMessage];
            [self presentSimpleAlertViewWithTitle:@"Ошибка" andMessage:message];
        }
    } onFailure:^(NSError *error) {
        [DejalBezelActivityView removeViewAnimated:NO];
        //[self presentErrorViewControllerWithTryAgainSelector:@selector(loadFriendsAsync)];
        NSString* message = [[NSString alloc] initWithFormat:@"Ошибка при попытке загрузить список друзей. Проверьте соединение с интернетом и попробуйте еще раз, Описание ошибки:  %li : %@", error.code, error.localizedDescription.description];
        [self presentSimpleAlertViewWithTitle:@"Ошибка" andMessage:message];
    }];
}


- (void) createRandomInvitation {
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Подождите..."];
    [GameService createGameInvitation:0 onSuccess:^(ResponseWrapperModel *response) {
        [DejalBezelActivityView removeViewAnimated:NO];
        if ([response.status isEqualToString:SUCCESS]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        if ([response.status isEqualToString:NO_CONTENT]) {
            // SHOW ALERT NOBODY TO PLAY WITH YOU RIGHT NOW
            NSLog(@"response.status: %@", response.status);
            [self presentSimpleAlertViewWithTitle:@"Внимание" andMessage:@"Не удалось найти игрока."];
        }
        
        if ([response.status isEqualToString:BAD_REQUEST]) {
            // SHOW ERROR TO CONTACT TO DEVELOPER
            NSLog(@"response.status: %@", response.status);
        }
        
        if ([response.status isEqualToString:AUTHORIZATION_ERROR]) {
            [[AppDelegate globalDelegate] showAuthorizationView:self];
        }
        
        if ([response.status isEqualToString:SERVER_ERROR]) {
            NSLog(@"response.status: %@", response.status);
            // SHOW ERROR ALERT
            //[self presentSimpleAlertViewWithTitle:@"Ошибка" andMessage:@"Не удалось найти игрока."];
            NSString* message = [[NSString alloc] initWithFormat:@"Ошибка при попытке начать игру со случайным игроком. Проверьте соединение с интернетом и попробуйте еще раз, Описание ошибки: %@ : %@", response.errorCode, response.errorMessage];
            [self presentSimpleAlertViewWithTitle:@"Ошибка" andMessage:message];
        }
        
    } onFailure:^(NSError *error) {
        NSLog(@"error: %@", error);
        [DejalBezelActivityView removeViewAnimated:NO];
        //[self presentErrorViewControllerWithTryAgainSelector:@selector(loadFriendsAsync)];
        NSString* message = [[NSString alloc] initWithFormat:@"Ошибка при попытке начать игру со случайным игроком. Проверьте соединение с интернетом и попробуйте еще раз, Описание ошибки: %li : %@", error.code, error.localizedDescription.description];
        [self presentSimpleAlertViewWithTitle:@"Ошибка" andMessage:message];
    }];
}


- (void) loadUserAvatarInCell:(UserTableViewCell*) cell onIndexPath:(NSIndexPath*)indexPath withImageUrl:(NSString*)imageUrl {
    UIImage *loadedImage =(UIImage *)[LocalStorageService  loadImageFromLocalCache:imageUrl];
    
    if (loadedImage != nil) {
        cell.iconImage.image = loadedImage;
    } else {
        NSBlockOperation *loadImageOperation = [[NSBlockOperation alloc] init];
        __weak NSBlockOperation *weakOperation = loadImageOperation;
        
        [loadImageOperation addExecutionBlock:^(void){
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:
                                                                                   [UrlHelper imageUrlForAvatarWithPath:imageUrl]
                                                                                   ]]];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^(void) {
                if (! weakOperation.isCancelled) {
                    UserTableViewCell *updateCell = (UserTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                    if (updateCell != nil && image != nil) {
                        updateCell.iconImage.image = image;
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



// Отправить приглашение выбранному пользователю сыграть
- (void) sendGameInvitationToSelectedUserAction:(NSUInteger) userId {
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Подождите..."];
    
    [GameService createGameInvitation:userId onSuccess:^(ResponseWrapperModel *response) {
        if ([response.status isEqualToString:SUCCESS]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        if ([response.status isEqualToString:AUTHORIZATION_ERROR]) {
            [DejalBezelActivityView removeViewAnimated:NO];
            [[AppDelegate globalDelegate] showAuthorizationView:self];
        }
        
        if ([response.status isEqualToString:SERVER_ERROR]) {
            [DejalBezelActivityView removeViewAnimated:NO];
            // TODO SHOW ALERT
            NSString* message = [[NSString alloc] initWithFormat:@"Ошибка при попытке отправить приглашение. Проверьте соединение с интернетом и попробуйте еще раз, Описание ошибки: %@ : %@", response.errorCode, response.errorMessage];
            [self presentSimpleAlertViewWithTitle:@"Ошибка" andMessage:message];
        }
        
    } onFailure:^(NSError *error) {
        [DejalBezelActivityView removeViewAnimated:NO];
        // TODO SHOW ERROR
        NSString* message = [[NSString alloc] initWithFormat:@"Ошибка при попытке отправить приглашение. Проверьте соединение с интернетом и попробуйте еще раз, Описание ошибки: %li : %@", error.code, error.localizedDescription.description];
        [self presentSimpleAlertViewWithTitle:@"Ошибка" andMessage:message];
    }];
    
}

-(void) removeFriend {
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    UserProfileModel *userProfile = self.friends[selectedIndexPath.row];
    if (userProfile != nil) {
        [[UserService sharedInstance] removeUserFriendAsync:userProfile.id onSuccess:^(ResponseWrapperModel *response) {
            if ([response.status isEqualToString:SUCCESS]) {
                // REMOVE ROW
                [self.friends removeObject:userProfile];
                [self.tableView reloadData];
            }
            
            if ([response.status isEqualToString:NO_CONTENT]) {
                NSLog(@"response.status: %@", response.status);
            }
            
            if ([response.status isEqualToString:BAD_REQUEST]) {
                NSLog(@"response.status: %@", response.status);
            }
            
            if ([response.status isEqualToString:AUTHORIZATION_ERROR]) {
                [[AppDelegate globalDelegate] showAuthorizationView:self];
            }
            
            if ([response.status isEqualToString:SERVER_ERROR]) {
                NSLog(@"response.status: %@", response.status);
                NSString* message = [[NSString alloc] initWithFormat:@"Ошибка при попытке убрать из друзей. Проверьте соединение с интернетом и попробуйте еще раз, Описание ошибки: %@ : %@", response.errorCode, response.errorMessage];
                [self presentSimpleAlertViewWithTitle:@"Ошибка" andMessage:message];
            }
            
        } onFailure:^(NSError *error) {
            NSLog(@"error: %@", error);
            //[self presentErrorViewControllerWithTryAgainSelector:@selector(loadFriendsAsync)];
            NSString* message = [[NSString alloc] initWithFormat:@"Ошибка при попытке убрать из друзей. Проверьте соединение с интернетом и попробуйте еще раз, Описание ошибки: %li : %@", error.code, error.localizedDescription.description];
            [self presentSimpleAlertViewWithTitle:@"Ошибка" andMessage:message];
        }];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
        return 1;
    if (section == 1)
        return 1;
    if (section == 2)
        return 1;
    if (section == 3) {
        if (self.friends != nil) {
            return [self.friends count];
        } else {
            return 0;
        }
    }
    return 0;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != 3) {
        ChoiceSearchActionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChoiceSearchActionCell"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"ChoiceSearchActionTableViewCell" bundle:nil]forCellReuseIdentifier:@"ChoiceSearchActionCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"ChoiceSearchActionCell"];
        }
    
        if (indexPath.section == 0) {
            [cell initCell:@"Cлучайный игрок" withImage:@"randomIcon"];
        }
    
        if (indexPath.section == 1) {
            [cell initCell:@"Поиск по Орг. структуре" withImage:@"organizationStructureIcon"];
        }
    
        if (indexPath.section == 2) {
            [cell initCell:@"Поиск по имени" withImage:@"findUserIcon"];
        }
        return cell;
    }
    
    if (indexPath.section == 3) {
        UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"UserTableViewCell" bundle:nil]forCellReuseIdentifier:@"UserCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell"];
        }
        
        // Инициализируем ячейку друга
        UserProfileModel *userProfile = self.friends[indexPath.row];
        [cell initCell:userProfile withDeleteButton:YES onClicked:^{
            // remove friend;
            [self removeFriend];
        } withSendGameInvitationAction:^(NSUInteger userId) {
            [self sendGameInvitationToSelectedUserAction:userId];
        } onParentViewController:self];
        
        [self loadUserAvatarInCell:cell onIndexPath:indexPath withImageUrl:userProfile.imageUrl];
        
        return cell;
    }
    
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0)
        return 75;
    return 75;
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Случайный игрок
    if (indexPath.section == 0) {
        [self createRandomInvitation];
    }
    
    // Поиск по орг структуре
    if (indexPath.section == 1) {
        [self performSegueWithIdentifier:@"FromNewGameToOrganizationStructure" sender:self];
    }
    
    // Поиск по имени
    if (indexPath.section == 2) {
        [self performSegueWithIdentifier:@"FromNewGameToSearchByName" sender:self];
    }
    
    if (indexPath.section == 3) {
        // Пользователи
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        UserProfileTableViewController *viewController = [[UserProfileTableViewController alloc] init];
        [viewController setUserProfile:self.friends[selectedIndexPath.row]];
        viewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Назад"
                                                                                           style:UIBarButtonItemStylePlain
                                                                                          target:nil
                                                                                          action:nil];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
}


-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section < 3)
        return 0;
    return 35;
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 3) {
        FriendsHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendsHeaderCell"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"FriendsHeaderTableViewCell" bundle:nil]forCellReuseIdentifier:@"FriendsHeaderCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"FriendsHeaderCell"];
        }
        return cell;
    }
    return nil;
}

-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 3) {
        return @"Мои друзья";
    }
    return nil;
}


- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 3)
        if (self.friends == nil || [self.friends count] == 0)
            return 80;
    return 0;
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 3) {
        if (self.friends == nil || [self.friends count] == 0) {
            EmptySectionFooterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EmptySectionFooterCell"];
            if (!cell) {
                [tableView registerNib:[UINib nibWithNibName:@"EmptySectionFooterTableViewCell" bundle:nil]forCellReuseIdentifier:@"EmptySectionFooterCell"];
                cell = [tableView dequeueReusableCellWithIdentifier:@"EmptySectionFooterCell"];
            }
            [cell setEmptySectionText:@"У вас пока нет друзей, вы можете добавить их играя или просматривая профили соперников"];
            return cell;
        }
        
        return nil;
    } else {
        return nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.destinationViewController isKindOfClass:[OrganizationStructureTableViewController class]]) {
        segue.destinationViewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Назад" style:UIBarButtonItemStylePlain target:nil action:nil];
        NSLog(@"NewGame -> OrganizationStructure");
    }
    
}

@end
