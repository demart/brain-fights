//
//  UserHelper.m
//  BrainFights
//
//  Created by Artem Demidovich on 11/9/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import "UserHelper.h"

#import "DevicePushTokenRegisterModel.h"

#import "DepartmentSearchResultModel.h"
#import "DepartmentModel.h"
#import "UserSearchResultModel.h"
#import "UserProfileModel.h"
#import "UserFriendsModel.h"
#import "ResponseWrapperModel.h"
#import "UserSearchRequestModel.h"

@implementation UserHelper

// Строит маппинг для профиля пользователя
+ (RKResponseDescriptor*) buildResponseDescriptorForUserProfile {
    RKObjectMapping* departmentModel = [RKObjectMapping mappingForClass:[DepartmentModel class]];
    [departmentModel addAttributeMappingsFromDictionary:@{
                                                          @"id": @"id",
                                                          @"name": @"name",
                                                          @"userCount": @"userCount",
                                                          @"score": @"score",
                                                          @"haveChildren": @"haveChildren",
                                                          @"isUserBelongs": @"isUserBelongs",
                                                          @"lastScore":@"lastScore",
                                                          @"lastPosition":@"lastPosition",
                                                          @"lastGlobalPosition":@"lastGlobalPosition",
                                                          @"lastStatisticsUpdate":@"lastStatisticsUpdate",
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
    
    RKObjectMapping* wrapperMapping = [RKObjectMapping mappingForClass:[ResponseWrapperModel class]];
    [wrapperMapping addAttributeMappingsFromDictionary:@{
                                                         @"status": @"status",
                                                         @"errorCode": @"errorCode",
                                                         @"errorMessage": @"errorMessage"
                                                         }];
    
    [wrapperMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"data"
                                                                                   toKeyPath:@"data"
                                                                                 withMapping:userProfileModel]];
    
    RKResponseDescriptor *responseWrapperDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:wrapperMapping method:RKRequestMethodAny pathPattern:nil keyPath:@"" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful) ];
    
    return responseWrapperDescriptor;
}


// Строит маппинг для результата отправки приглашения пользователю
+ (RKResponseDescriptor*) buildResponseDescriptorForFriends {
    RKObjectMapping* departmentModel = [RKObjectMapping mappingForClass:[DepartmentModel class]];
    [departmentModel addAttributeMappingsFromDictionary:@{
                                                          @"id": @"id",
                                                          @"name": @"name",
                                                          @"userCount": @"userCount",
                                                          @"score": @"score",
                                                          @"haveChildren": @"haveChildren",
                                                          @"isUserBelongs": @"isUserBelongs",
                                                          @"lastScore":@"lastScore",
                                                          @"lastPosition":@"lastPosition",
                                                          @"lastGlobalPosition":@"lastGlobalPosition",
                                                          @"lastStatisticsUpdate":@"lastStatisticsUpdate",
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
    
    
    RKObjectMapping* userFriendsModel = [RKObjectMapping mappingForClass:[UserFriendsModel class]];
    [userFriendsModel addAttributeMappingsFromDictionary:@{
                                                     @"count": @"count",
                                                     }];
    
    // FRIENDS
    [userFriendsModel addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"friends"
                                                                               toKeyPath:@"friends"
                                                                             withMapping:userProfileModel]];
    
    RKObjectMapping* wrapperMapping = [RKObjectMapping mappingForClass:[ResponseWrapperModel class]];
    [wrapperMapping addAttributeMappingsFromDictionary:@{
                                                         @"status": @"status",
                                                         @"errorCode": @"errorCode",
                                                         @"errorMessage": @"errorMessage"
                                                         }];
    
    [wrapperMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"data"
                                                                                   toKeyPath:@"data"
                                                                                 withMapping:userFriendsModel]];
    
    RKResponseDescriptor *responseWrapperDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:wrapperMapping method:RKRequestMethodAny pathPattern:nil keyPath:@"" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful) ];
    
    return responseWrapperDescriptor;
}

