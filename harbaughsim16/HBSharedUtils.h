//
//  HBSharedUtils.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/18/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "League.h"

@interface HBSharedUtils : NSObject
+(double)randomValue;
+(League*)getLeague;
@end
