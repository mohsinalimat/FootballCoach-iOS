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

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:gameEventLog forKey:@"gameEventLog"];
    [aCoder encodeObject:tdInfo forKey:@"tdInfo"];
    
    [aCoder encodeInt:gameTime forKey:@"gameTime"];
    [aCoder encodeBool:gamePoss forKey:@"gamePoss"];
    [aCoder encodeInt:gameYardLine forKey:@"gameYardLine"];
    [aCoder encodeInt:gameDown forKey:@"gameDown"];
    [aCoder encodeInt:gameYardsNeed forKey:@"gameYardsNeed"];
    
    [aCoder encodeInt:_homeScore forKey:@"homeScore"];
    [aCoder encodeInt:_awayScore forKey:@"awayScore"];
    [aCoder encodeBool:_hasPlayed forKey:@"hasPlayed"];
    [aCoder encodeObject:_gameName forKey:@"gameName"];
    
    [aCoder encodeObject:_homeQScore forKey:@"homeQScore"];
    [aCoder encodeObject:_awayQScore forKey:@"awayQScore"];
    
    [aCoder encodeInt:_homeYards forKey:@"homeYards"];
    [aCoder encodeInt:_awayYards forKey:@"awayYards"];
    [aCoder encodeInt:_numOT forKey:@"numOT"];
    [aCoder encodeInt:_homeTOs forKey:@"homeTOs"];
    [aCoder encodeInt:_awayTOs forKey:@"awayTOs"];
    
    [aCoder encodeObject:_HomeQBStats forKey:@"HomeQBStats"];
    
    [aCoder encodeObject:_HomeRB1Stats forKey:@"HomeRB1Stats"];
    [aCoder encodeObject:_HomeRB2Stats forKey:@"HomeRB2Stats"];
    
    [aCoder encodeObject:_HomeWR1Stats forKey:@"HomeWR1Stats"];
    [aCoder encodeObject:_HomeWR2Stats forKey:@"HomeWR2Stats"];
    [aCoder encodeObject:_HomeWR3Stats forKey:@"HomeWR3Stats"];
    [aCoder encodeObject:_HomeKStats forKey:@"HomeKStats"];
    
    [aCoder encodeObject:_AwayQBStats forKey:@"AwayQBStats"];
    
    [aCoder encodeObject:_AwayRB1Stats forKey:@"AwayRB1Stats"];
    [aCoder encodeObject:_AwayRB2Stats forKey:@"AwayRB2Stats"];
    
    [aCoder encodeObject:_AwayWR1Stats forKey:@"AwayWR1Stats"];
    [aCoder encodeObject:_AwayWR2Stats forKey:@"AwayWR2Stats"];
    [aCoder encodeObject:_AwayWR3Stats forKey:@"AwayWR3Stats"];
    [aCoder encodeObject:_AwayKStats forKey:@"AwayKStats"];
    
    [aCoder encodeObject:_homeTeam forKey:@"homeTeam"];
    [aCoder encodeObject:_awayTeam forKey:@"awayTeam"];
    
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        gameEventLog = [aDecoder decodeObjectForKey:@"gameEventLog"];
        tdInfo = [aDecoder decodeObjectForKey:@"tdInfo"];
        gameTime = [aDecoder decodeIntForKey:@"gameTime"];
        gamePoss = [aDecoder decodeBoolForKey:@"gamePoss"];
        gameDown = [aDecoder decodeIntForKey:@"gameDown"];
        gameYardsNeed = [aDecoder decodeIntForKey:@"gameYardsNeed"];
        
        _homeTeam = [aDecoder decodeObjectForKey:@"homeTeam"];
        _awayTeam = [aDecoder decodeObjectForKey:@"awayTeam"];
        
        _homeScore = [aDecoder decodeIntForKey:@"homeScore"];
        _awayScore = [aDecoder decodeIntForKey:@"awayScore"];
        _numOT = [aDecoder decodeIntForKey:@"numOT"];
        _homeTOs = [aDecoder decodeIntForKey:@"homeTOs"];
        _awayTOs = [aDecoder decodeIntForKey:@"awayTOs"];
        _awayYards = [aDecoder decodeIntForKey:@"awayYards"];
        _homeYards = [aDecoder decodeIntForKey:@"homeYards"];
        _hasPlayed = [aDecoder decodeBoolForKey:@"hasPlayed"];
        _gameName = [aDecoder decodeObjectForKey:@"gameName"];
        _homeQScore = [aDecoder decodeObjectForKey:@"homeQScore"];
        _awayQScore = [aDecoder decodeObjectForKey:@"awayQScore"];
        
        _HomeQBStats = [aDecoder decodeObjectForKey:@"HomeQBStats"];
        _HomeRB1Stats = [aDecoder decodeObjectForKey:@"HomeRB1Stats"];
        _HomeRB2Stats = [aDecoder decodeObjectForKey:@"HomeRB2Stats"];
        _HomeWR1Stats = [aDecoder decodeObjectForKey:@"HomeWR1Stats"];
        _HomeWR2Stats = [aDecoder decodeObjectForKey:@"HomeWR2Stats"];
        _HomeWR3Stats = [aDecoder decodeObjectForKey:@"HomeWR3Stats"];
        
        _AwayQBStats = [aDecoder decodeObjectForKey:@"AwayQBStats"];
        _AwayRB1Stats = [aDecoder decodeObjectForKey:@"AwayRB1Stats"];
        _AwayRB2Stats = [aDecoder decodeObjectForKey:@"AwayRB2Stats"];
        _AwayWR1Stats = [aDecoder decodeObjectForKey:@"AwayWR1Stats"];
        _AwayWR2Stats = [aDecoder decodeObjectForKey:@"AwayWR2Stats"];
        _AwayWR3Stats = [aDecoder decodeObjectForKey:@"AwayWR3Stats"];
        
        _HomeKStats = [aDecoder decodeObjectForKey:@"HomeKStats"];
        _AwayKStats = [aDecoder decodeObjectForKey:@"AwayKStats"];
    }
    return self;
}

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
        
        if ([_gameName isEqualToString:@"In Conf"] && ([_homeTeam.rivalTeam isEqualToString:_awayTeam.abbreviation] || [_awayTeam.rivalTeam isEqualToString:_homeTeam.abbreviation])) {
            // Rivalry game!
            _gameName = @"Rivalry Game";
        }
    }
    return self;
}

