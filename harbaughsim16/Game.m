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

#import "PlayerQB.h"
#import "PlayerRB.h"
#import "PlayerWR.h"
#import "PlayerK.h"
#import "PlayerOL.h"
#import "PlayerF7.h"
#import "PlayerCB.h"
#import "PlayerS.h"


@implementation Game
-(instancetype)initWithHome:(Team*)home away:(Team*)away {
    self = [super init];
    if (self) {
        _homeTeam = home;
        _awayTeam = away;
        
        _homeScore = 0;
        _homeQScore = [NSMutableArray array];
        _awayScore = 0;
        _awayQScore = [NSMutableArray array];
        _numOT = 0;
        
        for (int i = 0; i < 10; i++) {
            [_homeQScore addObject:@(0)];
            [_awayQScore addObject:@(0)];
        }
        
        _homeTOs = 0;
        _awayTOs = 0;
        
        gameEventLog = [NSMutableString stringWithFormat:@"LOG: #%ld %@ (%ld-%ld) @ #%ld %@ (%ld-%ld)\n---------------------------------------------------------",(long)_awayTeam.rankTeamPollScore,_awayTeam.abbreviation,(long)_awayTeam.wins,(long)_awayTeam.losses,(long)_homeTeam.rankTeamPollScore,_homeTeam.abbreviation,(long)_homeTeam.wins,(long)_homeTeam.losses];
        
        //initialize arrays, set everything to zero
        _HomeQBStats = [NSMutableArray array];
        _AwayQBStats = [NSMutableArray array];
        
        _HomeRB1Stats = [NSMutableArray array];
        _HomeRB2Stats = [NSMutableArray array];
        _AwayRB1Stats = [NSMutableArray array];
        _AwayRB2Stats = [NSMutableArray array];
        
        _HomeWR1Stats = [NSMutableArray array];
        _HomeWR2Stats = [NSMutableArray array];
        _HomeWR3Stats = [NSMutableArray array];
        _AwayWR1Stats = [NSMutableArray array];
        _AwayWR2Stats = [NSMutableArray array];
        _AwayWR3Stats = [NSMutableArray array];
        
        _HomeKStats = [NSMutableArray array];
        _AwayKStats = [NSMutableArray array];
        
        
        for (int i = 0; i < 6; i++) {
            [_HomeQBStats addObject:@(0)];
            [_AwayQBStats addObject:@(0)];
            
            [_HomeKStats addObject:@(0)];
            [_AwayKStats addObject:@(0)];
            
            [_HomeWR1Stats addObject:@(0)];
            [_AwayWR1Stats addObject:@(0)];
            
            [_HomeWR2Stats addObject:@(0)];
            [_AwayWR2Stats addObject:@(0)];
            
            [_HomeWR3Stats addObject:@(0)];
            [_AwayWR3Stats addObject:@(0)];
        }
        
        for (int i = 0; i < 4; i++) {
            [_HomeRB1Stats addObject:@(0)];
            [_AwayRB1Stats addObject:@(0)];
            [_HomeRB2Stats addObject:@(0)];
            [_AwayRB2Stats addObject:@(0)];
        }
        
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
        _homeQScore = [NSMutableArray array];
        _awayScore = 0;
        _awayQScore = [NSMutableArray array];
        _numOT = 0;
        
        _homeTOs = 0;
        _awayTOs = 0;
        
        gameEventLog = [NSMutableString stringWithFormat:@"LOG: #%ld %@ (%ld-%ld) @ #%ld %@ (%ld-%ld)\n---------------------------------------------------------",(long)_awayTeam.rankTeamPollScore,_awayTeam.abbreviation,(long)_awayTeam.wins,(long)_awayTeam.losses,(long)_homeTeam.rankTeamPollScore,_homeTeam.abbreviation,(long)_homeTeam.wins,(long)_homeTeam.losses];
        
        //initialize arrays, set everything to zero
        _HomeQBStats = [NSMutableArray array];
        _AwayQBStats = [NSMutableArray array];
        
        _HomeRB1Stats = [NSMutableArray array];
        _HomeRB2Stats = [NSMutableArray array];
        _AwayRB1Stats = [NSMutableArray array];
        _AwayRB2Stats = [NSMutableArray array];
        
        _HomeWR1Stats = [NSMutableArray array];
        _HomeWR2Stats = [NSMutableArray array];
        _HomeWR3Stats = [NSMutableArray array];
        _AwayWR1Stats = [NSMutableArray array];
        _AwayWR2Stats = [NSMutableArray array];
        _AwayWR3Stats = [NSMutableArray array];
        
        _HomeKStats = [NSMutableArray array];
        _AwayKStats = [NSMutableArray array];
        
        
        for (int i = 0; i < 10; i++) {
            [_homeQScore addObject:@(0)];
            [_awayQScore addObject:@(0)];
        }
        for (int i = 0; i < 6; i++) {
            [_HomeQBStats addObject:@(0)];
            [_AwayQBStats addObject:@(0)];
            
            [_HomeKStats addObject:@(0)];
            [_AwayKStats addObject:@(0)];
            
            [_HomeWR1Stats addObject:@(0)];
            [_AwayWR1Stats addObject:@(0)];
            
            [_HomeWR2Stats addObject:@(0)];
            [_AwayWR2Stats addObject:@(0)];
            
            [_HomeWR3Stats addObject:@(0)];
            [_AwayWR3Stats addObject:@(0)];
        }
        
        for (int i = 0; i < 4; i++) {
            [_HomeRB1Stats addObject:@(0)];
            [_AwayRB1Stats addObject:@(0)];
            [_HomeRB2Stats addObject:@(0)];
            [_AwayRB2Stats addObject:@(0)];
        }
        
        _hasPlayed = false;
        
        if ([_gameName isEqualToString:@"In Conf"] && [_homeTeam.rivalTeam isEqualToString:_awayTeam.abbreviation]) {
            // Rivalry game!
            _gameName = @"Rivalry Game";
        }
    }
    return self;
}

