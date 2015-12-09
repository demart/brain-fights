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
@property (nonatomic, copy) void (^sendGameInvitationAction)(NSUInteger);
@property UITapGestureRecognizer *recognizer;
@property UIViewController *parentViewController;

@end

@implementation UserTableViewCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.roundView.backgroundColor = [Constants SYSTEM_COLOR_GREEN];
    self.roundView.layer.cornerRadius = 5.0;
    self.roundView.layer.masksToBounds = NO;
    self.roundView.layer.shadowOffset = CGSizeMake(2, 2);
    self.roundView.layer.shadowRadius = 1;
    self.roundView.layer.shadowOpacity = 0.5;
    self.backgroundColor = [Constants SYSTEM_COLOR_WHITE];
    
    self.userName.textColor = [Constants SYSTEM_COLOR_WHITE];
    self.userPosition.textColor = [Constants SYSTEM_COLOR_WHITE];
    self.leftActionView.backgroundColor = [Constants SYSTEM_COLOR_ORANGE];
    self.leftActionView.layer.cornerRadius = 5.0;
    self.leftActionView.layer.masksToBounds = NO;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

// Инициализируем ячейкам
- (void) initCell:(UserProfileModel*) userProfile withDeleteButton:(BOOL)showDeleteButton onClicked:(void (^)())clicked withSendGameInvitationAction:(void (^)(NSUInteger))sendGameInvitationAction onParentViewController:(UIViewController*) parentViewController {
    self.userProfile = userProfile;
    [self.userName setText: userProfile.name];
    [self.userPosition setText:userProfile.position];
    
    self.sendGameInvitationAction = sendGameInvitationAction;
    self.parentViewController = parentViewController;
    
    if (showDeleteButton) {
        self.rightUtilityButtons = [self friendsRightButtons];
        self.delegate = self;
        self.clickedBlockAction = clicked;
    }
    
    [self initRightActionView];

}

// Инициализируем правую область
-(void)initRightActionView {
    if ([self.userProfile.type isEqualToString:USER_TYPE_ME]) {
        [self.leftActionView removeFromSuperview];
        return;
    }
    
    if ([self.userProfile.playStatus isEqualToString:USER_GAME_PLAYING_STATUS_READY]) {
        self.leftActionView.backgroundColor = [Constants SYSTEM_COLOR_ORANGE];
    } else {
        self.leftActionView.backgroundColor = [Constants SYSTEM_COLOR_DARK_GREY];
    }
    
    // Ставим прошлушку на View
    if (self.recognizer == nil) {
        self.recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightActionViewTapped:)];
        [self.recognizer setNumberOfTapsRequired:1];
        [self.leftActionView addGestureRecognizer:self.recognizer];
    }
}


// Пользователь нажал на кнопку
-(void) rightActionViewTapped:(UITapGestureRecognizer *)recognizer {
    // Если можно отправить приглашение
    if ([self.userProfile.playStatus isEqualToString:USER_GAME_PLAYING_STATUS_READY]) {
        self.sendGameInvitationAction(self.userProfile.id);
        return;
    }

    if ([self.userProfile.playStatus isEqualToString:USER_GAME_PLAYING_STATUS_PLAYING]) {
        [self presentSimpleAlertViewWithTitle:@"Внимание" andMessage:@"Вы уже играете с выбранным игроком."];
    }
    
    if ([self.userProfile.playStatus isEqualToString:USER_GAME_PLAYING_STATUS_INVITED]) {
        [self presentSimpleAlertViewWithTitle:@"Внимание" andMessage:@"Вы уже отравили приглашение пользователю и ждете подтверждение."];
    }
    
    if ([self.userProfile.playStatus isEqualToString:USER_GAME_PLAYING_STATUS_WAITING]) {
        [self presentSimpleAlertViewWithTitle:@"Внимание" andMessage:@"Игрок уже отправил вам приглашение и ждет вашего решения."];
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


- (void) presentSimpleAlertViewWithTitle:(NSString*)title andMessage:(NSString*)message {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    [self.parentViewController presentViewController:alert animated:YES completion:nil];
}


@end
