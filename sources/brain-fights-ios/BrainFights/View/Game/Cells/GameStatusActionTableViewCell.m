//
//  GameStatusActionTableViewCell.m
//  BrainFights
//
//  Created by Artem Demidovich on 11/12/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import "GameStatusActionTableViewCell.h"


@interface GameStatusActionTableViewCell()

@property GameModel* model;

@property (nonatomic, copy) void (^playActionBlock)(void);
@property (nonatomic, copy) void (^revancheActionBlock)(void);
@property (nonatomic, copy) void (^addToFriendsActionBlock)(void);
@property (nonatomic, copy) void (^surrenderActionBlock)(void);

@property UITableViewController *parentTableViewController;

@end

@implementation GameStatusActionTableViewCell


- (void)awakeFromNib {
    [self initButtonView:self.surrenderActionButton];
    [self initButtonView:self.playButton];
    [self initButtonView:self.addToFriendsButton];
    
    [self.surrenderActionButton setBackgroundColor:[Constants SYSTEM_COLOR_RED]];
    [self.playButton setBackgroundColor:[Constants SYSTEM_COLOR_GREEN]];
    [self.addToFriendsButton setBackgroundColor:[Constants SYSTEM_COLOR_ORANGE]];
}

-(void) initButtonView:(UIView*) view {
    view.layer.cornerRadius = 5.0;
    view.layer.masksToBounds = NO;
    view.layer.shadowOffset = CGSizeMake(2, 2);
    view.layer.shadowRadius = 2;
    view.layer.shadowOpacity = 0.5;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (void) initCell:(GameModel*) gameModel parentTableViewController:(UITableViewController*) parentTableViewController {
    NSLog(@"GameStatusActionTableViewCell initCell invoked");
    self.model = gameModel;
    self.parentTableViewController = parentTableViewController;
    
    if ([gameModel.status isEqualToString:GAME_STATUS_FINISHED]) {
        [self.surrenderActionButton setHidden:YES];
        [self.playButton setTitle:@"Реванш" forState:UIControlStateNormal];
        [self.playButton setEnabled:YES];
    }
    
    if ([gameModel.status isEqualToString:GAME_STATUS_WAITING]) {
        // Не корректная ситация нужно убрать все кнопки
        [self.surrenderActionButton setHidden:YES];
        [self.playButton setHidden:YES];
        [self.addToFriendsButton setHidden:YES];
    }
    
    if ([gameModel.status isEqualToString:GAME_STATUS_STARTED]) {
        if ([gameModel.me.status isEqualToString:GAMER_STATUS_WAITING_ANSWERS] ||
            [gameModel.me.status isEqualToString:GAMER_STATUS_WAITING_ROUND]) {
            // Ход текущего игрока
            [self.playButton setTitle:@"Играть!" forState:UIControlStateNormal];
            [self.playButton setBackgroundColor:[Constants SYSTEM_COLOR_GREEN]];
            [self.playButton setEnabled:YES];
        }
        
        if ([gameModel.me.status isEqualToString:GAMER_STATUS_WAITING_OPONENT]) {
            // Ожидаем игрока
            [self.playButton setTitle:@"Ждем" forState:UIControlStateNormal];
            [self.playButton setBackgroundColor:[Constants SYSTEM_COLOR_LIGHT_GREY]];
            [self.playButton setEnabled:NO];
        }
    }
    
    if ([gameModel.oponent.user.type isEqualToString:USER_TYPE_FRIEND]) {
        [self.addToFriendsButton setHidden:YES];
    }
}

- (void) initCell:(GameModel*) gameModel onPlayAction:(void (^)(void))playAction onSurrenderAction:(void (^)(void))surrenderAction onAddToFriendsAction:(void (^)(void))addToFriendsAction onRevancheAction:(void (^)(void))onRevancheAction {
    NSLog(@"GameStatusActionTableViewCell initCell invoked");
    self.model = gameModel;
    self.playActionBlock = playAction;
    self.revancheActionBlock = onRevancheAction;
    self.surrenderActionBlock = surrenderAction;
    self.addToFriendsActionBlock = addToFriendsAction;
    
    if ([gameModel.status isEqualToString:GAME_STATUS_FINISHED]) {
        [self.surrenderActionButton setHidden:YES];
        [self.playButton setTitle:@"Реванш" forState:UIControlStateNormal];
    }
    
    if ([gameModel.status isEqualToString:GAME_STATUS_WAITING]) {
        // Не корректная ситация нужно убрать все кнопки
        [self.surrenderActionButton setHidden:YES];
        [self.playButton setHidden:YES];
        [self.addToFriendsButton setHidden:YES];
    }
    
    if ([gameModel.status isEqualToString:GAME_STATUS_STARTED]) {
        if ([gameModel.me.status isEqualToString:GAMER_STATUS_WAITING_ANSWERS] ||
            [gameModel.me.status isEqualToString:GAMER_STATUS_WAITING_ROUND]) {
            // Ход текущего игрока
            [self.playButton setTitle:@"Играть!" forState:UIControlStateNormal];
            [self.playButton setBackgroundColor:[Constants SYSTEM_COLOR_GREEN]];
        }
        
        if ([gameModel.me.status isEqualToString:GAMER_STATUS_WAITING_OPONENT]) {
            // Ожидаем игрока
            [self.playButton setTitle:@"Ждем" forState:UIControlStateNormal];
            [self.playButton setBackgroundColor:[Constants SYSTEM_COLOR_LIGHT_GREY]];
            [self.playButton setEnabled:NO];
        }
    }
    
    if ([gameModel.oponent.user.type isEqualToString:USER_TYPE_FRIEND]) {
        [self.addToFriendsButton setHidden:YES];
    }
    
}


- (IBAction)surrenderAction:(id)sender {
    [self.parentTableViewController performSelector:@selector(onSurrenderAction)];
    //self.surrenderActionBlock();
}

- (IBAction)addToFrindsAction:(UIButton *)sender {
    [self.parentTableViewController performSelector:@selector(onAddToFriendsAction)];
    //self.addToFriendsActionBlock();
}

- (IBAction)playAction:(UIButton *)sender {
    if ([self.model.status isEqualToString:GAME_STATUS_FINISHED]){
        [self.parentTableViewController performSelector:@selector(onRevancheAction)];
        //self.revancheActionBlock();
    } else {
        [self.parentTableViewController performSelector:@selector(onPlayAction)];
        //self.playActionBlock();
    }
}



@end