-(NSArray<NSString*>*)getGameSummaryStrings {
    NSMutableArray<NSString*> *gameSum = [NSMutableArray array];
    /**
     * [0] is left side
     * [1] is center
     * [2] is right
     * [3] is bottom (game log)
     */
    NSMutableString *gameL = [NSMutableString string];
    NSMutableString *gameC = [NSMutableString string];
    NSMutableString *gameR = [NSMutableString string];
    
    [gameL appendString:@"\nPoints\nYards\nPass Yards\nRush Yards\nTOs\n\n"];
    [gameC appendString:[NSString stringWithFormat:@"#%ld %@\n%ld\n%ld yds\n%ld pyads\n%ldryds\n%ld TOs\n\n",(long)_awayTeam.rankTeamPollScore,_awayTeam.abbreviation,(long)_awayScore,(long)_awayYards,(long)[self getPassYards:TRUE],(long)[self getRushYards:TRUE],(long)_awayTOs]];
    [gameR appendString:[NSString stringWithFormat:@"#%ld %@\n%ld\n%ld yds\n%ld pyads\n%ldryds\n%ld TOs\n\n",(long)_homeTeam.rankTeamPollScore,_homeTeam.abbreviation,(long)_homeScore,(long)_homeYards,(long)[self getPassYards:FALSE],(long)[self getRushYards:FALSE],(long)_homeTOs]];
    
    /**
     * QBs
     */
    [gameL appendString:@"QBs\nName\nYr Ovr/Pot\nTD/Int\nPass Yards\nComp/Att\n"];
    [gameC appendString:[NSString stringWithFormat:@"%@\n%@\n",_awayTeam.abbreviation,[_awayTeam getQB:0].getInitialName]];
    [gameC appendString:[NSString stringWithFormat:@"%@ %ld/%ld\n",[_awayTeam getQB:0].getYearString,(long)[_awayTeam getQB:0].ratOvr,(long)[_awayTeam getQB:0].ratPot]];
    [gameC appendString:[NSString stringWithFormat:@"%@/%@\n",[_AwayQBStats[2] string],[_AwayQBStats[3] string]]]; //td/int
    [gameC appendString:[NSString stringWithFormat:@"%@yds\n",[_AwayQBStats[4] string]]]; //pass yards
    [gameC appendString:[NSString stringWithFormat:@"%@/%@\n",[_AwayQBStats[0] string],[_AwayQBStats[1] string]]];//pass comp/att
    
    [gameR appendString:[NSString stringWithFormat:@"%@\n%@\n",_homeTeam.abbreviation,[_homeTeam getQB:0].getInitialName]];
    [gameR appendString:[NSString stringWithFormat:@"%@ %ld/%ld\n",[_homeTeam getQB:0].getYearString,(long)[_homeTeam getQB:0].ratOvr,(long)[_homeTeam getQB:0].ratPot]];
    [gameR appendString:[NSString stringWithFormat:@"%@/%@\n",[_HomeQBStats[2] string],[_HomeQBStats[3] string]]]; //td/int
    [gameR appendString:[NSString stringWithFormat:@"%@yds\n",[_HomeQBStats[4] string]]]; //pass yards
    [gameR appendString:[NSString stringWithFormat:@"%@/%@\n",[_HomeQBStats[0] string],[_HomeQBStats[1] string]]];//pass comp/att
    
    /**
     * RBs
     */
    [gameL appendString:@"\nRBs\nRB1 Name\nYr Ovr/Pot\nTD/Fum\nRush Yards\nYds/Att\n"];
    [gameC appendString:[NSString stringWithFormat:@"%@\n%@\n",_awayTeam.abbreviation,[_awayTeam getRB:0].getInitialName]];
    [gameC appendString:[NSString stringWithFormat:@"%@ %ld/%ld\n",[_awayTeam getRB:0].getYearString,(long)[_awayTeam getRB:0].ratOvr,(long)[_awayTeam getRB:0].ratPot]];
    [gameC appendString:[NSString stringWithFormat:@"%@/%@\n",[_AwayRB1Stats[2] string],[_AwayRB1Stats[3] string]]];
    [gameC appendString:[NSString stringWithFormat:@"%@yds\n",[_AwayRB1Stats[1] string]]];
    [gameC appendString:[NSString stringWithFormat:@"%f\n",((double)((10*[_AwayRB1Stats[1] doubleValue])/[_AwayRB1Stats[0] doubleValue])/10)]];
    
    [gameR appendString:[NSString stringWithFormat:@"%@\n%@\n",_homeTeam.abbreviation,[_homeTeam getRB:0].getInitialName]];
    [gameR appendString:[NSString stringWithFormat:@"%@ %ld/%ld\n",[_homeTeam getRB:0].getYearString,(long)[_homeTeam getRB:0].ratOvr,(long)[_homeTeam getRB:0].ratPot]];
    [gameR appendString:[NSString stringWithFormat:@"%@/%@\n",[_HomeRB1Stats[2] string],[_HomeRB1Stats[3] string]]];
    [gameR appendString:[NSString stringWithFormat:@"%@yds\n",[_HomeRB1Stats[1] string]]];
    [gameR appendString:[NSString stringWithFormat:@"%f\n",((double)((10*[_HomeRB1Stats[1] doubleValue])/[_HomeRB1Stats[0] doubleValue])/10)]];
    
    [gameL appendString:@"\n"]; [gameC appendString:@"\n"]; [gameR appendString:@"\n"];
    
    [gameL appendString:@"RB2 Name\nYr Ovr/Pot\nTD/Fum\nRush Yards\nYds/Att\n"];
    [gameC appendString:[NSString stringWithFormat:@"%@\n%@\n",_awayTeam.abbreviation,[_awayTeam getRB:1].getInitialName]];
    [gameC appendString:[NSString stringWithFormat:@"%@ %ld/%ld\n",[_awayTeam getRB:1].getYearString,(long)[_awayTeam getRB:1].ratOvr,(long)[_awayTeam getRB:1].ratPot]];
    [gameC appendString:[NSString stringWithFormat:@"%@/%@\n",[_AwayRB2Stats[2] string],[_AwayRB2Stats[3] string]]];
    [gameC appendString:[NSString stringWithFormat:@"%@yds\n",[_AwayRB2Stats[1] string]]];
    [gameC appendString:[NSString stringWithFormat:@"%f\n",((double)((10*[_AwayRB2Stats[1] doubleValue])/[_AwayRB2Stats[0] doubleValue])/10)]];
    
    [gameR appendString:[NSString stringWithFormat:@"%@\n%@\n",_homeTeam.abbreviation,[_homeTeam getRB:1].getInitialName]];
    [gameR appendString:[NSString stringWithFormat:@"%@ %ld/%ld\n",[_homeTeam getRB:1].getYearString,(long)[_homeTeam getRB:1].ratOvr,(long)[_homeTeam getRB:1].ratPot]];
    [gameR appendString:[NSString stringWithFormat:@"%@/%@\n",[_HomeRB2Stats[2] string],[_HomeRB2Stats[3] string]]];
    [gameR appendString:[NSString stringWithFormat:@"%@yds\n",[_HomeRB2Stats[1] string]]];
    [gameR appendString:[NSString stringWithFormat:@"%f\n",((double)((10*[_HomeRB2Stats[1] doubleValue])/[_HomeRB2Stats[0] doubleValue])/10)]];
    
    /**
     * WRs
     */
    [gameL appendString:@"\nWRs\nWR1 Name\nYr Ovr/Pot\nTD/Fum\nRec Yards\nRec/Tgts\n" ];

    [gameC appendString:[NSString stringWithFormat:@"%@\n%@\n",_awayTeam.abbreviation,[_awayTeam getWR:0].getInitialName]];
    [gameC appendString:[NSString stringWithFormat:@"%@ %ld/%ld\n",[_awayTeam getWR:0].getYearString,(long)[_awayTeam getWR:0].ratOvr,(long)[_awayTeam getWR:0].ratPot]];
    [gameC appendString:[NSString stringWithFormat:@"%@/%@\n",[_AwayWR1Stats[3] string],[_AwayWR1Stats[5] string]]];
    [gameC appendString:[NSString stringWithFormat:@"%@yds\n",[_AwayWR1Stats[2] string]]];
    [gameC appendString:[NSString stringWithFormat:@"%@/%@\n",[_AwayWR1Stats[0] string],[_AwayWR1Stats[1] string]]];
    
    [gameR appendString:[NSString stringWithFormat:@"%@\n%@\n",_homeTeam.abbreviation,[_homeTeam getWR:0].getInitialName]];
    [gameR appendString:[NSString stringWithFormat:@"%@ %ld/%ld\n",[_homeTeam getWR:0].getYearString,(long)[_homeTeam getWR:0].ratOvr,(long)[_homeTeam getWR:0].ratPot]];
    [gameR appendString:[NSString stringWithFormat:@"%@/%@\n",[_HomeWR1Stats[2] string],[_HomeWR1Stats[3] string]]];
    [gameR appendString:[NSString stringWithFormat:@"%@yds\n",[_HomeWR1Stats[4] string]]];
    [gameR appendString:[NSString stringWithFormat:@"%@/%@\n",[_HomeWR1Stats[0] string],[_HomeWR1Stats[1] string]]];
    
    [gameL appendString:@"\n"]; [gameC appendString:@"\n"]; [gameR appendString:@"\n"];
    
    [gameL appendString:@"WR2 Name\nYr Ovr/Pot\nTD/Fum\nRec Yards\nRec/Tgts\n" ];
    [gameC appendString:[NSString stringWithFormat:@"%@\n%@\n",_awayTeam.abbreviation,[_awayTeam getWR:1].getInitialName]];
    [gameC appendString:[NSString stringWithFormat:@"%@ %ld/%ld\n",[_awayTeam getWR:1].getYearString,(long)[_awayTeam getWR:1].ratOvr,(long)[_awayTeam getWR:1].ratPot]];
    [gameC appendString:[NSString stringWithFormat:@"%@/%@\n",[_AwayWR2Stats[3] string],[_AwayWR2Stats[5] string]]];
    [gameC appendString:[NSString stringWithFormat:@"%@yds\n",[_AwayWR2Stats[2] string]]];
    [gameC appendString:[NSString stringWithFormat:@"%@/%@\n",[_AwayWR2Stats[0] string],[_AwayWR2Stats[1] string]]];
    
    [gameR appendString:[NSString stringWithFormat:@"%@\n%@\n",_homeTeam.abbreviation,[_homeTeam getWR:1].getInitialName]];
    [gameR appendString:[NSString stringWithFormat:@"%@ %ld/%ld\n",[_homeTeam getWR:1].getYearString,(long)[_homeTeam getWR:1].ratOvr,(long)[_homeTeam getWR:1].ratPot]];
    [gameR appendString:[NSString stringWithFormat:@"%@/%@\n",[_HomeWR2Stats[2] string],[_HomeWR2Stats[3] string]]];
    [gameR appendString:[NSString stringWithFormat:@"%@yds\n",[_HomeWR2Stats[4] string]]];
    [gameR appendString:[NSString stringWithFormat:@"%@/%@\n",[_HomeWR2Stats[0] string],[_HomeWR2Stats[1] string]]];
    
    [gameL appendString:@"\n"]; [gameC appendString:@"\n"]; [gameR appendString:@"\n"];
    
    [gameL appendString:@"WR3 Name\nYr Ovr/Pot\nTD/Fum\nRec Yards\nRec/Tgts\n" ];
    [gameC appendString:[NSString stringWithFormat:@"%@\n%@\n",_awayTeam.abbreviation,[_awayTeam getWR:2].getInitialName]];
    [gameC appendString:[NSString stringWithFormat:@"%@ %ld/%ld\n",[_awayTeam getWR:2].getYearString,(long)[_awayTeam getWR:2].ratOvr,(long)[_awayTeam getWR:2].ratPot]];
    [gameC appendString:[NSString stringWithFormat:@"%@/%@\n",[_AwayWR3Stats[3] string],[_AwayWR3Stats[5] string]]];
    [gameC appendString:[NSString stringWithFormat:@"%@yds\n",[_AwayWR3Stats[2] string]]];
    [gameC appendString:[NSString stringWithFormat:@"%@/%@\n",[_AwayWR3Stats[0] string],[_AwayWR3Stats[1] string]]];
    
    [gameR appendString:[NSString stringWithFormat:@"%@\n%@\n",_homeTeam.abbreviation,[_homeTeam getWR:2].getInitialName]];
    [gameR appendString:[NSString stringWithFormat:@"%@ %ld/%ld\n",[_homeTeam getWR:2].getYearString,(long)[_homeTeam getWR:2].ratOvr,(long)[_homeTeam getWR:2].ratPot]];
    [gameR appendString:[NSString stringWithFormat:@"%@/%@\n",[_HomeWR3Stats[2] string],[_HomeWR3Stats[3] string]]];
    [gameR appendString:[NSString stringWithFormat:@"%@yds\n",[_HomeWR3Stats[4] string]]];
    [gameR appendString:[NSString stringWithFormat:@"%@/%@\n",[_HomeWR3Stats[0] string],[_HomeWR3Stats[1] string]]];
    
    /**
     * Ks
     */
    [gameL appendString:@"\nKs\nName\nYr Ovr/Pot\nFGM/FGA\nXPM/XPA\n"];
    [gameC appendString:[NSString stringWithFormat:@"%@\n%@\n",_awayTeam.abbreviation,[_awayTeam getK:0].getInitialName]];
    [gameC appendString:[NSString stringWithFormat:@"%@ %ld/%ld\n",[_awayTeam getK:0].getYearString,(long)[_awayTeam getK:0].ratOvr,(long)[_awayTeam getK:0].ratPot]];
    [gameC appendString:[NSString stringWithFormat:@"%@/%@ FG %@/%@ XP",[_AwayKStats[2] string],[_AwayKStats[3] string],[_AwayKStats[0] string],[_AwayKStats[1] string]]];
    
    [gameR appendString:[NSString stringWithFormat:@"%@\n%@\n",_homeTeam.abbreviation,[_homeTeam getK:0].getInitialName]];
    [gameR appendString:[NSString stringWithFormat:@"%@ %ld/%ld\n",[_homeTeam getK:0].getYearString,(long)[_homeTeam getK:0].ratOvr,(long)[_homeTeam getK:0].ratPot]];
    [gameR appendString:[NSString stringWithFormat:@"%@/%@ FG %@/%@ XP",[_HomeKStats[2] string],[_HomeKStats[3] string],[_HomeKStats[0] string],[_HomeKStats[1] string]]];
    
    [gameSum addObject:gameL];
    [gameSum addObject:gameC];
    [gameSum addObject:gameR];
    [gameSum addObject:gameEventLog];
    
    return gameSum;
    
    
    
    return [gameSum copy];
}

