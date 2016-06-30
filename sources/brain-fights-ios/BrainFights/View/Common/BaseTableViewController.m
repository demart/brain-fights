//
//  BaseTableViewController.m
//  BrainFights
//
//  Created by Artem Demidovich on 11/24/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import "AppDelegate.h"

#import "BaseTableViewController.h"
#import "ErrorViewController.h"

@interface BaseTableViewController ()

@end

@implementation BaseTableViewController

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



- (void) presentSimpleAlertViewWithTitle:(NSString*)title andMessage:(NSString*)message {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}


// Показывает сообщение об ошибке
- (void) showAlertWithTitle:(NSString*)title andMessage:(NSString*) message onAction:(void (^)(void))onActionBlock {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              onActionBlock();
                                                          }];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
