//
//  GameQuestionViewController.m
//  BrainFights
//
//  Created by Artem Demidovich on 11/18/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import "GameQuestionViewController.h"

@interface GameQuestionViewController ()

@property UIViewController *gameStatusViewController;

@end

@implementation GameQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void) initView:(UIViewController*) gameStatusViewController {
    self.gameStatusViewController = gameStatusViewController;
}


- (IBAction)dismissView:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [self.gameStatusViewController.navigationController popToViewController:self.gameStatusViewController animated:YES];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