-(NSArray<NSString*>*)getGameScoutStrings {
    NSMutableArray<NSString*> *gameSum = [NSMutableArray array];
    NSString *gameL = @"Ranking\nRecord\nPPG\nOpp PPG\nYPG\nOpp YPG\n\nPass YPG\nRush YPG\nOpp PYPG\nOpp RYPG\n\nOff Talent\nDef Talent\nPrestige";
    NSString *gameC = @"";
    NSString *gameR = @"";
    int g = _awayTeam.numGames;
    Team *t = _awayTeam;
    
    gameC = [NSString stringWithFormat:@"#%ld %@\n%ld-%ld\n%ld (%ld)\n%d (%ld)\n%d (%ld)\n%d (%ld)\n\n%d (%ld)\n%d (%ld)\n%d (%ld)\n%d (%ld)\n%ld (%ld)\n\n%ld (%ld)\n%ld (%ld)\n",(long)t.rankTeamPollScore,t.abbreviation,(long)t.wins,(long)t.losses,(long)t.teamPoints,(long)t.rankTeamPoints,(t.teamOppPoints/g),(long)t.rankTeamOppPoints,(t.teamYards/g), (long)t.rankTeamYards,(t.teamOppYards/g), (long)t.rankTeamOppYards,(t.teamPassYards/g),(long)t.rankTeamPassYards,(t.teamRushYards/g),(long)t.rankTeamRushYards,(t.teamOppPassYards/g),(long)t.rankTeamOppPassYards,(t.teamOppRushYards/g),(long)t.rankTeamOppRushYards, (long)t.teamOffTalent, (long)t.rankTeamOffTalent, (long)t.teamDefTalent, (long)t.rankTeamDefTalent, (long)t.teamPrestige, (long)t.rankTeamPrestige];
    
    g = _homeTeam.numGames;
    t = _homeTeam;
    gameR = [NSString stringWithFormat:@"#%ld %@\n%ld-%ld\n%ld (%ld)\n%d (%ld)\n%d (%ld)\n%d (%ld)\n\n%d (%ld)\n%d (%ld)\n%d (%ld)\n%d (%ld)\n%ld (%ld)\n\n%ld (%ld)\n%ld (%ld)\n",(long)t.rankTeamPollScore,t.abbreviation,(long)t.wins,(long)t.losses,(long)t.teamPoints,(long)t.rankTeamPoints,(t.teamOppPoints/g),(long)t.rankTeamOppPoints,(t.teamYards/g), (long)t.rankTeamYards,(t.teamOppYards/g), (long)t.rankTeamOppYards,(t.teamPassYards/g),(long)t.rankTeamPassYards,(t.teamRushYards/g),(long)t.rankTeamRushYards,(t.teamOppPassYards/g),(long)t.rankTeamOppPassYards,(t.teamOppRushYards/g),(long)t.rankTeamOppRushYards, (long)t.teamOffTalent, (long)t.rankTeamOffTalent, (long)t.teamDefTalent, (long)t.rankTeamDefTalent, (long)t.teamPrestige, (long)t.rankTeamPrestige];
    
    [gameSum addObject:gameL];
    [gameSum addObject:gameC];
    [gameSum addObject:gameR];
    [gameSum addObject:@"SCOUTING REPORT"];
    
    
    return [gameSum copy];
}

-(int)getPassYards:(BOOL)ha {
    if (!ha) {
        NSNumber *qbYd = _HomeQBStats[4];
        return qbYd.intValue;
    } else {
        NSNumber *qbYd = _AwayQBStats[4];
        return qbYd.intValue;
    }
}

-(int)getRushYards:(BOOL)ha {
    if (!ha){
      //return HomeRB1Stats[1] + HomeRB2Stats[1];
        NSNumber *rb1Yd = _HomeRB1Stats[1];
        NSNumber *rb2Yd = _HomeRB2Stats[1];
        return rb1Yd.intValue + rb2Yd.intValue;
    } else {
        NSNumber *rb1Yd = _AwayRB1Stats[1];
        NSNumber *rb2Yd = _AwayRB2Stats[1];
        return rb1Yd.intValue + rb2Yd.intValue;
    }
}

-(int)getHFAdv {
    if ( gamePoss ) return 3;
    else return 0;
}

-(NSString*)getEventPrefix {
    NSString *possStr;
    if ( gamePoss ) possStr = _homeTeam.abbreviation;
    else possStr = _awayTeam.abbreviation;
    NSString *yardsNeedAdj = [NSString stringWithFormat:@"%ld",(long)gameYardsNeed];
    
    if (gameYardLine + gameYardsNeed >= 100) yardsNeedAdj = @"Goal";
    return [NSString stringWithFormat:@"\n\%@ %ld - %ld %@, Time: %@,\n\t%@ %ld and %@ at %ld yard line.\n",_homeTeam.abbreviation,(long)_homeScore,(long)_awayScore,_awayTeam.abbreviation, [self convGameTime],possStr,(long)gameDown,yardsNeedAdj,(long)gameYardLine];
}

