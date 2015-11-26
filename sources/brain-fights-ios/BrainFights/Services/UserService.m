//
//  UserService.m
//  BrainFights
//
//  Created by Artem Demidovich on 11/7/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import "UserService.h"
#import "UserProfileModel.h"
#import "ResponseWrapperModel.h"
#import "AuthorizationService.h"
#import "UrlHelper.h"
#import "UserHelper.h"
#import "UserSearchRequestModel.h"

@implementation UserService

static UserService *_userService;
static UserProfileModel *_userProfileModel;

+(UserService*) sharedInstance {
    if (_userService == nil)
        _userService = [[UserService alloc] init];
    return _userService;
}

// Выставляет профиль пользователя
- (void) setUserProfile:(UserProfileModel*) profile {
    _userProfileModel = profile;
}

// Выставляет профиль пользователя
- (UserProfileModel*) getUserProfile {
    return _userProfileModel;
}

// Загружает профиль любого пользователя асинхронно
- (void) retrieveUserProfileByIdAsync:(NSInteger)userId onSuccess:(void (^)(ResponseWrapperModel *response))success onFailure:(void (^)(NSError *error))failure {
    
    NSString* authToken = [AuthorizationService getAuthToken];
    if (authToken == nil)
        failure(nil);
    
    if (userId < 1)
        failure(nil);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:[UrlHelper userProfileByIdUrl:userId]]];
    
    RKResponseDescriptor *responseWrapperDescriptor = [UserHelper buildResponseDescriptorForUserProfile];
    
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[ responseWrapperDescriptor ]];
    [objectRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        ResponseWrapperModel *response = (ResponseWrapperModel*)[mappingResult.array objectAtIndex:0];
        
        NSLog(@"Status: %@", response.status);
        NSLog(@"Data: %@", response.data);
        NSLog(@"ErrorCode: %@", response.errorCode);
        NSLog(@"ErrorMessage: %@", response.errorMessage);
        
        success(response);
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Operation failed with error: %@", error);
        failure(error);
    }];
    
    [objectRequestOperation start];
}

// Загружает список друзей
- (void) retrieveUserFriendsAsync:(void (^)(ResponseWrapperModel *response))success onFailure:(void (^)(NSError *error))failure {
    
    NSString* authToken = [AuthorizationService getAuthToken];
    if (authToken == nil)
        failure(nil);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:[UrlHelper userFriendsUrl]]];
    
    RKResponseDescriptor *responseWrapperDescriptor = [UserHelper buildResponseDescriptorForFriends];
    
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[ responseWrapperDescriptor ]];
    [objectRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        ResponseWrapperModel *response = (ResponseWrapperModel*)[mappingResult.array objectAtIndex:0];
        
        NSLog(@"Status: %@", response.status);
        NSLog(@"Data: %@", response.data);
        NSLog(@"ErrorCode: %@", response.errorCode);
        NSLog(@"ErrorMessage: %@", response.errorMessage);
        
        success(response);
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Operation failed with error: %@", error);
        failure(error);
    }];
    
    [objectRequestOperation start];
}

// Добавляем друга
- (void) addUserFriendAsync:(NSInteger)userId onSuccess:(void (^)(ResponseWrapperModel *response))success onFailure:(void (^)(NSError *error))failure {
    
    NSString* authToken = [AuthorizationService getAuthToken];
    if (authToken == nil)
        failure(nil);
    
    if (userId < 1)
        failure(nil);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:[UrlHelper userAddFriendByIdUrl:userId]]];
    
    RKResponseDescriptor *responseWrapperDescriptor = [UserHelper buildResponseDescriptorForAddFriend];
    
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[ responseWrapperDescriptor ]];
    [objectRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        ResponseWrapperModel *response = (ResponseWrapperModel*)[mappingResult.array objectAtIndex:0];
        
        NSLog(@"Status: %@", response.status);
        NSLog(@"Data: %@", response.data);
        NSLog(@"ErrorCode: %@", response.errorCode);
        NSLog(@"ErrorMessage: %@", response.errorMessage);
        
        success(response);
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Operation failed with error: %@", error);
        failure(error);
    }];
    
    [objectRequestOperation start];
}

// Добавляем друга
- (void) removeUserFriendAsync:(NSInteger)userId onSuccess:(void (^)(ResponseWrapperModel *response))success onFailure:(void (^)(NSError *error))failure {
    
    NSString* authToken = [AuthorizationService getAuthToken];
    if (authToken == nil)
        failure(nil);
    
    if (userId < 1)
        failure(nil);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:[UrlHelper userAddFriendByIdUrl:userId]]];
    
    RKResponseDescriptor *responseWrapperDescriptor = [UserHelper buildResponseDescriptorForRemoveFriend];
    
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[ responseWrapperDescriptor ]];
    [objectRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        ResponseWrapperModel *response = (ResponseWrapperModel*)[mappingResult.array objectAtIndex:0];
        
        NSLog(@"Status: %@", response.status);
        NSLog(@"Data: %@", response.data);
        NSLog(@"ErrorCode: %@", response.errorCode);
        NSLog(@"ErrorMessage: %@", response.errorMessage);
        
        success(response);
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Operation failed with error: %@", error);
        failure(error);
    }];
    
    [objectRequestOperation start];
}

