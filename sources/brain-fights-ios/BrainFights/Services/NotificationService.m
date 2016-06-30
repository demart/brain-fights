//
//  NotificationService.m
//  BrainFights
//
//  Created by Artem Demidovich on 11/21/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import "NotificationService.h"
#import "../../LNNotificationsUI/LNNotificationsUI/LNNotificationsUI.h"


@implementation NotificationService

+ (void) registerForRemoteNotification {
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

+ (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"PUSH: registered in APNS with deviceToken: %@", deviceToken);
    
    NSString *oldTokenValue = (NSString*)[LocalStorageService getSettingsValueByKey:SYSTEM_DEVICE_TOKEN];
    NSString *newTokenValue = [deviceToken description] ;

    // Сохраняем новый токен
    [LocalStorageService setSettingsKey:SYSTEM_DEVICE_TOKEN withObject:newTokenValue];
    [self registerOrUpdateModel:newTokenValue withOldToken:oldTokenValue];
    /*
    if (![newTokenValue isEqualToString:oldTokenValue]) {
        // Отправляем данные на сервер
        [self registerOrUpdateModel:newTokenValue withOldToken:oldTokenValue];
    } else {
        // Убедимся что данные в прошлый раз успешно отпраивли на сервер
        NSString* isSync = (NSString*)[LocalStorageService getSettingsValueByKey:SYSTEM_DEVICE_TOKEN_SYNCHRONIZED];
        NSString* oldTokenValue = (NSString*)[LocalStorageService getSettingsValueByKey:SYSTEM_DEVICE_TOKEN_OLD];
        if (![isSync isEqualToString:@"YES"]) {
            [self registerOrUpdateModel:newTokenValue withOldToken:oldTokenValue];
        }
    }*/
}


+ (void) registerOrUpdateModel:(NSString*)newTokenValue withOldToken:(NSString*)oldTokenValue {
    [[UserService sharedInstance]registerOrUpdateDeviceToken:newTokenValue invalidateDeviceToken:oldTokenValue onSuccess:^(ResponseWrapperModel *response) {
        if ([response.status isEqualToString:SUCCESS]) {
            // Успешно отправили данные на сервер
            [LocalStorageService setSettingsKey:SYSTEM_DEVICE_TOKEN_SYNCHRONIZED withObject:@"YES"];
            [LocalStorageService setSettingsKey:SYSTEM_DEVICE_TOKEN_OLD withObject:nil];
        } else {
            // Не удалось отправить данные на сервер :(
            [LocalStorageService setSettingsKey:SYSTEM_DEVICE_TOKEN_SYNCHRONIZED withObject:@"NO"];
            
            if (oldTokenValue != nil) {
                // Если был старый токен, что означает замену токена, то сохраним его чтобы попробовать потом
                [LocalStorageService setSettingsKey:SYSTEM_DEVICE_TOKEN_OLD withObject:oldTokenValue];
            } else {
                // Если нету старого токена значит это первый раз регистрация
                [LocalStorageService setSettingsKey:SYSTEM_DEVICE_TOKEN_OLD withObject:nil];
            }
        }
    } onFailure:^(NSError *error) {
        if (oldTokenValue != nil) {
            // Если был старый токен, что означает замену токена, то сохраним его чтобы попробовать потом
            [LocalStorageService setSettingsKey:SYSTEM_DEVICE_TOKEN_OLD withObject:oldTokenValue];
        } else {
            // Если нету старого токена значит это первый раз регистрация
            [LocalStorageService setSettingsKey:SYSTEM_DEVICE_TOKEN_OLD withObject:nil];
        }
    }];
}


+ (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"PUSH: error during regisntration in APNS, error: %@", error);
}

+ (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    NSLog(@"PUSH: supported notificaiton settings: %@", notificationSettings);
    // Посмотреть что поддерживается пользователем
}

+ (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))handler {
    NSLog(@"PUSH: receive push: %@", userInfo);
    
    // Проверить что работает только при выключенном приложении
    if (application.applicationState == UIApplicationStateActive) {
        // Получаем когда приложение запущено и пользователь его видит
        NSLog(@"PUSH: application state: %@", @"Active");

        NSDictionary *aps = (NSDictionary*)[userInfo valueForKey:@"aps"];
        NSString *alert = [aps valueForKey:@"alert"];

        LNNotification* notification = [LNNotification notificationWithMessage:alert];
        notification.title = @"Уведомление";
        notification.date = [[NSDate date] dateByAddingTimeInterval:-60 * 24];
        
        notification.defaultAction = [LNNotificationAction actionWithTitle:@"View" handler:^(LNNotificationAction *action) {
            [[AppDelegate globalDelegate] gameMainViewController];
            // TODO сделать обновление списка игр, так как будет переход но всё будет старое
        }];
        
        [[LNNotificationCenter defaultCenter] presentNotification:notification forApplicationIdentifier:@"games"];
        
        // Сбрасываем счетчик так как приложение запущено
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        
        handler(UIBackgroundFetchResultNoData);
    }
    
    if (application.applicationState == UIApplicationStateInactive) {
        // Получаем когда приложение запущено но пользователь свернул его
        NSLog(@"PUSH: application state: %@", @"Inactive");
        //[[UIApplication sharedApplication] setApplicationIconBadgeNumber:[UIApplication sharedApplication].applicationIconBadgeNumber + 1];
        handler(UIBackgroundFetchResultNoData);
    }
    
    if (application.applicationState == UIApplicationStateBackground) {
        // Получаем когда приложение закрыто
        NSLog(@"PUSH: application state: %@", @"Background");
        //[[UIApplication sharedApplication] setApplicationIconBadgeNumber:[UIApplication sharedApplication].applicationIconBadgeNumber + 1];
        
        handler(UIBackgroundFetchResultNoData);
    }
    
}

+ (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"PUSH: receive push and app is running: %@", userInfo);
    // Проверить что работает только при включенном приложении
    if (application.applicationState == UIApplicationStateInactive) {
    }
}

@end
