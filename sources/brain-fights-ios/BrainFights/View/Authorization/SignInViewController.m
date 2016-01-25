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
    [self initButtonView:self.signInButton];
    
    [self initTextFieldView:self.loginTextField];
    [self initTextFieldView:self.passwordTextField];
}

- (void) initTextFieldView:(UITextField*)textField {
    CALayer *border = [CALayer layer];
    CGFloat borderWidth = 2;
    border.borderColor = [Constants SYSTEM_COLOR_GREEN].CGColor;
    //border.borderColor = [Constants SYSTEM_COLOR_ORANGE].CGColor;
    border.frame = CGRectMake(0, textField.frame.size.height - borderWidth, textField.frame.size.width, self.loginTextField.frame.size.height);
    border.borderWidth = borderWidth;
    [textField.layer addSublayer:border];
    textField.layer.masksToBounds = YES;
}


-(void) initButtonView:(UIView*) view {
    view.layer.cornerRadius = 5.0;
    view.layer.masksToBounds = NO;
    view.layer.shadowOffset = CGSizeMake(2, 2);
    view.layer.shadowRadius = 1;
    view.layer.shadowOpacity = 0.5;
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
        [DejalBezelActivityView removeViewAnimated:YES];
        NSString* message = [[NSString alloc] initWithFormat:@"Операция завершилась с ошибкой. Проверьте соединение с интернетом и попробуйте еще раз, Описание ошибки: %li : %@", error.code, error.localizedDescription.description];
        [self showAlertWithTitle:@"Ошибка" andMessage:message];
        //[self presentErrorViewControllerWithTryAgainSelector:@selector(signInAction)];

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
