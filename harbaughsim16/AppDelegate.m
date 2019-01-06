//
//  AppDelegate.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/16/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "AppDelegate.h"
#import "UpcomingViewController.h"
#import "ScheduleViewController.h"
#import "RosterViewController.h"
#import "MyTeamViewController.h"
#import "IntroViewController.h"
#import "TeamSearchViewController.h"
#import "MyCareerViewController.h"

#import "League.h"
#import "LeagueUpdater.h"

#import "HexColors.h"
#import "STPopup.h"
#import "RMessage.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "ATAppUpdater.h"
#import "FCFileManager.h"
#import "ZGNavigationTitleView.h"
//#import "harbaughsim16-Swift.h"

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
    UINavigationController *newsNav = [[UINavigationController alloc] initWithRootViewController:[[UpcomingViewController alloc] initWithNibName:@"UpcomingViewController" bundle:nil]];
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
    } else {
        if (_league.leagueVersion == nil || [LeagueUpdater needsUpdateFromVersion:_league.leagueVersion toVersion:HB_CURRENT_APP_VERSION]) {
            //NSLog(@"Current league version: %@", _league.leagueVersion);
            [self startSaveFileUpdate];
        }
        
        if (_league.isCareerMode) {
            [self updateTabBarForCareer];
        }
        
        //check if data file is corrupt, alert user
        if ([[HBSharedUtils currentLeague] isSaveCorrupt]) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Corrupt Save File" message:@"Your save file may be corrupt. Please delete it and restart to ensure you do not experience any crashes." preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
            [tabBarController presentViewController:alertController animated:YES completion:nil];
        } else if (![[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"me.akeaswaran.harbaughsim16"]) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Unofficial Build" message:@"You are using an unofficial build of College Football Coach. In order to ensure you get the latest bug fixes and features, please install the official version." preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Go to App Store" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/college-football-coach/id1095701497?ls=1&mt=8"] options:@{} completionHandler:nil];
            }]];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Continue playing" style:UIAlertActionStyleCancel handler:nil]];
            [tabBarController presentViewController:alertController animated:YES completion:nil];
        }
    }
    
    [Fabric with:@[CrashlyticsKit]];
    [[ATAppUpdater sharedUpdater] showUpdateWithConfirmation];
    return YES;
}

-(void)displayIntro {
    UINavigationController *introNav = [[UINavigationController alloc] initWithRootViewController:[[IntroViewController alloc] init]];
    [introNav setNavigationBarHidden:YES];
    [tabBarController presentViewController:introNav animated:YES completion:nil];
}

