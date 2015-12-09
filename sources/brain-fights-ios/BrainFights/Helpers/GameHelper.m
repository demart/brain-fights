//
//  GameHelper.m
//  BrainFights
//
//  Created by Artem Demidovich on 11/8/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import "GameHelper.h"

#import "UserProfileModel.h"
#import "DepartmentModel.h"

#import "UserGamesGroupedModel.h"
#import "UserGameGroupModel.h"
#import "UserGamesModel.h"
#import "UserGameModel.h"
#import "GamerModel.h"
#import "GamerQuestionAnswerResultModel.h"

#import "GameModel.h"

#import "ResponseWrapperModel.h"

@implementation GameHelper


// Строит модель для запросов профиля авторизованного пользователя
+ (RKResponseDescriptor*) buildResponseDescriptorForGames {
    RKObjectMapping* departmentModel = [RKObjectMapping mappingForClass:[DepartmentModel class]];
    [departmentModel addAttributeMappingsFromDictionary:@{
                                                          @"id": @"id",
                                                          @"name": @"name",
                                                          @"userCount": @"userCount",
                                                          @"score": @"score",
                                                          @"haveChildren": @"haveChildren",
                                                          @"isUserBelongs": @"isUserBelongs",
                                                          }];
    
    [departmentModel addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"parent"
                                                                                    toKeyPath:@"parent"
                                                                                  withMapping:departmentModel]];
    [departmentModel addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"children"
                                                                                    toKeyPath:@"children"
                                                                                  withMapping:departmentModel]];
    
    RKObjectMapping* userProfileModel = [RKObjectMapping mappingForClass:[UserProfileModel class]];
    [userProfileModel addAttributeMappingsFromDictionary:@{
                                                           @"id": @"id",
                                                           @"type": @"type",
                                                           @"name": @"name",
                                                           @"position": @"position",
                                                           @"login": @"login",
                                                           @"email": @"email",
                                                           @"totalGames": @"totalGames",
                                                           @"wonGames": @"wonGames",
                                                           @"loosingGames": @"loosingGames",
                                                           @"drawnGames": @"drawnGames",
                                                           @"score": @"score",
                                                           @"gamePosition": @"gamePosition",
                                                           @"imageUrl":@"imageUrl",
                                                           @"lastTotalGames":@"lastTotalGames",
                                                           @"lastWonGames":@"lastWonGames",
                                                           @"lastLoosingGames":@"lastLoosingGames",
                                                           @"lastDrawnGames":@"lastDrawnGames",
                                                           @"lastScore":@"lastScore",
                                                           @"lastGamePosition":@"lastGamePosition",
                                                           @"lastStatisticsUpdate":@"lastStatisticsUpdate",
                                                           }];
    
    [userProfileModel addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"department"
                                                                                     toKeyPath:@"department"
                                                                                   withMapping:departmentModel]];
    
    
    RKObjectMapping* gamerModel = [RKObjectMapping mappingForClass:[GamerModel class]];
    [gamerModel addAttributeMappingsFromDictionary:@{
                                                        @"id": @"id",
                                                        @"status": @"status",
                                                        @"lastUpdateStatusDate": @"lastUpdateStatusDate",
                                                        @"correctAnswerCount": @"correctAnswerCount",
                                                        @"resultScore": @"resultScore",
                                                        @"resultWasViewed": @"resultWasViewed",
                                                        }];
    
    // USER
    [gamerModel addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"user"
                                                                                  toKeyPath:@"user"
                                                                                withMapping:userProfileModel]];
    
    RKObjectMapping* userGameModel = [RKObjectMapping mappingForClass:[UserGameModel class]];
    [userGameModel addAttributeMappingsFromDictionary:@{
                                                           @"id": @"id",
                                                           @"gameStatus": @"gameStatus",
                                                           @"gamerStatus": @"gamerStatus",
                                                           }];
    
    // me
    [userGameModel addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"me"
                                                                                   toKeyPath:@"me"
                                                                                 withMapping:gamerModel]];
    
    // oponent
    [userGameModel addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"oponent"
                                                                                  toKeyPath:@"opoenent"
                                                                                withMapping:gamerModel]];
    
    
    RKObjectMapping* userGamesModel = [RKObjectMapping mappingForClass:[UserGamesModel class]];
    [userGamesModel addAttributeMappingsFromDictionary:@{}];
    [userGamesModel addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"user"
                                                                                   toKeyPath:@"user"
                                                                                 withMapping:userProfileModel]];
    [userGamesModel addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"games"
                                                                                     toKeyPath:@"games"
                                                                                   withMapping:userGameModel]];
    
    RKObjectMapping* wrapperMapping = [RKObjectMapping mappingForClass:[ResponseWrapperModel class]];
    [wrapperMapping addAttributeMappingsFromDictionary:@{
                                                         @"status": @"status",
                                                         @"errorCode": @"errorCode",
                                                         @"errorMessage": @"errorMessage"
                                                         }];
    
    [wrapperMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"data"
                                                                                   toKeyPath:@"data"
                                                                                 withMapping:userGamesModel]];
    
    RKResponseDescriptor *responseWrapperDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:wrapperMapping method:RKRequestMethodAny pathPattern:nil keyPath:@"" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful) ];
    
    return responseWrapperDescriptor;
}


