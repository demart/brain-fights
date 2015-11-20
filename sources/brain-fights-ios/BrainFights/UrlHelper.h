//
//  UrlHelper.h
//  BrainFights
//
//  Created by Artem Demidovich on 11/7/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UrlHelper : NSObject

+(NSString*) baseUrl;

// URL для авторизации пользователей
+(NSString*) userBaseUrl;


// URL для авторизации пользователей
+(NSString*) userProfileUrl;

// URL для авторизации пользователей
+(NSString*) userProfileByIdUrl:(NSInteger)userId;


// URL для получения списка друзей пользователя
+(NSString*) userFriendsUrl;

// URL для получения добавления друга пользователя
+(NSString*) userAddFriendByIdUrl:(NSInteger)userId;

// URL для получения удаление друга пользователя
+(NSString*) userRemoveFriendByIdUrl:(NSInteger)userId;



// URL для получения рутовый департаментов
+(NSString*) childrenDepartmentByRootUrl;

// URL для получения детей департамента
+(NSString*) childrenDepartmentByParentIdUrl:(NSInteger)parentId;

// Базовый URL для API поиска
+(NSString*) searchBaseUrl;

// URL с текстом для поиска пользователей
+(NSString*) searchUsersByTextUrl:(NSString*)searchText;

// URL для API регистрации PUSH tokena
+(NSString*) registerDeviceTokenUrl;





// URL для запроса списка игр пользователя
+ (NSString*) gamesUrl;

// URL для запроса списка игр сгруппированных пользователя
+ (NSString*) gamesGroupedUrl;

// URL для отправки приглашения со случайным игроком
+ (NSString*) gameCreateRandomInvitationUrl;

// URL для отправки приглашения с выбранным игроком
+ (NSString*) gameCreateInvitationByUserIdUrl:(NSInteger)userId;

// URL для принятия приглашения сыграть в игру
+ (NSString*) gameAcceptInvitationUrl:(NSInteger)gameId;

// URL для получения детальной информации об игре
+ (NSString*) gameInformationUrl:(NSInteger)gameId;

// URL для создания нового раунда
+ (NSString*) gameCreateRoundUrl:(NSUInteger)gameId withSelectedCategoryId:(NSInteger)categoryId;

// URL для получения списка вопросов для указанного раунда
+ (NSString*) gameRoundQuestionsUrl:(NSUInteger)gameId withRoundId:(NSUInteger) roundId;

// URL для получения списка вопросов для указанного раунда
+ (NSString*) gameAnswerOnQuestion:(NSUInteger)gameId withRoundId:(NSUInteger) roundId withQuestionId:(NSUInteger)questionId withAnswerId:(NSUInteger)answerId;

// URL для того чтобы сдаться в игре
+ (NSString*) gameSurrenderUrl:(NSUInteger)gameId;

// Базовый URL для API по игре
+ (NSString*) gameBaseUrl;


@end