-(NSString*)convGameTime {
    int qNum = (3600 - gameTime) / 900 + 1;
    int minTime;
    int secTime;
    NSMutableString *secStr =[NSMutableString string];
    if ( qNum >= 4 && _numOT > 0 ) {
        minTime = gameTime / 60;
        secTime = gameTime - 60*minTime;
        if (secTime < 10) {
            //secStr = "0" + secTime;
            [secStr appendString:[NSString stringWithFormat:@"0%ld", (long)secTime]];
        } else {
            [secStr appendString:[NSString stringWithFormat:@"%ld", (long)secTime]];
        }
        return [NSString stringWithFormat:@"%ld: %@ OT%ld",(long)minTime,secStr,(long)_numOT];
    } else {
        minTime = (gameTime - 900*(4-qNum)) / 60;
        secTime = (gameTime - 900*(4-qNum)) - 60*minTime;
        if (secTime < 10) {
            [secStr appendString:[NSString stringWithFormat:@"0%ld", (long)secTime]];
        } else {
            [secStr appendString:[NSString stringWithFormat:@"%ld", (long)secTime]];
        }
        return [NSString stringWithFormat:@"%ld: %@ Q%ld",(long)minTime,secStr,(long)qNum];
    }
}

-(void)playGame {
    if ( !_hasPlayed ) {
        gameEventLog = [NSMutableString stringWithFormat:@"LOG: #%ld %@ (%ld-%ld) @ #%ld %@ (%ld-%ld)\n---------------------------------------------------------",(long)_awayTeam.rankTeamPollScore, _awayTeam.abbreviation,(long)_awayTeam.wins,(long)_awayTeam.losses,(long)_homeTeam.rankTeamPollScore,_homeTeam.abbreviation,(long)_homeTeam.wins,(long)_homeTeam.losses];
        //probably establish some home field advantage before playing
        gameTime = 3600;
        gameDown = 1;
        gamePoss = true;
        gameYardsNeed = 10;
        gameYardLine = 20;
        
        while ( gameTime > 0 ) {
            //play ball!
            if (gamePoss) {
                //runPlay( homeTeam, awayTeam );
                [self runPlay:_homeTeam defense:_awayTeam];
            } else {
                [self runPlay:_awayTeam defense:_homeTeam];
            }
            if (gameTime <= 0 && _homeScore == _awayScore) {
                gameTime = 900; //OT
                gameYardLine = 20;
                _numOT++;
            }
        }
        
        //game over, add wins
        if (_homeScore > _awayScore) {
            _homeTeam.wins++;
            _homeTeam.totalWins++;
            [_homeTeam.gameWLSchedule addObject:@"W"];
            _awayTeam.losses++;
            _awayTeam.totalLosses++;
            [_awayTeam.gameWLSchedule addObject:@"L"];
            [_homeTeam.gameWinsAgainst addObject:_awayTeam];
        } else {
            _homeTeam.losses++;
            _homeTeam.totalLosses++;
            [_homeTeam.gameWLSchedule addObject:@"L"];
            _awayTeam.wins++;
            _awayTeam.totalWins++;
            [_awayTeam.gameWLSchedule addObject:@"W"];
            [_awayTeam.gameWinsAgainst addObject:_homeTeam];
        }
        
        // Add points/opp points
        _homeTeam.teamPoints += _homeScore;
        _awayTeam.teamPoints += _awayScore;
        
        _homeTeam.teamOppPoints += _awayScore;
        _awayTeam.teamOppPoints += _homeScore;
        
        _homeTeam.teamYards += _homeYards;
        _awayTeam.teamYards += _awayYards;
        
        _homeTeam.teamOppYards += _awayYards;
        _awayTeam.teamOppYards += _homeYards;
        
        _homeTeam.teamOppPassYards += [self getPassYards:YES];
        _awayTeam.teamOppPassYards += [self getPassYards:NO];
        _homeTeam.teamOppRushYards += [self getRushYards:YES];
        _awayTeam.teamOppRushYards += [self getRushYards:NO];
        
        _homeTeam.teamTODiff += _awayTOs-_homeTOs;
        _awayTeam.teamTODiff += _homeTOs-_awayTOs;
        
        _hasPlayed = true;
        
        [self addNewsStory];
        
        if ([_gameName isEqualToString:@"Rivalry Game"]) {
            if (_homeScore > _awayScore) {
                _homeTeam.wonRivalryGame = true;
            } else {
                _awayTeam.wonRivalryGame = true;
            }
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"playedGame" object:nil];
}

-(void)addNewsStory {
    NSMutableArray *currentWeekNews;
    if (_numOT >= 3) {
        // Thriller in OT
        Team *winner, *loser;
        int winScore, loseScore;
        if (_awayScore > _homeScore) {
            winner = _awayTeam;
            loser = _homeTeam;
            winScore = _awayScore;
            loseScore = _homeScore;
        } else {
            winner = _homeTeam;
            loser = _awayTeam;
            winScore = _homeScore;
            loseScore = _awayScore;
        }
        
        currentWeekNews = _homeTeam.league.newsStories[_homeTeam.league.currentWeek+1];
        [currentWeekNews addObject:[NSString stringWithFormat:@"%ldOT Thriller!\n%@ and %@ played an absolutely thrilling game that went to %ld overtimes, with %@ finally emerging victorious %ld to %ld.", (long)_numOT, winner.strRep, loser.strRep, (long)_numOT, winner.name, (long)winScore, (long)loseScore]];
    }
    else if (_homeScore > _awayScore && _awayTeam.losses == 1 && _awayTeam.league.currentWeek > 5) {
        // 5-0 or better team given first loss
        currentWeekNews = _awayTeam.league.newsStories[_homeTeam.league.currentWeek+1];
        [currentWeekNews addObject:[NSString stringWithFormat:@"Undefeated no more! %@ suffers first loss!\n%@ hands %@ their first loss of the season, winning %ld to %ld.", _awayTeam.name, _homeTeam.strRep, _awayTeam.strRep, (long)_homeScore, (long)_awayScore]];
    }
    else if (_awayScore > _homeScore && _homeTeam.losses == 1 && _homeTeam.league.currentWeek > 5) {
        // 5-0 or better team given first loss
        currentWeekNews = _homeTeam.league.newsStories[_awayTeam.league.currentWeek+1];
        [currentWeekNews addObject:[NSString stringWithFormat:@"Undefeated no more! %@ suffers first loss!\n%@ hands %@ their first loss of the season, winning %ld to %ld.", _homeTeam.name, _awayTeam.strRep, _homeTeam.strRep, (long)_awayScore, (long)_homeScore]];

    }
    else if (_awayScore > _homeScore && _homeTeam.rankTeamPollScore < 20 && (_awayTeam.rankTeamPollScore - _homeTeam.rankTeamPollScore) > 20) {
        // Upset!
        currentWeekNews = _awayTeam.league.newsStories[_homeTeam.league.currentWeek+1];
        [currentWeekNews addObject:[NSString stringWithFormat:@"Upset! %@ beats %@\n%@ pulls off the upset on the road against %@, winning %ld to %ld.", _awayTeam.strRep, _homeTeam.strRep, _awayTeam.name, _homeTeam.name, (long)_awayScore, (long)_homeScore]];
    }
    else if (_homeScore > _awayScore && _awayTeam.rankTeamPollScore < 20 && (_homeTeam.rankTeamPollScore - _awayTeam.rankTeamPollScore) > 20) {
        // Upset!
        currentWeekNews = _homeTeam.league.newsStories[_awayTeam.league.currentWeek+1];
        [currentWeekNews addObject:[NSString stringWithFormat:@"Upset! %@ beats %@\n%@ pulls off the upset on the road against %@, winning %ld to %ld.", _homeTeam.strRep, _awayTeam.strRep, _homeTeam.name, _awayTeam.name, (long)_homeScore, (long)_awayScore]];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"newNewsStory" object:nil];
}

-(void)runPlay:(Team *)offense defense:(Team *)defense {
    if ( gameDown > 4 ) {
        gamePoss = !gamePoss;
        gameDown = 1;
    }
    double preferPass = ([offense getPassProf]*2 - [defense getPassDef]) *[HBSharedUtils randomValue] - 10;
    double preferRush = ([offense getRushProf]*2 - [defense getRushDef]) *[HBSharedUtils randomValue] + offense.offensiveStrategy.rushYdBonus;
    
    if ( gameTime <= 30 ) {
        if ( ((gamePoss && (_awayScore - _homeScore) <= 3) || (!gamePoss && (_homeScore - _awayScore) <= 3)) && gameYardLine > 60 ) {
            //last second FGA
            [self fieldGoalAtt:offense defense:defense];
        } else {
            //hail mary
            [self passingPlay:offense defense:defense];
        }
    }
    else if ( gameDown >= 4 ) {
        if ( ((gamePoss && (_awayScore - _homeScore) > 3) || (!gamePoss && (_homeScore - _awayScore) > 3)) && gameTime < 300 ) {
            //go for it since we need 7 to win
            if ( gameYardsNeed < 3 ) {
                //rushingPlay( offense, defense );
                [self rushingPlay:offense defense:defense];
            } else {
                //passingPlay( offense, defense );
                [self passingPlay:offense defense:defense];
            }
        } else {
            //4th down
            if ( gameYardsNeed < 3 ) {
                if ( gameYardLine > 65 ) {
                    //fga
                    //fieldGoalAtt( offense, defense );
                    [self fieldGoalAtt:offense defense:defense];
                } else if ( gameYardLine > 55 ) {
                    // run play, go for it!
                    //rushingPlay( offense, defense );
                    [self rushingPlay:offense defense:defense];
                } else {
                    //punt
                    //puntPlay( offense );
                    [self puntPlay:offense];
                }
            } else if ( gameYardLine > 60 ) {
                //fga
                //fieldGoalAtt( offense, defense );
                [self fieldGoalAtt:offense defense:defense];
            } else {
                //punt
                //puntPlay( offense );
                [self puntPlay:offense];
            }
        }
    } else if ( (gameDown == 3 && gameYardsNeed > 4) || ((gameDown==1 || gameDown==2) && (preferPass >= preferRush)) ) {
        // pass play
        //passingPlay( offense, defense );
        [self passingPlay:offense defense:defense];
    } else {
        //run play
        //rushingPlay( offense, defense );
        [self rushingPlay:offense defense:defense];
    }
}

-(void)passingPlay:(Team *)offense defense:(Team *)defense {
    int yardsGain = 0;
    BOOL gotTD = false;
    BOOL gotFumble = false;
    //choose WR to throw to, better WRs more often
    double WR1pref = pow([offense getWR:0].ratOvr , 1 ) * [HBSharedUtils randomValue];
    double WR2pref = pow([offense getWR:1].ratOvr , 1 ) * [HBSharedUtils randomValue];
    double WR3pref = pow([offense getWR:2].ratOvr , 1 ) * [HBSharedUtils randomValue];
    
    PlayerWR *selWR;
    PlayerCB *selCB;
    NSMutableArray *selWRStats;
    if ( WR1pref > WR2pref && WR1pref > WR3pref ) {
        selWR = [offense getWR:0];
        selCB = [defense getCB:0];
        if (gamePoss) {
            selWRStats = _HomeWR1Stats;
        } else selWRStats = _AwayWR1Stats;
    } else if ( WR2pref > WR1pref && WR2pref > WR3pref ) {
        selWR = [offense getWR:1];
        selCB = [defense getCB:1];
        if (gamePoss) {
            selWRStats = _HomeWR2Stats;
        } else selWRStats = _AwayWR2Stats;
    } else {
        selWR = [offense getWR:2];
        selCB = [defense getCB:2];
        if (gamePoss) {
            selWRStats = _HomeWR3Stats;
        } else selWRStats = _AwayWR3Stats;
    }
    
    //get how much pressure there is on qb, check if sack
    int pressureOnQB = [defense getCompositeF7Pass]*2 - [offense getCompositeOLPass] - [self getHFAdv];
    if ([HBSharedUtils randomValue]*100 < pressureOnQB/8 ) {
        //sacked!
        [self qbSack:offense];
        return;
    }
    
    //check for int
    double intChance = (pressureOnQB + [defense getS:0].ratOvr - ([offense getQB:0].ratPassAcc+[offense getQB:0].ratFootIQ+100)/3)/18
    + offense.offensiveStrategy.passAgBonus + defense.defensiveStrategy.passAgBonus;
    if (intChance < 0.015) intChance = 0.015;
    if ( 100*arc4random() < intChance ) {
        //Interception
        [self qbInterception:offense];
        return;
    }
    
    //throw ball, check for completion
    double completion = ( [self getHFAdv] + [self normalize:[offense getQB:0].ratPassAcc] + [self normalize:selWR.ratRecCat] - [self normalize:selCB.ratCBCov])/2 + 18.25 - pressureOnQB/16.8 - offense.offensiveStrategy.passAgBonus - defense.defensiveStrategy.passAgBonus;
    if ( 100*arc4random() < completion ) {
        if ( 100*arc4random() < (100 - selWR.ratRecCat)/3 ) {
            //drop
            gameDown++;
            NSNumber *wrStat = selWRStats[4];
            wrStat = [NSNumber numberWithInteger:wrStat.integerValue + 1];
            [selWRStats replaceObjectAtIndex:4 withObject:wrStat];
            selWR.statsDrops++;
        } else {
            //no drop
            yardsGain = (int) (( [self normalize:[offense getQB:0].ratPassPow] + [self normalize:selWR.ratRecSpd] - [self normalize:selCB.ratCBSpd] )*arc4random()/3.7 + offense.offensiveStrategy.passYdBonus/2 - defense.defensiveStrategy.passYdBonus);
            //see if receiver can get yards after catch
            double escapeChance = ([self normalize:(selWR.ratRecEva)*3 - selCB.ratCBTkl - [defense getS:0].ratOvr]*arc4random() + offense.offensiveStrategy.passYdBonus - defense.defensiveStrategy.passAgBonus);
            if ( escapeChance > 92 ||[HBSharedUtils randomValue] > 0.95 ) {
                yardsGain += 3 + selWR.ratRecSpd*arc4random()/3;
            }
            if ( escapeChance > 75 &&[HBSharedUtils randomValue] < (0.1 + (offense.offensiveStrategy.passAgBonus)-defense.defensiveStrategy.passAgBonus)/200) {
                //wr escapes for TD
                yardsGain += 100;
            }
            
            //add yardage
            gameYardLine += yardsGain;
            if ( gameYardLine >= 100 ) { //TD!
                yardsGain -= gameYardLine - 100;
                gameYardLine = 100 - yardsGain;
                [self addPointsQuarter:6];
                [self passingTD:offense receiver:selWR stats:selWRStats yardsGained:yardsGain];
                //offense.teamPoints += 6;
                //defense.teamOppPoints += 6;
                gotTD = true;
            } else {
                //check for fumble
                double fumChance = ([defense getS:0].ratSTkl + selCB.ratCBTkl)/2;
                if ( 100*arc4random() < fumChance/40 ) {
                    //Fumble!
                    gotFumble = true;
                }
            }
            
            //check downs
            gameYardsNeed -= yardsGain;
            if ( gameYardsNeed <= 0 ) {
                gameDown = 1;
                gameYardsNeed = 10;
            } else gameDown++;
            
            //stats management
            //passCompletion(offense, defense, selWR, selWRStats, yardsGain);
            [self passCompletion:offense defense:defense receiver:selWR stats:selWRStats yardsGained:yardsGain];
        }
        
    } else {
        //no completion, advance downs
        gameDown++;
    }
    
    //passAttempt(offense, selWR, selWRStats, yardsGain);
    [self passAttempt:offense defense:defense receiver:selWR stats:selWRStats yardsGained:yardsGain];
    
    
    if ( gotFumble ) {
        [gameEventLog appendString:[NSString stringWithFormat:@"%@TURNOVER!\n%@ WR %@ fumbled the ball after a catch.", [self getEventPrefix],offense.abbreviation,selWR.name]];
        NSNumber *wrFum = selWRStats[5];
        wrFum = [NSNumber numberWithInteger:wrFum.integerValue + 1];
        [selWRStats replaceObjectAtIndex:5 withObject:wrFum];
        selWR.statsFumbles++;
        gameDown = 1;
        gameYardsNeed = 10;
        if ( gamePoss ) { // home possession
            _homeTOs++;
        } else {
            _awayTOs++;
        }
        gamePoss = !gamePoss;
        gameYardLine = 100 - gameYardLine;
    }
    
    if ( gotTD ) {
        [self kickXP:offense defense:defense];
        [self kickOff:offense];
    }
    
    gameTime -= 15 + 15*arc4random();

}

-(void)rushingPlay:(Team *)offense defense:(Team *)defense {
    BOOL gotTD = false;
    //pick RB to run
    PlayerRB *selRB;
    double RB1pref = pow( [offense getRB:0].ratOvr , 1.5 ) *[HBSharedUtils randomValue];
    double RB2pref = pow( [offense getRB:1].ratOvr , 1.5 ) *[HBSharedUtils randomValue];
    
    if (RB1pref > RB2pref) {
        selRB = [offense getRB:0];
    } else {
        selRB = [offense getRB:1];
    }
    
    int blockAdv = [offense getCompositeOLRush ] - [defense getCompositeF7Rush];
    int yardsGain = (int) ((selRB.ratRushSpd + blockAdv + [self getHFAdv]) *[HBSharedUtils randomValue] / 10 + offense.offensiveStrategy.rushYdBonus/2 - defense.defensiveStrategy.rushYdBonus/2);
    if (yardsGain < 2) {
        yardsGain += selRB.ratRushPow/20 - 3 - defense.defensiveStrategy.rushYdBonus/2;
    } else {
        //break free from tackles
        if (arc4random() < ( 0.28 + ( offense.offensiveStrategy.rushAgBonus - defense.defensiveStrategy.rushYdBonus/2 )/50 )) {
            yardsGain += selRB.ratRushEva/5 *[HBSharedUtils randomValue];
        }
    }
    
    //add yardage
    gameYardLine += yardsGain;
    if ( gameYardLine >= 100 ) { //TD!
        [self addPointsQuarter:6];
        yardsGain -= gameYardLine - 100;
        gameYardLine = 100 - yardsGain;
        if ( gamePoss ) { // home possession
            _homeScore += 6;
            if (RB1pref > RB2pref) {
                NSNumber *kStat1 = _HomeRB1Stats[2];
                kStat1 = [NSNumber numberWithInteger:kStat1.integerValue + 1];
                [_HomeRB1Stats replaceObjectAtIndex:3 withObject:kStat1];
            } else {
                NSNumber *kStat1 = _HomeRB2Stats[2];
                kStat1 = [NSNumber numberWithInteger:kStat1.integerValue + 1];
                [_HomeRB2Stats replaceObjectAtIndex:3 withObject:kStat1];
            }
        } else {
            _awayScore += 6;
            if (RB1pref > RB2pref) {
                NSNumber *kStat1 = _AwayRB1Stats[2];
                kStat1 = [NSNumber numberWithInteger:kStat1.integerValue + 1];
                [_AwayRB1Stats replaceObjectAtIndex:3 withObject:kStat1];
            } else {
                NSNumber *kStat1 = _AwayRB2Stats[2];
                kStat1 = [NSNumber numberWithInteger:kStat1.integerValue + 1];
                [_AwayRB2Stats replaceObjectAtIndex:3 withObject:kStat1];
            }
        }
        tdInfo = [NSString stringWithFormat:@"%@ RB %@ rushed %d yards for a TD.", offense.abbreviation,selRB.name,yardsGain];
        selRB.statsTD++;
        //offense.teamPoints += 6;
        //defense.teamOppPoints += 6;
        
        gotTD = true;
    }
    
    //check downs
    gameYardsNeed -= yardsGain;
    if ( gameYardsNeed <= 0 ) {
        gameDown = 1;
        gameYardsNeed = 10;
    } else gameDown++;
    
    //stats management
    [self rushAttempt:offense defense:defense rusher:selRB rb1Pref:RB1pref rb2Pref:RB2pref yardsGained:yardsGain];
    
    if ( gotTD ) {
        [self kickXP:offense defense:defense];
        [self kickOff:offense];
    } else {
        gameTime -= 25 + 15*arc4random();
        //check for fumble
        double fumChance = ([defense getS:0].ratSTkl + [defense getCompositeF7Rush] - [self getHFAdv])/2 + offense.offensiveStrategy.rushAgBonus;
        if ( 100*arc4random() < fumChance/40 ) {
            //Fumble!
            if ( gamePoss ) {
                _homeTOs++;
                if (RB1pref > RB2pref) {
                    NSNumber *kStat1 = _HomeRB1Stats[3];
                    kStat1 = [NSNumber numberWithInteger:kStat1.integerValue + 1];
                    [_HomeRB1Stats replaceObjectAtIndex:3 withObject:kStat1];
                } else {
                    NSNumber *kStat1 = _HomeRB2Stats[3];
                    kStat1 = [NSNumber numberWithInteger:kStat1.integerValue + 1];
                    [_HomeRB2Stats replaceObjectAtIndex:3 withObject:kStat1];
                }
            } else {
                _awayTOs++;
                if (RB1pref > RB2pref) {
                    NSNumber *kStat1 = _AwayRB1Stats[3];
                    kStat1 = [NSNumber numberWithInteger:kStat1.integerValue + 1];
                    [_AwayRB1Stats replaceObjectAtIndex:3 withObject:kStat1];
                } else {
                    NSNumber *kStat1 = _AwayRB2Stats[3];
                    kStat1 = [NSNumber numberWithInteger:kStat1.integerValue + 1];
                    [_AwayRB2Stats replaceObjectAtIndex:3 withObject:kStat1];
                }
            }
            
            [gameEventLog  appendString:[NSString stringWithFormat:@"%@TURNOVER!\n%@ RB %@ fumbled the ball while rushing.",[self getEventPrefix], offense.abbreviation, selRB.name]];
            selRB.statsFumbles++;
            gameDown = 1;
            gameYardsNeed = 10;
            gamePoss = !gamePoss;
            gameYardLine = 100 - gameYardLine;
        }
    }
}

-(void)fieldGoalAtt:(Team *)offense defense:(Team *)defense {
    double fgDistRatio = pow((110 - gameYardLine)/50,2);
    double fgAccRatio = pow((110 - gameYardLine)/50,1.25);
    double fgDistChance = ( [self getHFAdv] + [offense getK:0].ratKickPow - fgDistRatio*80 );
    double fgAccChance = ( [self getHFAdv] + [offense getK:0].ratKickAcc - fgAccRatio*80 );
    if ( fgDistChance > 20 && fgAccChance*arc4random() > 15 ) {
        // made the fg
        if ( gamePoss ) { // home possession
            _homeScore += 3;

            NSNumber *kStat1 = _HomeKStats[3];
            kStat1 = [NSNumber numberWithInteger:kStat1.integerValue + 1];
            [_HomeKStats replaceObjectAtIndex:3 withObject:kStat1];
            
            NSNumber *kStat2 = _HomeKStats[2];
            kStat2 = [NSNumber numberWithInteger:kStat2.integerValue + 1];
            [_HomeKStats replaceObjectAtIndex:2 withObject:kStat2];
        } else {
            _awayScore += 3;
            NSNumber *kStat1 = _AwayKStats[3];
            kStat1 = [NSNumber numberWithInteger:kStat1.integerValue + 1];
            [_AwayKStats replaceObjectAtIndex:3 withObject:kStat1];
            
            NSNumber *kStat2 = _AwayKStats[2];
            kStat2 = [NSNumber numberWithInteger:kStat2.integerValue + 1];
            [_AwayKStats replaceObjectAtIndex:2 withObject:kStat2];
        }
         [gameEventLog appendString:[NSString stringWithFormat:@"%@ %@ K %@ made the %d yard FG.",[self getEventPrefix], offense.abbreviation, [offense getK:0].name, (110-gameYardLine)]];
        [self addPointsQuarter:3];
        //offense.teamPoints += 3;
        //defense.teamOppPoints += 3;
        [offense getK:0].statsFGMade++;
        [offense getK:0].statsFGAtt++;
        [self kickOff:offense];
        
    } else {
        //miss
        
        [gameEventLog appendString:[NSString stringWithFormat:@"%@ %@ K %@ missed the %d yard FG!",[self getEventPrefix], offense.abbreviation, [offense getK:0].name, (110-gameYardLine)]];
        [offense getK:0].statsFGAtt++;
        gameYardLine = 100 - gameYardLine;
        gameDown = 1;
        gameYardsNeed = 10;
        gamePoss = !gamePoss;
        if ( gamePoss ) { // home possession
            NSNumber *kStat1 = _HomeKStats[3];
            kStat1 = [NSNumber numberWithInteger:kStat1.integerValue + 1];
            [_HomeKStats replaceObjectAtIndex:3 withObject:kStat1];
        } else {
            NSNumber *kStat1 = _AwayKStats[3];
            kStat1 = [NSNumber numberWithInteger:kStat1.integerValue + 1];
            [_AwayKStats replaceObjectAtIndex:3 withObject:kStat1];
        }
    }
    
    gameTime -= 20;
 
}

-(void)kickXP:(Team *)offense defense:(Team *)defense {
    if ( ((gamePoss && (_awayScore - _homeScore) == 2) || (!gamePoss && (_homeScore - _awayScore) == 2)) && gameTime < 300 ) {
        //go for 2
        BOOL successConversion = false;
        if ([HBSharedUtils randomValue] < 0.5 ) {
            //rushing
            int blockAdv = [offense getCompositeOLRush] - [defense getCompositeF7Rush];
            int yardsGain = (([offense getRB:0].ratRushSpd + blockAdv) *[HBSharedUtils randomValue] / 6);
            if ( yardsGain > 5 ) {
                successConversion = true;
                if ( gamePoss ) { // home possession
                    _homeScore += 2;
                } else {
                    _awayScore += 2;
                }
                [self addPointsQuarter:2];
                [gameEventLog appendString:[NSString stringWithFormat:@"%@ %@ %@ rushed for the 2pt conversion.",[self getEventPrefix],tdInfo,[offense getRB:0].name]];
            } else {
                [gameEventLog appendString:[NSString stringWithFormat:@"%@ %@ %@ stopped at the line of scrimmage, failed the 2pt conversion.",[self getEventPrefix],tdInfo,[offense getRB:0].name]];
            }
        } else {
            int pressureOnQB = [defense getCompositeF7Pass]*2 - [offense getCompositeOLPass];
            double completion = ( [self normalize:[offense getQB:0].ratPassAcc] + [offense getWR:0].ratRecCat - [defense getCB:0].ratCBCov )/2 + 25 - pressureOnQB/20;
            if ( 100*arc4random() < completion ) {
                successConversion = true;
                if ( gamePoss ) { // home possession
                    _homeScore += 2;
                } else {
                    _awayScore += 2;
                }
                [self addPointsQuarter:2];
                [gameEventLog appendString:[NSString stringWithFormat:@"%@ %@ 2pt conversion is good! %@ completed the pass to %@ for the 2pt conversion.",[self getEventPrefix],tdInfo,[offense getQB:0].name, [offense getWR:0].name]];
            } else {
                [gameEventLog appendString:[NSString stringWithFormat:@"%@ %@ 2pt conversion failed! %@'s pass incomplete to %@.",[self getEventPrefix],tdInfo,[offense getQB:0].name, [offense getWR:0].name]];
            }
        }
        
    } else {
        //kick XP
        if ([HBSharedUtils randomValue]*100 < 20 + [offense getK:0].ratKickAcc ) {
            //made XP
            if ( gamePoss ) { // home possession
                _homeScore += 1;
                NSNumber *kStat1 = _HomeKStats[0];
                kStat1 = [NSNumber numberWithInteger:kStat1.integerValue + 1];
                [_HomeKStats replaceObjectAtIndex:0 withObject:kStat1];

                NSNumber *kStat2 = _HomeKStats[1];
                kStat2 = [NSNumber numberWithInteger:kStat2.integerValue + 1];
                [_HomeKStats replaceObjectAtIndex:1 withObject:kStat2];
            } else {
                _awayScore += 1;
                NSNumber *kStat1 = _AwayKStats[0];
                kStat1 = [NSNumber numberWithInteger:kStat1.integerValue + 1];
                [_AwayKStats replaceObjectAtIndex:0 withObject:kStat1];
                
                NSNumber *kStat2 = _AwayKStats[1];
                kStat2 = [NSNumber numberWithInteger:kStat2.integerValue + 1];
                [_AwayKStats replaceObjectAtIndex:1 withObject:kStat2];
            }
            
            [gameEventLog appendString:[NSString stringWithFormat:@"%@ %@ %@ made the XP.",[self getEventPrefix],tdInfo,[offense getK:0].name]];
            [self addPointsQuarter:1];
            [offense getK:0].statsXPMade++;
        } else {
            [gameEventLog appendString:[NSString stringWithFormat:@"%@ %@ %@ missed the XP.",[self getEventPrefix],tdInfo,[offense getK:0].name]];
        }
        [offense getK:0].statsXPAtt++;
    }
}

-(void)kickOff:(Team *)offense {
    //Decide whether to onside kick. Only if losing but within 8 points with < 3 min to go
    if ( gameTime < 180 && ((gamePoss && (_awayScore - _homeScore) <= 8 && (_awayScore - _homeScore) > 0)
                            || (!gamePoss && (_homeScore - _awayScore) <=8 && (_homeScore - _awayScore) > 0))) {
        // Yes, do onside
        if ([offense getK:0].ratKickFum *[HBSharedUtils randomValue] > 60 ||[HBSharedUtils randomValue] < 0.1) {
            //Success!
            [gameEventLog appendString:[NSString stringWithFormat:@"%@ %@ K %@ successfully executes onside kick! %@ has possession!",[self getEventPrefix], offense.abbreviation, [offense getK:0].name, offense.abbreviation]];
        } else {
            // Fail
            [gameEventLog appendString:[NSString stringWithFormat:@"%@ %@ K %@ failed to convert the onside kick. %@ lost possession.",[self getEventPrefix], offense.abbreviation, [offense getK:0].name, offense.abbreviation]];
            gamePoss = !gamePoss;
        }
        gameYardLine = 50;
        gameDown = 1;
        gameYardsNeed = 10;
    } else {
        // Just regular kick off
        gameYardLine = (int) (100 - ([offense getK:0].ratKickPow + 20 - 40*arc4random() ));
        if ( gameYardLine <= 0 ) gameYardLine = 20;
        gameDown = 1;
        gameYardsNeed = 10;
        gamePoss = !gamePoss;
    }
}

-(void)puntPlay:(Team *)offense {
    gameYardLine = (int) (100 - ( gameYardLine + [offense getK:0].ratKickPow/3 + 20 - 10*arc4random() ));
    if ( gameYardLine < 0 ) {
        gameYardLine = 20;
    }
    gameDown = 1;
    gameYardsNeed = 10;
    gamePoss = !gamePoss;
    
    gameTime -= 20 + 15*arc4random();
}

-(void)qbSack:(Team *)offense {
    [offense getQB:0].statsSacked++;
    gameYardsNeed += 3;
    gameYardLine -= 3;
    gameDown++;
    if ( gamePoss ) { // home possession
        NSNumber *qbSack = _HomeQBStats[5];
        qbSack = [NSNumber numberWithInteger:qbSack.integerValue + 1];
        [_HomeQBStats replaceObjectAtIndex:5 withObject:qbSack];
    } else {
        NSNumber *qbSack = _AwayQBStats[5];
        qbSack = [NSNumber numberWithInteger:qbSack.integerValue + 1];
        [_AwayQBStats replaceObjectAtIndex:5 withObject:qbSack];
    }
    
    if (gameYardLine < 0) {
        // Safety!
        [self safety];
    }
}

-(void)safety {
    if (gamePoss) {
        _awayScore += 2;
        [gameEventLog appendString:[NSString stringWithFormat:@"%@SAFETY!\n%@ QB %@ was tackled in the endzone! Result is a safety and %@ will get the ball.", [self getEventPrefix],_homeTeam.abbreviation,[_homeTeam getQB:0].name,_awayTeam.abbreviation]];
        [self kickOff:_homeTeam];
    } else {
        _homeScore += 2;
        [gameEventLog appendString:[NSString stringWithFormat:@"%@SAFETY!\n%@ QB %@ was tackled in the endzone! Result is a safety and %@ will get the ball.", [self getEventPrefix],_awayTeam.abbreviation,[_awayTeam getQB:0].name,_homeTeam.abbreviation]];
        [self kickOff:_awayTeam];
    }
}

-(void)qbInterception:(Team *)offense {
    if ( gamePoss ) { // home possession
        NSNumber *qbInt = _HomeQBStats[3];
        qbInt = [NSNumber numberWithInteger:qbInt.integerValue + 1];
        [_HomeQBStats replaceObjectAtIndex:3 withObject:qbInt];
        
        NSNumber *qbStat = _HomeQBStats[1];
        qbStat = [NSNumber numberWithInteger:qbStat.integerValue + 1];
        [_HomeQBStats replaceObjectAtIndex:1 withObject:qbStat];
        _homeTOs++;
    } else {
        NSNumber *qbInt = _AwayQBStats[3];
        qbInt = [NSNumber numberWithInteger:qbInt.integerValue + 1];
        [_AwayQBStats replaceObjectAtIndex:3 withObject:qbInt];
        
        NSNumber *qbStat = _AwayQBStats[1];
        qbStat = [NSNumber numberWithInteger:qbStat.integerValue + 1];
        [_AwayQBStats replaceObjectAtIndex:1 withObject:qbStat];
        _awayTOs++;
    }
    [gameEventLog appendString:[NSString stringWithFormat:@"%@TURNOVER!\n%@ QB %@ was intercepted.", [self getEventPrefix], offense.abbreviation, [offense getQB:0].name]];
    [offense getQB:0].statsInt++;
    gameDown = 1;
    gameYardsNeed = 10;
    gamePoss = !gamePoss;
    gameYardLine = 100 - gameYardLine;
}

-(void)passingTD:(Team *)offense receiver:(PlayerWR *)selWR stats:(NSMutableArray *)selWRStats yardsGained:(int)yardsGained {
    if ( gamePoss ) { // home possession
        _homeScore += 6;
        NSNumber *qbStat = _HomeQBStats[2];
        qbStat = [NSNumber numberWithInteger:qbStat.integerValue + 1];
        [_HomeQBStats replaceObjectAtIndex:2 withObject:qbStat];
        NSNumber *wrTarget = selWRStats[3];
        wrTarget = [NSNumber numberWithInteger:wrTarget.integerValue + 1];
        [selWRStats replaceObjectAtIndex:3 withObject:wrTarget];
    } else {
        _awayScore += 6;
        NSNumber *qbStat = _AwayQBStats[2];
        qbStat = [NSNumber numberWithInteger:qbStat.integerValue + 1];
        [_AwayQBStats replaceObjectAtIndex:2 withObject:qbStat];
        NSNumber *wrTarget = selWRStats[3];
        wrTarget = [NSNumber numberWithInteger:wrTarget.integerValue + 1];
        [selWRStats replaceObjectAtIndex:3 withObject:wrTarget];
    }
    tdInfo = [NSString stringWithFormat:@"%@ QB %@ threw a %ld yard TD to %@.",offense.abbreviation,[offense getQB:0].name,(long)yardsGained,selWR.name];
    [offense getQB:0].statsTD++;
    selWR.statsTD++;
}


-(void)passCompletion:(Team *)offense defense:(Team *)defense receiver:(PlayerWR *)selWR stats:(NSMutableArray *)selWRStats yardsGained:(int)yardsGained {
    [offense getQB:0].statsPassComp++;
    [offense getQB:0].statsPassYards += yardsGained;
    selWR.statsReceptions++;
    selWR.statsRecYards += yardsGained;
    offense.teamPassYards += yardsGained;
    
    if ( gamePoss ) { // home possession
        NSNumber *qbStat = _HomeQBStats[0];
        qbStat = [NSNumber numberWithInteger:qbStat.integerValue + 1];
        [_HomeQBStats replaceObjectAtIndex:0 withObject:qbStat];
        
        NSNumber *wrTarget = selWRStats[0];
        wrTarget = [NSNumber numberWithInteger:wrTarget.integerValue + 1];
        [selWRStats replaceObjectAtIndex:0 withObject:wrTarget];
    } else {
        NSNumber *qbStat = _AwayQBStats[0];
        qbStat = [NSNumber numberWithInteger:qbStat.integerValue + 1];
        [_AwayQBStats replaceObjectAtIndex:0 withObject:qbStat];
        
        NSNumber *wrTarget = selWRStats[0];
        wrTarget = [NSNumber numberWithInteger:wrTarget.integerValue + 1];
        [selWRStats replaceObjectAtIndex:0 withObject:wrTarget];
    }
}

-(void)passAttempt:(Team *)offense defense:(Team *)defense receiver:(PlayerWR *)selWR stats:(NSMutableArray *)selWRStats yardsGained:(int)yardsGained {
    PlayerQB *qb = [offense getQB:0];
    qb.statsPassAtt++;
    selWR.statsTargets++;
    
    if ( gamePoss ) { // home possession
        _homeYards += yardsGained;
         NSNumber *qbStatYd = _HomeQBStats[4];
         qbStatYd = [NSNumber numberWithInteger:qbStatYd.integerValue + yardsGained];
         [_HomeQBStats replaceObjectAtIndex:4 withObject:qbStatYd];
         
         NSNumber *qbStat = _HomeQBStats[0];
         qbStat = [NSNumber numberWithInteger:qbStat.integerValue + 1];
         [_HomeQBStats replaceObjectAtIndex:0 withObject:qbStat];
        
        NSNumber *wr2Yds = selWRStats[2];
        wr2Yds = [NSNumber numberWithInteger:wr2Yds.integerValue + yardsGained];
        [selWRStats replaceObjectAtIndex:2 withObject:wr2Yds];
        
        NSNumber *wrTarget = selWRStats[1];
        wrTarget = [NSNumber numberWithInteger:wrTarget.integerValue + 1];
        [selWRStats replaceObjectAtIndex:1 withObject:wrTarget];
        
        
    } else {
        _awayYards += yardsGained;
        NSNumber *qbStatYd = _AwayQBStats[4];
        qbStatYd = [NSNumber numberWithInteger:qbStatYd.integerValue + yardsGained];
        [_AwayQBStats replaceObjectAtIndex:4 withObject:qbStatYd];
        
        NSNumber *qbStat = _AwayQBStats[0];
        qbStat = [NSNumber numberWithInteger:qbStat.integerValue + 1];
        [_AwayQBStats replaceObjectAtIndex:0 withObject:qbStat];
        
        NSNumber *wr2Yds = selWRStats[2];
        wr2Yds = [NSNumber numberWithInteger:wr2Yds.integerValue + yardsGained];
        [selWRStats replaceObjectAtIndex:2 withObject:wr2Yds];
        
        NSNumber *wrTarget = selWRStats[1];
        wrTarget = [NSNumber numberWithInteger:wrTarget.integerValue + 1];
        [selWRStats replaceObjectAtIndex:1 withObject:wrTarget];
    }
}

-(void)rushAttempt:(Team *)offense defense:(Team *)defense rusher:(PlayerRB *)selRB rb1Pref:(double)rb1Pref rb2Pref:(double)rb2Pref yardsGained:(int)yardsGained {
    selRB.statsRushAtt++;
    selRB.statsRushYards += yardsGained;
    offense.teamRushYards += yardsGained;
    
    if ( gamePoss ) { // home possession
        _homeYards += yardsGained;
        if (rb1Pref > rb2Pref) {
            NSNumber *rb1 = _HomeRB1Stats[0];
            rb1 = [NSNumber numberWithInteger:rb1.integerValue + 1];
            [_HomeRB1Stats replaceObjectAtIndex:0 withObject:rb1];
            
            NSNumber *rb1Att = _HomeRB1Stats[1];
            rb1Att = [NSNumber numberWithInteger:rb1Att.integerValue + yardsGained];
            [_HomeRB1Stats replaceObjectAtIndex:1 withObject:rb1Att];
            
        } else {
            NSNumber *rb2 = _HomeRB1Stats[0];
            rb2 = [NSNumber numberWithInteger:rb2.integerValue + 1];
            [_HomeRB1Stats replaceObjectAtIndex:0 withObject:rb2];
            
            NSNumber *rb2Att = _HomeRB1Stats[1];
            rb2Att = [NSNumber numberWithInteger:rb2Att.integerValue + yardsGained];
            [_HomeRB1Stats replaceObjectAtIndex:1 withObject:rb2Att];
        }
    } else {
        _awayYards += yardsGained;
        if (rb1Pref > rb2Pref) {
            NSNumber *rb1 = _AwayRB1Stats[0];
            rb1 = [NSNumber numberWithInteger:rb1.integerValue + 1];
            [_AwayRB1Stats replaceObjectAtIndex:0 withObject:rb1];
            
            NSNumber *rb1Att = _AwayRB1Stats[1];
            rb1Att = [NSNumber numberWithInteger:rb1Att.integerValue + yardsGained];
            [_AwayRB1Stats replaceObjectAtIndex:1 withObject:rb1Att];
        } else {
            NSNumber *rb2 = _AwayRB2Stats[0];
            rb2 = [NSNumber numberWithInteger:rb2.integerValue + 1];
            [_AwayRB2Stats replaceObjectAtIndex:0 withObject:rb2];
            
            NSNumber *rb2Att = _AwayRB2Stats[1];
            rb2Att = [NSNumber numberWithInteger:rb2Att.integerValue + yardsGained];
            [_AwayRB2Stats replaceObjectAtIndex:1 withObject:rb2Att];
        }
    }
}

-(void)addPointsQuarter:(int)points {
    if ( gamePoss ) {
        //home poss
        int index = 0;
        if ( gameTime > 2700 ) {
            index = 0;
        } else if ( gameTime > 1800 ) {
            index = 1;
        } else if ( gameTime > 900 ) {
            index = 2;
        } else if ( _numOT == 0 ) {
            index = 3;
        } else {
            if ( 3+_numOT < 10 ){
                index = 3 + _numOT;
            } else {
                index = 9;
            }
        }
        
        NSNumber *quarter = _homeQScore[index];
        quarter = [NSNumber numberWithInt:quarter.intValue + points];
        [_homeQScore replaceObjectAtIndex:index withObject:quarter];
    } else {
        //away
        int index = 0;
        if ( gameTime > 2700 ) {
            index = 0;
        } else if ( gameTime > 1800 ) {
            index = 1;
        } else if ( gameTime > 900 ) {
            index = 2;
        } else if ( _numOT == 0 ) {
            index = 3;
        } else {
            if ( 3+_numOT < 10 ){
                index = 3 + _numOT;
            } else {
                index = 9;
            }
        }
        NSNumber *quarter = _awayQScore[index];
        quarter = [NSNumber numberWithInt:quarter.intValue + points];
        [_awayQScore replaceObjectAtIndex:index withObject:quarter];
    }
}

-(int)normalize:(int)rating {
    return (100 + rating)/2;
}

@end
