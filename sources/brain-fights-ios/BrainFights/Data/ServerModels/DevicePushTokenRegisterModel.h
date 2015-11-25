//
//  DevicePushTokenRegisterModel.h
//  BrainFights
//
//  Created by Artem Demidovich on 11/21/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DevicePushTokenRegisterModel : NSObject

/**
 * Token
 */
@property NSString* devicePushToken;

/**
 * Старый токен который был ассоциирован с указанным телефоном и учетной записью
 */
@property NSString* invalidPushToken;

@end
