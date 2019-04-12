//
//  Game.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/16/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//
//  Seconds per play based on Tempo stats: https://www.cfbanalytics.com/2018-tempo
//  ^ generates plays/gm in range of about [57, 82]
//  Yards per game: aiming for range here https://www.teamrankings.com/college-football/stat/yards-per-game


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
@synthesize AwayKStats,AwayQBStats,AwayRB1Stats,AwayRB2Stats,AwayWR1Stats,AwayWR2Stats,AwayWR3Stats,awayTOs,awayTeam,awayScore,awayYards,awayQScore,awayStarters,gameName,homeTeam,hasPlayed,homeYards,HomeKStats,superclass,HomeQBStats,HomeRB1Stats,HomeRB2Stats,homeStarters,HomeWR1Stats,HomeWR2Stats,HomeWR3Stats,homeScore,homeQScore,homeTOs,numOT,AwayTEStats,HomeTEStats, gameEventLog,HomeSStats,HomeCB1Stats,HomeCB2Stats,HomeCB3Stats,HomeDL1Stats,HomeDL2Stats,HomeDL3Stats,HomeDL4Stats,HomeLB1Stats,HomeLB2Stats,HomeLB3Stats,AwaySStats,AwayCB1Stats,AwayCB2Stats,AwayCB3Stats,AwayDL1Stats,AwayDL2Stats,AwayDL3Stats,AwayDL4Stats,AwayLB1Stats,AwayLB2Stats,AwayLB3Stats;

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
    
    [aCoder encodeObject:self.HomeDL1Stats forKey:@"HomeDL1Stats"];
    [aCoder encodeObject:self.HomeDL2Stats forKey:@"HomeDL2Stats"];
    [aCoder encodeObject:self.HomeDL3Stats forKey:@"HomeDL3Stats"];
    [aCoder encodeObject:self.HomeDL4Stats forKey:@"HomeDL4Stats"];
    
    [aCoder encodeObject:self.HomeLB1Stats forKey:@"HomeLB1Stats"];
    [aCoder encodeObject:self.HomeLB2Stats forKey:@"HomeLB2Stats"];
    [aCoder encodeObject:self.HomeLB3Stats forKey:@"HomeLB3Stats"];
    
    [aCoder encodeObject:self.HomeCB1Stats forKey:@"HomeCB1Stats"];
    [aCoder encodeObject:self.HomeCB2Stats forKey:@"HomeCB2Stats"];
    [aCoder encodeObject:self.HomeCB3Stats forKey:@"HomeCB3Stats"];
    
    [aCoder encodeObject:self.HomeSStats forKey:@"HomeSStats"];

    [aCoder encodeObject:self.AwayQBStats forKey:@"AwayQBStats"];

    [aCoder encodeObject:self.AwayRB1Stats forKey:@"AwayRB1Stats"];
    [aCoder encodeObject:self.AwayRB2Stats forKey:@"AwayRB2Stats"];

    [aCoder encodeObject:self.AwayWR1Stats forKey:@"AwayWR1Stats"];
    [aCoder encodeObject:self.AwayWR2Stats forKey:@"AwayWR2Stats"];
    [aCoder encodeObject:self.AwayWR3Stats forKey:@"AwayWR3Stats"];
    [aCoder encodeObject:self.AwayKStats forKey:@"AwayKStats"];
    
    [aCoder encodeObject:self.AwayDL1Stats forKey:@"AwayDL1Stats"];
    [aCoder encodeObject:self.AwayDL2Stats forKey:@"AwayDL2Stats"];
    [aCoder encodeObject:self.AwayDL3Stats forKey:@"AwayDL3Stats"];
    [aCoder encodeObject:self.AwayDL4Stats forKey:@"AwayDL4Stats"];
    
    [aCoder encodeObject:self.AwayLB1Stats forKey:@"AwayLB1Stats"];
    [aCoder encodeObject:self.AwayLB2Stats forKey:@"AwayLB2Stats"];
    [aCoder encodeObject:self.AwayLB3Stats forKey:@"AwayLB3Stats"];
    
    [aCoder encodeObject:self.AwayCB1Stats forKey:@"AwayCB1Stats"];
    [aCoder encodeObject:self.AwayCB2Stats forKey:@"AwayCB2Stats"];
    [aCoder encodeObject:self.AwayCB3Stats forKey:@"AwayCB3Stats"];
    
    [aCoder encodeObject:self.AwaySStats forKey:@"AwaySStats"];
    
    @synchronized(self.homeTeam) {
        [aCoder encodeObject:self.homeTeam forKey:@"homeTeam"];
    }
    
    @synchronized(self.awayTeam) {
        [aCoder encodeObject:self.awayTeam forKey:@"awayTeam"];
    }

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
        gameYardLine = [aDecoder decodeIntForKey:@"gameYardLine"];

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
        
        // defensive stats
        if ([aDecoder containsValueForKey:@"HomeDL1Stats"]) {
            self.HomeDL1Stats = [aDecoder decodeObjectForKey:@"HomeDL1Stats"];
        } else {
            self.HomeDL1Stats = [NSMutableArray arrayWithObjects:@0,@0,@0,@0,@0, nil];
        }
        
        if ([aDecoder containsValueForKey:@"AwayDL1Stats"]) {
            self.AwayDL1Stats = [aDecoder decodeObjectForKey:@"AwayDL1Stats"];
        } else {
            self.AwayDL1Stats = [NSMutableArray arrayWithObjects:@0,@0,@0,@0,@0, nil];
        }
        
        if ([aDecoder containsValueForKey:@"HomeDL2Stats"]) {
            self.HomeDL2Stats = [aDecoder decodeObjectForKey:@"HomeDL2Stats"];
        } else {
            self.HomeDL2Stats = [NSMutableArray arrayWithObjects:@0,@0,@0,@0,@0, nil];
        }
        
        if ([aDecoder containsValueForKey:@"AwayDL2Stats"]) {
            self.AwayDL2Stats = [aDecoder decodeObjectForKey:@"AwayDL2Stats"];
        } else {
            self.AwayDL2Stats = [NSMutableArray arrayWithObjects:@0,@0,@0,@0,@0, nil];
        }
        
        if ([aDecoder containsValueForKey:@"HomeDL3Stats"]) {
            self.HomeDL3Stats = [aDecoder decodeObjectForKey:@"HomeDL3Stats"];
        } else {
            self.HomeDL3Stats = [NSMutableArray arrayWithObjects:@0,@0,@0,@0,@0, nil];
        }
        
        if ([aDecoder containsValueForKey:@"AwayDL3Stats"]) {
            self.AwayDL3Stats = [aDecoder decodeObjectForKey:@"AwayDL3Stats"];
        } else {
            self.AwayDL3Stats = [NSMutableArray arrayWithObjects:@0,@0,@0,@0,@0, nil];
        }
        
        if ([aDecoder containsValueForKey:@"HomeDL4Stats"]) {
            self.HomeDL4Stats = [aDecoder decodeObjectForKey:@"HomeDL4Stats"];
        } else {
            self.HomeDL4Stats = [NSMutableArray arrayWithObjects:@0,@0,@0,@0,@0, nil];
        }
        
        if ([aDecoder containsValueForKey:@"AwayDL4Stats"]) {
            self.AwayDL4Stats = [aDecoder decodeObjectForKey:@"AwayDL4Stats"];
        } else {
            self.AwayDL4Stats = [NSMutableArray arrayWithObjects:@0,@0,@0,@0,@0, nil];
        }
        
        if ([aDecoder containsValueForKey:@"HomeLB1Stats"]) {
            self.HomeLB1Stats = [aDecoder decodeObjectForKey:@"HomeLB1Stats"];
        } else {
            self.HomeLB1Stats = [NSMutableArray arrayWithObjects:@0,@0,@0,@0,@0, nil];
        }
        
        if ([aDecoder containsValueForKey:@"AwayLB1Stats"]) {
            self.AwayLB1Stats = [aDecoder decodeObjectForKey:@"AwayLB1Stats"];
        } else {
            self.AwayLB1Stats = [NSMutableArray arrayWithObjects:@0,@0,@0,@0,@0, nil];
        }
        
        if ([aDecoder containsValueForKey:@"HomeLB2Stats"]) {
            self.HomeLB2Stats = [aDecoder decodeObjectForKey:@"HomeLB2Stats"];
        } else {
            self.HomeLB2Stats = [NSMutableArray arrayWithObjects:@0,@0,@0,@0,@0, nil];
        }
        
        if ([aDecoder containsValueForKey:@"AwayLB2Stats"]) {
            self.AwayLB2Stats = [aDecoder decodeObjectForKey:@"AwayLB2Stats"];
        } else {
            self.AwayLB2Stats = [NSMutableArray arrayWithObjects:@0,@0,@0,@0,@0, nil];
        }
        
        if ([aDecoder containsValueForKey:@"HomeLB3Stats"]) {
            self.HomeLB3Stats = [aDecoder decodeObjectForKey:@"HomeLB3Stats"];
        } else {
            self.HomeLB3Stats = [NSMutableArray arrayWithObjects:@0,@0,@0,@0,@0, nil];
        }
        
        if ([aDecoder containsValueForKey:@"AwayLB3Stats"]) {
            self.AwayLB3Stats = [aDecoder decodeObjectForKey:@"AwayLB3Stats"];
        } else {
            self.AwayLB3Stats = [NSMutableArray arrayWithObjects:@0,@0,@0,@0,@0, nil];
        }
        
        if ([aDecoder containsValueForKey:@"HomeCB1Stats"]) {
            self.HomeCB1Stats = [aDecoder decodeObjectForKey:@"HomeCB1Stats"];
        } else {
            self.HomeCB1Stats = [NSMutableArray arrayWithObjects:@0,@0,@0,@0,@0, nil];
        }
        
        if ([aDecoder containsValueForKey:@"AwayCB1Stats"]) {
            self.AwayCB1Stats = [aDecoder decodeObjectForKey:@"AwayCB1Stats"];
        } else {
            self.AwayCB1Stats = [NSMutableArray arrayWithObjects:@0,@0,@0,@0,@0, nil];
        }
        
        if ([aDecoder containsValueForKey:@"HomeCB2Stats"]) {
            self.HomeCB2Stats = [aDecoder decodeObjectForKey:@"HomeCB2Stats"];
        } else {
            self.HomeCB2Stats = [NSMutableArray arrayWithObjects:@0,@0,@0,@0,@0, nil];
        }
        
        if ([aDecoder containsValueForKey:@"AwayCB2Stats"]) {
            self.AwayCB2Stats = [aDecoder decodeObjectForKey:@"AwayCB2Stats"];
        } else {
            self.AwayCB2Stats = [NSMutableArray arrayWithObjects:@0,@0,@0,@0,@0, nil];
        }
        
        if ([aDecoder containsValueForKey:@"HomeCB3Stats"]) {
            self.HomeCB3Stats = [aDecoder decodeObjectForKey:@"HomeCB3Stats"];
        } else {
            self.HomeCB3Stats = [NSMutableArray arrayWithObjects:@0,@0,@0,@0,@0, nil];
        }
        
        if ([aDecoder containsValueForKey:@"AwayCB3Stats"]) {
            self.AwayCB3Stats = [aDecoder decodeObjectForKey:@"AwayCB3Stats"];
        } else {
            self.AwayCB3Stats = [NSMutableArray arrayWithObjects:@0,@0,@0,@0,@0, nil];
        }
        
        if ([aDecoder containsValueForKey:@"HomeSStats"]) {
            self.HomeSStats = [aDecoder decodeObjectForKey:@"HomeSStats"];
        } else {
            self.HomeSStats = [NSMutableArray arrayWithObjects:@0,@0,@0,@0,@0, nil];
        }
        
        if ([aDecoder containsValueForKey:@"AwaySStats"]) {
            self.AwaySStats = [aDecoder decodeObjectForKey:@"AwaySStats"];
        } else {
            self.AwaySStats = [NSMutableArray arrayWithObjects:@0,@0,@0,@0,@0, nil];
        }
        
    }
    return self;
}

-(int)calculateSecondsPerPlay:(TeamStrategy *)strat {
    // Team Archetypes based on stats here: https://www.cfbanalytics.com/2018-tempo
    if ([strat.stratName isEqualToString:@"Balanced"] || [strat.stratName isEqualToString:@"West Coast"]) {
        // Archetype: NC State / Pro-style - https://www.footballoutsiders.com/stats/pacestats
        return (25 + (5 * [HBSharedUtils randomValue]));
    } else if ([strat.stratName isEqualToString:@"Smashmouth"]) {
        // Archetype: Wisconsin - 28.0373831776 sec/play
        return (27 + (2 * [HBSharedUtils randomValue]));
    } else if ([strat.stratName isEqualToString:@"Spread"]) {
        // Archetype: West Virginia - 24.0 sec/play
        return (22 + (3 * [HBSharedUtils randomValue]));
    } else if ([strat.stratName isEqualToString:@"Read Option"]) {
        // Archetype: Georgia Tech - 29.8507462687 sec/play
        return (28 + (3 * [HBSharedUtils randomValue]));
    } else if ([strat.stratName isEqualToString:@"Run-Pass Option"]) {
        // Archetype: Auburn - 24.3902439024 sec/play
        return (20 + (5 * [HBSharedUtils randomValue]));
    }
    
    // old time scale
    return (15 * [HBSharedUtils randomValue]);
}

+(instancetype)newGameWithHome:(Team*)home away:(Team*)away {
    return [[Game alloc] initWithHome:home away:away name:nil];
}

+(instancetype)newGameWithHome:(Team*)home away:(Team*)away name:(NSString*)name {
    return [[Game alloc] initWithHome:home away:away name:name];
}

