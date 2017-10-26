//
//  HBSharedUtils.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/18/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "League.h"
#import "HBTeamPlayView.h"

#define HB_IN_APP_NOTIFICATIONS_TURNED_ON @"inAppNotifs"
#define HB_CURRENT_THEME_COLOR @"themeColor"
#define HB_NUMBER_OF_COLOR_OPTIONS 4
#define HB_RECRUITING_TUTORIAL_SHOWN @"kHBTutorialShownKey"
#define HB_ROSTER_TUTORIAL_SHOWN_KEY @"kHBRosterTutorialShownKey"
#define kHBSimFirstLaunchKey @"firstLaunch"
#define HB_OFFSEASON_TUTORIAL_SHOWN_KEY @"kHBOffseasonTutorialShownKey"

#define HB_APP_REVIEW_URL @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1095701497&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software"

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))
#define IS_ZOOMED (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_IPHONE_X (IS_IPHONE && SCREEN_MAX_LENGTH == 812.0)

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

@interface HBSharedUtils : NSObject
+(double)randomValue;
+(League*)getLeague;
+(UIColor *)styleColor;
+(UIColor *)errorColor;
+(UIColor *)successColor;
+(UIColor *)champColor;
+(void)setStyleColor:(NSDictionary*)colorDict;
+(NSArray *)colorOptions;
+(void)showNotificationWithTintColor:(UIColor*)tintColor message:(NSString*)message onViewController:(UIViewController*)viewController;
+(NSString *)randomState;

+(NSComparisonResult)comparePlayers:(id)obj1 toObj2:(id)obj2;
+(NSComparisonResult)comparePositions:(id)obj1 toObj2:(id)obj2;
+(NSComparisonResult)compareDivTeams:(id)obj1 toObj2:(id)obj2;
+(NSComparisonResult)compareMVPScore:(id)obj1 toObj2:(id)obj2;
+(NSComparisonResult)comparePollScore:(id)obj1 toObj2:(id)obj2;
+(NSComparisonResult)compareSoW:(id)obj1 toObj2:(id)obj2;
+(NSComparisonResult)comparePlayoffTeams:(id)obj1 toObj2:(id)obj2;

+(NSComparisonResult)compareTeamPPG:(id)obj1 toObj2:(id)obj2;
+(NSComparisonResult)compareOppPPG:(id)obj1 toObj2:(id)obj2;
+(NSComparisonResult)compareTeamYPG:(id)obj1 toObj2:(id)obj2;
+(NSComparisonResult)compareOppYPG:(id)obj1 toObj2:(id)obj2;
+(NSComparisonResult)compareTeamPYPG:(id)obj1 toObj2:(id)obj2;
+(NSComparisonResult)compareOppPYPG:(id)obj1 toObj2:(id)obj2;
+(NSComparisonResult)compareTeamRYPG:(id)obj1 toObj2:(id)obj2;
+(NSComparisonResult)compareOppRYPG:(id)obj1 toObj2:(id)obj2;

+(NSComparisonResult)compareTeamTODiff:(id)obj1 toObj2:(id)obj2;
+(NSComparisonResult)compareTeamOffTalent:(id)obj1 toObj2:(id)obj2;
+(NSComparisonResult)compareTeamDefTalent:(id)obj1 toObj2:(id)obj2;
+(NSComparisonResult)compareTeamPrestige:(id)obj1 toObj2:(id)obj2;
+(NSComparisonResult)compareTeamLeastWins:(id)obj1 toObj2:(id)obj2;

+(void)simulateEntireSeason:(int)weekTotal viewController:(UIViewController*)viewController headerView:(HBTeamPlayView*)teamHeaderView callback:(void (^)(void))callback;
+(void)playWeek:(UIViewController*)viewController headerView:(HBTeamPlayView*)teamHeaderView callback:(void (^)(void))callback;

@end
