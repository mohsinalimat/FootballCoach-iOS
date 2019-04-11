//
//  NSMutableArray+Mapping.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 4/10/19.
//  Copyright © 2019 Akshay Easwaran. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableArray (Mapping)
- (instancetype)map:(id (^ _Nonnull)(id obj))mapBlock;
@end

NS_ASSUME_NONNULL_END