-(instancetype)initWithHome:(Team*)home away:(Team*)away name:(NSString*)name {
    self = [super init];
    if (self) {
        homeTeam = home;
        awayTeam = away;
        
        if (name != nil) {
            gameName = name;
        }
        
        homeScore = 0;
        homeQScore = [NSMutableArray array];
        awayScore = 0;
        awayQScore = [NSMutableArray array];
        numOT = 0;
        
        homeTOs = 0;
        awayTOs = 0;
        
        gameEventLog = [NSMutableString stringWithFormat:@"#%ld %@ (%ld-%ld) @ #%ld %@ (%ld-%ld)\n%@\n---------------------------------------------------------",(long)awayTeam.rankTeamPollScore,awayTeam.abbreviation,(long)awayTeam.wins,(long)awayTeam.losses,(long)homeTeam.rankTeamPollScore,homeTeam.abbreviation,(long)homeTeam.wins,(long)homeTeam.losses,gameName];
        
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
        
        HomeCB1Stats = [NSMutableArray array];
        HomeCB2Stats = [NSMutableArray array];
        HomeCB3Stats = [NSMutableArray array];
        AwayCB1Stats = [NSMutableArray array];
        AwayCB2Stats = [NSMutableArray array];
        AwayCB3Stats = [NSMutableArray array];
        
        HomeLB1Stats = [NSMutableArray array];
        HomeLB2Stats = [NSMutableArray array];
        HomeLB3Stats = [NSMutableArray array];
        AwayLB1Stats = [NSMutableArray array];
        AwayLB2Stats = [NSMutableArray array];
        AwayLB3Stats = [NSMutableArray array];
        
        HomeDL1Stats = [NSMutableArray array];
        HomeDL2Stats = [NSMutableArray array];
        HomeDL3Stats = [NSMutableArray array];
        HomeDL4Stats = [NSMutableArray array];
        AwayDL1Stats = [NSMutableArray array];
        AwayDL2Stats = [NSMutableArray array];
        AwayDL3Stats = [NSMutableArray array];
        AwayDL4Stats = [NSMutableArray array];
        
        HomeKStats = [NSMutableArray array];
        AwayKStats = [NSMutableArray array];
        
        HomeSStats = [NSMutableArray array];
        AwaySStats = [NSMutableArray array];
        
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
        
        for (int i = 0; i < 5; i++) {
            [HomeDL1Stats addObject:@(0)];
            [AwayDL1Stats addObject:@(0)];
            
            [HomeDL2Stats addObject:@(0)];
            [AwayDL2Stats addObject:@(0)];
            
            [HomeDL3Stats addObject:@(0)];
            [AwayDL3Stats addObject:@(0)];
            
            [HomeDL4Stats addObject:@(0)];
            [AwayDL4Stats addObject:@(0)];
            
            [HomeLB1Stats addObject:@(0)];
            [AwayLB1Stats addObject:@(0)];
            
            [HomeLB2Stats addObject:@(0)];
            [AwayLB2Stats addObject:@(0)];
            
            [HomeLB3Stats addObject:@(0)];
            [AwayLB3Stats addObject:@(0)];
            
            [HomeCB1Stats addObject:@(0)];
            [AwayCB1Stats addObject:@(0)];
            
            [HomeCB2Stats addObject:@(0)];
            [AwayCB2Stats addObject:@(0)];
            
            [HomeCB3Stats addObject:@(0)];
            [AwayCB3Stats addObject:@(0)];
            
            [HomeSStats addObject:@(0)];
            [AwaySStats addObject:@(0)];
        }
        
        hasPlayed = false;
        
        if (gameName != nil && [gameName isEqualToString:@"In Conf"] && ([homeTeam.rivalTeam isEqualToString:awayTeam.abbreviation] || [awayTeam.rivalTeam isEqualToString:homeTeam.abbreviation])) {
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
        
        //DLs
        NSMutableDictionary *DLs = [NSMutableDictionary dictionary];
        
        [DLs setObject:homeStarters[20] forKey:@"homeDL1"];
        [DLs setObject:HomeDL1Stats forKey:@"homeDL1Stats"];
        
        [DLs setObject:homeStarters[21] forKey:@"homeDL2"];
        [DLs setObject:HomeDL2Stats forKey:@"homeDL2Stats"];
        
        [DLs setObject:homeStarters[22] forKey:@"homeDL3"];
        [DLs setObject:HomeDL3Stats forKey:@"homeDL3Stats"];
        
        if (homeStarters.count < 24) {
            [DLs setObject:[homeTeam getDL:3] forKey:@"homeDL4"];
        } else {
            [DLs setObject:homeStarters[23] forKey:@"homeDL4"];
        }
        [DLs setObject:HomeDL4Stats forKey:@"homeDL4Stats"];
        
        [DLs setObject:awayStarters[20] forKey:@"awayDL1"];
        [DLs setObject:AwayDL1Stats forKey:@"awayDL1Stats"];
        
        [DLs setObject:awayStarters[21] forKey:@"awayDL2"];
        [DLs setObject:AwayDL2Stats forKey:@"awayDL2Stats"];
        
        [DLs setObject:awayStarters[22] forKey:@"awayDL3"];
        [DLs setObject:AwayDL3Stats forKey:@"awayDL3Stats"];
        
        if (awayStarters.count < 24) {
            [DLs setObject:[awayTeam getDL:3] forKey:@"awayDL4"];
        } else {
            [DLs setObject:awayStarters[23] forKey:@"awayDL4"];
        }
        [DLs setObject:AwayDL4Stats forKey:@"awayDL4Stats"];
        
        [report setObject:DLs forKey:@"DLs"];
        
        
        //LBs
        NSMutableDictionary *lbs = [NSMutableDictionary dictionary];
        
        [lbs setObject:homeStarters[17] forKey:@"homeLB1"];
        [lbs setObject:HomeLB1Stats forKey:@"homeLB1Stats"];
        
        [lbs setObject:homeStarters[18] forKey:@"homeLB2"];
        [lbs setObject:HomeLB2Stats forKey:@"homeLB2Stats"];
        
        [lbs setObject:homeStarters[19] forKey:@"homeLB3"];
        [lbs setObject:HomeLB3Stats forKey:@"homeLB3Stats"];
        
        [lbs setObject:awayStarters[17] forKey:@"awayLB1"];
        [lbs setObject:AwayLB1Stats forKey:@"awayLB1Stats"];
        
        [lbs setObject:awayStarters[18] forKey:@"awayLB2"];
        [lbs setObject:AwayLB2Stats forKey:@"awayLB2Stats"];
        
        [lbs setObject:awayStarters[19] forKey:@"awayLB3"];
        [lbs setObject:AwayLB3Stats forKey:@"awayLB3Stats"];
        
        [report setObject:lbs forKey:@"LBs"];
        
        //CBs
        NSMutableDictionary *cbs = [NSMutableDictionary dictionary];
        
        [cbs setObject:homeStarters[14] forKey:@"homeCB1"];
        [cbs setObject:HomeCB1Stats forKey:@"homeCB1Stats"];
        
        [cbs setObject:homeStarters[15] forKey:@"homeCB2"];
        [cbs setObject:HomeCB2Stats forKey:@"homeCB2Stats"];
        
        [cbs setObject:homeStarters[16] forKey:@"homeCB3"];
        [cbs setObject:HomeCB3Stats forKey:@"homeCB3Stats"];
        
        [cbs setObject:awayStarters[14] forKey:@"awayCB1"];
        [cbs setObject:AwayCB1Stats forKey:@"awayCB1Stats"];
        
        [cbs setObject:awayStarters[15] forKey:@"awayCB2"];
        [cbs setObject:AwayCB2Stats forKey:@"awayCB2Stats"];
        
        [cbs setObject:awayStarters[16] forKey:@"awayCB3"];
        [cbs setObject:AwayCB3Stats forKey:@"awayCB3Stats"];
        
        [report setObject:cbs forKey:@"CBs"];
        
        //Ss
        NSMutableDictionary *ss = [NSMutableDictionary dictionary];
        [ss setObject:homeStarters[13] forKey:@"homeS"];
        [ss setObject:HomeSStats forKey:@"homeSStats"];
        
        [ss setObject:awayStarters[13] forKey:@"awayS"];
        [ss setObject:AwaySStats forKey:@"awaySStats"];
        [report setObject:ss forKey:@"Ss"];
        
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
        
        if ([HBSharedUtils currentLeague].currentWeek > 0) {
            appg = (int)ceil((double)awayTeam.teamPoints / (double)([HBSharedUtils currentLeague].currentWeek));
            hppg = (int)ceil((double)homeTeam.teamPoints / (double)([HBSharedUtils currentLeague].currentWeek));
            
            aoppg = (int)ceil((double)awayTeam.teamOppPoints / (double)([HBSharedUtils currentLeague].currentWeek));
            hoppg = (int)ceil((double)homeTeam.teamOppPoints / (double)([HBSharedUtils currentLeague].currentWeek));
            
            aypg = (int)ceil((double)awayTeam.teamYards / (double)([HBSharedUtils currentLeague].currentWeek));
            hypg = (int)ceil((double)homeTeam.teamYards / (double)([HBSharedUtils currentLeague].currentWeek));
            
            aoypg = (int)ceil((double)awayTeam.teamOppYards / (double)([HBSharedUtils currentLeague].currentWeek));
            hoypg = (int)ceil((double)homeTeam.teamOppYards / (double)([HBSharedUtils currentLeague].currentWeek));
            
            apypg = (int)ceil((double)awayTeam.teamPassYards / (double)([HBSharedUtils currentLeague].currentWeek));
            hpypg = (int)ceil((double)homeTeam.teamPassYards / (double)([HBSharedUtils currentLeague].currentWeek));
            
            arypg = (int)ceil((double)awayTeam.teamRushYards / (double)([HBSharedUtils currentLeague].currentWeek));
            hrypg = (int)ceil((double)homeTeam.teamRushYards / (double)([HBSharedUtils currentLeague].currentWeek));
            
            aopypg = (int)ceil((double)awayTeam.teamOppPassYards / (double)([HBSharedUtils currentLeague].currentWeek));
            hopypg = (int)ceil((double)homeTeam.teamOppPassYards / (double)([HBSharedUtils currentLeague].currentWeek));
            
            aorypg = (int)ceil((double)awayTeam.teamOppRushYards / (double)([HBSharedUtils currentLeague].currentWeek));
            horypg = (int)ceil((double)homeTeam.teamOppRushYards / (double)([HBSharedUtils currentLeague].currentWeek));
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
        NSNumber *qbYd = HomeQBStats[FCQBStatPassYards];
        return qbYd.intValue;
    } else {
        NSNumber *qbYd = AwayQBStats[FCQBStatPassYards];
        return qbYd.intValue;
    }
}

-(int)getRushYards:(BOOL)ha {
    if (!ha) {
        NSNumber *rb1Yd = HomeRB1Stats[FCRBStatRushYards];
        NSNumber *rb2Yd = HomeRB2Stats[FCRBStatRushYards];
        NSNumber *qbYd = HomeQBStats[FCQBStatRushYards];
        return rb1Yd.intValue + rb2Yd.intValue + qbYd.intValue;
    } else {
        NSNumber *rb1Yd = AwayRB1Stats[FCRBStatRushYards];
        NSNumber *rb2Yd = AwayRB2Stats[FCRBStatRushYards];
        NSNumber *qbYd = AwayQBStats[FCQBStatRushYards];
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

-(NSString *)getEventPrefix {
    return  [self getEventPrefix:0];
}

-(NSString*)getEventPrefix:(int)yardsGained {
    NSString *possStr;
    NSString *defStr;
    if ( gamePoss ) {
        possStr = homeTeam.abbreviation;
        defStr = awayTeam.abbreviation;
    } else {
        possStr = awayTeam.abbreviation;
        defStr = homeTeam.abbreviation;
    }
    
    NSString *yardsNeedAdj = [NSString stringWithFormat:@"%ld",(long)(gameYardsNeed)];
    int gameDownAdj = gameDown;
    if (gameDownAdj > 4) {
        gameDownAdj = 4;
    } else {
        gameDownAdj = gameDownAdj; // needed adjustment bc we are displaying these after the play.
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
    int adjYardLine = gameYardLine;// - yardsGained; // needed adjustment bc we are displaying these after the play.
    if (adjYardLine > 50) {
        ydLineStr = [NSString stringWithFormat:@"%@ %ld", defStr, (long)(100 - adjYardLine)];
    }
//    else if (gameYardLine == 50) {
//        ydLineStr = @"50-yard line";
//    }
    else {
        ydLineStr = [NSString stringWithFormat:@"%@ %ld", possStr, (long)adjYardLine];
    }
    
    if ((adjYardLine + yardsGained) >= 100) yardsNeedAdj = @"Goal";
    //return [NSString stringWithFormat:@"\n\n%@ %ld - %ld %@, Time: %@\n%@ %@ and %@ at the %@.\n",awayTeam.abbreviation,(long)awayScore,(long)homeScore,homeTeam.abbreviation, [self convGameTime],possStr,downString,yardsNeedAdj,ydLineStr];
    if (!playingOT) {
        return [NSString stringWithFormat:@"\n\n%@ | %@ & %@ | %@ | (%@) ", ydLineStr, downString, yardsNeedAdj, [self convGameQuarter], [self convGameTimeMinute]];
    } else {
        return [NSString stringWithFormat:@"\n\n%@ | %@ & %@ | %@ | ", ydLineStr, downString, yardsNeedAdj, [self convGameQuarter]];
    }
}

-(NSString *)convGameQuarter {
    if (gameTime <= 0 && !playingOT) {
        return @"Q4";
    }
    
    if (!playingOT) {
        int qNum = (3600 - gameTime) / 900 + 1;
        if ( qNum >= 4 && numOT > 0 ) {
            return [NSString stringWithFormat:@"OT%ld",(long)numOT];
        } else {
            return [NSString stringWithFormat:@"Q%ld",(long)qNum];
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

-(NSString *)convGameTimeMinute {
    if (gameTime <= 0 && !playingOT) {
        return @"0:00";
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
            return [NSString stringWithFormat:@"%ld:%@",(long)minTime,secStr];
        } else {
            minTime = (gameTime - 900*(4-qNum)) / 60;
            secTime = (gameTime - 900*(4-qNum)) - 60*minTime;
            if (secTime < 10) {
                [secStr appendString:[NSString stringWithFormat:@"0%ld", (long)secTime]];
            } else {
                [secStr appendString:[NSString stringWithFormat:@"%ld", (long)secTime]];
            }
            return [NSString stringWithFormat:@"%ld:%@",(long)minTime,secStr];
        }
        
    } else {
        return @"";
    }
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

-(int)calculatePlayerPreferenceForPlayer:(Player *)p inGameSituation:(FCGameSituation)situation relatedPlayer:(nonnull Player*)relatedPlayer yardsGained:(int)yardsGain {
    return [self calculatePlayerPreferenceForPlayer:p inGameSituation:situation relatedPlayer:relatedPlayer yardsGained:yardsGain gotTD:NO];
}

-(int)calculatePlayerPreferenceForPlayer:(Player *)p inGameSituation:(FCGameSituation)situation relatedPlayer:(nonnull Player*)relatedPlayer yardsGained:(int)yardsGain gotTD:(BOOL)gotTD {
    if (situation == FCGameSituationPassCompletion) {
        if ([relatedPlayer.position isEqualToString:@"WR"]) {
            if ([p.position isEqualToString:@"CB"]) {
                return ((PlayerCB *)p).ratCBCov * [HBSharedUtils randomValue] * 100;
            } else if ([p.position isEqualToString:@"S"]) {
                return ((PlayerS *)p).ratSCov * [HBSharedUtils randomValue] * 60;
            } else if ([p.position isEqualToString:@"LB"]) {
                return ((PlayerLB *)p).ratLBPas * [HBSharedUtils randomValue] * 40;
            } else if ([p.position isEqualToString:@"DL"]) {
                return ((PlayerDL *)p).ratDLPas * [HBSharedUtils randomValue] * 10;
            } else {
                return 0;
            }
        } else if ([relatedPlayer.position isEqualToString:@"TE"]) {
            if ([p.position isEqualToString:@"CB"]) {
                return ((PlayerCB *)p).ratCBCov * [HBSharedUtils randomValue] * 40;
            } else if ([p.position isEqualToString:@"S"]) {
                return ((PlayerS *)p).ratSCov * [HBSharedUtils randomValue] * 60;
            } else if ([p.position isEqualToString:@"LB"]) {
                return ((PlayerLB *)p).ratLBPas * [HBSharedUtils randomValue] * 80;
            } else if ([p.position isEqualToString:@"DL"]) {
                return ((PlayerDL *)p).ratDLPas * [HBSharedUtils randomValue] * 10;
            } else {
                return 0;
            }
        } else {
            if ([relatedPlayer.position isEqualToString:@"WR"]) {
                if ([p.position isEqualToString:@"CB"]) {
                    return ((PlayerCB *)p).ratCBCov * [HBSharedUtils randomValue] * 30;
                } else if ([p.position isEqualToString:@"S"]) {
                    return ((PlayerS *)p).ratSCov * [HBSharedUtils randomValue] * 40;
                } else if ([p.position isEqualToString:@"LB"]) {
                    return ((PlayerLB *)p).ratLBPas * [HBSharedUtils randomValue] * 60;
                } else if ([p.position isEqualToString:@"DL"]) {
                    return 0;
                } else {
                    return 0;
                }
            }
        }
    } else if (situation == FCGameSituationFumble) {
        if ([relatedPlayer.position isEqualToString:@"WR"]) {
            if ([p.position isEqualToString:@"CB"]) {
                return ((PlayerCB *)p).ratCBTkl * [HBSharedUtils randomValue] * 100;
            } else if ([p.position isEqualToString:@"S"]) {
                return ((PlayerS *)p).ratSTkl * [HBSharedUtils randomValue] * 60;
            } else if ([p.position isEqualToString:@"LB"]) {
                return ((PlayerLB *)p).ratLBTkl * [HBSharedUtils randomValue] * 40;
            } else {
                return 0;
            }
        } else if ([relatedPlayer.position isEqualToString:@"TE"]) {
            if ([p.position isEqualToString:@"CB"]) {
                return ((PlayerCB *)p).ratCBTkl * [HBSharedUtils randomValue] * 50;
            } else if ([p.position isEqualToString:@"S"]) {
                return ((PlayerS *)p).ratSTkl * [HBSharedUtils randomValue] * 55;
            } else if ([p.position isEqualToString:@"LB"]) {
                return ((PlayerLB *)p).ratLBTkl * [HBSharedUtils randomValue] * 80;
            } else if ([p.position isEqualToString:@"DL"]) {
                return ((PlayerDL *)p).ratDLPow  * [HBSharedUtils randomValue] * 15;
            } else {
                return 0;
            }
        } else {
            if ([p.position isEqualToString:@"CB"]) {
                return ((PlayerCB *)p).ratCBTkl * [HBSharedUtils randomValue] * 30;
            } else if ([p.position isEqualToString:@"S"]) {
                return ((PlayerS *)p).ratSTkl * [HBSharedUtils randomValue] * 35;
            } else if ([p.position isEqualToString:@"LB"]) {
                return ((PlayerLB *)p).ratLBTkl * [HBSharedUtils randomValue] * 65;
            } else if ([p.position isEqualToString:@"DL"]) {
                return ((PlayerDL *)p).ratDLPow * [HBSharedUtils randomValue] * 40;
            } else {
                return 0;
            }
        }
    } else if (situation == FCGameSituationSack) {
        if ([p.position isEqualToString:@"CB"]) {
            return ((PlayerCB *)p).ratCBTkl * [HBSharedUtils randomValue] * 0;
        } else if ([p.position isEqualToString:@"S"]) {
            return ((PlayerS *)p).ratSTkl * [HBSharedUtils randomValue] * 25;
        } else if ([p.position isEqualToString:@"LB"]) {
            return ((PlayerLB *)p).ratLBTkl * [HBSharedUtils randomValue] * 60;
        } else if ([p.position isEqualToString:@"DL"]) {
            return ((PlayerDL *)p).ratDLPow * [HBSharedUtils randomValue] * 100;
        } else {
            return 0;
        }
    } else if (situation == FCGameSituationInterception) {
        if ([relatedPlayer.position isEqualToString:@"WR"]) {
            if ([p.position isEqualToString:@"CB"]) {
                return ((PlayerCB *)p).ratCBCov * [HBSharedUtils randomValue] * 100;
            } else if ([p.position isEqualToString:@"S"]) {
                return ((PlayerS *)p).ratSCov * [HBSharedUtils randomValue] * 50;
            } else if ([p.position isEqualToString:@"LB"]) {
                return ((PlayerLB *)p).ratLBPas * [HBSharedUtils randomValue] * 30;
            } else if ([p.position isEqualToString:@"DL"]) {
                return ((PlayerDL *)p).ratDLPas * [HBSharedUtils randomValue] * 15;
            } else {
                return 0;
            }
        } else if ([relatedPlayer.position isEqualToString:@"TE"]) {
            if ([p.position isEqualToString:@"CB"]) {
                return ((PlayerCB *)p).ratCBTkl * [HBSharedUtils randomValue] * 50;
            } else if ([p.position isEqualToString:@"S"]) {
                return ((PlayerS *)p).ratSTkl * [HBSharedUtils randomValue] * 45;
            } else if ([p.position isEqualToString:@"LB"]) {
                return ((PlayerLB *)p).ratLBPas * [HBSharedUtils randomValue] * 65;
            } else if ([p.position isEqualToString:@"DL"]) {
                return ((PlayerDL *)p).ratDLPas * [HBSharedUtils randomValue] * 15;
            } else {
                return 0;
            }
        } else {
            if ([p.position isEqualToString:@"CB"]) {
                return ((PlayerCB *)p).ratCBTkl * [HBSharedUtils randomValue] * 80;
            } else if ([p.position isEqualToString:@"S"]) {
                return ((PlayerS *)p).ratSTkl * [HBSharedUtils randomValue] * 50;
            } else if ([p.position isEqualToString:@"LB"]) {
                return ((PlayerLB *)p).ratLBTkl * [HBSharedUtils randomValue] * 65;
            } else if ([p.position isEqualToString:@"DL"]) {
                return ((PlayerDL *)p).ratDLPas * [HBSharedUtils randomValue] * 15;
            } else {
                return 0;
            }
        }
    } else if (situation == FCGameSituationTackle) {
        if (yardsGain < 5) {
            if ([p.position isEqualToString:@"CB"]) {
                return ((PlayerCB *)p).ratCBTkl * [HBSharedUtils randomValue] * 20;
            } else if ([p.position isEqualToString:@"S"]) {
                return ((PlayerS *)p).ratSTkl * [HBSharedUtils randomValue] * 20;
            } else if ([p.position isEqualToString:@"LB"]) {
                return ((PlayerLB *)p).ratLBTkl * [HBSharedUtils randomValue] * 60;
            } else if ([p.position isEqualToString:@"DL"]) {
                return ((PlayerDL *)p).ratDLPas * [HBSharedUtils randomValue] * 80;
            } else {
                return 0;
            }
        } else {
            if ([p.position isEqualToString:@"CB"]) {
                return ((PlayerCB *)p).ratCBTkl * [HBSharedUtils randomValue] * 25;
            } else if ([p.position isEqualToString:@"S"]) {
                return ((PlayerS *)p).ratSTkl * [HBSharedUtils randomValue] * 50;
            } else if ([p.position isEqualToString:@"LB"]) {
                return ((PlayerLB *)p).ratLBTkl * [HBSharedUtils randomValue] * 75;
            } else if ([p.position isEqualToString:@"DL"]) {
                return ((PlayerDL *)p).ratDLPas * [HBSharedUtils randomValue] * 20;
            } else {
                return 0;
            }
        }
    } else if (situation == FCGameSituationRunDefense) {
        if (yardsGain < 2 && !gotTD) {
            if ([p.position isEqualToString:@"DL"]) {
                return ((PlayerDL *)p).ratDLRsh * [HBSharedUtils randomValue] * 100;
            } else {
                return 0;
            }
        } else if (yardsGain >= 2 && yardsGain < 12 && !gotTD) {
            if ([p.position isEqualToString:@"LB"]) {
                return ((PlayerLB *)p).ratLBTkl * [HBSharedUtils randomValue] * 100;
            } else {
                return 0;
            }
        } else if (yardsGain >= 12 && !gotTD) {
            if ([p.position isEqualToString:@"CB"]) {
                return ((PlayerCB *)p).ratCBTkl * [HBSharedUtils randomValue] * 50;
            } else if ([p.position isEqualToString:@"S"]) {
                return ((PlayerS *)p).ratSTkl * [HBSharedUtils randomValue] * 100;
            } else {
                return 0;
            }
        }
    }
    
    return 0;
}

-(void)playGame {
    if ( !hasPlayed ) {
        pbpEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:HB_PLAY_BY_PLAY_ENABLED];
        //NSLog(@"[Game] START PLAY GAME, GAME SETUP");
        gameEventLog = [NSMutableString stringWithFormat:@"LOG: #%ld %@ (%ld-%ld) @ #%ld %@ (%ld-%ld)\n---------------------------------------------------------",(long)awayTeam.rankTeamPollScore, awayTeam.abbreviation,(long)awayTeam.wins,(long)awayTeam.losses,(long)homeTeam.rankTeamPollScore,homeTeam.abbreviation,(long)homeTeam.wins,(long)homeTeam.losses];
        //probably establish some home field advantage before playing
        gameTime = 3600;
        gameDown = 1;
        gamePoss = true;
        gameYardsNeed = 10;
        gameYardLine = 25;
        
        //Home Team Starters
//        NSLog(@"SET HOME STARTERS FOR %@", homeTeam.abbreviation);
        if (homeTeam == nil) {
            NSLog(@"WHY");
        }
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
//        NSLog(@"END HOME STARTERS FOR %@", homeTeam.abbreviation);
        
        //Away Team starters
//        NSLog(@"SET AWAY STARTERS FOR %@", awayTeam.abbreviation);
        if (awayTeam == nil) {
            NSLog(@"WHY");
        }
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
//        NSLog(@"END AWAY STARTERS FOR %@", awayTeam.abbreviation);
        //break redshirts if starters are marked as such and add gamesPlayed/gamesPlayedSeason
        //NSLog(@"[Game] BREAKING REDSHIRTS IF NECESSARY");
        for (Player *p in homeStarters) {
            if (p.hasRedshirt) {
                p.hasRedshirt = NO;
                p.wasRedshirted = YES;
            }
            
            if (![p isEqual:[homeTeam getWR:2]]) {
                p.gamesPlayedSeason++;
                p.gamesPlayed++;
            }
        }
        
        for (Player *p in awayStarters) {
            if (p.hasRedshirt) {
                p.hasRedshirt = NO;
                p.wasRedshirted = YES;
            }
            
            if (![p isEqual:[awayTeam getWR:2]]) {
                p.gamesPlayedSeason++;
                p.gamesPlayed++;
            }
        }
        
        [awayTeam getCurrentHC].gamesCoached++;
        [homeTeam getCurrentHC].gamesCoached++;
        
        //NSLog(@"[Game] START PLAYING GAME");
        int homePlays = 0;
        int awayPlays = 0;
        while ( gameTime > 0 ) {
            //play ball!
            if (gamePoss) {
                [self runPlay:homeTeam defense:awayTeam];
                homePlays++;
            } else {
                [self runPlay:awayTeam defense:homeTeam];
                awayPlays++;
            }
        }
        //NSLog(@"[Game] OUT OF TIME");
        
        //NSLog(@"[Game] CHECK IF OT NEEDED");
        if (homeScore != awayScore) {
            [gameEventLog appendFormat:@"\n\nTime has expired! The game is over.\n\nFINAL SCORE: %@ %ld - %ld %@", awayTeam.abbreviation, (long)awayScore, (long)homeScore, homeTeam.abbreviation ];
        } else {
            [gameEventLog appendFormat:@"%@\nOVERTIME!\n\nTie game at 0:00 - we're headed to overtime!",[self getEventPrefix]];
        }
        
        //NSLog(@"[Game] SETTING UP OT IF NECESSARY");
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
                    homePlays++;
                } else {
                    [self runPlay:awayTeam defense:homeTeam];
                    awayPlays++;
                }
            }
            
            if (homeScore != awayScore) {
                [gameEventLog appendFormat:@"\n\nFINAL SCORE: %@ %ld - %ld %@", awayTeam.abbreviation, (long)awayScore, (long)homeScore, homeTeam.abbreviation];
            }
        }
        //NSLog(@"[Game] END OT");
        
//        NSLog(@"%@ Plays (Home): %d", homeTeam.abbreviation, homePlays);
//        NSLog(@"%@ Plays (Away): %d", awayTeam.abbreviation, awayPlays);
        
        // Add points/opp points
        //NSLog(@"[Game] DOING SEASON STATS");
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
        //NSLog(@"[Game] END SEASON STATS");
        
        hasPlayed = true;
        
        //NSLog(@"[Game] COMPILING PLAYER STATS");
        //NSLog(@"[Game] HOME TEAM");
        NSNumber *qbComp, *qbAtt, *qbYds, *qbTD, *qbInt, *qbRushAtt, *qbRushYds, *qbRushTDs, *qbRushFum;
        NSNumber *rb1Att, *rb1Yds, *rb1TDs, *rb1Fum;
        NSNumber *rb2Att, *rb2Yds, *rb2TDs, *rb2Fum;
        NSNumber *wr1Rec, *wr1Yds, *wr1TD, *wr1Fum, *wr1Drp, *wr1Tgt;
        NSNumber *wr2Rec, *wr2Yds, *wr2TD, *wr2Fum, *wr2Drp, *wr2Tgt;
        NSNumber *wr3Rec, *wr3Yds, *wr3TD, *wr3Fum, *wr3Drp, *wr3Tgt;
        NSNumber *teRec, *teYds, *teTD, *teFum, *teDrp, *teTgt;
        NSNumber *kXPM, *kXPA, *kFGM, *kFGA;
        NSNumber *tkl, *passDef, *sks, *defInt, *ffum;
        
        //homeTeam career stats trackings
        qbComp = HomeQBStats[FCQBStatPassComp];
        [homeTeam getQB:0].careerStatsPassComp += [qbComp intValue];
        qbAtt = HomeQBStats[FCQBStatPassAtt];
        [homeTeam getQB:0].careerStatsPassAtt += [qbAtt intValue];
        qbYds = HomeQBStats[FCQBStatPassYards];
        [homeTeam getQB:0].careerStatsPassYards += [qbYds intValue];
        qbTD = HomeQBStats[FCQBStatPassTD];
        [homeTeam getQB:0].careerStatsTD += [qbTD intValue];
        qbInt = HomeQBStats[FCQBStatINT];
        [homeTeam getQB:0].careerStatsInt += [qbInt intValue];
        qbRushAtt = HomeQBStats[FCQBStatRushAtt];
        [homeTeam getQB:0].careerStatsRushAtt += [qbRushAtt intValue];
        qbRushYds = HomeQBStats[FCQBStatRushYards];
        [homeTeam getQB:0].careerStatsRushYards += [qbRushYds intValue];
        qbRushTDs = HomeQBStats[FCQBStatRushTD];
        [homeTeam getQB:0].careerStatsRushTD += [qbRushTDs intValue];
        qbRushFum = HomeQBStats[FCQBStatFumbles];
        [homeTeam getQB:0].careerStatsFumbles += [qbRushFum intValue];
        
        rb1Att = HomeRB1Stats[FCRBStatRushAtt];
        [homeTeam getRB:0].careerStatsRushAtt += [rb1Att intValue];
        rb1Yds = HomeRB1Stats[FCRBStatRushYards];
        [homeTeam getRB:0].careerStatsRushYards += [rb1Yds intValue];
        rb1TDs = HomeRB1Stats[FCRBStatRushTD];
        [homeTeam getRB:0].careerStatsTD += [rb1TDs intValue];
        rb1Fum = HomeRB1Stats[FCRBStatFumbles];
        [homeTeam getRB:0].careerStatsFumbles += [rb1Fum intValue];
        
        rb2Att = HomeRB2Stats[FCRBStatRushAtt];
        [homeTeam getRB:1].careerStatsRushAtt += [rb2Att intValue];
        rb2Yds = HomeRB2Stats[FCRBStatRushYards];
        [homeTeam getRB:1].careerStatsRushYards += [rb2Yds intValue];
        rb2TDs = HomeRB2Stats[FCRBStatRushTD];
        [homeTeam getRB:1].careerStatsTD += [rb2TDs intValue];
        rb2Fum = HomeRB2Stats[FCRBStatFumbles];
        [homeTeam getRB:1].careerStatsFumbles += [rb2Fum intValue];
        
        wr1Rec = HomeWR1Stats[FCWRStatCatches];
        [homeTeam getWR:0].careerStatsReceptions += [wr1Rec intValue];
        wr1Tgt = HomeWR1Stats[FCWRStatTargets];
        [homeTeam getWR:0].careerStatsTargets += [wr1Tgt intValue];
        wr1Yds = HomeWR1Stats[FCWRStatRecYards];
        [homeTeam getWR:0].careerStatsRecYards += [wr1Yds intValue];
        wr1TD = HomeWR1Stats[FCWRStatRecTD];
        [homeTeam getWR:0].careerStatsTD += [wr1TD intValue];
        wr1Drp = HomeWR1Stats[FCWRStatDrops];
        [homeTeam getWR:0].careerStatsDrops += [wr1Drp intValue];
        wr1Fum = HomeWR1Stats[FCWRStatFumbles];
        [homeTeam getWR:0].careerStatsFumbles += [wr1Fum intValue];
        
        wr2Rec = HomeWR2Stats[FCWRStatCatches];
        [homeTeam getWR:1].careerStatsReceptions += [wr2Rec intValue];
        wr2Tgt = HomeWR2Stats[FCWRStatTargets];
        [homeTeam getWR:1].careerStatsTargets += [wr2Tgt intValue];
        wr2Yds = HomeWR2Stats[FCWRStatRecYards];
        [homeTeam getWR:1].careerStatsRecYards += [wr2Yds intValue];
        wr2TD = HomeWR2Stats[FCWRStatRecTD];
        [homeTeam getWR:1].careerStatsTD += [wr2TD intValue];
        wr2Drp = HomeWR2Stats[FCWRStatDrops];
        [homeTeam getWR:1].careerStatsDrops += [wr2Drp intValue];
        wr2Fum = HomeWR2Stats[FCWRStatFumbles];
        [homeTeam getWR:1].careerStatsFumbles += [wr2Fum intValue];
        
        wr3Rec = HomeWR3Stats[FCWRStatCatches];
        [homeTeam getWR:2].careerStatsReceptions += [wr3Rec intValue];
        wr3Tgt = HomeWR3Stats[FCWRStatTargets];
        [homeTeam getWR:2].careerStatsTargets += [wr3Tgt intValue];
        wr3Yds = HomeWR3Stats[FCWRStatRecYards];
        [homeTeam getWR:2].careerStatsRecYards += [wr3Yds intValue];
        wr3TD = HomeWR3Stats[FCWRStatRecTD];
        [homeTeam getWR:2].careerStatsTD += [wr3TD intValue];
        wr3Drp = HomeWR3Stats[FCWRStatDrops];
        [homeTeam getWR:2].careerStatsDrops += [wr3Drp intValue];
        wr3Fum = HomeWR3Stats[FCWRStatFumbles];
        [homeTeam getWR:2].careerStatsFumbles += [wr3Fum intValue];
        
        teRec = HomeTEStats[FCWRStatCatches];
        [homeTeam getTE:0].careerStatsReceptions += [teRec intValue];
        teTgt = HomeTEStats[FCWRStatTargets];
        [homeTeam getTE:0].careerStatsTargets += [teTgt intValue];
        teYds = HomeTEStats[FCWRStatRecYards];
        [homeTeam getTE:0].careerStatsRecYards += [teYds intValue];
        teTD = HomeTEStats[FCWRStatRecTD];
        [homeTeam getTE:0].careerStatsTD += [teTD intValue];
        teDrp = HomeTEStats[FCWRStatDrops];
        [homeTeam getTE:0].careerStatsDrops += [teDrp intValue];
        teFum = HomeTEStats[FCWRStatFumbles];
        [homeTeam getTE:0].careerStatsFumbles += [teFum intValue];
        
        kXPM = HomeKStats[FCKStatXPMade];
        [homeTeam getK:0].careerStatsXPMade += [kXPM intValue];
        kXPA = HomeKStats[FCKStatXPAtt];
        [homeTeam getK:0].careerStatsXPAtt += [kXPA intValue];
        kFGM = HomeKStats[FCKStatFGMade];
        [homeTeam getK:0].careerStatsFGMade += [kFGM intValue];
        kFGA = HomeKStats[FCKStatFGAtt];
        [homeTeam getK:0].careerStatsFGAtt += [kFGA intValue];
        
        tkl = HomeSStats[FCDefensiveStatTkl];
        [homeTeam getS:0].statsTkl += [tkl intValue];
        [homeTeam getS:0].careerStatsTkl += [tkl intValue];
        passDef = HomeSStats[FCDefensiveStatPassDef];
        [homeTeam getS:0].statsPassDef += [passDef intValue];
        [homeTeam getS:0].careerStatsPassDef += [passDef intValue];
        sks = HomeSStats[FCDefensiveStatSacks];
        [homeTeam getS:0].statsSacks += [sks intValue];
        [homeTeam getS:0].careerStatsSacks += [sks intValue];
        defInt = HomeSStats[FCDefensiveStatINT];
        [homeTeam getS:0].statsInt += [defInt intValue];
        [homeTeam getS:0].careerStatsInt += [defInt intValue];
        ffum = HomeSStats[FCDefensiveStatForcedFum];
        [homeTeam getS:0].statsForcedFum += [ffum intValue];
        [homeTeam getS:0].careerStatsForcedFum += [ffum intValue];
        
        tkl = HomeCB1Stats[FCDefensiveStatTkl];
        [homeTeam getCB:0].statsTkl += [tkl intValue];
        [homeTeam getCB:0].careerStatsTkl += [tkl intValue];
        passDef = HomeCB1Stats[FCDefensiveStatPassDef];
        [homeTeam getCB:0].statsPassDef += [passDef intValue];
        [homeTeam getCB:0].careerStatsPassDef += [passDef intValue];
        sks = HomeCB1Stats[FCDefensiveStatSacks];
        [homeTeam getCB:0].statsSacks += [sks intValue];
        [homeTeam getCB:0].careerStatsSacks += [sks intValue];
        defInt = HomeCB1Stats[FCDefensiveStatINT];
        [homeTeam getCB:0].statsInt += [defInt intValue];
        [homeTeam getCB:0].careerStatsInt += [defInt intValue];
        ffum = HomeCB1Stats[FCDefensiveStatForcedFum];
        [homeTeam getCB:0].statsForcedFum += [ffum intValue];
        [homeTeam getCB:0].careerStatsForcedFum += [ffum intValue];
        
        tkl = HomeCB2Stats[FCDefensiveStatTkl];
        [homeTeam getCB:1].statsTkl += [tkl intValue];
        [homeTeam getCB:1].careerStatsTkl += [tkl intValue];
        passDef = HomeCB2Stats[FCDefensiveStatPassDef];
        [homeTeam getCB:1].statsPassDef += [passDef intValue];
        [homeTeam getCB:1].careerStatsPassDef += [passDef intValue];
        sks = HomeCB2Stats[FCDefensiveStatSacks];
        [homeTeam getCB:1].statsSacks += [sks intValue];
        [homeTeam getCB:1].careerStatsSacks += [sks intValue];
        defInt = HomeCB2Stats[FCDefensiveStatINT];
        [homeTeam getCB:1].statsInt += [defInt intValue];
        [homeTeam getCB:1].careerStatsInt += [defInt intValue];
        ffum = HomeCB2Stats[FCDefensiveStatForcedFum];
        [homeTeam getCB:1].statsForcedFum += [ffum intValue];
        [homeTeam getCB:1].careerStatsForcedFum += [ffum intValue];
        
        tkl = HomeCB3Stats[FCDefensiveStatTkl];
        [homeTeam getCB:2].statsTkl += [tkl intValue];
        [homeTeam getCB:2].careerStatsTkl += [tkl intValue];
        passDef = HomeCB3Stats[FCDefensiveStatPassDef];
        [homeTeam getCB:2].statsPassDef += [passDef intValue];
        [homeTeam getCB:2].careerStatsPassDef += [passDef intValue];
        sks = HomeCB3Stats[FCDefensiveStatSacks];
        [homeTeam getCB:2].statsSacks += [sks intValue];
        [homeTeam getCB:2].careerStatsSacks += [sks intValue];
        defInt = HomeCB3Stats[FCDefensiveStatINT];
        [homeTeam getCB:2].statsInt += [defInt intValue];
        [homeTeam getCB:2].careerStatsInt += [defInt intValue];
        ffum = HomeCB3Stats[FCDefensiveStatForcedFum];
        [homeTeam getCB:2].statsForcedFum += [ffum intValue];
        [homeTeam getCB:2].careerStatsForcedFum += [ffum intValue];
        
        ///
        tkl = HomeDL1Stats[FCDefensiveStatTkl];
        [homeTeam getDL:0].statsTkl += [tkl intValue];
        [homeTeam getDL:0].careerStatsTkl += [tkl intValue];
        passDef = HomeDL1Stats[FCDefensiveStatPassDef];
        [homeTeam getDL:0].statsPassDef += [passDef intValue];
        [homeTeam getDL:0].careerStatsPassDef += [passDef intValue];
        sks = HomeDL1Stats[FCDefensiveStatSacks];
        [homeTeam getDL:0].statsSacks += [sks intValue];
        [homeTeam getDL:0].careerStatsSacks += [sks intValue];
        defInt = HomeDL1Stats[FCDefensiveStatINT];
        [homeTeam getDL:0].statsInt += [defInt intValue];
        [homeTeam getDL:0].careerStatsInt += [defInt intValue];
        ffum = HomeDL1Stats[FCDefensiveStatForcedFum];
        [homeTeam getDL:0].statsForcedFum += [ffum intValue];
        [homeTeam getDL:0].careerStatsForcedFum += [ffum intValue];
        
        tkl = HomeDL2Stats[FCDefensiveStatTkl];
        [homeTeam getDL:1].statsTkl += [tkl intValue];
        [homeTeam getDL:1].careerStatsTkl += [tkl intValue];
        passDef = HomeDL2Stats[FCDefensiveStatPassDef];
        [homeTeam getDL:1].statsPassDef += [passDef intValue];
        [homeTeam getDL:1].careerStatsPassDef += [passDef intValue];
        sks = HomeDL2Stats[FCDefensiveStatSacks];
        [homeTeam getDL:1].statsSacks += [sks intValue];
        [homeTeam getDL:1].careerStatsSacks += [sks intValue];
        defInt = HomeDL2Stats[FCDefensiveStatINT];
        [homeTeam getDL:1].statsInt += [defInt intValue];
        [homeTeam getDL:1].careerStatsInt += [defInt intValue];
        ffum = HomeDL2Stats[FCDefensiveStatForcedFum];
        [homeTeam getDL:1].statsForcedFum += [ffum intValue];
        [homeTeam getDL:1].careerStatsForcedFum += [ffum intValue];
        
        tkl = HomeDL3Stats[FCDefensiveStatTkl];
        [homeTeam getDL:2].statsTkl += [tkl intValue];
        [homeTeam getDL:2].careerStatsTkl += [tkl intValue];
        passDef = HomeDL3Stats[FCDefensiveStatPassDef];
        [homeTeam getDL:2].statsPassDef += [passDef intValue];
        [homeTeam getDL:2].careerStatsPassDef += [passDef intValue];
        sks = HomeDL3Stats[FCDefensiveStatSacks];
        [homeTeam getDL:2].statsSacks += [sks intValue];
        [homeTeam getDL:2].careerStatsSacks += [sks intValue];
        defInt = HomeDL3Stats[FCDefensiveStatINT];
        [homeTeam getDL:2].statsInt += [defInt intValue];
        [homeTeam getDL:2].careerStatsInt += [defInt intValue];
        ffum = HomeDL3Stats[FCDefensiveStatForcedFum];
        [homeTeam getDL:2].statsForcedFum += [ffum intValue];
        [homeTeam getDL:2].careerStatsForcedFum += [ffum intValue];
        
        tkl = HomeDL4Stats[FCDefensiveStatTkl];
        [homeTeam getDL:3].statsTkl += [tkl intValue];
        [homeTeam getDL:3].careerStatsTkl += [tkl intValue];
        passDef = HomeDL4Stats[FCDefensiveStatPassDef];
        [homeTeam getDL:3].statsPassDef += [passDef intValue];
        [homeTeam getDL:3].careerStatsPassDef += [passDef intValue];
        sks = HomeDL4Stats[FCDefensiveStatSacks];
        [homeTeam getDL:3].statsSacks += [sks intValue];
        [homeTeam getDL:3].careerStatsSacks += [sks intValue];
        defInt = HomeDL4Stats[FCDefensiveStatINT];
        [homeTeam getDL:3].statsInt += [defInt intValue];
        [homeTeam getDL:3].careerStatsInt += [defInt intValue];
        ffum = HomeDL4Stats[FCDefensiveStatForcedFum];
        [homeTeam getDL:3].statsForcedFum += [ffum intValue];
        [homeTeam getDL:3].careerStatsForcedFum += [ffum intValue];
        
        ///
        tkl = HomeLB1Stats[FCDefensiveStatTkl];
        [homeTeam getLB:0].statsTkl += [tkl intValue];
        [homeTeam getLB:0].careerStatsTkl += [tkl intValue];
        passDef = HomeLB1Stats[FCDefensiveStatPassDef];
        [homeTeam getLB:0].statsPassDef += [passDef intValue];
        [homeTeam getLB:0].careerStatsPassDef += [passDef intValue];
        sks = HomeLB1Stats[FCDefensiveStatSacks];
        [homeTeam getLB:0].statsSacks += [sks intValue];
        [homeTeam getLB:0].careerStatsSacks += [sks intValue];
        defInt = HomeLB1Stats[FCDefensiveStatINT];
        [homeTeam getLB:0].statsInt += [defInt intValue];
        [homeTeam getLB:0].careerStatsInt += [defInt intValue];
        ffum = HomeLB1Stats[FCDefensiveStatForcedFum];
        [homeTeam getLB:0].statsForcedFum += [ffum intValue];
        [homeTeam getLB:0].careerStatsForcedFum += [ffum intValue];
        
        tkl = HomeLB2Stats[FCDefensiveStatTkl];
        [homeTeam getLB:1].statsTkl += [tkl intValue];
        [homeTeam getLB:1].careerStatsTkl += [tkl intValue];
        passDef = HomeLB2Stats[FCDefensiveStatPassDef];
        [homeTeam getLB:1].statsPassDef += [passDef intValue];
        [homeTeam getLB:1].careerStatsPassDef += [passDef intValue];
        sks = HomeLB2Stats[FCDefensiveStatSacks];
        [homeTeam getLB:1].statsSacks += [sks intValue];
        [homeTeam getLB:1].careerStatsSacks += [sks intValue];
        defInt = HomeLB2Stats[FCDefensiveStatINT];
        [homeTeam getLB:1].statsInt += [defInt intValue];
        [homeTeam getLB:1].careerStatsInt += [defInt intValue];
        ffum = HomeLB2Stats[FCDefensiveStatForcedFum];
        [homeTeam getLB:1].statsForcedFum += [ffum intValue];
        [homeTeam getLB:1].careerStatsForcedFum += [ffum intValue];
        
        tkl = HomeLB3Stats[FCDefensiveStatTkl];
        [homeTeam getLB:2].statsTkl += [tkl intValue];
        [homeTeam getLB:2].careerStatsTkl += [tkl intValue];
        passDef = HomeLB3Stats[FCDefensiveStatPassDef];
        [homeTeam getLB:2].statsPassDef += [passDef intValue];
        [homeTeam getLB:2].careerStatsPassDef += [passDef intValue];
        sks = HomeLB3Stats[FCDefensiveStatSacks];
        [homeTeam getLB:2].statsSacks += [sks intValue];
        [homeTeam getLB:2].careerStatsSacks += [sks intValue];
        defInt = HomeLB3Stats[FCDefensiveStatINT];
        [homeTeam getLB:2].statsInt += [defInt intValue];
        [homeTeam getLB:2].careerStatsInt += [defInt intValue];
        ffum = HomeLB3Stats[FCDefensiveStatForcedFum];
        [homeTeam getLB:2].statsForcedFum += [ffum intValue];
        [homeTeam getLB:2].careerStatsForcedFum += [ffum intValue];
        //NSLog(@"[Game] END HOME TEAM");
        
        //away team career stats tracking
        //NSLog(@"[Game] START AWAY TEAM");
        qbComp = AwayQBStats[FCQBStatPassComp];
        [awayTeam getQB:0].careerStatsPassComp += [qbComp intValue];
        qbAtt = AwayQBStats[FCQBStatPassAtt];
        [awayTeam getQB:0].careerStatsPassAtt += [qbAtt intValue];
        qbYds = AwayQBStats[FCQBStatPassYards];
        [awayTeam getQB:0].careerStatsPassYards += [qbYds intValue];
        qbTD = AwayQBStats[FCQBStatPassTD];
        [awayTeam getQB:0].careerStatsTD += [qbTD intValue];
        qbInt = AwayQBStats[FCQBStatINT];
        [awayTeam getQB:0].careerStatsInt += [qbInt intValue];
        qbRushAtt = AwayQBStats[FCQBStatRushAtt];
        [awayTeam getQB:0].careerStatsRushAtt += [qbRushAtt intValue];
        qbRushYds = AwayQBStats[FCQBStatRushYards];
        [awayTeam getQB:0].careerStatsRushYards += [qbRushYds intValue];
        qbRushTDs = AwayQBStats[FCQBStatRushTD];
        [awayTeam getQB:0].careerStatsRushTD += [qbRushTDs intValue];
        qbRushFum = AwayQBStats[FCQBStatFumbles];
        [awayTeam getQB:0].careerStatsFumbles += [qbRushFum intValue];
        
        rb1Att = AwayRB1Stats[FCRBStatRushAtt];
        [awayTeam getRB:0].careerStatsRushAtt += [rb1Att intValue];
        rb1Yds = AwayRB1Stats[FCRBStatRushYards];
        [awayTeam getRB:0].careerStatsRushYards += [rb1Yds intValue];
        rb1TDs = AwayRB1Stats[FCRBStatRushTD];
        [awayTeam getRB:0].careerStatsTD += [rb1TDs intValue];
        rb1Fum = AwayRB1Stats[FCRBStatFumbles];
        [awayTeam getRB:0].careerStatsFumbles += [rb1Fum intValue];
        
        rb2Att = AwayRB2Stats[FCRBStatRushAtt];
        [awayTeam getRB:1].careerStatsRushAtt += [rb2Att intValue];
        rb2Yds = AwayRB2Stats[FCRBStatRushYards];
        [awayTeam getRB:1].careerStatsRushYards += [rb2Yds intValue];
        rb2TDs = AwayRB2Stats[FCRBStatRushTD];
        [awayTeam getRB:1].careerStatsTD += [rb2TDs intValue];
        rb2Fum = AwayRB2Stats[FCRBStatFumbles];
        [awayTeam getRB:1].careerStatsFumbles += [rb2Fum intValue];
        
        wr1Rec = AwayWR1Stats[FCWRStatCatches];
        [awayTeam getWR:0].careerStatsReceptions += [wr1Rec intValue];
        wr1Tgt = AwayWR1Stats[FCWRStatTargets];
        [awayTeam getWR:0].careerStatsTargets += [wr1Tgt intValue];
        wr1Yds = AwayWR1Stats[FCWRStatRecYards];
        [awayTeam getWR:0].careerStatsRecYards += [wr1Yds intValue];
        wr1TD = AwayWR1Stats[FCWRStatRecTD];
        [awayTeam getWR:0].careerStatsTD += [wr1TD intValue];
        wr1Drp = AwayWR1Stats[FCWRStatDrops];
        [awayTeam getWR:0].careerStatsDrops += [wr1Drp intValue];
        wr1Fum = AwayWR1Stats[FCWRStatFumbles];
        [awayTeam getWR:0].careerStatsFumbles += [wr1Fum intValue];
        
        wr2Rec = AwayWR2Stats[FCWRStatCatches];
        [awayTeam getWR:1].careerStatsReceptions += [wr2Rec intValue];
        wr2Tgt = AwayWR2Stats[FCWRStatTargets];
        [awayTeam getWR:1].careerStatsTargets += [wr2Tgt intValue];
        wr2Yds = AwayWR2Stats[FCWRStatRecYards];
        [awayTeam getWR:1].careerStatsRecYards += [wr2Yds intValue];
        wr2TD = AwayWR2Stats[FCWRStatRecTD];
        [awayTeam getWR:1].careerStatsTD += [wr2TD intValue];
        wr2Drp = AwayWR2Stats[FCWRStatDrops];
        [awayTeam getWR:1].careerStatsDrops += [wr2Drp intValue];
        wr2Fum = AwayWR2Stats[FCWRStatFumbles];
        [awayTeam getWR:1].careerStatsFumbles += [wr2Fum intValue];
        
        wr3Rec = AwayWR3Stats[FCWRStatCatches];
        [awayTeam getWR:2].careerStatsReceptions += [wr3Rec intValue];
        wr3Tgt = AwayWR3Stats[FCWRStatTargets];
        [awayTeam getWR:2].careerStatsTargets += [wr3Tgt intValue];
        wr3Yds = AwayWR3Stats[FCWRStatRecYards];
        [awayTeam getWR:2].careerStatsRecYards += [wr3Yds intValue];
        wr3TD = AwayWR3Stats[FCWRStatRecTD];
        [awayTeam getWR:2].careerStatsTD += [wr3TD intValue];
        wr3Drp = AwayWR3Stats[FCWRStatDrops];
        [awayTeam getWR:2].careerStatsDrops += [wr3Drp intValue];
        wr3Fum = AwayWR3Stats[FCWRStatFumbles];
        [awayTeam getWR:2].careerStatsFumbles += [wr3Fum intValue];
        
        teRec = AwayTEStats[FCWRStatCatches];
        [awayTeam getTE:0].careerStatsReceptions += [teRec intValue];
        teTgt = AwayTEStats[FCWRStatTargets];
        [awayTeam getTE:0].careerStatsTargets += [teTgt intValue];
        teYds = AwayTEStats[FCWRStatRecYards];
        [awayTeam getTE:0].careerStatsRecYards += [teYds intValue];
        teTD = AwayTEStats[FCWRStatRecTD];
        [awayTeam getTE:0].careerStatsTD += [teTD intValue];
        teDrp = AwayTEStats[FCWRStatDrops];
        [awayTeam getTE:0].careerStatsDrops += [teDrp intValue];
        teFum = AwayTEStats[FCWRStatFumbles];
        [awayTeam getTE:0].careerStatsFumbles += [teFum intValue];
        
        kXPM = AwayKStats[FCKStatXPMade];
        [awayTeam getK:0].careerStatsXPMade += [kXPM intValue];
        kXPA = AwayKStats[FCKStatXPAtt];
        [awayTeam getK:0].careerStatsXPAtt += [kXPA intValue];
        kFGM = AwayKStats[FCKStatFGMade];
        [awayTeam getK:0].careerStatsFGMade += [kFGM intValue];
        kFGA = AwayKStats[FCKStatFGAtt];
        [awayTeam getK:0].careerStatsFGAtt += [kFGA intValue];
        
        tkl = AwaySStats[FCDefensiveStatTkl];
        [awayTeam getS:0].statsTkl += [tkl intValue];
        [awayTeam getS:0].careerStatsTkl += [tkl intValue];
        passDef = AwaySStats[FCDefensiveStatPassDef];
        [awayTeam getS:0].statsPassDef += [passDef intValue];
        [awayTeam getS:0].careerStatsPassDef += [passDef intValue];
        sks = AwaySStats[FCDefensiveStatSacks];
        [awayTeam getS:0].statsSacks += [sks intValue];
        [awayTeam getS:0].careerStatsSacks += [sks intValue];
        defInt = AwaySStats[FCDefensiveStatINT];
        [awayTeam getS:0].statsInt += [defInt intValue];
        [awayTeam getS:0].careerStatsInt += [defInt intValue];
        ffum = AwaySStats[FCDefensiveStatForcedFum];
        [awayTeam getS:0].statsForcedFum += [ffum intValue];
        [awayTeam getS:0].careerStatsForcedFum += [ffum intValue];
        
        tkl = AwayCB1Stats[FCDefensiveStatTkl];
        [awayTeam getCB:0].statsTkl += [tkl intValue];
        [awayTeam getCB:0].careerStatsTkl += [tkl intValue];
        passDef = AwayCB1Stats[FCDefensiveStatPassDef];
        [awayTeam getCB:0].statsPassDef += [passDef intValue];
        [awayTeam getCB:0].careerStatsPassDef += [passDef intValue];
        sks = AwayCB1Stats[FCDefensiveStatSacks];
        [awayTeam getCB:0].statsSacks += [sks intValue];
        [awayTeam getCB:0].careerStatsSacks += [sks intValue];
        defInt = AwayCB1Stats[FCDefensiveStatINT];
        [awayTeam getCB:0].statsInt += [defInt intValue];
        [awayTeam getCB:0].careerStatsInt += [defInt intValue];
        ffum = AwayCB1Stats[FCDefensiveStatForcedFum];
        [awayTeam getCB:0].statsForcedFum += [ffum intValue];
        [awayTeam getCB:0].careerStatsForcedFum += [ffum intValue];
        
        tkl = AwayCB2Stats[FCDefensiveStatTkl];
        [awayTeam getCB:1].statsTkl += [tkl intValue];
        [awayTeam getCB:1].careerStatsTkl += [tkl intValue];
        passDef = AwayCB2Stats[FCDefensiveStatPassDef];
        [awayTeam getCB:1].statsPassDef += [passDef intValue];
        [awayTeam getCB:1].careerStatsPassDef += [passDef intValue];
        sks = AwayCB2Stats[FCDefensiveStatSacks];
        [awayTeam getCB:1].statsSacks += [sks intValue];
        [awayTeam getCB:1].careerStatsSacks += [sks intValue];
        defInt = AwayCB2Stats[FCDefensiveStatINT];
        [awayTeam getCB:1].statsInt += [defInt intValue];
        [awayTeam getCB:1].careerStatsInt += [defInt intValue];
        ffum = AwayCB2Stats[FCDefensiveStatForcedFum];
        [awayTeam getCB:1].statsForcedFum += [ffum intValue];
        [awayTeam getCB:1].careerStatsForcedFum += [ffum intValue];
        
        tkl = AwayCB3Stats[FCDefensiveStatTkl];
        [awayTeam getCB:2].statsTkl += [tkl intValue];
        [awayTeam getCB:2].careerStatsTkl += [tkl intValue];
        passDef = AwayCB3Stats[FCDefensiveStatPassDef];
        [awayTeam getCB:2].statsPassDef += [passDef intValue];
        [awayTeam getCB:2].careerStatsPassDef += [passDef intValue];
        sks = AwayCB3Stats[FCDefensiveStatSacks];
        [awayTeam getCB:2].statsSacks += [sks intValue];
        [awayTeam getCB:2].careerStatsSacks += [sks intValue];
        defInt = AwayCB3Stats[FCDefensiveStatINT];
        [awayTeam getCB:2].statsInt += [defInt intValue];
        [awayTeam getCB:2].careerStatsInt += [defInt intValue];
        ffum = AwayCB3Stats[FCDefensiveStatForcedFum];
        [awayTeam getCB:2].statsForcedFum += [ffum intValue];
        [awayTeam getCB:2].careerStatsForcedFum += [ffum intValue];
        
        ///
        tkl = AwayDL1Stats[FCDefensiveStatTkl];
        [awayTeam getDL:0].statsTkl += [tkl intValue];
        [awayTeam getDL:0].careerStatsTkl += [tkl intValue];
        passDef = AwayDL1Stats[FCDefensiveStatPassDef];
        [awayTeam getDL:0].statsPassDef += [passDef intValue];
        [awayTeam getDL:0].careerStatsPassDef += [passDef intValue];
        sks = AwayDL1Stats[FCDefensiveStatSacks];
        [awayTeam getDL:0].statsSacks += [sks intValue];
        [awayTeam getDL:0].careerStatsSacks += [sks intValue];
        defInt = AwayDL1Stats[FCDefensiveStatINT];
        [awayTeam getDL:0].statsInt += [defInt intValue];
        [awayTeam getDL:0].careerStatsInt += [defInt intValue];
        ffum = AwayDL1Stats[FCDefensiveStatForcedFum];
        [awayTeam getDL:0].statsForcedFum += [ffum intValue];
        [awayTeam getDL:0].careerStatsForcedFum += [ffum intValue];
        
        tkl = AwayDL2Stats[FCDefensiveStatTkl];
        [awayTeam getDL:1].statsTkl += [tkl intValue];
        [awayTeam getDL:1].careerStatsTkl += [tkl intValue];
        passDef = AwayDL2Stats[FCDefensiveStatPassDef];
        [awayTeam getDL:1].statsPassDef += [passDef intValue];
        [awayTeam getDL:1].careerStatsPassDef += [passDef intValue];
        sks = AwayDL2Stats[FCDefensiveStatSacks];
        [awayTeam getDL:1].statsSacks += [sks intValue];
        [awayTeam getDL:1].careerStatsSacks += [sks intValue];
        defInt = AwayDL2Stats[FCDefensiveStatINT];
        [awayTeam getDL:1].statsInt += [defInt intValue];
        [awayTeam getDL:1].careerStatsInt += [defInt intValue];
        ffum = AwayDL2Stats[FCDefensiveStatForcedFum];
        [awayTeam getDL:1].statsForcedFum += [ffum intValue];
        [awayTeam getDL:1].careerStatsForcedFum += [ffum intValue];
        
        tkl = AwayDL3Stats[FCDefensiveStatTkl];
        [awayTeam getDL:2].statsTkl += [tkl intValue];
        [awayTeam getDL:2].careerStatsTkl += [tkl intValue];
        passDef = AwayDL3Stats[FCDefensiveStatPassDef];
        [awayTeam getDL:2].statsPassDef += [passDef intValue];
        [awayTeam getDL:2].careerStatsPassDef += [passDef intValue];
        sks = AwayDL3Stats[FCDefensiveStatSacks];
        [awayTeam getDL:2].statsSacks += [sks intValue];
        [awayTeam getDL:2].careerStatsSacks += [sks intValue];
        defInt = AwayDL3Stats[FCDefensiveStatINT];
        [awayTeam getDL:2].statsInt += [defInt intValue];
        [awayTeam getDL:2].careerStatsInt += [defInt intValue];
        ffum = AwayDL3Stats[FCDefensiveStatForcedFum];
        [awayTeam getDL:2].statsForcedFum += [ffum intValue];
        [awayTeam getDL:2].careerStatsForcedFum += [ffum intValue];
        
        tkl = AwayDL4Stats[FCDefensiveStatTkl];
        [awayTeam getDL:3].statsTkl += [tkl intValue];
        [awayTeam getDL:3].careerStatsTkl += [tkl intValue];
        passDef = AwayDL4Stats[FCDefensiveStatPassDef];
        [awayTeam getDL:3].statsPassDef += [passDef intValue];
        [awayTeam getDL:3].careerStatsPassDef += [passDef intValue];
        sks = AwayDL4Stats[FCDefensiveStatSacks];
        [awayTeam getDL:3].statsSacks += [sks intValue];
        [awayTeam getDL:3].careerStatsSacks += [sks intValue];
        defInt = AwayDL4Stats[FCDefensiveStatINT];
        [awayTeam getDL:3].statsInt += [defInt intValue];
        [awayTeam getDL:3].careerStatsInt += [defInt intValue];
        ffum = AwayDL4Stats[FCDefensiveStatForcedFum];
        [awayTeam getDL:3].statsForcedFum += [ffum intValue];
        [awayTeam getDL:3].careerStatsForcedFum += [ffum intValue];
        
        ///
        
        tkl = AwayLB1Stats[FCDefensiveStatTkl];
        [awayTeam getLB:0].statsTkl += [tkl intValue];
        [awayTeam getLB:0].careerStatsTkl += [tkl intValue];
        passDef = AwayLB1Stats[FCDefensiveStatPassDef];
        [awayTeam getLB:0].statsPassDef += [passDef intValue];
        [awayTeam getLB:0].careerStatsPassDef += [passDef intValue];
        sks = AwayLB1Stats[FCDefensiveStatSacks];
        [awayTeam getLB:0].statsSacks += [sks intValue];
        [awayTeam getLB:0].careerStatsSacks += [sks intValue];
        defInt = AwayLB1Stats[FCDefensiveStatINT];
        [awayTeam getLB:0].statsInt += [defInt intValue];
        [awayTeam getLB:0].careerStatsInt += [defInt intValue];
        ffum = AwayLB1Stats[FCDefensiveStatForcedFum];
        [awayTeam getLB:0].statsForcedFum += [ffum intValue];
        [awayTeam getLB:0].careerStatsForcedFum += [ffum intValue];
        
        tkl = AwayLB2Stats[FCDefensiveStatTkl];
        [awayTeam getLB:1].statsTkl += [tkl intValue];
        [awayTeam getLB:1].careerStatsTkl += [tkl intValue];
        passDef = AwayLB2Stats[FCDefensiveStatPassDef];
        [awayTeam getLB:1].statsPassDef += [passDef intValue];
        [awayTeam getLB:1].careerStatsPassDef += [passDef intValue];
        sks = AwayLB2Stats[FCDefensiveStatSacks];
        [awayTeam getLB:1].statsSacks += [sks intValue];
        [awayTeam getLB:1].careerStatsSacks += [sks intValue];
        defInt = AwayLB2Stats[FCDefensiveStatINT];
        [awayTeam getLB:1].statsInt += [defInt intValue];
        [awayTeam getLB:1].careerStatsInt += [defInt intValue];
        ffum = AwayLB2Stats[FCDefensiveStatForcedFum];
        [awayTeam getLB:1].statsForcedFum += [ffum intValue];
        [awayTeam getLB:1].careerStatsForcedFum += [ffum intValue];
        
        tkl = AwayLB3Stats[FCDefensiveStatTkl];
        [awayTeam getLB:2].statsTkl += [tkl intValue];
        [awayTeam getLB:2].careerStatsTkl += [tkl intValue];
        passDef = AwayLB3Stats[FCDefensiveStatPassDef];
        [awayTeam getLB:2].statsPassDef += [passDef intValue];
        [awayTeam getLB:2].careerStatsPassDef += [passDef intValue];
        sks = AwayLB3Stats[FCDefensiveStatSacks];
        [awayTeam getLB:2].statsSacks += [sks intValue];
        [awayTeam getLB:2].careerStatsSacks += [sks intValue];
        defInt = AwayLB3Stats[FCDefensiveStatINT];
        [awayTeam getLB:2].statsInt += [defInt intValue];
        [awayTeam getLB:2].careerStatsInt += [defInt intValue];
        ffum = AwayLB3Stats[FCDefensiveStatForcedFum];
        [awayTeam getLB:2].statsForcedFum += [ffum intValue];
        [awayTeam getLB:2].careerStatsForcedFum += [ffum intValue];
        //NSLog(@"[Game] END AWAY TEAM");
        
        //game over, add wins
        //NSLog(@"[Game] CALCULATING STREAKS");
        if (homeScore > awayScore) {
            homeTeam.wins++;
            [homeTeam getCurrentHC].totalWins++;
            homeTeam.totalWins++;
            [homeTeam.gameWLSchedule addObject:@"W"];
            awayTeam.losses++;
            [awayTeam getCurrentHC].totalLosses++;
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
            [homeTeam getCurrentHC].totalLosses++;
            [homeTeam.gameWLSchedule addObject:@"L"];
            awayTeam.wins++;
            awayTeam.totalWins++;
            [awayTeam getCurrentHC].totalWins++;
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
        
        //NSLog(@"[Game] END CALCULATING STREAKS");
        //NSLog(@"[Game] START CONF GAME CALC");
        if (([homeTeam.conference isEqualToString:awayTeam.conference]) || [gameName isEqualToString:@"In Conf"] || [gameName isEqualToString:@"Rivalry Game"] ) {
            // in conference game, see if was won
            if (homeScore > awayScore) {
                homeTeam.confWins++;
                homeTeam.totalConfWins++;
                [homeTeam getCurrentHC].totalConfWins++;
                awayTeam.confLosses++;
                awayTeam.totalConfLosses++;
                [awayTeam getCurrentHC].totalConfLosses++;
            } else if (homeScore < awayScore) {
                awayTeam.confWins++;
                awayTeam.totalConfWins++;
                [awayTeam getCurrentHC].totalConfWins++;
                homeTeam.confLosses++;
                homeTeam.totalConfLosses++;
                [homeTeam getCurrentHC].totalConfLosses++;
            }
        }
        //NSLog(@"[Game] END CONF GAME CALC");
        
        //NSLog(@"[Game] START RIVALRY GAME CALC");
        if ([gameName isEqualToString:@"Rivalry Game"] || [homeTeam.rivalTeam isEqualToString:awayTeam.abbreviation] || [awayTeam.rivalTeam isEqualToString:homeTeam.abbreviation]) {
            if (homeScore > awayScore) {
                homeTeam.wonRivalryGame = true;
                awayTeam.wonRivalryGame = false;
                homeTeam.rivalryWins++;
                [homeTeam getCurrentHC].totalRivalryWins++;
                awayTeam.rivalryLosses++;
                [awayTeam getCurrentHC].totalRivalryLosses++;
            } else {
                awayTeam.wonRivalryGame = true;
                homeTeam.wonRivalryGame = false;
                [awayTeam getCurrentHC].totalRivalryWins++;
                awayTeam.rivalryWins++;
                homeTeam.rivalryLosses++;
                [homeTeam getCurrentHC].totalRivalryLosses++;
            }
        }
        //NSLog(@"[Game] END RIVALRY GAME CALC");
        
        [homeTeam checkForInjury];
        [awayTeam checkForInjury];
        
        [self addNewsStory];
        
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"playedGame" object:nil];
    //NSLog(@"[Game] TEARDOWN AND END PLAY GAME");
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
        selCB = [defense getCB:2];
        [self passingPlayTE:offense defense:defense selQB:selQB selTE:selTE selTEStats:selTEStats selCB:selCB selS:selS selDL:selDL selLB:selLB selLB2:selLB2];
    } else {
        [self passingPlayWR:offense defense:defense selQB:selQB selWR:selWR selWRStats:selWRStats selCB:selCB selS:selS selLB:selLB selDL:selDL];
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
        
        [self qbSack:offense defense:defense selectedDL:selDL selectedLB:selLB selectedCB:selCB selectedS:selS];
        return;
    }
    
    //check for int
    double intChance = ((pressureOnQB + selS.ratOvr + defense.defensiveStrategy.passProtection - (selQB.ratPassAcc + selQB.ratFootIQ + 100 + offense.offensiveStrategy.passProtection) / 3) / 25);
    if (intChance < 0.015) intChance = 0.015;
    if ( 100* [HBSharedUtils randomValue] < intChance ) {
        //Interception
        [self qbInterception:offense defense:defense selectedDL:selDL selectedLB:selLB selectedCB:selCB selectedS:selS selectedReceiver:selTE];

        gameTime -= [self calculateSecondsPerPlay:offense.offensiveStrategy];
        [offense getQB:0].statsInt++;
        [offense getQB:0].statsPassAtt++;
        if (!playingOT) {
            gameDown = 1;
            gameYardsNeed = 10;
            gamePoss = !gamePoss;
            gameYardLine = 100 - gameYardLine;
        } else {
            [self resetForOT];
        }
        return;
    }
    
    //throw ball, check for completion
    double completion = ( [self getHFAdv] + [self normalize:selQB.ratPassAcc] + [self normalize:selTE.ratRecCat] - [self normalize:selLB.ratLBPas])/2 + 18.25 - pressureOnQB/16.8 + offense.offensiveStrategy.passProtection - defense.defensiveStrategy.passProtection;
    if ( 100* [HBSharedUtils randomValue] < completion ) {
        if ( 100* [HBSharedUtils randomValue] < (100 - selTE.ratRecCat)/3 ) {
            //drop
            if (pbpEnabled) {
                [gameEventLog appendString:[NSString stringWithFormat:@"%@%@ QB %@ pass incomplete %@ to TE %@.", [self getEventPrefix: yardsGain],offense.abbreviation,selQB.name,[self retrieveRandomPassDirection],selTE.name]];
            }
            gameDown++;
            NSNumber *wrStat = selTEStats[FCWRStatDrops];
            wrStat = [NSNumber numberWithInteger:wrStat.integerValue + 1];
            [selTEStats replaceObjectAtIndex:FCWRStatDrops withObject:wrStat];
            selTE.statsDrops++;
            [self passAttempt:offense defense:defense selectedDL:selDL selectedLB:selLB selectedCB:selCB selectedS:selS receiver:selTE stats:selTEStats yardsGained:yardsGain];
            gameTime -= [self calculateSecondsPerPlay:offense.offensiveStrategy];
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

            if ( (gameYardLine + yardsGain) >= 100 ) { //TD!
                yardsGain = abs(gameYardLine - 100);
//                gameYardLine = 100 - yardsGain;
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
            
            //stats management
            [self passCompletion:offense defense:defense selectedDL:selDL selectedLB:selLB selectedCB:selCB selectedS:selS receiver:selTE stats:selTEStats yardsGained:yardsGain];
            
            if (!gotTD && !gotFumble) {
                if (pbpEnabled) {
                    [gameEventLog appendString:[NSString stringWithFormat:@"%@%@ QB %@ pass %@ to TE %@ for %d yards.", [self getEventPrefix: yardsGain],offense.abbreviation,selQB.name,[self retrieveRandomPassDirection],selTE.name, yardsGain]];
                }
                //check downs
                gameYardsNeed -= yardsGain;
                gameYardLine += yardsGain;
                if ( gameYardsNeed <= 0) {
                    gameDown = 1;
                    gameYardsNeed = 10;
                } else gameDown++;
                gameTime -= [self calculateSecondsPerPlay:offense.offensiveStrategy];
            }
        }
    } else {
        //no completion, advance downs
        if (pbpEnabled) {
            [gameEventLog appendString:[NSString stringWithFormat:@"%@%@ QB %@ pass incomplete %@ to TE %@.", [self getEventPrefix: yardsGain],offense.abbreviation,selQB.name,[self retrieveRandomPassDirection],selTE.name]];
        }
        [self passAttempt:offense defense:defense selectedDL:selDL selectedLB:selLB selectedCB:selCB selectedS:selS receiver:selTE stats:selTEStats yardsGained:yardsGain];
        gameDown++;
        gameTime -= [self calculateSecondsPerPlay:offense.offensiveStrategy];
        return;
    }
    
    if ( gotTD ) {
        [self kickXP:offense defense:defense];
        gameTime -= [self calculateSecondsPerPlay:offense.offensiveStrategy];
        if (!playingOT) {
            [self kickOff:offense];
        } else {
            [self resetForOT];
        }
        return;
    } else if ( gotFumble ) {
        NSArray *defenders = @[selS,selCB,selDL,selLB];
        NSMutableDictionary *playerPrefs = [NSMutableDictionary dictionary];
        for (Player *p in defenders) {
            [playerPrefs setObject:@([self calculatePlayerPreferenceForPlayer:p inGameSituation:FCGameSituationFumble relatedPlayer:selTE yardsGained:yardsGain]) forKey:[p uniqueIdentifier]];
        }
        
        NSArray *sortedDefenderIds = [playerPrefs keysSortedByValueUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj2 compare:obj1];
        }];
        
        Player *defender = defenders[0];
        for (Player *p in defenders) {
            if ([[p uniqueIdentifier] isEqualToString:sortedDefenderIds[0]]) {
                defender = p;
                break;
            }
        }
        // add game stats
        [self _addGameStat:FCDefensiveStatForcedFum forDefender:defender onDefense:defense amount:1];
        
        [gameEventLog  appendString:[NSString stringWithFormat:@"%@TURNOVER!\n%@ QB %@ pass %@ to TE %@ for %d yards. FUMBLES (forced by %@ %@ %@), recovered by %@.",[self getEventPrefix: yardsGain], offense.abbreviation, selQB.name, [self retrieveRandomPassDirection], selTE.name, yardsGain, defender.team.abbreviation,defender.position,defender.name, defense.abbreviation]];
        
        NSNumber *wrFum = selTEStats[FCWRStatFumbles];
        wrFum = [NSNumber numberWithInteger:wrFum.integerValue + 1];
        [selTEStats replaceObjectAtIndex:FCWRStatFumbles withObject:wrFum];
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
            gameTime -= [self calculateSecondsPerPlay:offense.offensiveStrategy];
            return;
        } else {
            [self resetForOT];
            return;
        }
    }
}


-(void)passingPlayWR:(Team *)offense defense:(Team *)defense selQB:(PlayerQB*)selQB selWR:(PlayerWR*)selWR selWRStats:(NSMutableArray*)selWRStats selCB:(PlayerCB*)selCB selS:(PlayerS*)selS selLB:(PlayerLB*)selLB selDL:(PlayerDL*)selDL {
    int yardsGain = 0;
    BOOL gotTD = false;
    BOOL gotFumble = false;
    
    //get how much pressure there is on qb, check if sack
    int pressureOnQB = [defense getCompositeF7Pass] * 2 - [offense getCompositeOLPass] - [self getHFAdv] + (defense.defensiveStrategy.runProtection * 2 - offense.offensiveStrategy.runProtection);
    if ([HBSharedUtils randomValue]*100 < pressureOnQB/8 ) {
        //sacked!
        [self qbSack:offense defense:defense selectedDL:selDL selectedLB:selLB selectedCB:selCB selectedS:selS];
        return;
    }
    
    //check for int
    double intChance = ((pressureOnQB + selS.ratOvr + defense.defensiveStrategy.passProtection - (selQB.ratPassAcc + selQB.ratFootIQ + 100 + offense.offensiveStrategy.passProtection) / 3) / 25);
    if (intChance < 0.015) intChance = 0.015;
    if ( 100* [HBSharedUtils randomValue] < intChance ) {
        //Interception
        [self qbInterception:offense defense:defense selectedDL:selDL selectedLB:selLB selectedCB:selCB selectedS:selS selectedReceiver:selWR];
        
        gameTime -= [self calculateSecondsPerPlay:offense.offensiveStrategy];
        [offense getQB:0].statsInt++;
        [offense getQB:0].statsPassAtt++;
        if (!playingOT) {
            gameDown = 1;
            gameYardsNeed = 10;
            gamePoss = !gamePoss;
            gameYardLine = 100 - gameYardLine;
        } else {
            [self resetForOT];
        }
        return;
    }
    
    //throw ball, check for completion
    double completion = ([self getHFAdv] + (int) ([HBSharedUtils randomValue]) + [self normalize:[offense getQB:0].ratPassAcc] + [self normalize:selWR.ratRecCat] - [self normalize:selCB.ratCBCov]) / 2 + 18.25 - pressureOnQB / 16.8 + offense.offensiveStrategy.passProtection - defense.defensiveStrategy.passProtection;
    if ( 100* [HBSharedUtils randomValue] < completion ) {
        if ( 100* [HBSharedUtils randomValue] < (100 - selWR.ratRecCat)/3 ) {
            //drop
            if (pbpEnabled) {
                [gameEventLog appendString:[NSString stringWithFormat:@"%@%@ QB %@ pass incomplete %@ to WR %@.", [self getEventPrefix: yardsGain],offense.abbreviation,selQB.name,[self retrieveRandomPassDirection],selWR.name]];
            }
            gameDown++;
            NSNumber *wrStat = selWRStats[FCWRStatDrops];
            wrStat = [NSNumber numberWithInteger:wrStat.integerValue + 1];
            [selWRStats replaceObjectAtIndex:FCWRStatDrops withObject:wrStat];
            selWR.statsDrops++;
            [self passAttempt:offense defense:defense selectedDL:selDL selectedLB:selLB selectedCB:selCB selectedS:selS receiver:selWR stats:selWRStats yardsGained:yardsGain];
            gameTime -= [self calculateSecondsPerPlay:offense.offensiveStrategy];
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

            if ( (gameYardLine + yardsGain) >= 100 ) { //TD!
                yardsGain = abs(gameYardLine - 100);
//                gameYardLine = 100 - yardsGain;
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
            
            //stats management
            [self passCompletion:offense defense:defense selectedDL:selDL selectedLB:selLB selectedCB:selCB selectedS:selS receiver:selWR stats:selWRStats yardsGained:yardsGain];
            
            
            if (!gotTD && !gotFumble) {
                if (pbpEnabled) {
                    [gameEventLog appendString:[NSString stringWithFormat:@"%@%@ QB %@ pass %@ to %@ %@ for %d yards.",[self getEventPrefix: yardsGain],offense.abbreviation,[offense getQB:0].name, [self retrieveRandomPassDirection],selWR.position, selWR.name, yardsGain]];
                }
                //check downs
                gameYardLine += yardsGain;
                gameYardsNeed -= yardsGain;
                if ( gameYardsNeed <= 0) {
                    gameDown = 1;
                    gameYardsNeed = 10;
                } else gameDown++;
            }
        }
        
    } else {
        //no completion, advance downs
        if (pbpEnabled) {
            [gameEventLog appendString:[NSString stringWithFormat:@"%@%@ QB %@ pass incomplete %@ to %@ %@.",[self getEventPrefix: yardsGain],offense.abbreviation,[offense getQB:0].name, [self retrieveRandomPassDirection],selWR.position, selWR.name]];
        }
        [self passAttempt:offense defense:defense selectedDL:selDL selectedLB:selLB selectedCB:selCB selectedS:selS receiver:selWR stats:selWRStats yardsGained:yardsGain];

        gameDown++;
        gameTime -= [self calculateSecondsPerPlay:offense.offensiveStrategy];
        return;
    }
    
    
    if ( gotFumble ) {
        NSArray *defenders = @[selS,selCB,selDL,selLB];
        NSMutableDictionary *playerPrefs = [NSMutableDictionary dictionary];
        for (Player *p in defenders) {
            [playerPrefs setObject:@([self calculatePlayerPreferenceForPlayer:p inGameSituation:FCGameSituationFumble relatedPlayer:selWR yardsGained:yardsGain]) forKey:[p uniqueIdentifier]];
        }
        
        NSArray *sortedDefenderIds = [playerPrefs keysSortedByValueUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj2 compare:obj1];
        }];
        
        Player *defender = defenders[0];
        for (Player *p in defenders) {
            if ([[p uniqueIdentifier] isEqualToString:sortedDefenderIds[0]]) {
                defender = p;
                break;
            }
        }
        // add game stats
        [self _addGameStat:FCDefensiveStatForcedFum forDefender:defender onDefense:defense amount:1];
        
        [gameEventLog  appendString:[NSString stringWithFormat:@"%@TURNOVER!\n%@ QB %@ pass %@ to WR %@ for %d yards. FUMBLES (forced by %@ %@ %@), recovered by %@.",[self getEventPrefix: yardsGain], offense.abbreviation, selQB.name, [self retrieveRandomPassDirection], selWR.name, yardsGain, defender.team.abbreviation,defender.position,defender.name, defense.abbreviation]];
        NSNumber *wrFum = selWRStats[FCWRStatFumbles];
        wrFum = [NSNumber numberWithInteger:wrFum.integerValue + 1];
        [selWRStats replaceObjectAtIndex:FCWRStatFumbles withObject:wrFum];
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
            gameTime -= [self calculateSecondsPerPlay:offense.offensiveStrategy];
            return;
        } else {
            [self resetForOT];
            return;
        }
    }
    
    if ( gotTD ) {
        [self kickXP:offense defense:defense];
        gameTime -= [self calculateSecondsPerPlay:offense.offensiveStrategy];
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
        [self _rushingPlayRB:offense defense:defense selRB:selRB selDL:selDL selTE:selTE selCB:selCB selLB:selLB selS:selS RB1pref:RB1pref RB2pref:RB2pref];
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
    if ( gameYardLine + yardsGain >= 100 ) { //TD!
        [self addPointsQuarter:6];
        
        selQB.statsRushTD++;
        if ( gamePoss ) { // home possession
            homeScore += 6;
            NSNumber *kStat1 = HomeQBStats[FCQBStatRushTD];
            kStat1 = [NSNumber numberWithInteger:kStat1.integerValue + 1];
            [HomeQBStats replaceObjectAtIndex:FCQBStatRushTD withObject:kStat1];
        } else {
            awayScore += 6;
            NSNumber *kStat1 = AwayQBStats[FCQBStatRushTD];
            kStat1 = [NSNumber numberWithInteger:kStat1.integerValue + 1];
            [AwayQBStats replaceObjectAtIndex:FCQBStatRushTD withObject:kStat1];
        }
        
        NSString *rushDirection = [self retreiveRandomRushDirection];
        if (yardsGain != 1) {
            tdInfo = [NSString stringWithFormat:@"%@ QB %@ %@ for %d yards, TOUCHDOWN.", offense.abbreviation,selQB.name,rushDirection, yardsGain];
        } else {
            tdInfo = [NSString stringWithFormat:@"%@ QB %@ %@ for %d yard, TOUCHDOWN.", offense.abbreviation,selQB.name,rushDirection, yardsGain];
        }
        
        gotTD = true;
        yardsGain = abs(gameYardLine - 100);
        gameYardLine = 100 - yardsGain;
    }
    
    //stats management
    [self rushAttemptQB:offense defense:defense selectedDL:selDL selectedLB:selLB selectedCB:selCB selectedS:selS rusher:selQB yardsGained:yardsGain];
    
    double fumChance = (selS.ratSTkl + [defense getCompositeF7Rush] - [self getHFAdv])/2 + offense.offensiveStrategy.runProtection;
    
    if ( gotTD ) {
        [self kickXP:offense defense:defense];
        gameTime -= [self calculateSecondsPerPlay:offense.offensiveStrategy];
        if (!playingOT) {
            [self kickOff:offense];
        } else {
            [self resetForOT];
        }
    } else if (!gotTD && ( 100* [HBSharedUtils randomValue] < fumChance/40 )) {
        gameTime -= 25 + 15* [HBSharedUtils randomValue];
        NSArray *defenders = @[selS,selCB,selDL,selLB];
        NSMutableDictionary *playerPrefs = [NSMutableDictionary dictionary];
        for (Player *p in defenders) {
            [playerPrefs setObject:@([self calculatePlayerPreferenceForPlayer:p inGameSituation:FCGameSituationFumble relatedPlayer:selTE yardsGained:yardsGain]) forKey:[p uniqueIdentifier]];
        }
        
        NSArray *sortedDefenderIds = [playerPrefs keysSortedByValueUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj2 compare:obj1];
        }];
        
        Player *defender = defenders[0];
        for (Player *p in defenders) {
            if ([[p uniqueIdentifier] isEqualToString:sortedDefenderIds[0]]) {
                defender = p;
                break;
            }
        }
        // add game stats
        [self _addGameStat:FCDefensiveStatForcedFum forDefender:defender onDefense:defense amount:1];
        
        //Fumble!
        selQB.statsFumbles++;
        if ( gamePoss ) {
            homeTOs++;
            NSNumber *kStat1 = HomeQBStats[FCQBStatFumbles];
            kStat1 = [NSNumber numberWithInteger:kStat1.integerValue + 1];
            [HomeQBStats replaceObjectAtIndex:FCQBStatFumbles withObject:kStat1];
        } else {
            awayTOs++;
            NSNumber *kStat1 = AwayQBStats[FCQBStatFumbles];
            kStat1 = [NSNumber numberWithInteger:kStat1.integerValue + 1];
            [AwayQBStats replaceObjectAtIndex:FCQBStatFumbles withObject:kStat1];
        }
        
        
        NSString *rushDirection = [self retreiveRandomRushDirection];
        [gameEventLog  appendString:[NSString stringWithFormat:@"%@TURNOVER!\n%@ QB %@ %@ for %d yards. FUMBLES (forced by %@ %@ %@), recovered by %@.",[self getEventPrefix: yardsGain], offense.abbreviation, selQB.name, rushDirection, yardsGain, defender.team.abbreviation,defender.position,defender.name, defense.abbreviation]];
        
        if (!playingOT) {
            gameDown = 1;
            gameYardsNeed = 10;
            gamePoss = !gamePoss;
            gameYardLine = 100 - gameYardLine;
        } else {
            [self resetForOT];
        }
    } else {
        if (pbpEnabled) {
            if (yardsGain > 0) {
                [gameEventLog appendFormat:@"%@%@ QB %@ %@ for %d yards.", [self getEventPrefix: yardsGain],offense.abbreviation, [offense getQB:0].name, [self retreiveRandomRushDirection], yardsGain];
            } else if (yardsGain == 1 || yardsGain == -1) {
                [gameEventLog appendFormat:@"%@%@ QB %@ %@ for %d yard.", [self getEventPrefix: yardsGain],offense.abbreviation, [offense getQB:0].name, [self retreiveRandomRushDirection], yardsGain];
            } else {
                [gameEventLog appendFormat:@"%@%@ QB %@ %@ for no gain.", [self getEventPrefix: yardsGain], offense.abbreviation, [offense getQB:0].name, [self retreiveRandomRushDirection]];
            }
        }
        
        gameYardsNeed -= yardsGain;
        gameYardLine += yardsGain;
        if ( gameYardsNeed <= 0 ) {
            gameDown = 1;
            gameYardsNeed = 10;
        } else gameDown++;
        gameTime -= [self calculateSecondsPerPlay:offense.offensiveStrategy];
    }
}

