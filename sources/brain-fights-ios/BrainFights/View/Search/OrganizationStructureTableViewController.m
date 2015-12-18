//
//  OrganizationStructureTableViewController.m
//  BrainFights
//
//  Created by Artem Demidovich on 11/9/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import "OrganizationStructureTableViewController.h"
#import "UserService.h"
#import "GameService.h"
#import "AppDelegate.h"


#import "DepartmentTableViewCell.h"
#import "DepartmentHeaderTableViewCell.h"
#import "UserTableViewCell.h"
#import "UserProfileTableViewController.h"

#import "DejalActivityView.h"

@interface OrganizationStructureTableViewController ()

@property NSMutableArray *departments;
@property NSMutableArray *users;

@property NSMutableDictionary *loadImageOperations;
@property NSOperationQueue *loadImageOperationQueue;

@end

@implementation OrganizationStructureTableViewController

static UIRefreshControl* refreshControl;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorColor = [UIColor clearColor];

    [self initRefreshControl];
    
    self.loadImageOperationQueue = [[NSOperationQueue alloc] init];
    [self.loadImageOperationQueue setMaxConcurrentOperationCount:1];
    
    // Загружаем список друзей
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Подождите\nИдет загрузка..."];
    [self loadDepartmentsAsync:nil];
}

-(void)viewWillDisappear:(BOOL)animated {
    [_loadImageOperationQueue cancelAllOperations];
    [_loadImageOperations removeAllObjects];
}

// Указываем родителя
-(void) setParentDepartment:(DepartmentModel*)department; {
    self.parentDepartmentModel = department;
    self.users = department.users;
    self.navigationItem.title = @"Транстелеком";
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
    [self loadDepartmentsAsync:refreshControll];
}



- (void) loadDepartmentsAsync:(UIRefreshControl*) refreshControl {
    // Show Loader
    NSInteger parentId = 0;
    if (self.parentDepartmentModel != nil) {
        parentId = self.parentDepartmentModel.id;
    }
    
    [[UserService sharedInstance] searchDepartments:parentId onSuccess:^(ResponseWrapperModel *response) {
        if (refreshControl!=nil)
            [refreshControl endRefreshing];
        [DejalBezelActivityView removeViewAnimated:YES];
        
        if ([response.status isEqualToString:SUCCESS]) {
            DepartmentSearchResultModel *model = (DepartmentSearchResultModel*)response.data;
            if (model != nil)
                self.departments = model.departments;
            [self.tableView reloadData];
        }
        
        if ([response.status isEqualToString:NO_CONTENT]) {
            // Не должно быть такого статуса
        }
        
        if ([response.status isEqualToString:AUTHORIZATION_ERROR]) {
            [[AppDelegate globalDelegate] showAuthorizationView:self];
        }
        
        if ([response.status isEqualToString:BAD_REQUEST]) {
            // SHOW ERROR
        }
        
        if ([response.status isEqualToString:SERVER_ERROR]) {
            // SHOW ERROR
        }
    } onFailure:^(NSError *error) {
        if (refreshControl!=nil)
            [refreshControl endRefreshing];
        [DejalBezelActivityView removeViewAnimated:YES];
        // TODO [self presentErrorViewControllerWithTryAgainSelector:@selector(loadDepartmentsAsync)];
    }];
}


