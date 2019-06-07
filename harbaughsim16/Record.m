//
//  Record.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 4/8/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "Record.h"
#import "AutoCoding.h"

@implementation Record
@synthesize year, holder, statistic, title, coachHolder;

+(instancetype)newRecord:(NSString*)recordName coach:(HeadCoach*)coach stat:(NSInteger)stat year:(NSInteger)yr {
    return [[Record alloc] initWithName:recordName coach:coach stat:stat year:yr];
}

-(instancetype)initWithName:(NSString*)recordName coach:(HeadCoach *)coach stat:(NSInteger)stat year:(NSInteger)yr {
    if (self = [super init]) {
        year = yr;
        holder = nil;
        coachHolder = coach;
        statistic = stat;
        title = recordName;
    }
    return self;
}

+(instancetype)newRecord:(NSString*)recordName player:(Player*)plyr stat:(NSInteger)stat year:(NSInteger)yr {
    return [[Record alloc] initWithName:recordName player:plyr stat:stat year:yr];
}

-(instancetype)initWithName:(NSString*)recordName player:(Player*)plyr stat:(NSInteger)stat year:(NSInteger)yr {
    if (self = [super init]) {
        year = yr;
        holder = plyr;
        coachHolder = nil;
        statistic = stat;
        title = recordName;
    }
    return self;
}
@end
