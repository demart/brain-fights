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
    if (self.userProfileModel != nil) {
        [self.showMenuButton setImage:[UIImage imageNamed:@"backArrowIcon"]];
        [self.showMenuButton setTitle:@"Назад"];
    } else {
        [self.showMenuButton setImage:[UIImage imageNamed:@"leftMenuIcon"]];
    }
    
    [self reloadProfile];
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



-(void) reloadProfile {
    NSInteger userId = 0;
    if (self.userProfileModel == nil) {
        userId = [[UserService sharedInstance] getUserProfile].id;
    } else {
        // oponents profile
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
            // Show Authorization View
            [[AppDelegate globalDelegate] showAuthorizationView:self];
        }
        
        if ([response.status isEqualToString:SERVER_ERROR]) {
            // Show Error Alert
            // TODO
        }
        [DejalBezelActivityView removeViewAnimated:YES];
    } onFailure:^(NSError *error) {
        [DejalBezelActivityView removeViewAnimated:NO];
        // SHOW ERROR
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
            // Show alert
        }
        
        if ([response.status isEqualToString:AUTHORIZATION_ERROR]) {
            [DejalBezelActivityView removeViewAnimated:NO];
            [[AppDelegate globalDelegate] showAuthorizationView:self];
        }
        
        if ([response.status isEqualToString:SERVER_ERROR]) {
            // Show Error Alert
            [DejalBezelActivityView removeViewAnimated:NO];
        }
        
    } onFailure:^(NSError *error) {
        [DejalBezelActivityView removeViewAnimated:NO];
        // Show Error
    }];

}


- (void) addToFriendsAction {
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Подождите..."];
    
    [[UserService sharedInstance] addUserFriendAsync:[self getUserProfileModel].id onSuccess:^(ResponseWrapperModel *response) {
        sleep(1);
        if ([response.status isEqualToString:SUCCESS]) {
            [self reloadProfile];
            [DejalBezelActivityView removeViewAnimated:NO];
        }
        
        if ([response.status isEqualToString:AUTHORIZATION_ERROR]) {
            [DejalBezelActivityView removeViewAnimated:NO];
            [[AppDelegate globalDelegate] showAuthorizationView:self];
        }
        
        if ([response.status isEqualToString:SERVER_ERROR]) {
            // Show Error Alert
            [DejalBezelActivityView removeViewAnimated:NO];
        }
    } onFailure:^(NSError *error) {
        [DejalBezelActivityView removeViewAnimated:NO];
        // Show Error
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
    CGFloat proportion = tableView.bounds.size.height / HEIGHT;
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
    // Dispose of any resources that can be recreated.
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