-(NSString *)retreiveRandomRushDirection {
    static dispatch_once_t onceToken;
    static NSArray *directions;
    dispatch_once(&onceToken, ^{
        directions = @[@"up the middle", @"left tackle", @"right tackle", @"right guard", @"left guard"];
    });
    return directions[(int)([HBSharedUtils randomValue] * directions.count)];
}

-(NSString *)retrieveRandomPassDirection {
    static dispatch_once_t onceToken;
    static NSArray *directions;
    dispatch_once(&onceToken, ^{
        directions = @[@"right", @"left", @"middle"];
    });
    return directions[(int)([HBSharedUtils randomValue] * directions.count)];
}

-(void)_rushingPlayRB:(Team*)offense defense:(Team*)defense selRB:(PlayerRB*)selRB selDL:(PlayerDL*)selDL selTE:(PlayerTE*)selTE selCB:(PlayerCB*)selCB selLB:(PlayerLB*)selLB selS:(PlayerS*)selS RB1pref:(double)RB1pref RB2pref:(double)RB2pref {
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

    if ( (gameYardLine + yardsGain) >= 100 ) { //TD!
        [self addPointsQuarter:6];
        yardsGain = abs(gameYardLine - 100);
        if ( gamePoss ) { // home possession
            homeScore += 6;
            if (RB1pref > RB2pref) {
                NSNumber *kStat1 = HomeRB1Stats[FCRBStatRushTD];
                kStat1 = [NSNumber numberWithInteger:kStat1.integerValue + 1];
                [HomeRB1Stats replaceObjectAtIndex:FCRBStatRushTD withObject:kStat1];
            } else {
                NSNumber *kStat1 = HomeRB2Stats[FCRBStatRushTD];
                kStat1 = [NSNumber numberWithInteger:kStat1.integerValue + 1];
                [HomeRB2Stats replaceObjectAtIndex:FCRBStatRushTD withObject:kStat1];
            }
        } else {
            awayScore += 6;
            if (RB1pref > RB2pref) {
                NSNumber *kStat1 = AwayRB1Stats[FCRBStatRushTD];
                kStat1 = [NSNumber numberWithInteger:kStat1.integerValue + 1];
                [AwayRB1Stats replaceObjectAtIndex:FCRBStatRushTD withObject:kStat1];
            } else {
                NSNumber *kStat1 = AwayRB2Stats[FCRBStatRushTD];
                kStat1 = [NSNumber numberWithInteger:kStat1.integerValue + 1];
                [AwayRB2Stats replaceObjectAtIndex:FCRBStatRushTD withObject:kStat1];
            }
        }
        
        NSString *rushDirection = [self retreiveRandomRushDirection];
        if (yardsGain != 1) {
            tdInfo = [NSString stringWithFormat:@"%@ RB %@ %@ for %d yards, TOUCHDOWN. ", offense.abbreviation,selRB.name,rushDirection, yardsGain];
        } else {
            tdInfo = [NSString stringWithFormat:@"%@ RB %@ %@ for %d yard, TOUCHDOWN. ", offense.abbreviation,selRB.name,rushDirection, yardsGain];
        }
        selRB.statsTD++;
        //offense.teamPoints += 6;
        //defense.teamOppPoints += 6;
//        gameYardLine = 100 - yardsGain;
        gotTD = true;
    }
    //stats management
    [self rushAttempt:offense defense:defense selectedDL:selDL selectedLB:selLB selectedCB:selCB selectedS:selS rusher:selRB rb1Pref:RB1pref rb2Pref:RB2pref yardsGained:yardsGain];
    double fumChance = (selS.ratSTkl + [defense getCompositeF7Rush] - [self getHFAdv])/2 + offense.offensiveStrategy.runProtection;
    
    if ( gotTD ) {
        [self kickXP:offense defense:defense];
        gameTime -= [self calculateSecondsPerPlay:offense.offensiveStrategy];
        if (!playingOT) {
            [self kickOff:offense];
        } else {
            [self resetForOT];
        }
    } else if (!gotTD && ( 100* [HBSharedUtils randomValue] < fumChance/40 )) {
        //Fumble!
        
        NSArray *defenders = @[selS,selCB,selDL,selLB];
        NSMutableDictionary *playerPrefs = [NSMutableDictionary dictionary];
        for (Player *p in defenders) {
            [playerPrefs setObject:@([self calculatePlayerPreferenceForPlayer:p inGameSituation:FCGameSituationFumble relatedPlayer:selTE yardsGained:yardsGain]) forKey:[p uniqueIdentifier]];
        }
        
        NSArray *sortedDefenderIds = [playerPrefs keysSortedByValueUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj2 compare:obj1];
        }];
        
        Player *defender = defenders[0];
        for (Player *p in defenders) {
            if ([[p uniqueIdentifier] isEqualToString:sortedDefenderIds[0]]) {
                defender = p;
                break;
            }
        }
        // add game stats
        [self _addGameStat:FCDefensiveStatForcedFum forDefender:defender onDefense:defense amount:1];
        
        if ( gamePoss ) {
            homeTOs++;
            if (RB1pref > RB2pref) {
                NSNumber *kStat1 = HomeRB1Stats[FCRBStatFumbles];
                kStat1 = [NSNumber numberWithInteger:kStat1.integerValue + 1];
                [HomeRB1Stats replaceObjectAtIndex:FCRBStatFumbles withObject:kStat1];
            } else {
                NSNumber *kStat1 = HomeRB2Stats[FCRBStatFumbles];
                kStat1 = [NSNumber numberWithInteger:kStat1.integerValue + 1];
                [HomeRB2Stats replaceObjectAtIndex:FCRBStatFumbles withObject:kStat1];
            }
        } else {
            awayTOs++;
            if (RB1pref > RB2pref) {
                NSNumber *kStat1 = AwayRB1Stats[FCRBStatFumbles];
                kStat1 = [NSNumber numberWithInteger:kStat1.integerValue + 1];
                [AwayRB1Stats replaceObjectAtIndex:FCRBStatFumbles withObject:kStat1];
            } else {
                NSNumber *kStat1 = AwayRB2Stats[FCRBStatFumbles];
                kStat1 = [NSNumber numberWithInteger:kStat1.integerValue + 1];
                [AwayRB2Stats replaceObjectAtIndex:FCRBStatFumbles withObject:kStat1];
            }
        }
        
        [gameEventLog  appendString:[NSString stringWithFormat:@"%@%@ RB %@ %@ for %d yards. FUMBLES (forced by %@ %@ %@), RECOVERED by %@.",[self getEventPrefix: yardsGain], offense.abbreviation, selRB.name, [self retreiveRandomRushDirection],yardsGain, defender.team.abbreviation,defender.position,defender.name,defender.team.abbreviation]];
