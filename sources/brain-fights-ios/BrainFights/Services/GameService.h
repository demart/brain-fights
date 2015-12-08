//
//  GameService.h
//  BrainFights
//
//  Created by Artem Demidovich on 11/8/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ResponseWrapperModel.h"

@interface GameService : NSObject


// получить список игр пользователя
+ (void) retrieveGames:(void (^)(ResponseWrapperModel *response))success onFailure:(void (^)(NSError *error))failure;


// получить список игр пользователя
+ (void) retrieveGamesGrouped:(void (^)(ResponseWrapperModel *response))success onFailure:(void (^)(NSError *error))failure;


// отправить приглашение на игру (если userID не указан, значит рандомная игра)
+ (void) createGameInvitation:(NSInteger)userId onSuccess:(void (^)(ResponseWrapperModel *response))success onFailure:(void (^)(NSError *error))failure;

// принять приглашения сыграть
+ (void) acceptGameInvitation:(NSInteger)gameId onSuccess:(void (^)(ResponseWrapperModel *response))success onFailure:(void (^)(NSError *error))failure withResult:(BOOL)result;


// Получаем детальную информацию по игре
+ (void) retrieveGameInformation:(NSInteger)gameId onSuccess:(void (^)(ResponseWrapperModel *response))success onFailure:(void (^)(NSError *error))failure;


// Создает новый раунд для игроков
+ (void) genereateGameRound:(NSUInteger)gameId withSelectedCategory:(NSInteger)categoryId  onSuccess:(void (^)(ResponseWrapperModel *response))success onFailure:(void (^)(NSError *error))failure;

// Возвращает список вопросов к раунду
+ (void) getRoundQuestions:(NSUInteger)gameId withRound:(NSUInteger)roundId onSuccess:(void (^)(ResponseWrapperModel *response))success onFailure:(void (^)(NSError *error))failure;

// Отправляет ответ на вопрос на сервер
+ (void) answerOnQuestion:(NSUInteger)gameId withRound:(NSUInteger)roundId withQuestionId:(NSUInteger)questionId withAnswer:(NSUInteger)answerId onSuccess:(void (^)(ResponseWrapperModel *response))success onFailure:(void (^)(NSError *error))failure;

// Сдаться в указанной игре
+ (void) surrenderGame:(NSUInteger) gameId onSuccess:(void (^)(ResponseWrapperModel *response))success onFailure:(void (^)(NSError *error))failure;

// Пометить запись как прочитанную
+ (void) markAsViewed:(NSUInteger) gameId andGamer:(NSUInteger)gamerId onSuccess:(void (^)(ResponseWrapperModel *response))success onFailure:(void (^)(NSError *error))failure;

@end
