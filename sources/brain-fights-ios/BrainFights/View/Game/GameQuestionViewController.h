//
//  GameQuestionViewController.h
//  BrainFights
//
//  Created by Artem Demidovich on 11/18/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameQuestionViewController : UIViewController

- (IBAction)dismissView:(UIButton *)sender;

- (void) initView:(UIViewController*) gameStatusViewController;

@end
