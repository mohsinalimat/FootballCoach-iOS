//
//  NSArray+Uniqueness.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 7/25/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "NSArray+Uniqueness.h"

@implementation NSArray (Uniqueness)

-(BOOL)allObjectsAreUnique {
    NSMutableSet *foundObjects = [NSMutableSet set];
    for(id o in self){
        if([foundObjects containsObject:o]){
            return false;
        }
        [foundObjects addObject:o];
    }
    return true;
}
@end
