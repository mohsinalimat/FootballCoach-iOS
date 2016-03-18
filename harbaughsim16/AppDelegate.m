//
//  AppDelegate.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/16/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "AppDelegate.h"
#import "NewsViewController.h"
#import "ScheduleViewController.h"
#import "RosterViewController.h"
#import "RecruitingViewController.h"
#import "MyTeamViewController.h"

#define kHBSimFirstLaunchKey @"firstLaunch"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    UINavigationController *newsNav = [[UINavigationController alloc] initWithRootViewController:[[NewsViewController alloc] init]];
    UINavigationController *scheduleNav = [[UINavigationController alloc] initWithRootViewController:[[ScheduleViewController alloc] init]];
    UINavigationController *rosterNav = [[UINavigationController alloc] initWithRootViewController:[[RosterViewController alloc] init]];
    UINavigationController *recruitingNav = [[UINavigationController alloc] initWithRootViewController:[[RecruitingViewController alloc] init]];
    UINavigationController *teamNav = [[UINavigationController alloc] initWithRootViewController:[[MyTeamViewController alloc] init]];
    
    
    tabBarController.viewControllers = @[newsNav, scheduleNav, rosterNav, recruitingNav, teamNav];
    [self.window setRootViewController:tabBarController];
    [self.window makeKeyAndVisible];
    
    
    BOOL noFirstLaunch = [[NSUserDefaults standardUserDefaults] boolForKey:kHBSimFirstLaunchKey];
    if (noFirstLaunch) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kHBSimFirstLaunchKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //display intro screen
    }
    
    
    
    return YES;
}


@end
