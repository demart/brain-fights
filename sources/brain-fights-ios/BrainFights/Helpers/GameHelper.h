//
//  GameHelper.h
//  BrainFights
//
//  Created by Artem Demidovich on 11/8/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RKObjectManager.h"
#import "RKObjectMapping.h"
#import "RKResponseDescriptor.h"
#import "RKObjectRequestOperation.h"
#import "RKRelationshipMapping.h"
#import "RKRequestDescriptor.h"
#import "RKLog.h"
#import "RKMIMETypes.h"

@interface GameHelper : NSObject

// Строит модель для получения списка игр пользователя
+ (RKResponseDescriptor*) buildResponseDescriptorForGames;

// Строит модель для получения списка игр пользователя
+ (RKResponseDescriptor*) buildResponseDescriptorForGamesGroups;

// Строит маппинг для результата отправки приглашения пользователю
+ (RKResponseDescriptor*) buildResponseDescriptorForCreateInvitation;

// Строит маппинг для результата отправки приглашения пользователю
+ (RKResponseDescriptor*) buildResponseDescriptorForAcceptInvitation;

// Строит маппинг для получения деталей по игре
+ (RKResponseDescriptor*) buildResponseDescriptorForGameInformation;

// Строит маппинг для получения ответа с вопросами на запрос создания нового раунда
+ (RKResponseDescriptor*) buildResponseDescriptorForCreatedGameRound;

// Строит маппинг для получения списка вопросов в раунде
+ (RKResponseDescriptor*)  buildResponseDescriptorForGameRoundQuestions;

// Строит маппинг для получения списка вопросов в раунде
+ (RKResponseDescriptor*)  buildResponseDescriptorForGameAnswerOnQuestion;

// Строит маппинг для получения ответа на запрос "Сдаться"
+ (RKResponseDescriptor*) buildResponseDescriptorForGameSurrender;

// Строит маппинг для получения ответа на запрос отметки о прочтении
+ (RKResponseDescriptor*) buildResponseDescriptorForGameMarkAsViewed;

@end
