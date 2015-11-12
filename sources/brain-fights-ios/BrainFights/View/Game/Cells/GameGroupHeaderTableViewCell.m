//
//  GameGroupHeaderTableViewCell.m
//  BrainFights
//
//  Created by Artem Demidovich on 11/11/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import "GameGroupHeaderTableViewCell.h"

@implementation GameGroupHeaderTableViewCell

- (void)awakeFromNib {}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void) initCell:(NSString*)title {
    [self.gameGroupHeaderTitle setText:title];
}

@end
