//
//  UserProfileActionTableViewCell.h
//  BrainFights
//
//  Created by Artem Demidovich on 11/22/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface UserProfileActionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *twoActionsView;
@property (weak, nonatomic) IBOutlet UIView *oneActionView;
@property (weak, nonatomic) IBOutlet UIButton *twoActionsViewPlayButton;
@property (weak, nonatomic) IBOutlet UIButton *twoActionsViewAddToFriendButton;
@property (weak, nonatomic) IBOutlet UIButton *oneActionViewPlayButton;
- (IBAction)twoActionsViewPlayAction:(UIButton *)sender;

- (IBAction)oneActionViewPlayAction:(UIButton *)sender;
- (IBAction)twoActionsViewAddToFriendAction:(UIButton *)sender;

-(void) initCell:(UserProfileModel*)userProfileModel onPlayAction:(void (^)(void))playAction  onAddToFriedsAction:(void (^)(void))addToFriendAction;

@end
