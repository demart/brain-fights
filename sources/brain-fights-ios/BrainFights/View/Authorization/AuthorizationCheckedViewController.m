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
    sleep(2);
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
            // Если ошибка, то скорее всего сети нужно показать скрин и передать функцию на перевызов
            
        }];
         } else {
        // Либо первый раз, либо просрочился токен
        [self performSegueWithIdentifier:@"LoadingToSignIn" sender:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
