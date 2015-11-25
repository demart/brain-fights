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
    
    GameRoundCategoryModel *categoryModel = (GameRoundCategoryModel*)self.model.categories[indexPath.row];
    
    // SHOW LOADING
    // Call API to retrieve Questions
    [GameService genereateGameRound:self.model.id withSelectedCategory:categoryModel.id onSuccess:^(ResponseWrapperModel *response) {
        // Check data and refresh table
        if ([response.status isEqualToString:SUCCESS]) {
            GameRoundModel *gameRoundModel = (GameRoundModel*)response.data;
            
            // Начинаем новый раунд
            GameQuestionViewController *gameQuestionViewController = [[[AppDelegate globalDelegate] drawersStoryboard] instantiateViewControllerWithIdentifier:@"GameQuestionViewController"];
            [gameQuestionViewController initView:self.gameStatusController withGameModel:self.model withGameRoundModel:gameRoundModel];
            [self presentViewController:gameQuestionViewController animated:YES completion:nil];
        }
        
        if ([response.status isEqualToString:AUTHORIZATION_ERROR]) {
            // Show Authorization View
            [[AppDelegate globalDelegate] showAuthorizationView:self];
        }
        
        if ([response.status isEqualToString:SERVER_ERROR]) {
            // Show Error Alert
            // TODO
        }
    } onFailure:^(NSError *error) {
        // SHOW ERROR
        
    }];
    
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
