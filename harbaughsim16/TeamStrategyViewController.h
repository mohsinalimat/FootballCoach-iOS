//
//  TeamStrategyViewController.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/22/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCTableViewController.h"

@class TeamStrategy;
@interface TeamStrategyViewController : FCTableViewController
-(instancetype)initWithType:(BOOL)offensive options:(NSArray<TeamStrategy*> *)options;
@end
