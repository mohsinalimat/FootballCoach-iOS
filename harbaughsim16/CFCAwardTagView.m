//
//  CFCAwardTagView.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 1/9/19.
//  Copyright © 2019 Akshay Easwaran. All rights reserved.
//

#import "CFCAwardTagView.h"
@import QuartzCore;

@implementation CFCAwardTagView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = self.frame.size.height * 0.25;
    
//    self.layer.borderWidth = 1.0f;
//    self.layer.borderColor = [UIColor lightTextColor].CGColor;
}

@end
