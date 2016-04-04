//
//  TeamStreak.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 4/4/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Team;

@interface TeamStreak : NSObject
@property (strong, nonatomic) NSMutableArray *backingStreakArray;
@property (strong, nonatomic) Team *opponent;
@property (strong, nonatomic) Team *mainTeam;
@property (nonatomic) NSInteger wins;
@property (nonatomic) NSInteger losses;
+(instancetype)newStreakWithOpponent:(Team*)opp;
+(instancetype)newStreakWithTeam:(Team*)team opponent:(Team*)opp;
-(void)addWin;
-(void)addLoss;
-(NSString*)getLastThreeGames;
-(NSString*)stringRepresentation;
@end
