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

#import "DepartmentRatingTableViewCell.h"
#import "DepartmentRatingHeaderTableViewCell.h"
#import "OrganizationStructureTableViewController.h"

#import "DejalActivityView.h"

#import "UserService.h"

#import "UserProfileTableViewController.h"
#import "LMDropdownView.h"

// Режим рейтинг пользователей
static NSInteger MODE_USERS = 0;

// Режим рейтинг департаментов
static NSInteger MODE_DEPARTMENTS = 1;

@interface RatingTableViewController ()

@property (strong, nonatomic) LMDropdownView *dropdownView;

// Страница загруженная
@property NSInteger page;

// Подгруженный пользователи или департаменты
@property NSMutableArray* records;

// Есть ли еще записи
@property bool isExistsMoreRecords;

// Режим рейтинга (Пользователи/Департаменты)
@property NSInteger mode;

// Выбранный тип подразделений
@property DepartmentTypeModel *departmentType;

// Доступные типы подразделений
@property NSMutableArray *departmentTypes;



@property NSInteger selectedIndex;

@end

@implementation RatingTableViewController

static NSInteger PAGE_LIMIT = 20;

static UIRefreshControl* refreshControl;


- (void)viewDidLoad {
    [super viewDidLoad];

    self.page = 0;
    self.records = [[NSMutableArray alloc] init];
    self.mode = MODE_USERS;
    
    [self initRefreshControl];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorColor = [UIColor clearColor];
    
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Подождите\nИдет загрузка..."];
    [self loadUsersRating:nil];
    
}


- (IBAction)ratingSegmentedControlValueChanged:(UISegmentedControl *)sender {
    self.page = 0;
    [self.records removeAllObjects];
    
    if (self.dropdownView)
        [self.dropdownView hide];
    
    if (sender.selectedSegmentIndex == MODE_USERS) {
        // MODE USERS
        [DejalBezelActivityView activityViewForView:self.view withLabel:@"Подождите\nИдет загрузка..."];
        self.mode = MODE_USERS;
        [self loadUsersRating:nil];
    }
    
    if (sender.selectedSegmentIndex == MODE_DEPARTMENTS) {
        // MODE DEPARTMENTS
        [DejalBezelActivityView activityViewForView:self.view withLabel:@"Подождите\nИдет загрузка..."];
        self.mode = MODE_DEPARTMENTS;
        if (self.departmentTypes == nil || [self.departmentTypes count] < 1) {
            
            [self loadDepartmentTypesAndDepartments];
        } else {
            [self loadDepartmentsRating:nil];
        }
    }
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
    [self.records removeAllObjects];
    
    if (self.mode == MODE_USERS) {
        [self loadUsersRating:refreshControll];
    } else {
        [self loadDepartmentsRating:refreshControll];
    }
}


