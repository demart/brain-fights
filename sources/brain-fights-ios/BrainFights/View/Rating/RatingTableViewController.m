//
//  RatingTableViewController.m
//  BrainFights
//
//  Created by Artem Demidovich on 11/8/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import "RatingTableViewController.h"

#import "JVFloatingDrawerSpringAnimator.h"
#import "AppDelegate.h"

#import "UserRatingTableViewCell.h"
#import "UserRatingHeaderTableViewCell.h"
#import "DejalActivityView.h"

#import "UserService.h"

#import "UserProfileTableViewController.h"

@interface RatingTableViewController ()

// Страница загруженная
@property NSInteger page;

// Подгруженный пользователи
@property NSMutableArray* users;

// Есть ли еще записи
@property bool isExistsMoreRecords;

@end

@implementation RatingTableViewController

static NSInteger PAGE_LIMIT = 20;

static UIRefreshControl* refreshControl;


- (void)viewDidLoad {
    [super viewDidLoad];

    self.page = 0;
    self.users = [[NSMutableArray alloc] init];
    [self initRefreshControl];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorColor = [UIColor clearColor];
    
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Подождите\nИдет загрузка..."];
    [self loadUsersRating];
    
}

-(void)viewWillAppear:(BOOL)animated {
    /*
    self.page= 0;
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Подождите\nИдет загрузка..."];
    [self loadUsersRating];
    */
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
    self.page = 0;
    [self.users removeAllObjects];
    [self loadUsersRating];
    [refreshControl endRefreshing];
}


// Загружает данные с сервера
-(void) loadUsersRating {
    [[UserService sharedInstance] retrieveUsersRating:self.page withLimit:PAGE_LIMIT onSuccess:^(ResponseWrapperModel *response) {
        [DejalBezelActivityView removeViewAnimated:NO];
        
        if ([response.status isEqualToString:SUCCESS]) {
            NSLog(@"Success");
            
            NSMutableArray *userProfiles = (NSMutableArray*)response.data;
            if (userProfiles == nil || [userProfiles count] < 1) {
                self.isExistsMoreRecords = NO;
            } else {
                [self.users addObjectsFromArray:userProfiles];
                if ([userProfiles count] == PAGE_LIMIT) {
                    self.page = self.page + 1;
                    self.isExistsMoreRecords = YES;
                } else {
                    self.isExistsMoreRecords = NO;
                }
            }
            [self.tableView reloadData];
        }
        
        if ([response.status isEqualToString:AUTHORIZATION_ERROR]) {
            // Show Authorization View
            [[AppDelegate globalDelegate] showAuthorizationView:self];
        }
        
        if ([response.status isEqualToString:SERVER_ERROR]) {
            // TODO Show Error Alert
        }
        
    } onFailure:^(NSError *error) {
        // Stop loading
        // Show error
        [DejalBezelActivityView removeViewAnimated:NO];

    }];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.users != nil)
        return [self.users count];
    return 0;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UserRatingHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserRatingHeaderCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"UserRatingHeaderTableViewCell" bundle:nil]forCellReuseIdentifier:@"UserRatingHeaderCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"UserRatingHeaderCell"];
    }
    return cell;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserRatingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserRatingCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"UserRatingTableViewCell" bundle:nil]forCellReuseIdentifier:@"UserRatingCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"UserRatingCell"];
    }
    
    [cell initCell:self.users[indexPath.row]];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UserProfileTableViewController *destination = [[UserProfileTableViewController alloc] init];
    [destination setUserProfile:self.users[indexPath.row]];
    [self.navigationController pushViewController:destination animated:YES];
}


// Метод позволяет опроеделить что пользователь дошел до конца списка
-(void) scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.isExistsMoreRecords) {
//        [DejalBezelActivityView activityViewForView:self.view withLabel:@"Подождите\nИдет загрузка..."];
        [self loadUsersRating];
    }
}

- (IBAction)showMenuAction:(UIBarButtonItem *)sender {
    [[AppDelegate globalDelegate] toggleLeftDrawer:self animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
