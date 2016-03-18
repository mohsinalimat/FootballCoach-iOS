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

#import "HexColors.h"

#define kHBSimFirstLaunchKey @"firstLaunch"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    UINavigationController *newsNav = [[UINavigationController alloc] initWithRootViewController:[[NewsViewController alloc] init]];
    newsNav.title = @"Latest News";
    newsNav.tabBarItem.image = [UIImage imageNamed:@"news"];
    newsNav.tabBarItem.selectedImage = [UIImage imageNamed:@"news-selected"];
    
    UINavigationController *scheduleNav = [[UINavigationController alloc] initWithRootViewController:[[ScheduleViewController alloc] init]];
    scheduleNav.title = @"Schedule";
    scheduleNav.tabBarItem.image = [UIImage imageNamed:@"schedule"];
    scheduleNav.tabBarItem.selectedImage = [UIImage imageNamed:@"schedule-selected"];
    
    UINavigationController *rosterNav = [[UINavigationController alloc] initWithRootViewController:[[RosterViewController alloc] init]];
    rosterNav.title = @"Roster";
    rosterNav.tabBarItem.image = [UIImage imageNamed:@"roster"];
    rosterNav.tabBarItem.selectedImage = [UIImage imageNamed:@"roster-selected"];
    
    UINavigationController *recruitingNav = [[UINavigationController alloc] initWithRootViewController:[[RecruitingViewController alloc] init]];
    recruitingNav.title = @"Recruiting";
    recruitingNav.tabBarItem.image = [UIImage imageNamed:@"recruit"];
    recruitingNav.tabBarItem.selectedImage = [UIImage imageNamed:@"recruit-selected"];
    
    UINavigationController *teamNav = [[UINavigationController alloc] initWithRootViewController:[[MyTeamViewController alloc] init]];
    teamNav.title = @"My Team";
    teamNav.tabBarItem.image = [UIImage imageNamed:@"team"];
    teamNav.tabBarItem.selectedImage = [UIImage imageNamed:@"team-selected"];
    
    [self setupAppearance];
    
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


-(void)setupAppearance {
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    //[[UITabBar appearance] setBarTintColor:[UIColor blackColor]];
    //[[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    //[[UITabBar appearance] setBarStyle:UIBarStyleBlack];
    [[UITabBar appearance] setTintColor:[UIColor hx_colorWithHexRGBAString:@"#009740"]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor hx_colorWithHexRGBAString:@"#009740"]];
    self.window.tintColor = [UIColor hx_colorWithHexRGBAString:@"#009740"];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
}


@end
