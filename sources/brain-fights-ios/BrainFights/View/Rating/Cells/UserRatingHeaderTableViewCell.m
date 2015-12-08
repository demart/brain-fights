//
//  UserRatingHeaderTableViewCell.m
//  BrainFights
//
//  Created by Artem Demidovich on 11/21/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import "UserRatingHeaderTableViewCell.h"

@implementation UserRatingHeaderTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void) initCellWithHeaderTitle:(NSString*)title {
    [self.headerGroupTitle setText:title];
}

@end
