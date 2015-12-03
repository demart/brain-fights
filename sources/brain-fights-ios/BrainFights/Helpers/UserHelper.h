//
//  UserHelper.h
//  BrainFights
//
//  Created by Artem Demidovich on 11/9/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UrlHelper.h"

#import "RKObjectManager.h"
#import "RKObjectMapping.h"
#import "RKResponseDescriptor.h"
#import "RKObjectRequestOperation.h"
#import "RKRelationshipMapping.h"
#import "RKRequestDescriptor.h"
#import "RKLog.h"
#import "RKMIMETypes.h"

@interface UserHelper : NSObject

// Строит маппинг для профиля пользователя
+ (RKResponseDescriptor*) buildResponseDescriptorForUserProfile;

// Строит маппинг для получения списка друзей
+ (RKResponseDescriptor*) buildResponseDescriptorForFriends;

// Строит маппинг для добавления друга
+ (RKResponseDescriptor*) buildResponseDescriptorForAddFriend;

// Строит маппинг для уделяния друга
+ (RKResponseDescriptor*) buildResponseDescriptorForRemoveFriend;

//  Строит маппинг для просмотра организационной структуры
+ (RKResponseDescriptor*) buildResponseDescriptorForDepartments;

//  Строит маппинг для поиска пользователей по имени
+ (RKResponseDescriptor*) buildResponseDescriptorForSearchUsers;

//  Строит маппинг для получения рейтинга пользователей
+ (RKResponseDescriptor*) buildResponseDescriptorForUsersRating;

//  Строит маппинг для получения ответа о регистрации PUSH токена
+ (RKObjectManager*) buildObjectManagerForRegisterOrUpdateDeviceToken;

//  Строит маппинг для поиска пользователей
+ (RKObjectManager*) buildObjectManagerForSearchUsers;

@end
