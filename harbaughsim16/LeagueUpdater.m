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
+(void)convertLeagueFromOldVersion:(League* _Nonnull)oldLigue updatingBlock:(void (^_Nullable)(float progress, NSString * _Nullable updateStatus))updatingBlock completionBlock:(void (^_Nullable)(BOOL success, NSString * _Nullable finalStatus, League * _Nonnull ligue))completionBlock {
    //Alg:
    // If app version is not the same as the league version:
        // check the properties of the league
            // drill down to teams and players
            // we know which were added in this new version, so check if those exist and load them with data if needed
        // if there are no new properties to update, just update the version
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        if (![oldLigue.leagueVersion isEqualToString:HB_CURRENT_APP_VERSION]) {
            if ([HB_CURRENT_APP_VERSION isEqualToString:HB_APP_VERSION_POST_OVERHAUL]) {
                __block float prgs = 0.0;
                oldLigue.baseYear = 2016;
                for (Team *t in oldLigue.teamList) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        prgs += 0.01;
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            updatingBlock(prgs, @"Updating team details...");
                        });
                    });
                    
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
                    t.teamStatOffNum = [t getCPUOffense];
                    t.teamStatDefNum = [t getCPUDefense];
                    t.offensiveStrategy = [t getOffensiveTeamStrategies][t.teamStatOffNum];
                    t.defensiveStrategy = [t getDefensiveTeamStrategies][t.teamStatDefNum];
                
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
                            updatingBlock(prgs, @"Updating league structure...");
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
                        updatingBlock(prgs, @"Finishing league updates...");
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
            }
        }
        
        oldLigue.leagueVersion = HB_CURRENT_APP_VERSION;
        [oldLigue save];
        dispatch_async(dispatch_get_main_queue(), ^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                completionBlock(TRUE, @"Update complete!", oldLigue);
            });
            [[NSNotificationCenter defaultCenter] postNotificationName:@"newSaveFile" object:nil];
        });
    });
}


@end
