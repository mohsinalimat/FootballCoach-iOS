//
//  LeagueYearViewController.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/21/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCTableViewController.h"

@interface LeagueYearViewController : FCTableViewController
-(instancetype)initWithYear:(NSString*)year top10:(NSArray*)apTop10 ;
@end