// Строит модель для получения списка игр пользователя
+ (RKResponseDescriptor*) buildResponseDescriptorForGamesGroups {
    RKObjectMapping* departmentModel = [RKObjectMapping mappingForClass:[DepartmentModel class]];
    [departmentModel addAttributeMappingsFromDictionary:@{
                                                          @"id": @"id",
                                                          @"name": @"name",
                                                          @"userCount": @"userCount",
                                                          @"score": @"score",
                                                          @"haveChildren": @"haveChildren",
                                                          @"isUserBelongs": @"isUserBelongs",
                                                          }];
    
    [departmentModel addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"parent"
                                                                                    toKeyPath:@"parent"
                                                                                  withMapping:departmentModel]];
    [departmentModel addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"children"
                                                                                    toKeyPath:@"children"
                                                                                  withMapping:departmentModel]];
    
    RKObjectMapping* userProfileModel = [RKObjectMapping mappingForClass:[UserProfileModel class]];
    [userProfileModel addAttributeMappingsFromDictionary:@{
                                                           @"id": @"id",
                                                           @"type": @"type",
                                                           @"name": @"name",
                                                           @"position": @"position",
                                                           @"login": @"login",
                                                           @"email": @"email",
                                                           @"totalGames": @"totalGames",
                                                           @"wonGames": @"wonGames",
                                                           @"loosingGames": @"loosingGames",
                                                           @"drawnGames": @"drawnGames",
                                                           @"score": @"score",
                                                           @"gamePosition": @"gamePosition",
                                                           @"playStatus": @"playStatus",
                                                           @"imageUrl": @"imageUrl",
                                                           @"lastTotalGames":@"lastTotalGames",
                                                           @"lastWonGames":@"lastWonGames",
                                                           @"lastLoosingGames":@"lastLoosingGames",
                                                           @"lastDrawnGames":@"lastDrawnGames",
                                                           @"lastScore":@"lastScore",
                                                           @"lastGamePosition":@"lastGamePosition",
                                                           @"lastStatisticsUpdate":@"lastStatisticsUpdate",
                                                           }];
    
    [userProfileModel addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"department"
                                                                                     toKeyPath:@"department"
                                                                                   withMapping:departmentModel]];
    
    
    RKObjectMapping* gamerModel = [RKObjectMapping mappingForClass:[GamerModel class]];
    [gamerModel addAttributeMappingsFromDictionary:@{
                                                     @"id": @"id",
                                                     @"status": @"status",
                                                     @"lastUpdateStatusDate": @"lastUpdateStatusDate",
                                                     @"correctAnswerCount": @"correctAnswerCount",
                                                     @"resultScore": @"resultScore",
                                                     @"resultWasViewed": @"resultWasViewed",
                                                     }];
    
    // USER
    [gamerModel addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"user"
                                                                               toKeyPath:@"user"
                                                                             withMapping:userProfileModel]];
    
    RKObjectMapping* userGameModel = [RKObjectMapping mappingForClass:[UserGameModel class]];
    [userGameModel addAttributeMappingsFromDictionary:@{
                                                        @"id": @"id",
                                                        @"gameStatus": @"gameStatus",
                                                        @"gamerStatus": @"gamerStatus",
                                                        }];
    
    // me
    [userGameModel addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"me"
                                                                                  toKeyPath:@"me"
                                                                                withMapping:gamerModel]];
    
    // oponent
    [userGameModel addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"oponent"
                                                                                  toKeyPath:@"oponent"
                                                                                withMapping:gamerModel]];
    
    
    RKObjectMapping* userGameGroupModel = [RKObjectMapping mappingForClass:[UserGameGroupModel class]];
    [userGameGroupModel addAttributeMappingsFromDictionary:@{
                                                        @"status": @"status",
                                                        }];
    [userGameGroupModel addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"games"
                                                                                   toKeyPath:@"games"
                                                                                 withMapping:userGameModel]];
    
    
    
    RKObjectMapping* userGamesGroupModel = [RKObjectMapping mappingForClass:[UserGamesGroupedModel class]];
    [userGamesGroupModel addAttributeMappingsFromDictionary:@{}];
    [userGamesGroupModel addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"user"
                                                                                   toKeyPath:@"user"
                                                                                 withMapping:userProfileModel]];
    [userGamesGroupModel addPropertyMapping:[RKRelationshipMapping
                                                                relationshipMappingFromKeyPath:@"gameGroups"
                                                                toKeyPath:@"gameGroups"
                                                                withMapping:userGameGroupModel]];
    
    RKObjectMapping* wrapperMapping = [RKObjectMapping mappingForClass:[ResponseWrapperModel class]];
    [wrapperMapping addAttributeMappingsFromDictionary:@{
                                                         @"status": @"status",
                                                         @"errorCode": @"errorCode",
                                                         @"errorMessage": @"errorMessage"
                                                         }];
    
    [wrapperMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"data"
                                                                                   toKeyPath:@"data"
                                                                                 withMapping:userGamesGroupModel]];
    
    RKResponseDescriptor *responseWrapperDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:wrapperMapping method:RKRequestMethodAny pathPattern:nil keyPath:@"" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful) ];
    
    return responseWrapperDescriptor;
}

