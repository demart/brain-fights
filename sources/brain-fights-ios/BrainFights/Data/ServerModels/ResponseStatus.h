//
//  ResponseStatus.h
//  BrainFights
//
//  Created by Artem Demidovich on 11/7/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Ошибка авторизации
 */
static NSString* AUTHORIZATION_ERROR = @"AUTHORIZATION_ERROR";
/**
 * Операция успешно выполнена
 */
static NSString* SUCCESS = @"SUCCESS";

/**
 * Данные не найдены
 */
static NSString* NO_CONTENT = @"NO_CONTENT";

/**
 * Ошибки в запросе (валидация)
 */
static NSString* BAD_REQUEST = @"BAD_REQUEST";

/**
 * Ошибка сервера
 */
static NSString* SERVER_ERROR = @"SERVER_ERROR";


@interface ResponseStatus : NSObject

@end
