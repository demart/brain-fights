//
//  RatingTableViewController.h
//  BrainFights
//
//  Created by Artem Demidovich on 11/8/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RatingTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *showMenuButton;
- (IBAction)showMenuAction:(UIBarButtonItem *)sender;

@end
