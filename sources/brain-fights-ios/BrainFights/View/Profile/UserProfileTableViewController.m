//
//  UserProfileTableViewController.m
//  BrainFights
//
//  Created by Artem Demidovich on 11/8/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import "UserProfileTableViewController.h"

#import "JVFloatingDrawerSpringAnimator.h"
#import "AppDelegate.h"

#import "UserService.h"
#import "UserDepartmentTableViewCell.h"
#import "UserProfileTableViewCell.h"
#import "UserProfileStatisticsTableViewCell.h"
#import "UserProfileActionsTableViewCell.h"
#import "UserDepartmentHeaderTableViewCell.h"

#import "GameService.h"

#import "DejalActivityView.h"

@interface UserProfileTableViewController ()

// профиль пользователя
@property UserProfileModel* userProfileModel;
@property NSMutableArray* departmentHierarchy;

@property NSMutableDictionary *loadImageOperations;
@property NSOperationQueue *loadImageOperationQueue;

@end

@implementation UserProfileTableViewController

static UIRefreshControl *refreshControl;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initRefreshControl];
    
    //self.tableView.backgroundColor = [Constants SYSTEM_COLOR_GREEN];
    self.tableView.backgroundColor = [Constants SYSTEM_COLOR_WHITE];
    self.tableView.separatorColor = [UIColor clearColor];
    
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    
    self.loadImageOperationQueue = [[NSOperationQueue alloc] init];
    [self.loadImageOperationQueue setMaxConcurrentOperationCount:1];
    
    self.departmentHierarchy = [[NSMutableArray alloc] init];
}

- (void) viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    if (self.userProfileModel != nil) {
        //[self.showMenuButton setImage:[UIImage imageNamed:@"backArrowIcon"]];
        //[self.showMenuButton setTitle:@"Назад"];
    } else {
        [self.showMenuButton setImage:[UIImage imageNamed:@"leftMenuIcon"]];
    }
    
    [self reloadProfile:nil];
}

-(void) viewWillDisappear:(BOOL)animated {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];

    [_loadImageOperationQueue cancelAllOperations];
    [_loadImageOperations removeAllObjects];
    
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
    [self reloadProfile:refreshControl];
    [refreshControl endRefreshing];
}

-(void) appDidBecomeActive:(NSNotification *)notification {
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Подождите\nИдет загрузка..."];
    [self reloadProfile:nil];
}


-(void) reloadProfile:(UIRefreshControl*) refreshControll {
    NSInteger userId = 0;
    if (self.userProfileModel == nil) {
        userId = [[UserService sharedInstance] getUserProfile].id;
    } else {
        userId = self.userProfileModel.id;
    }

    [[UserService sharedInstance] retrieveUserProfileByIdAsync:userId onSuccess:^(ResponseWrapperModel *response) {
        if (refreshControl != nil)
            [refreshControl endRefreshing];
        if ([response.status isEqualToString:SUCCESS]) {
            if (self.userProfileModel != nil) {
                self.userProfileModel = (UserProfileModel*)response.data;
            } else {
                [[UserService sharedInstance] setUserProfile:(UserProfileModel*)response.data];
            }
            
            [self buildDepartmentHierarchy];
            
            [self.tableView reloadData];
        }
        
        if ([response.status isEqualToString:AUTHORIZATION_ERROR]) {
            [[AppDelegate globalDelegate] showAuthorizationView:self];
        }
        
        if ([response.status isEqualToString:SERVER_ERROR]) {
            [self presentErrorViewControllerWithTryAgainSelector:@selector(reloadProfile)];
        }
        [DejalBezelActivityView removeViewAnimated:YES];
    } onFailure:^(NSError *error) {
        if (refreshControl != nil)
            [refreshControl endRefreshing];
        [DejalBezelActivityView removeViewAnimated:NO];
        [self presentErrorViewControllerWithTryAgainSelector:@selector(reloadProfile)];
    }];
}


// Указываем профиль пользователя
- (void) setUserProfile:(UserProfileModel*)user {
    self.userProfileModel = user;
    
}


- (IBAction)showMenuAction:(UIBarButtonItem *)sender {
    if (self.userProfileModel != nil) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [[AppDelegate globalDelegate] toggleLeftDrawer:self animated:YES];
    }
    
}

