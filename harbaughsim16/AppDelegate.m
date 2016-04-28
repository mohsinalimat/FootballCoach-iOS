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
#import "MyTeamViewController.h"
#import "IntroViewController.h"
#import "TeamSearchViewController.h"

#import "League.h"

#import "HexColors.h"
#import "STPopup.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>


#define kHBSimFirstLaunchKey @"firstLaunch"

@interface AppDelegate ()
{
    UITabBarController *tabBarController;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    tabBarController = [[UITabBarController alloc] init];
    UINavigationController *newsNav = [[UINavigationController alloc] initWithRootViewController:[[NewsViewController alloc] init]];
    newsNav.title = @"Latest News";
    newsNav.tabBarItem.image = [UIImage imageNamed:@"news"];
    newsNav.tabBarItem.selectedImage = [UIImage imageNamed:@"news-selected"];
    
    UINavigationController *scheduleNav = [[UINavigationController alloc] initWithRootViewController:[[ScheduleViewController alloc] init]];
    scheduleNav.title = @"Schedule";
    scheduleNav.tabBarItem.image = [UIImage imageNamed:@"schedule"];
    scheduleNav.tabBarItem.selectedImage = [UIImage imageNamed:@"schedule-selected"];
    
    UINavigationController *rosterNav = [[UINavigationController alloc] initWithRootViewController:[[RosterViewController alloc] init]];
    rosterNav.title = @"Depth Chart";
    rosterNav.tabBarItem.image = [UIImage imageNamed:@"roster"];
    rosterNav.tabBarItem.selectedImage = [UIImage imageNamed:@"roster-selected"];
    
    UINavigationController *searchNav = [[UINavigationController alloc] initWithRootViewController:[[TeamSearchViewController alloc] init]];
    searchNav.title = @"Search";
    searchNav.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemSearch tag:3];
    
    UINavigationController *teamNav = [[UINavigationController alloc] initWithRootViewController:[[MyTeamViewController alloc] init]];
    teamNav.title = @"My Team";
    teamNav.tabBarItem.image = [UIImage imageNamed:@"team"];
    teamNav.tabBarItem.selectedImage = [UIImage imageNamed:@"team-selected"];
    
    [self setupAppearance];
    
    tabBarController.viewControllers = @[newsNav, scheduleNav, rosterNav, searchNav, teamNav];
    [self.window setRootViewController:tabBarController];
    [self.window makeKeyAndVisible];
    
    
    BOOL noFirstLaunch = [[NSUserDefaults standardUserDefaults] boolForKey:kHBSimFirstLaunchKey];
    BOOL loadSavedData = [League loadSavedData];
    if (!noFirstLaunch || !loadSavedData) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kHBSimFirstLaunchKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:HB_IN_APP_NOTIFICATIONS_TURNED_ON];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //display intro screen
        [self performSelector:@selector(displayIntro) withObject:nil afterDelay:0.0];
    }
    
    [Fabric with:@[[Crashlytics class]]];
    return YES;
}

-(void)displayIntro {
    UINavigationController *introNav = [[UINavigationController alloc] initWithRootViewController:[[IntroViewController alloc] init]];
    [introNav setNavigationBarHidden:YES];
    [tabBarController presentViewController:introNav animated:YES completion:nil];
}


-(void)setupAppearance {
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UITabBar appearance] setTintColor:[HBSharedUtils styleColor]];
    [[UINavigationBar appearance] setBarTintColor:[HBSharedUtils styleColor]];
    self.window.tintColor = [HBSharedUtils styleColor];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [[UIToolbar appearance] setBarTintColor:[HBSharedUtils styleColor]];
    [[UIToolbar appearance] setTintColor:[UIColor whiteColor]];
    
    [STPopupNavigationBar appearance].barTintColor = [HBSharedUtils styleColor];
    [STPopupNavigationBar appearance].tintColor = [UIColor whiteColor];
    [STPopupNavigationBar appearance].barStyle = UIBarStyleDefault;
    
}

@end