-(NSString*)gameSummary {
    return gameEventLog;
}

-(NSDictionary*)gameReport {
    NSMutableDictionary *report = [NSMutableDictionary dictionary];
    
    if (_hasPlayed) {
        //Points/stats dictionary - away, home
        NSMutableDictionary *gameStats = [NSMutableDictionary dictionary]; //score, total yards, pass yards, rush yards
        [gameStats setObject:@[[NSString stringWithFormat:@"%d",_awayScore],
                               [NSString stringWithFormat:@"%d",_homeScore]] forKey:@"Score"];
        [gameStats setObject:@[[NSString stringWithFormat:@"%d",_awayYards],
                               [NSString stringWithFormat:@"%d",_homeYards]] forKey:@"Total Yards"];
        [gameStats setObject:@[[NSString stringWithFormat:@"%d",[self getPassYards:TRUE]],
                               [NSString stringWithFormat:@"%d",[self getPassYards:FALSE]]] forKey:@"Pass Yards"];
        [gameStats setObject:@[[NSString stringWithFormat:@"%d",[self getRushYards:TRUE]],
                               [NSString stringWithFormat:@"%d",[self getRushYards:FALSE]]] forKey:@"Rush Yards"];
        
        [report setObject:gameStats forKey:@"gameStats"];
        
        //QBs - dicts go home, away - yes, I'm aware that's confusing
        NSMutableDictionary *qbs = [NSMutableDictionary dictionary];
        [qbs setObject:[_homeTeam getQB:0] forKey:@"homeQB"];
        [qbs setObject:_HomeQBStats forKey:@"homeQBStats"];
        
        [qbs setObject:[_awayTeam getQB:0] forKey:@"awayQB"];
        [qbs setObject:_AwayQBStats forKey:@"awayQBStats"];
        [report setObject:qbs forKey:@"QBs"];
        
        //RBs
        NSMutableDictionary *rbs = [NSMutableDictionary dictionary];
        [rbs setObject:[_homeTeam getRB:0] forKey:@"homeRB1"];
        [rbs setObject:_HomeRB1Stats forKey:@"homeRB1Stats"];
        
        [rbs setObject:[_homeTeam getRB:1] forKey:@"homeRB2"];
        [rbs setObject:_HomeRB2Stats forKey:@"homeRB2Stats"];
        
        [rbs setObject:[_awayTeam getRB:0] forKey:@"awayRB1"];
        [rbs setObject:_AwayRB1Stats forKey:@"awayRB1Stats"];
        
        [rbs setObject:[_awayTeam getRB:1] forKey:@"awayRB2"];
        [rbs setObject:_AwayRB2Stats forKey:@"awayRB2Stats"];
        
        [report setObject:rbs forKey:@"RBs"];
        
        //WRs
        NSMutableDictionary *wrs = [NSMutableDictionary dictionary];
        
        [wrs setObject:[_homeTeam getWR:0] forKey:@"homeWR1"];
        [wrs setObject:_HomeWR1Stats forKey:@"homeWR1Stats"];
        
        [wrs setObject:[_homeTeam getWR:1] forKey:@"homeWR2"];
        [wrs setObject:_HomeWR2Stats forKey:@"homeWR2Stats"];
        
        [wrs setObject:[_homeTeam getWR:2] forKey:@"homeWR3"];
        [wrs setObject:_HomeWR3Stats forKey:@"homeWR3Stats"];
        
        [wrs setObject:[_awayTeam getWR:0] forKey:@"awayWR1"];
        [wrs setObject:_AwayWR1Stats forKey:@"awayWR1Stats"];
        
        [wrs setObject:[_awayTeam getWR:1] forKey:@"awayWR2"];
        [wrs setObject:_AwayWR2Stats forKey:@"awayWR2Stats"];
        
        [wrs setObject:[_awayTeam getWR:2] forKey:@"awayWR3"];
        [wrs setObject:_AwayWR3Stats forKey:@"awayWR3Stats"];
        
        
        [report setObject:wrs forKey:@"WRs"];
        
        //Ks
        NSMutableDictionary *ks = [NSMutableDictionary dictionary];
        [ks setObject:[_homeTeam getK:0] forKey:@"homeK"];
        [ks setObject:_HomeKStats forKey:@"homeKStats"];
        
        [ks setObject:[_awayTeam getK:0] forKey:@"awayK"];
        [ks setObject:_AwayKStats forKey:@"awayKStats"];
        [report setObject:ks forKey:@"Ks"];
        
    } else {
        // array goes away, home
        int appg, hppg, aoppg, hoppg, aypg, hypg, aoypg, hoypg, apypg, hpypg, aopypg, hopypg, aorypg, horypg, arypg, hrypg;
        
        if ([HBSharedUtils getLeague].currentWeek > 0) {
            appg = (int)((double)_awayTeam.teamPoints / ((double)([HBSharedUtils getLeague].currentWeek)));
            hppg = (int)((double)_homeTeam.teamPoints / ((double)([HBSharedUtils getLeague].currentWeek)));
            
            aoppg = (int)((double)_awayTeam.teamOppPoints / ((double)([HBSharedUtils getLeague].currentWeek)));
            hoppg = (int)((double)_homeTeam.teamOppPoints / ((double)([HBSharedUtils getLeague].currentWeek)));
            
            aypg = (int)((double)_awayTeam.teamYards / ((double)([HBSharedUtils getLeague].currentWeek)));
            hypg = (int)((double)_homeTeam.teamYards / ((double)([HBSharedUtils getLeague].currentWeek)));
            
            aoypg = (int)((double)_awayTeam.teamOppYards / ((double)([HBSharedUtils getLeague].currentWeek)));
            hoypg = (int)((double)_homeTeam.teamOppYards / ((double)([HBSharedUtils getLeague].currentWeek)));
            
            apypg = (int)((double)_awayTeam.teamPassYards / ((double)([HBSharedUtils getLeague].currentWeek)));
            hpypg = (int)((double)_homeTeam.teamPassYards / ((double)([HBSharedUtils getLeague].currentWeek)));
            
            arypg = (int)((double)_awayTeam.teamRushYards / ((double)([HBSharedUtils getLeague].currentWeek)));
            hrypg = (int)((double)_homeTeam.teamRushYards / ((double)([HBSharedUtils getLeague].currentWeek)));
            
            aopypg = (int)((double)_awayTeam.teamOppPassYards / ((double)([HBSharedUtils getLeague].currentWeek)));
            hopypg = (int)((double)_homeTeam.teamOppPassYards / ((double)([HBSharedUtils getLeague].currentWeek)));
            
            aorypg = (int)((double)_awayTeam.teamOppRushYards / ((double)([HBSharedUtils getLeague].currentWeek)));
            horypg = (int)((double)_homeTeam.teamOppRushYards / ((double)([HBSharedUtils getLeague].currentWeek)));
        } else {
            appg = 0;
            hppg = 0;
            aoppg = 0;
            hoppg = 0;
            aypg = 0;
            hypg = 0;
            aoypg = 0;
            hoypg = 0;
            apypg = 0;
            hpypg = 0;
            aopypg = 0;
            hopypg = 0;
            aorypg = 0;
            horypg = 0;
            arypg = 0;
            hrypg = 0;

        }
        
        
        [report setObject:@[[NSString stringWithFormat:@"#%d",_awayTeam.rankTeamPollScore],
                            [NSString stringWithFormat:@"#%d",_homeTeam.rankTeamPollScore]] forKey:@"Ranking"];
        [report setObject:@[[NSString stringWithFormat:@"%d-%d",_awayTeam.wins,_awayTeam.losses],
                            [NSString stringWithFormat:@"%d-%d",_homeTeam.wins,_homeTeam.losses]] forKey:@"Record"];
        [report setObject:@[[NSString stringWithFormat:@"%d (#%d)",appg,_awayTeam.rankTeamPoints],
                            [NSString stringWithFormat:@"%d (#%d)",hppg,_homeTeam.rankTeamPoints]] forKey:@"Points Per Game"];
        [report setObject:@[[NSString stringWithFormat:@"%d (#%d)",aoppg,_awayTeam.rankTeamOppPoints],
                            [NSString stringWithFormat:@"%d (#%d)",hoppg,_homeTeam.rankTeamOppPoints]] forKey:@"Opp Points Per Game"];
        [report setObject:@[[NSString stringWithFormat:@"%d (#%d)",aypg,_awayTeam.rankTeamYards],
                            [NSString stringWithFormat:@"%d (#%d)",hypg,_homeTeam.rankTeamYards]] forKey:@"Yards Per Game"];
        [report setObject:@[[NSString stringWithFormat:@"%d (#%d)",aoypg,_awayTeam.rankTeamOppYards],
                            [NSString stringWithFormat:@"%d (#%d)",hoypg,_homeTeam.rankTeamOppYards]] forKey:@"Opp Yards Per Game"];
        [report setObject:@[[NSString stringWithFormat:@"%d (#%d)",apypg,_awayTeam.rankTeamPassYards],
                            [NSString stringWithFormat:@"%d (#%d)",hpypg,_homeTeam.rankTeamPassYards]] forKey:@"Pass Yards Per Game"];
        [report setObject:@[[NSString stringWithFormat:@"%d (#%d)",arypg,_awayTeam.rankTeamRushYards],
                            [NSString stringWithFormat:@"%d (#%d)",hrypg,_homeTeam.rankTeamRushYards]] forKey:@"Rush Yards Per Game"];
        [report setObject:@[[NSString stringWithFormat:@"%d (#%d)",aopypg,_awayTeam.rankTeamOppPassYards],
                            [NSString stringWithFormat:@"%d (#%d)",hopypg,_homeTeam.rankTeamOppPassYards]] forKey:@"Opp Pass YPG"];
        [report setObject:@[[NSString stringWithFormat:@"%d (#%d)",aorypg,_awayTeam.rankTeamOppRushYards],
                            [NSString stringWithFormat:@"%d (#%d)",horypg,_homeTeam.rankTeamOppRushYards]] forKey:@"Opp Rush YPG"];
        [report setObject:@[[NSString stringWithFormat:@"%d (#%d)",_awayTeam.teamOffTalent,_awayTeam.rankTeamOffTalent],
                            [NSString stringWithFormat:@"%d (#%d)",_homeTeam.teamOffTalent,_homeTeam.rankTeamOffTalent]] forKey:@"Offensive Talent"];
        [report setObject:@[[NSString stringWithFormat:@"%d (#%d)",_awayTeam.teamDefTalent,_awayTeam.rankTeamDefTalent],
                            [NSString stringWithFormat:@"%d (#%d)",_homeTeam.teamDefTalent,_homeTeam.rankTeamDefTalent]] forKey:@"Defensive Talent"];
        [report setObject:@[[NSString stringWithFormat:@"%d (#%d)",_awayTeam.teamPrestige,_awayTeam.rankTeamPrestige],
                            [NSString stringWithFormat:@"%d (#%d)",_homeTeam.teamPrestige,_homeTeam.rankTeamPrestige]] forKey:@"Prestige"];
    }
    
    return [report copy];
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
    int gameDownAdj;
    if (gameDown > 4) {
        gameDownAdj = 4;
    } else {
        gameDownAdj = gameDown;
    }
    if (gameYardLine + gameYardsNeed >= 100) yardsNeedAdj = @"Goal";
    return [NSString stringWithFormat:@"\n\n%@ %ld - %ld %@, Time: %@,\n\t%@ %ld and %@ at %ld yard line.\n",_homeTeam.abbreviation,(long)_homeScore,(long)_awayScore,_awayTeam.abbreviation, [self convGameTime],possStr,(long)gameDownAdj,yardsNeedAdj,(long)gameYardLine];
}