// Строит список департаментов рекурсивно
-(void) buildDepartmentHierarchy {
    [self.departmentHierarchy removeAllObjects];
    self.departmentHierarchy = [self departmentHierarchyBuilder:[self getUserProfileModel].department toArray:self.departmentHierarchy];
}

-(NSMutableArray*) departmentHierarchyBuilder:(DepartmentModel*)department toArray:(NSMutableArray*) departmentHierarchy {
    if (department == nil)
        return nil;
    if (department.parent != nil)
        [self departmentHierarchyBuilder:department.parent toArray:departmentHierarchy];
    [departmentHierarchy addObject:department];
    return departmentHierarchy;
}



- (void) playAction {
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Подождите..."];
    
    [GameService createGameInvitation:[self getUserProfileModel].id onSuccess:^(ResponseWrapperModel *response) {
        sleep(1);
        if ([response.status isEqualToString:SUCCESS]) {
            [self reloadProfile:nil];
            [self presentSimpleAlertViewWithTitle:@"Внимание" andMessage:@"Приглашение успешно отправлено!"];
        }
        
        if ([response.status isEqualToString:AUTHORIZATION_ERROR]) {
            [DejalBezelActivityView removeViewAnimated:NO];
            [[AppDelegate globalDelegate] showAuthorizationView:self];
        }
        
        if ([response.status isEqualToString:SERVER_ERROR]) {
            [DejalBezelActivityView removeViewAnimated:NO];
            // TODO SHOW ALERT
            //            [self presentErrorViewControllerWithTryAgainSelector:@selector(playAction)];
        }
        
    } onFailure:^(NSError *error) {
        [DejalBezelActivityView removeViewAnimated:NO];
        [self presentErrorViewControllerWithTryAgainSelector:@selector(playAction)];
    }];
    
}


- (void) addToFriendsAction {
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Подождите..."];
    [[UserService sharedInstance] addUserFriendAsync:[self getUserProfileModel].id onSuccess:^(ResponseWrapperModel *response) {
        sleep(1);
        if ([response.status isEqualToString:SUCCESS]) {
            [self reloadProfile:nil];
        }
        
        if ([response.status isEqualToString:AUTHORIZATION_ERROR]) {
            [DejalBezelActivityView removeViewAnimated:NO];
            [[AppDelegate globalDelegate] showAuthorizationView:self];
        }
        
        if ([response.status isEqualToString:SERVER_ERROR]) {
            [DejalBezelActivityView removeViewAnimated:NO];
            [self presentErrorViewControllerWithTryAgainSelector:@selector(addToFriendsAction)];
        }
    } onFailure:^(NSError *error) {
        [DejalBezelActivityView removeViewAnimated:NO];
        [self presentErrorViewControllerWithTryAgainSelector:@selector(addToFriendsAction)];
    }];
}


- (void) removeFromFriendsAction {
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Подождите..."];
    [[UserService sharedInstance] removeUserFriendAsync:[self getUserProfileModel].id onSuccess:^(ResponseWrapperModel *response) {
        sleep(1);
        if ([response.status isEqualToString:SUCCESS]) {
            [self reloadProfile:nil];
        }
        
        if ([response.status isEqualToString:AUTHORIZATION_ERROR]) {
            [DejalBezelActivityView removeViewAnimated:NO];
            [[AppDelegate globalDelegate] showAuthorizationView:self];
        }
        
        if ([response.status isEqualToString:SERVER_ERROR]) {
            [DejalBezelActivityView removeViewAnimated:NO];
            [self presentErrorViewControllerWithTryAgainSelector:@selector(removeFromFriendsAction)];
        }
    } onFailure:^(NSError *error) {
        [DejalBezelActivityView removeViewAnimated:NO];
        [self presentErrorViewControllerWithTryAgainSelector:@selector(removeFromFriendsAction)];
    }];
}


-(UserProfileModel*) getUserProfileModel {
    if (self.userProfileModel != nil) {
        return self.userProfileModel;
    } else {
        return [[UserService sharedInstance] getUserProfile];
    }
}



