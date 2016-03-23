//
//  HBSharedUtils.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/18/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "HBSharedUtils.h"
#import "AppDelegate.h"
#import "HexColors.h"

#import "CSNotificationView.h"

#define ARC4RANDOM_MAX      0x100000000

@implementation HBSharedUtils

+(double)randomValue {
    return ((double)arc4random() / ARC4RANDOM_MAX);
}

+(League*)getLeague {
    return [((AppDelegate*)[[UIApplication sharedApplication] delegate]) league];
}

+(int)leagueRecruitingStage {
    return [HBSharedUtils getLeague].recruitingStage;
}

+(UIColor *)styleColor {
    return [UIColor hx_colorWithHexRGBAString:@"#009740"]; //FC Android color: #3EB49F //FC iOS color: #009740
}

+(void)showNotificationWithTintColor:(UIColor*)tintColor message:(NSString*)message onViewController:(UIViewController*)viewController {
    BOOL weekNotifs = [[NSUserDefaults standardUserDefaults] boolForKey:HB_IN_APP_NOTIFICATIONS_TURNED_ON];
    if (!weekNotifs) {
        [CSNotificationView showInViewController:viewController tintColor:tintColor image:nil message:message duration:0.5];
    } else {
        NSLog(@"DON'T SEND NOTIFS");
    }
}
@end
