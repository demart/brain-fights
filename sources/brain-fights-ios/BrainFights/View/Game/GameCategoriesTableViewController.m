//
//  GameCategoriesTableViewController.m
//  BrainFights
//
//  Created by Artem Demidovich on 11/12/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import "GameCategoriesTableViewController.h"
#import "CategoryTableViewCell.h"
#import "GameQuestionViewController.h"

#import "DejalActivityView.h"

@interface GameCategoriesTableViewController ()

@property GameModel* model;
@property UITableViewController* gameStatusController;

@end

@implementation GameCategoriesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void) initViewController:(GameModel*)gameModel fromGameStatus:(UITableViewController*) gameStatusController {
    self.model = gameModel;
    self.gameStatusController = gameStatusController;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.model != nil && self.model.categories != nil)
        return 1;
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.model != nil && self.model.categories != nil)
        return [self.model.categories count];
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 170;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CategoryCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"CategoryTableViewCell" bundle:nil]forCellReuseIdentifier:@"CategoryCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"CategoryCell"];
    }
    
    [cell initCell:self.model.categories[indexPath.row]];
    
    return cell;
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self processSelectedCategory];
}


- (void) processSelectedCategory {
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Подождите\nИдет загрузка..."];
    
    NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
    GameRoundCategoryModel *categoryModel = (GameRoundCategoryModel*)self.model.categories[indexPath.row];

    [GameService genereateGameRound:self.model.id withSelectedCategory:categoryModel.id onSuccess:^(ResponseWrapperModel *response) {
        // Check data and refresh table
        if ([response.status isEqualToString:SUCCESS]) {
            GameRoundModel *gameRoundModel = (GameRoundModel*)response.data;
            
            // Начинаем новый раунд
            GameQuestionViewController *gameQuestionViewController = [[[AppDelegate globalDelegate] drawersStoryboard] instantiateViewControllerWithIdentifier:@"GameQuestionViewController"];
            [gameQuestionViewController initView:self.gameStatusController withGameModel:self.model withGameRoundModel:gameRoundModel];
            [self presentViewController:gameQuestionViewController animated:YES completion:nil];
            [DejalBezelActivityView removeViewAnimated:NO];
        }
        
        if ([response.status isEqualToString:AUTHORIZATION_ERROR]) {
            [[AppDelegate globalDelegate] showAuthorizationView:self];
        }
        
        if ([response.status isEqualToString:SERVER_ERROR]) {
            [DejalBezelActivityView removeViewAnimated:NO];
            [self presentErrorViewControllerWithTryAgainSelector:@selector(processSelectedCategory)];
        }
    } onFailure:^(NSError *error) {
        [DejalBezelActivityView removeViewAnimated:NO];
        [self presentErrorViewControllerWithTryAgainSelector:@selector(processSelectedCategory)];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
