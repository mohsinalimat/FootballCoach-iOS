//
//  HBRecordCell.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 4/11/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBRecordCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerLabel;
@property (weak, nonatomic) IBOutlet UILabel *teamLabel;
@property (weak, nonatomic) IBOutlet UILabel *statLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@end
