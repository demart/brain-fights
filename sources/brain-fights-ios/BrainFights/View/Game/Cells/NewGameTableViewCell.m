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
    self.gameView.layer.cornerRadius = 10.0f;
    self.gameView.backgroundColor = [Constants SYSTEM_COLOR_GREEN];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