//        gameTime -= 25 + 15* [HBSharedUtils randomValue];
        selRB.statsFumbles++;
        if (!playingOT) {
            gameDown = 1;
            gameYardsNeed = 10;
            gamePoss = !gamePoss;
            gameYardLine = 100 - gameYardLine;
            gameTime -= [self calculateSecondsPerPlay:offense.offensiveStrategy];
        } else {
            [self resetForOT];
        }
    } else {
        if (pbpEnabled) {
            if (yardsGain > 0) {
                [gameEventLog appendFormat:@"%@%@ RB %@ %@ for %d yards.", [self getEventPrefix: yardsGain],offense.abbreviation, selRB.name, [self retreiveRandomRushDirection], yardsGain];
            } else if (yardsGain == 1 || yardsGain == -1) {
                [gameEventLog appendFormat:@"%@%@ RB %@ %@ for %d yard.", [self getEventPrefix: yardsGain],offense.abbreviation, selRB.name, [self retreiveRandomRushDirection], yardsGain];
            } else {
                [gameEventLog appendFormat:@"%@%@ RB %@ %@ for no gain.", [self getEventPrefix: yardsGain], offense.abbreviation, selRB.name, [self retreiveRandomRushDirection]];
            }
        }
        gameYardsNeed -= yardsGain;
        gameYardLine += yardsGain;
        if ( gameYardsNeed <= 0 ) {
            gameDown = 1;
            gameYardsNeed = 10;
        } else gameDown++;
        gameTime -= [self calculateSecondsPerPlay:offense.offensiveStrategy];
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
            NSNumber *kStat1 = HomeKStats[FCKStatFGAtt];
            kStat1 = [NSNumber numberWithInteger:kStat1.integerValue + 1];
            [HomeKStats replaceObjectAtIndex:FCKStatFGAtt withObject:kStat1];
            
            NSNumber *kStat2 = HomeKStats[FCKStatFGMade];
            kStat2 = [NSNumber numberWithInteger:kStat2.integerValue + 1];
            [HomeKStats replaceObjectAtIndex:FCKStatFGMade withObject:kStat2];
        } else {
            awayScore += 3;
            NSNumber *kStat1 = AwayKStats[FCKStatFGAtt];
            kStat1 = [NSNumber numberWithInteger:kStat1.integerValue + 1];
            [AwayKStats replaceObjectAtIndex:FCKStatFGAtt withObject:kStat1];
            
            NSNumber *kStat2 = AwayKStats[FCKStatFGMade];
            kStat2 = [NSNumber numberWithInteger:kStat2.integerValue + 1];
            [AwayKStats replaceObjectAtIndex:FCKStatFGMade withObject:kStat2];
        }
        [gameEventLog appendString:[NSString stringWithFormat:@"%@%@ K %@ %d-yard field goal is GOOD.",[self getEventPrefix], offense.abbreviation, [offense getK:0].name, (117-gameYardLine)]];
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
        
        [gameEventLog appendString:[NSString stringWithFormat:@"%@%@ K %@ %d-yard field goal is NO GOOD.",[self getEventPrefix], offense.abbreviation, [offense getK:0].name, (117-gameYardLine)]];
        [offense getK:0].statsFGAtt++;
        if ( gamePoss ) { // home possession
            NSNumber *kStat1 = HomeKStats[FCKStatFGAtt];
            kStat1 = [NSNumber numberWithInteger:kStat1.integerValue + 1];
            [HomeKStats replaceObjectAtIndex:FCKStatFGAtt withObject:kStat1];
        } else {
            NSNumber *kStat1 = AwayKStats[FCKStatFGAtt];
            kStat1 = [NSNumber numberWithInteger:kStat1.integerValue + 1];
            [AwayKStats replaceObjectAtIndex:FCKStatFGAtt withObject:kStat1];
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
                        [gameEventLog appendString:[NSString stringWithFormat:@"%@%@TWO-POINT CONVERSION ATTEMPT. %@ left-tackle for 2 yards. ATTEMPT SUCCEEDS.",[self getEventPrefix: yardsGain],tdInfo,[offense getRB:0].name]];
                    } else {
                        [gameEventLog appendString:[NSString stringWithFormat:@"%@%@TWO-POINT CONVERSION ATTEMPT. %@ stopped at the line of scrimmage. ATTEMPT FAILS.",[self getEventPrefix: yardsGain],tdInfo,[offense getRB:0].name]];
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
                        [gameEventLog appendString:[NSString stringWithFormat:@"%@%@TWO-POINT CONVERSION ATTEMPT. %@ pass complete to %@. ATTEMPT SUCCEEDS.",[self getEventPrefix],tdInfo,[offense getQB:0].name, [offense getWR:0].name]];
                    } else {
                        [gameEventLog appendString:[NSString stringWithFormat:@"%@%@TWO-POINT CONVERSION ATTEMPT. %@ pass incomplete to %@. ATTEMPT FAILS.",[self getEventPrefix],tdInfo,[offense getQB:0].name, [offense getWR:0].name]];
                    }
                }
            } else {
                //kick XP
                if ( [HBSharedUtils randomValue]*100 < 23 + [offense getK:0].ratKickAcc && [HBSharedUtils randomValue] > 0.01 ) {
                    //made XP
                    if ( gamePoss ) { // home possession
                        homeScore += 1;
                        NSNumber *kStat1 = HomeKStats[FCKStatXPMade];
                        kStat1 = [NSNumber numberWithInteger:kStat1.integerValue + 1];
                        [HomeKStats replaceObjectAtIndex:FCKStatXPMade withObject:kStat1];
                        
                        NSNumber *kStat2 = HomeKStats[FCKStatXPAtt];
                        kStat2 = [NSNumber numberWithInteger:kStat2.integerValue + 1];
                        [HomeKStats replaceObjectAtIndex:FCKStatXPAtt withObject:kStat2];
                    } else {
                        awayScore += 1;
                        NSNumber *kStat1 = AwayKStats[FCKStatXPMade];
                        kStat1 = [NSNumber numberWithInteger:kStat1.integerValue + 1];
                        [AwayKStats replaceObjectAtIndex:FCKStatXPMade withObject:kStat1];
                        
                        NSNumber *kStat2 = AwayKStats[FCKStatXPAtt];
                        kStat2 = [NSNumber numberWithInteger:kStat2.integerValue + 1];
                        [AwayKStats replaceObjectAtIndex:FCKStatXPAtt withObject:kStat2];
                    }
                    
                    [gameEventLog appendString:[NSString stringWithFormat:@"%@%@ K %@ extra point is GOOD.",[self getEventPrefix],tdInfo,[offense getK:0].name]];
                    [self addPointsQuarter:1];
                    [offense getK:0].statsXPMade++;
                } else {
                    [gameEventLog appendString:[NSString stringWithFormat:@"%@%@ K %@ extra point is NO GOOD.",[self getEventPrefix],tdInfo,[offense getK:0].name]];
                    // missed XP
                    if ( gamePoss ) { // home possession
                        NSNumber *kStat2 = HomeKStats[FCKStatXPAtt];
                        kStat2 = [NSNumber numberWithInteger:kStat2.integerValue + 1];
                        [HomeKStats replaceObjectAtIndex:FCKStatXPAtt withObject:kStat2];
                    } else {
                        NSNumber *kStat2 = AwayKStats[FCKStatXPAtt];
                        kStat2 = [NSNumber numberWithInteger:kStat2.integerValue + 1];
                        [AwayKStats replaceObjectAtIndex:FCKStatXPAtt withObject:kStat2];
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
                                [gameEventLog appendString:[NSString stringWithFormat:@"%@%@TWO-POINT CONVERSION ATTEMPT. %@ left-tackle for 2 yards. ATTEMPT SUCCEEDS.",[self getEventPrefix: yardsGain],tdInfo,[offense getRB:0].name]];
                            } else {
                                [gameEventLog appendString:[NSString stringWithFormat:@"%@%@TWO-POINT CONVERSION ATTEMPT. %@ stopped at the line of scrimmage. ATTEMPT FAILS.",[self getEventPrefix: yardsGain],tdInfo,[offense getRB:0].name]];
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
                                [gameEventLog appendString:[NSString stringWithFormat:@"%@%@TWO-POINT CONVERSION ATTEMPT. %@ pass complete to %@. ATTEMPT SUCCEEDS.",[self getEventPrefix],tdInfo,[offense getQB:0].name, [offense getWR:0].name]];
                            } else {
                                [gameEventLog appendString:[NSString stringWithFormat:@"%@%@TWO-POINT CONVERSION ATTEMPT. %@ pass incomplete to %@. ATTEMPT FAILS.",[self getEventPrefix],tdInfo,[offense getQB:0].name, [offense getWR:0].name]];
                            }
                        }
                    } else {
                        //kick XP
                        if ( [HBSharedUtils randomValue]*100 < 23 + [offense getK:0].ratKickAcc && [HBSharedUtils randomValue] > 0.01 ) {
                            //made XP
                            if ( gamePoss ) { // home possession
                                homeScore += 1;
                                NSNumber *kStat1 = HomeKStats[FCKStatXPMade];
                                kStat1 = [NSNumber numberWithInteger:kStat1.integerValue + 1];
                                [HomeKStats replaceObjectAtIndex:FCKStatXPMade withObject:kStat1];
                                
                                NSNumber *kStat2 = HomeKStats[FCKStatXPAtt];
                                kStat2 = [NSNumber numberWithInteger:kStat2.integerValue + 1];
                                [HomeKStats replaceObjectAtIndex:FCKStatXPAtt withObject:kStat2];
                            } else {
                                awayScore += 1;
                                NSNumber *kStat1 = AwayKStats[FCKStatXPMade];
                                kStat1 = [NSNumber numberWithInteger:kStat1.integerValue + 1];
                                [AwayKStats replaceObjectAtIndex:FCKStatXPMade withObject:kStat1];
                                
                                NSNumber *kStat2 = AwayKStats[FCKStatXPAtt];
                                kStat2 = [NSNumber numberWithInteger:kStat2.integerValue + 1];
                                [AwayKStats replaceObjectAtIndex:FCKStatXPAtt withObject:kStat2];
                            }
                            
                            [gameEventLog appendString:[NSString stringWithFormat:@"%@%@ K %@ extra point is GOOD.",[self getEventPrefix],tdInfo,[offense getK:0].name]];
                            [self addPointsQuarter:1];
                            [offense getK:0].statsXPMade++;
                        } else {
                            [gameEventLog appendString:[NSString stringWithFormat:@"%@%@ K %@ extra point is NO GOOD.",[self getEventPrefix],tdInfo,[offense getK:0].name]];
                            // missed XP
                            if ( gamePoss ) { // home possession
                                NSNumber *kStat2 = HomeKStats[FCKStatXPAtt];
                                kStat2 = [NSNumber numberWithInteger:kStat2.integerValue + 1];
                                [HomeKStats replaceObjectAtIndex:FCKStatXPAtt withObject:kStat2];
                            } else {
                                NSNumber *kStat2 = AwayKStats[FCKStatXPAtt];
                                kStat2 = [NSNumber numberWithInteger:kStat2.integerValue + 1];
                                [AwayKStats replaceObjectAtIndex:FCKStatXPAtt withObject:kStat2];
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
                            [gameEventLog appendString:[NSString stringWithFormat:@"%@%@TWO-POINT CONVERSION ATTEMPT. %@ left-tackle for 2 yards. ATTEMPT SUCCEEDS.",[self getEventPrefix: yardsGain],tdInfo,[offense getRB:0].name]];
                        } else {
                            [gameEventLog appendString:[NSString stringWithFormat:@"%@%@TWO-POINT CONVERSION ATTEMPT. %@ stopped at the line of scrimmage. ATTEMPT FAILS.",[self getEventPrefix: yardsGain],tdInfo,[offense getRB:0].name]];
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
                            [gameEventLog appendString:[NSString stringWithFormat:@"%@%@TWO-POINT CONVERSION ATTEMPT. %@ pass complete to %@. ATTEMPT SUCCEEDS.",[self getEventPrefix],tdInfo,[offense getQB:0].name, [offense getWR:0].name]];
                        } else {
                            [gameEventLog appendString:[NSString stringWithFormat:@"%@%@TWO-POINT CONVERSION ATTEMPT. %@'s pass incomplete to %@. ATTEMPT FAILS.",[self getEventPrefix],tdInfo,[offense getQB:0].name, [offense getWR:0].name]];
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
                            [gameEventLog appendString:[NSString stringWithFormat:@"%@%@TWO-POINT CONVERSION ATTEMPT. %@ left-tackle for 2 yards. ATTEMPT SUCCEEDS.",[self getEventPrefix: yardsGain],tdInfo,[offense getRB:0].name]];
                        } else {
                            [gameEventLog appendString:[NSString stringWithFormat:@"%@%@TWO-POINT CONVERSION ATTEMPT. %@ stopped at the line of scrimmage. ATTEMPT FAILS.",[self getEventPrefix: yardsGain],tdInfo,[offense getRB:0].name]];
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
                            [gameEventLog appendString:[NSString stringWithFormat:@"%@%@TWO-POINT CONVERSION ATTEMPT. %@ pass complete to %@. ATTEMPT SUCCEEDS.",[self getEventPrefix],tdInfo,[offense getQB:0].name, [offense getWR:0].name]];
                        } else {
                            [gameEventLog appendString:[NSString stringWithFormat:@"%@%@TWO-POINT CONVERSION ATTEMPT. %@'s pass incomplete to %@. ATTEMPT FAILS.",[self getEventPrefix],tdInfo,[offense getQB:0].name, [offense getWR:0].name]];
                        }
                    }
                } else {
                    //kick XP
                    if ( [HBSharedUtils randomValue]*100 < 23 + [offense getK:0].ratKickAcc && [HBSharedUtils randomValue] > 0.01 ) {
                        //made XP
                        if ( gamePoss ) { // home possession
                            homeScore += 1;
                            NSNumber *kStat1 = HomeKStats[FCKStatXPMade];
                            kStat1 = [NSNumber numberWithInteger:kStat1.integerValue + 1];
                            [HomeKStats replaceObjectAtIndex:FCKStatXPMade withObject:kStat1];
                            
                            NSNumber *kStat2 = HomeKStats[FCKStatXPAtt];
                            kStat2 = [NSNumber numberWithInteger:kStat2.integerValue + 1];
                            [HomeKStats replaceObjectAtIndex:FCKStatXPAtt withObject:kStat2];
                        } else {
                            awayScore += 1;
                            NSNumber *kStat1 = AwayKStats[FCKStatXPMade];
                            kStat1 = [NSNumber numberWithInteger:kStat1.integerValue + 1];
                            [AwayKStats replaceObjectAtIndex:FCKStatXPMade withObject:kStat1];
                            
                            NSNumber *kStat2 = AwayKStats[FCKStatXPAtt];
                            kStat2 = [NSNumber numberWithInteger:kStat2.integerValue + 1];
                            [AwayKStats replaceObjectAtIndex:FCKStatXPAtt withObject:kStat2];
                        }
                        
                        [gameEventLog appendString:[NSString stringWithFormat:@"%@%@K %@ extra point is GOOD.",[self getEventPrefix],tdInfo,[[offense getK:0] getInitialName]]];
                        [self addPointsQuarter:1];
                        [offense getK:0].statsXPMade++;
                    } else {
                        [gameEventLog appendString:[NSString stringWithFormat:@"%@%@K %@ extra point is NO GOOD.",[self getEventPrefix],tdInfo,[[offense getK:0] getInitialName]]];
                        // missed XP
                        if ( gamePoss ) { // home possession
                            NSNumber *kStat2 = HomeKStats[FCKStatXPAtt];
                            kStat2 = [NSNumber numberWithInteger:kStat2.integerValue + 1];
                            [HomeKStats replaceObjectAtIndex:FCKStatXPAtt withObject:kStat2];
                        } else {
                            NSNumber *kStat2 = AwayKStats[FCKStatXPAtt];
                            kStat2 = [NSNumber numberWithInteger:kStat2.integerValue + 1];
                            [AwayKStats replaceObjectAtIndex:FCKStatXPAtt withObject:kStat2];
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
                        [gameEventLog appendString:[NSString stringWithFormat:@"%@%@TWO-POINT CONVERSION ATTEMPT. %@ right-tackle for 2 yards. ATTEMPT SUCCEEDS.",[self getEventPrefix: yardsGain],tdInfo,[[offense getRB:0] getInitialName]]];
                    } else {
                        [gameEventLog appendString:[NSString stringWithFormat:@"%@%@TWO-POINT CONVERSION ATTEMPT. %@ stopped at the line of scrimmage. ATTEMPT FAILS.",[self getEventPrefix: yardsGain],tdInfo,[offense getRB:0].name]];
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
                        [gameEventLog appendString:[NSString stringWithFormat:@"%@%@TWO-POINT CONVERSION ATTEMPT.  %@ pass complete to %@. ATTEMPT SUCCEEDS.",[self getEventPrefix],tdInfo,[offense getQB:0].name, [offense getWR:0].name]];
                    } else {
                        [gameEventLog appendString:[NSString stringWithFormat:@"%@%@TWO-POINT CONVERSION ATTEMPT. %@'s pass incomplete to %@. ATTEMPT FAILS.",[self getEventPrefix],tdInfo,[offense getQB:0].name, [offense getWR:0].name]];
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
                [gameEventLog appendString:[NSString stringWithFormat:@"\n\n%@ 35 | Kickoff | %@ K %@ successfully executes onside kick! %@ has possession!",offense.abbreviation,offense.abbreviation, [offense getK:0].name, offense.abbreviation]];
            } else {
                // Fail
                [gameEventLog appendString:[NSString stringWithFormat:@"\n\n%@ 35 | Kickoff | %@ K %@ failed to convert the onside kick. %@ lost possession.",offense.abbreviation, offense.abbreviation, [offense getK:0].name, offense.abbreviation]];
                gamePoss = !gamePoss;
            }
            gameYardLine = 50;
            gameDown = 1;
            gameYardsNeed = 10;
            gameTime -= (4 + (5 * [HBSharedUtils randomValue]));
        } else {
            // Just regular kick off
            int kickOffYards = (int)([offense getK:0].ratKickPow + 20 - 30* [HBSharedUtils randomValue]);
            gameYardLine = 100 - kickOffYards;
            if ( gameYardLine <= 0 ) gameYardLine = 25;
            NSString *touchback = @".";
            if (gameYardLine == 25) {
                touchback = @", Touchback.";
            }
            if (pbpEnabled) {
                [gameEventLog appendString:[NSString stringWithFormat:@"\n\n%@ 35 | Kickoff | %@ | (%@) %@ K %@ kicks %d yards%@",offense.abbreviation, [self convGameQuarter], [self convGameTimeMinute],offense.abbreviation, [offense getK:0].name, (kickOffYards - 35),touchback]];
            }
            gameDown = 1;
            gameYardsNeed = 10;
            gamePoss = !gamePoss;
            
        }
    }
}

