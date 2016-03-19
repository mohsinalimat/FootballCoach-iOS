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
#import "StatisticsViewController.h"
#import "MyTeamViewController.h"
#import "IntroViewController.h"

#import "League.h"

#import "HexColors.h"

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
    
    UINavigationController *statsNav = [[UINavigationController alloc] initWithRootViewController:[[StatisticsViewController alloc] init]];
    statsNav.title = @"Stats";
    statsNav.tabBarItem.image = [UIImage imageNamed:@"stats"];
    
    /*UINavigationController *rosterNav = [[UINavigationController alloc] initWithRootViewController:[[RosterViewController alloc] init]];
    rosterNav.title = @"Roster";
    rosterNav.tabBarItem.image = [UIImage imageNamed:@"roster"];
    rosterNav.tabBarItem.selectedImage = [UIImage imageNamed:@"roster-selected"];
    
    UINavigationController *recruitingNav = [[UINavigationController alloc] initWithRootViewController:[[RecruitingViewController alloc] init]];
    recruitingNav.title = @"Recruiting";
    recruitingNav.tabBarItem.image = [UIImage imageNamed:@"recruit"];
    recruitingNav.tabBarItem.selectedImage = [UIImage imageNamed:@"recruit-selected"];*/
    
    UINavigationController *teamNav = [[UINavigationController alloc] initWithRootViewController:[[MyTeamViewController alloc] init]];
    teamNav.title = @"My Team";
    teamNav.tabBarItem.image = [UIImage imageNamed:@"team"];
    teamNav.tabBarItem.selectedImage = [UIImage imageNamed:@"team-selected"];
    
    [self setupAppearance];
    
    tabBarController.viewControllers = @[newsNav, scheduleNav, statsNav, teamNav];
    [self.window setRootViewController:tabBarController];
    [self.window makeKeyAndVisible];
    
    
    BOOL noFirstLaunch = true;//[[NSUserDefaults standardUserDefaults] boolForKey:kHBSimFirstLaunchKey];
    if (noFirstLaunch) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kHBSimFirstLaunchKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //display intro screen
        [self performSelector:@selector(displayIntro) withObject:nil afterDelay:0.0];
    }

    return YES;
}

-(void)displayIntro {
    UINavigationController *introNav = [[UINavigationController alloc] initWithRootViewController:[[IntroViewController alloc] init]];
    [introNav setNavigationBarHidden:YES];
    [tabBarController presentViewController:introNav animated:YES completion:nil];
}


-(void)setupAppearance {
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UITabBar appearance] setTintColor:[UIColor hx_colorWithHexRGBAString:@"#009740"]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor hx_colorWithHexRGBAString:@"#009740"]];
    self.window.tintColor = [UIColor hx_colorWithHexRGBAString:@"#009740"];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
}

@end
