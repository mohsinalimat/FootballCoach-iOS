//
//  TeamStrategy.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/16/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TeamStrategy : NSObject

@property (nonatomic) NSInteger rushYdBonus;
@property (nonatomic) NSInteger rushAgBonus;
@property (nonatomic) NSInteger passYdBonus;
@property (nonatomic) NSInteger passAgBonus;

@property (strong, nonatomic) NSString * stratName;
@property (strong, nonatomic) NSString * stratDescription;

+(instancetype)newStrategyWithName:(NSString*)name description:(NSString*)description rYB:(NSInteger)rYB rAB:(NSInteger)rAB pYB:(NSInteger)pYB pAB:(NSInteger)pAB;
+(instancetype)newStrategy;

@end
