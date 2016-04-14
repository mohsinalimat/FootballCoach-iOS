//
//  HBTeamRankCell.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 4/14/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBTeamRankCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *teamNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;

@property (weak, nonatomic) IBOutlet UILabel *confLossLabel;
@property (weak, nonatomic) IBOutlet UILabel *confWinsLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalWinsLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLossesLabel;
@end
