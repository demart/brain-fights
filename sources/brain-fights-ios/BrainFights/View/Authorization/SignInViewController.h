//
//  SignInViewController.h
//  BrainFights
//
//  Created by Artem Demidovich on 11/6/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignInViewController : UIViewController


@property (weak, nonatomic) IBOutlet UITextField *loginTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;


- (IBAction)signInButtonAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;


// Метод для указания куда нужно вернуться если показали авторизацию уже в процессе игры
-(void) setReturnViewController:(UIViewController*) parentController;

@end
