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
+ (void) acceptGameInvitation:(NSInteger)gameId onSuccess:(void (^)(ResponseWrapperModel *response))success onFailure:(void (^)(NSError *error))failure;


@end
