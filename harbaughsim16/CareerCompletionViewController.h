//
//  CareerCompletionViewController.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 1/5/19.
//  Copyright © 2019 Akshay Easwaran. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HeadCoach;
NS_ASSUME_NONNULL_BEGIN

@interface CareerCompletionViewController : UIViewController
-(instancetype)initWithCoach:(HeadCoach *)coach;
-(instancetype)initWithCoachDictionary:(NSDictionary *)coachDict;
@end

NS_ASSUME_NONNULL_END
