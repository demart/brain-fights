//
//  UserService.h
//  BrainFights
//
//  Created by Artem Demidovich on 11/7/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DevicePushTokenRegisterModel.h"
#import "UserProfileModel.h"
#import "DepartmentSearchResultModel.h"
#import "DepartmentModel.h"
#import "ResponseWrapperModel.h"

@interface UserService : NSObject

+(UserService*) sharedInstance;

// Получать профиль пользователя
// Обновлять данные профиля пользователя
// Предоставлять данные профиля

// Выставляет профиль пользователя
- (void) setUserProfile:(UserProfileModel*) profile;

// Выставляет профиль пользователя
- (UserProfileModel*) getUserProfile;

// Загружает профиль любого пользователя асинхронно
- (void) retrieveUserProfileByIdAsync:(NSInteger)userId onSuccess:(void (^)(ResponseWrapperModel *response))success onFailure:(void (^)(NSError *error))failure;

// Загружает список друзей
- (void) retrieveUserFriendsAsync:(void (^)(ResponseWrapperModel *response))success onFailure:(void (^)(NSError *error))failure;

// Добавляем друга
- (void) addUserFriendAsync:(NSInteger)userId onSuccess:(void (^)(ResponseWrapperModel *response))success onFailure:(void (^)(NSError *error))failure;

// Добавляем друга
- (void) removeUserFriendAsync:(NSInteger)userId onSuccess:(void (^)(ResponseWrapperModel *response))success onFailure:(void (^)(NSError *error))failure;

// Загружает список организационной структуры
- (void) searchDepartments:(NSInteger)parentId onSuccess:(void (^)(ResponseWrapperModel *response))success onFailure:(void (^)(NSError *error))failure;

// Загружает список организационной структуры
- (void) searchUsersByTextAsync:(NSString*)searchText onSuccess:(void (^)(ResponseWrapperModel *response))success onFailure:(void (^)(NSError *error))failure;

// Возращает постранично рейтинг пользователей
- (void) retrieveUsersRating:(NSInteger)page withLimit:(NSInteger)limit onSuccess:(void (^)(ResponseWrapperModel *response))success onFailure:(void (^)(NSError *error))failure;

// Возращает список типов подразделений
- (void) retrieveDepartmentTyps:(void (^)(ResponseWrapperModel *response))success onFailure:(void (^)(NSError *error))failure;

// Возращает постранично департаменты
- (void) retrieveDepartmentsRating:(NSInteger)type withPage:(NSInteger)page withLimit:(NSInteger)limit onSuccess:(void (^)(ResponseWrapperModel *response))success onFailure:(void (^)(NSError *error))failure;



// Отправляет на сервер новый PUSH токен
-(void) registerOrUpdateDeviceToken:(NSString*)deviceToken invalidateDeviceToken:(NSString*)invalidDeviceToken   onSuccess:(void (^)(ResponseWrapperModel *response))success onFailure:(void (^)(NSError *error))failure;

@end
