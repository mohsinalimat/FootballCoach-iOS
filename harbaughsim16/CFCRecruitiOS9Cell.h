//
//  CFCRecruitiOS9Cell.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 1/9/18.
//  Copyright © 2018 Akshay Easwaran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CFCRecruitiOS9Cell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *interestLabel;
@property (weak, nonatomic) IBOutlet UIImageView *starImageView;
@property (weak, nonatomic) IBOutlet UILabel *heightLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UILabel *otherOffersLabel;
@end
