//
//  HeadCoachDetailViewController.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 12/29/18.
//  Copyright © 2018 Akshay Easwaran. All rights reserved.
//

#import "FCTableViewController.h"
#import "HBPlayerDetailView.h"
@class HeadCoach;

NS_ASSUME_NONNULL_BEGIN

@interface HeadCoachDetailViewController : FCTableViewController

-(instancetype)initWithCoach:(HeadCoach*)coach;
@end

NS_ASSUME_NONNULL_END
