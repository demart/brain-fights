//
//  MenuItemTableViewCell.m
//  BrainFights
//
//  Created by Artem Demidovich on 11/8/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import "MenuItemTableViewCell.h"

@implementation MenuItemTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.backgroundColor = [UIColor clearColor];
    [self.menuItemTitleLabel setTextColor:[UIColor whiteColor]];
}

// Инициализиурем ячейку
-(void) initCell:(NSString*) title withImage:(UIImage*)iconImage {
    [self.menuItemTitleLabel setText:title];
    [self.menuItemIcon setImage:iconImage];
}

@end
