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

#ifdef DEBUG
#define HBLog( s, ... ) NSLog( @"<%@:%d> %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__,  [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define HBLog( s, ... )
#endif

@interface HBSharedUtils : NSObject
+(double)randomValue;
+(League*)getLeague;
+(UIColor *)styleColor;
+(UIColor *)errorColor;
+(void)setStyleColor:(NSDictionary*)colorDict;
+(NSArray*)colorOptions;
+(void)showNotificationWithTintColor:(UIColor*)tintColor message:(NSString*)message onViewController:(UIViewController*)viewController;
@end