-(void)puntPlay:(Team *)offense {
    if (pbpEnabled) {
        [gameEventLog appendString:[NSString stringWithFormat:@"%@%@ punts.",[self getEventPrefix],offense.abbreviation]];
    }
    gameYardLine = (int) (100 - ( gameYardLine + [offense getK:0].ratKickPow/3 + 20 - 10* [HBSharedUtils randomValue] ));
    if ( gameYardLine < 0 ) {
        gameYardLine = 20;
    }
    gameDown = 1;
    gameYardsNeed = 10;
    gamePoss = !gamePoss;
    
    gameTime -= 20 + 15* [HBSharedUtils randomValue];
}

-(void)qbSack:(Team *)offense defense:(Team*)defense selectedDL:(PlayerDL*)selDL selectedLB:(PlayerLB*)selLB selectedCB:(PlayerCB*)selCB selectedS:(PlayerS*)selS {
    [offense getQB:0].statsSacked++;
    int sackLoss = (3 + (int) ([HBSharedUtils randomValue] * ([self normalize:[defense getCompositeF7Pass]] - [self normalize:[offense getCompositeOLPass]]) / 2));
    if (sackLoss < 2) sackLoss = 2;
    
    if ( gamePoss ) { // home possession
        NSNumber *qbSack = HomeQBStats[FCQBStatSacked];
        qbSack = [NSNumber numberWithInteger:qbSack.integerValue + 1];
        [HomeQBStats replaceObjectAtIndex:FCQBStatSacked withObject:qbSack];
    } else {
        NSNumber *qbSack = AwayQBStats[FCQBStatSacked];
        qbSack = [NSNumber numberWithInteger:qbSack.integerValue + 1];
        [AwayQBStats replaceObjectAtIndex:FCQBStatSacked withObject:qbSack];
    }
    NSArray *defenders = @[selS,selCB,selDL,selLB];
    NSMutableDictionary *playerPrefs = [NSMutableDictionary dictionary];
    for (Player *p in defenders) {
        [playerPrefs setObject:@([self calculatePlayerPreferenceForPlayer:p inGameSituation:FCGameSituationSack relatedPlayer:[offense getQB:0] yardsGained:sackLoss]) forKey:[p uniqueIdentifier]];
    }
    
    NSArray *sortedDefenderIds = [playerPrefs keysSortedByValueUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj2 compare:obj1];
    }];
    
    Player *defender = defenders[0];
    for (Player *p in defenders) {
        if ([[p uniqueIdentifier] isEqualToString:sortedDefenderIds[0]]) {
            defender = p;
            break;
        }
    }
    // add game stats
    [self _addGameStat:FCDefensiveStatSacks forDefender:defender onDefense:defense amount:1];

    if (gameYardLine < 0) {
        // Safety!
        gameTime -= (10 * [HBSharedUtils randomValue]);
        [self safety];
    }
    
    if (pbpEnabled) {
        [gameEventLog appendString:[NSString stringWithFormat:@"%@%@ QB %@ sacked by %@ %@ %@ for a %d-yard loss.",[self getEventPrefix: sackLoss],offense.abbreviation,[offense getQB:0].name, defender.team.abbreviation,defender.position,defender.name,sackLoss]];
    }
    
    gameYardsNeed += sackLoss;
    gameYardLine -= sackLoss;
    gameTime -=  (25 + (10 * [HBSharedUtils randomValue]));
    gameDown++;
}

