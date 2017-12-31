//
//  AEProgressTitleToolbar.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 12/31/17.
//  Copyright © 2017 Akshay Easwaran. All rights reserved.
//

#import "AEProgressTitleToolbar.h"

@implementation AEProgressTitleToolbar

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(10, 10, self.frame.size.width - 20, 30)];
        [self.progressView setProgressViewStyle:UIProgressViewStyleDefault];
        [self.progressView sizeToFit];
        self.progressView.trackTintColor = [UIColor lightTextColor];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, self.frame.size.width - 20, 15)];
        [self.titleLabel setTextColor:[UIColor darkTextColor]];
        [self.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
        [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
        
        UIView *backingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
        [backingView setBackgroundColor:[UIColor clearColor]];
        [backingView addSubview:self.titleLabel];
        [backingView addSubview:self.progressView];
        
        [self addSubview:backingView];
    }
    return self;
}

-(void)updateViewWithProgress:(float)progress title:(NSString *)title {
    [self.progressView setProgress:progress animated:YES];
    if (title != nil) {
        [self.titleLabel setText:title];
    }
}

@end
