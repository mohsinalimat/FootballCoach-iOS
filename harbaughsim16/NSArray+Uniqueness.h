//
//  NSArray+Uniqueness.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 7/25/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Uniqueness)
-(BOOL)allObjectsAreUnique;
- (NSArray *)getElementsRandomly:(NSUInteger)count;
@end