-(void)_addGameStat:(FCDefensiveStat)statType forDefender:(Player *)defender onDefense:(Team *)defense amount:(NSInteger)amount {
    
    if (!gamePoss) { // away is on defense
        if ([defender isKindOfClass:[PlayerCB class]]) {
            PlayerCB *cb = (PlayerCB*)defender;
//            if (statType == FCDefensiveStatTkl) {
//                cb.statsTkl++;
//            } else if (statType == FCDefensiveStatPassDef) {
//                cb.statsPassDef++;
//            } else if (statType == FCDefensiveStatINT) {
//                cb.statsInt++;
//            } else if (statType == FCDefensiveStatForcedFum) {
//                cb.statsForcedFum++;
//            } else { // sack
//                cb.statsSacks++;
//            }
            if ([defense.teamCBs indexOfObject:cb] == 0) {
                NSNumber *qbSack = HomeCB1Stats[statType];
                qbSack = [NSNumber numberWithInteger:qbSack.integerValue + amount];
                [HomeCB1Stats replaceObjectAtIndex:statType withObject:qbSack];
            } else if ([defense.teamCBs indexOfObject:cb] == 1) {
                NSNumber *qbSack = HomeCB2Stats[statType];
                qbSack = [NSNumber numberWithInteger:qbSack.integerValue + amount];
                [HomeCB2Stats replaceObjectAtIndex:statType withObject:qbSack];
            } else { // 2
                NSNumber *qbSack = HomeCB3Stats[statType];
                qbSack = [NSNumber numberWithInteger:qbSack.integerValue + amount];
                [HomeCB3Stats replaceObjectAtIndex:statType withObject:qbSack];
            }
        } else if ([defender isKindOfClass:[PlayerS class]]) {
//            PlayerS *s = (PlayerS*)defender;
//            if (statType == FCDefensiveStatTkl) {
//                s.statsTkl++;
//            } else if (statType == FCDefensiveStatPassDef) {
//                s.statsPassDef++;
//            } else if (statType == FCDefensiveStatINT) {
//                s.statsInt++;
//            } else if (statType == FCDefensiveStatForcedFum) {
//                s.statsForcedFum++;
//            } else { // sack
//                s.statsSacks++;
//            }
            NSNumber *qbSack = HomeSStats[statType];
            qbSack = [NSNumber numberWithInteger:qbSack.integerValue + amount];
            [HomeSStats replaceObjectAtIndex:statType withObject:qbSack];
        } else if ([defender isKindOfClass:[PlayerDL class]]) {
            PlayerDL *dl = (PlayerDL*)defender;
//            if (statType == FCDefensiveStatTkl) {
//                dl.statsTkl++;
//            } else if (statType == FCDefensiveStatPassDef) {
//                dl.statsPassDef++;
//            } else if (statType == FCDefensiveStatINT) {
//                dl.statsInt++;
//            } else if (statType == FCDefensiveStatForcedFum) {
//                dl.statsForcedFum++;
//            } else { // sack
//                dl.statsSacks++;
//            }
            if ([defense.teamDLs indexOfObject:dl] == 0) {
                NSNumber *qbSack = HomeDL1Stats[statType];
                qbSack = [NSNumber numberWithInteger:qbSack.integerValue + amount];
                [HomeDL1Stats replaceObjectAtIndex:statType withObject:qbSack];
            } else if ([defense.teamDLs indexOfObject:dl] == 1) {
                NSNumber *qbSack = HomeDL2Stats[statType];
                qbSack = [NSNumber numberWithInteger:qbSack.integerValue + amount];
                [HomeDL2Stats replaceObjectAtIndex:statType withObject:qbSack];
            } else if ([defense.teamDLs indexOfObject:dl] == 2) {
                NSNumber *qbSack = HomeDL3Stats[statType];
                qbSack = [NSNumber numberWithInteger:qbSack.integerValue + amount];
                [HomeDL3Stats replaceObjectAtIndex:statType withObject:qbSack];
            } else { // 3
                NSNumber *qbSack = HomeDL4Stats[statType];
                qbSack = [NSNumber numberWithInteger:qbSack.integerValue + amount];
                [HomeDL4Stats replaceObjectAtIndex:statType withObject:qbSack];
            }
        } else { // PlayerLB
            PlayerLB *lb = (PlayerLB*)defender;
//            if (statType == FCDefensiveStatTkl) {
//                lb.statsTkl++;
//            } else if (statType == FCDefensiveStatPassDef) {
//                lb.statsPassDef++;
//            } else if (statType == FCDefensiveStatINT) {
//                lb.statsInt++;
//            } else if (statType == FCDefensiveStatForcedFum) {
//                lb.statsForcedFum++;
//            } else { // sack
//                lb.statsSacks++;
//            }
            if ([defense.teamLBs indexOfObject:lb] == 0) {
                NSNumber *qbSack = HomeLB1Stats[statType];
                qbSack = [NSNumber numberWithInteger:qbSack.integerValue + amount];
                [HomeLB1Stats replaceObjectAtIndex:statType withObject:qbSack];
            } else if ([defense.teamLBs indexOfObject:lb] == 1) {
                NSNumber *qbSack = HomeLB2Stats[statType];
                qbSack = [NSNumber numberWithInteger:qbSack.integerValue + amount];
                [HomeLB2Stats replaceObjectAtIndex:statType withObject:qbSack];
            } else { // 2
                NSNumber *qbSack = HomeLB3Stats[statType];
                qbSack = [NSNumber numberWithInteger:qbSack.integerValue + amount];
                [HomeLB3Stats replaceObjectAtIndex:statType withObject:qbSack];
            }
        }
    } else {
        if ([defender isKindOfClass:[PlayerCB class]]) {
            PlayerCB *cb = (PlayerCB*)defender;
//            if (statType == FCDefensiveStatTkl) {
//                cb.statsTkl++;
//            } else if (statType == FCDefensiveStatPassDef) {
//                cb.statsPassDef++;
//            } else if (statType == FCDefensiveStatINT) {
//                cb.statsInt++;
//            } else if (statType == FCDefensiveStatForcedFum) {
//                cb.statsForcedFum++;
//            } else { // sack
//                cb.statsSacks++;
//            }
            if ([defense.teamCBs indexOfObject:cb] == 0) {
                NSNumber *qbSack = AwayCB1Stats[statType];
                qbSack = [NSNumber numberWithInteger:qbSack.integerValue + amount];
                [AwayCB1Stats replaceObjectAtIndex:statType withObject:qbSack];
            } else if ([defense.teamCBs indexOfObject:cb] == 1) {
                NSNumber *qbSack = AwayCB2Stats[statType];
                qbSack = [NSNumber numberWithInteger:qbSack.integerValue + amount];
                [AwayCB2Stats replaceObjectAtIndex:statType withObject:qbSack];
            } else { // 2
                NSNumber *qbSack = AwayCB3Stats[statType];
                qbSack = [NSNumber numberWithInteger:qbSack.integerValue + amount];
                [AwayCB3Stats replaceObjectAtIndex:statType withObject:qbSack];
            }
        } else if ([defender isKindOfClass:[PlayerS class]]) {
//            PlayerS *s = (PlayerS*)defender;
//            if (statType == FCDefensiveStatTkl) {
//                s.statsTkl++;
//            } else if (statType == FCDefensiveStatPassDef) {
//                s.statsPassDef++;
//            } else if (statType == FCDefensiveStatINT) {
//                s.statsInt++;
//            } else if (statType == FCDefensiveStatForcedFum) {
//                s.statsForcedFum++;
//            } else { // sack
//                s.statsSacks++;
//            }
            NSNumber *qbSack = AwaySStats[statType];
            qbSack = [NSNumber numberWithInteger:qbSack.integerValue + amount];
            [AwaySStats replaceObjectAtIndex:statType withObject:qbSack];
        } else if ([defender isKindOfClass:[PlayerDL class]]) {
            PlayerDL *dl = (PlayerDL*)defender;
//            if (statType == FCDefensiveStatTkl) {
//                dl.statsTkl++;
//            } else if (statType == FCDefensiveStatPassDef) {
//                dl.statsPassDef++;
//            } else if (statType == FCDefensiveStatINT) {
//                dl.statsInt++;
//            } else if (statType == FCDefensiveStatForcedFum) {
//                dl.statsForcedFum++;
//            } else { // sack
//                dl.statsSacks++;
//            }
            if ([defense.teamDLs indexOfObject:dl] == 0) {
                NSNumber *qbSack = AwayDL1Stats[statType];
                qbSack = [NSNumber numberWithInteger:qbSack.integerValue + amount];
                [AwayDL1Stats replaceObjectAtIndex:statType withObject:qbSack];
            } else if ([defense.teamDLs indexOfObject:dl] == 1) {
                NSNumber *qbSack = AwayDL2Stats[statType];
                qbSack = [NSNumber numberWithInteger:qbSack.integerValue + amount];
                [AwayDL2Stats replaceObjectAtIndex:statType withObject:qbSack];
            } else if ([defense.teamDLs indexOfObject:dl] == 2) {
                NSNumber *qbSack = AwayDL3Stats[statType];
                qbSack = [NSNumber numberWithInteger:qbSack.integerValue + amount];
                [AwayDL3Stats replaceObjectAtIndex:statType withObject:qbSack];
            } else { // 3
                NSNumber *qbSack = AwayDL4Stats[statType];
                qbSack = [NSNumber numberWithInteger:qbSack.integerValue + amount];
                [AwayDL4Stats replaceObjectAtIndex:statType withObject:qbSack];
            }
        } else { // PlayerLB
            PlayerLB *lb = (PlayerLB*)defender;
//            if (statType == FCDefensiveStatTkl) {
//                lb.statsTkl++;
//            } else if (statType == FCDefensiveStatPassDef) {
//                lb.statsPassDef++;
//            } else if (statType == FCDefensiveStatINT) {
//                lb.statsInt++;
//            } else if (statType == FCDefensiveStatForcedFum) {
//                lb.statsForcedFum++;
//            } else { // sack
//                lb.statsSacks++;
//            }
            if ([defense.teamLBs indexOfObject:lb] == 0) {
                NSNumber *qbSack = AwayLB1Stats[statType];
                qbSack = [NSNumber numberWithInteger:qbSack.integerValue + amount];
                [AwayLB1Stats replaceObjectAtIndex:statType withObject:qbSack];
            } else if ([defense.teamLBs indexOfObject:lb] == 1) {
                NSNumber *qbSack = AwayLB2Stats[statType];
                qbSack = [NSNumber numberWithInteger:qbSack.integerValue + amount];
                [AwayLB2Stats replaceObjectAtIndex:statType withObject:qbSack];
            } else { // 2
                NSNumber *qbSack = AwayLB3Stats[statType];
                qbSack = [NSNumber numberWithInteger:qbSack.integerValue + amount];
                [AwayLB3Stats replaceObjectAtIndex:statType withObject:qbSack];
            }
        }
    }
}

