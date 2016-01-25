//
//  AuthorizationCheckedViewController.m
//  BrainFights
//
//  Created by Artem Demidovich on 11/6/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import "AuthorizationCheckedViewController.h"


#import "AppDelegate.h"

#import "JVFloatingDrawerViewController.h"
#import "JVFloatingDrawerSpringAnimator.h"

#import "AuthorizationService.h"
#import "AuthorizationResponseModel.h"

#import "UserService.h"

@interface AuthorizationCheckedViewController ()

@end

@implementation AuthorizationCheckedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    sleep(2);
    [self checkAuthorization];
}


- (void) checkAuthorization {
    if ([AuthorizationService isAuthTokenExisit]) {
        [AuthorizationService retrieveUserProfileAsync:^(ResponseWrapperModel *response) {
            if ([response.status isEqualToString:SUCCESS]) {
                // Если профиль загрузили, тогда
                // 1. Сохраняем данные в синглтоне, до последующего обновления
                UserProfileModel *userProfile = (UserProfileModel*)response.data;
                [[UserService sharedInstance] setUserProfile:userProfile];
                // 2. Переходим внутрь игры
                [[AppDelegate globalDelegate] initDrawerMenu];
            }
            
            if ([response.status isEqualToString:AUTHORIZATION_ERROR]) {
                // Если ошибка авторизации
                [self performSegueWithIdentifier:@"LoadingToSignIn" sender:self];
            } else {
                // Если непонятная вещь которая здесь не заложена тогда всё равно идем на авторизацию :)
                [self performSegueWithIdentifier:@"LoadingToSignIn" sender:self];
            }
            
        } onFailure:^(NSError *error) {
            //[self showAlertWithTitle:@"Ошибка" andMessage:@"Не удалось получить профиль пользователя. Проверьте соединение с интернетом, закройте и войдите в приложение снова."];
            // Если ошибка, то скорее всего сети нужно показать скрин и передать функцию на перевызов
            [self presentErrorViewControllerWithTryAgainSelector:@selector(checkAuthorization)];
        }];
    } else {
        // Либо первый раз, либо просрочился токен
        [self performSegueWithIdentifier:@"LoadingToSignIn" sender:self];
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
