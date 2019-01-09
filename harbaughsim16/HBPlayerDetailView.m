//
//  HBPlayerDetailView.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 12/20/18.
//  Copyright © 2018 Akshay Easwaran. All rights reserved.
//

#import "HBPlayerDetailView.h"

#import "HBSharedUtils.h"

@implementation HBPlayerDetailView

-(void)awakeFromNib {
    [super awakeFromNib];
    [self.potyTagView setBackgroundColor:[HBSharedUtils champColor]];
    [self.allConfTagView setBackgroundColor:[HBSharedUtils successColor]];
    [self.allLeagueTagView setBackgroundColor:[UIColor orangeColor]];
}

@end