// Загружает данные с сервера
-(void) loadUsersRating:(UIRefreshControl*) refreshControll {
    [[UserService sharedInstance] retrieveUsersRating:self.page withLimit:PAGE_LIMIT onSuccess:^(ResponseWrapperModel *response) {
        if (refreshControll != nil)
            [refreshControll endRefreshing];
        if ([response.status isEqualToString:SUCCESS]) {
            NSMutableArray *userProfiles = (NSMutableArray*)response.data;
            if (userProfiles == nil || [userProfiles count] < 1) {
                self.isExistsMoreRecords = NO;
            } else {
                [self.records addObjectsFromArray:userProfiles];
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
            [[AppDelegate globalDelegate] showAuthorizationView:self];
        }
        
        if ([response.status isEqualToString:SERVER_ERROR]) {
            [self presentErrorViewControllerWithTryAgainSelector:@selector(loadUsersRating)];
        }
        [DejalBezelActivityView removeViewAnimated:NO];
        
    } onFailure:^(NSError *error) {
        if (refreshControll != nil)
            [refreshControll endRefreshing];
        [DejalBezelActivityView removeViewAnimated:NO];
        [self presentErrorViewControllerWithTryAgainSelector:@selector(loadUsersRating)];
    }];
}


// Загружает данные с сервера
-(void) loadDepartmentsRating:(UIRefreshControl*) refreshControll {
    [[UserService sharedInstance] retrieveDepartmentsRating:self.departmentType.id withPage:self.page withLimit:PAGE_LIMIT onSuccess:^(ResponseWrapperModel *response) {
        if (refreshControll != nil)
            [refreshControll endRefreshing];
        if ([response.status isEqualToString:SUCCESS]) {
            NSMutableArray *departments = (NSMutableArray*)response.data;
            if (departments == nil || [departments count] < 1) {
                self.isExistsMoreRecords = NO;
            } else {
                [self.records addObjectsFromArray:departments];
                if ([departments count] == PAGE_LIMIT) {
                    self.page = self.page + 1;
                    self.isExistsMoreRecords = YES;
                } else {
                    self.isExistsMoreRecords = NO;
                }
            }
            [self.tableView reloadData];
        }

        if ([response.status isEqualToString:AUTHORIZATION_ERROR]) {
            [[AppDelegate globalDelegate] showAuthorizationView:self];
        }
        
        if ([response.status isEqualToString:SERVER_ERROR]) {
            // TODO SHOW ERROR
            //[self presentErrorViewControllerWithTryAgainSelector:@selector(loadUsersRating)];
        }
        [DejalBezelActivityView removeViewAnimated:NO];
        
    } onFailure:^(NSError *error) {
        if (refreshControll != nil)
            [refreshControll endRefreshing];
        [DejalBezelActivityView removeViewAnimated:NO];
        [self presentErrorViewControllerWithTryAgainSelector:@selector(loadUsersRating)];
    }];
}

- (void) loadDepartmentTypesAndDepartments {
    [[UserService sharedInstance] retrieveDepartmentTyps:^(ResponseWrapperModel *response) {
        if ([response.status isEqualToString:SUCCESS]) {
            NSMutableArray *departmentTypes = (NSMutableArray*)response.data;
            if (departmentTypes == nil || [departmentTypes count] < 1) {
                //
            } else {
                self.departmentTypes = departmentTypes;
                self.departmentType = departmentTypes[0];
                [self loadDepartmentsRating:nil];
            }
        }
        
        if ([response.status isEqualToString:AUTHORIZATION_ERROR]) {
            [[AppDelegate globalDelegate] showAuthorizationView:self];
        }
        
        if ([response.status isEqualToString:SERVER_ERROR]) {
            // TODO SHOW ERROR
        }
    } onFailure:^(NSError *error) {
        [self presentErrorViewControllerWithTryAgainSelector:@selector(loadUsersRating)];
    }];
}


//[self.menuTableView reloadData];
//[self showDropDownView];

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.menuTableView) {
        return 1;
    }
    
    if (self.mode == MODE_DEPARTMENTS) {
       return 1; // One for filter
    }
    
    if (self.mode == MODE_USERS) {
        return 1; // One for filter
    }
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.menuTableView) {
        if (self.departmentTypes == nil)
            return 0;
        return [self.departmentTypes count];
    }
    
    if (self.records != nil)
        return [self.records count];
    return 0;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == self.menuTableView) {
        return 0;
    }
    return 35;
}

