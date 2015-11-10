//
//  ResponseWrapperModel.h
//  BrainFights
//
//  Created by Artem Demidovich on 11/6/15.
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


@interface ResponseWrapperModel : NSObject

/**
    Статус обработки запроса
        ENUM: ResponseStatus
 */
@property NSString *status;

/*
 * Данные ответа, любой объект может быть
 */
@property NSObject *data;


/**
 * Код ошибки
 */
@property NSString *errorCode;

/**
 * Описание ошибки
 */
@property NSString *errorMessage;

/*
 ResponseStatus:

    * Ошибка авторизации
        AUTHORIZATION_ERROR,

    * Операция успешно выполнена
        SUCCESS,

    * Данные не найдены
        NO_CONTENT,

    * Ошибки в запросе (валидация)
        BAD_REQUEST,

    * Ошибка сервера
        SERVER_ERROR
 */

@end
