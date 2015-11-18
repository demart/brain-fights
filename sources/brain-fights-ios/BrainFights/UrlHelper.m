//
//  UrlHelper.m
//  BrainFights
//
//  Created by Artem Demidovich on 11/7/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import "UrlHelper.h"

#import "AuthorizationService.h"

// Класс хэлпер для ведения URL вызова API
@implementation UrlHelper

+(NSString*) baseUrl {
#if DEBUG
    return @"http://localhost:9000";
    //return @"http://172.20.10.2";
    //return @"http://api.sushimi.kz/rest-api";
#else
        return @"http://172.20.10.2";
    //return @"http://api.sushimi.kz/rest-api";
#endif
}

// URL для авторизации пользователей
+(NSString*) userBaseUrl {
    return [[NSString alloc] initWithFormat:@"%@/user/", UrlHelper.baseUrl];
}

// URL для авторизации пользователей
+(NSString*) userProfileUrl {
    return [[NSString alloc] initWithFormat:@"%@/user/profile?authToken=%@", UrlHelper.baseUrl, [self authToken]];
}

// URL для авторизации пользователей
+(NSString*) userProfileByIdUrl:(NSInteger)userId {
    return [[NSString alloc] initWithFormat:@"%@/user/profile/%li?authToken=%@", UrlHelper.baseUrl, userId, [self authToken]];
}



// URL для получения списка друзей пользователя
+(NSString*) userFriendsUrl {
    return [[NSString alloc] initWithFormat:@"%@/user/friends?authToken=%@", UrlHelper.baseUrl, [self authToken]];
}

// URL для получения добавления друга пользователя
+(NSString*) userAddFriendByIdUrl:(NSInteger)userId {
    return [[NSString alloc] initWithFormat:@"%@/user/friends/add/%li?authToken=%@", UrlHelper.baseUrl, userId, [self authToken]];
}

// URL для получения удаление друга пользователя
+(NSString*) userRemoveFriendByIdUrl:(NSInteger)userId {
    return [[NSString alloc] initWithFormat:@"%@/user/friends/remove/%li?authToken=%@", UrlHelper.baseUrl, userId, [self authToken]];
}


// URL для получения рутовый департаментов
+(NSString*) childrenDepartmentByRootUrl {
     return [[NSString alloc] initWithFormat:@"%@/search/department?authToken=%@", UrlHelper.baseUrl, [self authToken]];
}

// URL для получения детей департамента
+(NSString*) childrenDepartmentByParentIdUrl:(NSInteger)parentId {
     return [[NSString alloc] initWithFormat:@"%@/search/department/%li?authToken=%@", UrlHelper.baseUrl, parentId, [self authToken]];
}


// Базовый URL для API поиска
+(NSString*) searchBaseUrl {
    return [[NSString alloc] initWithFormat:@"%@/search/", UrlHelper.baseUrl];
}

// URL с текстом для поиска пользователей
+(NSString*) searchUsersByTextUrl:(NSString*)searchText {
    return [[NSString alloc] initWithFormat:@"%@/search/user?searchText=%@&authToken=%@", UrlHelper.baseUrl, searchText, [self authToken]];
}


// URL для API регистрации PUSH tokena
+(NSString*) registerDeviceTokenUrl {
    return [[NSString alloc] initWithFormat:@"%@/device/push/register?authToken=%@", UrlHelper.baseUrl, [self authToken]];
}



// Базовый URL для API по игре
+(NSString*) gameBaseUrl {
    return [[NSString alloc] initWithFormat:@"%@/game/", UrlHelper.baseUrl];
}

// URL для запроса списка игр пользователя
+ (NSString*) gamesUrl {
    return [[NSString alloc] initWithFormat:@"%@/game/list?authToken=%@", UrlHelper.baseUrl, [self authToken]];
}

// URL для запроса списка игр сгруппированных пользователя
+ (NSString*) gamesGroupedUrl {
    return [[NSString alloc] initWithFormat:@"%@/game/list/grouped?authToken=%@", UrlHelper.baseUrl, [self authToken]];
}


// URL для отправки приглашения со случайным игроком
+ (NSString*) gameCreateRandomInvitationUrl {
    return [[NSString alloc] initWithFormat:@"%@/game/invitation/create?authToken=%@", UrlHelper.baseUrl, [self authToken]];
}

// URL для отправки приглашения с выбранным игроком
+ (NSString*) gameCreateInvitationByUserId:(NSInteger)userId {
    return [[NSString alloc] initWithFormat:@"%@/game/invitation/create/%li?authToken=%@", UrlHelper.baseUrl, (long)userId, [self authToken]];
}


// URL для принятия приглашения сыграть в игру
+ (NSString*) gameAcceptInvitation:(NSInteger)gameId {
    return [[NSString alloc] initWithFormat:@"%@/game/%li/accept/invitation?authToken=%@", UrlHelper.baseUrl, (long)gameId, [self authToken]];
}

// URL для получения детальной информации об игре
+ (NSString*) gameInformationUrl:(NSInteger)gameId {
    return [[NSString alloc] initWithFormat:@"%@/game/%li?authToken=%@", UrlHelper.baseUrl, (long)gameId, [self authToken]];
}

// URL для создания нового раунда
+ (NSString*) gameCreateRoundUrl:(NSUInteger)gameId withSelectedCategoryId:(NSInteger)categoryId {
    return [[NSString alloc] initWithFormat:@"%@/game/%li/round/generate/%li?authToken=%@", UrlHelper.baseUrl, (long)gameId, (long)categoryId, [self authToken]];
}



+(NSString*) authToken {
    return [AuthorizationService getAuthToken];
}


@end