-(NSString*)convGameTime {
    if (!playingOT) {
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
            return [NSString stringWithFormat:@"%ld:%@ OT%ld",(long)minTime,secStr,(long)_numOT];
        } else {
            minTime = (gameTime - 900*(4-qNum)) / 60;
            secTime = (gameTime - 900*(4-qNum)) - 60*minTime;
            if (secTime < 10) {
                [secStr appendString:[NSString stringWithFormat:@"0%ld", (long)secTime]];
            } else {
                [secStr appendString:[NSString stringWithFormat:@"%ld", (long)secTime]];
            }
            return [NSString stringWithFormat:@"%ld:%@ Q%ld",(long)minTime,secStr,(long)qNum];
        }

    } else {
        if (!bottomOT) {
            if (_numOT > 1) {
                return [NSString stringWithFormat:@"TOP %ldOT",(long)_numOT];
            } else {
                return @"TOP OT";
            }
        } else {
            if (_numOT > 1) {
                return [NSString stringWithFormat:@"BOT %ldOT",(long)_numOT];
            } else {
                return @"BOT OT";
            }
        }
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
            
            /*if (gameTime <= 0 && _homeScore == _awayScore) {
                gameTime = 900; //OT
                gameYardLine = 20;
                _numOT++;
            }*/
        }
        
        if (gameTime <= 0 && _homeScore == _awayScore) {
            playingOT = YES;
            gamePoss = FALSE;
            gameYardLine = 75;
            _numOT++;
            gameTime = -1;
            gameDown = 1;
            gameYardsNeed = 10;
            
            while (playingOT) {
                if (gamePoss) {
                    [self runPlay:_homeTeam defense:_awayTeam];
                } else {
                    [self runPlay:_awayTeam defense:_homeTeam];
                }
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
            
            if ([_homeTeam.teamStreaks.allKeys containsObject:_awayTeam.abbreviation]) {
                NSMutableArray *streak = _homeTeam.teamStreaks[_awayTeam.abbreviation];
                [streak addObject:@"W"];
                [_homeTeam.teamStreaks setObject:streak forKey:_awayTeam.abbreviation];
            } else {
                [_homeTeam.teamStreaks setObject:[NSMutableArray arrayWithArray:@[@"W"]] forKey:_awayTeam.abbreviation];
            }
            
            if ([_awayTeam.teamStreaks.allKeys containsObject:_homeTeam.abbreviation]) {
                NSMutableArray *streak = _awayTeam.teamStreaks[_homeTeam.abbreviation];
                [streak addObject:@"L"];
                [_awayTeam.teamStreaks setObject:streak forKey:_homeTeam.abbreviation];
            } else {
                [_awayTeam.teamStreaks setObject:[NSMutableArray arrayWithArray:@[@"L"]] forKey:_homeTeam.abbreviation];
            }
        } else {
            _homeTeam.losses++;
            _homeTeam.totalLosses++;
            [_homeTeam.gameWLSchedule addObject:@"L"];
            _awayTeam.wins++;
            _awayTeam.totalWins++;
            [_awayTeam.gameWLSchedule addObject:@"W"];
            [_awayTeam.gameWinsAgainst addObject:_homeTeam];
            
            if ([_homeTeam.teamStreaks.allKeys containsObject:_awayTeam.abbreviation]) {
                NSMutableArray *streak = _homeTeam.teamStreaks[_awayTeam.abbreviation];
                [streak addObject:@"L"];
                [_homeTeam.teamStreaks setObject:streak forKey:_awayTeam.abbreviation];
            } else {
                [_homeTeam.teamStreaks setObject:[NSMutableArray arrayWithArray:@[@"L"]] forKey:_awayTeam.abbreviation];
            }
            
            if ([_awayTeam.teamStreaks.allKeys containsObject:_homeTeam.abbreviation]) {
                NSMutableArray *streak = _awayTeam.teamStreaks[_homeTeam.abbreviation];
                [streak addObject:@"W"];
                [_awayTeam.teamStreaks setObject:streak forKey:_homeTeam.abbreviation];
            } else {
                [_awayTeam.teamStreaks setObject:[NSMutableArray arrayWithArray:@[@"W"]] forKey:_homeTeam.abbreviation];
            }
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
                _awayTeam.wonRivalryGame = false;
            } else {
                _awayTeam.wonRivalryGame = true;
                _homeTeam.wonRivalryGame = false;
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
    } else if (_homeScore > _awayScore && [_homeTeam.teamStreaks[_awayTeam.abbreviation][_homeTeam.teamStreaks[_awayTeam.abbreviation].count - 1] isEqualToString:@"L"] && [_homeTeam.teamStreaks[_awayTeam.abbreviation][_homeTeam.teamStreaks[_awayTeam.abbreviation].count - 2] isEqualToString:@"L"] && [_homeTeam.teamStreaks[_awayTeam.abbreviation][_homeTeam.teamStreaks[_awayTeam.abbreviation].count - 3] isEqualToString:@"L"]) {
        //home snaps losing streak
        currentWeekNews = _homeTeam.league.newsStories[_awayTeam.league.currentWeek+1];
        [currentWeekNews addObject:[NSString stringWithFormat:@"Losing Streak Broken! %@ beats %@\n%@ beats %@ %ld to %ld at home, snapping its skid against them.", _homeTeam.strRep, _awayTeam.strRep, _homeTeam.name, _awayTeam.name, (long)_homeScore, (long)_awayScore]];
    } else if (_awayScore > _homeScore && [_awayTeam.teamStreaks[_homeTeam.abbreviation][_awayTeam.teamStreaks[_homeTeam.abbreviation].count - 1] isEqualToString:@"L"] && [_awayTeam.teamStreaks[_homeTeam.abbreviation][_awayTeam.teamStreaks[_homeTeam.abbreviation].count - 2] isEqualToString:@"L"] && [_awayTeam.teamStreaks[_homeTeam.abbreviation][_awayTeam.teamStreaks[_homeTeam.abbreviation].count - 3] isEqualToString:@"L"]) {
        //away snaps losing streak
        currentWeekNews = _awayTeam.league.newsStories[_homeTeam.league.currentWeek+1];
        [currentWeekNews addObject:[NSString stringWithFormat:@"Losing Streak Broken! %@ beats %@\n%@ beats %@ %ld to %ld on the road, snapping its skid against them.", _awayTeam.strRep, _homeTeam.strRep, _awayTeam.name, _homeTeam.name, (long)_awayScore, (long)_homeScore]];
    } else if (_homeScore < _awayScore && [_homeTeam.teamStreaks[_awayTeam.abbreviation][_homeTeam.teamStreaks[_awayTeam.abbreviation].count - 1] isEqualToString:@"W"] && [_homeTeam.teamStreaks[_awayTeam.abbreviation][_homeTeam.teamStreaks[_awayTeam.abbreviation].count - 2] isEqualToString:@"W"] && [_homeTeam.teamStreaks[_awayTeam.abbreviation][_homeTeam.teamStreaks[_awayTeam.abbreviation].count - 3] isEqualToString:@"W"]) {
        //home loses winning streak
        currentWeekNews = _homeTeam.league.newsStories[_awayTeam.league.currentWeek+1];
        [currentWeekNews addObject:[NSString stringWithFormat:@"Winning Streak Over! %@ beats %@\n%@ beats %@ %ld to %ld at home, snapping %@'s streak against them.", _awayTeam.strRep, _homeTeam.strRep, _awayTeam.name, _homeTeam.name, (long)_awayScore, (long)_homeScore, _homeTeam.abbreviation]];
    } else if (_awayScore < _homeScore && [_awayTeam.teamStreaks[_homeTeam.abbreviation][_awayTeam.teamStreaks[_homeTeam.abbreviation].count - 1] isEqualToString:@"W"] && [_awayTeam.teamStreaks[_homeTeam.abbreviation][_awayTeam.teamStreaks[_homeTeam.abbreviation].count - 2] isEqualToString:@"W"] && [_awayTeam.teamStreaks[_homeTeam.abbreviation][_awayTeam.teamStreaks[_homeTeam.abbreviation].count - 3] isEqualToString:@"W"]) {
        //away loses winning streak
        currentWeekNews = _awayTeam.league.newsStories[_homeTeam.league.currentWeek+1];
        [currentWeekNews addObject:[NSString stringWithFormat:@"Winning Streak Over! %@ beats %@\n%@ beats %@ %ld to %ld at home, snapping %@'s streak against them.", _homeTeam.strRep, _awayTeam.strRep, _homeTeam.name, _awayTeam.name, (long)_homeScore, (long)_awayScore, _awayTeam.abbreviation]];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"newNewsStory" object:nil];
}

