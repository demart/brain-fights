//
//  AboutTableViewController.h
//  BrainFights
//
//  Created by Artem Demidovich on 12/11/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface AboutTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *showMenuButton;

- (IBAction)showMenuAction:(UIBarButtonItem *)sender;

@end
