//
//  UserTableViewCell.h
//  BrainFights
//
//  Created by Artem Demidovich on 11/9/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "UserProfileModel.h"
#import "SWTableViewCell.h"

@interface UserTableViewCell : SWTableViewCell<SWTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userPosition;
@property (weak, nonatomic) IBOutlet UIView *roundView;

// Модель пользователя
@property UserProfileModel *userProfile;

// Инициализируем ячейкам
- (void) initCell:(UserProfileModel*) userProfile withDeleteButton:(BOOL)showDeleteButton onClicked:(void (^)())clicked;


@end