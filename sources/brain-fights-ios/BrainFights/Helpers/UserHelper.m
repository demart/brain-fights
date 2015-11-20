//
//  UserHelper.m
//  BrainFights
//
//  Created by Artem Demidovich on 11/9/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import "UserHelper.h"

#import "DepartmentSearchResultModel.h"
#import "DepartmentModel.h"
#import "UserSearchResultModel.h"
#import "UserProfileModel.h"
#import "UserFriendsModel.h"
#import "ResponseWrapperModel.h"

@implementation UserHelper

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

@end
