//
//  BaseViewController.m
//  BrainFights
//
//  Created by Artem Demidovich on 11/24/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import "AppDelegate.h"

#import "BaseViewController.h"
#import "ErrorViewController.h"


@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) presentErrorViewController {
    [self presentErrorViewControllerWithTryAgainSelector:nil];
}

- (void) presentErrorViewControllerWithTryAgainSelector:(SEL) tryAgainSelector  {
    ErrorViewController *errorViewController = [[ErrorViewController alloc] init];
    [errorViewController setTryAgainActionSelector:tryAgainSelector onController:self];
    [self presentViewController:errorViewController animated:YES completion:nil];
}


@end
