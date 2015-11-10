//
//  MenuItemTableViewCell.h
//  BrainFights
//
//  Created by Artem Demidovich on 11/8/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuItemTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *menuItemTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *menuItemIcon;

// Инициализиурем ячейку
-(void) initCell:(NSString*) title;

@end
