//
//  LeftFloatingDrawerTableViewController.m
//  BrainFights
//
//  Created by Artem Demidovich on 11/6/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import "LeftFloatingDrawerTableViewController.h"

#import "MenuCells/MenuProfileCellTableViewCell.h"
#import "MenuCells/MenuItemTableViewCell.h"

#import "AppDelegate.h"
#import "UserService.h"

#import "JVFloatingDrawerViewController.h"
#import "JVFloatingDrawerSpringAnimator.h"


static const CGFloat kJVTableViewTopInset = 0.0;

@interface LeftFloatingDrawerTableViewController ()

@end

@implementation LeftFloatingDrawerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.contentInset = UIEdgeInsetsMake(kJVTableViewTopInset, 0.0, 0.0, 0.0);
    self.clearsSelectionOnViewWillAppear = NO;
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1] animated:NO scrollPosition:UITableViewScrollPositionNone];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Profile View
    // Menu Items
        // My Games
        // Profile
        // Rating
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
        return 1;
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MenuProfileCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuProfile"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"MenuProfileCellTableViewCell" bundle:nil]forCellReuseIdentifier:@"MenuProfile"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"MenuProfile"];
        }
        
        UserProfileModel *userProfileMdodel = [[UserService sharedInstance] getUserProfile];
        [cell initCell:userProfileMdodel];
        
        return cell;
    }
    
    
    if (indexPath.section == 1) {
        MenuItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuItem"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"MenuItemTableViewCell" bundle:nil]forCellReuseIdentifier:@"MenuItem"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"MenuItem"];
        }
        
    
        // Мои игры
        if (indexPath.row == 0) {
            [cell initCell:@"Мои игры"];
        }
        
        // Профиль
        if (indexPath.row == 1) {
            [cell initCell:@"Мой профиль"];
        }
        
        // Рейтинг
        if (indexPath.row == 2) {
            [cell initCell:@"Рейтинг"];
        }
        
        
        
        return cell;
    }
    
    MenuItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuItem"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"MenuItemTableViewCell" bundle:nil]forCellReuseIdentifier:@"MenuItem"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"MenuItem"];
    }

    
    return nil;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0)
        return 250;
    return 44;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != 1)
        return;
    
    UIViewController *destinationViewController = nil;
    if (indexPath.row == 0) {
        destinationViewController = [[AppDelegate globalDelegate] gameMainViewController];
    }
    
    if (indexPath.row == 1) {
        destinationViewController = [[AppDelegate globalDelegate] profileViewController];
    }
    
    if (indexPath.row == 2) {
        destinationViewController = [[AppDelegate globalDelegate] ratingViewController];
    }
    
    [[[AppDelegate globalDelegate] drawerViewController] setCenterViewController:destinationViewController];
    [[AppDelegate globalDelegate] toggleLeftDrawer:self animated:YES];
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
