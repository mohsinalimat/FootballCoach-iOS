//
//  Record.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 4/8/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Player;

@interface Record : NSObject
@property (strong, nonatomic) NSString *title;
@property (nonatomic) NSInteger year;
@property (nonatomic) NSInteger statistic;
@property (nonatomic) Player *holder;
+(instancetype)newRecord:(NSString*)recordName player:(Player*)plyr stat:(NSInteger)stat year:(NSInteger)yr;
@end