// Строит маппинг для результата отправки приглашения пользователю
+ (RKResponseDescriptor*) buildResponseDescriptorForCreateInvitation {
    RKObjectMapping* departmentModel = [RKObjectMapping mappingForClass:[DepartmentModel class]];
    [departmentModel addAttributeMappingsFromDictionary:@{
                                                          @"id": @"id",
                                                          @"name": @"name",
                                                          @"userCount": @"userCount",
                                                          @"score": @"score",
                                                          @"haveChildren": @"haveChildren",
                                                          @"isUserBelongs": @"isUserBelongs",
                                                          }];
    
    [departmentModel addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"parent"
                                                                                    toKeyPath:@"parent"
                                                                                  withMapping:departmentModel]];
    [departmentModel addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"children"
                                                                                    toKeyPath:@"children"
                                                                                  withMapping:departmentModel]];
    
    RKObjectMapping* userProfileModel = [RKObjectMapping mappingForClass:[UserProfileModel class]];
    [userProfileModel addAttributeMappingsFromDictionary:@{
                                                           @"id": @"id",
                                                           @"type": @"type",
                                                           @"name": @"name",
                                                           @"position": @"position",
                                                           @"login": @"login",
                                                           @"email": @"email",
                                                           @"totalGames": @"totalGames",
                                                           @"wonGames": @"wonGames",
                                                           @"loosingGames": @"loosingGames",
                                                           @"drawnGames": @"drawnGames",
                                                           @"score": @"score",
                                                           @"gamePosition": @"gamePosition",
                                                           @"playStatus": @"playStatus",
                                                           @"imageUrl": @"imageUrl",
                                                           @"lastTotalGames":@"lastTotalGames",
                                                           @"lastWonGames":@"lastWonGames",
                                                           @"lastLoosingGames":@"lastLoosingGames",
                                                           @"lastDrawnGames":@"lastDrawnGames",
                                                           @"lastScore":@"lastScore",
                                                           @"lastGamePosition":@"lastGamePosition",
                                                           @"lastStatisticsUpdate":@"lastStatisticsUpdate",
                                                           }];
    
    [userProfileModel addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"department"
                                                                                     toKeyPath:@"department"
                                                                                   withMapping:departmentModel]];
    
    
    RKObjectMapping* gamerModel = [RKObjectMapping mappingForClass:[GamerModel class]];
    [gamerModel addAttributeMappingsFromDictionary:@{
                                                     @"id": @"id",
                                                     @"status": @"status",
                                                     @"lastUpdateStatusDate": @"lastUpdateStatusDate",
                                                     @"correctAnswerCount": @"correctAnswerCount",
                                                     @"resultScore": @"resultScore",
                                                     @"resultWasViewed": @"resultWasViewed",
                                                     }];
    
    // USER
    [gamerModel addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"user"
                                                                               toKeyPath:@"user"
                                                                             withMapping:userProfileModel]];
    
    RKObjectMapping* userGameModel = [RKObjectMapping mappingForClass:[UserGameModel class]];
    [userGameModel addAttributeMappingsFromDictionary:@{
                                                        @"id": @"id",
                                                        @"gameStatus": @"gameStatus",
                                                        @"gamerStatus": @"gamerStatus",
                                                        }];
    
    // me
    [userGameModel addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"me"
                                                                                  toKeyPath:@"me"
                                                                                withMapping:gamerModel]];
    
    // oponent
    [userGameModel addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"oponent"
                                                                                  toKeyPath:@"oponent"
                                                                                withMapping:gamerModel]];
    
    
    
    RKObjectMapping* wrapperMapping = [RKObjectMapping mappingForClass:[ResponseWrapperModel class]];
    [wrapperMapping addAttributeMappingsFromDictionary:@{
                                                         @"status": @"status",
                                                         @"errorCode": @"errorCode",
                                                         @"errorMessage": @"errorMessage"
                                                         }];
    
    [wrapperMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"data"
                                                                                   toKeyPath:@"data"
                                                                                 withMapping:userGameModel]];
    
    RKResponseDescriptor *responseWrapperDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:wrapperMapping method:RKRequestMethodAny pathPattern:nil keyPath:@"" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful) ];
    
    return responseWrapperDescriptor;
}

