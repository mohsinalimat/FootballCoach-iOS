//
//  NSMutableArray+Mapping.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 4/10/19.
//  Copyright © 2019 Akshay Easwaran. All rights reserved.
//

#import "NSMutableArray+Mapping.h"

@implementation NSMutableArray (Mapping)
- (instancetype)map:(id (^ _Nonnull)(id obj))mapBlock {
    NSMutableArray *mapped = [NSMutableArray array];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id mappedObj = mapBlock(obj);
        if (mappedObj != nil && ![mapped containsObject:mappedObj]) {
            [mapped addObject:mappedObj];
        }
    }];
    return mapped;
}
@end
