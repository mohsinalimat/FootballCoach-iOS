//
//  ConferenceStandingsViewController.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 4/14/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "FCTableViewController.h"
@class Conference;

@interface ConferenceStandingsViewController : FCTableViewController
-(instancetype)initWithConference:(Conference*)conf;
@end
