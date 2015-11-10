//
//  AuthorizationHelper.h
//  BrainFights
//
//  Created by Artem Demidovich on 11/7/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AuthorizationRequestModel.h"

#import "RKObjectManager.h"
#import "RKObjectMapping.h"
#import "RKResponseDescriptor.h"
#import "RKObjectRequestOperation.h"
#import "RKRelationshipMapping.h"
#import "RKRequestDescriptor.h"
#import "RKLog.h"
#import "RKMIMETypes.h"

@interface AuthorizationHelper : NSObject

// Строит модель авторизации
+ (AuthorizationRequestModel*) buildAuthorizationRequestModel:(NSString*) login withPassword:(NSString*)password;

// Строит модель для запросов авторизации
+ (RKObjectManager*) buildObjectManagerForSignIn;

// Строит модель для запросов профиля авторизованного пользователя
+ (RKResponseDescriptor*) buildResponseDescriptorForUserProfile;

@end
