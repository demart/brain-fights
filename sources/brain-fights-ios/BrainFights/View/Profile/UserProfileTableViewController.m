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

#import "MenuProfileCellTableViewCell.h"
#import "UserService.h"
#import "UserDepartmentTableViewCell.h"
#import "UserProfileActionTableViewCell.h"

#import "GameService.h"

#import "DejalActivityView.h"

@interface UserProfileTableViewController ()

// профиль пользователя
@property UserProfileModel* userProfileModel;

@end

@implementation UserProfileTableViewController

static UIRefreshControl *refreshControl;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initRefreshControl];
    
    self.tableView.backgroundColor = [Constants SYSTEM_COLOR_GREEN];
    self.tableView.separatorColor = [UIColor clearColor];
    
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
}

- (void) viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    if (self.userProfileModel != nil) {
        [self.showMenuButton setImage:[UIImage imageNamed:@"backArrowIcon"]];
        [self.showMenuButton setTitle:@"Назад"];
    } else {
        [self.showMenuButton setImage:[UIImage imageNamed:@"leftMenuIcon"]];
    }
    
    [self reloadProfile];
}

-(void) viewWillDisappear:(BOOL)animated {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
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
    [self reloadProfile];
    [refreshControl endRefreshing];
}

-(void) appDidBecomeActive:(NSNotification *)notification {
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Подождите\nИдет загрузка..."];
    [self reloadProfile];
}


-(void) reloadProfile {
    NSInteger userId = 0;
    if (self.userProfileModel == nil) {
        userId = [[UserService sharedInstance] getUserProfile].id;
    } else {
        userId = self.userProfileModel.id;
    }

    [[UserService sharedInstance] retrieveUserProfileByIdAsync:userId onSuccess:^(ResponseWrapperModel *response) {
        if ([response.status isEqualToString:SUCCESS]) {
            if (self.userProfileModel != nil) {
                self.userProfileModel = (UserProfileModel*)response.data;
            } else {
                [[UserService sharedInstance] setUserProfile:(UserProfileModel*)response.data];
            }
            
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


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        MenuProfileCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuProfile"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"MenuProfileCellTableViewCell" bundle:nil]    forCellReuseIdentifier:@"MenuProfile"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"MenuProfile"];
        }

        [cell initCell: [self getUserProfileModel]];
        return cell;
    }
    if (indexPath.row == 1) {
        UserDepartmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserDepartmentCell"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"UserDepartmentTableViewCell" bundle:nil]    forCellReuseIdentifier:@"UserDepartmentCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"UserDepartmentCell"];
        }
        
        [cell initCell:[self getUserProfileModel]];
        return cell;
    }
    if (indexPath.row == 2) {
        UserProfileActionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserProfileActionCell"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"UserProfileActionTableViewCell" bundle:nil]    forCellReuseIdentifier:@"UserProfileActionCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"UserProfileActionCell"];
        }
        
        [cell initCell:[self getUserProfileModel] onPlayAction:^{
            [self playAction];
        } onAddToFriedsAction:^{
            [self addToFriendsAction];
        }];
        return cell;
    }

    return nil;
}


- (void) playAction {
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Подождите..."];

    [GameService createGameInvitation:[self getUserProfileModel].id onSuccess:^(ResponseWrapperModel *response) {
        sleep(1);
        if ([response.status isEqualToString:SUCCESS]) {
            [self reloadProfile];
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
            [self reloadProfile];
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



-(UserProfileModel*) getUserProfileModel {
    if (self.userProfileModel != nil) {
        return self.userProfileModel;
    } else {
        return [[UserService sharedInstance] getUserProfile];
    }
}

static CGFloat HEIGHT = 504;

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"Table View Height: %f", tableView.bounds.size.height);
    //CGFloat proportion = tableView.bounds.size.height / HEIGHT;
    //NSLog(@"Proporting View Height: %f", proportion);
    
    
    if (indexPath.row == 0)
        return 250;
    if (indexPath.row == 1)
        return 80;
    if (indexPath.row == 2)
        return tableView.bounds.size.height - (250 + 80);
    return 44;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
