//
//  ChoiceSearchActionTableViewCell.m
//  BrainFights
//
//  Created by Artem Demidovich on 11/9/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import "ChoiceSearchActionTableViewCell.h"

@implementation ChoiceSearchActionTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


-(void) initCell:(NSString*) choiceActionTitle withImage:(NSString*)iconName {
    [self.choiceActionTitle setText:choiceActionTitle];
    [self.iconImage setImage:[UIImage imageNamed:iconName]];
}

@end
