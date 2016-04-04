//
//  TeamStreak.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 4/4/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "TeamStreak.h"
#import "HBSharedUtils.h"
#import "League.h"
#import "Team.h"

#import "AutoCoding.h"

@implementation TeamStreak
@synthesize wins, losses, opponent, mainTeam, backingStreakArray;

-(instancetype)initWithTeam:(Team*)team opponent:(Team*)opp {
    if (self = [super init]) {
        backingStreakArray = [NSMutableArray array];
        mainTeam = team;
        opponent = opp;
    }
    return self;
}

+(instancetype)newStreakWithOpponent:(Team*)opp {
    return [[TeamStreak alloc] initWithTeam:[HBSharedUtils getLeague].userTeam opponent:opp];
}

+(instancetype)newStreakWithTeam:(Team *)team opponent:(Team *)opp {
    return [[TeamStreak alloc] initWithTeam:team opponent:opp];
}

-(void)addWin {
    [backingStreakArray addObject:@"W"];
    wins++;
}

-(void)addLoss {
    [backingStreakArray addObject:@"L"];
    losses++;
}

-(NSString*)stringRepresentation {
    if (wins > losses) {
        return [NSString stringWithFormat:@"%@ leads the series %ld-%ld", mainTeam.abbreviation, (long)wins, (long)losses];
    } else if (losses > wins) {
        return [NSString stringWithFormat:@"%@ leads the series %ld-%ld", opponent.abbreviation, (long)losses, (long)wins];
    } else {
        return [NSString stringWithFormat:@"The series is tied %ld-%ld", (long)losses, (long)wins];
    }
}

-(NSString*)getLastThreeGames {
    NSMutableString *record = [NSMutableString string];
    if (backingStreakArray.count > 2) {
        for (int i = (int)backingStreakArray.count - 1; i > backingStreakArray.count - 4; i--) {
            [record appendString:backingStreakArray[i]];
        }
    } else if (backingStreakArray.count == 2) {
        [record appendString:backingStreakArray[0]];
        [record appendString:backingStreakArray[1]];
    } else if (backingStreakArray.count == 1) {
        [record appendString:backingStreakArray[0]];
    } else {
        [record appendString:@"These teams have never played each other"];
    }
    return record;
}

@end