-(void)safety {
    if (gamePoss) {
        awayScore += 2;
        [gameEventLog appendString:[NSString stringWithFormat:@"%@%@ QB %@ tackled in end zone, SAFETY. %@ ball.", [self getEventPrefix],homeTeam.abbreviation,[homeTeam getQB:0].name,awayTeam.abbreviation]];
        [self freeKick:homeTeam];
    } else {
        homeScore += 2;
        [gameEventLog appendString:[NSString stringWithFormat:@"%@%@ QB %@ tackled in end zone, SAFETY. %@ ball.", [self getEventPrefix],awayTeam.abbreviation,[awayTeam getQB:0].name,homeTeam.abbreviation]];
        [self freeKick:awayTeam];
    }
}

-(void)qbInterception:(Team *)offense defense:(Team*)defense selectedDL:(PlayerDL*)selDL selectedLB:(PlayerLB*)selLB selectedCB:(PlayerCB*)selCB selectedS:(PlayerS*)selS selectedReceiver:(Player *)selPlayer {

    if ( gamePoss ) { // home possession
        NSNumber *qbInt = HomeQBStats[FCQBStatINT];
        qbInt = [NSNumber numberWithInteger:qbInt.integerValue + 1];
        [HomeQBStats replaceObjectAtIndex:FCQBStatINT withObject:qbInt];
        
        NSNumber *qbStat = HomeQBStats[FCQBStatPassAtt];
        qbStat = [NSNumber numberWithInteger:qbStat.integerValue + 1];
        [HomeQBStats replaceObjectAtIndex:FCQBStatPassAtt withObject:qbStat];
        homeTOs++;
    } else {
        NSNumber *qbInt = AwayQBStats[FCQBStatINT];
        qbInt = [NSNumber numberWithInteger:qbInt.integerValue + 1];
        [AwayQBStats replaceObjectAtIndex:FCQBStatINT withObject:qbInt];
        
        NSNumber *qbStat = AwayQBStats[FCQBStatPassAtt];
        qbStat = [NSNumber numberWithInteger:qbStat.integerValue + 1];
        [AwayQBStats replaceObjectAtIndex:FCQBStatPassAtt withObject:qbStat];
        awayTOs++;
    }
    
    NSArray *defenders = @[selS,selCB,selDL,selLB];
    NSMutableDictionary *playerPrefs = [NSMutableDictionary dictionary];
    for (Player *p in defenders) {
        [playerPrefs setObject:@([self calculatePlayerPreferenceForPlayer:p inGameSituation:FCGameSituationInterception relatedPlayer:selPlayer yardsGained:0]) forKey:[p uniqueIdentifier]];
    }
    
    NSArray *sortedDefenderIds = [playerPrefs keysSortedByValueUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj2 compare:obj1];
    }];
    
    Player *defender = defenders[0];
    for (Player *p in defenders) {
        if ([[p uniqueIdentifier] isEqualToString:sortedDefenderIds[0]]) {
            defender = p;
            break;
        }
    }
    // add game stats
    [self _addGameStat:FCDefensiveStatINT forDefender:defender onDefense:defense amount:1];
    
    [gameEventLog appendString:[NSString stringWithFormat:@"%@%@ QB %@ pass %@ INTERCEPTED by %@ %@ %@.", [self getEventPrefix],offense.abbreviation, [offense getQB:0].name, [self retrieveRandomPassDirection], defender.team.abbreviation,defender.position,defender.name]];
}

