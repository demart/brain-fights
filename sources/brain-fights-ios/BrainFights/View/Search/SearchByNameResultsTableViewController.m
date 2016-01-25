//
//  SearchByNameResultsTableViewController.m
//  BrainFights
//
//  Created by Artem Demidovich on 11/11/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import "SearchByNameResultsTableViewController.h"

#import "UserTableViewCell.h"
#import "UserProfileModel.h"
#import "EmptySectionFooterTableViewCell.h"

#import "DejalActivityView.h"
#import "GameService.h"

@interface SearchByNameResultsTableViewController ()

@property NSMutableDictionary *loadImageOperations;
@property NSOperationQueue *loadImageOperationQueue;

@end

@implementation SearchByNameResultsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorColor = [UIColor clearColor];
    
    self.loadImageOperationQueue = [[NSOperationQueue alloc] init];
    [self.loadImageOperationQueue setMaxConcurrentOperationCount:1];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [_loadImageOperationQueue cancelAllOperations];
    [_loadImageOperations removeAllObjects];
}


// Отправить приглашение выбранному пользователю сыграть
- (void) sendGameInvitationToSelectedUserAction:(NSUInteger) userId {
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Подождите..."];
    
    [GameService createGameInvitation:userId onSuccess:^(ResponseWrapperModel *response) {
        [DejalBezelActivityView removeViewAnimated:YES];
        if ([response.status isEqualToString:SUCCESS]) {
            [self.navigationController popToRootViewControllerAnimated:YES];
            return;
        }
        
        if ([response.status isEqualToString:AUTHORIZATION_ERROR]) {
            [[AppDelegate globalDelegate] showAuthorizationView:self];
            return;
        }
        
        if ([response.status isEqualToString:SERVER_ERROR]) {
            NSString* message = [[NSString alloc] initWithFormat:@"Не удалось отправить приглашение. Проверьте соединение с интернетом и попробуйте еще раз, Описание ошибки: %@ : %@", response.errorCode, response.errorMessage];
            [self presentSimpleAlertViewWithTitle:@"Ошибка" andMessage:message];
            return;
        }
        
        NSString* message = [[NSString alloc] initWithFormat:@"Не удалось отправить приглашение. Проверьте соединение с интернетом и попробуйте еще раз, Описание ошибки: %@ : %@", response.errorCode, response.errorMessage];
        [self presentSimpleAlertViewWithTitle:@"Ошибка" andMessage:message];
        
    } onFailure:^(NSError *error) {
        [DejalBezelActivityView removeViewAnimated:NO];
        // TODO SHOW ERROR
        NSString* message = [[NSString alloc] initWithFormat:@"Не удалось отправить приглашение. Проверьте соединение с интернетом и попробуйте еще раз, Описание ошибки: %li : %@", error.code, error.localizedDescription.description];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.wasSearchQueryRequested) {
        if (self.filteredUsers.count > 0) {
            self.tableView.backgroundView = nil;
            return self.filteredUsers.count;
        } else {
            UIView *messageContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0,
                                                                                self.tableView.bounds.size.width,
                                                                                self.tableView.bounds.size.height)];
            UILabel *messageLbl = [[UILabel alloc] initWithFrame:CGRectMake(self.tableView.bounds.size.width*0.1, self.tableView.bounds.size.height*.4,
                                                                            self.tableView.bounds.size.width*0.8,
                                                                            self.tableView.bounds.size.height)];
            messageLbl.numberOfLines = 0;
            NSString *text = @"Игроков по указанным данным не найдено.\n\nПопробуйте ввести другие данные для поиска. Поиск умеет искать по ФИО и почтовому ящику. Если вы не нашли сотрудника, которого искали, попросите его установить игру и сыграть с вами.";
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
            return 0;
        }
    } else {
        self.tableView.backgroundView = nil;
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"UserTableViewCell" bundle:nil]forCellReuseIdentifier:@"UserCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell"];
    }
    
    // Инициализируем ячейку друга
    UserProfileModel *userProfile = (UserProfileModel*)self.filteredUsers[indexPath.row];
    [cell initCell:userProfile withDeleteButton:NO onClicked:nil withSendGameInvitationAction:^(NSUInteger userId) {
        NSLog(@"Send game invitation sent");
        [self sendGameInvitationToSelectedUserAction:userId];
    } onParentViewController:self];
    
    [self loadUserAvatarInCell:cell onIndexPath:indexPath withImageUrl:userProfile.imageUrl];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.filteredUsers == nil || [self.filteredUsers count] == 0)
        return 60;
    return 0;
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (self.filteredUsers == nil || [self.filteredUsers count] == 0) {
        EmptySectionFooterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EmptySectionFooterCell"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"EmptySectionFooterTableViewCell" bundle:nil]forCellReuseIdentifier:@"EmptySectionFooterCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"EmptySectionFooterCell"];
        }
        [cell setEmptySectionText:@"Никого не нашли... Попробуйте ввести другие данные. Поиск ищет по ФИО и почте..."];
        return cell;
    }
    return nil;
}

@end
