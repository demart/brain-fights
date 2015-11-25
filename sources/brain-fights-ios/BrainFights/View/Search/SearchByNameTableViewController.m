//
//  SearchByNameTableViewController.m
//  BrainFights
//
//  Created by Artem Demidovich on 11/9/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import "SearchByNameTableViewController.h"
#import "SearchByNameResultsTableViewController.h"

#import "UserTableViewCell.h"
#import "UserProfileTableViewController.h"

#import "UserService.h"
#import "UserSearchResultModel.h"
#import "UserProfileModel.h"
#import "ResponseWrapperModel.h"

#import "DejalActivityView.h"

@interface SearchByNameTableViewController ()<UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating>

@property (nonatomic, strong) UISearchController *searchController;

// our secondary search results table view
@property (nonatomic, strong) SearchByNameResultsTableViewController *resultsTableController;

// for state restoration
@property BOOL searchControllerWasActive;
@property BOOL searchControllerSearchFieldWasFirstResponder;


// Список отфильтрованных пользователей
@property (strong, nonatomic) NSMutableArray* filteredUsers;

// Таймер для отсрочки поиска для того чтобы не отправлять на сервер кучу запросов
@property NSTimer *searchDelayedTimer;

@end

@implementation SearchByNameTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    _resultsTableController = [[SearchByNameResultsTableViewController alloc] init];
    _searchController = [[UISearchController alloc] initWithSearchResultsController:self.resultsTableController];
    self.searchController.searchResultsUpdater = self;
    [self.searchController.searchBar sizeToFit];
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    self.resultsTableController.tableView.delegate = self;
    self.searchController.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = NO; // default is YES
    self.searchController.searchBar.delegate = self; // so we can monitor text changes + others
    
    self.searchController.searchBar.placeholder = @"Введите имя соперника";
    
    self.searchController.searchBar.layer.borderWidth = 1;
    self.searchController.searchBar.layer.borderColor = [[Constants SYSTEM_COLOR_GREEN] CGColor];
    self.searchController.searchBar.translucent = NO;

    self.definesPresentationContext = YES;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.resultsTableController.extendedLayoutIncludesOpaqueBars = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.searchControllerWasActive) {
        self.searchController.active = self.searchControllerWasActive;
        _searchControllerWasActive = NO;
        
        if (self.searchControllerSearchFieldWasFirstResponder) {
            [self.searchController.searchBar becomeFirstResponder];
            _searchControllerSearchFieldWasFirstResponder = NO;
        }
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

#pragma mark - UISearchControllerDelegate

- (void)presentSearchController:(UISearchController *)searchController {
    
}

- (void)willPresentSearchController:(UISearchController *)searchController {
    // do something before the search controller is presented
}

- (void)didPresentSearchController:(UISearchController *)searchController {
    // do something after the search controller is presented
}

- (void)willDismissSearchController:(UISearchController *)searchController {
    // do something before the search controller is dismissed
}

- (void)didDismissSearchController:(UISearchController *)searchController {
    // do something after the search controller is dismissed
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.filteredUsers != nil)
        return [self.filteredUsers count];
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Пользователи
    UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"UserTableViewCell" bundle:nil]forCellReuseIdentifier:@"UserCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell"];
    }
    
    // Инициализируем ячейку друга
    UserProfileModel *userProfile = (UserProfileModel*)self.filteredUsers[indexPath.row];
    [cell initCell:userProfile];
    
    return cell;
}


// Выполняет поиск асинхронно
- (void) searchUsersByTextRemotely {
    NSLog(@"remote search text: %@", self.searchController.searchBar.text);
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Подождите\nИдет загрузка..."];
    [[UserService sharedInstance] searchUsersByTextAsync:self.searchController.searchBar.text onSuccess:^(ResponseWrapperModel *response) {
        if ([response.status isEqualToString:SUCCESS]) {
            UserSearchResultModel *model = (UserSearchResultModel*)response.data;
            if (model != nil)
                self.filteredUsers = model.users;
            
            // hand over the filtered results to our search results table
            SearchByNameResultsTableViewController *tableController = (SearchByNameResultsTableViewController *)self.searchController.searchResultsController;
            tableController.filteredUsers = self.filteredUsers;
            [tableController.tableView reloadData];
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
        [DejalBezelActivityView removeViewAnimated:NO];
    } onFailure:^(NSError *error) {
        [DejalBezelActivityView removeViewAnimated:NO];
        //[self presentErrorViewControllerWithTryAgainSelector:@selector(searchUsersByTextRemotely)];
    }];
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    // update the filtered array based on the search text
    NSString *searchText = searchController.searchBar.text;
    
    if (self.searchDelayedTimer != nil)
        [self.searchDelayedTimer invalidate];
    
    if(searchText.length  < 3) {
        return;
    }
    
    NSLog(@"search text: %@", searchText);
    self.searchDelayedTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                               target:self
                                                             selector:@selector(searchUsersByTextRemotely)
                                                             userInfo:nil
                                                              repeats:NO];
}


- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (self.searchDelayedTimer != nil) {
        [self.searchDelayedTimer invalidate];
        self.searchDelayedTimer = nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Пользователи
    UserProfileTableViewController *viewController = [[UserProfileTableViewController alloc] init];
    [viewController setUserProfile:self.filteredUsers[indexPath.row]];
    viewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Назад"
                                                                                       style:UIBarButtonItemStylePlain
                                                                                      target:nil
                                                                                      action:nil];
    [self.navigationController pushViewController:viewController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