- (void) loadUserAvatarInCell:(UserProfileTableViewCell*) cell onIndexPath:(NSIndexPath*)indexPath withImageUrl:(NSString*)imageUrl {
    UIImage *loadedImage =(UIImage *)[LocalStorageService  loadImageFromLocalCache:imageUrl];
    
    if (loadedImage != nil) {
        cell.userImage.image = loadedImage;
    } else {
        NSBlockOperation *loadImageOperation = [[NSBlockOperation alloc] init];
        __weak NSBlockOperation *weakOperation = loadImageOperation;
        
        [loadImageOperation addExecutionBlock:^(void){
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:
                                                                                   [UrlHelper imageUrlForAvatarWithPath:imageUrl]
                                                                                   ]]];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^(void) {
                if (! weakOperation.isCancelled) {
                    UserProfileTableViewCell *updateCell = (UserProfileTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                    if (updateCell != nil && image != nil) {
                        updateCell.userImage.image = image;
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (self.userProfileModel == nil  || [self.userProfileModel.type isEqualToString:USER_TYPE_ME])
            return 2;
        return 3;
    }
    if (section == 1)
        return 1 + [self.departmentHierarchy count];
    
    if (section == 2) {
        return 1;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UserProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserProfileCell"];
            if (!cell) {
                [tableView registerNib:[UINib nibWithNibName:@"UserProfileTableViewCell" bundle:nil]    forCellReuseIdentifier:@"UserProfileCell"];
                cell = [tableView dequeueReusableCellWithIdentifier:@"UserProfileCell"];
            }
            
            [cell initCell: [self getUserProfileModel]];
            [self loadUserAvatarInCell:cell onIndexPath:indexPath withImageUrl:[self getUserProfileModel].imageUrl];
            
            return cell;
        }

        if (indexPath.row == 1) {
            UserProfileStatisticsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserProfileStatisticsCell"];
            if (!cell) {
                [tableView registerNib:[UINib nibWithNibName:@"UserProfileStatisticsTableViewCell" bundle:nil]    forCellReuseIdentifier:@"UserProfileStatisticsCell"];
                cell = [tableView dequeueReusableCellWithIdentifier:@"UserProfileStatisticsCell"];
            }
            
            [cell initCell: [self getUserProfileModel]];
            return cell;
        }
        
        
        if (indexPath.row == 2) {
            UserProfileActionsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserProfileActionsCell"];
            if (!cell) {
                [tableView registerNib:[UINib nibWithNibName:@"UserProfileActionsTableViewCell" bundle:nil]    forCellReuseIdentifier:@"UserProfileActionsCell"];
                cell = [tableView dequeueReusableCellWithIdentifier:@"UserProfileActionsCell"];
            }
            
            [cell initCell:[self getUserProfileModel] onPlayAction:^{
                [self playAction];
            } onAddToFriedsAction:^{
                [self addToFriendsAction];
            } onRemoveFromFriedsAction:^{
                [self removeFromFriendsAction];
            }];
            
            return cell;
        }
    }
    
    if (indexPath.section == 1) {
        UserDepartmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserDepartmentCell"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"UserDepartmentTableViewCell" bundle:nil]    forCellReuseIdentifier:@"UserDepartmentCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"UserDepartmentCell"];
        }
        
        if (indexPath.row == 0) {
            [cell initCell:nil withIndex:0 lastLevel:NO];
        } else {
            if (indexPath.row == [self.departmentHierarchy count]) {
                [cell initCell:self.departmentHierarchy[indexPath.row-1] withIndex:indexPath.row lastLevel:YES];
            } else {
                [cell initCell:self.departmentHierarchy[indexPath.row-1] withIndex:indexPath.row  lastLevel:NO];
            }
        }
        return cell;
    }
    
    return nil;
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UserDepartmentHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserDepartmentHeaderCell"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"UserDepartmentHeaderTableViewCell" bundle:nil]       forCellReuseIdentifier:@"UserDepartmentHeaderCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"UserDepartmentHeaderCell"];
        }
        return cell;
    }
    return nil;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0)
        return 0;
    if (section == 1)
        return 30;
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 180;
        }
        if (indexPath.row == 1) {
            return 80;
        }
        if (indexPath.row == 2) {
            return 70;
        }
    }
    
    if (indexPath.section == 1)
        return 30;
    
    return 44;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
