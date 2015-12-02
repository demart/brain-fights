//
//  OrganizationStructureTableViewController.m
//  BrainFights
//
//  Created by Artem Demidovich on 11/9/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import "OrganizationStructureTableViewController.h"
#import "UserService.h"
#import "AppDelegate.h"


#import "DepartmentTableViewCell.h"
#import "UserTableViewCell.h"
#import "UserProfileTableViewController.h"

@interface OrganizationStructureTableViewController ()

@property NSMutableArray *departments;
@property NSMutableArray *users;

@end

@implementation OrganizationStructureTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Загружаем список друзей
    [self loadDepartmentsAsync];
}

- (void) loadDepartmentsAsync {
    // Show Loader
    NSInteger parentId = 0;
    if (self.parentDepartmentModel != nil) {
        parentId = self.parentDepartmentModel.id;
    }
    
    [[UserService sharedInstance] searchDepartments:parentId onSuccess:^(ResponseWrapperModel *response) {
        if ([response.status isEqualToString:SUCCESS]) {
            DepartmentSearchResultModel *model = (DepartmentSearchResultModel*)response.data;
            if (model != nil)
                self.departments = model.departments;
            [self.tableView reloadData];
        }
        
        if ([response.status isEqualToString:NO_CONTENT]) {
            // Не должно быть такого статуса
        }
        
        if ([response.status isEqualToString:AUTHORIZATION_ERROR]) {
            [[AppDelegate globalDelegate] showAuthorizationView:self];
        }
        
        if ([response.status isEqualToString:BAD_REQUEST]) {
            // SHOW ERROR
        }
        
        if ([response.status isEqualToString:SERVER_ERROR]) {
            // SHOW ERROR
        }
    } onFailure:^(NSError *error) {
        [self presentErrorViewControllerWithTryAgainSelector:@selector(loadDepartmentsAsync)];
    }];
    
}

// Указываем родителя
-(void) setParentDepartment:(DepartmentModel*)department; {
    self.parentDepartmentModel = department;
    self.users = department.users;
    self.navigationItem.title = @"Транстелеком";
    //self.navigationItem.title = department.name;
    //self.navigationItem.backBarButtonItem.title = @"Назад";
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger sectionCount = 0;
    
    // Если есть пользователи то для них секцию
    if (self.users != nil && [self.users count] > 0)
        sectionCount = sectionCount + 1;
    
    // Если есть департаменты то для них секцию
    if (self.departments != nil && [self.departments count] > 0)
        sectionCount = sectionCount + 1;
 
    return sectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger sectionCount = [self.tableView numberOfSections];
    
    if (sectionCount == 2) {
        if (section == 0) {
            if (self.users != nil && [self.users count] > 0)
                return [self.users count];
            return [self.parentDepartmentModel.users count];
        } else {
            if (self.departments != nil && [self.departments count] > 0)
                return [self.departments count];
            return 0;
        }
    } else {
        //  Если одна секция
        if (self.users != nil && [self.users count] > 0)
            return [self.users count];
        
        if (self.departments != nil && [self.departments count] > 0)
            return [self.departments count];
        
        return 0;
    }
}


 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     NSInteger sectionCount = [self.tableView numberOfSections];
    
     if (sectionCount == 2) {
         if (indexPath.section == 0) {
             // Пользователи
             UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell"];
             if (!cell) {
                 [tableView registerNib:[UINib nibWithNibName:@"UserTableViewCell" bundle:nil]forCellReuseIdentifier:@"UserCell"];
                 cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell"];
             }
             
             // Инициализируем ячейку друга
             NSLog(@"users count: %li", [self.users count]);
             UserProfileModel *userProfile = (UserProfileModel*)self.users[indexPath.row];
             [cell initCell:userProfile withDeleteButton:NO onClicked:nil];
             return cell;
         } else {
             // Подразделения
             DepartmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DepartmentCell"];
             if (!cell) {
                 [tableView registerNib:[UINib nibWithNibName:@"DepartmentTableViewCell" bundle:nil]forCellReuseIdentifier:@"DepartmentCell"];
                 cell = [tableView dequeueReusableCellWithIdentifier:@"DepartmentCell"];
             }
             NSLog(@"departments count: %li", [self.departments count]);
             [cell initCell:self.departments[indexPath.row]];
             return cell;
         }
     } else {
         // Определить кого показываем
         
         if (self.users != nil && [self.users count] > 0) {
             UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell"];
             if (!cell) {
                 [tableView registerNib:[UINib nibWithNibName:@"UserTableViewCell" bundle:nil]forCellReuseIdentifier:@"UserCell"];
                 cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell"];
             }
             
             // Инициализируем ячейку друга
             NSLog(@"users count: %li", [self.users count]);
             UserProfileModel *userProfile = (UserProfileModel*)self.users[indexPath.row];
             [cell initCell:userProfile withDeleteButton:NO onClicked:nil];
             return cell;
         } else {

             DepartmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DepartmentCell"];
             if (!cell) {
                 [tableView registerNib:[UINib nibWithNibName:@"DepartmentTableViewCell" bundle:nil]forCellReuseIdentifier:@"DepartmentCell"];
                 cell = [tableView dequeueReusableCellWithIdentifier:@"DepartmentCell"];
             }
             NSLog(@"departments count: %li", [self.departments count]);
             [cell initCell:self.departments[indexPath.row]];
             return cell;
         }
         
     }
 }

-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSInteger sectionCount = [self.tableView numberOfSections];
    if (sectionCount == 2) {
        if (section == 0) {
            return @"Сотрудники";
        } else {
            //return @"Подразделения";
            return self.parentDepartmentModel.name;
        }
    }
    //  Если одна секция
    if (self.users != nil && [self.users count] > 0)
        return @"Сотрудники";
    
    if (self.departments != nil && [self.departments count] > 0)
        return self.parentDepartmentModel.name;
    
    return nil;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger sectionCount = [self.tableView numberOfSections];
    
    if (sectionCount == 2) {
        if (indexPath.section == 0) {
            // Пользователи
            UserProfileTableViewController *viewController = [[UserProfileTableViewController alloc] init];
            [viewController setUserProfile:self.parentDepartmentModel.users[indexPath.row]];
            viewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Назад"
                                                                                               style:UIBarButtonItemStylePlain
                                                                                              target:nil
                                                                                              action:nil];
            [self.navigationController pushViewController:viewController animated:YES];
        } else {
            // Подразделения
            OrganizationStructureTableViewController *viewController = [[OrganizationStructureTableViewController alloc] init];
            [viewController setParentDepartment:self.departments[indexPath.row]];
            viewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Назад"
                                                                                             style:UIBarButtonItemStylePlain
                                                                                            target:nil
                                                                                              action:nil];
            [self.navigationController pushViewController:viewController animated:YES];
        }
        
    } else {
        if (self.departments != nil && [self.departments count] >0) {
            // Подразделения
            OrganizationStructureTableViewController *viewController = [[OrganizationStructureTableViewController alloc] init];
            [viewController setParentDepartment:self.departments[indexPath.row]];
            viewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Назад"
                                                                                               style:UIBarButtonItemStylePlain
                                                                                              target:nil
                                                                                              action:nil];
            [self.navigationController pushViewController:viewController animated:YES];
        } else {
            // Пользователи
            UserProfileTableViewController *viewController = [[UserProfileTableViewController alloc] init];
            [viewController setUserProfile:self.parentDepartmentModel.users[indexPath.row]];
            viewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Назад"
                                                                                               style:UIBarButtonItemStylePlain
                                                                                              target:nil
                                                                                              action:nil];
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
