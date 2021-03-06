//
//  AppDelegate.m
//  Charity Search
//
//  Created by Chelsea Liu on 7/1/15.
//  Copyright (c) 2015 Chelsea Liu. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "Key.h"
#import "HomeViewController.h"
#import "ProfileViewController.h"
#import "NewsMainViewController.h"
#import "PopularCharitiesViewController.h"
#import "LoginViewController.h"
#import "CharityData.h"
#import "UIImage+ResizedIcon.h"


@interface AppDelegate () <UITabBarControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // [Optional] Power your app with Local Datastore. For more info, go to
    // https://parse.com/docs/ios_guide#localdatastore/iOS
    [Parse enableLocalDatastore];
    
    // Initialize Parse.
    [Parse setApplicationId:[NSString stringWithFormat:@"%@", APPLICATION_ID]
                  clientKey:[NSString stringWithFormat:@"%@", CLIENT_KEY]];
    
    // [Optional] Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    
    HomeViewController *homeController = (HomeViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"Home"];
    ProfileViewController *profileController = (ProfileViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"Profile"];
    PopularCharitiesViewController *charityController = (PopularCharitiesViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"Charities"];
    NewsMainViewController *categoriesController = (NewsMainViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"News"];

    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:homeController];
    UINavigationController *profileNav = [[UINavigationController alloc] initWithRootViewController:profileController];
    UINavigationController *charityNav = [[UINavigationController alloc] initWithRootViewController:charityController];
    UINavigationController *categoriesNav = [[UINavigationController alloc] initWithRootViewController:categoriesController];
    
    homeController.tabBarItem.title = @"Home";
    homeController.tabBarItem.image = [UIImage resizeTabIcon:[UIImage imageNamed:@"home.png"] withX:30 andY:30];
    
    profileController.tabBarItem.title = @"Profile";
    profileController.tabBarItem.image = [UIImage resizeTabIcon:[UIImage imageNamed:@"profile.png"] withX:30 andY:30];

    categoriesController.tabBarItem.title = @"News";
    categoriesController.tabBarItem.image = [UIImage resizeTabIcon:[UIImage imageNamed:@"news.png"] withX:30 andY:30];
    
    charityController.tabBarItem.title = @"Suggested";
    charityController.tabBarItem.image = [UIImage resizeTabIcon:[UIImage imageNamed:@"suggested.png"] withX:30 andY:30];
    
    NSMutableArray* allControllers = [NSMutableArray arrayWithObjects: homeNav, categoriesNav, charityNav, nil];
//    tabBarController.tabBar.contentMode = UIViewContentModeScaleAspectFit;
    tabBarController.tabBar.autoresizesSubviews = NO;
    tabBarController.tabBar.clipsToBounds = YES;

    if ([User currentUser] != nil) {
        [allControllers addObject:profileNav];
    }
    
    tabBarController.viewControllers = allControllers;
    tabBarController.tabBar.barTintColor = [UIColor blackColor];
    tabBarController.tabBar.tintColor = [UIColor whiteColor];
    
    
    //Add the tab bar controller to the window
 
    [self.window setRootViewController:tabBarController];
    //[CharityData getCharityObjects];
    
    [tabBarController setDelegate:self];
    
    return YES;
}


-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
    for (UINavigationController *navController in tabBarController.viewControllers) {
        
        if ([tabBarController selectedViewController] == navController) {
            [navController popToRootViewControllerAnimated:NO];
        }
    }
    
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

@end