-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == self.menuTableView) {
        return nil;
    }
    
    if (self.mode == MODE_USERS) {
        UserRatingHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserRatingHeaderCell"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"UserRatingHeaderTableViewCell" bundle:nil]forCellReuseIdentifier:@"UserRatingHeaderCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"UserRatingHeaderCell"];
        }
        
            [cell initCellWithHeaderTitle:@"Сотрудник"];
        return cell;
    }
    
    if (self.mode == MODE_DEPARTMENTS) {
        if (section == 0) {
            DepartmentRatingHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DepartmentRatingHeaderCell"];
            if (!cell) {
                [tableView registerNib:[UINib nibWithNibName:@"DepartmentRatingHeaderTableViewCell" bundle:nil]forCellReuseIdentifier:@"DepartmentRatingHeaderCell"];
                cell = [tableView dequeueReusableCellWithIdentifier:@"DepartmentRatingHeaderCell"];
            }
            
            NSString *headerTitle = nil;
            if (self.departmentTypes != nil && [self.departmentTypes count] > 0) {
                if (self.selectedIndex < 0) {
                    headerTitle = ((DepartmentTypeModel*)self.departmentTypes[0]).name;
                } else {
                    headerTitle = ((DepartmentTypeModel*)self.departmentTypes[self.selectedIndex]).name;
                }
            }
            
            [cell initCellWithTitle:headerTitle andShowSortingOptionsAction:^{
                [self.menuTableView reloadData];
                [self showDropDownView];
            }];
            
            return cell;
        }
    }
    
    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.menuTableView) {
        DepartmentTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DepartmentTypeCell"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"DepartmentTypeTableViewCell" bundle:nil]forCellReuseIdentifier:@"DepartmentTypeCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"DepartmentTypeCell"];
        }
        
        DepartmentTypeModel *model = self.departmentTypes[indexPath.row];
        if (self.selectedIndex == indexPath.row) {
            [cell initCell:model.name isSelected:YES];
        } else {
            [cell initCell:model.name isSelected:NO];
        }
        
        return cell;
    }
    
    if (self.mode == MODE_USERS) {
        UserRatingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserRatingCell"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"UserRatingTableViewCell" bundle:nil]forCellReuseIdentifier:@"UserRatingCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"UserRatingCell"];
        }
        
        [cell initCell:self.records[indexPath.row] withIndex:indexPath.row];
        return cell;
    }
    
    
    if (self.mode == MODE_DEPARTMENTS) {
        DepartmentRatingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DepartmentRatingCell"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"DepartmentRatingTableViewCell" bundle:nil]forCellReuseIdentifier:@"DepartmentRatingCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"DepartmentRatingCell"];
        }
        
        [cell initCell:self.records[indexPath.row] withIndex:indexPath.row];
        return cell;
    }
    
    return nil;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.menuTableView) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        
        self.selectedIndex = indexPath.row;
        self.departmentType = self.departmentTypes[indexPath.row];
        [self.dropdownView hide];
        self.page = 0;
        [self.records removeAllObjects];
        [DejalBezelActivityView activityViewForView:self.view withLabel:@"Подождите\nИдет загрузка..."];
        [self loadDepartmentsRating:nil];
        
        return;
    }
    
    if (self.mode == MODE_USERS) {
        UserProfileTableViewController *destination = [[UserProfileTableViewController alloc] init];
        [destination setUserProfile:self.records[indexPath.row]];
        [self.navigationController pushViewController:destination animated:YES];
    }
    
    if (self.mode == MODE_DEPARTMENTS) {
        OrganizationStructureTableViewController *viewController = [[OrganizationStructureTableViewController alloc] init];
        [viewController setParentDepartment:self.records[indexPath.row]];
        viewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Назад"
                                                                                           style:UIBarButtonItemStylePlain
                                                                                          target:nil
                                                                                          action:nil];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}


// Метод позволяет опроеделить что пользователь дошел до конца списка
-(void) scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.isExistsMoreRecords) {
//        [DejalBezelActivityView activityViewForView:self.view withLabel:@"Подождите\nИдет загрузка..."];
        [self loadUsersRating:nil];
    }
}

- (IBAction)showMenuAction:(UIBarButtonItem *)sender {
    [[AppDelegate globalDelegate] toggleLeftDrawer:self animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}


#pragma mark - DROPDOWN VIEW

- (void)showDropDownView
{
    // Init dropdown view
    if (!self.dropdownView) {
        self.dropdownView = [LMDropdownView dropdownView];
        self.dropdownView.delegate = self;
        
        // Customize Dropdown style
        self.dropdownView.closedScale = 0.95;
        self.dropdownView.blurRadius = 5;
        self.dropdownView.blackMaskAlpha = 0.5;
        self.dropdownView.animationDuration = 0.5;
        self.dropdownView.animationBounceHeight = 10;
        self.dropdownView.contentBackgroundColor = [UIColor colorWithRed:40.0/255 green:196.0/255 blue:80.0/255 alpha:1];
    }
    
    // Show/hide dropdown view
    if ([self.dropdownView isOpen]) {
        [self.dropdownView hide];
    }
    else {
        [self.menuTableView setFrame:CGRectMake(0,
                                                0,
                                                CGRectGetWidth(self.view.bounds),
                                                MIN(CGRectGetHeight(self.view.bounds)/2, self.departmentTypes.count * 50))];

        [self.menuTableView reloadData];
        [self.dropdownView showFromNavigationController:self.navigationController withContentView:self.menuTableView];
    }
}

- (void)dropdownViewWillShow:(LMDropdownView *)dropdownView {
    //NSLog(@"Dropdown view will show");
}

- (void)dropdownViewDidShow:(LMDropdownView *)dropdownView {
    //NSLog(@"Dropdown view did show");
}

- (void)dropdownViewWillHide:(LMDropdownView *)dropdownView {
    //NSLog(@"Dropdown view will hide");
}

- (void)dropdownViewDidHide:(LMDropdownView *)dropdownView {
    //NSLog(@"Dropdown view did hide");
    
    [self.tableView reloadData];
    /*
    switch (self.currentMapTypeIndex) {
        case 0:
            self.mapView.mapType = MKMapTypeStandard;
            break;
        case 1:
            self.mapView.mapType = MKMapTypeSatellite;
            break;
        case 2:
            self.mapView.mapType = MKMapTypeHybrid;
            break;
        default:
            break;
    }*/
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