// Строит маппинг для добавления друга
+ (RKResponseDescriptor*) buildResponseDescriptorForAddFriend {
    RKObjectMapping* wrapperMapping = [RKObjectMapping mappingForClass:[ResponseWrapperModel class]];
    [wrapperMapping addAttributeMappingsFromDictionary:@{
                                                         @"status": @"status",
                                                         @"errorCode": @"errorCode",
                                                         @"errorMessage": @"errorMessage"
                                                         }];
    RKResponseDescriptor *responseWrapperDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:wrapperMapping method:RKRequestMethodAny pathPattern:nil keyPath:@"" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful) ];
    
    return responseWrapperDescriptor;
}

// Строит маппинг для уделяния друга
+ (RKResponseDescriptor*) buildResponseDescriptorForRemoveFriend {
    RKObjectMapping* wrapperMapping = [RKObjectMapping mappingForClass:[ResponseWrapperModel class]];
    [wrapperMapping addAttributeMappingsFromDictionary:@{
                                                         @"status": @"status",
                                                         @"errorCode": @"errorCode",
                                                         @"errorMessage": @"errorMessage"
                                                         }];
    RKResponseDescriptor *responseWrapperDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:wrapperMapping method:RKRequestMethodAny pathPattern:nil keyPath:@"" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful) ];
    
    return responseWrapperDescriptor;
}

//  Строит маппинг для просмотра организационной структуры
+ (RKResponseDescriptor*) buildResponseDescriptorForDepartments {
    
    RKObjectMapping* userDepartmentModel = [RKObjectMapping mappingForClass:[DepartmentModel class]];
    [userDepartmentModel addAttributeMappingsFromDictionary:@{
                                                          @"id": @"id",
                                                          @"name": @"name",
                                                          @"userCount": @"userCount",
                                                          @"score": @"score",
                                                          @"haveChildren": @"haveChildren",
                                                          @"isUserBelongs": @"isUserBelongs",
                                                          @"lastScore":@"lastScore",
                                                          @"lastPosition":@"lastPosition",
                                                          @"lastGlobalPosition":@"lastGlobalPosition",
                                                          @"lastStatisticsUpdate":@"lastStatisticsUpdate",
                                                          }];
    
    [userDepartmentModel addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"parent"
                                                                                    toKeyPath:@"parent"
                                                                                  withMapping:userDepartmentModel]];
    [userDepartmentModel addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"children"
                                                                                    toKeyPath:@"children"
                                                                                  withMapping:userDepartmentModel]];
    
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
                                                                                   withMapping:userDepartmentModel]];
    
    
    RKObjectMapping* departmentModel = [RKObjectMapping mappingForClass:[DepartmentModel class]];
    [departmentModel addAttributeMappingsFromDictionary:@{
                                                          @"id": @"id",
                                                          @"name": @"name",
                                                          @"userCount": @"userCount",
                                                          @"score": @"score",
                                                          @"haveChildren": @"haveChildren",
                                                          @"isUserBelongs": @"isUserBelongs",
                                                          @"lastScore":@"lastScore",
                                                          @"lastPosition":@"lastPosition",
                                                          @"lastGlobalPosition":@"lastGlobalPosition",
                                                          @"lastStatisticsUpdate":@"lastStatisticsUpdate",
                                                          }];
    
    [departmentModel addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"parent"
                                                                                    toKeyPath:@"parent"
                                                                                  withMapping:departmentModel]];
    [departmentModel addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"children"
                                                                                    toKeyPath:@"children"
                                                                                  withMapping:departmentModel]];
    
    [departmentModel addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"users"
                                                                                    toKeyPath:@"users"
                                                                                  withMapping:userProfileModel]];
    
    RKObjectMapping* departmentSearchResultModel = [RKObjectMapping mappingForClass:[DepartmentSearchResultModel class]];
    [departmentSearchResultModel addAttributeMappingsFromDictionary:@{
                                                          @"count": @"count",
                                                          }];

    [departmentSearchResultModel addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"departments" toKeyPath:@"departments" withMapping:departmentModel]];
    

    RKObjectMapping* wrapperMapping = [RKObjectMapping mappingForClass:[ResponseWrapperModel class]];
    [wrapperMapping addAttributeMappingsFromDictionary:@{
                                                         @"status": @"status",
                                                         @"errorCode": @"errorCode",
                                                         @"errorMessage": @"errorMessage"
                                                         }];
    
    [wrapperMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"data"
                                                                                   toKeyPath:@"data"
                                                                                 withMapping:departmentSearchResultModel]];
    
    RKResponseDescriptor *responseWrapperDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:wrapperMapping method:RKRequestMethodAny pathPattern:nil keyPath:@"" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful) ];
    
    return responseWrapperDescriptor;
}



