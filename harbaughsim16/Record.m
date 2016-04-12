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
@synthesize year, holder, statistic, title;


+(instancetype)newRecord:(NSString*)recordName player:(Player*)plyr stat:(NSInteger)stat year:(NSInteger)yr {
    return [[Record alloc] initWithName:recordName player:plyr stat:stat year:yr];
}

-(instancetype)initWithName:(NSString*)recordName player:(Player*)plyr stat:(NSInteger)stat year:(NSInteger)yr {
    if (self = [super init]) {
        year = yr;
        holder = plyr;
        statistic = stat;
        title = recordName;
    }
    return self;
}
@end