-(void)runPlay:(Team *)offense defense:(Team *)defense {
    if ( gameDown > 4 ) {
        if (!playingOT) {
            [gameEventLog appendFormat:@"%@TURNOVER ON DOWNS!\n%@ failed to convert on 4th down. %@ takes over on downs.",[self getEventPrefix],offense.abbreviation,defense.abbreviation];
            gamePoss = !gamePoss;
            gameDown = 1;
            gameYardsNeed = 10;
            gameYardLine = 100 - gameYardLine;
        } else {
            [gameEventLog appendFormat:@"%@TURNOVER ON DOWNS!\n%@ failed to convert on 4th down in OT and lost possession.",[self getEventPrefix],offense.abbreviation];
            [self resetForOT];
        }
    } else {
        double preferPass = ([offense getPassProf]*2 - [defense getPassDef]) *[HBSharedUtils randomValue] - 10;
        double preferRush = ([offense getRushProf]*2 - [defense getRushDef]) *[HBSharedUtils randomValue] + offense.offensiveStrategy.rushYdBonus;
        
        if (gameDown == 1 && gameYardLine >= 91) {
            gameYardsNeed = 100 - gameYardLine;
        }
        
        if ( gameTime <= 30 && !playingOT ) {
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
}

-(void)resetForOT {
    if (bottomOT && _homeScore == _awayScore) {
        gameYardLine = 75;
        gameYardsNeed = 10;
        gameDown = 1;
        _numOT++;
        if ((_numOT % 2) == 0) {
            gamePoss = FALSE;
        } else {
            gamePoss = TRUE;
        }
        gameTime = -1;
        bottomOT = FALSE;
    } else if (!bottomOT) {
        gamePoss = !gamePoss;
        gameYardLine = 75;
        gameYardsNeed = 10;
        gameDown = 1;
        gameTime = -1;
        bottomOT = TRUE;
    } else {
        playingOT = FALSE;
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
    if ( 100* [HBSharedUtils randomValue] < intChance ) {
        //Interception
        [self qbInterception:offense];
        return;
    }
    
    //throw ball, check for completion
    double completion = ( [self getHFAdv] + [self normalize:[offense getQB:0].ratPassAcc] + [self normalize:selWR.ratRecCat] - [self normalize:selCB.ratCBCov])/2 + 18.25 - pressureOnQB/16.8 - offense.offensiveStrategy.passAgBonus - defense.defensiveStrategy.passAgBonus;
    if ( 100* [HBSharedUtils randomValue] < completion ) {
        if ( 100* [HBSharedUtils randomValue] < (100 - selWR.ratRecCat)/3 ) {
            //drop
            gameDown++;
            NSNumber *wrStat = selWRStats[4];
            wrStat = [NSNumber numberWithInteger:wrStat.integerValue + 1];
            [selWRStats replaceObjectAtIndex:4 withObject:wrStat];
            selWR.statsDrops++;
            [self passAttempt:offense defense:defense receiver:selWR stats:selWRStats yardsGained:yardsGain];
            gameTime -= (15 * [HBSharedUtils randomValue]);
            return;
        } else {
            //no drop
            yardsGain = (int) (( [self normalize:[offense getQB:0].ratPassPow] + [self normalize:selWR.ratRecSpd] - [self normalize:selCB.ratCBSpd] )* [HBSharedUtils randomValue]/3.7 + offense.offensiveStrategy.passYdBonus/2 - defense.defensiveStrategy.passYdBonus);
            //see if receiver can get yards after catch
            double escapeChance = ([self normalize:(selWR.ratRecEva)*3 - selCB.ratCBTkl - [defense getS:0].ratOvr]* [HBSharedUtils randomValue] + offense.offensiveStrategy.passYdBonus - defense.defensiveStrategy.passAgBonus);
            if ( escapeChance > 92 ||[HBSharedUtils randomValue] > 0.95 ) {
                yardsGain += 3 + selWR.ratRecSpd* [HBSharedUtils randomValue]/3;
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
                if ( 100* [HBSharedUtils randomValue] < fumChance/40 ) {
                    //Fumble!
                    gotFumble = true;
                }
            }
            
            if (!gotTD && !gotFumble) {
                //check downs
                gameYardsNeed -= yardsGain;
                if ( gameYardsNeed <= 0) {
                    gameDown = 1;
                    gameYardsNeed = 10;
                } else gameDown++;
            }
            
            //stats management
            [self passCompletion:offense defense:defense receiver:selWR stats:selWRStats yardsGained:yardsGain];
        }
        
    } else {
        //no completion, advance downs
        [self passAttempt:offense defense:defense receiver:selWR stats:selWRStats yardsGained:yardsGain];
        gameDown++;
        gameTime -= (15 * [HBSharedUtils randomValue]);
        return;
    }
    
    //passAttempt(offense, selWR, selWRStats, yardsGain);
    [self passAttempt:offense defense:defense receiver:selWR stats:selWRStats yardsGained:yardsGain];
    
    
    if ( gotFumble ) {
        [gameEventLog appendString:[NSString stringWithFormat:@"%@TURNOVER!\n%@ WR %@ fumbled the ball after a catch.", [self getEventPrefix],offense.abbreviation,selWR.name]];
        NSNumber *wrFum = selWRStats[5];
        wrFum = [NSNumber numberWithInteger:wrFum.integerValue + 1];
        [selWRStats replaceObjectAtIndex:5 withObject:wrFum];
        selWR.statsFumbles++;
    
        if ( gamePoss ) { // home possession
            _homeTOs++;
        } else {
            _awayTOs++;
        }
        
        if (!playingOT) {
            gameDown = 1;
            gameYardsNeed = 10;
            gamePoss = !gamePoss;
            gameYardLine = 100 - gameYardLine;
            gameTime -= (15 * [HBSharedUtils randomValue]);
            return;
        } else {
            [self resetForOT];
            return;
        }
    }
    
    if ( gotTD ) {
        gameTime -= (15 * [HBSharedUtils randomValue]);
        [self kickXP:offense defense:defense];
        if (!playingOT) {
            [self kickOff:offense];
        } else {
            [self resetForOT];
        }
        return;
    }
    
    gameTime -= 15 + 15* [HBSharedUtils randomValue];

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
        if ([HBSharedUtils randomValue] < ( 0.28 + ( offense.offensiveStrategy.rushAgBonus - defense.defensiveStrategy.rushYdBonus/2 )/50 )) {
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
                [_HomeRB1Stats replaceObjectAtIndex:2 withObject:kStat1];
            } else {
                NSNumber *kStat1 = _HomeRB2Stats[2];
                kStat1 = [NSNumber numberWithInteger:kStat1.integerValue + 1];
                [_HomeRB2Stats replaceObjectAtIndex:2 withObject:kStat1];
            }
        } else {
            _awayScore += 6;
            if (RB1pref > RB2pref) {
                NSNumber *kStat1 = _AwayRB1Stats[2];
                kStat1 = [NSNumber numberWithInteger:kStat1.integerValue + 1];
                [_AwayRB1Stats replaceObjectAtIndex:2 withObject:kStat1];
            } else {
                NSNumber *kStat1 = _AwayRB2Stats[2];
                kStat1 = [NSNumber numberWithInteger:kStat1.integerValue + 1];
                [_AwayRB2Stats replaceObjectAtIndex:2 withObject:kStat1];
            }
        }
        tdInfo = [NSString stringWithFormat:@"%@ RB %@ rushed %d yards for a TD.", offense.abbreviation,selRB.name,yardsGain];
        selRB.statsTD++;
        //offense.teamPoints += 6;
        //defense.teamOppPoints += 6;
        
        gotTD = true;
    }
    
    //check downs
    if (!gotTD) {
        gameYardsNeed -= yardsGain;
        if ( gameYardsNeed <= 0 ) {
            gameDown = 1;
            gameYardsNeed = 10;
        } else gameDown++;
    }
    
    //stats management
    [self rushAttempt:offense defense:defense rusher:selRB rb1Pref:RB1pref rb2Pref:RB2pref yardsGained:yardsGain];
    
    if ( gotTD ) {
        [self kickXP:offense defense:defense];
        if (!playingOT) {
            [self kickOff:offense];
        } else {
            [self resetForOT];
        }
    } else {
        gameTime -= 25 + 15* [HBSharedUtils randomValue];
        //check for fumble
        double fumChance = ([defense getS:0].ratSTkl + [defense getCompositeF7Rush] - [self getHFAdv])/2 + offense.offensiveStrategy.rushAgBonus;
        if ( 100* [HBSharedUtils randomValue] < fumChance/40 ) {
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
            if (!playingOT) {
                gameDown = 1;
                gameYardsNeed = 10;
                gamePoss = !gamePoss;
                gameYardLine = 100 - gameYardLine;
            } else {
                [self resetForOT];
            }
        }
    }
}

-(void)fieldGoalAtt:(Team *)offense defense:(Team *)defense {
    double fgDistRatio = pow((110 - gameYardLine)/50,2);
    double fgAccRatio = pow((110 - gameYardLine)/50,1.25);
    double fgDistChance = ( [self getHFAdv] + [offense getK:0].ratKickPow - fgDistRatio*80 );
    double fgAccChance = ( [self getHFAdv] + [offense getK:0].ratKickAcc - fgAccRatio*80 );
    if ( fgDistChance > 20 && fgAccChance* [HBSharedUtils randomValue] > 15 ) {
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
         [gameEventLog appendString:[NSString stringWithFormat:@"%@%@ K %@ made the %d yard FG.",[self getEventPrefix], offense.abbreviation, [offense getK:0].name, (110-gameYardLine)]];
        [self addPointsQuarter:3];
        //offense.teamPoints += 3;
        //defense.teamOppPoints += 3;
        [offense getK:0].statsFGMade++;
        [offense getK:0].statsFGAtt++;
        if (!playingOT) {
            [self kickOff:offense];
        } else {
            [self resetForOT];
        }
        
    } else {
        //miss
        
        [gameEventLog appendString:[NSString stringWithFormat:@"%@%@ K %@ missed the %d yard FG!",[self getEventPrefix], offense.abbreviation, [offense getK:0].name, (110-gameYardLine)]];
        [offense getK:0].statsFGAtt++;
        if ( gamePoss ) { // home possession
            NSNumber *kStat1 = _HomeKStats[3];
            kStat1 = [NSNumber numberWithInteger:kStat1.integerValue + 1];
            [_HomeKStats replaceObjectAtIndex:3 withObject:kStat1];
        } else {
            NSNumber *kStat1 = _AwayKStats[3];
            kStat1 = [NSNumber numberWithInteger:kStat1.integerValue + 1];
            [_AwayKStats replaceObjectAtIndex:3 withObject:kStat1];
        }
        if (!playingOT) {
            gameYardLine = MAX(100 - gameYardLine, 20);
            gameDown = 1;
            gameYardsNeed = 10;
            gamePoss = !gamePoss;
        } else {
            [self resetForOT];
        }
        
    }
    
    gameTime -= 20;
 
}

-(void)kickXP:(Team *)offense defense:(Team *)defense {
    if ((_numOT >= 3) || (((gamePoss && (_awayScore - _homeScore) == 2) || (!gamePoss && (_homeScore - _awayScore) == 2)) && gameTime < 300) ) {
        //go for 2
        BOOL successConversion = false;
        if ([HBSharedUtils randomValue] <= 0.50 ) {
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
                [gameEventLog appendString:[NSString stringWithFormat:@"%@%@%@ rushed for the 2pt conversion.",[self getEventPrefix],tdInfo,[offense getRB:0].name]];
            } else {
                [gameEventLog appendString:[NSString stringWithFormat:@"%@%@%@ stopped at the line of scrimmage, failed the 2pt conversion.",[self getEventPrefix],tdInfo,[offense getRB:0].name]];
            }
        } else {
            int pressureOnQB = [defense getCompositeF7Pass]*2 - [offense getCompositeOLPass];
            double completion = ( [self normalize:[offense getQB:0].ratPassAcc] + [offense getWR:0].ratRecCat - [defense getCB:0].ratCBCov )/2 + 25 - pressureOnQB/20;
            if ( 100* [HBSharedUtils randomValue] < completion ) {
                successConversion = true;
                if ( gamePoss ) { // home possession
                    _homeScore += 2;
                } else {
                    _awayScore += 2;
                }
                [self addPointsQuarter:2];
                [gameEventLog appendString:[NSString stringWithFormat:@"%@%@ 2pt conversion is good! %@ completed the pass to %@ for the 2pt conversion.",[self getEventPrefix],tdInfo,[offense getQB:0].name, [offense getWR:0].name]];
            } else {
                [gameEventLog appendString:[NSString stringWithFormat:@"%@%@ 2pt conversion failed! %@'s pass incomplete to %@.",[self getEventPrefix],tdInfo,[offense getQB:0].name, [offense getWR:0].name]];
            }
        }
        
    } else {
        //kick XP
        if ([HBSharedUtils randomValue]*100 < 23 + [offense getK:0].ratKickAcc && [HBSharedUtils randomValue] > 0.01) {
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
            
            [gameEventLog appendString:[NSString stringWithFormat:@"%@%@ %@ made the XP.",[self getEventPrefix],tdInfo,[offense getK:0].name]];
            [self addPointsQuarter:1];
            [offense getK:0].statsXPMade++;
        } else {
            [gameEventLog appendString:[NSString stringWithFormat:@"%@%@ %@ missed the XP.",[self getEventPrefix],tdInfo,[offense getK:0].name]];
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
            [gameEventLog appendString:[NSString stringWithFormat:@"%@%@ K %@ successfully executes onside kick! %@ has possession!",[self getEventPrefix], offense.abbreviation, [offense getK:0].name, offense.abbreviation]];
        } else {
            // Fail
            [gameEventLog appendString:[NSString stringWithFormat:@"%@%@ K %@ failed to convert the onside kick. %@ lost possession.",[self getEventPrefix], offense.abbreviation, [offense getK:0].name, offense.abbreviation]];
            gamePoss = !gamePoss;
        }
        gameYardLine = 50;
        gameDown = 1;
        gameYardsNeed = 10;
        gameTime -= (4 + (5 * [HBSharedUtils randomValue]));
    } else {
        // Just regular kick off
        gameYardLine = (int) (100 - ([offense getK:0].ratKickPow + 20 - 40* [HBSharedUtils randomValue] ));
        if ( gameYardLine <= 0 ) gameYardLine = 25;
        gameDown = 1;
        gameYardsNeed = 10;
        gamePoss = !gamePoss;
    }
}

