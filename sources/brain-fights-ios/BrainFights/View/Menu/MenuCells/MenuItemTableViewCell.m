//
//  MenuItemTableViewCell.m
//  BrainFights
//
//  Created by Artem Demidovich on 11/8/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import "MenuItemTableViewCell.h"
#import "AppDelegate.h"

@implementation MenuItemTableViewCell

- (void)awakeFromNib {
    self.backgroundColor = [Constants SYSTEM_COLOR_WHITE];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.backgroundColor = [UIColor clearColor];
}

// Инициализиурем ячейку
-(void) initCell:(NSString*) title withImage:(UIImage*)iconImage {
    [self.menuItemTitleLabel setText:title];
    [self.menuItemIcon setImage:iconImage];
}

@end
