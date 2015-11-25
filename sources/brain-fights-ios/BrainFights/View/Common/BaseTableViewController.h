//
//  BaseTableViewController.h
//  BrainFights
//
//  Created by Artem Demidovich on 11/24/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableViewController : UITableViewController

- (void) presentErrorViewController;

- (void) presentErrorViewControllerWithTryAgainSelector:(SEL) tryAgainSelector;


- (void) presentSimpleAlertViewWithTitle:(NSString*)title andMessage:(NSString*)message;

@end