//  Строит маппинг для поиска пользователей по имени
+ (RKResponseDescriptor*) buildResponseDescriptorForSearchUsers {
    
    RKObjectMapping* departmentModel = [RKObjectMapping mappingForClass:[DepartmentModel class]];
    [departmentModel addAttributeMappingsFromDictionary:@{
                                                          @"id": @"id",
                                                          @"name": @"name",
                                                          @"userCount": @"userCount",
                                                          @"score": @"score",
                                                          @"haveChildren": @"haveChildren",
                                                          @"isUserBelongs": @"isUserBelongs",
                                                          @"lastScore":@"lastScore",
                                                          @"lastPosition":@"lastPosition",
                                                          @"lastGlobalPosition":@"lastGlobalPosition",
                                                          @"lastStatisticsUpdate":@"lastStatisticsUpdate",
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
    
    
    RKObjectMapping* userSearchResultModel = [RKObjectMapping mappingForClass:[UserSearchResultModel class]];
    [userSearchResultModel addAttributeMappingsFromDictionary:@{
                                                                      @"count": @"count",
                                                                      @"totalCount": @"totalCount",
                                                                      }];
    
    [userSearchResultModel addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"users" toKeyPath:@"users" withMapping:userProfileModel]];
    
    
    RKObjectMapping* wrapperMapping = [RKObjectMapping mappingForClass:[ResponseWrapperModel class]];
    [wrapperMapping addAttributeMappingsFromDictionary:@{
                                                         @"status": @"status",
                                                         @"errorCode": @"errorCode",
                                                         @"errorMessage": @"errorMessage"
                                                         }];
    
    [wrapperMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"data"
                                                                                   toKeyPath:@"data"
                                                                                 withMapping:userSearchResultModel]];
    
    RKResponseDescriptor *responseWrapperDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:wrapperMapping method:RKRequestMethodAny pathPattern:nil keyPath:@"" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful) ];
    
    return responseWrapperDescriptor;
}


//  Строит маппинг для получения рейтинга пользователей
+ (RKResponseDescriptor*) buildResponseDescriptorForUsersRating {
    
    RKObjectMapping* departmentModel = [RKObjectMapping mappingForClass:[DepartmentModel class]];
    [departmentModel addAttributeMappingsFromDictionary:@{
                                                          @"id": @"id",
                                                          @"name": @"name",
                                                          @"userCount": @"userCount",
                                                          @"score": @"score",
                                                          @"haveChildren": @"haveChildren",
                                                          @"isUserBelongs": @"isUserBelongs",
                                                          @"lastScore":@"lastScore",
                                                          @"lastPosition":@"lastPosition",
                                                          @"lastGlobalPosition":@"lastGlobalPosition",
                                                          @"lastStatisticsUpdate":@"lastStatisticsUpdate",
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
    
    RKObjectMapping* wrapperMapping = [RKObjectMapping mappingForClass:[ResponseWrapperModel class]];
    [wrapperMapping addAttributeMappingsFromDictionary:@{
                                                         @"status": @"status",
                                                         @"errorCode": @"errorCode",
                                                         @"errorMessage": @"errorMessage"
                                                         }];
    
    [wrapperMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"data"
                                                                                   toKeyPath:@"data"
                                                                                 withMapping:userProfileModel]];
    
    RKResponseDescriptor *responseWrapperDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:wrapperMapping method:RKRequestMethodAny pathPattern:nil keyPath:@"" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful) ];
    
    return responseWrapperDescriptor;
}


