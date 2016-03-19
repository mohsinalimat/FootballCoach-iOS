//
//  HBPlayerCell.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/19/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBPlayerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *playerLabel;
@property (weak, nonatomic) IBOutlet UILabel *teamLabel;

@property (weak, nonatomic) IBOutlet UILabel *stat1Label;
@property (weak, nonatomic) IBOutlet UILabel *stat1ValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *stat2Label;
@property (weak, nonatomic) IBOutlet UILabel *stat2ValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *stat3Label;
@property (weak, nonatomic) IBOutlet UILabel *stat3ValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *stat4Label;
@property (weak, nonatomic) IBOutlet UILabel *stat4ValueLabel;
@end
