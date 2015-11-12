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


@interface AppDelegate ()

@property (nonatomic, strong, readonly) UIStoryboard *authorizationStoryboard;

@property (nonatomic, strong, readonly) UIStoryboard *drawersStoryboard;

@end

@implementation AppDelegate

@synthesize drawersStoryboard = _drawersStoryboard;
@synthesize authorizationStoryboard = _authorizationStoryboard;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self initDesignScheme];
    
    return YES;
}


-(void) initDesignScheme {
    
    [[UINavigationBar appearance] setBarTintColor: [Constants SYSTEM_COLOR_GREEN]];
    [UINavigationBar appearance].tintColor = [Constants SYSTEM_COLOR_WHITE];
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
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = self.drawerViewController;

    self.drawerViewController.leftViewController = self.leftDrawerViewController;
    self.drawerViewController.centerViewController = self.gameMainViewController;
    self.drawerViewController.animator = self.drawerAnimator;
    
    self.drawerViewController.backgroundImage = [AppDelegate imageFromColor:[Constants SYSTEM_COLOR_GREEN]];
    
    [self.window makeKeyAndVisible];
}

+ (UIImage *)imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
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




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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
