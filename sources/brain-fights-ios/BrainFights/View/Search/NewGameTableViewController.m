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

#import "AppDelegate.h"
#import "GameService.h"
#import "UserService.h"
#import "UserFriendsModel.h"
#import "UserProfileModel.h"


@interface NewGameTableViewController ()

// Список друзей
@property NSMutableArray *friends;

@end

@implementation NewGameTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Загружаем список друзей
    [self loadFriendsAsync];
}

- (void) loadFriendsAsync {
    // Show Loader
    
    // Retrieve data
    [[UserService sharedInstance] retrieveUserFriendsAsync:^(ResponseWrapperModel *response) {
        if ([response.status isEqualToString:SUCCESS]) {
            UserFriendsModel *model = (UserFriendsModel*)response.data;
            if (model != nil)
                self.friends = model.friends;
            [self.tableView reloadData];
        }
        
        if ([response.status isEqualToString:NO_CONTENT]) {
            // Не должно быть такого статуса
        }
        
        if ([response.status isEqualToString:AUTHORIZATION_ERROR]) {
            // SHOW AUTH SCREEN
            [[AppDelegate globalDelegate] showAuthorizationView:self];
        }
        
        if ([response.status isEqualToString:BAD_REQUEST]) {
            // SHOW ERROR
        }
        
        if ([response.status isEqualToString:SERVER_ERROR]) {
            // SHOW ERROR
        }
    } onFailure:^(NSError *error) {
        // SHOW ERROR
    }];
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
            [cell initCell:@"Поиск по орг структуре" withImage:@"organizationStructureIcon"];
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
        [cell initCell:userProfile];
        
        return cell;
    }
    
    return nil;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section < 3)
        return 0;
    return 40;
}


-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 3) {
        return @"Мои друзья";
    }
    return @"";
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Случайный игрок
    if (indexPath.section == 0) {
        
        // Loading bar
        [GameService createGameInvitation:0 onSuccess:^(ResponseWrapperModel *response) {
            if ([response.status isEqualToString:SUCCESS]) {
                [self.navigationController popViewControllerAnimated:YES];
            }
            
            if ([response.status isEqualToString:NO_CONTENT]) {
                // SHOW ALERT NOBODY TO PLAY WITH YOU RIGHT NOW
                NSLog(@"response.status: %@", response.status);
            }
            
            if ([response.status isEqualToString:BAD_REQUEST]) {
                // SHOW ERROR TO CONTACT TO DEVELOPER
                NSLog(@"response.status: %@", response.status);
            }
            
            if ([response.status isEqualToString:AUTHORIZATION_ERROR]) {
                // Show Login Screen
                NSLog(@"response.status: %@", response.status);
                [[AppDelegate globalDelegate] showAuthorizationView:self];
            }
            
            if ([response.status isEqualToString:SERVER_ERROR]) {
                NSLog(@"response.status: %@", response.status);
                // SHOW ERROR ALERT
                
            }
            
        } onFailure:^(NSError *error) {
            NSLog(@"error: %@", error);
            // SHOW ERROR ALERT
            
        }];
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
        // TODO
        [self performSegueWithIdentifier:@"FromNewGameToUserProfile" sender:self];
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0)
        return 60;
    return 70;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    // Если переход на профиль друга
    if ([segue.destinationViewController isKindOfClass:[UserProfileTableViewController class]]) {
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        [(UserProfileTableViewController*)segue.destinationViewController setUserProfile:self.friends[selectedIndexPath.row]];
        NSLog(@"NewGame -> UserProfile");
    }
    
    if ([segue.destinationViewController isKindOfClass:[OrganizationStructureTableViewController class]]) {
        segue.destinationViewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Назад" style:UIBarButtonItemStylePlain target:nil action:nil];
        NSLog(@"NewGame -> OrganizationStructure");
    }
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

@end