// Отправить приглашение выбранному пользователю сыграть
- (void) sendGameInvitationToSelectedUserAction:(NSUInteger) userId {
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Подождите..."];
    
    [GameService createGameInvitation:userId onSuccess:^(ResponseWrapperModel *response) {
        if ([response.status isEqualToString:SUCCESS]) {
            //[self.navigationController popViewControllerAnimated:YES];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
        if ([response.status isEqualToString:AUTHORIZATION_ERROR]) {
            [DejalBezelActivityView removeViewAnimated:NO];
            [[AppDelegate globalDelegate] showAuthorizationView:self];
        }
        
        if ([response.status isEqualToString:SERVER_ERROR]) {
            [DejalBezelActivityView removeViewAnimated:NO];
            // TODO SHOW ALERT
        }
        
    } onFailure:^(NSError *error) {
        [DejalBezelActivityView removeViewAnimated:NO];
        // TODO SHOW ERROR
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



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger sectionCount = 1;
    
    // Если есть пользователи то для них секцию
    if (self.users != nil && [self.users count] > 0)
        sectionCount = sectionCount + 1;
    
    // Если есть департаменты то для них секцию
    if (self.departments != nil && [self.departments count] > 0)
        sectionCount = sectionCount + 1;
 
    return sectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger sectionCount = [self.tableView numberOfSections];
    if (sectionCount == 1) {
        UIView *messageContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0,
                                                                            self.tableView.bounds.size.width,
                                                                            self.tableView.bounds.size.height)];
        UILabel *messageLbl = [[UILabel alloc] initWithFrame:CGRectMake(self.tableView.bounds.size.width*0.1, self.tableView.bounds.size.height*.4,
                                                                        self.tableView.bounds.size.width*0.8,
                                                                        self.tableView.bounds.size.height)];
        messageLbl.numberOfLines = 0;
        NSString *text = @"В данном подразделении пока нету игроков. Попробуйте поискать в другом подразделении и/или скорее пригласить сотрудников из данного подразделения сыграть с вами.";
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
    } else {
        self.tableView.backgroundView = nil;
    }
    
    if (sectionCount == 2) {
        if (section == 0)
            return 0;
        
        //  Если одна секция
        if (section == 1) {
            if (self.users != nil && [self.users count] > 0)
                return [self.users count];
        
            if (self.departments != nil && [self.departments count] > 0)
                return [self.departments count];
        }
    }
    
    if (sectionCount == 3) {
        if (section == 0) {
            return 0;
        }
        if (section == 1) {
            if (self.users != nil && [self.users count] > 0)
                return [self.users count];
        }
        if (section == 2) {
            if (self.departments != nil && [self.departments count] > 0)
                return [self.departments count];
        }
    }
    
    return 0;
}


 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     NSInteger sectionCount = [self.tableView numberOfSections];
     if (sectionCount == 3) {
         if (indexPath.section == 1) {
             // Пользователи
             UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell"];
             if (!cell) {
                 [tableView registerNib:[UINib nibWithNibName:@"UserTableViewCell" bundle:nil]forCellReuseIdentifier:@"UserCell"];
                 cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell"];
             }
             
             // Инициализируем ячейку друга
             NSLog(@"users count: %li", [self.users count]);
             UserProfileModel *userProfile = (UserProfileModel*)self.users[indexPath.row];
             [cell initCell:userProfile withDeleteButton:NO onClicked:nil withSendGameInvitationAction:^(NSUInteger userId) {
                 [self sendGameInvitationToSelectedUserAction:userId];
             } onParentViewController:self];
             
             [self loadUserAvatarInCell:cell onIndexPath:indexPath withImageUrl:userProfile.imageUrl];
             
             return cell;
         } else {
             // Подразделения
             DepartmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DepartmentCell"];
             if (!cell) {
                 [tableView registerNib:[UINib nibWithNibName:@"DepartmentTableViewCell" bundle:nil]forCellReuseIdentifier:@"DepartmentCell"];
                 cell = [tableView dequeueReusableCellWithIdentifier:@"DepartmentCell"];
             }
             NSLog(@"departments count: %li", [self.departments count]);
             [cell initCell:self.departments[indexPath.row]];
             return cell;
         }
     } else {
         // Определить кого показываем
         
         if (self.users != nil && [self.users count] > 0) {
             UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell"];
             if (!cell) {
                 [tableView registerNib:[UINib nibWithNibName:@"UserTableViewCell" bundle:nil]forCellReuseIdentifier:@"UserCell"];
                 cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell"];
             }
             
             // Инициализируем ячейку друга
             NSLog(@"users count: %li", [self.users count]);
             UserProfileModel *userProfile = (UserProfileModel*)self.users[indexPath.row];
             [cell initCell:userProfile withDeleteButton:NO onClicked:nil withSendGameInvitationAction:^(NSUInteger userId) {
                 [self sendGameInvitationToSelectedUserAction:userId];
             } onParentViewController:self];
             
            [self loadUserAvatarInCell:cell onIndexPath:indexPath withImageUrl:userProfile.imageUrl];
             
             return cell;
         } else {

             DepartmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DepartmentCell"];
             if (!cell) {
                 [tableView registerNib:[UINib nibWithNibName:@"DepartmentTableViewCell" bundle:nil]forCellReuseIdentifier:@"DepartmentCell"];
                 cell = [tableView dequeueReusableCellWithIdentifier:@"DepartmentCell"];
             }
             NSLog(@"departments count: %li", [self.departments count]);
             [cell initCell:self.departments[indexPath.row]];
             return cell;
         }
         
     }
 }

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    DepartmentHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DepartmentHeaderCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"DepartmentHeaderTableViewCell" bundle:nil]forCellReuseIdentifier:@"DepartmentHeaderCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"DepartmentHeaderCell"];
    }
    
    NSInteger sectionCount = [self.tableView numberOfSections];

    // Если ничего нету в подразделении
    if (sectionCount == 1) {
        if (self.parentDepartmentModel == nil) {
            [cell initCellWithTitle:@"Транстелеком" withMainHeader:YES isDepartment:YES];
            return cell;
        } else {
            [cell initCellWithTitle:self.parentDepartmentModel.name withMainHeader:YES isDepartment:YES];
            return cell;
        }
    }
    
    if (sectionCount == 2) {
        if (section == 0) {
            if (self.parentDepartmentModel == nil) {
                [cell initCellWithTitle:@"Транстелеком" withMainHeader:YES isDepartment:YES];
                return cell;
            } else {
                [cell initCellWithTitle:self.parentDepartmentModel.name withMainHeader:YES isDepartment:YES];
                return cell;
            }
        }
        
        //  Если одна секция
        if (self.users != nil && [self.users count] > 0) {
            [cell initCellWithTitle:@"Сотрудники" withMainHeader:NO isDepartment:NO];
            return cell;
        }
        
        if (self.departments != nil && [self.departments count] > 0) {
            [cell initCellWithTitle:@"Подразделения" withMainHeader:NO isDepartment:YES];
            return cell;
        }
    }

    if (sectionCount == 3) {
        if (section == 0) {
            if (self.parentDepartmentModel == nil) {
                [cell initCellWithTitle:@"Транстелеком" withMainHeader:YES isDepartment:YES];
                return cell;
            } else {
                [cell initCellWithTitle:self.parentDepartmentModel.name withMainHeader:YES isDepartment:YES];
                return cell;
            }
        }
        if (section == 1) {
            [cell initCellWithTitle:@"Сотрудники" withMainHeader:NO isDepartment:NO];
            return cell;
        } else {
            [cell initCellWithTitle:@"Подразделения" withMainHeader:NO isDepartment:YES];
            return cell;
        }
    }
    
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger sectionCount = [self.tableView numberOfSections];
    
    if (sectionCount == 3) {
        if (indexPath.section == 1) {
            // Пользователи
            UserProfileTableViewController *viewController = [[UserProfileTableViewController alloc] init];
            [viewController setUserProfile:self.parentDepartmentModel.users[indexPath.row]];
            viewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Назад"
                                                                                               style:UIBarButtonItemStylePlain
                                                                                              target:nil
                                                                                              action:nil];
            [self.navigationController pushViewController:viewController animated:YES];
        }
        
        if (indexPath.section == 2) {
            // Подразделения
            OrganizationStructureTableViewController *viewController = [[OrganizationStructureTableViewController alloc] init];
            [viewController setParentDepartment:self.departments[indexPath.row]];
            viewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Назад"
                                                                                             style:UIBarButtonItemStylePlain
                                                                                            target:nil
                                                                                              action:nil];
            [self.navigationController pushViewController:viewController animated:YES];
        }
        
    }
    
    if (sectionCount == 2) {
        if (self.departments != nil && [self.departments count] >0) {
            // Подразделения
            OrganizationStructureTableViewController *viewController = [[OrganizationStructureTableViewController alloc] init];
            [viewController setParentDepartment:self.departments[indexPath.row]];
            viewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Назад"
                                                                                               style:UIBarButtonItemStylePlain
                                                                                              target:nil
                                                                                              action:nil];
            [self.navigationController pushViewController:viewController animated:YES];
        } else {
            // Пользователи
            UserProfileTableViewController *viewController = [[UserProfileTableViewController alloc] init];
            [viewController setUserProfile:self.parentDepartmentModel.users[indexPath.row]];
            viewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Назад"
                                                                                               style:UIBarButtonItemStylePlain
                                                                                              target:nil
                                                                                              action:nil];
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0)
        return 0;
    return 75;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
