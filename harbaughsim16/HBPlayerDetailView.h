//
//  HBPlayerDetailView.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 12/20/18.
//  Copyright © 2018 Akshay Easwaran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CFCAwardTagView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HBPlayerDetailView : UIView
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *yrLabel;
@property (weak, nonatomic) IBOutlet UILabel *posLabel;
@property (weak, nonatomic) IBOutlet UIImageView *medImageView;

@property (weak, nonatomic) IBOutlet CFCAwardTagView *potyTagView;
@property (weak, nonatomic) IBOutlet CFCAwardTagView *allConfTagView;
@property (weak, nonatomic) IBOutlet CFCAwardTagView *allLeagueTagView;
@end

NS_ASSUME_NONNULL_END