-(void)passingTD:(Team *)offense receiver:(PlayerWR *)selWR stats:(NSMutableArray *)selWRStats yardsGained:(int)yardsGained {
    if ( gamePoss ) { // home possession
        homeScore += 6;
        NSNumber *qbStat = HomeQBStats[FCQBStatPassTD];
        qbStat = [NSNumber numberWithInteger:qbStat.integerValue + 1];
        [HomeQBStats replaceObjectAtIndex:FCQBStatPassTD withObject:qbStat];
        NSNumber *wrTarget = selWRStats[FCWRStatRecTD];
        wrTarget = [NSNumber numberWithInteger:wrTarget.integerValue + 1];
        [selWRStats replaceObjectAtIndex:FCWRStatRecTD withObject:wrTarget];
    } else {
        awayScore += 6;
        NSNumber *qbStat = AwayQBStats[FCQBStatPassTD];
        qbStat = [NSNumber numberWithInteger:qbStat.integerValue + 1];
        [AwayQBStats replaceObjectAtIndex:FCQBStatPassTD withObject:qbStat];
        NSNumber *wrTarget = selWRStats[FCWRStatRecTD];
        wrTarget = [NSNumber numberWithInteger:wrTarget.integerValue + 1];
        [selWRStats replaceObjectAtIndex:FCWRStatRecTD withObject:wrTarget];
    }
    tdInfo = [NSString stringWithFormat:@"%@ QB %@ pass %@ to %@ %@ for %ld yards, TOUCHDOWN.",offense.abbreviation,[offense getQB:0].name,[self retrieveRandomPassDirection],selWR.position,selWR.name,(long)yardsGained];

    
    [offense getQB:0].statsTD++;
    selWR.statsTD++;
}


-(void)passCompletion:(Team *)offense defense:(Team *)defense selectedDL:(PlayerDL *)selDL selectedLB:(PlayerLB *)selLB selectedCB:(PlayerCB *)selCB selectedS:(PlayerS *)selS receiver:(PlayerWR *)selWR stats:(NSMutableArray *)selWRStats yardsGained:(int)yardsGained {
    
    [offense getQB:0].statsPassComp++;
    [offense getQB:0].statsPassAtt++;
    [offense getQB:0].statsPassYards += yardsGained;
    selWR.statsReceptions++;
    selWR.statsTargets++;
    selWR.statsRecYards += yardsGained;
    offense.teamPassYards += yardsGained;
    
    NSArray *defenders = @[selS,selCB,selDL,selLB];
    NSMutableDictionary *playerPrefs = [NSMutableDictionary dictionary];
    for (Player *p in defenders) {
        [playerPrefs setObject:@([self calculatePlayerPreferenceForPlayer:p inGameSituation:FCGameSituationTackle relatedPlayer:selWR yardsGained:yardsGained]) forKey:[p uniqueIdentifier]];
    }
    
    NSArray *sortedDefenderIds = [playerPrefs keysSortedByValueUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj2 compare:obj1];
    }];
    
    Player *defender = defenders[0];
    for (Player *p in defenders) {
        if ([[p uniqueIdentifier] isEqualToString:sortedDefenderIds[0]]) {
            defender = p;
            break;
        }
    }
    [self _addGameStat:FCDefensiveStatTkl forDefender:defender onDefense:defense amount:1];
    
    if ( gamePoss ) { // home possession
        homeYards += yardsGained;
        NSNumber *qbStatYd = HomeQBStats[FCQBStatPassYards];
        qbStatYd = [NSNumber numberWithInteger:qbStatYd.integerValue + yardsGained];
        [HomeQBStats replaceObjectAtIndex:FCQBStatPassYards withObject:qbStatYd];
        
        NSNumber *qbComp = HomeQBStats[FCQBStatPassComp];
        qbComp = [NSNumber numberWithInteger:qbComp.integerValue + 1];
        [HomeQBStats replaceObjectAtIndex:FCQBStatPassComp withObject:qbComp];
        
        NSNumber *qbStat = HomeQBStats[FCQBStatPassAtt];
        qbStat = [NSNumber numberWithInteger:qbStat.integerValue + 1];
        [HomeQBStats replaceObjectAtIndex:FCQBStatPassAtt withObject:qbStat];
        
        NSNumber *wrTarget = selWRStats[FCWRStatCatches];
        wrTarget = [NSNumber numberWithInteger:wrTarget.integerValue + 1];
        [selWRStats replaceObjectAtIndex:FCWRStatCatches withObject:wrTarget];
        
        NSNumber *wr2Yds = selWRStats[FCWRStatRecYards];
        wr2Yds = [NSNumber numberWithInteger:wr2Yds.integerValue + yardsGained];
        [selWRStats replaceObjectAtIndex:FCWRStatRecYards withObject:wr2Yds];
    } else {
        awayYards += yardsGained;
        NSNumber *qbStatYd = AwayQBStats[FCQBStatPassYards];
        qbStatYd = [NSNumber numberWithInteger:qbStatYd.integerValue + yardsGained];
        [AwayQBStats replaceObjectAtIndex:FCQBStatPassYards withObject:qbStatYd];
        
        NSNumber *qbStat = AwayQBStats[FCQBStatPassAtt];
        qbStat = [NSNumber numberWithInteger:qbStat.integerValue + 1];
        [AwayQBStats replaceObjectAtIndex:FCQBStatPassAtt withObject:qbStat];
        
        NSNumber *qbComp = AwayQBStats[FCQBStatPassComp];
        qbComp = [NSNumber numberWithInteger:qbComp.integerValue + 1];
        [AwayQBStats replaceObjectAtIndex:FCQBStatPassComp withObject:qbComp];
        
        NSNumber *wr2Yds = selWRStats[FCWRStatRecYards];
        wr2Yds = [NSNumber numberWithInteger:wr2Yds.integerValue + yardsGained];
        [selWRStats replaceObjectAtIndex:FCWRStatRecYards withObject:wr2Yds];
        
        NSNumber *wrTarget = selWRStats[FCWRStatCatches];
        wrTarget = [NSNumber numberWithInteger:wrTarget.integerValue + 1];
        [selWRStats replaceObjectAtIndex:FCWRStatCatches withObject:wrTarget];
    }
}

-(void)passAttempt:(Team *)offense defense:(Team *)defense selectedDL:(PlayerDL *)selDL selectedLB:(PlayerLB *)selLB selectedCB:(PlayerCB *)selCB selectedS:(PlayerS *)selS receiver:(PlayerWR *)selWR stats:(NSMutableArray *)selWRStats yardsGained:(int)yardsGained {
    PlayerQB *qb = [offense getQB:0];
    qb.statsPassAtt++;
    selWR.statsTargets++;
    
    if ([HBSharedUtils randomValue] < 0.50) {
        NSArray *defenders = @[selS,selCB,selDL,selLB];
        NSMutableDictionary *playerPrefs = [NSMutableDictionary dictionary];
        for (Player *p in defenders) {
            [playerPrefs setObject:@([self calculatePlayerPreferenceForPlayer:p inGameSituation:FCGameSituationPassDefense relatedPlayer:selWR yardsGained:yardsGained]) forKey:[p uniqueIdentifier]];
        }
        
        NSArray *sortedDefenderIds = [playerPrefs keysSortedByValueUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj2 compare:obj1];
        }];
        
        Player *defender = defenders[0];
        for (Player *p in defenders) {
            if ([[p uniqueIdentifier] isEqualToString:sortedDefenderIds[0]]) {
                defender = p;
                break;
            }
        }
        [self _addGameStat:FCDefensiveStatPassDef forDefender:defender onDefense:defense amount:1];
    }
    
    if ( gamePoss ) { // home possession
        
        NSNumber *qbStat = HomeQBStats[FCQBStatPassAtt];
        qbStat = [NSNumber numberWithInteger:qbStat.integerValue + 1];
        [HomeQBStats replaceObjectAtIndex:FCQBStatPassAtt withObject:qbStat];

        NSNumber *wrTarget = selWRStats[FCWRStatTargets];
        wrTarget = [NSNumber numberWithInteger:wrTarget.integerValue + 1];
        [selWRStats replaceObjectAtIndex:FCWRStatTargets withObject:wrTarget];
       
    } else {
        
        NSNumber *qbStat = AwayQBStats[FCQBStatPassAtt];
        qbStat = [NSNumber numberWithInteger:qbStat.integerValue + 1];
        [AwayQBStats replaceObjectAtIndex:FCQBStatPassAtt withObject:qbStat];
        
        NSNumber *wrTarget = selWRStats[FCWRStatTargets];
        wrTarget = [NSNumber numberWithInteger:wrTarget.integerValue + 1];
        [selWRStats replaceObjectAtIndex:FCWRStatTargets withObject:wrTarget];
    }
    
}

-(void)rushAttemptQB:(Team *)offense defense:(Team *)defense selectedDL:(PlayerDL *)selDL selectedLB:(PlayerLB *)selLB selectedCB:(PlayerCB *)selCB selectedS:(PlayerS *)selS rusher:(PlayerQB *)selQB yardsGained:(int)yardsGained {
    selQB.statsRushAtt++;
    selQB.statsRushYards += yardsGained;
    offense.teamRushYards += yardsGained;
    
    NSArray *defenders = @[selS,selCB,selDL,selLB];
    NSMutableDictionary *playerPrefs = [NSMutableDictionary dictionary];
    for (Player *p in defenders) {
        [playerPrefs setObject:@([self calculatePlayerPreferenceForPlayer:p inGameSituation:FCGameSituationRunDefense relatedPlayer:selQB yardsGained:yardsGained gotTD:NO]) forKey:[p uniqueIdentifier]];
    }
    
    NSArray *sortedDefenderIds = [playerPrefs keysSortedByValueUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj2 compare:obj1];
    }];
    
    Player *defender = defenders[0];
    for (Player *p in defenders) {
        if ([[p uniqueIdentifier] isEqualToString:sortedDefenderIds[0]]) {
            defender = p;
            break;
        }
    }
    [self _addGameStat:FCDefensiveStatTkl forDefender:defender onDefense:defense amount:1];
    
    if ( gamePoss ) { // home possession
        homeYards += yardsGained;
        NSNumber *qbStat = HomeQBStats[FCQBStatRushAtt];
        qbStat = [NSNumber numberWithInteger:qbStat.integerValue + 1];
        [HomeQBStats replaceObjectAtIndex:FCQBStatRushAtt withObject:qbStat];
        
        NSNumber *rb2Att = HomeQBStats[FCQBStatRushYards];
        rb2Att = [NSNumber numberWithInteger:rb2Att.integerValue + yardsGained];
        [HomeQBStats replaceObjectAtIndex:FCQBStatRushYards withObject:rb2Att];
    } else {
        awayYards += yardsGained;
        NSNumber *qbStat = AwayQBStats[FCQBStatRushAtt];
        qbStat = [NSNumber numberWithInteger:qbStat.integerValue + 1];
        [AwayQBStats replaceObjectAtIndex:FCQBStatRushAtt withObject:qbStat];
        
        NSNumber *rb2Att = AwayQBStats[FCQBStatRushYards];
        rb2Att = [NSNumber numberWithInteger:rb2Att.integerValue + yardsGained];
        [AwayQBStats replaceObjectAtIndex:FCQBStatRushYards withObject:rb2Att];
    }
}

-(void)rushAttempt:(Team *)offense defense:(Team *)defense selectedDL:(PlayerDL *)selDL selectedLB:(PlayerLB *)selLB selectedCB:(PlayerCB *)selCB selectedS:(PlayerS *)selS rusher:(PlayerRB *)selRB rb1Pref:(double)rb1Pref rb2Pref:(double)rb2Pref yardsGained:(int)yardsGained {
    selRB.statsRushAtt++;
    selRB.statsRushYards += yardsGained;
    offense.teamRushYards += yardsGained;
    
    NSArray *defenders = @[selS,selCB,selDL,selLB];
    NSMutableDictionary *playerPrefs = [NSMutableDictionary dictionary];
    for (Player *p in defenders) {
        [playerPrefs setObject:@([self calculatePlayerPreferenceForPlayer:p inGameSituation:FCGameSituationRunDefense relatedPlayer:selRB yardsGained:yardsGained gotTD:NO]) forKey:[p uniqueIdentifier]];
    }
    
    NSArray *sortedDefenderIds = [playerPrefs keysSortedByValueUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj2 compare:obj1];
    }];
    
    Player *defender = defenders[0];
    for (Player *p in defenders) {
        if ([[p uniqueIdentifier] isEqualToString:sortedDefenderIds[0]]) {
            defender = p;
            break;
        }
    }
    [self _addGameStat:FCDefensiveStatTkl forDefender:defender onDefense:defense amount:1];
    
    if ( gamePoss ) { // home possession
        homeYards += yardsGained;
        if (rb1Pref > rb2Pref) {
            NSNumber *rb1 = HomeRB1Stats[FCRBStatRushAtt];
            rb1 = [NSNumber numberWithInteger:rb1.integerValue + 1];
            [HomeRB1Stats replaceObjectAtIndex:FCRBStatRushAtt withObject:rb1];
            
            NSNumber *rb1Att = HomeRB1Stats[FCRBStatRushYards];
            rb1Att = [NSNumber numberWithInteger:rb1Att.integerValue + yardsGained];
            [HomeRB1Stats replaceObjectAtIndex:FCRBStatRushYards withObject:rb1Att];
            
        } else {
            NSNumber *rb2 = HomeRB2Stats[FCRBStatRushAtt];
            rb2 = [NSNumber numberWithInteger:rb2.integerValue + 1];
            [HomeRB2Stats replaceObjectAtIndex:FCRBStatRushAtt withObject:rb2];
            
            NSNumber *rb2Att = HomeRB2Stats[FCRBStatRushYards];
            rb2Att = [NSNumber numberWithInteger:rb2Att.integerValue + yardsGained];
            [HomeRB2Stats replaceObjectAtIndex:FCRBStatRushYards withObject:rb2Att];
        }
    } else {
        awayYards += yardsGained;
        if (rb1Pref > rb2Pref) {
            NSNumber *rb1 = AwayRB1Stats[FCRBStatRushAtt];
            rb1 = [NSNumber numberWithInteger:rb1.integerValue + 1];
            [AwayRB1Stats replaceObjectAtIndex:FCRBStatRushAtt withObject:rb1];
            
            NSNumber *rb1Att = AwayRB1Stats[FCRBStatRushYards];
            rb1Att = [NSNumber numberWithInteger:rb1Att.integerValue + yardsGained];
            [AwayRB1Stats replaceObjectAtIndex:FCRBStatRushYards withObject:rb1Att];
        } else {
            NSNumber *rb2 = AwayRB2Stats[FCRBStatRushAtt];
            rb2 = [NSNumber numberWithInteger:rb2.integerValue + 1];
            [AwayRB2Stats replaceObjectAtIndex:FCRBStatRushAtt withObject:rb2];
            
            NSNumber *rb2Att = AwayRB2Stats[FCRBStatRushYards];
            rb2Att = [NSNumber numberWithInteger:rb2Att.integerValue + yardsGained];
            [AwayRB2Stats replaceObjectAtIndex:FCRBStatRushYards withObject:rb2Att];
        }
    }
}

-(void)freeKick:(Team*)offense {
    if (gameTime > 0) {
        if ( gameTime < 180 && ((gamePoss && (awayScore - homeScore) <= 8 && (awayScore - homeScore) > 0)
                                || (!gamePoss && (homeScore - awayScore) <=8 && (homeScore - awayScore) > 0))) {
            // Yes, do onside
            if ([offense getK:0].ratKickFum *[HBSharedUtils randomValue] > 60 ||[HBSharedUtils randomValue] < 0.1) {
                //Success!
                [gameEventLog appendString:[NSString stringWithFormat:@"\n\n%@ 35 | Kickoff | %@ K %@ successfully executes onside kick! %@ has possession!",offense.abbreviation,offense.abbreviation, [offense getK:0].name, offense.abbreviation]];
            } else {
                // Fail
                [gameEventLog appendString:[NSString stringWithFormat:@"\n\n%@ 35 | Kickoff | %@ K %@ failed to convert the onside kick. %@ lost possession.",offense.abbreviation, offense.abbreviation, [offense getK:0].name, offense.abbreviation]];
                gamePoss = !gamePoss;
            }
            gameYardLine = 50;
            gameDown = 1;
            gameYardsNeed = 10;
            gameTime -= (4 + (5 * [HBSharedUtils randomValue]));
            
        } else {
            // Just regular kick off
            int kickOffYards = (int)([offense getK:0].ratKickPow + 20 - 40* [HBSharedUtils randomValue]);
            gameYardLine = 100 - kickOffYards;
            if ( gameYardLine <= 25 ) gameYardLine = 25;
            NSString *touchback = @".";
            if (gameYardLine == 25) {
                touchback = @", Touchback.";
            }
            if (pbpEnabled) {
                [gameEventLog appendString:[NSString stringWithFormat:@"\n\n%@ 35 | Kickoff | %@ | (%@) %@ K %@ kicks %d yards%@",offense.abbreviation, [self convGameQuarter], [self convGameTimeMinute],offense.abbreviation, [offense getK:0].name, (kickOffYards - 35),touchback]];
            }
            gameDown = 1;
            gameYardsNeed = 10;
            gamePoss = !gamePoss;
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
    return rating;
}

-(NSString *)debugDescription {
    if (hasPlayed) {
        return [NSString stringWithFormat:@"%@ %d, %@ %d", awayTeam.abbreviation, awayScore, homeTeam.abbreviation, homeScore];
    } else {
        return [NSString stringWithFormat:@"%@ @ %@",awayTeam.abbreviation, homeTeam.abbreviation];
    }
}

@end
