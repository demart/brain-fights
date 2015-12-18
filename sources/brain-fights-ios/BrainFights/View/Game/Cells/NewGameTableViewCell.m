//
//  NewGameTableViewCell.m
//  BrainFights
//
//  Created by Artem Demidovich on 11/8/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import "NewGameTableViewCell.h"
#import "Constants.h"

@implementation NewGameTableViewCell

- (void)awakeFromNib {
    // Загругляем углы
    [self initButtonView:self.gameView];
    self.gameView.backgroundColor = [Constants SYSTEM_COLOR_GREEN];
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

@end
