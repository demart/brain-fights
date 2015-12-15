//
//  AboutTableViewCell.h
//  BrainFights
//
//  Created by Artem Demidovich on 12/11/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface AboutTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *minimumGreenViewConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeightConstraint;

@property (weak, nonatomic) IBOutlet UILabel *aphionLabel;

@end
