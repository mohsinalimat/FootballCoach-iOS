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

#define ARC4RANDOM_MAX      0x100000000

@implementation HBSharedUtils
+(double)randomValue {
    return ((double)arc4random() / ARC4RANDOM_MAX);
}

+(League*)getLeague {
    return [((AppDelegate*)[[UIApplication sharedApplication] delegate]) league];
}

+(UIColor *)styleColor {
    return [UIColor hx_colorWithHexRGBAString:@"#009740"]; //FC Android color: #3EB49F
}
@end
