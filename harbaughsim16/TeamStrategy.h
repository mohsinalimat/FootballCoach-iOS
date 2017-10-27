//
//  TeamStrategy.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/16/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TeamStrategy : NSObject <NSCoding>

@property (nonatomic) int rushYdBonus;
@property (nonatomic) int rushAgBonus;
@property (nonatomic) int passYdBonus;
@property (nonatomic) int passAgBonus;

@property (strong, nonatomic) NSString * stratName;
@property (strong, nonatomic) NSString * stratDescription;

+(instancetype)newStrategyWithName:(NSString*)name description:(NSString*)description rYB:(int)rYB rAB:(int)rAB pYB:(int)pYB pAB:(int)pAB;
+(instancetype)newStrategy;

@end