-(void)startSaveFileUpdate {
    UIAlertController *convertAlertPerm = [UIAlertController alertControllerWithTitle:@"Save File Update Required" message:[NSString stringWithFormat:@"Version %@ requires an update to your save file in order to ensure compatability.", HB_CURRENT_APP_VERSION] preferredStyle:UIAlertControllerStyleAlert];
    [convertAlertPerm addAction:[UIAlertAction actionWithTitle:@"Proceed" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIAlertController *convertProgressAlert = [UIAlertController alertControllerWithTitle:@"Save File Update in Progress" message:@"Updating save file..." preferredStyle:UIAlertControllerStyleAlert];
        UIProgressView *convertProgressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        [convertProgressView setProgress:0.0 animated:YES];
        convertProgressView.tintColor = [HBSharedUtils styleColor];
        convertProgressView.frame = CGRectMake(10, 70, 250, 0);
        [convertProgressAlert.view addSubview:convertProgressView];
        
        __block League *oldLigue = self->_league;
        
        [LeagueUpdater convertLeagueFromOldVersion:oldLigue updatingBlock:^(float progress, NSString * _Nullable updateStatus) {
            convertProgressAlert.message = updateStatus;
            [convertProgressView setProgress:progress animated:YES];
        } completionBlock:^(BOOL success, NSString * _Nullable finalStatus, League * _Nonnull ligue) {
            convertProgressView.progress = 1.0;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.00 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [convertProgressView removeFromSuperview];
                convertProgressAlert.title = finalStatus;
                if ([LeagueUpdater needsUpdateFromVersion:oldLigue.leagueVersion toVersion:@"2.0"]) {
                    convertProgressAlert.message = @"Please be aware that each school in your save file has been assigned a random home state. This will only have an effect in recruiting. If you want to change this, please edit teams before starting recruiting in the next offseason.";
                } else { // 2.0.x -> 2.1.x
                    convertProgressAlert.message = [NSString stringWithFormat:@"Your save file has been updated for use in version %@!", HB_CURRENT_APP_VERSION];
                }
                [convertProgressAlert addAction:[UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:nil]];
                self->_league = ligue;
                [self->_league save];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"saveFileUpdate" object:nil];
            });
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self->tabBarController presentViewController:convertProgressAlert animated:YES completion:nil];
        });
    }]];
    
    [convertAlertPerm addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        UIAlertController *dangerAlert = [UIAlertController alertControllerWithTitle:@"Are you sure?" message:@"If your save file can not be updated, then it must be deleted to ensure compatibility with new game functionality. Are you sure you wish to proceed with deletion?" preferredStyle:UIAlertControllerStyleAlert];
        [dangerAlert addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            BOOL success = [FCFileManager removeItemAtPath:@"league.cfb"];
            if (success) {
                self->_league.userTeam = nil;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"noSaveFile" object:nil];
                    [self displayIntro];
                });
            }
        }]];
        [dangerAlert addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self startSaveFileUpdate];
        }]];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self->tabBarController presentViewController:dangerAlert animated:YES completion:nil];
        });
    }]];
    
    [tabBarController presentViewController:convertAlertPerm animated:YES completion:nil];
}

-(void)startNewSaveFile {
    BOOL success = [FCFileManager removeItemAtPath:@"league.cfb"];
    if (success) {
        self->_league.userTeam = nil;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"noSaveFile" object:nil];
            [self displayIntro];
        });
    }
}

-(void)updateTabBarForCareer {
    UINavigationController *teamNav = [[UINavigationController alloc] initWithRootViewController:[[MyCareerViewController alloc] init]];
    teamNav.title = @"Career";
    teamNav.tabBarItem.image = [UIImage imageNamed:@"coach-unselected"];
    teamNav.tabBarItem.selectedImage = [UIImage imageNamed:@"coach"];
    NSMutableArray *navs = [NSMutableArray arrayWithArray:tabBarController.viewControllers];
    [navs removeLastObject];
    [navs addObject:teamNav];
    tabBarController.viewControllers = navs;
}


-(void)setupAppearance {
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    //[[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    [[UITabBar appearance] setTintColor:[HBSharedUtils styleColor]];
    [[UINavigationBar appearance] setBarTintColor:[HBSharedUtils styleColor]];
    self.window.tintColor = [HBSharedUtils styleColor];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [[UIToolbar appearance] setBarTintColor:[HBSharedUtils styleColor]];
    [[UIToolbar appearance] setTintColor:[UIColor whiteColor]];
    
    [STPopupNavigationBar appearance].barTintColor = [HBSharedUtils styleColor];
    [STPopupNavigationBar appearance].tintColor = [UIColor whiteColor];
    [STPopupNavigationBar appearance].barStyle = UIBarStyleDefault;
    
    [[ZGNavigationTitleView appearance] setNavigationBarTitleFont:[UIFont systemFontOfSize:17.0 weight:UIFontWeightSemibold]];
    [[ZGNavigationTitleView appearance] setNavigationBarTitleFontColor:[UIColor whiteColor]];
    
    [[ZGNavigationTitleView appearance] setNavigationBarSubtitleFont:[UIFont systemFontOfSize:12.0]];
    [[ZGNavigationTitleView appearance] setNavigationBarSubtitleFontColor:[UIColor lightTextColor]];
    
    
    [RMessage addDesignsFromFileWithName:@"alt-designs" inBundle:[NSBundle mainBundle]];

}

@end