// Строит маппинг для результата отправки приглашения пользователю
+ (RKResponseDescriptor*) buildResponseDescriptorForAcceptInvitation {
    RKObjectMapping* departmentModel = [RKObjectMapping mappingForClass:[DepartmentModel class]];
    [departmentModel addAttributeMappingsFromDictionary:@{
                                                          @"id": @"id",
                                                          @"name": @"name",
                                                          @"userCount": @"userCount",
                                                          @"score": @"score",
                                                          @"haveChildren": @"haveChildren",
                                                          @"isUserBelongs": @"isUserBelongs",
                                                          }];
    
    [departmentModel addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"parent"
                                                                                    toKeyPath:@"parent"
                                                                                  withMapping:departmentModel]];
    [departmentModel addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"children"
                                                                                    toKeyPath:@"children"
                                                                                  withMapping:departmentModel]];
    
    RKObjectMapping* userProfileModel = [RKObjectMapping mappingForClass:[UserProfileModel class]];
    [userProfileModel addAttributeMappingsFromDictionary:@{
                                                           @"id": @"id",
                                                           @"type": @"type",
                                                           @"name": @"name",
                                                           @"position": @"position",
                                                           @"login": @"login",
                                                           @"email": @"email",
                                                           @"totalGames": @"totalGames",
                                                           @"wonGames": @"wonGames",
                                                           @"loosingGames": @"loosingGames",
                                                           @"drawnGames": @"drawnGames",
                                                           @"score": @"score",
                                                           @"gamePosition": @"gamePosition",
                                                           @"playStatus": @"playStatus",
                                                           @"imageUrl": @"imageUrl",
                                                           @"lastTotalGames":@"lastTotalGames",
                                                           @"lastWonGames":@"lastWonGames",
                                                           @"lastLoosingGames":@"lastLoosingGames",
                                                           @"lastDrawnGames":@"lastDrawnGames",
                                                           @"lastScore":@"lastScore",
                                                           @"lastGamePosition":@"lastGamePosition",
                                                           @"lastStatisticsUpdate":@"lastStatisticsUpdate",
                                                           }];
    
    [userProfileModel addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"department"
                                                                                     toKeyPath:@"department"
                                                                                   withMapping:departmentModel]];
    
    
    RKObjectMapping* gamerModel = [RKObjectMapping mappingForClass:[GamerModel class]];
    [gamerModel addAttributeMappingsFromDictionary:@{
                                                     @"id": @"id",
                                                     @"status": @"status",
                                                     @"lastUpdateStatusDate": @"lastUpdateStatusDate",
                                                     @"correctAnswerCount": @"correctAnswerCount",
                                                     @"resultScore": @"resultScore",
                                                     @"resultWasViewed": @"resultWasViewed",
                                                     }];
    
    // USER
    [gamerModel addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"user"
                                                                               toKeyPath:@"user"
                                                                             withMapping:userProfileModel]];
    
    RKObjectMapping* userGameModel = [RKObjectMapping mappingForClass:[UserGameModel class]];
    [userGameModel addAttributeMappingsFromDictionary:@{
                                                        @"id": @"id",
                                                        @"gameStatus": @"gameStatus",
                                                        @"gamerStatus": @"gamerStatus",
                                                        }];
    
    // me
    [userGameModel addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"me"
                                                                                  toKeyPath:@"me"
                                                                                withMapping:gamerModel]];
    
    // oponent
    [userGameModel addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"oponent"
                                                                                  toKeyPath:@"oponent"
                                                                                withMapping:gamerModel]];
    
    
    
    RKObjectMapping* wrapperMapping = [RKObjectMapping mappingForClass:[ResponseWrapperModel class]];
    [wrapperMapping addAttributeMappingsFromDictionary:@{
                                                         @"status": @"status",
                                                         @"errorCode": @"errorCode",
                                                         @"errorMessage": @"errorMessage"
                                                         }];
    
    [wrapperMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"data"
                                                                                   toKeyPath:@"data"
                                                                                 withMapping:userGameModel]];
    
    RKResponseDescriptor *responseWrapperDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:wrapperMapping method:RKRequestMethodAny pathPattern:nil keyPath:@"" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful) ];
    
    return responseWrapperDescriptor;
}


