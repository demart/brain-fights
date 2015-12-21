//
//  AppDelegate.m
//  BrainFights
//
//  Created by Artem Demidovich on 11/6/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import "AppDelegate.h"
#import "JVFloatingDrawerViewController.h"
#import "JVFloatingDrawerSpringAnimator.h"

#import "SignInViewController.h"

#import "../LNNotificationsUI/LNNotificationsUI/LNNotificationsUI.h"

// Название StoryBoard
static NSString * const MenuDrawersStoryboardName = @"Main";

static NSString * const AuthorizationStoryboardName = @"Authorization";


// ===== AUTHORIZATION STORYBOARD ====

static NSString * const SignInViewStoryboardID = @"SignInViewStoryboardID";

// ===== DRAWER STORYBOARD ============

// Идентификатор бокового меню
static NSString * const MenuLeftFloatingViewStoryboardID = @"MenuLeftFloatingViewStoryboardID";

// Идентификатор главной страницы со списком игр
static NSString * const GameMainViewControllerStoryboardID = @"GameMainViewControllerStoryboardID";

// Идентификатор профиля пользователя
static NSString * const UserProfileViewControllerStoryboardID = @"UserProfileViewControllerStoryboardID";

// Идентификатор рейтинга пользователей и орг структур
static NSString * const RatingViewControllerStoryboardID = @"RatingViewControllerStoryboardID";

// Идентификатор о приложении
static NSString * const AboutViewControllerStoryboardID = @"AboutViewControllerStoryboardID";

@interface AppDelegate ()

@property (nonatomic, strong, readonly) UIStoryboard *authorizationStoryboard;

@property (nonatomic, strong, readonly) UIStoryboard *drawersStoryboard;

@end

@implementation AppDelegate

@synthesize drawersStoryboard = _drawersStoryboard;
@synthesize authorizationStoryboard = _authorizationStoryboard;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self initDesignScheme];
    
    [[LNNotificationCenter defaultCenter] registerApplicationWithIdentifier:@"games" name:@"GREEn" icon:[UIImage imageNamed:@"AppNotificationIcon"] defaultSettings:LNNotificationDefaultAppSettings];
    
    return YES;
}


-(void) initDesignScheme {
    
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setBarTintColor: [Constants SYSTEM_COLOR_GREEN]];
    [UINavigationBar appearance].tintColor = [Constants SYSTEM_COLOR_WHITE];
    [[UINavigationBar appearance] setTranslucent:NO];
    [UIButton appearance].layer.cornerRadius = 2.0f;
    
    
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [Constants SYSTEM_COLOR_WHITE], NSForegroundColorAttributeName,
      //[UIFont fontWithName:@"Gill Sans" size:17.0], NSFontAttributeName,
      nil]];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[Constants SYSTEM_COLOR_WHITE],
       //NSFontAttributeName: [UIFont fontWithName:@"Gill Sans" size:17.0]
       } forState:UIControlStateNormal];
    
    [[UISearchBar appearance] setBarTintColor: [Constants SYSTEM_COLOR_GREEN]];
    [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:[UIColor whiteColor]];
    
}

- (void) initDrawerMenu {
    //self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = self.drawerViewController;

    self.drawerViewController.backgroundImage = [Constants imageFromColor: [Constants SYSTEM_COLOR_GREEN]];
//    self.drawerViewController.centerViewController = self.gameMainViewController;
    self.drawerViewController.leftViewController = self.leftDrawerViewController;
    self.drawerViewController.animator = self.drawerAnimator;

    [UIView animateWithDuration:.5
                     animations:^{
                         [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                         self.drawerViewController.centerViewController = self.gameMainViewController;
                         [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.window.rootViewController.view cache:NO];
                     }];

    //[self.window makeKeyAndVisible];
    // Подаписываемся на получение пуш уведомлений
    [NotificationService registerForRemoteNotification];
}


-(void) showAuthorizationView:(UIViewController*) parentController {
     SignInViewController *signInViewController = [[self authorizationStoryboard] instantiateViewControllerWithIdentifier:SignInViewStoryboardID];
    [signInViewController setReturnViewController:parentController];
    [parentController presentViewController:signInViewController animated:YES completion:nil];
}


- (UIStoryboard *)authorizationStoryboard {
    if(!_authorizationStoryboard)
        _authorizationStoryboard = [UIStoryboard storyboardWithName:AuthorizationStoryboardName bundle:nil];
    return _authorizationStoryboard;
}

- (UIStoryboard *)drawersStoryboard {
    if(!_drawersStoryboard) {
        _drawersStoryboard = [UIStoryboard storyboardWithName:MenuDrawersStoryboardName bundle:nil];
    }
    
    return _drawersStoryboard;
}


- (JVFloatingDrawerViewController *)drawerViewController {
    if (!_drawerViewController)
        _drawerViewController = [[JVFloatingDrawerViewController alloc] init];
    return _drawerViewController;
}

- (JVFloatingDrawerSpringAnimator *)drawerAnimator {
    if (!_drawerAnimator)
        _drawerAnimator = [[JVFloatingDrawerSpringAnimator alloc] init];
    return _drawerAnimator;
}

- (UITableViewController *)leftDrawerViewController {
    if (!_leftDrawerViewController)
        _leftDrawerViewController = [self.drawersStoryboard instantiateViewControllerWithIdentifier:MenuLeftFloatingViewStoryboardID];
    
    return _leftDrawerViewController;
}


#pragma Center Scenes

// Сцена со списком игр (главный скрин)
- (UIViewController *)gameMainViewController {
    if (!_gameMainViewController)
        _gameMainViewController = [self.drawersStoryboard instantiateViewControllerWithIdentifier:GameMainViewControllerStoryboardID];
    return _gameMainViewController;
}

// Сцена со списком игр (главный скрин)
- (UIViewController *)profileViewController {
    if (!_profileViewController)
        _profileViewController = [self.drawersStoryboard instantiateViewControllerWithIdentifier:UserProfileViewControllerStoryboardID];
    return _profileViewController;
}

// Сцена рейтинга
- (UIViewController *)ratingViewController {
    if (!_ratingViewController)
        _ratingViewController = [self.drawersStoryboard instantiateViewControllerWithIdentifier:RatingViewControllerStoryboardID];
    return _ratingViewController;
}


// Сцена рейтинга
- (UIViewController *)aboutViewController {
    if (!_aboutViewController)
        _aboutViewController = [self.drawersStoryboard instantiateViewControllerWithIdentifier:AboutViewControllerStoryboardID];
    return _aboutViewController;
}


/// =========================
/// === NOTIFICATIONS =======
/// =========================

// ================
//   NOTFICATIONS
// ================

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [NotificationService application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    [NotificationService application:application didFailToRegisterForRemoteNotificationsWithError:error];
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [NotificationService application:application didRegisterUserNotificationSettings:notificationSettings];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [NotificationService application:application didReceiveRemoteNotification:userInfo];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [NotificationService application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
}

// ================
//   APPLICATAIONS
// ================

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

#pragma mark - Global Access Helper

+ (AppDelegate *)globalDelegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (void)toggleLeftDrawer:(id)sender animated:(BOOL)animated {
    [self.drawerViewController toggleDrawerWithSide:JVFloatingDrawerSideLeft animated:animated completion:nil];
}

- (void)toggleRightDrawer:(id)sender animated:(BOOL)animated {
    [self.drawerViewController toggleDrawerWithSide:JVFloatingDrawerSideRight animated:animated completion:nil];
}


@end
