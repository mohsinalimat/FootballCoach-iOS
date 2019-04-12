//
//  LeagueUpdater.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 11/1/17.
//  Copyright © 2017 Akshay Easwaran. All rights reserved.
//

#import "LeagueUpdater.h"
#import "Player.h"
#import "Conference.h"
#import "Game.h"
#import "Team.h"
#import "AppDelegate.h"
#import "Record.h"

#import "PlayerQB.h"
#import "PlayerRB.h"
#import "PlayerWR.h"
#import "PlayerK.h"
#import "PlayerOL.h"
#import "PlayerTE.h"
#import "PlayerLB.h"
#import "PlayerDL.h"
#import "PlayerCB.h"
#import "PlayerS.h"
#import "PlayerF7.h"
#import "Injury.h"

#import "HBSharedUtils.h"

@implementation LeagueUpdater

+ (BOOL)needsUpdateFromVersion:(NSString*)actualVersion toVersion:(NSString*)requiredVersion {
    if (actualVersion == nil) {
        return YES;
    }
    return ([requiredVersion compare:actualVersion options:NSNumericSearch] == NSOrderedDescending);
}

+ (void)convertLeagueFromOldVersion:(League* _Nonnull)oldLigue updatingBlock:(void (^_Nullable)(float progress, NSString * _Nullable updateStatus))updatingBlock completionBlock:(void (^_Nullable)(BOOL success, NSString * _Nullable finalStatus, League * _Nonnull ligue))completionBlock {
    //Alg:
    // If app version is not the same as the league version:
        // check the properties of the league
            // drill down to teams and players
            // we know which were added in this new version, so check if those exist and load them with data if needed
        // if there are no new properties to update, just update the version
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        if ([[self class] needsUpdateFromVersion:oldLigue.leagueVersion toVersion:@"2.0"]) {
            __block float prgs = 0.0;
            oldLigue.baseYear = 2016;
            for (Team *t in oldLigue.teamList) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    prgs += 0.01;
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        updatingBlock(prgs, @"Updating team details for version 2...");
                    });
                });
                
                // Set to a random state for now just to populate the field
                t.state = [HBSharedUtils randomState];
                t.recruitingClass = [NSMutableArray array];
                
                
                // add TEs, LBs as 3* freshmen
                t.teamTEs = [NSMutableArray array];
                for( int i = 0; i < 2; ++i ) {
                    //make TEs
                    [t.teamTEs addObject:[PlayerTE newTEWithName:[oldLigue getRandName] year:((int)(3 * [HBSharedUtils randomValue]) + 1) stars:((int)(3 * [HBSharedUtils randomValue]) + 2) team:t]];
                }
                
                t.teamLBs = [NSMutableArray array];
                for( int i = 0; i < 6; ++i ) {
                    //make LBs
                    [t.teamLBs addObject:[PlayerLB newLBWithName:[oldLigue getRandName] year:((int)(3 * [HBSharedUtils randomValue]) + 1) stars:((int)(3 * [HBSharedUtils randomValue]) + 2) team:t]];
                }
                
                // convert F7s to DLs
                t.teamDLs = [NSMutableArray array];
                for (PlayerF7 *f7 in t.teamF7s) {
                    PlayerDL *dl = [PlayerDL newDLWithF7:f7];
                    [t.teamDLs addObject:dl];
                }
                
                [t sortPlayers];
                
                // for QBs -> add speed attr and rush stats
                for (PlayerQB *qb in t.teamQBs) {
                    qb.ratSpeed = (int) (67 + (qb.year*5 * [HBSharedUtils randomValue]));
                    
                    qb.statsRushAtt = 0;
                    qb.statsRushYards = 0;
                    qb.statsRushTD = 0;
                    qb.statsFumbles = 0;
                    
                    qb.careerStatsRushAtt = 0;
                    qb.careerStatsRushYards = 0;
                    qb.careerStatsRushTD = 0;
                    qb.careerStatsFumbles = 0;
                }
                
                // reset strats
                if (!t.isUserControlled) {
                    t.teamStatOffNum = [t getCPUOffense];
                    t.teamStatDefNum = [t getCPUDefense];
                    t.offensiveStrategy = [t getOffensiveTeamStrategies][t.teamStatOffNum];
                    t.defensiveStrategy = [t getDefensiveTeamStrategies][t.teamStatDefNum];
                }
            }
            
            // add TEStats and TE (as starter) and 4 more QB stats to games
            for (Team *t in oldLigue.teamList) {
                for (Game *g in t.gameSchedule) {
                    if (!g.hasPlayed) {
                        g.HomeQBStats = [NSMutableArray array];
                        for (int i = 0; i < 10; i++) {
                            [g.HomeQBStats addObject:@(0)];
                        }
                        g.HomeTEStats = [NSMutableArray array];
                        for (int i = 0; i < 6; i++) {
                            [g.HomeTEStats addObject:@(0)];
                        }
                        g.AwayQBStats = [NSMutableArray array];
                        for (int i = 0; i < 10; i++) {
                            [g.AwayQBStats addObject:@(0)];
                        }
                        g.AwayTEStats = [NSMutableArray array];
                        for (int i = 0; i < 6; i++) {
                            [g.AwayTEStats addObject:@(0)];
                        }
                    } else {
                        for (int i = 0; i < 4; i++) {
                            [g.HomeQBStats addObject:@(0)];
                        }
                        
                        g.HomeTEStats = [NSMutableArray array];
                        for (int i = 0; i < 6; i++) {
                            [g.HomeTEStats addObject:@(0)];
                        }
                        
                        for (int i = 0; i < 4; i++) {
                            [g.AwayQBStats addObject:@(0)];
                        }
                        
                        g.AwayTEStats = [NSMutableArray array];
                        for (int i = 0; i < 6; i++) {
                            [g.AwayTEStats addObject:@(0)];
                        }
                    }
                    
                    
                    __block NSInteger foundIndex = NSNotFound;
                    [g.homeStarters enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if ([obj isKindOfClass:[PlayerTE class]]) {
                            foundIndex = idx;
                            *stop = YES;
                        }
                    }];
                    
                    if (foundIndex == NSNotFound) {
                        if (g.homeTeam.teamTEs != nil && g.homeTeam.teamTEs.count > 0 && g.homeStarters != nil && g.homeStarters.count > 0) {
                            [g.homeStarters insertObject:[g.homeTeam getTE:0] atIndex: 6];
                        }
                    }
                    
                    foundIndex = NSNotFound;
                    [g.awayStarters enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if ([obj isKindOfClass:[PlayerTE class]]) {
                            foundIndex = idx;
                            *stop = YES;
                        }
                    }];
                    
                    if (foundIndex == NSNotFound) {
                        if (g.awayTeam.teamTEs != nil && g.awayTeam.teamTEs.count > 0 && g.awayStarters.count > 0) {
                            [g.awayStarters insertObject:[g.awayTeam getTE:0] atIndex: 6];
                        }
                    }
                }
            }
            
            // if NCG, bowls, semis are not null, add TEStats and TE and 4 more QB stats
            NSMutableArray *leagueGames;
            if (oldLigue.bowlGames.count > 0) {
                leagueGames = [NSMutableArray arrayWithArray:oldLigue.bowlGames];
            }
            
            if (oldLigue.ncg != nil) {
                [leagueGames addObject:oldLigue.ncg];
            }
            
            if (oldLigue.semiG14 != nil) {
                [leagueGames addObject:oldLigue.semiG14];
            }
            
            if (oldLigue.semiG23 != nil) {
                [leagueGames addObject:oldLigue.semiG23];
            }
            
            
            for (Game *g in leagueGames) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    prgs += (0.30 / leagueGames.count);
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        updatingBlock(prgs, @"Updating league structure for version 2...");
                    });
                });
                if (g != nil) {
                    if (g.HomeQBStats == nil) {
                        g.HomeQBStats = [NSMutableArray array];
                        for (int i = 0; i < 10; i++) {
                            [g.HomeQBStats addObject:@(0)];
                        }
                    } else {
                        for (int i = 0; i < 4; i++) {
                            [g.HomeQBStats addObject:@(0)];
                        }
                    }
                    
                    if (g.HomeTEStats == nil) {
                        g.HomeTEStats = [NSMutableArray array];
                        for (int i = 0; i < 6; i++) {
                            [g.HomeTEStats addObject:@(0)];
                        }
                    }
                    
                    if (g.AwayQBStats == nil) {
                        g.AwayQBStats = [NSMutableArray array];
                        for (int i = 0; i < 10; i++) {
                            [g.AwayQBStats addObject:@(0)];
                        }
                    } else {
                        for (int i = 0; i < 4; i++) {
                            [g.AwayQBStats addObject:@(0)];
                        }
                    }
                    
                    __block NSInteger foundIndex = NSNotFound;
                    [g.homeStarters enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if ([obj isKindOfClass:[PlayerTE class]]) {
                            foundIndex = idx;
                            *stop = YES;
                        }
                    }];
                    
                    if (foundIndex == NSNotFound) {
                        if (g.homeTeam.teamTEs != nil && g.homeTeam.teamTEs.count > 0 && g.homeStarters != nil && g.homeStarters.count > 0) {
                            [g.homeStarters insertObject:[g.homeTeam getTE:0] atIndex: 6];
                        }
                    }
                    
                    foundIndex = NSNotFound;
                    [g.awayStarters enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if ([obj isKindOfClass:[PlayerTE class]]) {
                            foundIndex = idx;
                            *stop = YES;
                        }
                    }];
                    
                    if (foundIndex == NSNotFound) {
                        if (g.awayTeam.teamTEs != nil && g.awayTeam.teamTEs.count > 0 && g.awayStarters.count > 0) {
                            [g.awayStarters insertObject:[g.awayTeam getTE:0] atIndex: 6];
                        }
                    }
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                prgs += 0.05;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    updatingBlock(prgs, @"Finishing league updates for version 2...");
                });
            });
            // if all league players were calculated, then recalculate
            if (oldLigue.currentWeek > 14 && (oldLigue.allLeaguePlayers != nil || oldLigue.allLeaguePlayers.count != 0)) {
                [oldLigue refreshAllLeaguePlayers];
            }
            
            // if all conf players were calculated, then recalculate
            for (Conference *c in oldLigue.conferences) {
                if (oldLigue.currentWeek > 14 && (c.allConferencePlayers != nil || c.allConferencePlayers.count != 0)) {
                    [c refreshAllConferencePlayers];
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                prgs += 0.05;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    updatingBlock(prgs, @"Cleaning up...");
                });
            });
            
            oldLigue.leagueVersion = @"2.0";
            [oldLigue save];
        }
        
        if ([[self class] needsUpdateFromVersion:oldLigue.leagueVersion toVersion:@"2.1"]) {
            __block float prgs = 0.0;
            dispatch_async(dispatch_get_main_queue(), ^{
                prgs += 0.05;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    updatingBlock(prgs, @"Starting league updates...");
                });
            });
            // add the stuff for transfers
            oldLigue.transferList = @{
                             @"QB" : [NSMutableArray array],
                             @"RB" : [NSMutableArray array],
                             @"WR" : [NSMutableArray array],
                             @"TE" : [NSMutableArray array],
                             @"OL" : [NSMutableArray array],
                             @"DL" : [NSMutableArray array],
                             @"LB" : [NSMutableArray array],
                             @"CB" : [NSMutableArray array],
                             @"S" : [NSMutableArray array],
                             @"K" : [NSMutableArray array]
                             };
            oldLigue.transferLog = [NSMutableArray array];
            oldLigue.didFinishTransferPeriod = NO;
            
            // add stuff for ROTY
            oldLigue.rotyHistoryDictionary = [NSMutableDictionary dictionary];
            oldLigue.rotyCandidates = [NSMutableArray array];
            oldLigue.roty = nil;
            oldLigue.rotyFinalists = [NSMutableArray array];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                prgs += 0.20;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    updatingBlock(prgs, @"Finishing league updates...");
                });
            });
            
            dispatch_async(dispatch_get_main_queue(), ^{
                prgs += 0.55;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    updatingBlock(prgs, @"Finishing team updates...");
                });
            });
            
            for (Team *t in oldLigue.teamList) {
                t.playersTransferring = [NSMutableArray array];
                t.transferClass = [NSMutableArray array];
                t.recruitingPoints = 0;
                t.usedRecruitingPoints = 0;
                t.rotys = 0;
                NSMutableArray<Player *> *players = [t getAllPlayers];
                for (Player *p in players) {
                    p.isTransfer = NO;
                    p.isGradTransfer = NO;
                    
                    // ROTY stuff
                    p.isROTY = NO;
                    p.careerROTYs = 0;
                }
            }
            
            if (oldLigue.currentWeek > 12 && oldLigue.roty == nil) {
                NSString *roty = [oldLigue getROTYCeremonyStr];
                NSLog(@"ROTY: %@", roty);
            }
            
            // we can't run these until 3.0 because of HC changes, so if we need to update to 3.0 from here, avoid running these
            if (![HB_APP_VERSION_CURRENT_MINOR_VERSION isEqualToString:@"3.0"]) {
                // if all league players were calculated, then recalculate
                if (oldLigue.currentWeek > 14 && (oldLigue.allLeaguePlayers != nil || oldLigue.allLeaguePlayers.count != 0)) {
                    [oldLigue refreshAllLeaguePlayers];
                }
                
                // if all conf players were calculated, then recalculate
                for (Conference *c in oldLigue.conferences) {
                    if (oldLigue.currentWeek > 14 && (c.allConferencePlayers != nil || c.allConferencePlayers.count != 0)) {
                        [c refreshAllConferencePlayers];
                    }
                }
            }

            dispatch_async(dispatch_get_main_queue(), ^{
                prgs += 0.15;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    updatingBlock(prgs, @"Cleaning up...");
                });
            });
            
            oldLigue.leagueVersion = @"2.1";
            [oldLigue save];
        }
        
        if ([[self class] needsUpdateFromVersion:oldLigue.leagueVersion toVersion:@"3.0"]) {
            __block float prgs = 0.0;
            oldLigue.isCareerMode = NO;
            oldLigue.coachList = [NSMutableArray array];
            oldLigue.coachStarList = [NSMutableArray array];
            oldLigue.coachFreeAgents = [NSMutableArray array];
            oldLigue.cotyWinner = nil;
            oldLigue.cotyWinnerStrFull = nil;
            
            for (Team *t in oldLigue.teamList) {
                t.coaches = [NSMutableArray array];
                t.totalCOTYs = 0;
                t.coachGotNewContract = NO;
                t.coachContractString = nil;
                t.coachRetired = NO;
                t.coachFired = NO;
                [t createNewCustomHeadCoach:[oldLigue getRandName] stars:((int)([HBSharedUtils randomValue] * 4) + 1)];
                [t getCurrentHC].contractLength = 1 + (int)([HBSharedUtils randomValue] * 6);
                [t getCurrentHC].contractYear = (int)([HBSharedUtils randomValue] * [t getCurrentHC].contractLength);
                [t getCurrentHC].totalWins = t.totalWins;
                [t getCurrentHC].totalLosses = t.totalLosses;
                [t getCurrentHC].totalConfWins = t.totalConfWins;
                [t getCurrentHC].totalConfLosses = t.totalConfLosses;
                [t getCurrentHC].totalHeismans = t.heismans;
                [t getCurrentHC].totalROTYs = t.rotys;
                [t getCurrentHC].totalCCs = t.totalCCs;
                [t getCurrentHC].totalNCs = t.totalNCs;
                [t getCurrentHC].totalBowls = t.totalBowls;
                [t getCurrentHC].totalCCLosses = t.totalCCLosses;
                [t getCurrentHC].totalNCLosses = t.totalNCLosses;
                [t getCurrentHC].totalBowlLosses = t.totalBowlLosses;
                [t getCurrentHC].gamesCoached = [t getCurrentHC].totalWins + [t getCurrentHC].totalLosses;
                [t getCurrentHC].offStratNum = t.teamStatOffNum;
                [t getCurrentHC].defStratNum = t.teamStatDefNum;
                [t getCurrentHC].startYear = (int)t.league.baseYear;
                [t getCurrentHC].year = (int)([t.league getCurrentYear] - t.league.baseYear);
                
                // give HC the team history too
                [t getCurrentHC].coachingHistoryDictionary = [t.teamHistoryDictionary mutableCopy];
            }
            
            if (oldLigue.currentWeek > 13 && oldLigue.cotyWinner == nil) {
                [oldLigue getCoachAwardStr];
            }
            
            // add defensive stats to all games
            for (Team *t in oldLigue.teamList) {
                for (Game *g in t.gameSchedule) {
                    g.HomeCB1Stats = [NSMutableArray array];
                    g.HomeCB2Stats = [NSMutableArray array];
                    g.HomeCB3Stats = [NSMutableArray array];
                    g.AwayCB1Stats = [NSMutableArray array];
                    g.AwayCB2Stats = [NSMutableArray array];
                    g.AwayCB3Stats = [NSMutableArray array];
                    
                    g.HomeLB1Stats = [NSMutableArray array];
                    g.HomeLB2Stats = [NSMutableArray array];
                    g.HomeLB3Stats = [NSMutableArray array];
                    g.AwayLB1Stats = [NSMutableArray array];
                    g.AwayLB2Stats = [NSMutableArray array];
                    g.AwayLB3Stats = [NSMutableArray array];
                    
                    g.HomeDL1Stats = [NSMutableArray array];
                    g.HomeDL2Stats = [NSMutableArray array];
                    g.HomeDL3Stats = [NSMutableArray array];
                    g.HomeDL4Stats = [NSMutableArray array];
                    g.AwayDL1Stats = [NSMutableArray array];
                    g.AwayDL2Stats = [NSMutableArray array];
                    g.AwayDL3Stats = [NSMutableArray array];
                    g.AwayDL4Stats = [NSMutableArray array];
                    g.HomeSStats = [NSMutableArray array];
                    g.AwaySStats = [NSMutableArray array];
                    
                    for (int i = 0; i < 5; i++) {
                        [g.HomeDL1Stats addObject:@(0)];
                        [g.AwayDL1Stats addObject:@(0)];
                        
                        [g.HomeDL2Stats addObject:@(0)];
                        [g.AwayDL2Stats addObject:@(0)];
                        
                        [g.HomeDL3Stats addObject:@(0)];
                        [g.AwayDL3Stats addObject:@(0)];
                        
                        [g.HomeDL4Stats addObject:@(0)];
                        [g.AwayDL4Stats addObject:@(0)];
                        
                        [g.HomeLB1Stats addObject:@(0)];
                        [g.AwayLB1Stats addObject:@(0)];
                        
                        [g.HomeLB2Stats addObject:@(0)];
                        [g.AwayLB2Stats addObject:@(0)];
                        
                        [g.HomeLB3Stats addObject:@(0)];
                        [g.AwayLB3Stats addObject:@(0)];
                        
                        [g.HomeCB1Stats addObject:@(0)];
                        [g.AwayCB1Stats addObject:@(0)];
                        
                        [g.HomeCB2Stats addObject:@(0)];
                        [g.AwayCB2Stats addObject:@(0)];
                        
                        [g.HomeCB3Stats addObject:@(0)];
                        [g.AwayCB3Stats addObject:@(0)];
                        
                        [g.HomeSStats addObject:@(0)];
                        [g.AwaySStats addObject:@(0)];
                    }
                }
                
                [t updateDepthChartPositions];
                
                for (PlayerDL *dl in t.teamDLs) {
                    dl.statsTkl = 0;
                    dl.statsSacks = 0;
                    dl.statsPassDef = 0;
                    dl.statsForcedFum = 0;
                    dl.statsInt = 0;
                    
                    dl.careerStatsTkl = 0;
                    dl.careerStatsSacks = 0;
                    dl.careerStatsPassDef = 0;
                    dl.careerStatsForcedFum = 0;
                    dl.careerStatsInt = 0;
                }
                
                for (PlayerLB *dl in t.teamLBs) {
                    dl.statsTkl = 0;
                    dl.statsSacks = 0;
                    dl.statsPassDef = 0;
                    dl.statsForcedFum = 0;
                    dl.statsInt = 0;
                    
                    dl.careerStatsTkl = 0;
                    dl.careerStatsSacks = 0;
                    dl.careerStatsPassDef = 0;
                    dl.careerStatsForcedFum = 0;
                    dl.careerStatsInt = 0;
                }
                
                for (PlayerCB *dl in t.teamCBs) {
                    dl.statsTkl = 0;
                    dl.statsSacks = 0;
                    dl.statsPassDef = 0;
                    dl.statsForcedFum = 0;
                    dl.statsInt = 0;
                    
                    dl.careerStatsTkl = 0;
                    dl.careerStatsSacks = 0;
                    dl.careerStatsPassDef = 0;
                    dl.careerStatsForcedFum = 0;
                    dl.careerStatsInt = 0;
                }
                
                for (PlayerS *dl in t.teamSs) {
                    dl.statsTkl = 0;
                    dl.statsSacks = 0;
                    dl.statsPassDef = 0;
                    dl.statsForcedFum = 0;
                    dl.statsInt = 0;
                    
                    dl.careerStatsTkl = 0;
                    dl.careerStatsSacks = 0;
                    dl.careerStatsPassDef = 0;
                    dl.careerStatsForcedFum = 0;
                    dl.careerStatsInt = 0;
                }
                
                for (Player *p in [t getAllPlayers]) {
                    p.statHistoryDictionary = [NSMutableDictionary dictionary];
                }
                
                t.careerSacksRecord = nil;
                t.careerTacklesRecord = nil;
                t.careerPassDefRecord = nil;
                t.careerForcedFumRecord = nil;
                t.careerDefInterceptionsRecord = nil;
                
                t.singleSeasonSacksRecord = nil;
                t.singleSeasonTacklesRecord = nil;
                t.singleSeasonPassDefRecord = nil;
                t.singleSeasonForcedFumRecord = nil;
                t.singleSeasonDefInterceptionsRecord = nil;
            }
            
            // if NCG, bowls, semis are not null, add TEStats and TE and 4 more QB stats
            NSMutableArray *leagueGames;
            if (oldLigue.bowlGames.count > 0) {
                leagueGames = [NSMutableArray arrayWithArray:oldLigue.bowlGames];
            }
            
            if (oldLigue.ncg != nil) {
                [leagueGames addObject:oldLigue.ncg];
            }
            
            if (oldLigue.semiG14 != nil) {
                [leagueGames addObject:oldLigue.semiG14];
            }
            
            if (oldLigue.semiG23 != nil) {
                [leagueGames addObject:oldLigue.semiG23];
            }
            
            for (Game *g in leagueGames) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    prgs += (0.30 / leagueGames.count);
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        updatingBlock(prgs, @"Updating league structure for version 3.0...");
                    });
                });
                if (g != nil) {
                    g.HomeCB1Stats = [NSMutableArray array];
                    g.HomeCB2Stats = [NSMutableArray array];
                    g.HomeCB3Stats = [NSMutableArray array];
                    g.AwayCB1Stats = [NSMutableArray array];
                    g.AwayCB2Stats = [NSMutableArray array];
                    g.AwayCB3Stats = [NSMutableArray array];
                    
                    g.HomeLB1Stats = [NSMutableArray array];
                    g.HomeLB2Stats = [NSMutableArray array];
                    g.HomeLB3Stats = [NSMutableArray array];
                    g.AwayLB1Stats = [NSMutableArray array];
                    g.AwayLB2Stats = [NSMutableArray array];
                    g.AwayLB3Stats = [NSMutableArray array];
                    
                    g.HomeDL1Stats = [NSMutableArray array];
                    g.HomeDL2Stats = [NSMutableArray array];
                    g.HomeDL3Stats = [NSMutableArray array];
                    g.HomeDL4Stats = [NSMutableArray array];
                    g.AwayDL1Stats = [NSMutableArray array];
                    g.AwayDL2Stats = [NSMutableArray array];
                    g.AwayDL3Stats = [NSMutableArray array];
                    g.AwayDL4Stats = [NSMutableArray array];
                    g.HomeSStats = [NSMutableArray array];
                    g.AwaySStats = [NSMutableArray array];
                    
                    for (int i = 0; i < 5; i++) {
                        [g.HomeDL1Stats addObject:@(0)];
                        [g.AwayDL1Stats addObject:@(0)];
                        
                        [g.HomeDL2Stats addObject:@(0)];
                        [g.AwayDL2Stats addObject:@(0)];
                        
                        [g.HomeDL3Stats addObject:@(0)];
                        [g.AwayDL3Stats addObject:@(0)];
                        
                        [g.HomeDL4Stats addObject:@(0)];
                        [g.AwayDL4Stats addObject:@(0)];
                        
                        [g.HomeLB1Stats addObject:@(0)];
                        [g.AwayLB1Stats addObject:@(0)];
                        
                        [g.HomeLB2Stats addObject:@(0)];
                        [g.AwayLB2Stats addObject:@(0)];
                        
                        [g.HomeLB3Stats addObject:@(0)];
                        [g.AwayLB3Stats addObject:@(0)];
                        
                        [g.HomeCB1Stats addObject:@(0)];
                        [g.AwayCB1Stats addObject:@(0)];
                        
                        [g.HomeCB2Stats addObject:@(0)];
                        [g.AwayCB2Stats addObject:@(0)];
                        
                        [g.HomeCB3Stats addObject:@(0)];
                        [g.AwayCB3Stats addObject:@(0)];
                        
                        [g.HomeSStats addObject:@(0)];
                        [g.AwaySStats addObject:@(0)];
                    }
                }
            }
            
            oldLigue.careerSacksRecord = nil;
            oldLigue.careerTacklesRecord = nil;
            oldLigue.careerPassDefRecord = nil;
            oldLigue.careerForcedFumRecord = nil;
            oldLigue.careerDefInterceptionsRecord = nil;
            
            oldLigue.singleSeasonSacksRecord = nil;
            oldLigue.singleSeasonTacklesRecord = nil;
            oldLigue.singleSeasonPassDefRecord = nil;
            oldLigue.singleSeasonForcedFumRecord = nil;
            oldLigue.singleSeasonDefInterceptionsRecord = nil;
            
            // if all league players were calculated, then recalculate
            if (oldLigue.currentWeek > 14 && (oldLigue.allLeaguePlayers != nil || oldLigue.allLeaguePlayers.count != 0)) {
                [oldLigue refreshAllLeaguePlayers];
            }
            
            // if all conf players were calculated, then recalculate
            for (Conference *c in oldLigue.conferences) {
                if (oldLigue.currentWeek > 14 && (c.allConferencePlayers != nil || c.allConferencePlayers.count != 0)) {
                    [c refreshAllConferencePlayers];
                }
            }
            
            oldLigue.leagueVersion = HB_CURRENT_APP_VERSION;
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                completionBlock(TRUE, @"Update complete!", oldLigue);
            });
            [[NSNotificationCenter defaultCenter] postNotificationName:@"newSaveFile" object:nil];
        });
    });
}


@end
