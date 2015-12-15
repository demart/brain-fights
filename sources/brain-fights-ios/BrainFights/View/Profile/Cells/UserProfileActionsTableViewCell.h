//
//  UserProfileActionsTableViewCell.h
//  BrainFights
//
//  Created by Artem Demidovich on 12/11/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface UserProfileActionsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *friendActionView;
@property (weak, nonatomic) IBOutlet UILabel *friendActionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *friendActionImage;

@property (weak, nonatomic) IBOutlet UIView *playActionView;
@property (weak, nonatomic) IBOutlet UIImageView *playActionImage;
@property (weak, nonatomic) IBOutlet UILabel *playActionLabel;

- (void) initCell:(UserProfileModel*) userProfile;

-(void) initCell:(UserProfileModel*)userProfileModel onPlayAction:(void (^)(void))playAction  onAddToFriedsAction:(void (^)(void))addToFriendAction onRemoveFromFriedsAction:(void (^)(void))removeFromFriendAction;

@end
