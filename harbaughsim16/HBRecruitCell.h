//
//  HBRecruitCell.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/21/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBRecruitCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UILabel *ovrLabel;

@property (weak, nonatomic) IBOutlet UILabel *stat1ValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *stat2ValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *stat3ValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *stat4ValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *stat5ValueLabel;

@property (weak, nonatomic) IBOutlet UIButton *recruitButton;
@end
