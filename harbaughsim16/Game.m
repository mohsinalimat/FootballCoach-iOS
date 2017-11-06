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
#import "PlayerDL.h"
#import "PlayerTE.h"
#import "PlayerLB.h"
#import "PlayerCB.h"
#import "PlayerS.h"

#import "TeamStreak.h"

@implementation Game
@synthesize AwayKStats,AwayQBStats,AwayRB1Stats,AwayRB2Stats,AwayWR1Stats,AwayWR2Stats,AwayWR3Stats,awayTOs,awayTeam,awayScore,awayYards,awayQScore,awayStarters,gameName,homeTeam,hasPlayed,homeYards,HomeKStats,superclass,HomeQBStats,HomeRB1Stats,HomeRB2Stats,homeStarters,HomeWR1Stats,HomeWR2Stats,HomeWR3Stats,homeScore,homeQScore,homeTOs,numOT,AwayTEStats,HomeTEStats, gameEventLog;

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.gameEventLog forKey:@"gameEventLog"];
    [aCoder encodeObject:tdInfo forKey:@"tdInfo"];

    [aCoder encodeInt:gameTime forKey:@"gameTime"];
    [aCoder encodeBool:gamePoss forKey:@"gamePoss"];
    [aCoder encodeInt:gameYardLine forKey:@"gameYardLine"];
    [aCoder encodeInt:gameDown forKey:@"gameDown"];
    [aCoder encodeInt:gameYardsNeed forKey:@"gameYardsNeed"];

    [aCoder encodeInt:self.homeScore forKey:@"homeScore"];
    [aCoder encodeInt:self.awayScore forKey:@"awayScore"];
    [aCoder encodeBool:self.hasPlayed forKey:@"hasPlayed"];
    [aCoder encodeObject:self.gameName forKey:@"gameName"];

    [aCoder encodeObject:self.homeQScore forKey:@"homeQScore"];
    [aCoder encodeObject:self.awayQScore forKey:@"awayQScore"];

    [aCoder encodeInt:self.homeYards forKey:@"homeYards"];
    [aCoder encodeInt:self.awayYards forKey:@"awayYards"];
    [aCoder encodeInt:self.numOT forKey:@"numOT"];
    [aCoder encodeInt:self.homeTOs forKey:@"homeTOs"];
    [aCoder encodeInt:self.awayTOs forKey:@"awayTOs"];

    [aCoder encodeObject:self.HomeQBStats forKey:@"HomeQBStats"];

    [aCoder encodeObject:self.HomeRB1Stats forKey:@"HomeRB1Stats"];
    [aCoder encodeObject:self.HomeRB2Stats forKey:@"HomeRB2Stats"];

    [aCoder encodeObject:self.HomeWR1Stats forKey:@"HomeWR1Stats"];
    [aCoder encodeObject:self.HomeWR2Stats forKey:@"HomeWR2Stats"];
    [aCoder encodeObject:self.HomeWR3Stats forKey:@"HomeWR3Stats"];
    [aCoder encodeObject:self.HomeKStats forKey:@"HomeKStats"];

    [aCoder encodeObject:self.AwayQBStats forKey:@"AwayQBStats"];

    [aCoder encodeObject:self.AwayRB1Stats forKey:@"AwayRB1Stats"];
    [aCoder encodeObject:self.AwayRB2Stats forKey:@"AwayRB2Stats"];

    [aCoder encodeObject:self.AwayWR1Stats forKey:@"AwayWR1Stats"];
    [aCoder encodeObject:self.AwayWR2Stats forKey:@"AwayWR2Stats"];
    [aCoder encodeObject:self.AwayWR3Stats forKey:@"AwayWR3Stats"];
    [aCoder encodeObject:self.AwayKStats forKey:@"AwayKStats"];

    [aCoder encodeObject:self.homeTeam forKey:@"homeTeam"];
    [aCoder encodeObject:self.awayTeam forKey:@"awayTeam"];

    [aCoder encodeObject:self.homeStarters forKey:@"homeStarters"];
    [aCoder encodeObject:self.awayStarters forKey:@"awayStarters"];
    
    [aCoder encodeObject:self.HomeTEStats forKey:@"HomeTEStats"];
    [aCoder encodeObject:self.AwayTEStats forKey:@"AwayTEStats"];

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

        self.homeTeam = [aDecoder decodeObjectForKey:@"homeTeam"];
        self.awayTeam = [aDecoder decodeObjectForKey:@"awayTeam"];

        self.homeScore = [aDecoder decodeIntForKey:@"homeScore"];
        self.awayScore = [aDecoder decodeIntForKey:@"awayScore"];
        self.numOT = [aDecoder decodeIntForKey:@"numOT"];
        self.homeTOs = [aDecoder decodeIntForKey:@"homeTOs"];
        self.awayTOs = [aDecoder decodeIntForKey:@"awayTOs"];
        self.awayYards = [aDecoder decodeIntForKey:@"awayYards"];
        self.homeYards = [aDecoder decodeIntForKey:@"homeYards"];
        self.hasPlayed = [aDecoder decodeBoolForKey:@"hasPlayed"];
        self.gameName = [aDecoder decodeObjectForKey:@"gameName"];
        self.homeQScore = [aDecoder decodeObjectForKey:@"homeQScore"];
        self.awayQScore = [aDecoder decodeObjectForKey:@"awayQScore"];

        self.HomeQBStats = [aDecoder decodeObjectForKey:@"HomeQBStats"];
        self.HomeRB1Stats = [aDecoder decodeObjectForKey:@"HomeRB1Stats"];
        self.HomeRB2Stats = [aDecoder decodeObjectForKey:@"HomeRB2Stats"];
        self.HomeWR1Stats = [aDecoder decodeObjectForKey:@"HomeWR1Stats"];
        self.HomeWR2Stats = [aDecoder decodeObjectForKey:@"HomeWR2Stats"];
        self.HomeWR3Stats = [aDecoder decodeObjectForKey:@"HomeWR3Stats"];

        self.AwayQBStats = [aDecoder decodeObjectForKey:@"AwayQBStats"];
        self.AwayRB1Stats = [aDecoder decodeObjectForKey:@"AwayRB1Stats"];
        self.AwayRB2Stats = [aDecoder decodeObjectForKey:@"AwayRB2Stats"];
        self.AwayWR1Stats = [aDecoder decodeObjectForKey:@"AwayWR1Stats"];
        self.AwayWR2Stats = [aDecoder decodeObjectForKey:@"AwayWR2Stats"];
        self.AwayWR3Stats = [aDecoder decodeObjectForKey:@"AwayWR3Stats"];

        self.HomeKStats = [aDecoder decodeObjectForKey:@"HomeKStats"];
        self.AwayKStats = [aDecoder decodeObjectForKey:@"AwayKStats"];

        if ([aDecoder containsValueForKey:@"homeStarters"]) {
            self.homeStarters = [aDecoder decodeObjectForKey:@"homeStarters"];
        } else {
            self.homeStarters = [NSMutableArray array];
        }

        if ([aDecoder containsValueForKey:@"awayStarters"]) {
            self.awayStarters = [aDecoder decodeObjectForKey:@"awayStarters"];
        } else {
            self.awayStarters = [NSMutableArray array];
        }
        
        if ([aDecoder containsValueForKey:@"HomeTEStats"]) {
            self.HomeTEStats = [aDecoder decodeObjectForKey:@"HomeTEStats"];
        } else {
            self.HomeTEStats = [NSMutableArray arrayWithObjects:@0,@0,@0,@0,@0,@0, nil];
        }
        
        if ([aDecoder containsValueForKey:@"AwayTEStats"]) {
            self.AwayTEStats = [aDecoder decodeObjectForKey:@"AwayTEStats"];
        } else {
            self.AwayTEStats = [NSMutableArray arrayWithObjects:@0,@0,@0,@0,@0,@0, nil];
        }
    }
    return self;
}


-(instancetype)initWithHome:(Team*)home away:(Team*)away {
    self = [super init];
    if (self) {
        homeTeam = home;
        awayTeam = away;
        
        homeScore = 0;
        homeQScore = [NSMutableArray array];
        awayScore = 0;
        awayQScore = [NSMutableArray array];
        numOT = 0;
        
        for (int i = 0; i < 10; i++) {
            [homeQScore addObject:@(0)];
            [awayQScore addObject:@(0)];
        }
        
        homeTOs = 0;
        awayTOs = 0;
        
        gameEventLog = [NSMutableString stringWithFormat:@"LOG: #%ld %@ (%ld-%ld) @ #%ld %@ (%ld-%ld)\n---------------------------------------------------------",(long)awayTeam.rankTeamPollScore,awayTeam.abbreviation,(long)awayTeam.wins,(long)awayTeam.losses,(long)homeTeam.rankTeamPollScore,homeTeam.abbreviation,(long)homeTeam.wins,(long)homeTeam.losses];
        
        //initialize arrays, set everything to zero
        HomeQBStats = [NSMutableArray array];
        AwayQBStats = [NSMutableArray array];
        
        HomeRB1Stats = [NSMutableArray array];
        HomeRB2Stats = [NSMutableArray array];
        AwayRB1Stats = [NSMutableArray array];
        AwayRB2Stats = [NSMutableArray array];
        
        HomeWR1Stats = [NSMutableArray array];
        HomeWR2Stats = [NSMutableArray array];
        HomeWR3Stats = [NSMutableArray array];
        AwayWR1Stats = [NSMutableArray array];
        AwayWR2Stats = [NSMutableArray array];
        AwayWR3Stats = [NSMutableArray array];
        
        HomeTEStats = [NSMutableArray array];
        AwayTEStats = [NSMutableArray array];
        
        HomeKStats = [NSMutableArray array];
        AwayKStats = [NSMutableArray array];
        
        
        for (int i = 0; i < 10; i++) {
            [HomeQBStats addObject:@(0)];
            [AwayQBStats addObject:@(0)];
        }
        
        for (int i = 0; i < 6; i++) {
            [HomeTEStats addObject:@(0)];
            [AwayTEStats addObject:@(0)];
            
            [HomeKStats addObject:@(0)];
            [AwayKStats addObject:@(0)];
            
            [HomeWR1Stats addObject:@(0)];
            [AwayWR1Stats addObject:@(0)];
            
            [HomeWR2Stats addObject:@(0)];
            [AwayWR2Stats addObject:@(0)];
            
            [HomeWR3Stats addObject:@(0)];
            [AwayWR3Stats addObject:@(0)];
        }
        
        for (int i = 0; i < 4; i++) {
            [HomeRB1Stats addObject:@(0)];
            [AwayRB1Stats addObject:@(0)];
            [HomeRB2Stats addObject:@(0)];
            [AwayRB2Stats addObject:@(0)];
        }
        
        hasPlayed = false;
        
        gameName = @"";
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
        homeTeam = home;
        awayTeam = away;
        
        gameName = name;
        
        homeScore = 0;
        homeQScore = [NSMutableArray array];
        awayScore = 0;
        awayQScore = [NSMutableArray array];
        numOT = 0;
        
        homeTOs = 0;
        awayTOs = 0;
        
        gameEventLog = [NSMutableString stringWithFormat:@"LOG: #%ld %@ (%ld-%ld) @ #%ld %@ (%ld-%ld)\n%@\n---------------------------------------------------------",(long)awayTeam.rankTeamPollScore,awayTeam.abbreviation,(long)awayTeam.wins,(long)awayTeam.losses,(long)homeTeam.rankTeamPollScore,homeTeam.abbreviation,(long)homeTeam.wins,(long)homeTeam.losses,gameName];
        
        //initialize arrays, set everything to zero
        HomeQBStats = [NSMutableArray array];
        AwayQBStats = [NSMutableArray array];
        
        HomeRB1Stats = [NSMutableArray array];
        HomeRB2Stats = [NSMutableArray array];
        AwayRB1Stats = [NSMutableArray array];
        AwayRB2Stats = [NSMutableArray array];
        
        HomeWR1Stats = [NSMutableArray array];
        HomeWR2Stats = [NSMutableArray array];
        HomeWR3Stats = [NSMutableArray array];
        AwayWR1Stats = [NSMutableArray array];
        AwayWR2Stats = [NSMutableArray array];
        AwayWR3Stats = [NSMutableArray array];
        
        HomeTEStats = [NSMutableArray array];
        AwayTEStats = [NSMutableArray array];
        
        HomeKStats = [NSMutableArray array];
        AwayKStats = [NSMutableArray array];
        
        homeStarters = [NSMutableArray array];
        awayStarters = [NSMutableArray array];
        
        
        for (int i = 0; i < 10; i++) {
            [homeQScore addObject:@(0)];
            [awayQScore addObject:@(0)];
        }
        
        for (int i = 0; i < 10; i++) {
            [HomeQBStats addObject:@(0)];
            [AwayQBStats addObject:@(0)];
        }
        
        for (int i = 0; i < 6; i++) {
            [HomeKStats addObject:@(0)];
            [AwayKStats addObject:@(0)];
            
            [HomeTEStats addObject:@(0)];
            [AwayTEStats addObject:@(0)];
            
            [HomeWR1Stats addObject:@(0)];
            [AwayWR1Stats addObject:@(0)];
            
            [HomeWR2Stats addObject:@(0)];
            [AwayWR2Stats addObject:@(0)];
            
            [HomeWR3Stats addObject:@(0)];
            [AwayWR3Stats addObject:@(0)];
        }
        
        for (int i = 0; i < 4; i++) {
            [HomeRB1Stats addObject:@(0)];
            [AwayRB1Stats addObject:@(0)];
            [HomeRB2Stats addObject:@(0)];
            [AwayRB2Stats addObject:@(0)];
        }
        
        hasPlayed = false;
        
        if ([gameName isEqualToString:@"In Conf"] && ([homeTeam.rivalTeam isEqualToString:awayTeam.abbreviation] || [awayTeam.rivalTeam isEqualToString:homeTeam.abbreviation])) {
            // Rivalry game!
            gameName = @"Rivalry Game";
        }
    }
    return self;
}

-(NSString*)gameSummary {
    return gameEventLog;
}

