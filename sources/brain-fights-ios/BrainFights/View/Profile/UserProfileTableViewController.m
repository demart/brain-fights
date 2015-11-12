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

@interface UserProfileTableViewController ()

// профиль пользователя
@property UserProfileModel* userProfileModel;

@end

@implementation UserProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated {
    if (self.userProfileModel != nil) {
        [self.showMenuButton setImage:[UIImage imageNamed:@"backArrowIcon"]];
        [self.showMenuButton setTitle:@"Назад"];
    } else {
        [self.showMenuButton setImage:[UIImage imageNamed:@"leftMenuIcon"]];
    }
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
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuProfileCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuProfile"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"MenuProfileCellTableViewCell" bundle:nil]forCellReuseIdentifier:@"MenuProfile"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"MenuProfile"];
    }
    
    UserProfileModel *model = nil;
    if (self.userProfileModel != nil) {
        model = self.userProfileModel;
    } else {
        model = [[UserService sharedInstance] getUserProfile];
    }
    [cell initCell: model];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0)
        return 250;
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
