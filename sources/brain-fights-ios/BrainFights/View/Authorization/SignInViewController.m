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

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (IBAction)signInButtonAction:(UIButton *)sender {
    NSString* login = [self.loginTextField text];
    NSString* password = [self.passwordTextField text];

    [self.view endEditing:YES];
    
    // Авторизовываемся
    [AuthorizationService authorizeUserAsync:login withPassword:password onSuccess:^(ResponseWrapperModel *response) {

        if ([response.status isEqualToString:AUTHORIZATION_ERROR]) {
            // Если ошибка авторизации
            // Ругаемся просим ввести обратно логин/пароль
            NSLog(@"User or password is incorrect");
            
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
                // Ошибка сервера и другие статусы
                NSLog(@"Authorization failed: %@ %@", response.errorCode, response.errorMessage);
            }
        }
        
    } onFailure:^(NSError *error) {
        // Если ошибка, то скорее всего сети нужно показать скрин и передать функцию на перевызов
    }];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
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

// Called when the UIKeyboardWillHideNotification is sent
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