-(void)puntPlay:(Team *)offense {
    gameYardLine = (int) (100 - ( gameYardLine + [offense getK:0].ratKickPow/3 + 20 - 10* [HBSharedUtils randomValue] ));
    if ( gameYardLine < 0 ) {
        gameYardLine = 20;
    }
    gameDown = 1;
    gameYardsNeed = 10;
    gamePoss = !gamePoss;
    
    gameTime -= 20 + 15* [HBSharedUtils randomValue];
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
        gameTime -= (10 * [HBSharedUtils randomValue]);
        [self safety];
    }
    
    gameTime -=  (25 + (10 * [HBSharedUtils randomValue]));
}

-(void)safety {
    if (gamePoss) {
        _awayScore += 2;
        [gameEventLog appendString:[NSString stringWithFormat:@"%@SAFETY!\n%@ QB %@ was tackled in the endzone! Result is a safety and %@ will get the ball.", [self getEventPrefix],_homeTeam.abbreviation,[_homeTeam getQB:0].name,_awayTeam.abbreviation]];
        [self freeKick:_homeTeam];
    } else {
        _homeScore += 2;
        [gameEventLog appendString:[NSString stringWithFormat:@"%@SAFETY!\n%@ QB %@ was tackled in the endzone! Result is a safety and %@ will get the ball.", [self getEventPrefix],_awayTeam.abbreviation,[_awayTeam getQB:0].name,_homeTeam.abbreviation]];
        [self freeKick:_awayTeam];
    }
}

