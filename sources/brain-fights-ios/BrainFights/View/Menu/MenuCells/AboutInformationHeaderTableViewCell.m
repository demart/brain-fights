//
//  AboutInformationHeaderTableViewCell.m
//  BrainFights
//
//  Created by Artem Demidovich on 12/21/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import "AboutInformationHeaderTableViewCell.h"

@implementation AboutInformationHeaderTableViewCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
