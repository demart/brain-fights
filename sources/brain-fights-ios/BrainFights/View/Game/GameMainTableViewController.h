//
//  GameMainTableViewController.h
//  BrainFights
//
//  Created by Artem Demidovich on 11/6/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameMainTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *showMenuButton;
- (IBAction)showMenuAction:(UIBarButtonItem *)sender;

- (IBAction)showAuthScene:(UIBarButtonItem *)sender;

@end
