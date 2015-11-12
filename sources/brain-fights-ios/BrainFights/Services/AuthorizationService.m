//
//  AuthorizationService.m
//  BrainFights
//
//  Created by Artem Demidovich on 11/6/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import "AuthorizationService.h"

#import "AuthorizationHelper.h"
#import "LocalStorageService.h"
#import "ResponseWrapperModel.h"
#import "UrlHelper.h"

@implementation AuthorizationService

+ (BOOL) isAuthTokenExisit {
    if ([LocalStorageService getSettingsValueByKey:AUTH_TOKEN] == nil)
        return NO;
    return YES;
}

// Возвращает токен авторизации
+ (NSString*) getAuthToken {
    return (NSString*)[LocalStorageService getSettingsValueByKey:AUTH_TOKEN];
}


// Авторизовывает пользователя
+ (void) authorizeUserAsync:(NSString*)login withPassword:(NSString*)password onSuccess:(void (^)(ResponseWrapperModel *response))success onFailure:(void (^)(NSError *error))failure {
    
    // Модель авторизации
    AuthorizationRequestModel *model = [AuthorizationHelper buildAuthorizationRequestModel:login withPassword:password];
    
    RKObjectManager *objectManager = [AuthorizationHelper buildObjectManagerForSignIn];
    [objectManager
     postObject:model
     path:@"auth"
     parameters:nil
     success:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
         ResponseWrapperModel *response = (ResponseWrapperModel*)[result.array objectAtIndex:0];
         
         //NSString* status = [[result.array objectAtIndex:0] valueForKey:@"status"];
        
         //NSString* errorCode = [[result.array objectAtIndex:0] valueForKey:@"errorCode"];
         //NSString* errorMessage = [[result.array objectAtIndex:0] valueForKey:@"errorMessage"];
         
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

// Загружаем профиль пользователя с сервера
+ (void) retrieveUserProfileAsync:(void (^)(ResponseWrapperModel *response))success onFailure:(void (^)(NSError *error))failure{
    
    NSString* authToken = [AuthorizationService getAuthToken];
    
    if (authToken == nil) {
        failure(nil);
    }
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:[UrlHelper userProfileUrl]] ];
    
    RKResponseDescriptor *responseWrapperDescriptor = [AuthorizationHelper buildResponseDescriptorForUserProfile];
    
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

@end
