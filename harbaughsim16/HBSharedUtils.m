//
//  HBSharedUtils.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/18/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "HBSharedUtils.h"
#import "AppDelegate.h"

#import "CSNotificationView.h"
#import "HexColors.h"

#define ARC4RANDOM_MAX      0x100000000
static UIColor *styleColor = nil;

@implementation HBSharedUtils
+(void)initialize {
    if (!styleColor) {
        NSDictionary *themeColorData = [[NSUserDefaults standardUserDefaults] objectForKey:HB_CURRENT_THEME_COLOR];
        if (themeColorData) {
            UIColor *themeColor = [NSKeyedUnarchiver unarchiveObjectWithData:themeColorData[@"color"]];
            styleColor = themeColor;
        } else {
            NSLog(@"NO EXISTING COLORS");
            [[NSUserDefaults standardUserDefaults] setObject:@{@"title" : @"iOS Default", @"color" : [NSKeyedArchiver archivedDataWithRootObject:[UIColor hx_colorWithHexRGBAString:@"#009740"]]} forKey:HB_CURRENT_THEME_COLOR];
            [[NSUserDefaults standardUserDefaults] synchronize];
            styleColor = [UIColor hx_colorWithHexRGBAString:@"#009740"];
        }
    }
}

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
    return styleColor;
}

+(void)setStyleColor:(NSDictionary*)colorDict {
    styleColor = [NSKeyedUnarchiver unarchiveObjectWithData:colorDict[@"color"]];
    [[NSUserDefaults standardUserDefaults] setObject:colorDict forKey:HB_CURRENT_THEME_COLOR];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"newStyleColor" object:nil];
     [((AppDelegate*)[[UIApplication sharedApplication] delegate]) setupAppearance];
    
}

+(NSArray*)colorOptions { //FC Android color: #3EB49F //FC iOS color: #009740 //USA Red: #BB133E // USA Blue: #002147
    return @[
  @{@"title" : @"Android Default", @"color" : [NSKeyedArchiver archivedDataWithRootObject:[UIColor hx_colorWithHexRGBAString:@"#3EB49F"]]},
  @{@"title" : @"iOS Default", @"color" : [NSKeyedArchiver archivedDataWithRootObject:[UIColor hx_colorWithHexRGBAString:@"#009740"]]},
  @{@"title" : @"Old Glory Blue", @"color" : [NSKeyedArchiver archivedDataWithRootObject:[UIColor hx_colorWithHexRGBAString:@"#002147"]]},
  @{@"title" : @"Old Glory Red", @"color" : [NSKeyedArchiver archivedDataWithRootObject:[UIColor hx_colorWithHexRGBAString:@"#BB133E"]]}
             ];
}

+(void)showNotificationWithTintColor:(UIColor*)tintColor message:(NSString*)message onViewController:(UIViewController*)viewController {
    BOOL weekNotifs = [[NSUserDefaults standardUserDefaults] boolForKey:HB_IN_APP_NOTIFICATIONS_TURNED_ON];
    if (weekNotifs) {
        [CSNotificationView showInViewController:viewController tintColor:tintColor image:nil message:message duration:0.5];
    } else {
        NSLog(@"DON'T SEND NOTIFS");
    }
}
@end