// Строит маппинг для получения деталей по игре
+ (RKResponseDescriptor*) buildResponseDescriptorForGameInformation {
    RKObjectMapping* departmentModel = [RKObjectMapping mappingForClass:[DepartmentModel class]];
    [departmentModel addAttributeMappingsFromDictionary:@{
                                                          @"id": @"id",
                                                          @"name": @"name",
                                                          @"userCount": @"userCount",
                                                          @"score": @"score",
                                                          @"haveChildren": @"haveChildren",
                                                          @"isUserBelongs": @"isUserBelongs",
                                                          }];
    
    [departmentModel addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"parent"
                                                                                    toKeyPath:@"parent"
                                                                                  withMapping:departmentModel]];
    [departmentModel addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"children"
                                                                                    toKeyPath:@"children"
                                                                                  withMapping:departmentModel]];
    
    RKObjectMapping* userProfileModel = [RKObjectMapping mappingForClass:[UserProfileModel class]];
    [userProfileModel addAttributeMappingsFromDictionary:@{
                                                           @"id": @"id",
                                                           @"type": @"type",
                                                           @"name": @"name",
                                                           @"position": @"position",
                                                           @"login": @"login",
                                                           @"email": @"email",
                                                           @"totalGames": @"totalGames",
                                                           @"wonGames": @"wonGames",
                                                           @"loosingGames": @"loosingGames",
                                                           @"drawnGames": @"drawnGames",
                                                           @"score": @"score",
                                                           @"gamePosition": @"gamePosition",
                                                           @"playStatus": @"playStatus",
                                                           @"imageUrl": @"imageUrl",
                                                           @"lastTotalGames":@"lastTotalGames",
                                                           @"lastWonGames":@"lastWonGames",
                                                           @"lastLoosingGames":@"lastLoosingGames",
                                                           @"lastDrawnGames":@"lastDrawnGames",
                                                           @"lastScore":@"lastScore",
                                                           @"lastGamePosition":@"lastGamePosition",
                                                           @"lastStatisticsUpdate":@"lastStatisticsUpdate",
                                                           }];
    
    [userProfileModel addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"department"
                                                                                     toKeyPath:@"department"
                                                                                   withMapping:departmentModel]];
    
    
    RKObjectMapping* gamerModel = [RKObjectMapping mappingForClass:[GamerModel class]];
    [gamerModel addAttributeMappingsFromDictionary:@{
                                                     @"id": @"id",
                                                     @"status": @"status",
                                                     @"lastUpdateStatusDate": @"lastUpdateStatusDate",
                                                     @"correctAnswerCount": @"correctAnswerCount",
                                                     @"resultScore": @"resultScore",
                                                     @"resultWasViewed": @"resultWasViewed",
                                                     }];
    
    // USER
    [gamerModel addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"user"
                                                                               toKeyPath:@"user"
                                                                             withMapping:userProfileModel]];
    
    
    RKObjectMapping* gameRoundQuestionAnswerModel = [RKObjectMapping mappingForClass:[GameRoundQuestionAnswerModel class]];
    [gameRoundQuestionAnswerModel addAttributeMappingsFromDictionary:@{
                                                                 @"id": @"id",
                                                                 @"text": @"text",
                                                                 @"isCorrect":@"isCorrect",
                                                                 @"isMissingAnswer":@"isMissingAnswer",
                                                                 }];
    
    
    
    RKObjectMapping* gameRoundQuestionModel = [RKObjectMapping mappingForClass:[GameRoundQuestionModel class]];
    [gameRoundQuestionModel addAttributeMappingsFromDictionary:@{
                                                         @"id": @"id",
                                                         @"type": @"type",
                                                         @"text":@"text",
                                                         @"imageUrl" : @"imageUrl",
                                                         @"imageUrlBase64":@"imageUrlBase64",
                                                         }];
    [gameRoundQuestionModel addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"answers"
                                                                                   toKeyPath:@"answers"
                                                                                 withMapping:gameRoundQuestionAnswerModel]];
    [gameRoundQuestionModel addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"answer"
                                                                                           toKeyPath:@"answer"
                                                                                         withMapping:gameRoundQuestionAnswerModel]];
    
    [gameRoundQuestionModel addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"oponentAnswer"
                                                                                           toKeyPath:@"oponentAnswer"
                                                                                         withMapping:gameRoundQuestionAnswerModel]];
    
    RKObjectMapping* gameRoundCategoryModel = [RKObjectMapping mappingForClass:[GameRoundCategoryModel class]];
    [gameRoundCategoryModel addAttributeMappingsFromDictionary:@{
                                                         @"id": @"id",
                                                         @"name": @"name",
                                                         @"color": @"color",
                                                         @"imageUrl": @"imageUrl",
                                                         @"imageUrlBase64": @"imageUrlBase64",
                                                         }];
    [gameRoundCategoryModel addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"questions"
                                                                                   toKeyPath:@"questions"
                                                                                 withMapping:gameRoundQuestionModel]];
    
    
    
    RKObjectMapping* gameRoundModel = [RKObjectMapping mappingForClass:[GameRoundModel class]];
    [gameRoundModel addAttributeMappingsFromDictionary:@{
                                                    @"id": @"id",
                                                    @"categoryName": @"categoryName",
                                                    @"status": @"status",
                                                    }];
    
    [gameRoundModel addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"questions"
                                                                              toKeyPath:@"questions"
                                                                            withMapping:gameRoundQuestionModel]];
    
    [gameRoundModel addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"category"
                                                                                   toKeyPath:@"category"
                                                                                 withMapping:gameRoundCategoryModel]];

    
    RKObjectMapping* gameModel = [RKObjectMapping mappingForClass:[GameModel class]];
    [gameModel addAttributeMappingsFromDictionary:@{
                                                        @"id": @"id",
                                                        @"status": @"status",
                                                        }];
    
    // me
    [gameModel addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"me"
                                                                                  toKeyPath:@"me"
                                                                                withMapping:gamerModel]];
    
    // oponent
    [gameModel addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"oponent"
                                                                                  toKeyPath:@"oponent"
                                                                                withMapping:gamerModel]];


    [gameModel addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"gameRounds"
                                                                              toKeyPath:@"gameRounds"
                                                                            withMapping:gameRoundModel]];

    [gameModel addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"lastRound"
                                                                              toKeyPath:@"lastRound"
                                                                            withMapping:gameRoundModel]];
    
    [gameModel addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"categories"
                                                                              toKeyPath:@"categories"
                                                                            withMapping:gameRoundCategoryModel]];
    
    
    RKObjectMapping* wrapperMapping = [RKObjectMapping mappingForClass:[ResponseWrapperModel class]];
    [wrapperMapping addAttributeMappingsFromDictionary:@{
                                                         @"status": @"status",
                                                         @"errorCode": @"errorCode",
                                                         @"errorMessage": @"errorMessage"
                                                         }];
    
    [wrapperMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"data"
                                                                                   toKeyPath:@"data"
                                                                                 withMapping:gameModel]];
    
    RKResponseDescriptor *responseWrapperDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:wrapperMapping method:RKRequestMethodAny pathPattern:nil keyPath:@"" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful) ];
    
    return responseWrapperDescriptor;
}

