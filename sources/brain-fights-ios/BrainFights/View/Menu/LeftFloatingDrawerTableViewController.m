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
#import "UserProfileTableViewCell.h"
#import "AboutTableViewCell.h"

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
    
    self.tableView.backgroundColor = [Constants SYSTEM_COLOR_GREEN];
    self.tableView.backgroundView.backgroundColor = [Constants SYSTEM_COLOR_GREEN];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.contentInset = UIEdgeInsetsMake(kJVTableViewTopInset, 0.0, 0.0, 0.0);
    self.clearsSelectionOnViewWillAppear = NO;
}


-(void) viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Profile View
    // Menu Items
        // My Games
        // Profile
        // Rating
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
        return 1;
    if (section == 1)
        return 3;
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UserProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserProfileCell"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"UserProfileTableViewCell" bundle:nil]forCellReuseIdentifier:@"UserProfileCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"UserProfileCell"];
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
            UIImage *iconImage = [UIImage imageNamed:@"brainGreenIcon"];
            [cell initCell:@"Мои игры" withImage:iconImage];
        }
        
        // Профиль
        if (indexPath.row == 1) {
            UIImage *iconImage = [UIImage imageNamed:@"gamerProfileIcon"];
            [cell initCell:@"Мой профиль" withImage:iconImage];
        }
        
        // Рейтинг
        if (indexPath.row == 2) {
            UIImage *iconImage = [UIImage imageNamed:@"ratingGreenIcon"];
            [cell initCell:@"Рейтинг" withImage:iconImage];
        }
        
        return cell;
    }
    
    if (indexPath.section == 2) {
        AboutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AboutCell"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"AboutTableViewCell" bundle:nil]forCellReuseIdentifier:@"AboutCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"AboutCell"];
        }
        
        CGFloat constHeightValue = 100;
        CGFloat tableHeight = tableView.bounds.size.height;
        cell.bottomViewHeightConstraint.constant = constHeightValue * (tableHeight / HEIGHT);
        
        return cell;
    }
    
    MenuItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuItem"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"MenuItemTableViewCell" bundle:nil]forCellReuseIdentifier:@"MenuItem"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"MenuItem"];
    }

    return nil;
}

static CGFloat HEIGHT = 504;

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0)
        return 200;
    if (indexPath.section == 1) {
        return 50;
    }
    if (indexPath.section == 2) {
        return tableView.bounds.size.height - (200 + 50 * 3);
    }
    return 44;
}


- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}



- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *destinationViewController = nil;
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            destinationViewController = [[AppDelegate globalDelegate] gameMainViewController];
        }
    
        if (indexPath.row == 1) {
            destinationViewController = [[AppDelegate globalDelegate] profileViewController];
        }
    
        if (indexPath.row == 2) {
            destinationViewController = [[AppDelegate globalDelegate] ratingViewController];
        }
    }
    
    if (indexPath.section == 2) {
        destinationViewController = [[AppDelegate globalDelegate] aboutViewController];
    }
    
    if (destinationViewController) {
        [[[AppDelegate globalDelegate] drawerViewController] setCenterViewController:destinationViewController];
        [[AppDelegate globalDelegate] toggleLeftDrawer:self animated:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
