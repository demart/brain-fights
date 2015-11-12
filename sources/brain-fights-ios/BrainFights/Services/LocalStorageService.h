//
//  LocalStorageService.h
//  BrainFights
//
//  Created by Artem Demidovich on 11/7/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <Foundation/Foundation.h>

// Ключ для хранения токена авторизации
static NSString* AUTH_TOKEN = @"settings.auth.token";

// Ключ для хранения логина пользователя
static NSString* AUTH_LOGIN = @"settings.auth.login";

// Ключ для хранения токена для получения PUSH
static NSString* PUSH_TOKEN = @"settings.push.token";


@interface LocalStorageService : NSObject

// Сохраняет параметр в локальных настройках приложениния
+(void) setSettingsKey:(NSString*)key withObject:(NSObject*) value;

// Возвращает сохраненное значение в локальных настройках приложения
+(NSObject*) getSettingsValueByKey:(NSString*)key;

@end
