//
//  NotificationService.h
//  BrainFights
//
//  Created by Artem Demidovich on 11/21/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "LocalStorageService.h"
#import "UserService.h"

static NSString* SYSTEM_DEVICE_TOKEN_SYNCHRONIZED = @"system.push.sycnc";
static NSString* SYSTEM_DEVICE_TOKEN = @"system.push.token";
static NSString* SYSTEM_DEVICE_TOKEN_OLD = @"system.push.token.old";

@interface NotificationService : NSObject

+ (void) registerForRemoteNotification;

+ (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;

+ (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;
+ (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings;

+ (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))handler;

+ (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo;


@end