// Строит маппинг для получения ответа с вопросами на запрос создания нового раунда
+ (RKResponseDescriptor*) buildResponseDescriptorForCreatedGameRound {
    RKObjectMapping* gameRoundQuestionAnswerModel = [RKObjectMapping mappingForClass:[GameRoundQuestionAnswerModel class]];
    [gameRoundQuestionAnswerModel addAttributeMappingsFromDictionary:@{
                                                                       @"id": @"id",
                                                                       @"text": @"text",
                                                                       @"isCorrect":@"isCorrect",
                                                                       @"isMissingAnswer":@"isMissingAnswer"
                                                                       }];
    
    
    
    RKObjectMapping* gameRoundQuestionModel = [RKObjectMapping mappingForClass:[GameRoundQuestionModel class]];
    [gameRoundQuestionModel addAttributeMappingsFromDictionary:@{
                                                                 @"id": @"id",
                                                                 @"type": @"type",
                                                                 @"text":@"text",
                                                                 @"imageUrl" : @"imageUrl",
                                                                 @"imageUrlBase64":@"imageUrlBase64",
                                                                 }];
    [gameRoundQuestionModel addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"answers"
                                                                                           toKeyPath:@"answers"
                                                                                         withMapping:gameRoundQuestionAnswerModel]];
    [gameRoundQuestionModel addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"answer"
                                                                                           toKeyPath:@"answer"
                                                                                         withMapping:gameRoundQuestionAnswerModel]];
    
    [gameRoundQuestionModel addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"oponentAnswer"
                                                                                           toKeyPath:@"oponentAnswer"
                                                                                         withMapping:gameRoundQuestionAnswerModel]];
    
    
    RKObjectMapping* gameRoundCategoryModel = [RKObjectMapping mappingForClass:[GameRoundCategoryModel class]];
    [gameRoundCategoryModel addAttributeMappingsFromDictionary:@{
                                                                 @"id": @"id",
                                                                 @"name": @"name",
                                                                 @"color": @"color",
                                                                 @"imageUrl": @"imageUrl",
                                                                 @"imageUrlBase64": @"imageUrlBase64",
                                                                 }];

    
    RKObjectMapping* gameRoundModel = [RKObjectMapping mappingForClass:[GameRoundModel class]];
    [gameRoundModel addAttributeMappingsFromDictionary:@{
                                                         @"id": @"id",
                                                         @"categoryName": @"categoryName",
                                                         @"status": @"status",
                                                         }];
    
    [gameRoundModel addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"questions"
                                                                                   toKeyPath:@"questions"
                                                                                 withMapping:gameRoundQuestionModel]];
    
    [gameRoundModel addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"category"
                                                                                   toKeyPath:@"category"
                                                                                 withMapping:gameRoundCategoryModel]];
    
    RKObjectMapping* wrapperMapping = [RKObjectMapping mappingForClass:[ResponseWrapperModel class]];
    [wrapperMapping addAttributeMappingsFromDictionary:@{
                                                         @"status": @"status",
                                                         @"errorCode": @"errorCode",
                                                         @"errorMessage": @"errorMessage"
                                                         }];
    
    [wrapperMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"data"
                                                                                   toKeyPath:@"data"
                                                                                 withMapping:gameRoundModel]];
    
    RKResponseDescriptor *responseWrapperDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:wrapperMapping method:RKRequestMethodAny pathPattern:nil keyPath:@"" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful) ];
    
    return responseWrapperDescriptor;
}

