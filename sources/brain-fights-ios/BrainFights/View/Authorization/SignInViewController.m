//
//  SignInViewController.m
//  BrainFights
//
//  Created by Artem Demidovich on 11/6/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import "SignInViewController.h"
#import "LocalStorageService.h"

#import "AuthorizationService.h"
#import "AuthorizationResponseModel.h"

#import "UserService.h"
#import "AppDelegate.h"

#import "DejalActivityView.h"

@interface SignInViewController ()

@property UIViewController *parentController;

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGSize size =  CGSizeMake(self.view.bounds.size.width-50, self.view.bounds.size.height+10);
    [self.scrollView setContentSize:size];
    
    // Загружаем логин, который был успешно использован до этого
    [self.loginTextField setText:(NSString*)[LocalStorageService getSettingsValueByKey:AUTH_LOGIN]];
    [self registerForKeyboardNotifications];
}

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (IBAction)signInButtonAction:(UIButton *)sender {
    [self signInAction];
}


-(void) signInAction {
    [DejalBezelActivityView  activityViewForView:self.view withLabel:@"Подождите\nИдет процесс авторизации..."];
    NSString* login = [self.loginTextField text];
    NSString* password = [self.passwordTextField text];
    
    [self.view endEditing:YES];
    
    // Авторизовываемся
    [AuthorizationService authorizeUserAsync:login withPassword:password onSuccess:^(ResponseWrapperModel *response) {
        [DejalBezelActivityView removeViewAnimated:YES];
        if ([response.status isEqualToString:AUTHORIZATION_ERROR]) {
            // Если ошибка авторизации
            // Ругаемся просим ввести обратно логин/пароль
            NSLog(@"User or password is incorrect");
            [self showIncorrectLoginPasswordMessage];
            
        } else {
            if ([response.status isEqualToString:SUCCESS]) {
                // 0. Сохраняем токен авторизации
                AuthorizationResponseModel *authResponse = (AuthorizationResponseModel*)response.data;
                [LocalStorageService setSettingsKey:AUTH_TOKEN withObject:authResponse.authToken];
                
                // 1. Отправляем событие входа тем кто подписан
                // ....
                [[UserService sharedInstance] setUserProfile:authResponse.userProfile];
                
                // 2. Сохранаем последний успешный логин
                [LocalStorageService setSettingsKey:AUTH_LOGIN withObject:login];
                
                // 3. Делаем переход либо на главный скрин игры либо на страницу откуда сюда попали
                if (self.parentController) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                } else {
                    [[AppDelegate globalDelegate] initDrawerMenu];
                }
            } else {
                if ([response.status isEqualToString:NO_CONTENT]) {
                    // Impossible
                }
                if ([response.status isEqualToString:SERVER_ERROR]) {
                    [self presentErrorViewControllerWithTryAgainSelector:@selector(signInAction)];
                }
                NSLog(@"Authorization failed: %@ %@", response.errorCode, response.errorMessage);
            }
        }
        
        
    } onFailure:^(NSError *error) {
        [self presentErrorViewControllerWithTryAgainSelector:@selector(signInAction)];
        [DejalBezelActivityView removeViewAnimated:NO];
    }];
}

- (void) showIncorrectLoginPasswordMessage {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Ошибка авторизации"
                                                                   message:@"Проверьте правильность введенного логина и/или пароля"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, self.loginTextField.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, self.signInButton.frame.origin.y-kbSize.height);
        [self.scrollView setContentOffset:scrollPoint animated:YES];
    }
    if (!CGRectContainsPoint(aRect, self.passwordTextField.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, self.signInButton.frame.origin.y-kbSize.height);
        [self.scrollView setContentOffset:scrollPoint animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) setReturnViewController:(UIViewController*) parentController {
    self.parentController = parentController;
}

@end
