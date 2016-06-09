//
//  RingOfHonorViewController.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 6/8/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCTableViewController.h"
@class Team;

@interface RingOfHonorViewController : FCTableViewController
-(instancetype)initWithTeam:(Team *)t;
@end
