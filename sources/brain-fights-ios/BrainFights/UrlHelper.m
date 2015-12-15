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

+ (NSString*) aphionUrl {
    return @"http://aphion.kz?source=transtelecom-brain-fights";
}



+(NSString*) baseUrl {
#if DEBUG
    //return @"http://localhost:8080";
    return @"http://ec2-54-69-182-222.us-west-2.compute.amazonaws.com:8080";
    //return @"http://localhost:9000";
    //return @"http://172.20.10.2:9000";
    //return @"http://192.168.0.94:8080";
    //return @"http://api.sushimi.kz/rest-api";
#else
    return @"http://ec2-54-69-182-222.us-west-2.compute.amazonaws.com:8080";
     //   return @"http://172.20.10.2";
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



// URL для получения рейтинга пользователей
+ (NSString*) usersRating:(NSUInteger)page withLimit:(NSUInteger)limit {
    return [[NSString alloc] initWithFormat:@"%@/stat/users/page/%li/limit/%li?authToken=%@", UrlHelper.baseUrl, page, limit, [self authToken]];
}

// URL для получения типов подразделений
+ (NSString*) departmentTypeUrl {
    return [[NSString alloc] initWithFormat:@"%@/stat/departments/types?authToken=%@", UrlHelper.baseUrl, [self authToken]];
}

// URL для получения рейтинга департаментов
+ (NSString*) departmentsRatingUrl:(NSUInteger)typeId withPage:(NSUInteger)page withLimit:(NSUInteger)limit {
    return [[NSString alloc] initWithFormat:@"%@/stat/departments/type/%li/page/%li/limit/%li?authToken=%@", UrlHelper.baseUrl, typeId, page, limit, [self authToken]];
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

// URL с текстом для поиска пользователей
+(NSString*) searchUsersByTextUrl {
    return [[NSString alloc] initWithFormat:@"%@/search/user?authToken=%@", UrlHelper.baseUrl, [self authToken]];
}


// URL для API регистрации PUSH tokena
+(NSString*) registerDeviceTokenUrl {
    return [[NSString alloc] initWithFormat:@"%@/device/push/register?authToken=%@", UrlHelper.baseUrl, [self authToken]];
}



// Базовый URL для картинок по вопросам
+(NSString*) imageUrlForQuestionWithPath:(NSString*) questionImagePath {
    if (questionImagePath == nil)
        return nil;
    if ([questionImagePath hasPrefix:@"/"]) {
        return [[NSString alloc] initWithFormat:@"%@%@", UrlHelper.baseUrl, questionImagePath];
    } else {
        return [[NSString alloc] initWithFormat:@"%@/%@", UrlHelper.baseUrl, questionImagePath];
    }
}

// Базовый URL для картинок по категориям
+(NSString*) imageUrlForCategoryWithPath:(NSString*) categoryImagePath {
    if (categoryImagePath == nil)
        return nil;
    if ([categoryImagePath hasPrefix:@"/"]) {
        return [[NSString alloc] initWithFormat:@"%@%@", UrlHelper.baseUrl, categoryImagePath];
    } else {
        return [[NSString alloc] initWithFormat:@"%@/%@", UrlHelper.baseUrl, categoryImagePath];
    }
}

// Базовый URL для картинок авотаров
+(NSString*) imageUrlForAvatarWithPath:(NSString*) avatarImagePath {
    if (avatarImagePath == nil)
        return nil;
    if ([avatarImagePath hasPrefix:@"/"]) {
        return [[NSString alloc] initWithFormat:@"%@%@", UrlHelper.baseUrl, avatarImagePath];
    } else {
        return [[NSString alloc] initWithFormat:@"%@/%@", UrlHelper.baseUrl, avatarImagePath];
    }
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
+ (NSString*) gameCreateInvitationByUserIdUrl:(NSInteger)userId {
    return [[NSString alloc] initWithFormat:@"%@/game/invitation/create/%li?authToken=%@", UrlHelper.baseUrl, (long)userId, [self authToken]];
}


// URL для принятия приглашения сыграть в игру
+ (NSString*) gameAcceptInvitationUrl:(NSInteger)gameId withResult:(BOOL)result {
    if (result) {
        return [[NSString alloc] initWithFormat:@"%@/game/%li/accept/invitation/true?authToken=%@", UrlHelper.baseUrl, (long)gameId, [self authToken]];
    } else {
         return [[NSString alloc] initWithFormat:@"%@/game/%li/accept/invitation/false?authToken=%@", UrlHelper.baseUrl, (long)gameId, [self authToken]];
    }
}

// URL для получения детальной информации об игре
+ (NSString*) gameInformationUrl:(NSInteger)gameId {
    return [[NSString alloc] initWithFormat:@"%@/game/%li?authToken=%@", UrlHelper.baseUrl, (long)gameId, [self authToken]];
}

// URL для создания нового раунда
+ (NSString*) gameCreateRoundUrl:(NSUInteger)gameId withSelectedCategoryId:(NSInteger)categoryId {
    return [[NSString alloc] initWithFormat:@"%@/game/%li/round/generate/%li?authToken=%@", UrlHelper.baseUrl, (long)gameId, (long)categoryId, [self authToken]];
}


// URL для получения списка вопросов для указанного раунда
+ (NSString*) gameRoundQuestionsUrl:(NSUInteger)gameId withRoundId:(NSUInteger) roundId {
    return [[NSString alloc] initWithFormat:@"%@/game/%li/round/%li/questions?authToken=%@", UrlHelper.baseUrl, (long)gameId, (long)roundId, [self authToken]];
}

// URL для получения списка вопросов для указанного раунда
+ (NSString*) gameAnswerOnQuestion:(NSUInteger)gameId withRoundId:(NSUInteger) roundId withQuestionId:(NSUInteger)questionId withAnswerId:(NSUInteger)answerId {
    return [[NSString alloc] initWithFormat:@"%@/game/%li/round/%li/questions/%li/answer/%li?authToken=%@", UrlHelper.baseUrl, gameId, roundId, questionId, answerId,  [self authToken]];
}

// URL для того чтобы сдаться в игре
+ (NSString*) gameSurrenderUrl:(NSUInteger)gameId {
    return [[NSString alloc] initWithFormat:@"%@/game/%li/surrender?authToken=%@", UrlHelper.baseUrl, (long)gameId, [self authToken]];
}

// URL для отметки о прочтении
+ (NSString*) gameMarkAsViewed:(NSUInteger)gameId onGamer:(NSUInteger)gamerId {
    return [[NSString alloc] initWithFormat:@"%@/game/%li/gamer/%li/mark/as/viewed?authToken=%@", UrlHelper.baseUrl, gameId, gamerId, [self authToken]];
}

+(NSString*) authToken {
    return [AuthorizationService getAuthToken];
}


@end
