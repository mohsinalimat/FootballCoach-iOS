//
//  NewsUpdatesViewController.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 5/5/19.
//  Copyright © 2019 Akshay Easwaran. All rights reserved.
//

#import "FCTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewsUpdatesViewController : FCTableViewController
-(instancetype)initWithStories:(NSArray<NSString *> *)stories title:(NSString *)title;
@end

NS_ASSUME_NONNULL_END