//  Строит маппинг для получения типа подразделений
+ (RKResponseDescriptor*) buildResponseDescriptorForDepartmentTypes {
    RKObjectMapping* departmentTypeModel = [RKObjectMapping mappingForClass:[DepartmentTypeModel class]];
    [departmentTypeModel addAttributeMappingsFromDictionary:@{
                                                           @"id": @"id",
                                                           @"name": @"name"
                                                           }];
    
    RKObjectMapping* wrapperMapping = [RKObjectMapping mappingForClass:[ResponseWrapperModel class]];
    [wrapperMapping addAttributeMappingsFromDictionary:@{
                                                         @"status": @"status",
                                                         @"errorCode": @"errorCode",
                                                         @"errorMessage": @"errorMessage"
                                                         }];
    
    [wrapperMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"data"
                                                                                   toKeyPath:@"data"
                                                                                 withMapping:departmentTypeModel]];
    
    RKResponseDescriptor *responseWrapperDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:wrapperMapping method:RKRequestMethodAny pathPattern:nil keyPath:@"" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful) ];
    
    return responseWrapperDescriptor;
}

//  Строит маппинг для получения рейтинга департаментов
+ (RKResponseDescriptor*) buildResponseDescriptorForDepartmentsRating {
    
    RKObjectMapping* userDepartmentModel = [RKObjectMapping mappingForClass:[DepartmentModel class]];
    [userDepartmentModel addAttributeMappingsFromDictionary:@{
                                                              @"id": @"id",
                                                              @"name": @"name",
                                                              @"userCount": @"userCount",
                                                              @"score": @"score",
                                                              @"haveChildren": @"haveChildren",
                                                              @"isUserBelongs": @"isUserBelongs",
                                                              @"lastScore":@"lastScore",
                                                              @"lastPosition":@"lastPosition",
                                                              @"lastGlobalPosition":@"lastGlobalPosition",
                                                              @"lastStatisticsUpdate":@"lastStatisticsUpdate",
                                                              }];
    
    [userDepartmentModel addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"parent"
                                                                                        toKeyPath:@"parent"
                                                                                      withMapping:userDepartmentModel]];
    [userDepartmentModel addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"children"
                                                                                        toKeyPath:@"children"
                                                                                      withMapping:userDepartmentModel]];
    
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
                                                                                   withMapping:userDepartmentModel]];
    
    RKObjectMapping* departmentTypeModel = [RKObjectMapping mappingForClass:[DepartmentTypeModel class]];
    [departmentTypeModel addAttributeMappingsFromDictionary:@{
                                                              @"id": @"id",
                                                              @"name": @"name"
                                                              }];
    
    RKObjectMapping* departmentModel = [RKObjectMapping mappingForClass:[DepartmentModel class]];
    [departmentModel addAttributeMappingsFromDictionary:@{
                                                          @"id": @"id",
                                                          @"name": @"name",
                                                          @"userCount": @"userCount",
                                                          @"score": @"score",
                                                          @"haveChildren": @"haveChildren",
                                                          @"isUserBelongs": @"isUserBelongs",
                                                          @"lastScore":@"lastScore",
                                                          @"lastPosition":@"lastPosition",
                                                          @"lastGlobalPosition":@"lastGlobalPosition",
                                                          @"lastStatisticsUpdate":@"lastStatisticsUpdate",
                                                          }];
    
    [departmentModel addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"parent"
                                                                                    toKeyPath:@"parent"
                                                                                  withMapping:departmentModel]];
    [departmentModel addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"children"
                                                                                    toKeyPath:@"children"
                                                                                  withMapping:departmentModel]];
    
    [departmentModel addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"users"
                                                                                    toKeyPath:@"users"
                                                                                  withMapping:userProfileModel]];
    
    [departmentModel addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"type" toKeyPath:@"type" withMapping:departmentTypeModel]];
    
    RKObjectMapping* wrapperMapping = [RKObjectMapping mappingForClass:[ResponseWrapperModel class]];
    [wrapperMapping addAttributeMappingsFromDictionary:@{
                                                         @"status": @"status",
                                                         @"errorCode": @"errorCode",
                                                         @"errorMessage": @"errorMessage"
                                                         }];
    
    [wrapperMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"data"
                                                                                   toKeyPath:@"data"
                                                                                 withMapping:departmentModel]];
    
    RKResponseDescriptor *responseWrapperDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:wrapperMapping method:RKRequestMethodAny pathPattern:nil keyPath:@"" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful) ];
    
    return responseWrapperDescriptor;
    
}



