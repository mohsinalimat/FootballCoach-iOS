//
//  Record.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 4/8/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Player;
@class HeadCoach;

@interface Record : NSObject
@property (strong, nonatomic) NSString *title;
@property (nonatomic) NSInteger year;
@property (nonatomic) NSInteger statistic;
@property (nonatomic) Player *holder;
@property (nonatomic) HeadCoach *coachHolder;
+(instancetype)newRecord:(NSString*)recordName player:(Player*)plyr stat:(NSInteger)stat year:(NSInteger)yr;
+(instancetype)newRecord:(NSString*)recordName coach:(HeadCoach*)coach stat:(NSInteger)stat year:(NSInteger)yr;
@end