-(NSDictionary*)gameReport {
    NSMutableDictionary *report = [NSMutableDictionary dictionary];
    
    if (hasPlayed) {
        //Points/stats dictionary - away, home
        NSMutableDictionary *gameStats = [NSMutableDictionary dictionary]; //score, total yards, pass yards, rush yards
        [gameStats setObject:@[[NSString stringWithFormat:@"%d",awayScore],
                               [NSString stringWithFormat:@"%d",homeScore]] forKey:@"Score"];
        [gameStats setObject:@[[NSString stringWithFormat:@"%d",awayYards],
                               [NSString stringWithFormat:@"%d",homeYards]] forKey:@"Total Yards"];
        [gameStats setObject:@[[NSString stringWithFormat:@"%d",[self getPassYards:TRUE]],
                               [NSString stringWithFormat:@"%d",[self getPassYards:FALSE]]] forKey:@"Pass Yards"];
        [gameStats setObject:@[[NSString stringWithFormat:@"%d",[self getRushYards:TRUE]],
                               [NSString stringWithFormat:@"%d",[self getRushYards:FALSE]]] forKey:@"Rush Yards"];
        
        [report setObject:gameStats forKey:@"gameStats"];
        
        if (homeStarters.count == 0 || homeStarters == nil) {
            homeStarters = [NSMutableArray arrayWithArray:@[[homeTeam getQB:0],
                                                             
                                                             [homeTeam getRB:0],
                                                             [homeTeam getRB:1],
                                                             
                                                             [homeTeam getWR:0],
                                                             [homeTeam getWR:1],
                                                             [homeTeam getWR:2],
                                                            
                                                            [homeTeam getTE:0],
                                                             
                                                             [homeTeam getOL:0],
                                                             [homeTeam getOL:1],
                                                             [homeTeam getOL:2],
                                                             [homeTeam getOL:3],
                                                             [homeTeam getOL:4],
                                                             
                                                             [homeTeam getK:0],
                                                             
                                                             [homeTeam getS:0],
                                                             
                                                             [homeTeam getCB:0],
                                                             [homeTeam getCB:1],
                                                             [homeTeam getCB:2],
                                                             
                                                             [homeTeam getDL:0],
                                                             [homeTeam getDL:1],
                                                             [homeTeam getDL:2],
                                                             [homeTeam getDL:3],
                                                             
                                                             [homeTeam getLB:0],
                                                             [homeTeam getLB:1],
                                                             [homeTeam getLB:3]]];
        }
        
        if (awayStarters.count == 0 || awayStarters == nil) {
            awayStarters = [NSMutableArray arrayWithArray:@[[awayTeam getQB:0],
                                                             
                                                             [awayTeam getRB:0],
                                                             [awayTeam getRB:1],
                                                             
                                                             [awayTeam getWR:0],
                                                             [awayTeam getWR:1],
                                                             [awayTeam getWR:2],
                                                            
                                                            [awayTeam getTE:0],
                                                             
                                                             [awayTeam getOL:0],
                                                             [awayTeam getOL:1],
                                                             [awayTeam getOL:2],
                                                             [awayTeam getOL:3],
                                                             [awayTeam getOL:4],
                                                             
                                                             [awayTeam getK:0],
                                                             
                                                             [awayTeam getS:0],
                                                             
                                                             [awayTeam getCB:0],
                                                             [awayTeam getCB:1],
                                                             [awayTeam getCB:2],
                                                             
                                                             [awayTeam getDL:0],
                                                             [awayTeam getDL:1],
                                                             [awayTeam getDL:2],
                                                             [awayTeam getDL:3],
                                                             
                                                             [awayTeam getLB:0],
                                                             [awayTeam getLB:1],
                                                             [awayTeam getLB:2]]];
        }
        
        //QBs - dicts go home, away - yes, I'm aware that's confusing
        NSMutableDictionary *qbs = [NSMutableDictionary dictionary];
        [qbs setObject:homeStarters[0] forKey:@"homeQB"];
        [qbs setObject:HomeQBStats forKey:@"homeQBStats"];
        
        [qbs setObject:awayStarters[0] forKey:@"awayQB"];
        [qbs setObject:AwayQBStats forKey:@"awayQBStats"];
        [report setObject:qbs forKey:@"QBs"];
        
        //RBs
        NSMutableDictionary *rbs = [NSMutableDictionary dictionary];
        [rbs setObject:homeStarters[1] forKey:@"homeRB1"];
        [rbs setObject:HomeRB1Stats forKey:@"homeRB1Stats"];
        
        [rbs setObject:homeStarters[2] forKey:@"homeRB2"];
        [rbs setObject:HomeRB2Stats forKey:@"homeRB2Stats"];
        
        [rbs setObject:awayStarters[1] forKey:@"awayRB1"];
        [rbs setObject:AwayRB1Stats forKey:@"awayRB1Stats"];
        
        [rbs setObject:awayStarters[2] forKey:@"awayRB2"];
        [rbs setObject:AwayRB2Stats forKey:@"awayRB2Stats"];
        
        [report setObject:rbs forKey:@"RBs"];
        
        //WRs
        NSMutableDictionary *wrs = [NSMutableDictionary dictionary];
        
        [wrs setObject:homeStarters[3] forKey:@"homeWR1"];
        [wrs setObject:HomeWR1Stats forKey:@"homeWR1Stats"];
        
        [wrs setObject:homeStarters[4] forKey:@"homeWR2"];
        [wrs setObject:HomeWR2Stats forKey:@"homeWR2Stats"];
        
        [wrs setObject:awayStarters[3] forKey:@"awayWR1"];
        [wrs setObject:AwayWR1Stats forKey:@"awayWR1Stats"];
        
        [wrs setObject:awayStarters[4] forKey:@"awayWR2"];
        [wrs setObject:AwayWR2Stats forKey:@"awayWR2Stats"];
        
        [report setObject:wrs forKey:@"WRs"];
        
        //TEs
        NSMutableDictionary *tes = [NSMutableDictionary dictionary];
        [tes setObject:homeStarters[6] forKey:@"homeTE"];
        [tes setObject:HomeTEStats forKey:@"homeTEStats"];
        
        [tes setObject:awayStarters[6] forKey:@"awayTE"];
        [tes setObject:AwayTEStats forKey:@"awayTEStats"];
        [report setObject:tes forKey:@"TEs"];
        
        //Ks
        NSMutableDictionary *ks = [NSMutableDictionary dictionary];
        [ks setObject:homeStarters[12] forKey:@"homeK"];
        [ks setObject:HomeKStats forKey:@"homeKStats"];
        
        [ks setObject:awayStarters[12] forKey:@"awayK"];
        [ks setObject:AwayKStats forKey:@"awayKStats"];
        [report setObject:ks forKey:@"Ks"];
        
    } else {
        // array goes away, home
        int appg, hppg, aoppg, hoppg, aypg, hypg, aoypg, hoypg, apypg, hpypg, aopypg, hopypg, aorypg, horypg, arypg, hrypg;
        
        if ([HBSharedUtils getLeague].currentWeek > 0) {
            appg = (int)ceil((double)awayTeam.teamPoints / (double)([HBSharedUtils getLeague].currentWeek));
            hppg = (int)ceil((double)homeTeam.teamPoints / (double)([HBSharedUtils getLeague].currentWeek));
            
            aoppg = (int)ceil((double)awayTeam.teamOppPoints / (double)([HBSharedUtils getLeague].currentWeek));
            hoppg = (int)ceil((double)homeTeam.teamOppPoints / (double)([HBSharedUtils getLeague].currentWeek));
            
            aypg = (int)ceil((double)awayTeam.teamYards / (double)([HBSharedUtils getLeague].currentWeek));
            hypg = (int)ceil((double)homeTeam.teamYards / (double)([HBSharedUtils getLeague].currentWeek));
            
            aoypg = (int)ceil((double)awayTeam.teamOppYards / (double)([HBSharedUtils getLeague].currentWeek));
            hoypg = (int)ceil((double)homeTeam.teamOppYards / (double)([HBSharedUtils getLeague].currentWeek));
            
            apypg = (int)ceil((double)awayTeam.teamPassYards / (double)([HBSharedUtils getLeague].currentWeek));
            hpypg = (int)ceil((double)homeTeam.teamPassYards / (double)([HBSharedUtils getLeague].currentWeek));
            
            arypg = (int)ceil((double)awayTeam.teamRushYards / (double)([HBSharedUtils getLeague].currentWeek));
            hrypg = (int)ceil((double)homeTeam.teamRushYards / (double)([HBSharedUtils getLeague].currentWeek));
            
            aopypg = (int)ceil((double)awayTeam.teamOppPassYards / (double)([HBSharedUtils getLeague].currentWeek));
            hopypg = (int)ceil((double)homeTeam.teamOppPassYards / (double)([HBSharedUtils getLeague].currentWeek));
            
            aorypg = (int)ceil((double)awayTeam.teamOppRushYards / (double)([HBSharedUtils getLeague].currentWeek));
            horypg = (int)ceil((double)homeTeam.teamOppRushYards / (double)([HBSharedUtils getLeague].currentWeek));
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
        
        
        [report setObject:@[[NSString stringWithFormat:@"#%d",awayTeam.rankTeamPollScore],
                            [NSString stringWithFormat:@"#%d",homeTeam.rankTeamPollScore]] forKey:@"Ranking"];
        [report setObject:@[[NSString stringWithFormat:@"%d-%d",awayTeam.wins,awayTeam.losses],
                            [NSString stringWithFormat:@"%d-%d",homeTeam.wins,homeTeam.losses]] forKey:@"Record"];
        [report setObject:@[[NSString stringWithFormat:@"%d (#%d)",appg,awayTeam.rankTeamPoints],
                            [NSString stringWithFormat:@"%d (#%d)",hppg,homeTeam.rankTeamPoints]] forKey:@"Points Per Game"];
        [report setObject:@[[NSString stringWithFormat:@"%d (#%d)",aoppg,awayTeam.rankTeamOppPoints],
                            [NSString stringWithFormat:@"%d (#%d)",hoppg,homeTeam.rankTeamOppPoints]] forKey:@"Opp PPG"];
        [report setObject:@[[NSString stringWithFormat:@"%d (#%d)",aypg,awayTeam.rankTeamYards],
                            [NSString stringWithFormat:@"%d (#%d)",hypg,homeTeam.rankTeamYards]] forKey:@"Yards Per Game"];
        [report setObject:@[[NSString stringWithFormat:@"%d (#%d)",aoypg,awayTeam.rankTeamOppYards],
                            [NSString stringWithFormat:@"%d (#%d)",hoypg,homeTeam.rankTeamOppYards]] forKey:@"Opp YPG"];
        [report setObject:@[[NSString stringWithFormat:@"%d (#%d)",apypg,awayTeam.rankTeamPassYards],
                            [NSString stringWithFormat:@"%d (#%d)",hpypg,homeTeam.rankTeamPassYards]] forKey:@"Pass YPG"];
        [report setObject:@[[NSString stringWithFormat:@"%d (#%d)",arypg,awayTeam.rankTeamRushYards],
                            [NSString stringWithFormat:@"%d (#%d)",hrypg,homeTeam.rankTeamRushYards]] forKey:@"Rush YPG"];
        [report setObject:@[[NSString stringWithFormat:@"%d (#%d)",aopypg,awayTeam.rankTeamOppPassYards],
                            [NSString stringWithFormat:@"%d (#%d)",hopypg,homeTeam.rankTeamOppPassYards]] forKey:@"Opp Pass YPG"];
        [report setObject:@[[NSString stringWithFormat:@"%d (#%d)",aorypg,awayTeam.rankTeamOppRushYards],
                            [NSString stringWithFormat:@"%d (#%d)",horypg,homeTeam.rankTeamOppRushYards]] forKey:@"Opp Rush YPG"];
        [report setObject:@[[NSString stringWithFormat:@"%d (#%d)",awayTeam.teamOffTalent,awayTeam.rankTeamOffTalent],
                            [NSString stringWithFormat:@"%d (#%d)",homeTeam.teamOffTalent,homeTeam.rankTeamOffTalent]] forKey:@"Offensive Talent"];
        [report setObject:@[[NSString stringWithFormat:@"%d (#%d)",awayTeam.teamDefTalent,awayTeam.rankTeamDefTalent],
                            [NSString stringWithFormat:@"%d (#%d)",homeTeam.teamDefTalent,homeTeam.rankTeamDefTalent]] forKey:@"Defensive Talent"];
        [report setObject:@[[NSString stringWithFormat:@"%d (#%d)",awayTeam.teamPrestige,awayTeam.rankTeamPrestige],
                            [NSString stringWithFormat:@"%d (#%d)",homeTeam.teamPrestige,homeTeam.rankTeamPrestige]] forKey:@"Prestige"];
    }
    
    return [report copy];
}

-(int)getPassYards:(BOOL)ha {
    if (!ha) {
        NSNumber *qbYd = HomeQBStats[4];
        return qbYd.intValue;
    } else {
        NSNumber *qbYd = AwayQBStats[4];
        return qbYd.intValue;
    }
}

-(int)getRushYards:(BOOL)ha {
    if (!ha) {
        NSNumber *rb1Yd = HomeRB1Stats[1];
        NSNumber *rb2Yd = HomeRB2Stats[1];
        NSNumber *qbYd = HomeQBStats[7];
        return rb1Yd.intValue + rb2Yd.intValue + qbYd.intValue;
    } else {
        NSNumber *rb1Yd = AwayRB1Stats[1];
        NSNumber *rb2Yd = AwayRB2Stats[1];
        NSNumber *qbYd = AwayQBStats[7];
        return rb1Yd.intValue + rb2Yd.intValue + qbYd.intValue;
    }
}

-(int)getHFAdv {
    int footIQadv = ([homeTeam getCompositeFootIQ] - [awayTeam getCompositeFootIQ])/5;
    if (footIQadv > 3) footIQadv = 3;
    if (footIQadv < -3) footIQadv = -3;
    if (gamePoss) {
        return 3 + footIQadv;
    } else {
        return -footIQadv;
    }
}

-(NSString*)getEventPrefix {
    NSString *possStr;
    NSString *defStr;
    if ( gamePoss ) {
        possStr = homeTeam.abbreviation;
        defStr = awayTeam.abbreviation;
    } else {
        possStr = awayTeam.abbreviation;
        defStr = homeTeam.abbreviation;
    }
    
    NSString *yardsNeedAdj = [NSString stringWithFormat:@"%ld",(long)gameYardsNeed];
    int gameDownAdj;
    if (gameDown > 4) {
        gameDownAdj = 4;
    } else {
        gameDownAdj = gameDown;
    }
    
    NSString *downString = @"";
    if (gameDownAdj == 1) {
        downString = @"1st";
    } else if (gameDownAdj == 2) {
        downString = @"2nd";
    } else if (gameDownAdj == 3) {
        downString = @"3rd";
    } else {
        downString = @"4th";
    }
    
    
    NSString *ydLineStr;
    if (gameYardLine > 50) {
        ydLineStr = [NSString stringWithFormat:@"%@ %ld", defStr, (long)(100 - gameYardLine)];
    } else if (gameYardLine == 50) {
        ydLineStr = @"50-yard line";
    } else {
        ydLineStr = [NSString stringWithFormat:@"%@ %ld", possStr, (long)gameYardLine];
    }
    
    if (gameYardLine + gameYardsNeed >= 100) yardsNeedAdj = @"Goal";
    return [NSString stringWithFormat:@"\n\n%@ %ld - %ld %@, Time: %@\n%@ %@ and %@ at the %@.\n",awayTeam.abbreviation,(long)awayScore,(long)homeScore,homeTeam.abbreviation, [self convGameTime],possStr,downString,yardsNeedAdj,ydLineStr];
}

-(NSString*)convGameTime {
    if (gameTime <= 0 && !playingOT) {
        return @"0:00 Q4";
    }
    
    if (!playingOT) {
        int qNum = (3600 - gameTime) / 900 + 1;
        int minTime;
        int secTime;
        NSMutableString *secStr =[NSMutableString string];
        if ( qNum >= 4 && numOT > 0 ) {
            minTime = gameTime / 60;
            secTime = gameTime - 60*minTime;
            if (secTime < 10) {
                //secStr = "0" + secTime;
                [secStr appendString:[NSString stringWithFormat:@"0%ld", (long)secTime]];
            } else {
                [secStr appendString:[NSString stringWithFormat:@"%ld", (long)secTime]];
            }
            return [NSString stringWithFormat:@"%ld:%@ OT%ld",(long)minTime,secStr,(long)numOT];
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
            if (numOT > 1) {
                return [NSString stringWithFormat:@"TOP %ldOT",(long)numOT];
            } else {
                return @"TOP OT";
            }
        } else {
            if (numOT > 1) {
                return [NSString stringWithFormat:@"BOT %ldOT",(long)numOT];
            } else {
                return @"BOT OT";
            }
        }
    }
}

-(void)playGame {
    if ( !hasPlayed ) {
        //NSLog(@"START PLAY GAME, GAME SETUP");
        gameEventLog = [NSMutableString stringWithFormat:@"LOG: #%ld %@ (%ld-%ld) @ #%ld %@ (%ld-%ld)\n---------------------------------------------------------",(long)awayTeam.rankTeamPollScore, awayTeam.abbreviation,(long)awayTeam.wins,(long)awayTeam.losses,(long)homeTeam.rankTeamPollScore,homeTeam.abbreviation,(long)homeTeam.wins,(long)homeTeam.losses];
        //probably establish some home field advantage before playing
        gameTime = 3600;
        gameDown = 1;
        gamePoss = true;
        gameYardsNeed = 10;
        gameYardLine = 25;
        
        //Home Team Starters
        //NSLog(@"SET HOME STARTERS");
        homeStarters = [NSMutableArray arrayWithArray:@[[homeTeam getQB:0],
                                                         
                                                         [homeTeam getRB:0],
                                                         [homeTeam getRB:1],
                                                         
                                                         [homeTeam getWR:0],
                                                         [homeTeam getWR:1],
                                                         [homeTeam getWR:2],
                                                        
                                                         [homeTeam getTE:0],
                                                         
                                                         [homeTeam getOL:0],
                                                         [homeTeam getOL:1],
                                                         [homeTeam getOL:2],
                                                         [homeTeam getOL:3],
                                                         [homeTeam getOL:4],
                                                         
                                                         [homeTeam getK:0],
                                                         
                                                         [homeTeam getS:0],
                                                         
                                                         [homeTeam getCB:0],
                                                         [homeTeam getCB:1],
                                                         [homeTeam getCB:2],
                                                         
                                                         [homeTeam getDL:0],
                                                         [homeTeam getDL:1],
                                                         [homeTeam getDL:2],
                                                         [homeTeam getDL:3],
                                                         
                                                         [homeTeam getLB:0],
                                                         [homeTeam getLB:1],
                                                         [homeTeam getLB:2]]];
        
        //Away Team starters
        //NSLog(@"SET AWAY STARTERS");
        awayStarters = [NSMutableArray arrayWithArray:@[[awayTeam getQB:0],
                                                         
                                                         [awayTeam getRB:0],
                                                         [awayTeam getRB:1],
                                                         
                                                         [awayTeam getWR:0],
                                                         [awayTeam getWR:1],
                                                         [awayTeam getWR:2],
                                                        
                                                        [awayTeam getTE:0],
                                                         
                                                         [awayTeam getOL:0],
                                                         [awayTeam getOL:1],
                                                         [awayTeam getOL:2],
                                                         [awayTeam getOL:3],
                                                         [awayTeam getOL:4],
                                                         
                                                         [awayTeam getK:0],
                                                         
                                                         [awayTeam getS:0],
                                                         
                                                         [awayTeam getCB:0],
                                                         [awayTeam getCB:1],
                                                         [awayTeam getCB:2],
                                                         
                                                         [awayTeam getDL:0],
                                                         [awayTeam getDL:1],
                                                         [awayTeam getDL:2],
                                                         [awayTeam getDL:3],
                                                         
                                                         [awayTeam getLB:0],
                                                         [awayTeam getLB:1],
                                                         [awayTeam getLB:2]]];
        
        //break redshirts if starters are marked as such and add gamesPlayed/gamesPlayedSeason
        //NSLog(@"BREAKING REDSHIRTS IF NECESSARY");
        for (Player *p in homeStarters) {
            if (p.hasRedshirt) {
                p.hasRedshirt = NO;
                p.wasRedshirted = YES;
            }
            
            p.gamesPlayedSeason++;
            p.gamesPlayed++;
        }
        
        for (Player *p in awayStarters) {
            if (p.hasRedshirt) {
                p.hasRedshirt = NO;
                p.wasRedshirted = YES;
            }
            
            p.gamesPlayedSeason++;
            p.gamesPlayed++;
        }
        
        //NSLog(@"START PLAYING GAME");
        while ( gameTime > 0 ) {
            //play ball!
            if (gamePoss) {
                [self runPlay:homeTeam defense:awayTeam];
            } else {
                [self runPlay:awayTeam defense:homeTeam];
            }
            
        }
        //NSLog(@"OUT OF TIME");
        
        //NSLog(@"CHECK IF OT NEEDED");
        if (homeScore != awayScore) {
            [gameEventLog appendFormat:@"\n\nTime has expired! The game is over.\n\nFINAL SCORE: %@ %ld - %ld %@", awayTeam.abbreviation, (long)awayScore, (long)homeScore, homeTeam.abbreviation ];
        } else {
            [gameEventLog appendFormat:@"%@\nOVERTIME!\n\nTie game at 0:00, overtime begins!",[self getEventPrefix]];
        }
        
        //NSLog(@"SETTING UP OT IF NECESSARY");
        if (gameTime <= 0 && homeScore == awayScore) {
            playingOT = YES;
            gamePoss = FALSE;
            gameYardLine = 75;
            numOT++;
            gameTime = -1;
            gameDown = 1;
            gameYardsNeed = 10;
            
            while (playingOT) {
                if (gamePoss) {
                    [self runPlay:homeTeam defense:awayTeam];
                } else {
                    [self runPlay:awayTeam defense:homeTeam];
                }
            }
            
            if (homeScore != awayScore) {
                [gameEventLog appendFormat:@"\n\nFINAL SCORE: %@ %ld - %ld %@", awayTeam.abbreviation, (long)awayScore, (long)homeScore, homeTeam.abbreviation ];
            }
        }
        //NSLog(@"END OT");
        
        // Add points/opp points
        //NSLog(@"DOING SEASON STATS");
        homeTeam.teamPoints += homeScore;
        awayTeam.teamPoints += awayScore;
        
        homeTeam.teamOppPoints += awayScore;
        awayTeam.teamOppPoints += homeScore;
        
        homeTeam.teamYards += homeYards;
        awayTeam.teamYards += awayYards;
        
        homeTeam.teamOppYards += awayYards;
        awayTeam.teamOppYards += homeYards;
        
        homeTeam.teamOppPassYards += [self getPassYards:YES];
        awayTeam.teamOppPassYards += [self getPassYards:NO];
        homeTeam.teamOppRushYards += [self getRushYards:YES];
        awayTeam.teamOppRushYards += [self getRushYards:NO];
        
        homeTeam.teamTODiff += awayTOs-homeTOs;
        awayTeam.teamTODiff += homeTOs-awayTOs;
        //NSLog(@"END SEASON STATS");
        
        hasPlayed = true;
        
        //NSLog(@"COMPILING PLAYER STATS");
        //NSLog(@"HOME TEAM");
        NSNumber *qbComp, *qbAtt, *qbYds, *qbTD, *qbInt, *qbRushAtt, *qbRushYds, *qbRushTDs, *qbRushFum;
        NSNumber *rb1Att, *rb1Yds, *rb1TDs, *rb1Fum;
        NSNumber *rb2Att, *rb2Yds, *rb2TDs, *rb2Fum;
        NSNumber *wr1Rec, *wr1Yds, *wr1TD, *wr1Fum, *wr1Drp, *wr1Tgt;
        NSNumber *wr2Rec, *wr2Yds, *wr2TD, *wr2Fum, *wr2Drp, *wr2Tgt;
        NSNumber *wr3Rec, *wr3Yds, *wr3TD, *wr3Fum, *wr3Drp, *wr3Tgt;
        NSNumber *teRec, *teYds, *teTD, *teFum, *teDrp, *teTgt;
        NSNumber *kXPM, *kXPA, *kFGM, *kFGA;
        
        //homeTeam career stats trackings
        qbComp = HomeQBStats[1];
        [homeTeam getQB:0].careerStatsPassComp += [qbComp intValue];
        qbAtt = HomeQBStats[0];
        [homeTeam getQB:0].careerStatsPassAtt += [qbAtt intValue];
        qbYds = HomeQBStats[4];
        [homeTeam getQB:0].careerStatsPassYards += [qbYds intValue];
        qbTD = HomeQBStats[2];
        [homeTeam getQB:0].careerStatsTD += [qbTD intValue];
        qbInt = HomeQBStats[3];
        [homeTeam getQB:0].careerStatsInt += [qbInt intValue];
        qbRushAtt = HomeQBStats[6];
        [homeTeam getQB:0].careerStatsRushAtt += [qbRushAtt intValue];
        qbRushYds = HomeQBStats[7];
        [homeTeam getQB:0].careerStatsRushYards += [qbRushYds intValue];
        qbRushTDs = HomeQBStats[8];
        [homeTeam getQB:0].careerStatsTD += [qbRushTDs intValue];
        qbRushFum = HomeQBStats[9];
        [homeTeam getQB:0].careerStatsFumbles += [qbRushFum intValue];
        
        rb1Att = HomeRB1Stats[0];
        [homeTeam getRB:0].careerStatsRushAtt += [rb1Att intValue];
        rb1Yds = HomeRB1Stats[1];
        [homeTeam getRB:0].careerStatsRushYards += [rb1Yds intValue];
        rb1TDs = HomeRB1Stats[2];
        [homeTeam getRB:0].careerStatsTD += [rb1TDs intValue];
        rb1Fum = HomeRB1Stats[3];
        [homeTeam getRB:0].careerStatsFumbles += [rb1Fum intValue];
        
        rb2Att = HomeRB2Stats[0];
        [homeTeam getRB:1].careerStatsRushAtt += [rb2Att intValue];
        rb2Yds = HomeRB2Stats[1];
        [homeTeam getRB:1].careerStatsRushYards += [rb2Yds intValue];
        rb2TDs = HomeRB2Stats[2];
        [homeTeam getRB:1].careerStatsTD += [rb2TDs intValue];
        rb2Fum = HomeRB2Stats[3];
        [homeTeam getRB:1].careerStatsFumbles += [rb2Fum intValue];
        
        wr1Rec = HomeWR1Stats[0];
        [homeTeam getWR:0].careerStatsReceptions += [wr1Rec intValue];
        wr1Tgt = HomeWR1Stats[1];
        [homeTeam getWR:0].careerStatsTargets += [wr1Tgt intValue];
        wr1Yds = HomeWR1Stats[2];
        [homeTeam getWR:0].careerStatsRecYards += [wr1Yds intValue];
        wr1TD = HomeWR1Stats[3];
        [homeTeam getWR:0].careerStatsTD += [wr1TD intValue];
        wr1Drp = HomeWR1Stats[4];
        [homeTeam getWR:0].careerStatsDrops += [wr1Drp intValue];
        wr1Fum = HomeWR1Stats[5];
        [homeTeam getWR:0].careerStatsFumbles += [wr1Fum intValue];
        
        wr2Rec = HomeWR2Stats[0];
        [homeTeam getWR:1].careerStatsReceptions += [wr2Rec intValue];
        wr2Tgt = HomeWR2Stats[1];
        [homeTeam getWR:1].careerStatsTargets += [wr2Tgt intValue];
        wr2Yds = HomeWR2Stats[2];
        [homeTeam getWR:1].careerStatsRecYards += [wr2Yds intValue];
        wr2TD = HomeWR2Stats[3];
        [homeTeam getWR:1].careerStatsTD += [wr2TD intValue];
        wr2Drp = HomeWR2Stats[4];
        [homeTeam getWR:1].careerStatsDrops += [wr2Drp intValue];
        wr2Fum = HomeWR2Stats[5];
        [homeTeam getWR:1].careerStatsFumbles += [wr2Fum intValue];
        
        wr3Rec = HomeWR3Stats[0];
        [homeTeam getWR:2].careerStatsReceptions += [wr3Rec intValue];
        wr3Tgt = HomeWR3Stats[1];
        [homeTeam getWR:2].careerStatsTargets += [wr3Tgt intValue];
        wr3Yds = HomeWR3Stats[2];
        [homeTeam getWR:2].careerStatsRecYards += [wr3Yds intValue];
        wr3TD = HomeWR3Stats[3];
        [homeTeam getWR:2].careerStatsTD += [wr3TD intValue];
        wr3Drp = HomeWR3Stats[4];
        [homeTeam getWR:2].careerStatsDrops += [wr3Drp intValue];
        wr3Fum = HomeWR3Stats[5];
        [homeTeam getWR:2].careerStatsFumbles += [wr3Fum intValue];
        
        teRec = HomeTEStats[0];
        [homeTeam getTE:0].careerStatsReceptions += [teRec intValue];
        teTgt = HomeTEStats[1];
        [homeTeam getTE:0].careerStatsTargets += [teTgt intValue];
        teYds = HomeTEStats[2];
        [homeTeam getTE:0].careerStatsRecYards += [teYds intValue];
        teTD = HomeTEStats[3];
        [homeTeam getTE:0].careerStatsTD += [teTD intValue];
        teDrp = HomeTEStats[4];
        [homeTeam getTE:0].careerStatsDrops += [teDrp intValue];
        teFum = HomeTEStats[5];
        [homeTeam getTE:0].careerStatsFumbles += [teFum intValue];
        
        kXPM = HomeKStats[0];
        [homeTeam getK:0].careerStatsXPMade += [kXPM intValue];
        kXPA = HomeKStats[1];
        [homeTeam getK:0].careerStatsXPAtt += [kXPA intValue];
        kFGM = HomeKStats[2];
        [homeTeam getK:0].careerStatsFGMade += [kFGM intValue];
        kFGA = HomeKStats[3];
        [homeTeam getK:0].careerStatsFGAtt += [kFGA intValue];
        //NSLog(@"END HOME TEAM");
        
        //away team career stats tracking
        //NSLog(@"START AWAY TEAM");
        qbComp = AwayQBStats[1];
        [awayTeam getQB:0].careerStatsPassComp += [qbComp intValue];
        qbAtt = AwayQBStats[0];
        [awayTeam getQB:0].careerStatsPassAtt += [qbAtt intValue];
        qbYds = AwayQBStats[4];
        [awayTeam getQB:0].careerStatsPassYards += [qbYds intValue];
        qbTD = AwayQBStats[2];
        [awayTeam getQB:0].careerStatsTD += [qbTD intValue];
        qbInt = AwayQBStats[3];
        [awayTeam getQB:0].careerStatsInt += [qbInt intValue];
        qbRushAtt = AwayQBStats[6];
        [awayTeam getQB:0].careerStatsRushAtt += [qbRushAtt intValue];
        qbRushYds = AwayQBStats[7];
        [awayTeam getQB:0].careerStatsRushYards += [qbRushYds intValue];
        qbRushTDs = AwayQBStats[8];
        [awayTeam getQB:0].careerStatsTD += [qbRushTDs intValue];
        qbRushFum = AwayQBStats[9];
        [awayTeam getQB:0].careerStatsFumbles += [qbRushFum intValue];
        
        rb1Att = AwayRB1Stats[0];
        [awayTeam getRB:0].careerStatsRushAtt += [rb1Att intValue];
        rb1Yds = AwayRB1Stats[1];
        [awayTeam getRB:0].careerStatsRushYards += [rb1Yds intValue];
        rb1TDs = AwayRB1Stats[2];
        [awayTeam getRB:0].careerStatsTD += [rb1TDs intValue];
        rb1Fum = AwayRB1Stats[3];
        [awayTeam getRB:0].careerStatsFumbles += [rb1Fum intValue];
        
        rb2Att = AwayRB2Stats[0];
        [awayTeam getRB:1].careerStatsRushAtt += [rb2Att intValue];
        rb2Yds = AwayRB2Stats[1];
        [awayTeam getRB:1].careerStatsRushYards += [rb2Yds intValue];
        rb2TDs = AwayRB2Stats[2];
        [awayTeam getRB:1].careerStatsTD += [rb2TDs intValue];
        rb2Fum = AwayRB2Stats[3];
        [awayTeam getRB:1].careerStatsFumbles += [rb2Fum intValue];
        
        wr1Rec = AwayWR1Stats[0];
        [awayTeam getWR:0].careerStatsReceptions += [wr1Rec intValue];
        wr1Tgt = AwayWR1Stats[1];
        [awayTeam getWR:0].careerStatsTargets += [wr1Tgt intValue];
        wr1Yds = AwayWR1Stats[2];
        [awayTeam getWR:0].careerStatsRecYards += [wr1Yds intValue];
        wr1TD = AwayWR1Stats[3];
        [awayTeam getWR:0].careerStatsTD += [wr1TD intValue];
        wr1Drp = AwayWR1Stats[4];
        [awayTeam getWR:0].careerStatsDrops += [wr1Drp intValue];
        wr1Fum = AwayWR1Stats[5];
        [awayTeam getWR:0].careerStatsFumbles += [wr1Fum intValue];
        
        wr2Rec = AwayWR2Stats[0];
        [awayTeam getWR:1].careerStatsReceptions += [wr2Rec intValue];
        wr2Tgt = AwayWR2Stats[1];
        [awayTeam getWR:1].careerStatsTargets += [wr2Tgt intValue];
        wr2Yds = AwayWR2Stats[2];
        [awayTeam getWR:1].careerStatsRecYards += [wr2Yds intValue];
        wr2TD = AwayWR2Stats[3];
        [awayTeam getWR:1].careerStatsTD += [wr2TD intValue];
        wr2Drp = AwayWR2Stats[4];
        [awayTeam getWR:1].careerStatsDrops += [wr2Drp intValue];
        wr2Fum = AwayWR2Stats[5];
        [awayTeam getWR:1].careerStatsFumbles += [wr2Fum intValue];
        
        wr3Rec = AwayWR3Stats[0];
        [awayTeam getWR:2].careerStatsReceptions += [wr3Rec intValue];
        wr3Tgt = AwayWR3Stats[1];
        [awayTeam getWR:2].careerStatsTargets += [wr3Tgt intValue];
        wr3Yds = AwayWR3Stats[2];
        [awayTeam getWR:2].careerStatsRecYards += [wr3Yds intValue];
        wr3TD = AwayWR3Stats[3];
        [awayTeam getWR:2].careerStatsTD += [wr3TD intValue];
        wr3Drp = AwayWR3Stats[4];
        [awayTeam getWR:2].careerStatsDrops += [wr3Drp intValue];
        wr3Fum = AwayWR3Stats[5];
        [awayTeam getWR:2].careerStatsFumbles += [wr3Fum intValue];
        
        teRec = AwayTEStats[0];
        [awayTeam getTE:0].careerStatsReceptions += [teRec intValue];
        teTgt = AwayTEStats[1];
        [awayTeam getTE:0].careerStatsTargets += [teTgt intValue];
        teYds = AwayTEStats[2];
        [awayTeam getTE:0].careerStatsRecYards += [teYds intValue];
        teTD = AwayTEStats[3];
        [awayTeam getTE:0].careerStatsTD += [teTD intValue];
        teDrp = AwayTEStats[4];
        [awayTeam getTE:0].careerStatsDrops += [teDrp intValue];
        teFum = AwayTEStats[5];
        [awayTeam getTE:0].careerStatsFumbles += [teFum intValue];
        
        kXPM = AwayKStats[0];
        [awayTeam getK:0].careerStatsXPMade += [kXPM intValue];
        kXPA = AwayKStats[1];
        [awayTeam getK:0].careerStatsXPAtt += [kXPA intValue];
        kFGM = AwayKStats[2];
        [awayTeam getK:0].careerStatsFGMade += [kFGM intValue];
        kFGA = AwayKStats[3];
        [awayTeam getK:0].careerStatsFGAtt += [kFGA intValue];
        //NSLog(@"END AWAY TEAM");
        
        //game over, add wins
        //NSLog(@"CALCULATING STREAKS");
        if (homeScore > awayScore) {
            homeTeam.wins++;
            homeTeam.totalWins++;
            [homeTeam.gameWLSchedule addObject:@"W"];
            awayTeam.losses++;
            awayTeam.totalLosses++;
            [awayTeam.gameWLSchedule addObject:@"L"];
            [homeTeam.gameWinsAgainst addObject:awayTeam];
            
            if (homeTeam.streaks != nil) {
                if ([homeTeam.streaks.allKeys containsObject:awayTeam.abbreviation]) {
                    TeamStreak *streak = homeTeam.streaks[awayTeam.abbreviation];
                    [streak addWin];
                    [homeTeam.streaks setObject:streak forKey:awayTeam.abbreviation];
                } else {
                    TeamStreak *streak = [TeamStreak newStreakWithTeam:homeTeam opponent:awayTeam];
                    [streak addWin];
                    [homeTeam.streaks setObject:streak forKey:awayTeam.abbreviation];
                }
            } else {
                homeTeam.streaks = [NSMutableDictionary dictionary];
                TeamStreak *streak = [TeamStreak newStreakWithTeam:homeTeam opponent:awayTeam];
                [streak addWin];
                [homeTeam.streaks setObject:streak forKey:awayTeam.abbreviation];
            }
            
            if (awayTeam.streaks != nil) {
                if ([awayTeam.streaks.allKeys containsObject:homeTeam.abbreviation]) {
                    TeamStreak *streak = awayTeam.streaks[homeTeam.abbreviation];
                    [streak addLoss];
                    [awayTeam.streaks setObject:streak forKey:homeTeam.abbreviation];
                } else {
                    TeamStreak *streak = [TeamStreak newStreakWithTeam:awayTeam opponent:homeTeam];
                    [streak addLoss];
                    [awayTeam.streaks setObject:streak forKey:homeTeam.abbreviation];
                }
            } else {
                awayTeam.streaks = [NSMutableDictionary dictionary];
                TeamStreak *streak = [TeamStreak newStreakWithTeam:awayTeam opponent:homeTeam];
                [streak addLoss];
                [awayTeam.streaks setObject:streak forKey:homeTeam.abbreviation];
            }
            
        } else {
            homeTeam.losses++;
            homeTeam.totalLosses++;
            [homeTeam.gameWLSchedule addObject:@"L"];
            awayTeam.wins++;
            awayTeam.totalWins++;
            [awayTeam.gameWLSchedule addObject:@"W"];
            [awayTeam.gameWinsAgainst addObject:homeTeam];
            
            if (homeTeam.streaks != nil) {
                if ([homeTeam.streaks.allKeys containsObject:awayTeam.abbreviation]) {
                    TeamStreak *streak = homeTeam.streaks[awayTeam.abbreviation];
                    [streak addLoss];
                    [homeTeam.streaks setObject:streak forKey:awayTeam.abbreviation];
                } else {
                    TeamStreak *streak = [TeamStreak newStreakWithTeam:homeTeam opponent:awayTeam];
                    [streak addLoss];
                    [homeTeam.streaks setObject:streak forKey:awayTeam.abbreviation];
                }
            } else {
                homeTeam.streaks = [NSMutableDictionary dictionary];
                TeamStreak *streak = [TeamStreak newStreakWithTeam:homeTeam opponent:awayTeam];
                [streak addLoss];
                [homeTeam.streaks setObject:streak forKey:awayTeam.abbreviation];
                
            }
            
            if (awayTeam.streaks != nil) {
                if ([awayTeam.streaks.allKeys containsObject:homeTeam.abbreviation]) {
                    TeamStreak *streak = awayTeam.streaks[homeTeam.abbreviation];
                    [streak addWin];
                    [awayTeam.streaks setObject:streak forKey:homeTeam.abbreviation];
                } else {
                    TeamStreak *streak = [TeamStreak newStreakWithTeam:awayTeam opponent:homeTeam];
                    [streak addWin];
                    [awayTeam.streaks setObject:streak forKey:homeTeam.abbreviation];
                }
            } else {
                awayTeam.streaks = [NSMutableDictionary dictionary];
                TeamStreak *streak = [TeamStreak newStreakWithTeam:awayTeam opponent:homeTeam];
                [streak addWin];
                [awayTeam.streaks setObject:streak forKey:homeTeam.abbreviation];
            }
        }
        
        //NSLog(@"END CALCULATING STREAKS");
        //NSLog(@"START CONF GAME CALC");
        if (([homeTeam.conference isEqualToString:awayTeam.conference]) || [gameName isEqualToString:@"In Conf"] || [gameName isEqualToString:@"Rivalry Game"] ) {
            // in conference game, see if was won
            if (homeScore > awayScore) {
                homeTeam.confWins++;
                homeTeam.totalConfWins++;
                awayTeam.confLosses++;
                awayTeam.totalConfLosses++;
            } else if (homeScore < awayScore) {
                awayTeam.confWins++;
                awayTeam.totalConfWins++;
                homeTeam.confLosses++;
                homeTeam.totalConfLosses++;
            }
        }
        //NSLog(@"END CONF GAME CALC");
        
        //NSLog(@"START RIVALRY GAME CALC");
        if ([gameName isEqualToString:@"Rivalry Game"] || [homeTeam.rivalTeam isEqualToString:awayTeam.abbreviation] || [awayTeam.rivalTeam isEqualToString:homeTeam.abbreviation]) {
            if (homeScore > awayScore) {
                homeTeam.wonRivalryGame = true;
                awayTeam.wonRivalryGame = false;
                homeTeam.rivalryWins++;
                awayTeam.rivalryLosses++;
            } else {
                awayTeam.wonRivalryGame = true;
                homeTeam.wonRivalryGame = false;
                awayTeam.rivalryWins++;
                homeTeam.rivalryLosses++;
            }
        }
        //NSLog(@"END RIVALRY GAME CALC");
        
        [homeTeam checkForInjury];
        [awayTeam checkForInjury];
        
        [self addNewsStory];
        
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"playedGame" object:nil];
    //NSLog(@"TEARDOWN AND END PLAY GAME");
}

-(void)addNewsStory {
    NSMutableArray *currentWeekNews;
    if (numOT >= 3) {
        // Thriller in OT
        Team *winner, *loser;
        int winScore, loseScore;
        if (awayScore > homeScore) {
            winner = awayTeam;
            loser = homeTeam;
            winScore = awayScore;
            loseScore = homeScore;
        } else {
            winner = homeTeam;
            loser = awayTeam;
            winScore = homeScore;
            loseScore = awayScore;
        }
        
        currentWeekNews = homeTeam.league.newsStories[homeTeam.league.currentWeek+1];
        [currentWeekNews addObject:[NSString stringWithFormat:@"%ldOT Thriller!\n%@ and %@ played an absolutely thrilling game that went to %ld overtimes, with %@ finally emerging victorious %ld to %ld.", (long)numOT, winner.strRep, loser.strRep, (long)numOT, winner.name, (long)winScore, (long)loseScore]];
    }
    else if (homeScore > awayScore && awayTeam.losses == 1 && awayTeam.league.currentWeek > 5) {
        // 5-0 or better team given first loss
        currentWeekNews = awayTeam.league.newsStories[homeTeam.league.currentWeek+1];
        [currentWeekNews addObject:[NSString stringWithFormat:@"Undefeated no more! %@ suffers first loss!\n%@ hands %@ their first loss of the season, winning %ld to %ld.", awayTeam.name, homeTeam.strRep, awayTeam.strRep, (long)homeScore, (long)awayScore]];
    }
    else if (awayScore > homeScore && homeTeam.losses == 1 && homeTeam.league.currentWeek > 5) {
        // 5-0 or better team given first loss
        currentWeekNews = homeTeam.league.newsStories[awayTeam.league.currentWeek+1];
        [currentWeekNews addObject:[NSString stringWithFormat:@"Undefeated no more! %@ suffers first loss!\n%@ hands %@ their first loss of the season, winning %ld to %ld.", homeTeam.name, awayTeam.strRep, homeTeam.strRep, (long)awayScore, (long)homeScore]];

    }
    else if (awayScore > homeScore && homeTeam.rankTeamPollScore < 20 && (awayTeam.rankTeamPollScore - homeTeam.rankTeamPollScore) > 20) {
        // Upset!
        currentWeekNews = awayTeam.league.newsStories[homeTeam.league.currentWeek+1];
        [currentWeekNews addObject:[NSString stringWithFormat:@"Upset! %@ beats %@\n%@ pulls off the upset on the road against %@, winning %ld to %ld.", awayTeam.strRep, homeTeam.strRep, awayTeam.name, homeTeam.name, (long)awayScore, (long)homeScore]];
    }
    else if (homeScore > awayScore && awayTeam.rankTeamPollScore < 20 && (homeTeam.rankTeamPollScore - awayTeam.rankTeamPollScore) > 20) {
        // Upset!
        currentWeekNews = homeTeam.league.newsStories[awayTeam.league.currentWeek+1];
        [currentWeekNews addObject:[NSString stringWithFormat:@"Upset! %@ beats %@\n%@ pulls off the upset on the road against %@, winning %ld to %ld.", homeTeam.strRep, awayTeam.strRep, homeTeam.name, awayTeam.name, (long)homeScore, (long)awayScore]];
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
        double preferPass = ([offense getPassProf] - [defense getPassDef]) / 100 + [HBSharedUtils randomValue] * offense.offensiveStrategy.passPref;       //STRATEGIES
        double preferRush = ([offense getRushProf] - [defense getRushDef]) / 100 + [HBSharedUtils randomValue] * offense.offensiveStrategy.runPref;

        
        if (gameDown == 1 && gameYardLine >= 91) {
            gameYardsNeed = 100 - gameYardLine;
        }
        
        //Under 30 seconds to play, check that the team with the ball is trailing or tied, do something based on the score difference
        if ( gameTime <= 30 && !playingOT && ((gamePoss && (awayScore >= homeScore)) || (!gamePoss && (homeScore >= awayScore)))) {
            if ( ((gamePoss && (awayScore - homeScore) <= 3) || (!gamePoss && (homeScore - awayScore) <= 3)) && gameYardLine > 60 ) {
                //last second FGA
                [self fieldGoalAtt:offense defense:defense];
            } else {
                //hail mary
                [self passingPlay:offense defense:defense];
            }
        } else if ( gameDown >= 4 ) {
            if ( ((gamePoss && (awayScore - homeScore) > 3) || (!gamePoss && (homeScore - awayScore) > 3)) && gameTime < 300 ) {
                //go for it since we need 7 to win
                if ( gameYardsNeed < 3 ) {
                    [self rushingPlay:offense defense:defense];
                } else {
                    [self passingPlay:offense defense:defense];
                }
            } else {
                //4th down
                if ( gameYardsNeed < 3 ) {
                    if ( gameYardLine > 65 ) {
                        //fga
                        [self fieldGoalAtt:offense defense:defense];
                    } else if ( gameYardLine > 55 ) {
                        // run play, go for it!
                        [self rushingPlay:offense defense:defense];
                    } else {
                        //punt
                        [self puntPlay:offense];
                    }
                } else if ( gameYardLine > 60 ) {
                    //fga
                    [self fieldGoalAtt:offense defense:defense];
                } else {
                    //punt
                    [self puntPlay:offense];
                }
            }
        } else if ( (gameDown == 3 && gameYardsNeed > 4) || ((gameDown==1 || gameDown==2) && (preferPass >= preferRush)) ) {
            // pass play
            [self passingPlay:offense defense:defense];
        } else {
            //run play
            [self rushingPlay:offense defense:defense];
        }
    }
}

-(void)resetForOT {
    if (bottomOT && homeScore == awayScore) {
        gameYardLine = 75;
        gameYardsNeed = 10;
        gameDown = 1;
        numOT++;
        if ((numOT % 2) == 0) {
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
    double TEpref;
    //choose WR to throw to, better WRs more often
    double WR1pref = pow([offense getWR:0].ratOvr , 1 ) * [HBSharedUtils randomValue];
    double WR2pref = pow([offense getWR:1].ratOvr , 1 ) * [HBSharedUtils randomValue];
    
    double DL1pref = pow([defense getDL:0].ratDLPas, 1) * [HBSharedUtils randomValue];
    double DL2pref = pow([defense getDL:1].ratDLPas, 1) * [HBSharedUtils randomValue];
    double DL3pref = pow([defense getDL:2].ratDLPas, 1) * [HBSharedUtils randomValue];
    double DL4pref = pow([defense getDL:3].ratDLPas, 1) * [HBSharedUtils randomValue];
    
    double LB1pref = pow([defense getLB:0].ratLBPas, 1) * [HBSharedUtils randomValue];
    double LB2pref = pow([defense getLB:1].ratLBPas, 1) * [HBSharedUtils randomValue];
    double LB3pref = pow([defense getLB:2].ratLBPas, 1) * [HBSharedUtils randomValue];
    
    PlayerWR *selWR;
    PlayerCB *selCB;
    PlayerDL *selDL;
    PlayerLB *selLB;
    PlayerLB *selLB2;
    PlayerTE *selTE = [offense getTE:0];
    PlayerS *selS = [defense getS:0];
    PlayerQB *selQB = [offense getQB:0];
    
    if (gameYardLine > 90) {
        TEpref = pow(((selTE.ratRecCat + selTE.ratRecSpd) / 2), 1) * [HBSharedUtils randomValue] * 1.25;
    } else {
        TEpref = pow(((selTE.ratRecCat + selTE.ratRecSpd) / 2), 1) * [HBSharedUtils randomValue] * .67;
    }
    
    NSMutableArray *selWRStats;
    if (WR1pref > WR2pref) {
        selWR = [offense getWR:0];
        selCB = [defense getCB:0];
        if (gamePoss) {
            selWRStats = HomeWR1Stats;
        } else selWRStats = AwayWR1Stats;
    } else {
        selWR = [offense getWR:1];
        selCB = [defense getCB:1];
        if (gamePoss) {
            selWRStats = HomeWR2Stats;
        } else selWRStats = AwayWR2Stats;
    }
    
    //Choose the DL involved in play
    if (DL1pref > DL2pref && DL1pref > DL3pref && DL1pref > DL4pref) {
        selDL = [defense getDL:0];
    } else if (DL2pref > DL1pref && DL2pref > DL3pref && DL2pref > DL4pref) {
        selDL = [defense getDL:1];
    } else if (DL3pref > DL1pref && DL3pref > DL2pref && DL3pref > DL4pref) {
        selDL = [defense getDL:2];
    } else {
        selDL = [defense getDL:3];
    }
    
    //Choose LB involved in play
    if (LB1pref > LB2pref && LB1pref > LB3pref) {
        selLB = [defense getLB:0];
        selLB2 = [defense getLB:1];
    } else if (LB2pref > LB1pref && LB2pref > LB3pref) {
        selLB = [defense getLB:1];
        selLB2 = [defense getLB:2];
    } else {
        selLB = [defense getLB:2];
        selLB2 = [defense getLB:0];
    }
    
    NSMutableArray *selTEStats;
    if (gamePoss) {
        selTEStats = HomeTEStats;
    } else {
        selTEStats = AwayTEStats;
    }
    //Choose the Catch Target
    if (TEpref > WR1pref && TEpref > WR2pref) {
        [self passingPlayTE:offense defense:defense selQB:selQB selTE:selTE selTEStats:selTEStats selCB:selCB selS:selS selDL:selDL selLB:selLB selLB2:selLB2];
    } else {
        [self passingPlayWR:offense defense:defense selQB:selQB selWR:selWR selWRStats:selWRStats selCB:selCB selS:selS];
    }
}

-(void)passingPlayTE:(Team *)offense defense:(Team *)defense selQB:(PlayerQB*)selQB selTE:(PlayerTE*)selTE selTEStats:(NSMutableArray*)selTEStats selCB:(PlayerCB*)selCB selS:(PlayerS*)selS selDL:(PlayerDL*)selDL selLB:(PlayerLB*)selLB selLB2:(PlayerLB*)selLB2 {
    int yardsGain = 0;
    BOOL gotTD = false;
    BOOL gotFumble = false;
    
    //get how much pressure there is on qb, check if sack
    int pressureOnQB = [defense getCompositeF7Pass]*2 - [offense getCompositeOLPass] - [self getHFAdv] + (defense.defensiveStrategy.runProtection*2 - offense.offensiveStrategy.runProtection);
    if ([HBSharedUtils randomValue]*100 < pressureOnQB/8 ) {
        //sacked!
        [self qbSack:offense];
        return;
    }
    
    //check for int
    double intChance = (pressureOnQB + selS.ratOvr - (selQB.ratPassAcc+selQB.ratFootIQ+100)/3)/18 - offense.offensiveStrategy.passProtection + defense.defensiveStrategy.passProtection;

    if (intChance < 0.015) intChance = 0.015;
    if ( 100* [HBSharedUtils randomValue] < intChance ) {
        //Interception
        [self qbInterception:offense];
        return;
    }
    
    //throw ball, check for completion
    double completion = ( [self getHFAdv] + [self normalize:[offense getQB:0].ratPassAcc] + [self normalize:selTE.ratRecCat] - [self normalize:selLB.ratLBPas])/2 + 18.25 - pressureOnQB/16.8 + offense.offensiveStrategy.passProtection - defense.defensiveStrategy.passProtection;
    if ( 100* [HBSharedUtils randomValue] < completion ) {
        if ( 100* [HBSharedUtils randomValue] < (100 - selTE.ratRecCat)/3 ) {
            //drop
            gameDown++;
            NSNumber *wrStat = selTEStats[4];
            wrStat = [NSNumber numberWithInteger:wrStat.integerValue + 1];
            [selTEStats replaceObjectAtIndex:4 withObject:wrStat];
            selTE.statsDrops++;
            [self passAttempt:offense defense:defense receiver:selTE stats:selTEStats yardsGained:yardsGain];
            gameTime -= (15 * [HBSharedUtils randomValue]);
            return;
        } else {
            //no drop
            yardsGain = (int) (( [self normalize:[offense getQB:0].ratPassPow] + [self normalize:selTE.ratRecSpd] - [self normalize:selCB.ratCBSpd] )* [HBSharedUtils randomValue]/3.7 + offense.offensiveStrategy.passPotential - defense.defensiveStrategy.passPotential);
            //see if receiver can get yards after catch
            double escapeChance = ([self normalize:selTE.ratRecEva] * 3 - selLB.ratLBTkl - selS.ratSTkl) * [HBSharedUtils randomValue] + offense.offensiveStrategy.passPotential - defense.defensiveStrategy.passPotential;
            if ( escapeChance > 92 ||[HBSharedUtils randomValue] > 0.95 ) {
                yardsGain += 3 + (selTE.ratRecSpd * [HBSharedUtils randomValue]/4);
            }
            if ( escapeChance > 75 &&[HBSharedUtils randomValue] < (0.1 + (offense.offensiveStrategy.passPotential)-defense.defensiveStrategy.passPotential)/200) {
                //wr escapes for TD
                yardsGain += 100;
            }
            
            //add yardage
            gameYardLine += yardsGain;
            if ( gameYardLine >= 100 ) { //TD!
                yardsGain -= gameYardLine - 100;
                gameYardLine = 100 - yardsGain;
                [self addPointsQuarter:6];
                [self passingTD:offense receiver:selTE stats:selTEStats yardsGained:yardsGain];
                //offense.teamPoints += 6;
                //defense.teamOppPoints += 6;
                gotTD = true;
            } else {
                //check for fumble
                double fumChance = (selS.ratSTkl + selLB.ratLBTkl)/2;
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
            [self passCompletion:offense defense:defense receiver:selTE stats:selTEStats yardsGained:yardsGain];
        }
        
    } else {
        //no completion, advance downs
        [self passAttempt:offense defense:defense receiver:selTE stats:selTEStats yardsGained:yardsGain];
        gameDown++;
        gameTime -= (15 * [HBSharedUtils randomValue]);
        return;
    }
    
    
    if ( gotFumble ) {
        [gameEventLog appendString:[NSString stringWithFormat:@"%@TURNOVER!\n%@ TE %@ fumbled the ball after a catch.", [self getEventPrefix],offense.abbreviation,selTE.name]];
        NSNumber *wrFum = selTEStats[5];
        wrFum = [NSNumber numberWithInteger:wrFum.integerValue + 1];
        [selTEStats replaceObjectAtIndex:5 withObject:wrFum];
        selTE.statsFumbles++;
        
        if ( gamePoss ) { // home possession
            homeTOs++;
        } else {
            awayTOs++;
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


-(void)passingPlayWR:(Team *)offense defense:(Team *)defense selQB:(PlayerQB*)selQB selWR:(PlayerWR*)selWR selWRStats:(NSMutableArray*)selWRStats selCB:(PlayerCB*)selCB selS:(PlayerS*)selS {
    int yardsGain = 0;
    BOOL gotTD = false;
    BOOL gotFumble = false;
    
    //get how much pressure there is on qb, check if sack
    int pressureOnQB = [defense getCompositeF7Pass]*2 - [offense getCompositeOLPass] - [self getHFAdv] + + (defense.defensiveStrategy.runProtection*2 - offense.offensiveStrategy.runProtection);
    if ([HBSharedUtils randomValue]*100 < pressureOnQB/8 ) {
        //sacked!
        [self qbSack:offense];
        return;
    }
    
    //check for int
    double intChance = (pressureOnQB + selS.ratOvr - ([offense getQB:0].ratPassAcc+[offense getQB:0].ratFootIQ+100)/3)/18 - offense.offensiveStrategy.passProtection + defense.defensiveStrategy.passProtection;
    if (intChance < 0.015) intChance = 0.015;
    if ( 100* [HBSharedUtils randomValue] < intChance ) {
        //Interception
        [self qbInterception:offense];
        return;
    }
    
    //throw ball, check for completion
    double completion = ([self getHFAdv] + (int) ([HBSharedUtils randomValue]) + [self normalize:[offense getQB:0].ratPassAcc] + [self normalize:selWR.ratRecCat] - [self normalize:selCB.ratCBCov]) / 2 + 18.25 - pressureOnQB / 16.8 + offense.offensiveStrategy.passProtection - defense.defensiveStrategy.passProtection;
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
            yardsGain = (int) (([self normalize:[offense getQB:0].ratPassPow] + [self normalize:selWR.ratRecSpd] - [self normalize:selCB.ratCBSpd]) * [HBSharedUtils randomValue] / 4.8 + offense.offensiveStrategy.passPotential - defense.defensiveStrategy.passPotential);

            //see if receiver can get yards after catch
            double escapeChance = ([self normalize:(selWR.ratRecEva)*3 - selCB.ratCBTkl - selS.ratOvr]* [HBSharedUtils randomValue] + offense.offensiveStrategy.passPotential - defense.defensiveStrategy.passPotential);
            if ( escapeChance > 92 ||[HBSharedUtils randomValue] > 0.95 ) {
                yardsGain += 3 + (selWR.ratRecSpd * [HBSharedUtils randomValue]/4);
            }
            if ( escapeChance > 80 && [HBSharedUtils randomValue] < (0.1 + (offense.offensiveStrategy.passPotential - defense.defensiveStrategy.passPotential) / 200)) {
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
                double fumChance = (selS.ratSTkl + selCB.ratCBTkl)/2;
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
    
    
    if ( gotFumble ) {
        [gameEventLog appendString:[NSString stringWithFormat:@"%@TURNOVER!\n%@ WR %@ fumbled the ball after a catch.", [self getEventPrefix],offense.abbreviation,selWR.name]];
        NSNumber *wrFum = selWRStats[5];
        wrFum = [NSNumber numberWithInteger:wrFum.integerValue + 1];
        [selWRStats replaceObjectAtIndex:5 withObject:wrFum];
        selWR.statsFumbles++;
        
        if ( gamePoss ) { // home possession
            homeTOs++;
        } else {
            awayTOs++;
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
    PlayerTE *selTE = [offense getTE:0];
    PlayerS *selS = [defense getS:0];
    PlayerQB *selQB = [offense getQB:0];
    PlayerRB *selRB;
    PlayerDL *selDL;
    PlayerLB *selLB;
    PlayerCB *selCB;
    
    int playerRB;
    int playerDL;
    int playerLB;
    int playerCB;
    
    double RB1pref = pow([offense getRB:0].ratOvr, 1.5) * [HBSharedUtils randomValue];
    double RB2pref =pow([offense getRB:1].ratOvr, 1.5) * [HBSharedUtils randomValue];
    double QBpref = pow(selQB.ratSpeed, 1.5) * [HBSharedUtils randomValue];
    
    double DL1pref = pow([defense getDL:0].ratDLRsh, 1) * [HBSharedUtils randomValue];
    double DL2pref = pow([defense getDL:1].ratDLRsh, 1) * [HBSharedUtils randomValue];
    double DL3pref = pow([defense getDL:2].ratDLRsh, 1) * [HBSharedUtils randomValue];
    double DL4pref = pow([defense getDL:3].ratDLRsh, 1) * [HBSharedUtils randomValue];
    
    double LB1pref = pow([defense getLB:0].ratLBRsh, 1) * [HBSharedUtils randomValue];
    double LB2pref = pow([defense getLB:1].ratLBRsh, 1) * [HBSharedUtils randomValue];
    double LB3pref = pow([defense getLB:2].ratLBRsh, 1) * [HBSharedUtils randomValue];
    
    double CB1pref = pow([defense getCB:0].ratCBTkl, 1) * [HBSharedUtils randomValue];
    double CB2pref = pow([defense getCB:1].ratCBTkl, 1) * [HBSharedUtils randomValue];
    double CB3pref = pow([defense getCB:2].ratCBTkl, 1) * [HBSharedUtils randomValue];
    
    if (RB1pref > RB2pref) {
        selRB = [offense getRB:0];
        playerRB = 0;
    } else {
        selRB = [offense getRB:1];
        playerRB = 1;
    }
    
    if (DL1pref > DL2pref && DL1pref > DL3pref && DL1pref > DL4pref) {
        selDL = [defense getDL:0];
        playerDL = 0;
    } else if (DL2pref > DL1pref && DL2pref > DL3pref && DL2pref > DL4pref) {
        selDL = [defense getDL:1];
        playerDL = 1;
    } else if (DL3pref > DL1pref && DL3pref > DL2pref && DL3pref > DL4pref) {
        selDL = [defense getDL:2];
        playerDL = 2;
    } else {
        selDL = [defense getDL:3];
        playerDL = 3;
    }
    
    if (LB1pref > LB2pref && LB1pref > LB3pref) {
        selLB = [defense getLB:0];
        playerLB = 0;
    } else if (LB2pref > LB1pref && LB2pref > LB3pref) {
        selLB = [defense getLB:1];
        playerLB = 1;
    } else {
        selLB = [defense getLB:2];
        playerLB = 2;
    }
    
    if (CB1pref > CB2pref && CB1pref > CB3pref) {
        selCB = [defense getCB:0];
        playerCB = 0;
    } else if (CB2pref > CB1pref && CB2pref > CB3pref) {
        selCB = [defense getCB:1];
        playerCB = 1;
    } else {
        selCB = [defense getCB:2];
        playerCB = 2;
    }
    
   
    if (offense.teamStatOffNum == 4 && QBpref > RB1pref && QBpref > RB2pref) {
        [self _rushingPlayQB:offense defense:defense selQB:selQB selDL:selDL selTE:selTE selLB:selLB selS:selS selCB:selCB];
        
    } else if (QBpref * 0.2 > RB1pref && QBpref * 0.2 > RB2pref) {
        [self _rushingPlayQB:offense defense:defense selQB:selQB selDL:selDL selTE:selTE selLB:selLB selS:selS selCB:selCB];
    } else {
        [self _rushingPlayRB:offense defense:defense selRB:selRB selDL:selDL selTE:selTE selLB:selLB selS:selS RB1pref:RB1pref RB2pref:RB2pref];
    }
}

-(void)_rushingPlayQB:(Team*)offense defense:(Team*)defense selQB:(PlayerQB*)selQB selDL:(PlayerDL*)selDL selTE:(PlayerTE*)selTE selLB:(PlayerLB*)selLB selS:(PlayerS*)selS selCB:(PlayerCB*)selCB {
    BOOL gotTD = false;
    
    int blockAdv = [offense getCompositeOLRush] - [defense getCompositeF7Rush] + (offense.offensiveStrategy.runProtection - defense.defensiveStrategy.runProtection);
    int blockAdvOutside = selTE.ratTERunBlk * 2 - selLB.ratLBRsh - selS.ratSTkl + (offense.offensiveStrategy.runUsage - defense.defensiveStrategy.runUsage);
    int yardsGain = (int) ((selQB.ratSpeed + blockAdv + blockAdvOutside + [self getHFAdv]) * [HBSharedUtils randomValue] / 10 + offense.offensiveStrategy.runPotential/2 - defense.defensiveStrategy.runPotential/2);
    if (yardsGain < 2) {
        yardsGain += selQB.ratPassEva/20 - 3 - defense.defensiveStrategy.runPotential/2;
    } else {
        //break free from tackles
        if ([HBSharedUtils randomValue] < ( 0.20 + ( offense.offensiveStrategy.runPotential - defense.defensiveStrategy.runPotential/2 )/50 )) {
            yardsGain += (selQB.ratPassEva - blockAdvOutside) / 5 * [HBSharedUtils randomValue];
        }
    }
    
    //add yardage
    gameYardLine += yardsGain;
    if ( gameYardLine >= 100 ) { //TD!
        [self addPointsQuarter:6];
        yardsGain -= gameYardLine - 100;
        gameYardLine = 100 - yardsGain;
        
        selQB.statsRushTD++;
        if ( gamePoss ) { // home possession
            homeScore += 6;
            NSNumber *kStat1 = HomeQBStats[8];
            kStat1 = [NSNumber numberWithInteger:kStat1.integerValue + 1];
            [HomeQBStats replaceObjectAtIndex:8 withObject:kStat1];
        } else {
            awayScore += 6;
            NSNumber *kStat1 = AwayQBStats[8];
            kStat1 = [NSNumber numberWithInteger:kStat1.integerValue + 1];
            [AwayQBStats replaceObjectAtIndex:8 withObject:kStat1];
        }
        
        if (yardsGain != 1) {
            tdInfo = [NSString stringWithFormat:@"%@ QB %@ rushed %d yards for a TD.\n", offense.abbreviation,selQB.name,yardsGain];
        } else {
            tdInfo = [NSString stringWithFormat:@"%@ QB %@ rushed %d yard for a TD.\n", offense.abbreviation,selQB.name,yardsGain];
        }
        
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
    [self rushAttemptQB:offense defense:defense rusher:selQB yardsGained:yardsGain];
    
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
        double fumChance = (selS.ratSTkl + [defense getCompositeF7Rush] - [self getHFAdv])/2 + offense.offensiveStrategy.runProtection;
        if ( 100* [HBSharedUtils randomValue] < fumChance/40 ) {
            //Fumble!
            selQB.statsFumbles++;
            if ( gamePoss ) {
                homeTOs++;
                NSNumber *kStat1 = HomeQBStats[9];
                kStat1 = [NSNumber numberWithInteger:kStat1.integerValue + 1];
                [HomeQBStats replaceObjectAtIndex:9 withObject:kStat1];
            } else {
                awayTOs++;
                NSNumber *kStat1 = AwayQBStats[9];
                kStat1 = [NSNumber numberWithInteger:kStat1.integerValue + 1];
                [AwayQBStats replaceObjectAtIndex:9 withObject:kStat1];
            }
            
            [gameEventLog  appendString:[NSString stringWithFormat:@"%@TURNOVER!\n%@ QB %@ fumbled the ball while rushing.",[self getEventPrefix], offense.abbreviation, selQB.name]];
            
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

-(void)_rushingPlayRB:(Team*)offense defense:(Team*)defense selRB:(PlayerRB*)selRB selDL:(PlayerDL*)selDL selTE:(PlayerTE*)selTE selLB:(PlayerLB*)selLB selS:(PlayerS*)selS RB1pref:(double)RB1pref RB2pref:(double)RB2pref {
    BOOL gotTD = false;
    int blockAdv = [offense getCompositeOLRush] - [defense getCompositeF7Rush] + (offense.offensiveStrategy.runProtection - defense.defensiveStrategy.runProtection);
    int blockAdvOutside = selTE.ratTERunBlk * 2 - selLB.ratLBRsh - selS.ratSTkl + (offense.offensiveStrategy.runUsage - defense.defensiveStrategy.runUsage);
    int yardsGain = (int) ((selRB.ratRushSpd + blockAdv + blockAdvOutside + [self getHFAdv]) * [HBSharedUtils randomValue] / 10 + offense.offensiveStrategy.runPotential/2 - defense.defensiveStrategy.runPotential/2);
    if (yardsGain < 2) {
        yardsGain += selRB.ratRushPow/20 - 3 - defense.defensiveStrategy.runPotential/2;
    } else {
        //break free from tackles
        if ([HBSharedUtils randomValue] < ( 0.28 + ( offense.offensiveStrategy.runPotential - defense.defensiveStrategy.runPotential/2 )/50 )) {
            yardsGain += (selRB.ratRushEva - blockAdvOutside)/5 *[HBSharedUtils randomValue];
        }
    }
    
    //add yardage
    gameYardLine += yardsGain;
    if ( gameYardLine >= 100 ) { //TD!
        [self addPointsQuarter:6];
        yardsGain -= gameYardLine - 100;
        gameYardLine = 100 - yardsGain;
        if ( gamePoss ) { // home possession
            homeScore += 6;
            if (RB1pref > RB2pref) {
                NSNumber *kStat1 = HomeRB1Stats[2];
                kStat1 = [NSNumber numberWithInteger:kStat1.integerValue + 1];
                [HomeRB1Stats replaceObjectAtIndex:2 withObject:kStat1];
            } else {
                NSNumber *kStat1 = HomeRB2Stats[2];
                kStat1 = [NSNumber numberWithInteger:kStat1.integerValue + 1];
                [HomeRB2Stats replaceObjectAtIndex:2 withObject:kStat1];
            }
        } else {
            awayScore += 6;
            if (RB1pref > RB2pref) {
                NSNumber *kStat1 = AwayRB1Stats[2];
                kStat1 = [NSNumber numberWithInteger:kStat1.integerValue + 1];
                [AwayRB1Stats replaceObjectAtIndex:2 withObject:kStat1];
            } else {
                NSNumber *kStat1 = AwayRB2Stats[2];
                kStat1 = [NSNumber numberWithInteger:kStat1.integerValue + 1];
                [AwayRB2Stats replaceObjectAtIndex:2 withObject:kStat1];
            }
        }
        if (yardsGain != 1) {
            tdInfo = [NSString stringWithFormat:@"%@ RB %@ rushed %d yards for a TD.\n", offense.abbreviation,selRB.name,yardsGain];
        } else {
            tdInfo = [NSString stringWithFormat:@"%@ RB %@ rushed %d yard for a TD.\n", offense.abbreviation,selRB.name,yardsGain];
        }
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
        double fumChance = (selS.ratSTkl + [defense getCompositeF7Rush] - [self getHFAdv])/2 + offense.offensiveStrategy.runProtection;
        if ( 100* [HBSharedUtils randomValue] < fumChance/40 ) {
            //Fumble!
            if ( gamePoss ) {
                homeTOs++;
                if (RB1pref > RB2pref) {
                    NSNumber *kStat1 = HomeRB1Stats[3];
                    kStat1 = [NSNumber numberWithInteger:kStat1.integerValue + 1];
                    [HomeRB1Stats replaceObjectAtIndex:3 withObject:kStat1];
                } else {
                    NSNumber *kStat1 = HomeRB2Stats[3];
                    kStat1 = [NSNumber numberWithInteger:kStat1.integerValue + 1];
                    [HomeRB2Stats replaceObjectAtIndex:3 withObject:kStat1];
                }
            } else {
                awayTOs++;
                if (RB1pref > RB2pref) {
                    NSNumber *kStat1 = AwayRB1Stats[3];
                    kStat1 = [NSNumber numberWithInteger:kStat1.integerValue + 1];
                    [AwayRB1Stats replaceObjectAtIndex:3 withObject:kStat1];
                } else {
                    NSNumber *kStat1 = AwayRB2Stats[3];
                    kStat1 = [NSNumber numberWithInteger:kStat1.integerValue + 1];
                    [AwayRB2Stats replaceObjectAtIndex:3 withObject:kStat1];
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
            homeScore += 3;
            NSNumber *kStat1 = HomeKStats[3];
            kStat1 = [NSNumber numberWithInteger:kStat1.integerValue + 1];
            [HomeKStats replaceObjectAtIndex:3 withObject:kStat1];
            
            NSNumber *kStat2 = HomeKStats[2];
            kStat2 = [NSNumber numberWithInteger:kStat2.integerValue + 1];
            [HomeKStats replaceObjectAtIndex:2 withObject:kStat2];
        } else {
            awayScore += 3;
            NSNumber *kStat1 = AwayKStats[3];
            kStat1 = [NSNumber numberWithInteger:kStat1.integerValue + 1];
            [AwayKStats replaceObjectAtIndex:3 withObject:kStat1];
            
            NSNumber *kStat2 = AwayKStats[2];
            kStat2 = [NSNumber numberWithInteger:kStat2.integerValue + 1];
            [AwayKStats replaceObjectAtIndex:2 withObject:kStat2];
        }
        [gameEventLog appendString:[NSString stringWithFormat:@"%@%@ K %@ made the %d yard FG.",[self getEventPrefix], offense.abbreviation, [offense getK:0].name, (117-gameYardLine)]];
        [self addPointsQuarter:3];
        //offense.teamPoints += 3;
        //defense.teamOppPoints += 3;
        [offense getK:0].statsFGMade++;
        [offense getK:0].statsFGAtt++;
        //[offense getK:0].careerStatsFGAtt++;
        if (!playingOT) {
            [self kickOff:offense];
        } else {
            [self resetForOT];
        }
        
    } else {
        //miss
        
        [gameEventLog appendString:[NSString stringWithFormat:@"%@%@ K %@ missed the %d yard FG!",[self getEventPrefix], offense.abbreviation, [offense getK:0].name, (117-gameYardLine)]];
        [offense getK:0].statsFGAtt++;
        if ( gamePoss ) { // home possession
            NSNumber *kStat1 = HomeKStats[3];
            kStat1 = [NSNumber numberWithInteger:kStat1.integerValue + 1];
            [HomeKStats replaceObjectAtIndex:3 withObject:kStat1];
        } else {
            NSNumber *kStat1 = AwayKStats[3];
            kStat1 = [NSNumber numberWithInteger:kStat1.integerValue + 1];
            [AwayKStats replaceObjectAtIndex:3 withObject:kStat1];
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
    if (!playingOT) {
        if (gameTime <= 0 && abs(homeScore - awayScore) > 2) {
            if (awayScore > homeScore && [awayTeam.abbreviation isEqualToString:offense.abbreviation]) {
                //AWAY WINS ON WALKOFF!
                [gameEventLog appendString:[NSString stringWithFormat:@"%@%@%@ wins on a walk-off touchdown!",[self getEventPrefix],tdInfo,awayTeam.abbreviation]];
            } else if (homeScore > awayScore && [homeTeam.abbreviation isEqualToString:offense.abbreviation]) {
                //HOME WINS ON WALKOFF!
                [gameEventLog appendString:[NSString stringWithFormat:@"%@%@%@ wins on a walk-off touchdown!",[self getEventPrefix],tdInfo,homeTeam.abbreviation]];
            }
        } else {
            //NORMALLY KICK THE XP OR GO FOR 2
            if (((gamePoss && (awayScore -homeScore) == 2) || (!gamePoss && (homeScore -awayScore) == 2)) && gameTime < 300) {
                //go for 2
                //BOOL //successConversion = false;
                if ( [HBSharedUtils randomValue] <= 0.50 ) {
                    //rushing
                    int blockAdv = [offense getCompositeOLRush] - [defense getCompositeF7Rush];
                    int yardsGain = (int) (([offense getRB:0].ratRushSpd + blockAdv) * [HBSharedUtils randomValue] / 6);
                    if ( yardsGain > 5 ) {
                        //successConversion = true;
                        if ( gamePoss ) { // home possession
                            homeScore += 2;
                        } else {
                            awayScore += 2;
                        }
                        [self addPointsQuarter:2];
                        [gameEventLog appendString:[NSString stringWithFormat:@"%@%@%@ rushed for the 2pt conversion.",[self getEventPrefix],tdInfo,[offense getRB:0].name]];
                    } else {
                        [gameEventLog appendString:[NSString stringWithFormat:@"%@%@%@ stopped at the line of scrimmage, failed the 2pt conversion.",[self getEventPrefix],tdInfo,[offense getRB:0].name]];
                    }
                } else {
                    int pressureOnQB = ([defense getCompositeF7Pass]*2) - [offense getCompositeOLPass];
                    double completion = ([self normalize:[offense getQB:0].ratPassAcc] + [offense getWR:0].ratRecCat - [defense getCB:0].ratCBCov )/2 + 25 - pressureOnQB/20;
                    if ( 100*[HBSharedUtils randomValue] < completion ) {
                        //successConversion = true;
                        if ( gamePoss ) { // home possession
                            homeScore += 2;
                        } else {
                            awayScore += 2;
                        }
                        [self addPointsQuarter:2];
                        [gameEventLog appendString:[NSString stringWithFormat:@"%@%@2pt conversion is good! %@ completed the pass to %@ for the 2pt conversion.",[self getEventPrefix],tdInfo,[offense getQB:0].name, [offense getWR:0].name]];
                    } else {
                        [gameEventLog appendString:[NSString stringWithFormat:@"%@%@2pt conversion failed! %@'s pass incomplete to %@.",[self getEventPrefix],tdInfo,[offense getQB:0].name, [offense getWR:0].name]];
                    }
                }
            } else {
                //kick XP
                if ( [HBSharedUtils randomValue]*100 < 23 + [offense getK:0].ratKickAcc && [HBSharedUtils randomValue] > 0.01 ) {
                    //made XP
                    if ( gamePoss ) { // home possession
                        homeScore += 1;
                        NSNumber *kStat1 = HomeKStats[0];
                        kStat1 = [NSNumber numberWithInteger:kStat1.integerValue + 1];
                        [HomeKStats replaceObjectAtIndex:0 withObject:kStat1];
                        
                        NSNumber *kStat2 = HomeKStats[1];
                        kStat2 = [NSNumber numberWithInteger:kStat2.integerValue + 1];
                        [HomeKStats replaceObjectAtIndex:1 withObject:kStat2];
                    } else {
                        awayScore += 1;
                        NSNumber *kStat1 = AwayKStats[0];
                        kStat1 = [NSNumber numberWithInteger:kStat1.integerValue + 1];
                        [AwayKStats replaceObjectAtIndex:0 withObject:kStat1];
                        
                        NSNumber *kStat2 = AwayKStats[1];
                        kStat2 = [NSNumber numberWithInteger:kStat2.integerValue + 1];
                        [AwayKStats replaceObjectAtIndex:1 withObject:kStat2];
                    }
                    
                    [gameEventLog appendString:[NSString stringWithFormat:@"%@%@%@ made the XP.",[self getEventPrefix],tdInfo,[offense getK:0].name]];
                    [self addPointsQuarter:1];
                    [offense getK:0].statsXPMade++;
                } else {
                    [gameEventLog appendString:[NSString stringWithFormat:@"%@%@%@ missed the XP.",[self getEventPrefix],tdInfo,[offense getK:0].name]];
                    // missed XP
                    if ( gamePoss ) { // home possession
                        NSNumber *kStat2 = HomeKStats[1];
                        kStat2 = [NSNumber numberWithInteger:kStat2.integerValue + 1];
                        [HomeKStats replaceObjectAtIndex:1 withObject:kStat2];
                    } else {
                        NSNumber *kStat2 = AwayKStats[1];
                        kStat2 = [NSNumber numberWithInteger:kStat2.integerValue + 1];
                        [AwayKStats replaceObjectAtIndex:1 withObject:kStat2];
                    }
                }
                [offense getK:0].statsXPAtt++;
            }
        }
    } else {
        if (bottomOT) {     //IF IN BOTTOM FRAME OF OT AND THE OFFENSE SCORES A TD TO MAKE THE SCORE GREATER THAN THE DEFENSE, THEN NO XP ACTION - DECLARE A WINNER
            if ([homeTeam.abbreviation isEqualToString:offense.abbreviation] && homeScore > awayScore) {
                [gameEventLog appendString:[NSString stringWithFormat:@"%@%@%@ wins on a walk-off touchdown!",[self getEventPrefix],tdInfo,homeTeam.abbreviation]];
            } else if ([awayTeam.abbreviation isEqualToString:offense.abbreviation] && awayScore > homeScore) {
                [gameEventLog appendString:[NSString stringWithFormat:@"%@%@%@ wins on a walk-off touchdown!",[self getEventPrefix],tdInfo,awayTeam.abbreviation]];
            } else {
                if (numOT < 3) {
                    if (((gamePoss && (awayScore -homeScore) == 2) || (!gamePoss && (homeScore -awayScore) == 2)) && gameTime < 300) {
                        //go for 2
                        //BOOL //successConversion = false;
                        if ( [HBSharedUtils randomValue] <= 0.50 ) {
                            //rushing
                            int blockAdv = [offense getCompositeOLRush] - [defense getCompositeF7Rush];
                            int yardsGain = (int) (([offense getRB:0].ratRushSpd + blockAdv) * [HBSharedUtils randomValue] / 6);
                            if ( yardsGain > 5 ) {
                                //successConversion = true;
                                if ( gamePoss ) { // home possession
                                    homeScore += 2;
                                } else {
                                    awayScore += 2;
                                }
                                [self addPointsQuarter:2];
                                [gameEventLog appendString:[NSString stringWithFormat:@"%@%@%@ rushed for the 2pt conversion.",[self getEventPrefix],tdInfo,[offense getRB:0].name]];
                            } else {
                                [gameEventLog appendString:[NSString stringWithFormat:@"%@%@%@ stopped at the line of scrimmage, failed the 2pt conversion.",[self getEventPrefix],tdInfo,[offense getRB:0].name]];
                            }
                        } else {
                            int pressureOnQB = ([defense getCompositeF7Pass]*2) - [offense getCompositeOLPass];
                            double completion = ([self normalize:[offense getQB:0].ratPassAcc] + [offense getWR:0].ratRecCat - [defense getCB:0].ratCBCov )/2 + 25 - pressureOnQB/20;
                            if ( 100*[HBSharedUtils randomValue] < completion ) {
                                //successConversion = true;
                                if ( gamePoss ) { // home possession
                                    homeScore += 2;
                                } else {
                                    awayScore += 2;
                                }
                                [self addPointsQuarter:2];
                                [gameEventLog appendString:[NSString stringWithFormat:@"%@%@2pt conversion is good! %@ completed the pass to %@ for the 2pt conversion.",[self getEventPrefix],tdInfo,[offense getQB:0].name, [offense getWR:0].name]];
                            } else {
                                [gameEventLog appendString:[NSString stringWithFormat:@"%@%@2pt conversion failed! %@'s pass incomplete to %@.",[self getEventPrefix],tdInfo,[offense getQB:0].name, [offense getWR:0].name]];
                            }
                        }
                    } else {
                        //kick XP
                        if ( [HBSharedUtils randomValue]*100 < 23 + [offense getK:0].ratKickAcc && [HBSharedUtils randomValue] > 0.01 ) {
                            //made XP
                            if ( gamePoss ) { // home possession
                                homeScore += 1;
                                NSNumber *kStat1 = HomeKStats[0];
                                kStat1 = [NSNumber numberWithInteger:kStat1.integerValue + 1];
                                [HomeKStats replaceObjectAtIndex:0 withObject:kStat1];
                                
                                NSNumber *kStat2 = HomeKStats[1];
                                kStat2 = [NSNumber numberWithInteger:kStat2.integerValue + 1];
                                [HomeKStats replaceObjectAtIndex:1 withObject:kStat2];
                            } else {
                                awayScore += 1;
                                NSNumber *kStat1 = AwayKStats[0];
                                kStat1 = [NSNumber numberWithInteger:kStat1.integerValue + 1];
                                [AwayKStats replaceObjectAtIndex:0 withObject:kStat1];
                                
                                NSNumber *kStat2 = AwayKStats[1];
                                kStat2 = [NSNumber numberWithInteger:kStat2.integerValue + 1];
                                [AwayKStats replaceObjectAtIndex:1 withObject:kStat2];
                            }
                            
                            [gameEventLog appendString:[NSString stringWithFormat:@"%@%@%@ made the XP.",[self getEventPrefix],tdInfo,[offense getK:0].name]];
                            [self addPointsQuarter:1];
                            [offense getK:0].statsXPMade++;
                        } else {
                            [gameEventLog appendString:[NSString stringWithFormat:@"%@%@%@ missed the XP.",[self getEventPrefix],tdInfo,[offense getK:0].name]];
                            // missed XP
                            if ( gamePoss ) { // home possession
                                NSNumber *kStat2 = HomeKStats[1];
                                kStat2 = [NSNumber numberWithInteger:kStat2.integerValue + 1];
                                [HomeKStats replaceObjectAtIndex:1 withObject:kStat2];
                            } else {
                                NSNumber *kStat2 = AwayKStats[1];
                                kStat2 = [NSNumber numberWithInteger:kStat2.integerValue + 1];
                                [AwayKStats replaceObjectAtIndex:1 withObject:kStat2];
                            }
                        }
                        [offense getK:0].statsXPAtt++;
                    }
                } else {        // always go for 2pt in >3OT
                    //BOOL //successConversion = false;
                    if ( [HBSharedUtils randomValue] <= 0.50 ) {
                        //rushing
                        int blockAdv = [offense getCompositeOLRush] - [defense getCompositeF7Rush];
                        int yardsGain = (int) (([offense getRB:0].ratRushSpd + blockAdv) * [HBSharedUtils randomValue] / 6);
                        if ( yardsGain > 5 ) {
                            //successConversion = true;
                            if ( gamePoss ) { // home possession
                                homeScore += 2;
                            } else {
                                awayScore += 2;
                            }
                            [self addPointsQuarter:2];
                            [gameEventLog appendString:[NSString stringWithFormat:@"%@%@%@ rushed for the 2pt conversion.",[self getEventPrefix],tdInfo,[offense getRB:0].name]];
                        } else {
                            [gameEventLog appendString:[NSString stringWithFormat:@"%@%@%@ stopped at the line of scrimmage, failed the 2pt conversion.",[self getEventPrefix],tdInfo,[offense getRB:0].name]];
                        }
                    } else {
                        int pressureOnQB = ([defense getCompositeF7Pass]*2) - [offense getCompositeOLPass];
                        double completion = ([self normalize:[offense getQB:0].ratPassAcc] + [offense getWR:0].ratRecCat - [defense getCB:0].ratCBCov )/2 + 25 - pressureOnQB/20;
                        if ( 100*[HBSharedUtils randomValue] < completion ) {
                            //successConversion = true;
                            if ( gamePoss ) { // home possession
                                homeScore += 2;
                            } else {
                                awayScore += 2;
                            }
                            [self addPointsQuarter:2];
                            [gameEventLog appendString:[NSString stringWithFormat:@"%@%@2pt conversion is good! %@ completed the pass to %@ for the 2pt conversion.",[self getEventPrefix],tdInfo,[offense getQB:0].name, [offense getWR:0].name]];
                        } else {
                            [gameEventLog appendString:[NSString stringWithFormat:@"%@%@2pt conversion failed! %@'s pass incomplete to %@.",[self getEventPrefix],tdInfo,[offense getQB:0].name, [offense getWR:0].name]];
                        }
                    }
                }
            }
        } else {            // IF IN TOP FRAME OF OT, NORMALLY DO XP/2-PT EXCEPT IN 3OT+, WHERE 2PT IS REQUIRED
            if (numOT < 3) {
                if (((gamePoss && (awayScore -homeScore) == 2) || (!gamePoss && (homeScore -awayScore) == 2)) && gameTime < 300) {
                    //go for 2
                    //BOOL //successConversion = false;
                    if ( [HBSharedUtils randomValue] <= 0.50 ) {
                        //rushing
                        int blockAdv = [offense getCompositeOLRush] - [defense getCompositeF7Rush];
                        int yardsGain = (int) (([offense getRB:0].ratRushSpd + blockAdv) * [HBSharedUtils randomValue] / 6);
                        if ( yardsGain > 5 ) {
                            //successConversion = true;
                            if ( gamePoss ) { // home possession
                                homeScore += 2;
                            } else {
                                awayScore += 2;
                            }
                            [self addPointsQuarter:2];
                            [gameEventLog appendString:[NSString stringWithFormat:@"%@%@%@ rushed for the 2pt conversion.",[self getEventPrefix],tdInfo,[offense getRB:0].name]];
                        } else {
                            [gameEventLog appendString:[NSString stringWithFormat:@"%@%@%@ stopped at the line of scrimmage, failed the 2pt conversion.",[self getEventPrefix],tdInfo,[offense getRB:0].name]];
                        }
                    } else {
                        int pressureOnQB = ([defense getCompositeF7Pass]*2) - [offense getCompositeOLPass];
                        double completion = ([self normalize:[offense getQB:0].ratPassAcc] + [offense getWR:0].ratRecCat - [defense getCB:0].ratCBCov )/2 + 25 - pressureOnQB/20;
                        if ( 100*[HBSharedUtils randomValue] < completion ) {
                            //successConversion = true;
                            if ( gamePoss ) { // home possession
                                homeScore += 2;
                            } else {
                                awayScore += 2;
                            }
                            [self addPointsQuarter:2];
                            [gameEventLog appendString:[NSString stringWithFormat:@"%@%@2pt conversion is good! %@ completed the pass to %@ for the 2pt conversion.",[self getEventPrefix],tdInfo,[offense getQB:0].name, [offense getWR:0].name]];
                        } else {
                            [gameEventLog appendString:[NSString stringWithFormat:@"%@%@2pt conversion failed! %@'s pass incomplete to %@.",[self getEventPrefix],tdInfo,[offense getQB:0].name, [offense getWR:0].name]];
                        }
                    }
                } else {
                    //kick XP
                    if ( [HBSharedUtils randomValue]*100 < 23 + [offense getK:0].ratKickAcc && [HBSharedUtils randomValue] > 0.01 ) {
                        //made XP
                        if ( gamePoss ) { // home possession
                            homeScore += 1;
                            NSNumber *kStat1 = HomeKStats[0];
                            kStat1 = [NSNumber numberWithInteger:kStat1.integerValue + 1];
                            [HomeKStats replaceObjectAtIndex:0 withObject:kStat1];
                            
                            NSNumber *kStat2 = HomeKStats[1];
                            kStat2 = [NSNumber numberWithInteger:kStat2.integerValue + 1];
                            [HomeKStats replaceObjectAtIndex:1 withObject:kStat2];
                        } else {
                            awayScore += 1;
                            NSNumber *kStat1 = AwayKStats[0];
                            kStat1 = [NSNumber numberWithInteger:kStat1.integerValue + 1];
                            [AwayKStats replaceObjectAtIndex:0 withObject:kStat1];
                            
                            NSNumber *kStat2 = AwayKStats[1];
                            kStat2 = [NSNumber numberWithInteger:kStat2.integerValue + 1];
                            [AwayKStats replaceObjectAtIndex:1 withObject:kStat2];
                        }
                        
                        [gameEventLog appendString:[NSString stringWithFormat:@"%@%@%@ made the XP.",[self getEventPrefix],tdInfo,[offense getK:0].name]];
                        [self addPointsQuarter:1];
                        [offense getK:0].statsXPMade++;
                    } else {
                        [gameEventLog appendString:[NSString stringWithFormat:@"%@%@%@ missed the XP.",[self getEventPrefix],tdInfo,[offense getK:0].name]];
                        // missed XP
                        if ( gamePoss ) { // home possession
                            NSNumber *kStat2 = HomeKStats[1];
                            kStat2 = [NSNumber numberWithInteger:kStat2.integerValue + 1];
                            [HomeKStats replaceObjectAtIndex:1 withObject:kStat2];
                        } else {
                            NSNumber *kStat2 = AwayKStats[1];
                            kStat2 = [NSNumber numberWithInteger:kStat2.integerValue + 1];
                            [AwayKStats replaceObjectAtIndex:1 withObject:kStat2];
                        }
                    }
                    [offense getK:0].statsXPAtt++;
                }
            } else {        // always go for 2pt in >3OT
                //BOOL //successConversion = false;
                if ( [HBSharedUtils randomValue] <= 0.50 ) {
                    //rushing
                    int blockAdv = [offense getCompositeOLRush] - [defense getCompositeF7Rush];
                    int yardsGain = (int) (([offense getRB:0].ratRushSpd + blockAdv) * [HBSharedUtils randomValue] / 6);
                    if ( yardsGain > 5 ) {
                        //successConversion = true;
                        if ( gamePoss ) { // home possession
                            homeScore += 2;
                        } else {
                            awayScore += 2;
                        }
                        [self addPointsQuarter:2];
                        [gameEventLog appendString:[NSString stringWithFormat:@"%@%@%@ rushed for the 2pt conversion.",[self getEventPrefix],tdInfo,[offense getRB:0].name]];
                    } else {
                        [gameEventLog appendString:[NSString stringWithFormat:@"%@%@%@ stopped at the line of scrimmage, failed the 2pt conversion.",[self getEventPrefix],tdInfo,[offense getRB:0].name]];
                    }
                } else {
                    int pressureOnQB = ([defense getCompositeF7Pass]*2) - [offense getCompositeOLPass];
                    double completion = ([self normalize:[offense getQB:0].ratPassAcc] + [offense getWR:0].ratRecCat - [defense getCB:0].ratCBCov )/2 + 25 - pressureOnQB/20;
                    if ( 100*[HBSharedUtils randomValue] < completion ) {
                        //successConversion = true;
                        if ( gamePoss ) { // home possession
                            homeScore += 2;
                        } else {
                            awayScore += 2;
                        }
                        [self addPointsQuarter:2];
                        [gameEventLog appendString:[NSString stringWithFormat:@"%@%@2pt conversion is good! %@ completed the pass to %@ for the 2pt conversion.",[self getEventPrefix],tdInfo,[offense getQB:0].name, [offense getWR:0].name]];
                    } else {
                        [gameEventLog appendString:[NSString stringWithFormat:@"%@%@2pt conversion failed! %@'s pass incomplete to %@.",[self getEventPrefix],tdInfo,[offense getQB:0].name, [offense getWR:0].name]];
                    }
                }
            }
        }
    }
    
}

-(void)kickOff:(Team *)offense {
    if (gameTime > 0) {
        //Decide whether to onside kick. Only if losing but within 8 points with < 3 min to go
        if ( gameTime < 180 && ((gamePoss && (awayScore - homeScore) <= 8 && (awayScore - homeScore) > 0)
                                || (!gamePoss && (homeScore - awayScore) <=8 && (homeScore - awayScore) > 0))) {
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
    
    if ( gamePoss ) { // home possession
        NSNumber *qbSack = HomeQBStats[5];
        qbSack = [NSNumber numberWithInteger:qbSack.integerValue + 1];
        [HomeQBStats replaceObjectAtIndex:5 withObject:qbSack];
    } else {
        NSNumber *qbSack = AwayQBStats[5];
        qbSack = [NSNumber numberWithInteger:qbSack.integerValue + 1];
        [AwayQBStats replaceObjectAtIndex:5 withObject:qbSack];
    }
    
    if (gameYardLine < 0) {
        // Safety!
        gameTime -= (10 * [HBSharedUtils randomValue]);
        [self safety];
    }
    
    gameTime -=  (25 + (10 * [HBSharedUtils randomValue]));
    gameDown++;
}

-(void)safety {
    if (gamePoss) {
        awayScore += 2;
        [gameEventLog appendString:[NSString stringWithFormat:@"%@SAFETY!\n%@ QB %@ was tackled in the endzone! Result is a safety and %@ will get the ball.", [self getEventPrefix],homeTeam.abbreviation,[homeTeam getQB:0].name,awayTeam.abbreviation]];
        [self freeKick:homeTeam];
    } else {
        homeScore += 2;
        [gameEventLog appendString:[NSString stringWithFormat:@"%@SAFETY!\n%@ QB %@ was tackled in the endzone! Result is a safety and %@ will get the ball.", [self getEventPrefix],awayTeam.abbreviation,[awayTeam getQB:0].name,homeTeam.abbreviation]];
        [self freeKick:awayTeam];
    }
}

-(void)qbInterception:(Team *)offense {
    [offense getQB:0].statsPassAtt++;
    if ( gamePoss ) { // home possession
        NSNumber *qbInt = HomeQBStats[3];
        qbInt = [NSNumber numberWithInteger:qbInt.integerValue + 1];
        [HomeQBStats replaceObjectAtIndex:3 withObject:qbInt];
        
        NSNumber *qbStat = HomeQBStats[0];
        qbStat = [NSNumber numberWithInteger:qbStat.integerValue + 1];
        [HomeQBStats replaceObjectAtIndex:0 withObject:qbStat];
        homeTOs++;
    } else {
        NSNumber *qbInt = AwayQBStats[3];
        qbInt = [NSNumber numberWithInteger:qbInt.integerValue + 1];
        [AwayQBStats replaceObjectAtIndex:3 withObject:qbInt];
        
        NSNumber *qbStat = AwayQBStats[0];
        qbStat = [NSNumber numberWithInteger:qbStat.integerValue + 1];
        [AwayQBStats replaceObjectAtIndex:0 withObject:qbStat];
        awayTOs++;
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
        homeScore += 6;
        NSNumber *qbStat = HomeQBStats[2];
        qbStat = [NSNumber numberWithInteger:qbStat.integerValue + 1];
        [HomeQBStats replaceObjectAtIndex:2 withObject:qbStat];
        NSNumber *wrTarget = selWRStats[3];
        wrTarget = [NSNumber numberWithInteger:wrTarget.integerValue + 1];
        [selWRStats replaceObjectAtIndex:3 withObject:wrTarget];
    } else {
        awayScore += 6;
        NSNumber *qbStat = AwayQBStats[2];
        qbStat = [NSNumber numberWithInteger:qbStat.integerValue + 1];
        [AwayQBStats replaceObjectAtIndex:2 withObject:qbStat];
        NSNumber *wrTarget = selWRStats[3];
        wrTarget = [NSNumber numberWithInteger:wrTarget.integerValue + 1];
        [selWRStats replaceObjectAtIndex:3 withObject:wrTarget];
    }
    tdInfo = [NSString stringWithFormat:@"%@ QB %@ threw a %ld-yard TD to %@.\n",offense.abbreviation,[offense getQB:0].name,(long)yardsGained,selWR.name];
    [offense getQB:0].statsTD++;
    selWR.statsTD++;
}


-(void)passCompletion:(Team *)offense defense:(Team *)defense receiver:(PlayerWR *)selWR stats:(NSMutableArray *)selWRStats yardsGained:(int)yardsGained {
    [offense getQB:0].statsPassComp++;
    [offense getQB:0].statsPassAtt++;
    [offense getQB:0].statsPassYards += yardsGained;
    selWR.statsReceptions++;
    selWR.statsTargets++;
    selWR.statsRecYards += yardsGained;
    offense.teamPassYards += yardsGained;
    
    if ( gamePoss ) { // home possession
        homeYards += yardsGained;
        NSNumber *qbStatYd = HomeQBStats[4];
        qbStatYd = [NSNumber numberWithInteger:qbStatYd.integerValue + yardsGained];
        [HomeQBStats replaceObjectAtIndex:4 withObject:qbStatYd];
        
        NSNumber *qbComp = HomeQBStats[1];
        qbComp = [NSNumber numberWithInteger:qbComp.integerValue + 1];
        [HomeQBStats replaceObjectAtIndex:1 withObject:qbComp];
        
        NSNumber *qbStat = HomeQBStats[0];
        qbStat = [NSNumber numberWithInteger:qbStat.integerValue + 1];
        [HomeQBStats replaceObjectAtIndex:0 withObject:qbStat];
        
        NSNumber *wrTarget = selWRStats[0];
        wrTarget = [NSNumber numberWithInteger:wrTarget.integerValue + 1];
        [selWRStats replaceObjectAtIndex:0 withObject:wrTarget];
        
        NSNumber *wr2Yds = selWRStats[2];
        wr2Yds = [NSNumber numberWithInteger:wr2Yds.integerValue + yardsGained];
        [selWRStats replaceObjectAtIndex:2 withObject:wr2Yds];
    } else {
        awayYards += yardsGained;
        NSNumber *qbStatYd = AwayQBStats[4];
        qbStatYd = [NSNumber numberWithInteger:qbStatYd.integerValue + yardsGained];
        [AwayQBStats replaceObjectAtIndex:4 withObject:qbStatYd];
        
        NSNumber *qbStat = AwayQBStats[0];
        qbStat = [NSNumber numberWithInteger:qbStat.integerValue + 1];
        [AwayQBStats replaceObjectAtIndex:0 withObject:qbStat];
        
        NSNumber *qbComp = AwayQBStats[1];
        qbComp = [NSNumber numberWithInteger:qbComp.integerValue + 1];
        [AwayQBStats replaceObjectAtIndex:1 withObject:qbComp];
        
        NSNumber *wr2Yds = selWRStats[2];
        wr2Yds = [NSNumber numberWithInteger:wr2Yds.integerValue + yardsGained];
        [selWRStats replaceObjectAtIndex:2 withObject:wr2Yds];
        
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
        
        NSNumber *qbStat = HomeQBStats[0];
        qbStat = [NSNumber numberWithInteger:qbStat.integerValue + 1];
        [HomeQBStats replaceObjectAtIndex:0 withObject:qbStat];

        NSNumber *wrTarget = selWRStats[1];
        wrTarget = [NSNumber numberWithInteger:wrTarget.integerValue + 1];
        [selWRStats replaceObjectAtIndex:1 withObject:wrTarget];
       
    } else {
        
        NSNumber *qbStat = AwayQBStats[0];
        qbStat = [NSNumber numberWithInteger:qbStat.integerValue + 1];
        [AwayQBStats replaceObjectAtIndex:0 withObject:qbStat];
        
        
        
        NSNumber *wrTarget = selWRStats[1];
        wrTarget = [NSNumber numberWithInteger:wrTarget.integerValue + 1];
        [selWRStats replaceObjectAtIndex:1 withObject:wrTarget];
    }
}

-(void)rushAttemptQB:(Team *)offense defense:(Team *)defense rusher:(PlayerQB *)selQB yardsGained:(int)yardsGained {
    selQB.statsRushAtt++;
    selQB.statsRushYards += yardsGained;
    offense.teamRushYards += yardsGained;
    
    if ( gamePoss ) { // home possession
        NSNumber *qbStat = HomeQBStats[6];
        qbStat = [NSNumber numberWithInteger:qbStat.integerValue + 1];
        [HomeQBStats replaceObjectAtIndex:6 withObject:qbStat];
        
        NSNumber *rb2Att = HomeQBStats[7];
        rb2Att = [NSNumber numberWithInteger:rb2Att.integerValue + yardsGained];
        [HomeQBStats replaceObjectAtIndex:7 withObject:rb2Att];
    } else {
        NSNumber *qbStat = AwayQBStats[6];
        qbStat = [NSNumber numberWithInteger:qbStat.integerValue + 1];
        [AwayQBStats replaceObjectAtIndex:6 withObject:qbStat];
        
        NSNumber *rb2Att = AwayQBStats[7];
        rb2Att = [NSNumber numberWithInteger:rb2Att.integerValue + yardsGained];
        [AwayQBStats replaceObjectAtIndex:7 withObject:rb2Att];
    }
}

-(void)rushAttempt:(Team *)offense defense:(Team *)defense rusher:(PlayerRB *)selRB rb1Pref:(double)rb1Pref rb2Pref:(double)rb2Pref yardsGained:(int)yardsGained {
    selRB.statsRushAtt++;
    selRB.statsRushYards += yardsGained;
    offense.teamRushYards += yardsGained;
    
    if ( gamePoss ) { // home possession
        homeYards += yardsGained;
        if (rb1Pref > rb2Pref) {
            NSNumber *rb1 = HomeRB1Stats[0];
            rb1 = [NSNumber numberWithInteger:rb1.integerValue + 1];
            [HomeRB1Stats replaceObjectAtIndex:0 withObject:rb1];
            
            NSNumber *rb1Att = HomeRB1Stats[1];
            rb1Att = [NSNumber numberWithInteger:rb1Att.integerValue + yardsGained];
            [HomeRB1Stats replaceObjectAtIndex:1 withObject:rb1Att];
            
        } else {
            NSNumber *rb2 = HomeRB2Stats[0];
            rb2 = [NSNumber numberWithInteger:rb2.integerValue + 1];
            [HomeRB2Stats replaceObjectAtIndex:0 withObject:rb2];
            
            NSNumber *rb2Att = HomeRB2Stats[1];
            rb2Att = [NSNumber numberWithInteger:rb2Att.integerValue + yardsGained];
            [HomeRB2Stats replaceObjectAtIndex:1 withObject:rb2Att];
        }
    } else {
        awayYards += yardsGained;
        if (rb1Pref > rb2Pref) {
            NSNumber *rb1 = AwayRB1Stats[0];
            rb1 = [NSNumber numberWithInteger:rb1.integerValue + 1];
            [AwayRB1Stats replaceObjectAtIndex:0 withObject:rb1];
            
            NSNumber *rb1Att = AwayRB1Stats[1];
            rb1Att = [NSNumber numberWithInteger:rb1Att.integerValue + yardsGained];
            [AwayRB1Stats replaceObjectAtIndex:1 withObject:rb1Att];
        } else {
            NSNumber *rb2 = AwayRB2Stats[0];
            rb2 = [NSNumber numberWithInteger:rb2.integerValue + 1];
            [AwayRB2Stats replaceObjectAtIndex:0 withObject:rb2];
            
            NSNumber *rb2Att = AwayRB2Stats[1];
            rb2Att = [NSNumber numberWithInteger:rb2Att.integerValue + yardsGained];
            [AwayRB2Stats replaceObjectAtIndex:1 withObject:rb2Att];
        }
    }
}

-(void)freeKick:(Team*)offense {
    if (gameTime > 0) {
        if ( gameTime < 180 && ((gamePoss && (awayScore - homeScore) <= 8 && (awayScore - homeScore) > 0)
                                || (!gamePoss && (homeScore - awayScore) <=8 && (homeScore - awayScore) > 0))) {
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
        } else if ( numOT == 0 ) {
            index = 3;
        } else {
            if ( 3+numOT < 10 ){
                index = 3 + numOT;
            } else {
                index = 9;
            }
        }
        
        NSNumber *quarter = homeQScore[index];
        quarter = [NSNumber numberWithInt:quarter.intValue + points];
        [homeQScore replaceObjectAtIndex:index withObject:quarter];
    } else {
        //away
        int index = 0;
        if ( gameTime > 2700 ) {
            index = 0;
        } else if ( gameTime > 1800 ) {
            index = 1;
        } else if ( gameTime > 900 ) {
            index = 2;
        } else if ( numOT == 0 ) {
            index = 3;
        } else {
            if ( 3+numOT < 10 ){
                index = 3 + numOT;
            } else {
                index = 9;
            }
        }
        NSNumber *quarter = awayQScore[index];
        quarter = [NSNumber numberWithInt:quarter.intValue + points];
        [awayQScore replaceObjectAtIndex:index withObject:quarter];
    }
}

-(int)normalize:(int)rating {
    return (100 + rating)/2;
}

@end
