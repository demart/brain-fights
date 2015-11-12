//
//  AuthorizationRequestModel.h
//  BrainFights
//
//  Created by Artem Demidovich on 11/6/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuthorizationRequestModel : NSObject


@property NSString *login;

@property NSString *password;

@property NSString *deviceType;

@property NSString *devicePushToken;

@property NSString *deviceOsVersion;

@property NSString *appVersion;


/**
 DeviceType:
    IOS,
	
	ANDROID,
	
	WINDOWS_PHONE,
 */

@end
