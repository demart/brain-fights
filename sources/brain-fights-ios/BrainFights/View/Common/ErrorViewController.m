//
//  ErrorViewController.m
//  BrainFights
//
//  Created by Artem Demidovich on 11/24/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import "ErrorViewController.h"
#import "Constants.h"

@interface ErrorViewController ()

@property SEL tryAgainAction;
@property UIViewController *targetController;

@end

@implementation ErrorViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [Constants SYSTEM_COLOR_GREEN];
    
    self.tryAgainButton.backgroundColor = [Constants SYSTEM_COLOR_ORANGE];
    self.tryAgainButton.layer.cornerRadius = 5.0;
    self.tryAgainButton.layer.masksToBounds = NO;
    self.tryAgainButton.layer.shadowOffset = CGSizeMake(1, 1);
    self.tryAgainButton.layer.shadowRadius = 5;
    self.tryAgainButton.layer.shadowOpacity = 0.5;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) setTryAgainActionSelector:(SEL) tryAgainAction onController:(UIViewController*) targetController {
    self.tryAgainAction = tryAgainAction;
    self.targetController = targetController;
}

- (IBAction)tryAgainButtonAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:self completion:^{
        if (self.targetController != nil && self.tryAgainAction != nil)
            [self.targetController performSelector:self.tryAgainAction];
    }];
}
     
@end
