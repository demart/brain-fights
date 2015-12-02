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


@interface SearchByNameResultsTableViewController ()

@end

@implementation SearchByNameResultsTableViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredUsers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"UserTableViewCell" bundle:nil]forCellReuseIdentifier:@"UserCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell"];
    }
    
    // Инициализируем ячейку друга
    UserProfileModel *userProfile = (UserProfileModel*)self.filteredUsers[indexPath.row];
    [cell initCell:userProfile withDeleteButton:NO onClicked:nil];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

@end
