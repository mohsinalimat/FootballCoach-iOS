//
//  CFCRecruitCell.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 12/28/17.
//  Copyright © 2017 Akshay Easwaran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CFCRecruitCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *interestLabel;
@property (weak, nonatomic) IBOutlet UIImageView *starImageView;
@property (weak, nonatomic) IBOutlet UILabel *heightLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
@property (weak, nonatomic) IBOutlet UILabel *fortyYdDashLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UILabel *specialtyLabel;
@property (weak, nonatomic) IBOutlet UILabel *otherOffersLabel;
@end