-(void)qbInterception:(Team *)offense {
    if ( gamePoss ) { // home possession
        NSNumber *qbInt = _HomeQBStats[3];
        qbInt = [NSNumber numberWithInteger:qbInt.integerValue + 1];
        [_HomeQBStats replaceObjectAtIndex:3 withObject:qbInt];
        
        NSNumber *qbStat = _HomeQBStats[0];
        qbStat = [NSNumber numberWithInteger:qbStat.integerValue + 1];
        [_HomeQBStats replaceObjectAtIndex:0 withObject:qbStat];
        _homeTOs++;
    } else {
        NSNumber *qbInt = _AwayQBStats[3];
        qbInt = [NSNumber numberWithInteger:qbInt.integerValue + 1];
        [_AwayQBStats replaceObjectAtIndex:3 withObject:qbInt];
        
        NSNumber *qbStat = _AwayQBStats[0];
        qbStat = [NSNumber numberWithInteger:qbStat.integerValue + 1];
        [_AwayQBStats replaceObjectAtIndex:0 withObject:qbStat];
        _awayTOs++;
    }
    [gameEventLog appendString:[NSString stringWithFormat:@"%@TURNOVER!\n%@ QB %@ was intercepted.", [self getEventPrefix], offense.abbreviation, [offense getQB:0].name]];
    gameTime -= (15 * [HBSharedUtils randomValue]);
    [offense getQB:0].statsInt++;
    if (!playingOT) {
        gameDown = 1;
        gameYardsNeed = 10;
        gamePoss = !gamePoss;
        gameYardLine = 100 - gameYardLine;
    } else {
        [self resetForOT];
    }
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
    tdInfo = [NSString stringWithFormat:@"%@ QB %@ threw a %ld yard TD to %@.\n",offense.abbreviation,[offense getQB:0].name,(long)yardsGained,selWR.name];
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
        NSNumber *qbAtt = _HomeQBStats[0];
        qbAtt = [NSNumber numberWithInteger:qbAtt.integerValue + 1];
        [_HomeQBStats replaceObjectAtIndex:0 withObject:qbAtt];
        
        NSNumber *qbComp = _HomeQBStats[1];
        qbComp = [NSNumber numberWithInteger:qbComp.integerValue + 1];
        [_HomeQBStats replaceObjectAtIndex:1 withObject:qbComp];
        
        NSNumber *wrTarget = selWRStats[0];
        wrTarget = [NSNumber numberWithInteger:wrTarget.integerValue + 1];
        [selWRStats replaceObjectAtIndex:0 withObject:wrTarget];
    } else {
        NSNumber *qbStat = _AwayQBStats[0];
        qbStat = [NSNumber numberWithInteger:qbStat.integerValue + 1];
        [_AwayQBStats replaceObjectAtIndex:0 withObject:qbStat];
        
        NSNumber *qbComp = _AwayQBStats[1];
        qbComp = [NSNumber numberWithInteger:qbComp.integerValue + 1];
        [_AwayQBStats replaceObjectAtIndex:1 withObject:qbComp];
        
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
            NSNumber *rb2 = _HomeRB2Stats[0];
            rb2 = [NSNumber numberWithInteger:rb2.integerValue + 1];
            [_HomeRB2Stats replaceObjectAtIndex:0 withObject:rb2];
            
            NSNumber *rb2Att = _HomeRB2Stats[1];
            rb2Att = [NSNumber numberWithInteger:rb2Att.integerValue + yardsGained];
            [_HomeRB2Stats replaceObjectAtIndex:1 withObject:rb2Att];
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

-(void)freeKick:(Team*)offense {
    if ( gameTime < 180 && ((gamePoss && (_awayScore - _homeScore) <= 8 && (_awayScore - _homeScore) > 0)
                            || (!gamePoss && (_homeScore - _awayScore) <=8 && (_homeScore - _awayScore) > 0))) {
        // Yes, do onside
        if ([offense getK:0].ratKickFum * [HBSharedUtils randomValue] > 60 || [HBSharedUtils randomValue] < 0.1) {
            //Success!
           // gameEventLog += getEventPrefix() + offense.abbr + " K " + offense.getK(0).name + " successfully executes onside kick! " + offense.abbr + " has possession!";
            [gameEventLog appendString:[NSString stringWithFormat:@"%@%@ K %@ successfully executes onside kick! %@ has possession!\n",[self getEventPrefix], offense.abbreviation, [offense getK:0].name, offense.abbreviation]];
            gameYardLine = 35;
            gameDown = 1;
            gameYardsNeed = 10;
        } else {
            // Fail
            //gameEventLog += getEventPrefix() + offense.abbr + " K " + offense.getK(0).name + " failed the onside kick and lost possession.";
            [gameEventLog appendString:[NSString stringWithFormat:@"%@%@ K %@ failed to convert the onside kick. %@ lost possession.\n",[self getEventPrefix], offense.abbreviation, [offense getK:0].name, offense.abbreviation]];
            gamePoss = !gamePoss;
            gameYardLine = 65;
            gameDown = 1;
            gameYardsNeed = 10;
        }
        
        gameTime -= (4 + (5 * [HBSharedUtils randomValue]));
        
    } else {
        // Just regular kick off
        gameYardLine = (int) (115 - ( [offense getK:0].ratKickPow + 20 - 40*[HBSharedUtils randomValue] ));
        if ( gameYardLine <= 0 ) gameYardLine = 25;
        gameDown = 1;
        gameYardsNeed = 10;
        gamePoss = !gamePoss;
        gameTime -= (15*[HBSharedUtils randomValue]);
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