// Строит маппинг для получения списка вопросов в раунде
+ (RKResponseDescriptor*)  buildResponseDescriptorForGameRoundQuestions {
    return [GameHelper buildResponseDescriptorForCreatedGameRound];
}

// Строит маппинг для получения списка вопросов в раунде
+ (RKResponseDescriptor*)  buildResponseDescriptorForGameAnswerOnQuestion {
    RKObjectMapping* gamerQuestionAnswerResult = [RKObjectMapping mappingForClass:[GamerQuestionAnswerResultModel class]];
    [gamerQuestionAnswerResult addAttributeMappingsFromDictionary:@{
                                                         @"gameStatus": @"gameStatus",
                                                         @"gameRoundStatus": @"gameRoundStatus",
                                                         @"gamerStatus": @"gamerStatus",
                                                         @"gamerScore": @"gamerScore",
                                                         }];
    
    RKObjectMapping* wrapperMapping = [RKObjectMapping mappingForClass:[ResponseWrapperModel class]];
    [wrapperMapping addAttributeMappingsFromDictionary:@{
                                                         @"status": @"status",
                                                         @"errorCode": @"errorCode",
                                                         @"errorMessage": @"errorMessage"
                                                         }];
    
    [wrapperMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"data"
                                                                                   toKeyPath:@"data"
                                                                                 withMapping:gamerQuestionAnswerResult]];
    
    RKResponseDescriptor *responseWrapperDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:wrapperMapping method:RKRequestMethodAny pathPattern:nil keyPath:@"" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful) ];
    
    return responseWrapperDescriptor;
}


// Строит маппинг для получения ответа на запрос "Сдаться"
+ (RKResponseDescriptor*) buildResponseDescriptorForGameSurrender {
    return [GameHelper buildResponseDescriptorForGameInformation];
}


// Строит маппинг для получения ответа на запрос отметки о прочтении
+ (RKResponseDescriptor*) buildResponseDescriptorForGameMarkAsViewed {
    return [GameHelper buildResponseDescriptorForGameInformation];
}



@end
