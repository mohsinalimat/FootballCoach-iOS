//
//  TeamScheduleViewController.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/25/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "FCTableViewController.h"
@class Team;
@interface TeamScheduleViewController : FCTableViewController
-(instancetype)initWithTeam:(Team*)team;
@end
