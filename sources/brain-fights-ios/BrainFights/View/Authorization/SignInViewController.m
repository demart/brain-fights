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
    
    // Загружаем логин, который был успешно использован до этого
    [self.loginTextField setText:(NSString*)[LocalStorageService getSettingsValueByKey:AUTH_LOGIN]];
}


- (IBAction)signInButtonAction:(UIButton *)sender {
    NSString* login = [self.loginTextField text];
    NSString* password = [self.passwordTextField text];

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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) setReturnViewController:(UIViewController*) parentController {
    self.parentController = parentController;
}

@end
