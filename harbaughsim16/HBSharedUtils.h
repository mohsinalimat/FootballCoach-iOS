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

#define HB_IN_APP_NOTIFICATIONS_TURNED_ON @"inAppNotifs"
#define HB_CURRENT_THEME_COLOR @"themeColor"
#define HB_NUMBER_OF_COLOR_OPTIONS 4
#define HB_RECRUITING_TUTORIAL_SHOWN @"kHBTutorialShownKey"
#define HB_ROSTER_TUTORIAL_SHOWN_KEY @"kHBRosterTutorialShownKey"

#define HB_APP_REVIEW_URL @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1095701497&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software"

@interface HBSharedUtils : NSObject
+(double)randomValue;
+(League*)getLeague;
+(UIColor *)styleColor;
+(UIColor *)errorColor;
+(UIColor *)successColor;
+(UIColor*)champColor;
+(void)setStyleColor:(NSDictionary*)colorDict;
+(NSArray*)colorOptions;
+(void)showNotificationWithTintColor:(UIColor*)tintColor message:(NSString*)message onViewController:(UIViewController*)viewController;
@end