//  Строит маппинг для получения ответа о регистрации PUSH токена
+ (RKObjectManager*) buildObjectManagerForRegisterOrUpdateDeviceToken {
    NSURL *targetUrl = [NSURL URLWithString:[UrlHelper registerDeviceTokenUrl]];

    RKObjectMapping* wrapperMapping = [RKObjectMapping mappingForClass:[ResponseWrapperModel class]];
    [wrapperMapping addAttributeMappingsFromDictionary:@{
                                                         @"status": @"status",
                                                         @"errorCode": @"errorCode",
                                                         @"errorMessage": @"errorMessage"
                                                         }];
    
    RKResponseDescriptor *responseWrapperDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:wrapperMapping method:RKRequestMethodAny pathPattern:nil keyPath:@"" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful) ];
    
    // ==== REQUEST DESC =====
    
    RKObjectMapping* signinRequestModel = [RKObjectMapping requestMapping];
    [signinRequestModel addAttributeMappingsFromDictionary:@{
                                                             @"devicePushToken": @"devicePushToken",
                                                             @"invalidPushToken": @"invalidPushToken",
                                                             }];
    
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:targetUrl];
    objectManager.requestSerializationMIMEType = RKMIMETypeJSON;
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:signinRequestModel objectClass:[DevicePushTokenRegisterModel class] rootKeyPath:nil method:RKRequestMethodPOST];
    
    [objectManager addRequestDescriptor:requestDescriptor];
    [objectManager addResponseDescriptor:responseWrapperDescriptor];
    
    return objectManager;
}


//  Строит маппинг для поиска пользователей
+ (RKObjectManager*) buildObjectManagerForSearchUsers {
    
    RKObjectMapping* departmentModel = [RKObjectMapping mappingForClass:[DepartmentModel class]];
    [departmentModel addAttributeMappingsFromDictionary:@{
                                                          @"id": @"id",
                                                          @"name": @"name",
                                                          @"userCount": @"userCount",
                                                          @"score": @"score",
                                                          @"haveChildren": @"haveChildren",
                                                          @"isUserBelongs": @"isUserBelongs",
                                                          @"lastScore":@"lastScore",
                                                          @"lastPosition":@"lastPosition",
                                                          @"lastGlobalPosition":@"lastGlobalPosition",
                                                          @"lastStatisticsUpdate":@"lastStatisticsUpdate",
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
    
    
    RKObjectMapping* userSearchResultModel = [RKObjectMapping mappingForClass:[UserSearchResultModel class]];
    [userSearchResultModel addAttributeMappingsFromDictionary:@{
                                                                @"count": @"count",
                                                                @"totalCount": @"totalCount",
                                                                }];
    
    [userSearchResultModel addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"users" toKeyPath:@"users" withMapping:userProfileModel]];
    
    
    RKObjectMapping* wrapperMapping = [RKObjectMapping mappingForClass:[ResponseWrapperModel class]];
    [wrapperMapping addAttributeMappingsFromDictionary:@{
                                                         @"status": @"status",
                                                         @"errorCode": @"errorCode",
                                                         @"errorMessage": @"errorMessage"
                                                         }];
    
    [wrapperMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"data"
                                                                                   toKeyPath:@"data"
                                                                                 withMapping:userSearchResultModel]];
    RKResponseDescriptor *responseWrapperDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:wrapperMapping method:RKRequestMethodAny pathPattern:nil keyPath:@"" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful) ];
    // ==== REQUEST DESC =====
    
    RKObjectMapping* signinRequestModel = [RKObjectMapping requestMapping];
    [signinRequestModel addAttributeMappingsFromDictionary:@{
                                                             @"searchText": @"searchText",
                                                             }];
    
    
    NSURL *targetUrl = [NSURL URLWithString:[UrlHelper searchUsersByTextUrl]];
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:targetUrl];
    objectManager.requestSerializationMIMEType = RKMIMETypeJSON;
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:signinRequestModel objectClass:[UserSearchRequestModel class] rootKeyPath:nil method:RKRequestMethodPOST];
    
    [objectManager addRequestDescriptor:requestDescriptor];
    [objectManager addResponseDescriptor:responseWrapperDescriptor];
    
    return objectManager;
}

@end
