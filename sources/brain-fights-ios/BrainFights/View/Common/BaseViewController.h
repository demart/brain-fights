//
//  BaseViewController.h
//  BrainFights
//
//  Created by Artem Demidovich on 11/24/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

- (void) presentErrorViewController;

- (void) presentErrorViewControllerWithTryAgainSelector:(SEL) tryAgainSelector;

@end
