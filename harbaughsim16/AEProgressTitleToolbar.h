//
//  AEProgressTitleToolbar.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 12/31/17.
//  Copyright © 2017 Akshay Easwaran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AEProgressTitleToolbar : UIToolbar
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIProgressView *progressView;
-(void)updateViewWithProgress:(float)progress title:(NSString *)title;
@end
