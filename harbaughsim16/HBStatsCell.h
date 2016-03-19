//
//  HBStatsCell.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/19/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBStatsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *statLabel;
@property (weak, nonatomic) IBOutlet UILabel *homeTeamLabel;
@property (weak, nonatomic) IBOutlet UILabel *awayTeamLabel;
@property (weak, nonatomic) IBOutlet UILabel *homeValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *awayValueLabel;

@end
