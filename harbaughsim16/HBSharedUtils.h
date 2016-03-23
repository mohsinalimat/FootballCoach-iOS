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

@interface HBSharedUtils : NSObject
+(double)randomValue;
+(League*)getLeague;
+(UIColor *)styleColor;
+(void)showNotificationWithTintColor:(UIColor*)tintColor message:(NSString*)message onViewController:(UIViewController*)viewController;
@end
