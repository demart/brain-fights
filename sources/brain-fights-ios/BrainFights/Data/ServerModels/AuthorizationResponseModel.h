//
//  AuthorizationResponseModel.h
//  BrainFights
//
//  Created by Artem Demidovich on 11/6/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UserProfileModel.h"

@interface AuthorizationResponseModel : NSObject

/**
 * Токен авторизации для обращения к резурсам
 */
@property NSString *authToken;

/**
 * Профиль пользователя
 */
@property UserProfileModel *userProfile;


@end
