//
//  HBScoreCell.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/20/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBScoreCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *teamNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *teamAbbrevLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@end
