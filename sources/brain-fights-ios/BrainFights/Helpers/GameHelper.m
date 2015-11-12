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



@end
