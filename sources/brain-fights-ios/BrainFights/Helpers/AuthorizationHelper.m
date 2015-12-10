//
//  AuthorizationHelper.m
//  BrainFights
//
//  Created by Artem Demidovich on 11/7/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import "AuthorizationHelper.h"

#import "AuthorizationRequestModel.h"
#import "AuthorizationResponseModel.h"

#import "UserProfileModel.h"
#import "DepartmentModel.h"


#import "ResponseWrapperModel.h"
#import "UrlHelper.h"

#import "RKObjectMapping.h"
#import "RKResponseDescriptor.h"
#import "RKObjectRequestOperation.h"
#import "RKRelationshipMapping.h"
#import "RKRequestDescriptor.h"
#import "RKLog.h"
#import "RKMIMETypes.h"

@implementation AuthorizationHelper

// Строит модель запроса для автоизации
+ (AuthorizationRequestModel*) buildAuthorizationRequestModel:(NSString*) login withPassword:(NSString*)password {
    
    AuthorizationRequestModel *model = [[AuthorizationRequestModel alloc] init];
    
    model.login = login;
    model.password = password;
    model.appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];;
    model.deviceOsVersion = [[NSString alloc] initWithFormat:@"%@ %@", [[UIDevice currentDevice] systemName], [[UIDevice currentDevice] systemVersion]];
//    model.devicePushToken = @"";
    model.deviceType = @"IOS";
    
    return model;
}


// Строить мета информацию для отправки запросов на авторизацию
+ (RKObjectManager*) buildObjectManagerForSignIn; {
    NSURL *targetUrl = [NSURL URLWithString:[UrlHelper userBaseUrl]];
    
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
                                                          @"position":@"position",
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
    
    
    RKObjectMapping* responseDataModel = [RKObjectMapping mappingForClass:[AuthorizationResponseModel class]];
    [responseDataModel addAttributeMappingsFromDictionary:@{
                                                            @"authToken": @"authToken",
                                                            }];

    [responseDataModel addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"userProfile"
                                                                                   toKeyPath:@"userProfile"
                                                                                 withMapping:userProfileModel]];
    
    RKObjectMapping* wrapperMapping = [RKObjectMapping mappingForClass:[ResponseWrapperModel class]];
    [wrapperMapping addAttributeMappingsFromDictionary:@{
                                                         @"status": @"status",
                                                         @"errorCode": @"errorCode",
                                                         @"errorMessage": @"errorMessage"
                                                         }];
    
    [wrapperMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"data"
                                                                                   toKeyPath:@"data"
                                                                                 withMapping:responseDataModel]];
    
    RKResponseDescriptor *responseWrapperDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:wrapperMapping method:RKRequestMethodAny pathPattern:nil keyPath:@"" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful) ];
    
    // ==== REQUEST DESC =====
    
    RKObjectMapping* signinRequestModel = [RKObjectMapping requestMapping];
    [signinRequestModel addAttributeMappingsFromDictionary:@{
                                                            @"login": @"login",
                                                            @"password": @"password",
                                                            @"deviceType": @"deviceType",
                                                            @"devicePushToken": @"devicePushToken",
                                                            @"deviceOsVersion": @"deviceOsVersion",
                                                            @"appVersion": @"appVersion"
                                                            }];
    
    
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:targetUrl];
    objectManager.requestSerializationMIMEType = RKMIMETypeJSON;
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:signinRequestModel objectClass:[AuthorizationRequestModel class] rootKeyPath:nil method:RKRequestMethodPOST];
    
    [objectManager addRequestDescriptor:requestDescriptor];
    [objectManager addResponseDescriptor:responseWrapperDescriptor];
    
    return objectManager;
}


// Строит модель для запросов профиля авторизованного пользователя
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
                                                            @"position":@"position",
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


@end
