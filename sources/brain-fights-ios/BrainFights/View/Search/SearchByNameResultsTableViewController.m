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

#import "DejalActivityView.h"
#import "GameService.h"


@interface SearchByNameResultsTableViewController ()

@property NSMutableDictionary *loadImageOperations;
@property NSOperationQueue *loadImageOperationQueue;

@end

@implementation SearchByNameResultsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorColor = [UIColor clearColor];
    
    self.loadImageOperationQueue = [[NSOperationQueue alloc] init];
    [self.loadImageOperationQueue setMaxConcurrentOperationCount:1];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [_loadImageOperationQueue cancelAllOperations];
    [_loadImageOperations removeAllObjects];
}


- (void) loadUserAvatarInCell:(UserTableViewCell*) cell onIndexPath:(NSIndexPath*)indexPath withImageUrl:(NSString*)imageUrl {
    UIImage *loadedImage =(UIImage *)[LocalStorageService  loadImageFromLocalCache:imageUrl];
    
    if (loadedImage != nil) {
        cell.iconImage.image = loadedImage;
    } else {
        NSBlockOperation *loadImageOperation = [[NSBlockOperation alloc] init];
        __weak NSBlockOperation *weakOperation = loadImageOperation;
        
        [loadImageOperation addExecutionBlock:^(void){
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:
                                                                                   [UrlHelper imageUrlForAvatarWithPath:imageUrl]
                                                                                   ]]];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^(void) {
                if (! weakOperation.isCancelled) {
                    UserTableViewCell *updateCell = (UserTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                    if (updateCell != nil && image != nil) {
                        updateCell.iconImage.image = image;
                    }
                    
                    if (image != nil) {
                        [LocalStorageService  saveImageToLocalCache:imageUrl withData:image];
                    }
                    [self.loadImageOperations removeObjectForKey:indexPath];
                }
            }];
        }];
        
        [_loadImageOperations setObject: loadImageOperation forKey:indexPath];
        if (loadImageOperation) {
            [_loadImageOperationQueue addOperation:loadImageOperation];
        }
    }
}

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
    [cell initCell:userProfile withDeleteButton:NO onClicked:nil withSendGameInvitationAction:^(NSUInteger userId) {
        NSLog(@"Send game invitation sent");
        [self sendGameInvitationToSelectedUserAction:userId];
    } onParentViewController:self];
    
    [self loadUserAvatarInCell:cell onIndexPath:indexPath withImageUrl:userProfile.imageUrl];
    
    return cell;
}

// Отправить приглашение выбранному пользователю сыграть
- (void) sendGameInvitationToSelectedUserAction:(NSUInteger) userId {
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Подождите..."];
    
    [GameService createGameInvitation:userId onSuccess:^(ResponseWrapperModel *response) {
        if ([response.status isEqualToString:SUCCESS]) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
        if ([response.status isEqualToString:AUTHORIZATION_ERROR]) {
            [DejalBezelActivityView removeViewAnimated:NO];
            [[AppDelegate globalDelegate] showAuthorizationView:self];
        }
        
        if ([response.status isEqualToString:SERVER_ERROR]) {
            [DejalBezelActivityView removeViewAnimated:NO];
            // TODO SHOW ALERT
        }
        
    } onFailure:^(NSError *error) {
        [DejalBezelActivityView removeViewAnimated:NO];
        // TODO SHOW ERROR
    }];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}

@end
