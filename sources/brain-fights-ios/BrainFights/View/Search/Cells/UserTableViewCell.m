//
//  UserTableViewCell.m
//  BrainFights
//
//  Created by Artem Demidovich on 11/9/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import "UserTableViewCell.h"

@interface UserTableViewCell()

@property (nonatomic, copy) void (^clickedBlockAction)(void);

@end

@implementation UserTableViewCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.roundView.backgroundColor = [Constants SYSTEM_COLOR_GREEN];
    self.roundView.layer.cornerRadius = 5.0;
    self.roundView.layer.masksToBounds = NO;
    self.roundView.layer.shadowOffset = CGSizeMake(1, 1);
    self.roundView.layer.shadowRadius = 3;
    self.roundView.layer.shadowOpacity = 0.5;
    self.backgroundColor = [Constants SYSTEM_COLOR_WHITE];
    
    self.userName.textColor = [Constants SYSTEM_COLOR_WHITE];
    self.userPosition.textColor = [Constants SYSTEM_COLOR_WHITE];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

// Инициализируем ячейкам
- (void) initCell:(UserProfileModel*) userProfile withDeleteButton:(BOOL)showDeleteButton onClicked:(void (^)())clicked {
    self.userProfile = userProfile;
    [self.userName setText: userProfile.name];
    [self.userPosition setText:userProfile.position];
    
    if (showDeleteButton) {
        self.rightUtilityButtons = [self friendsRightButtons];
        self.delegate = self;
        self.clickedBlockAction = clicked;
    }
    
}

- (NSArray *)friendsRightButtons {
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
     //[UIColor whiteColor]
                                                title:@"Удалить"];
    
    return rightUtilityButtons;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    NSLog(@"Right button clicked");
    self.clickedBlockAction();
}


@end