// Загружает список организационной структуры
- (void) searchDepartments:(NSInteger)parentId onSuccess:(void (^)(ResponseWrapperModel *response))success onFailure:(void (^)(NSError *error))failure {
    
    NSString* authToken = [AuthorizationService getAuthToken];
    if (authToken == nil)
        failure(nil);
    
    NSMutableURLRequest *request = nil;
    if (parentId < 1) {
        request = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:[UrlHelper childrenDepartmentByRootUrl]]];
    } else {
        request = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:[UrlHelper childrenDepartmentByParentIdUrl:parentId]]];
    }
    
    RKResponseDescriptor *responseWrapperDescriptor = [UserHelper buildResponseDescriptorForDepartments];
    
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[ responseWrapperDescriptor ]];
    [objectRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        ResponseWrapperModel *response = (ResponseWrapperModel*)[mappingResult.array objectAtIndex:0];
        
        NSLog(@"Status: %@", response.status);
        NSLog(@"Data: %@", response.data);
        NSLog(@"ErrorCode: %@", response.errorCode);
        NSLog(@"ErrorMessage: %@", response.errorMessage);
        
        success(response);
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Operation failed with error: %@", error);
        failure(error);
    }];
    
    [objectRequestOperation start];
}

// Загружает список организационной структуры
- (void) searchUsersByTextAsync:(NSString*)searchText onSuccess:(void (^)(ResponseWrapperModel *response))success onFailure:(void (^)(NSError *error))failure {
    
    NSString* authToken = [AuthorizationService getAuthToken];
    if (authToken == nil)
        failure(nil);
    
    UserSearchRequestModel *model = [[UserSearchRequestModel alloc] init];
    model.searchText = searchText;
    
    RKObjectManager *objectManager = [UserHelper buildObjectManagerForSearchUsers];
    [objectManager
     postObject:model
     path:@"" //???
     parameters:nil
     success:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
         ResponseWrapperModel *response = (ResponseWrapperModel*)[result.array objectAtIndex:0];
         
         NSLog(@"Status: %@", response.status);
         NSLog(@"Data: %@", response.data);
         NSLog(@"ErrorCode: %@", response.errorCode);
         NSLog(@"ErrorMessage: %@", response.errorMessage);
         
         success(response);
     }
     failure:^(RKObjectRequestOperation *operation, NSError *error){
         NSLog(@"Error %@", error);
         failure(error);
     }];
}

// Возращает постранично рейтинг пользователей
- (void) retrieveUsersRating:(NSInteger)page withLimit:(NSInteger)limit onSuccess:(void (^)(ResponseWrapperModel *response))success onFailure:(void (^)(NSError *error))failure {
    
    NSString* authToken = [AuthorizationService getAuthToken];
    if (authToken == nil)
        failure(nil);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:[UrlHelper usersRating:page withLimit:limit]]];
    
    RKResponseDescriptor *responseWrapperDescriptor = [UserHelper buildResponseDescriptorForUsersRating];
    
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[ responseWrapperDescriptor ]];
    [objectRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        ResponseWrapperModel *response = (ResponseWrapperModel*)[mappingResult.array objectAtIndex:0];
        
        NSLog(@"Status: %@", response.status);
        NSLog(@"Data: %@", response.data);
        NSLog(@"ErrorCode: %@", response.errorCode);
        NSLog(@"ErrorMessage: %@", response.errorMessage);
        
        success(response);
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Operation failed with error: %@", error);
        failure(error);
    }];
    
    [objectRequestOperation start];
    
}

// Отправляет на сервер новый PUSH токен
-(void) registerOrUpdateDeviceToken:(NSString*)deviceToken invalidateDeviceToken:(NSString*)invalidDeviceToken   onSuccess:(void (^)(ResponseWrapperModel *response))success onFailure:(void (^)(NSError *error))failure {
    // Модель авторизации
    DevicePushTokenRegisterModel *model = [[DevicePushTokenRegisterModel alloc] init];
    model.devicePushToken = deviceToken;
    model.invalidPushToken = invalidDeviceToken;
    
    RKObjectManager *objectManager = [UserHelper buildObjectManagerForRegisterOrUpdateDeviceToken];
    [objectManager
     postObject:model
     path:@"" //???
     parameters:nil
     success:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
         ResponseWrapperModel *response = (ResponseWrapperModel*)[result.array objectAtIndex:0];

         NSLog(@"Status: %@", response.status);
         NSLog(@"Data: %@", response.data);
         NSLog(@"ErrorCode: %@", response.errorCode);
         NSLog(@"ErrorMessage: %@", response.errorMessage);
         
         success(response);
     }
     failure:^(RKObjectRequestOperation *operation, NSError *error){
         NSLog(@"Error %@", error);
         failure(error);
     }];
    
}


@end
