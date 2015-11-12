//
//  AuthorizationService.h
//  BrainFights
//
//  Created by Artem Demidovich on 11/6/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AuthorizationRequestModel.h"
#import "ResponseWrapperModel.h"

@interface AuthorizationService : NSObject

// Если ли токен авторизации
+ (BOOL) isAuthTokenExisit;

// Возвращает токен авторизации
+ (NSString*) getAuthToken;


// авторизация пользователя по логин и паролю
+ (void) authorizeUserAsync:(NSString*)login withPassword:(NSString*)password onSuccess:(void (^)(ResponseWrapperModel *response))success onFailure:(void (^)(NSError *error))failure;

// загружает профиль пользователя по указанному токену авторизации
+ (void) retrieveUserProfileAsync:(void (^)(ResponseWrapperModel *response))success onFailure:(void (^)(NSError *error))failure;

@end
