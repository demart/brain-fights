//
//  AppDelegate.h
//  BrainFights
//
//  Created by Artem Demidovich on 11/6/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UrlHelper.h"
#import "Constants.h"
#import "NotificationService.h"
#import "ErrorViewController.h"

@class JVFloatingDrawerViewController;
@class JVFloatingDrawerSpringAnimator;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) JVFloatingDrawerViewController *drawerViewController;
@property (nonatomic, strong) JVFloatingDrawerSpringAnimator *drawerAnimator;

@property (nonatomic, strong) UITableViewController *leftDrawerViewController;

// Стартовый экран загрузки приложения (авторизован или нет)
@property (nonatomic, strong) UIViewController *loadingViewController;

// Скрин со списком игр (главный экран)
@property (nonatomic, strong) UIViewController *gameMainViewController;

// Скрин профиля в игре
@property (nonatomic, strong) UIViewController *profileViewController;

// Скрин рейтинга
@property (nonatomic, strong) UIViewController *ratingViewController;

// Скрин рейтинга
@property (nonatomic, strong) UIViewController *authorizationViewController;

// Скрин о программе
@property (nonatomic, strong) UIViewController *aboutViewController;

+ (AppDelegate *)globalDelegate;

- (UIStoryboard *)drawersStoryboard;
- (void) initDrawerMenu;
-(void) showAuthorizationView:(UIViewController*) parentController;

- (void)toggleLeftDrawer:(id)sender animated:(BOOL)animated;
- (void)toggleRightDrawer:(id)sender animated:(BOOL)animated;


@end

