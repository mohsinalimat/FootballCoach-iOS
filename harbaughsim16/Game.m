//
//  Game.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/16/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "Game.h"
#import "Team.h"
#import "Player.h"

@implementation Game
-(instancetype)initWithHome:(Team*)home away:(Team*)away {
    self = [super init];
    if (self) {
        _homeTeam = home;
        _awayTeam = away;
        
        _homeScore = 0;
        _homeQScore = [NSMutableArray arrayWithCapacity:10];
        _awayScore = 0;
        _awayQScore = [NSMutableArray arrayWithCapacity:10];
        _numOT = 0;
        
        _homeTOs = 0;
        _awayTOs = 0;
        
        gameEventLog = [NSString stringWithFormat:@"LOG: #%ld %@ (%ld-%ld) @ #%ld %@ (%ld-%ld)\n---------------------------------------------------------",(long)_awayTeam.rankTeamPollScore,_awayTeam.abbreviation,(long)_awayTeam.wins,(long)_awayTeam.losses,(long)_homeTeam.rankTeamPollScore,_homeTeam.abbreviation,(long)_homeTeam.wins,(long)_homeTeam.losses];
        
        //initialize arrays, set everything to zero
        _HomeQBStats = [NSMutableArray arrayWithCapacity:6];
        _AwayQBStats = [NSMutableArray arrayWithCapacity:6];
        
        _HomeRB1Stats = [NSMutableArray arrayWithCapacity:4];
        _HomeRB2Stats = [NSMutableArray arrayWithCapacity:4];
        _AwayRB1Stats = [NSMutableArray arrayWithCapacity:4];
        _AwayRB2Stats = [NSMutableArray arrayWithCapacity:4];
        
        _HomeWR1Stats = [NSMutableArray arrayWithCapacity:6];
        _HomeWR2Stats = [NSMutableArray arrayWithCapacity:6];
        _HomeWR3Stats = [NSMutableArray arrayWithCapacity:6];
        _AwayWR1Stats = [NSMutableArray arrayWithCapacity:6];
        _AwayWR2Stats = [NSMutableArray arrayWithCapacity:6];
        _AwayWR3Stats = [NSMutableArray arrayWithCapacity:6];
        
        _HomeKStats = [NSMutableArray arrayWithCapacity:6];
        _AwayKStats = [NSMutableArray arrayWithCapacity:6];
        
        //playGame();
        _hasPlayed = false;
        
        _gameName = @"";
    }
    return self;
}

+(instancetype)newGameWithHome:(Team*)home away:(Team*)away {
    return [[Game alloc] initWithHome:home away:away];
}

+(instancetype)newGameWithHome:(Team*)home away:(Team*)away name:(NSString*)name {
    return [[Game alloc] initWithHome:home away:away name:name];
}

-(instancetype)initWithHome:(Team*)home away:(Team*)away name:(NSString*)name {
    self = [super init];
    if (self) {
        _homeTeam = home;
        _awayTeam = away;
        
        _gameName = name;
        
        _homeScore = 0;
        _homeQScore = [NSMutableArray arrayWithCapacity:10];
        _awayScore = 0;
        _awayQScore = [NSMutableArray arrayWithCapacity:10];
        _numOT = 0;
        
        _homeTOs = 0;
        _awayTOs = 0;
        
        gameEventLog = [NSString stringWithFormat:@"LOG: #%ld %@ (%ld-%ld) @ #%ld %@ (%ld-%ld)\n---------------------------------------------------------",(long)_awayTeam.rankTeamPollScore,_awayTeam.abbreviation,(long)_awayTeam.wins,(long)_awayTeam.losses,(long)_homeTeam.rankTeamPollScore,_homeTeam.abbreviation,(long)_homeTeam.wins,(long)_homeTeam.losses];
        
        //initialize arrays, set everything to zero
        _HomeQBStats = [NSMutableArray arrayWithCapacity:6];
        _AwayQBStats = [NSMutableArray arrayWithCapacity:6];
        
        _HomeRB1Stats = [NSMutableArray arrayWithCapacity:4];
        _HomeRB2Stats = [NSMutableArray arrayWithCapacity:4];
        _AwayRB1Stats = [NSMutableArray arrayWithCapacity:4];
        _AwayRB2Stats = [NSMutableArray arrayWithCapacity:4];
        
        _HomeWR1Stats = [NSMutableArray arrayWithCapacity:6];
        _HomeWR2Stats = [NSMutableArray arrayWithCapacity:6];
        _HomeWR3Stats = [NSMutableArray arrayWithCapacity:6];
        _AwayWR1Stats = [NSMutableArray arrayWithCapacity:6];
        _AwayWR2Stats = [NSMutableArray arrayWithCapacity:6];
        _AwayWR3Stats = [NSMutableArray arrayWithCapacity:6];
        
        _HomeKStats = [NSMutableArray arrayWithCapacity:6];
        _AwayKStats = [NSMutableArray arrayWithCapacity:6];
        
        //playGame();
        _hasPlayed = false;
        
        if ([_gameName isEqualToString:@"In Conf"] && [_homeTeam.rivalTeam isEqualToString:_awayTeam.abbreviation]) {
            // Rivalry game!
            _gameName = @"Rivalry Game";
        }
    }
    return self;
}

@end
