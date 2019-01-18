//
//  Team.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/16/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "Team.h"

#import "PlayerQB.h"
#import "PlayerRB.h"
#import "PlayerWR.h"
#import "PlayerK.h"
#import "PlayerOL.h"
#import "PlayerLB.h"
#import "PlayerTE.h"
#import "PlayerDL.h"
#import "PlayerCB.h"
#import "PlayerS.h"
#import "HBSharedUtils.h"
#import "Record.h"

#import "AutoCoding.h"

#define NFL_OVR 90
#define NFL_CHANCE 0.50
#define NCG_DRAFT_BONUS 0.20
#define HARD_MODE_DRAFT_BONUS 0.20

#define RAT_TRANSFER 70
#define GRAD_TRANSFER_MIN_GAMES 6
#define GRAD_TRANSFER_RAT 77

@implementation Team
@synthesize league, name, abbreviation,conference,rivalTeam,isUserControlled,wonRivalryGame,numberOfRecruits,wins,losses,totalWins,totalLosses,totalCCs,totalNCs,totalCCLosses,totalNCLosses,totalBowlLosses,gameSchedule,oocGame0,oocGame4,oocGame9,gameWLSchedule,gameWinsAgainst,confChampion,semifinalWL,natlChampWL,teamPoints,teamOppPoints,teamYards,teamOppYards,teamPassYards,teamRushYards,teamOppPassYards,teamOppRushYards,teamTODiff,teamOffTalent,teamDefTalent,teamPrestige,teamPollScore,teamStrengthOfWins,teamStatDefNum,teamStatOffNum,rankTeamPoints,rankTeamOppPoints,rankTeamYards,rankTeamOppYards,rankTeamPassYards,rankTeamRushYards,rankTeamOppPassYards,rankTeamOppRushYards,rankTeamTODiff,rankTeamOffTalent,rankTeamDefTalent,rankTeamPrestige,rankTeamPollScore,rankTeamStrengthOfWins,diffPrestige,diffOffTalent,diffDefTalent,teamSs,teamKs,teamCBs,teamLBs, teamDLs,teamOLs,teamQBs,teamRBs,teamWRs,offensiveStrategy,defensiveStrategy,totalBowls,playersLeaving,singleSeasonCompletionsRecord,singleSeasonFgMadeRecord,singleSeasonRecTDsRecord,singleSeasonXpMadeRecord,singleSeasonCarriesRecord,singleSeasonCatchesRecord,singleSeasonFumblesRecord,singleSeasonPassTDsRecord,singleSeasonRushTDsRecord,singleSeasonRecYardsRecord,singleSeasonPassYardsRecord,singleSeasonRushYardsRecord,singleSeasonInterceptionsRecord,careerCompletionsRecord,careerFgMadeRecord,careerRecTDsRecord,careerXpMadeRecord,careerCarriesRecord,careerCatchesRecord,careerFumblesRecord,careerPassTDsRecord,careerRushTDsRecord,careerRecYardsRecord,careerPassYardsRecord,careerRushYardsRecord,careerInterceptionsRecord,streaks,deltaPrestige,heismans,rivalryWins,rivalryLosses,totalConfWins,totalConfLosses, confWins,confLosses,rankTeamTotalWins, injuredPlayers,recoveredPlayers,hallOfFamers,teamHistoryDictionary, teamHistory,teamTEs,teamF7s, state,recruitingClass,playersTransferring,transferClass,recruitingPoints,usedRecruitingPoints;

-(void)setWithCoder:(NSCoder *)aDecoder {
    [super setWithCoder:aDecoder];

    if (teamHistory.count > 0) {
        if (teamHistoryDictionary == nil) {
            teamHistoryDictionary = [NSMutableDictionary dictionary];
        }
        if (teamHistoryDictionary.count < teamHistory.count) {
            for (int i = 0; i < teamHistory.count; i++) {
                [teamHistoryDictionary setObject:teamHistory[i] forKey:[NSString stringWithFormat:@"%ld",(long)([HBSharedUtils currentLeague].baseYear + i)]];
            }
        }
    }
    
    if (state == nil) {
        // set the home state here
    }
    
    if (playersTransferring == nil) {
        playersTransferring = [NSMutableArray array];
    }
}

-(Player*)playerToWatch {
    NSMutableArray *topPlayers = [NSMutableArray array];
    if (teamQBs.count > 0) {
        [topPlayers addObject:teamQBs[0]];
    }

    //rb
    if (teamRBs.count >= 2) {
        for (int rb = 0; rb < 2; rb++) {
            [topPlayers addObject:teamRBs[rb]];
        }
    }

    //wr
    if (teamWRs.count >= 3) {
        for (int wr = 0; wr < 3; wr++) {
            [topPlayers addObject:teamWRs[wr]];
        }
    }

    if (topPlayers.count > 0) {
        [topPlayers sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            Player *a = (Player*)obj1;
            Player *b = (Player*)obj2;
            if (a.isHeisman || a.isROTY) {
                return -1;
            } else if (b.isHeisman || b.isROTY) {
                return 1;
            } else {
                return [a getHeismanScore] > [b getHeismanScore] ? -1 : [a getHeismanScore] == [b getHeismanScore] ? 0 : 1;
            }
        }];
        return topPlayers[0];
    } else {
        return nil;
    }
}

-(NSArray*)singleSeasonRecords {
    NSMutableArray *records = [NSMutableArray array];
    if (singleSeasonCompletionsRecord != nil) {
        [records addObject:singleSeasonCompletionsRecord];
    }

    if (singleSeasonPassYardsRecord != nil) {
        [records addObject:singleSeasonPassYardsRecord];
    }

    if (singleSeasonPassTDsRecord != nil) {
        [records addObject:singleSeasonPassTDsRecord];
    }

    if (singleSeasonInterceptionsRecord != nil) {
        [records addObject:singleSeasonInterceptionsRecord];
    }

    if (singleSeasonCarriesRecord != nil) {
        [records addObject:singleSeasonCarriesRecord];
    }

    if (singleSeasonRushYardsRecord != nil) {
        [records addObject:singleSeasonRushYardsRecord];
    }

    if (singleSeasonRushTDsRecord != nil) {
        [records addObject:singleSeasonRushTDsRecord];
    }

    if (singleSeasonFumblesRecord != nil) {
        [records addObject:singleSeasonFumblesRecord];
    }

    if (singleSeasonCatchesRecord != nil) {
        [records addObject:singleSeasonCatchesRecord];
    }

    if (singleSeasonRecYardsRecord != nil) {
        [records addObject:singleSeasonRecYardsRecord];
    }

    if (singleSeasonRecTDsRecord != nil) {
        [records addObject:singleSeasonRecTDsRecord];
    }

    if (singleSeasonXpMadeRecord != nil) {
        [records addObject:singleSeasonXpMadeRecord];
    }

    if (singleSeasonFgMadeRecord != nil) {
        [records addObject:singleSeasonFgMadeRecord];
    }

    return records;
}

-(NSArray*)careerRecords {
    NSMutableArray *records = [NSMutableArray array];
    if (careerCompletionsRecord != nil) {
        [records addObject:careerCompletionsRecord];
    }

    if (careerPassYardsRecord != nil) {
        [records addObject:careerPassYardsRecord];
    }

    if (careerPassTDsRecord != nil) {
        [records addObject:careerPassTDsRecord];
    }

    if (careerInterceptionsRecord != nil) {
        [records addObject:careerInterceptionsRecord];
    }

    if (careerCarriesRecord != nil) {
        [records addObject:careerCarriesRecord];
    }

    if (careerRushYardsRecord != nil) {
        [records addObject:careerRushYardsRecord];
    }

    if (careerRushTDsRecord != nil) {
        [records addObject:careerRushTDsRecord];
    }

    if (careerFumblesRecord != nil) {
        [records addObject:careerFumblesRecord];
    }

    if (careerCatchesRecord != nil) {
        [records addObject:careerCatchesRecord];
    }

    if (careerRecYardsRecord != nil) {
        [records addObject:careerRecYardsRecord];
    }

    if (careerRecTDsRecord != nil) {
        [records addObject:careerRecTDsRecord];
    }

    if (careerXpMadeRecord != nil) {
        [records addObject:careerXpMadeRecord];
    }

    if (careerFgMadeRecord != nil) {
        [records addObject:careerFgMadeRecord];
    }

    return records;
}

+(instancetype)newTeamWithName:(NSString *)nm abbreviation:(NSString *)abbr conference:(NSString *)conf league:(League *)league prestige:(int)prestige rivalTeam:(NSString *)rivalTeamAbbr state:(NSString*)stt {
    return [[Team alloc] initWithName:nm abbreviation:abbr conference:conf league:league prestige:prestige rivalTeam:rivalTeamAbbr state:stt];
}

-(instancetype)initWithName:(NSString*)nm abbreviation:(NSString*)abbr conference:(NSString*)conf league:(League*)ligue prestige:(int)prestige rivalTeam:(NSString*)rivalTeamAbbr state:(NSString*)stt {
    self = [super init];
    if (self) {
        league = ligue;
        isUserControlled = false;
        teamHistory = [NSMutableArray array];
        hallOfFamers = [NSMutableArray array];
        teamHistoryDictionary = [NSMutableDictionary dictionary];
        
        teamQBs = [NSMutableArray array];
        teamRBs = [NSMutableArray array];
        teamWRs = [NSMutableArray array];
        teamKs = [NSMutableArray array];
        teamOLs = [NSMutableArray array];
        teamLBs = [NSMutableArray array];
        teamTEs = [NSMutableArray array];
        teamDLs = [NSMutableArray array];
        teamSs = [NSMutableArray array];
        teamCBs = [NSMutableArray array];

        gameSchedule = [NSMutableArray array];
        playersLeaving = [NSMutableArray array];
        playersTransferring = [NSMutableArray array];
        injuredPlayers = [NSMutableArray array];
        oocGame0 = nil;
        oocGame4 = nil;
        oocGame9 = nil;
        gameWinsAgainst = [NSMutableArray array];
        gameWLSchedule = [NSMutableArray array];
        teamStreaks = [NSMutableDictionary dictionary];
        streaks = [NSMutableDictionary dictionary];
        confChampion = @"";
        semifinalWL = @"";
        natlChampWL = @"";
        recruitingClass = [NSMutableArray array];

        teamPrestige = prestige;
        [self recruitPlayers: @[@2, @4, @6, @2, @10, @2, @6, @8, @6, @2]];

        //set stats
        totalWins = 0;
        totalLosses = 0;

        confLosses = 0;
        confWins = 0;

        totalConfLosses = 0;
        totalConfWins = 0;

        totalCCs = 0;
        totalNCs = 0;

        totalBowls = 0;
        totalBowlLosses = 0;
        totalCCLosses = 0;
        totalNCLosses = 0;

        teamStatOffNum = [self getCPUOffense];
        teamStatDefNum = [self getCPUDefense];

        name = nm;
        abbreviation = abbr;
        conference = conf;
        rivalTeam = rivalTeamAbbr;
        state = stt;
        
        wonRivalryGame = false;
        teamPoints = 0;
        teamOppPoints = 0;
        teamYards = 0;
        teamOppYards = 0;
        teamPassYards = 0;
        teamRushYards = 0;
        teamOppPassYards = 0;
        teamOppRushYards = 0;
        teamTODiff = 0;
        rivalryLosses = 0;
        rivalryWins = 0;

        teamOffTalent = [self getOffensiveTalent];
        teamDefTalent = [self getDefensiveTalent];

        teamPollScore = teamPrestige + [self getOffensiveTalent] + [self getDefensiveTalent];

        offensiveStrategy = [self getOffensiveTeamStrategies][teamStatOffNum];
        defensiveStrategy = [self getDefensiveTeamStrategies][teamStatDefNum];
        numberOfRecruits = 30;

        careerCompletionsRecord = nil;
        careerPassYardsRecord = nil;
        careerPassTDsRecord = nil;
        careerInterceptionsRecord = nil;
        careerFumblesRecord = nil;
        careerRushYardsRecord = nil;
        careerRushTDsRecord = nil;
        careerCarriesRecord = nil;
        careerRecYardsRecord = nil;
        careerRecTDsRecord = nil;
        careerCatchesRecord = nil;
        careerXpMadeRecord = nil;
        careerFgMadeRecord = nil;

        singleSeasonCompletionsRecord = nil;
        singleSeasonPassYardsRecord = nil;
        singleSeasonPassTDsRecord = nil;
        singleSeasonInterceptionsRecord = nil;
        singleSeasonFumblesRecord = nil;
        singleSeasonRushYardsRecord = nil;
        singleSeasonRushTDsRecord = nil;
        singleSeasonCarriesRecord = nil;
        singleSeasonRecYardsRecord = nil;
        singleSeasonRecTDsRecord = nil;
        singleSeasonCatchesRecord = nil;
        singleSeasonXpMadeRecord = nil;
        singleSeasonFgMadeRecord = nil;
    }
    return self;
}

-(void)updateTalentRatings {
    teamOffTalent = [self getOffensiveTalent];
    teamDefTalent = [self getDefensiveTalent];
    teamPollScore = teamPrestige + [self getOffensiveTalent] + [self getDefensiveTalent];
}

-(void)advanceSeason {
    if (![self isEqual:league.blessedTeam] && ![self isEqual:league.cursedTeam]) {
        [self getSeasonSummaryString];

        teamPrestige += deltaPrestige;
    }

    if (teamPrestige > 95) teamPrestige = 95;
    
    if (!league.isHardMode) {
        if (teamPrestige < 45 && ![name isEqualToString:@"American Samoa"]) teamPrestige = 45;
    }
    
    if (teamPrestige <= 0) teamPrestige = 0;

    diffPrestige = deltaPrestige;

    //team records
    PlayerQB *qb = [self getQB:0];
    PlayerRB *rb1 = [self getRB:0];
    PlayerRB *rb2 = [self getRB:1];
    PlayerWR *wr1 = [self getWR:0];
    PlayerWR *wr2 = [self getWR:1];
    PlayerTE *te = [self getTE:0];
    PlayerK *k = [self getK:0];

    [qb checkRecords];
    [rb1 checkRecords];
    [rb2 checkRecords];
    [wr1 checkRecords];
    [wr2 checkRecords];
    [te checkRecords];
    [k checkRecords];

    [self advanceSeasonPlayers];
    
    if (!isUserControlled) {
        teamStatOffNum = [self getCPUOffense];
        teamStatDefNum = [self getCPUDefense];
        offensiveStrategy = [self getOffensiveTeamStrategies][teamStatOffNum];
        defensiveStrategy = [self getDefensiveTeamStrategies][teamStatDefNum];
    }
}

-(void)advanceSeasonPlayers {
    int qbNeeds=0, rbNeeds=0, wrNeeds=0, kNeeds=0, olNeeds=0, sNeeds=0, cbNeeds=0, dlNeeds=0, lbNeeds = 0, teNeeds = 0;
    int curYear = (int)league.leagueHistoryDictionary.count + (int)league.baseYear;
    
    if (playersLeaving == nil || playersLeaving.count == 0) {
        [self getGraduatingPlayers];
    }
    
    if (playersTransferring == nil) { // don't reload this if it's just empty cause we could get a different set of players
        [self getTransferringPlayers];
    }
    
    if (playersLeaving.count > 0 || playersTransferring.count > 0) {
        int i = 0;
        for (Player *p in playersLeaving) {
            p.endYear = curYear;
        }
        
        while (i < teamQBs.count) {
            if ([playersLeaving containsObject:teamQBs[i]] || [playersTransferring containsObject:teamQBs[i]]) {
                [teamQBs removeObjectAtIndex:i];
                qbNeeds++;
            } else {
                [teamQBs[i] advanceSeason];
                if ([transferClass containsObject:teamQBs[i]] && !teamQBs[i].isGradTransfer) {
                    teamQBs[i].isTransfer = YES;
                }
                i++;
            }
        }
        
        i = 0;
        while (i < teamRBs.count) {
            if ([playersLeaving containsObject:teamRBs[i]] || [playersTransferring containsObject:teamRBs[i]]) {
                [teamRBs removeObjectAtIndex:i];
                rbNeeds++;
            } else {
                [teamRBs[i] advanceSeason];
                if ([transferClass containsObject:teamRBs[i]] && !teamRBs[i].isGradTransfer) {
                    teamRBs[i].isTransfer = YES;
                }
                i++;
            }
        }
        
        i = 0;
        while (i < teamWRs.count) {
            if ([playersLeaving containsObject:teamWRs[i]] || [playersTransferring containsObject:teamWRs[i]]) {
                [teamWRs removeObjectAtIndex:i];
                wrNeeds++;
            } else {
                [teamWRs[i] advanceSeason];
                if ([transferClass containsObject:teamWRs[i]] && !teamWRs[i].isGradTransfer) {
                    teamWRs[i].isTransfer = YES;
                }
                i++;
            }
        }
        
        i = 0;
        while (i < teamTEs.count) {
            if ([playersLeaving containsObject:teamTEs[i]] || [playersTransferring containsObject:teamTEs[i]]) {
                [teamTEs removeObjectAtIndex:i];
                teNeeds++;
            } else {
                [teamTEs[i] advanceSeason];
                if ([transferClass containsObject:teamTEs[i]] && !teamTEs[i].isGradTransfer) {
                    teamTEs[i].isTransfer = YES;
                }
                i++;
            }
        }
        
        i = 0;
        while (i < teamKs.count) {
            if ([playersLeaving containsObject:teamKs[i]] || [playersTransferring containsObject:teamKs[i]]) {
                [teamKs removeObjectAtIndex:i];
                kNeeds++;
            } else {
                [teamKs[i] advanceSeason];
                if ([transferClass containsObject:teamKs[i]] && !teamKs[i].isGradTransfer) {
                    teamKs[i].isTransfer = YES;
                }
                i++;
            }
        }
        
        i = 0;
        while (i < teamOLs.count) {
            if ([playersLeaving containsObject:teamOLs[i]] || [playersTransferring containsObject:teamOLs[i]]) {
                [teamOLs removeObjectAtIndex:i];
                olNeeds++;
            } else {
                [teamOLs[i] advanceSeason];
                if ([transferClass containsObject:teamOLs[i]] && !teamOLs[i].isGradTransfer) {
                    teamOLs[i].isTransfer = YES;
                }
                i++;
            }
        }
        
        i = 0;
        while (i < teamSs.count) {
            if ([playersLeaving containsObject:teamSs[i]] || [playersTransferring containsObject:teamSs[i]]) {
                [teamSs removeObjectAtIndex:i];
                sNeeds++;
            } else {
                [teamSs[i] advanceSeason];
                if ([transferClass containsObject:teamSs[i]] && !teamSs[i].isGradTransfer) {
                    teamSs[i].isTransfer = YES;
                }
                i++;
            }
        }
        
        i = 0;
        while (i < teamCBs.count) {
            if ([playersLeaving containsObject:teamCBs[i]] || [playersTransferring containsObject:teamCBs[i]]) {
                [teamCBs removeObjectAtIndex:i];
                cbNeeds++;
            } else {
                [teamCBs[i] advanceSeason];
                if ([transferClass containsObject:teamCBs[i]] && !teamCBs[i].isGradTransfer) {
                    teamCBs[i].isTransfer = YES;
                }
                i++;
            }
        }
        
        i = 0;
        while (i < teamLBs.count) {
            if ([playersLeaving containsObject:teamLBs[i]] || [playersTransferring containsObject:teamLBs[i]]) {
                [teamLBs removeObjectAtIndex:i];
                lbNeeds++;
            } else {
                [teamLBs[i] advanceSeason];
                if ([transferClass containsObject:teamLBs[i]] && !teamLBs[i].isGradTransfer) {
                    teamLBs[i].isTransfer = YES;
                }
                i++;
            }
        }
        
        i = 0;
        while (i < teamDLs.count) {
            if ([playersLeaving containsObject:teamDLs[i]] || [playersTransferring containsObject:teamDLs[i]]) {
                [teamDLs removeObjectAtIndex:i];
                dlNeeds++;
            } else {
                [teamDLs[i] advanceSeason];
                if ([transferClass containsObject:teamDLs[i]] && !teamDLs[i].isGradTransfer) {
                    teamDLs[i].isTransfer = YES;
                }
                i++;
            }
        }
    } else {
        NSArray *players = [self getAllPlayers];
        for (Player *p in players) {
            [p advanceSeason];
            if ([transferClass containsObject:p] && !p.isGradTransfer) {
                p.isTransfer = YES;
            }
        }
    }
 
    [playersLeaving removeAllObjects];
    [injuredPlayers removeAllObjects];
    
     // all transfers have been added to new teams in -[TransferPeriodViewController advanceRecruits] and have been removed from this roster above. we can clear these out now.
    [playersTransferring removeAllObjects];
    [transferClass removeAllObjects];
    
    //if ( !isUserControlled ) {
        [self resetStats];
    //}
    [self sortPlayers];
}

-(void)recruitPlayers:(NSArray*)needs {
    teamQBs = [NSMutableArray array];
    teamRBs = [NSMutableArray array];
    teamWRs = [NSMutableArray array];
    teamKs = [NSMutableArray array];
    teamOLs = [NSMutableArray array];
    teamLBs = [NSMutableArray array];
    teamTEs = [NSMutableArray array];
    teamDLs = [NSMutableArray array];
    teamSs = [NSMutableArray array];
    teamCBs = [NSMutableArray array];
    
    int qbNeeds, rbNeeds, wrNeeds, kNeeds, olNeeds, sNeeds, cbNeeds, dlNeeds, lbNeeds, teNeeds;
    qbNeeds = [needs[0] intValue];
    rbNeeds = [needs[1] intValue];
    wrNeeds = [needs[2] intValue];
    kNeeds = [needs[3] intValue];
    olNeeds = [needs[4] intValue];
    sNeeds = [needs[5] intValue];
    cbNeeds = [needs[6] intValue];
    dlNeeds = [needs[7] intValue];
    lbNeeds = [needs[8] intValue];
    teNeeds = [needs[9] intValue];

    int stars = teamPrestige/20 + 1;
    int chance = 20 - (teamPrestige - 20 * (teamPrestige / 20)); //between 0 and 20

    for( int i = 0; i < qbNeeds; ++i ) {
        //make QBs
        if ((([HBSharedUtils randomValue] * 100)/100) < 5*chance ) {
            [teamQBs addObject:[PlayerQB newQBWithName:[league getRandName] year:(int)(4* [HBSharedUtils randomValue] + 1) stars:(stars - 1) team:self]];
        } else {
            [teamQBs addObject:[PlayerQB newQBWithName:[league getRandName] year:(int)(4* [HBSharedUtils randomValue] + 1) stars:(stars) team:self]];
        }
    }

    for( int i = 0; i < kNeeds; ++i ) {
        //make Ks
        if ((([HBSharedUtils randomValue] * 100)/100) < 5*chance ) {
            [teamKs addObject:[PlayerK newKWithName:[league getRandName] year:(int)(4* [HBSharedUtils randomValue] + 1) stars:(stars - 1) team:self]];
        } else {
            [teamKs addObject:[PlayerK newKWithName:[league getRandName] year:(int)(4* [HBSharedUtils randomValue] + 1) stars:(stars) team:self]];
        }
    }

    for( int i = 0; i < rbNeeds; ++i ) {
        //make RBs
        if ((([HBSharedUtils randomValue] * 100)/100) < 5*chance ) {
            [teamRBs addObject:[PlayerRB newRBWithName:[league getRandName] year:(int)(4* [HBSharedUtils randomValue] + 1) stars:(stars - 1) team:self]];
        } else {
            [teamRBs addObject:[PlayerRB newRBWithName:[league getRandName] year:(int)(4* [HBSharedUtils randomValue] + 1) stars:(stars) team:self]];
        }
    }

    for( int i = 0; i < wrNeeds; ++i ) {
        //make WRs
        if ((([HBSharedUtils randomValue] * 100)/100) < 5*chance ) {
            [teamWRs addObject:[PlayerWR newWRWithName:[league getRandName] year:(int)(4* [HBSharedUtils randomValue] + 1) stars:(stars - 1) team:self]];
        } else {
            [teamWRs addObject:[PlayerWR newWRWithName:[league getRandName] year:(int)(4* [HBSharedUtils randomValue] + 1) stars:(stars) team:self]];
        }
    }
    
    for( int i = 0; i < teNeeds; ++i ) {
        //make TEs
        if ((([HBSharedUtils randomValue] * 100)/100) < 5*chance ) {
            [teamTEs addObject:[PlayerTE newTEWithName:[league getRandName] year:(int)(4* [HBSharedUtils randomValue] + 1) stars:(stars - 1) team:self]];
        } else {
            [teamTEs addObject:[PlayerTE newTEWithName:[league getRandName] year:(int)(4* [HBSharedUtils randomValue] + 1) stars:(stars) team:self]];
        }
    }

    for( int i = 0; i < olNeeds; ++i ) {
        //make OLs
        if ((([HBSharedUtils randomValue] * 100)/100) < 5*chance ) {
            [teamOLs addObject:[PlayerOL newOLWithName:[league getRandName] year:(int)(4* [HBSharedUtils randomValue] + 1) stars:(stars - 1) team:self]];
        } else {
            [teamOLs addObject:[PlayerOL newOLWithName:[league getRandName] year:(int)(4* [HBSharedUtils randomValue] + 1) stars:(stars) team:self]];
        }
    }

    for( int i = 0; i < cbNeeds; ++i ) {
        //make CBs
        if ((([HBSharedUtils randomValue] * 100)/100) < 5*chance ) {
             [teamCBs addObject:[PlayerCB newCBWithName:[league getRandName] year:(int)(4* [HBSharedUtils randomValue] + 1) stars:(stars - 1) team:self]];
            //teamCBs addObject: new PlayerCB(league.getRandName(), (int)(4*[HBSharedUtils randomValue] + 1), stars-1) );
        } else {
            [teamCBs addObject:[PlayerCB newCBWithName:[league getRandName] year:(int)(4* [HBSharedUtils randomValue] + 1) stars:(stars) team:self]];
            //teamCBs addObject: new PlayerCB(league.getRandName(), (int)(4*[HBSharedUtils randomValue] + 1), stars) );
        }
    }

    for( int i = 0; i < lbNeeds; ++i ) {
        //make LBs
        if ((([HBSharedUtils randomValue] * 100)/100) < 5*chance ) {
            [teamLBs addObject:[PlayerLB newLBWithName:[league getRandName] year:(int)(4* [HBSharedUtils randomValue] + 1) stars:(stars - 1) team:self]];
        } else {
            [teamLBs addObject:[PlayerLB newLBWithName:[league getRandName] year:(int)(4* [HBSharedUtils randomValue] + 1) stars:(stars) team:self]];
        }
    }
    
    for( int i = 0; i < dlNeeds; ++i ) {
        //make DLs
        if ((([HBSharedUtils randomValue] * 100)/100) < 5*chance ) {
            [teamDLs addObject:[PlayerDL newDLWithName:[league getRandName] year:(int)(4* [HBSharedUtils randomValue] + 1) stars:(stars - 1) team:self]];
        } else {
            [teamDLs addObject:[PlayerDL newDLWithName:[league getRandName] year:(int)(4* [HBSharedUtils randomValue] + 1) stars:(stars) team:self]];
        }
    }

    for( int i = 0; i < sNeeds; ++i ) {
        //make Ss
        if ((([HBSharedUtils randomValue] * 100)/100) < 5*chance ) {
            [teamSs addObject:[PlayerS newSWithName:[league getRandName] year:(int)(4* [HBSharedUtils randomValue] + 1) stars:(stars - 1) team:self]];
        } else {
            [teamSs addObject:[PlayerS newSWithName:[league getRandName] year:(int)(4* [HBSharedUtils randomValue] + 1) stars:(stars) team:self]];
        }
    }

    //done making players, sort them
    [self sortPlayers];
}

-(NSInteger)_calculateTransferSlots:(NSString *)pos {
    NSMutableArray *players = [NSMutableArray array];
    if ([pos isEqualToString:@"QB"]) {
        players = self.teamQBs;
    } else if ([pos isEqualToString:@"RB"]) {
        players = self.teamRBs;
    } else if ([pos isEqualToString:@"WR"]) {
        players = self.teamWRs;
    } else if ([pos isEqualToString:@"TE"]) {
        players = self.teamTEs;
    } else if ([pos isEqualToString:@"OL"]) {
        players = self.teamOLs;
    } else if ([pos isEqualToString:@"DL"]) {
        players = self.teamDLs;
    } else if ([pos isEqualToString:@"LB"]) {
        players = self.teamLBs;
    } else if ([pos isEqualToString:@"CB"]) {
        players = self.teamCBs;
    } else if ([pos isEqualToString:@"S"]) {
        players = self.teamSs;
    } else { // K
        players = self.teamKs;
    }
    
    NSMutableArray *mapped = [NSMutableArray array];
    [players enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Player *p = (Player *)obj;
        if ([p.position isEqualToString:pos] && p.isTransfer) {
            [mapped addObject:p];
        }
    }];
    return mapped.count;
}

-(void)recruitPlayersFreshman:(NSArray*)needs {
    int qbNeeds, rbNeeds, wrNeeds, kNeeds, olNeeds, sNeeds, cbNeeds, dlNeeds, lbNeeds, teNeeds;
    qbNeeds = [needs[0] intValue];
    rbNeeds = [needs[1] intValue];
    wrNeeds = [needs[2] intValue];
    kNeeds = [needs[3] intValue];
    olNeeds = [needs[4] intValue];
    sNeeds = [needs[5] intValue];
    cbNeeds = [needs[6] intValue];
    dlNeeds = [needs[7] intValue];
    lbNeeds = [needs[8] intValue];
    teNeeds = [needs[9] intValue];

    if (qbNeeds > 2) {
        qbNeeds = 2;
    } else {
        if (teamQBs.count >= 2 && [self _calculateTransferSlots:@"QB"] == 0) {
            qbNeeds = 0;
        }
    }

    if (rbNeeds > 4) {
        rbNeeds = 4;
    } else {
        if (teamRBs.count >= 4 && [self _calculateTransferSlots:@"RB"] == 0) {
            rbNeeds = 0;
        }
    }

    if (wrNeeds > 6) {
        wrNeeds = 6;
    } else {
        if (teamWRs.count >= 6 && [self _calculateTransferSlots:@"WR"] == 0) {
            wrNeeds = 0;
        }
    }
    
    if (teNeeds > 2) {
        teNeeds = 2;
    } else {
        if (teamTEs.count >= 2 && [self _calculateTransferSlots:@"TE"] == 0) {
            teNeeds = 0;
        }
    }

    if (kNeeds > 2) {
        kNeeds = 2;
    } else {
        if (teamKs.count >= 2 && [self _calculateTransferSlots:@"K"] == 0) {
            kNeeds = 0;
        }
    }

    if (olNeeds > 10) {
        olNeeds = 10;
    } else {
        if (teamOLs.count >= 10 && [self _calculateTransferSlots:@"OL"] == 0) {
            olNeeds = 0;
        }
    }

    if (sNeeds > 2) {
        sNeeds = 2;
    } else {
        if (teamSs.count >= 2 && [self _calculateTransferSlots:@"S"] == 0) {
            sNeeds = 0;
        }
    }

    if (cbNeeds > 6) {
        cbNeeds = 6;
    } else {
        if (teamCBs.count >= 6 && [self _calculateTransferSlots:@"CB"] == 0) {
            cbNeeds = 0;
        }
    }

    if (lbNeeds > 6) {
        lbNeeds = 6;
    } else {
        if (teamLBs.count >= 6 && [self _calculateTransferSlots:@"LB"] == 0) {
            lbNeeds = 0;
        }
    }
    
    if (dlNeeds > 8) {
        dlNeeds = 8;
    } else {
        if (teamDLs.count >= 8 && [self _calculateTransferSlots:@"DL"] == 0) {
            dlNeeds = 0;
        }
    }

    int stars;
    int chance = 20 - (teamPrestige - 20*( teamPrestige/20 )); //between 0 and 20

    double starsBonusChance = 0.15;
    double starsBonusDoubleChance = 0.05;

    for( int i = 0; i < qbNeeds; ++i ) {
        //make QBs
        stars = teamPrestige/20 + 1;
        if ([HBSharedUtils randomValue] < starsBonusChance) {
            stars += 1;
        } else if ([HBSharedUtils randomValue] < starsBonusDoubleChance) {
            stars += 2;
        }
        
        PlayerQB *qb;
        if ((([HBSharedUtils randomValue] * 100)/100) < 5*chance ) {
            qb = [PlayerQB newQBWithName:[league getRandName] year:1 stars:(stars - 1) team:self];
        } else {
            qb = [PlayerQB newQBWithName:[league getRandName] year:1 stars:(stars) team:self];
        }
        [recruitingClass addObject:qb];
        [teamQBs addObject:qb];
    }

    for( int i = 0; i < kNeeds; ++i ) {
        //make Ks
        stars = teamPrestige/20 + 1;
        if ([HBSharedUtils randomValue] < starsBonusChance) {
            stars += 1;
        } else if ([HBSharedUtils randomValue] < starsBonusDoubleChance) {
            stars += 2;
        }

        PlayerK *k;
        if ((([HBSharedUtils randomValue] * 100)/100) < 5*chance ) {
            k = [PlayerK newKWithName:[league getRandName] year:1 stars:(stars - 1) team:self];
        } else {
            k = [PlayerK newKWithName:[league getRandName] year:1 stars:(stars) team:self];
        }
        [recruitingClass addObject:k];
        [teamKs addObject:k];
    }

    for( int i = 0; i < rbNeeds; ++i ) {
        //make RBs
        stars = teamPrestige/20 + 1;
        if ([HBSharedUtils randomValue] < starsBonusChance) {
            stars += 1;
        } else if ([HBSharedUtils randomValue] < starsBonusDoubleChance) {
            stars += 2;
        }

        PlayerRB *rb;
        if ((([HBSharedUtils randomValue] * 100)/100) < 5*chance ) {
            rb = [PlayerRB newRBWithName:[league getRandName] year:1 stars:(stars - 1) team:self];
        } else {
            rb = [PlayerRB newRBWithName:[league getRandName] year:1 stars:(stars) team:self];
        }
        [recruitingClass addObject:rb];
        [teamRBs addObject:rb];
    }

    for( int i = 0; i < wrNeeds; ++i ) {
        //make WRs
        stars = teamPrestige/20 + 1;
        if ([HBSharedUtils randomValue] < starsBonusChance) {
            stars += 1;
        } else if ([HBSharedUtils randomValue] < starsBonusDoubleChance) {
            stars += 2;
        }

        PlayerWR *wr;
        if ((([HBSharedUtils randomValue] * 100)/100) < 5*chance ) {
            wr = [PlayerWR newWRWithName:[league getRandName] year:1 stars:(stars - 1) team:self];
        } else {
            wr = [PlayerWR newWRWithName:[league getRandName] year:1 stars:(stars) team:self];
        }
        [recruitingClass addObject:wr];
        [teamWRs addObject:wr];
    }
    
    for( int i = 0; i < teNeeds; ++i ) {
        //make TEs
        stars = teamPrestige/20 + 1;
        if ([HBSharedUtils randomValue] < starsBonusChance) {
            stars += 1;
        } else if ([HBSharedUtils randomValue] < starsBonusDoubleChance) {
            stars += 2;
        }
        
        PlayerTE *te;
        if ((([HBSharedUtils randomValue] * 100)/100) < 5*chance ) {
            te = [PlayerTE newTEWithName:[league getRandName] year:1 stars:(stars - 1) team:self];
        } else {
            te = [PlayerTE newTEWithName:[league getRandName] year:1 stars:(stars) team:self];
        }
        [recruitingClass addObject:te];
        [teamTEs addObject:te];
    }

    for( int i = 0; i < olNeeds; ++i ) {
        //make OLs
        stars = teamPrestige/20 + 1;
        if ([HBSharedUtils randomValue] < starsBonusChance) {
            stars += 1;
        } else if ([HBSharedUtils randomValue] < starsBonusDoubleChance) {
            stars += 2;
        }

        PlayerOL *ol;
        if ((([HBSharedUtils randomValue] * 100)/100) < 5*chance ) {
            ol = [PlayerOL newOLWithName:[league getRandName] year:1 stars:(stars - 1) team:self];
        } else {
            ol = [PlayerOL newOLWithName:[league getRandName] year:1 stars:(stars) team:self];
        }
        [recruitingClass addObject:ol];
        [teamOLs addObject:ol];
    }

    for( int i = 0; i < cbNeeds; ++i ) {
        //make CBs
        stars = teamPrestige/20 + 1;
        if ([HBSharedUtils randomValue] < starsBonusChance) {
            stars += 1;
        } else if ([HBSharedUtils randomValue] < starsBonusDoubleChance) {
            stars += 2;
        }

        PlayerCB *cb;
        if ((([HBSharedUtils randomValue] * 100)/100) < 5*chance ) {
            cb = [PlayerCB newCBWithName:[league getRandName] year:1 stars:(stars - 1) team:self];
        } else {
            cb = [PlayerCB newCBWithName:[league getRandName] year:1 stars:(stars) team:self];
        }
        [recruitingClass addObject:cb];
        [teamCBs addObject:cb];
    }
    
    for( int i = 0; i < lbNeeds; ++i ) {
        //make LBs
        stars = teamPrestige/20 + 1;
        if ([HBSharedUtils randomValue] < starsBonusChance) {
            stars += 1;
        } else if ([HBSharedUtils randomValue] < starsBonusDoubleChance) {
            stars += 2;
        }
        
        PlayerLB *lb;
        if ((([HBSharedUtils randomValue] * 100)/100) < 5*chance ) {
            lb = [PlayerLB newLBWithName:[league getRandName] year:1 stars:(stars - 1) team:self];
        } else {
            lb = [PlayerLB newLBWithName:[league getRandName] year:1 stars:(stars) team:self];
        }
        [recruitingClass addObject:lb];
        [teamLBs addObject:lb];
    }

    for( int i = 0; i < dlNeeds; ++i ) {
        //make DLs
        stars = teamPrestige/20 + 1;
        if ([HBSharedUtils randomValue] < starsBonusChance) {
            stars += 1;
        } else if ([HBSharedUtils randomValue] < starsBonusDoubleChance) {
            stars += 2;
        }

        PlayerDL *dl;
        if ((([HBSharedUtils randomValue] * 100)/100) < 5*chance ) {
            dl = [PlayerDL newDLWithName:[league getRandName] year:1 stars:(stars - 1) team:self];
        } else {
            dl = [PlayerDL newDLWithName:[league getRandName] year:1 stars:(stars) team:self];
        }
        [recruitingClass addObject:dl];
        [teamDLs addObject:dl];
    }

    for( int i = 0; i < sNeeds; ++i ) {
        //make Ss
        stars = teamPrestige/20 + 1;
        if ([HBSharedUtils randomValue] < starsBonusChance) {
            stars += 1;
        } else if ([HBSharedUtils randomValue] < starsBonusDoubleChance) {
            stars += 2;
        }
        PlayerS *s;
        if ((([HBSharedUtils randomValue] * 100)/100) < 5*chance ) {
            s = [PlayerS newSWithName:[league getRandName] year:1 stars:(stars - 1) team:self];
        } else {
            s = [PlayerS newSWithName:[league getRandName] year:1 stars:(stars) team:self];
        }
        [recruitingClass addObject:s];
        [teamSs addObject:s];
    }

    //done making players, sort them
    [self sortPlayers];
    [recruitingClass sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [HBSharedUtils comparePlayers:obj1 toObj2:obj2];
    }];
}

-(void)recruitWalkOns:(NSArray*)needs {
    int qbNeeds, rbNeeds, wrNeeds, kNeeds, olNeeds, sNeeds, cbNeeds, dlNeeds, lbNeeds, teNeeds;
    qbNeeds = [needs[0] intValue];
    rbNeeds = [needs[1] intValue];
    wrNeeds = [needs[2] intValue];
    kNeeds = [needs[3] intValue];
    olNeeds = [needs[4] intValue];
    sNeeds = [needs[5] intValue];
    cbNeeds = [needs[6] intValue];
    dlNeeds = [needs[7] intValue];
    lbNeeds = [needs[8] intValue];
    teNeeds = [needs[9] intValue];
    
    if (qbNeeds > 2) {
        qbNeeds = 2;
    } else {
        if (teamQBs.count >= 2 && [self _calculateTransferSlots:@"QB"] == 0) {
            qbNeeds = 0;
        }
    }
    
    if (rbNeeds > 4) {
        rbNeeds = 4;
    } else {
        if (teamRBs.count >= 4 && [self _calculateTransferSlots:@"RB"] == 0) {
            rbNeeds = 0;
        }
    }
    
    if (wrNeeds > 6) {
        wrNeeds = 6;
    } else {
        if (teamWRs.count >= 6 && [self _calculateTransferSlots:@"WR"] == 0) {
            wrNeeds = 0;
        }
    }
    
    if (teNeeds > 2) {
        teNeeds = 2;
    } else {
        if (teamTEs.count >= 2 && [self _calculateTransferSlots:@"TE"] == 0) {
            teNeeds = 0;
        }
    }
    
    if (kNeeds > 2) {
        kNeeds = 2;
    } else {
        if (teamKs.count >= 2 && [self _calculateTransferSlots:@"K"] == 0) {
            kNeeds = 0;
        }
    }
    
    if (olNeeds > 10) {
        olNeeds = 10;
    } else {
        if (teamOLs.count >= 10 && [self _calculateTransferSlots:@"OL"] == 0) {
            olNeeds = 0;
        }
    }
    
    if (sNeeds > 2) {
        sNeeds = 2;
    } else {
        if (teamSs.count >= 2 && [self _calculateTransferSlots:@"S"] == 0) {
            sNeeds = 0;
        }
    }
    
    if (cbNeeds > 6) {
        cbNeeds = 6;
    } else {
        if (teamCBs.count >= 6 && [self _calculateTransferSlots:@"CB"] == 0) {
            cbNeeds = 0;
        }
    }
    
    if (lbNeeds > 6) {
        lbNeeds = 6;
    } else {
        if (teamLBs.count >= 6 && [self _calculateTransferSlots:@"LB"] == 0) {
            lbNeeds = 0;
        }
    }
    
    if (dlNeeds > 8) {
        dlNeeds = 8;
    } else {
        if (teamDLs.count >= 8 && [self _calculateTransferSlots:@"DL"] == 0) {
            dlNeeds = 0;
        }
    }

    for( int i = 0; i < qbNeeds; ++i ) {
        //make QBs
        PlayerQB *qb = [PlayerQB newQBWithName:[league getRandName] year:1 stars:1 team:self];
        [teamQBs addObject:qb];
        [recruitingClass addObject:qb];
    }

    for( int i = 0; i < rbNeeds; ++i ) {
        //make RBs
        PlayerRB *rb = [PlayerRB newRBWithName:[league getRandName] year:1 stars:1 team:self];
        [teamRBs addObject:rb];
        [recruitingClass addObject:rb];
    }

    for( int i = 0; i < wrNeeds; ++i ) {
        //make WRs
        PlayerWR *wr = [PlayerWR newWRWithName:[league getRandName] year:1 stars:1 team:self];
        [teamWRs addObject:wr];
        [recruitingClass addObject:wr];
    }
    
    for( int i = 0; i < teNeeds; ++i ) {
        //make TEs
        PlayerTE *te = [PlayerTE newTEWithName:[league getRandName] year:1 stars:1 team:self];
        [teamTEs addObject:te];
        [recruitingClass addObject:te];
    }

    for( int i = 0; i < olNeeds; ++i ) {
        //make OLs
        PlayerOL *ol = [PlayerOL newOLWithName:[league getRandName] year:1 stars:1 team:self];
        [teamOLs addObject:ol];
        [recruitingClass addObject:ol];
    }

    for( int i = 0; i < kNeeds; ++i ) {
        //make Ks
        PlayerK *k = [PlayerK newKWithName:[league getRandName] year:1 stars:1 team:self];
        [teamKs addObject:k];
        [recruitingClass addObject:k];
    }

    for( int i = 0; i < sNeeds; ++i ) {
        //make Ss
        PlayerS *s = [PlayerS newSWithName:[league getRandName] year:1 stars:1 team:self];
        [teamSs addObject:s];
        [recruitingClass addObject:s];
    }

    for( int i = 0; i < cbNeeds; ++i ) {
        //make CBs
        PlayerCB *cb = [PlayerCB newCBWithName:[league getRandName] year:1 stars:1 team:self];
        [teamCBs addObject:cb];
        [recruitingClass addObject:cb];
    }
    
    for( int i = 0; i < lbNeeds; ++i ) {
        //make LBs
        PlayerLB *lb = [PlayerLB newLBWithName:[league getRandName] year:1 stars:1 team:self];
        [teamLBs addObject:lb];
        [recruitingClass addObject:lb];
    }

    for( int i = 0; i < dlNeeds; ++i ) {
        //make DLs
        PlayerDL *dl = [PlayerDL newDLWithName:[league getRandName] year:1 stars:1 team:self];
        [teamDLs addObject:dl];
        [recruitingClass addObject:dl];
    }

    //done making players, sort them
    [self sortPlayers];
    [recruitingClass sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [HBSharedUtils comparePlayers:obj1 toObj2:obj2];
    }];
}

-(NSMutableArray<Player*>*)getAllPlayers {
    NSMutableArray<Player*> *players = [NSMutableArray array];
    [players addObjectsFromArray:teamQBs];
    [players addObjectsFromArray:teamRBs];
    [players addObjectsFromArray:teamWRs];
    [players addObjectsFromArray:teamTEs];
    [players addObjectsFromArray:teamOLs];
    [players addObjectsFromArray:teamKs];
    [players addObjectsFromArray:teamSs];
    [players addObjectsFromArray:teamCBs];
    [players addObjectsFromArray:teamLBs];
    [players addObjectsFromArray:teamDLs];
    return players;
}

-(void)resetStats {
    gameSchedule = [NSMutableArray array];
    oocGame0 = nil;
    oocGame4 = nil;
    oocGame9 = nil;
    gameWinsAgainst = [NSMutableArray array];
    gameWLSchedule = [NSMutableArray array];
    injuredPlayers = [NSMutableArray array];
    recruitingPoints = 0;
    usedRecruitingPoints = 0;
    confChampion = @"";
    semifinalWL = @"";
    natlChampWL = @"";
    wins = 0;
    losses = 0;
    confWins = 0;
    confLosses = 0;
    rivalryLosses = 0;
    rivalryWins = 0;

    teamPoints = 0;
    teamOppPoints = 0;
    teamYards = 0;
    teamOppYards = 0;
    teamPassYards = 0;
    teamRushYards = 0;
    teamOppPassYards = 0;
    teamOppRushYards = 0;
    teamTODiff = 0;
    wonRivalryGame = false;
    diffOffTalent = [self getOffensiveTalent] - teamOffTalent;
    teamOffTalent = [self getOffensiveTalent];
    diffDefTalent = [self getDefensiveTalent] - teamDefTalent;
    teamDefTalent = [self getDefensiveTalent];
    teamPollScore = teamPrestige + [self getOffensiveTalent] + [self getDefensiveTalent];

    if (!isUserControlled) {
        teamStatOffNum = [self getCPUOffense];
        teamStatDefNum = [self getCPUDefense];
        offensiveStrategy = [self getOffensiveTeamStrategies][teamStatOffNum];
        defensiveStrategy = [self getDefensiveTeamStrategies][teamStatDefNum];
    }
}

-(void)updatePollScore {
    [self updateStrengthOfWins];
    int preseasonBias = 8 - (wins + losses);
    if (preseasonBias < 0) preseasonBias = 0;
    teamPollScore = (wins*200 + 3*(teamPoints-teamOppPoints) + (teamYards-teamOppYards)/40 + (teamStrengthOfWins / 2) + 3*(preseasonBias)*(teamPrestige + [self getOffensiveTalent] + [self getDefensiveTalent]) + teamStrengthOfWins)/11 + (teamPrestige / 5);
    if ([@"CC" isEqualToString:confChampion] ) {
        //bonus for winning conference
        teamPollScore += 25;
    }
    if ( [@"NCW" isEqualToString:natlChampWL] ) {
        //bonus for winning champ game
        teamPollScore += 100;
    }
    if ( [@"NCL" isEqualToString:natlChampWL] ) {
        //bonus for winning champ game
        teamPollScore += 15;
    }
    if (losses == 0) {
        teamPollScore += 30;
    } else if (losses == 1 ) {
        teamPollScore += 15;
    } else {
        teamPollScore += 0;
    }

    if (teamPollScore < 0) {
        teamPollScore = 0;
    }
}

-(void)updateTeamHistory {
    NSMutableString *hist = [NSMutableString string];

    if (rankTeamPollScore > 0 && rankTeamPollScore < 26) {
        [hist appendFormat:@"#%ld %@ (%ld-%ld)\nPrestige: %ld",(long)rankTeamPollScore, abbreviation, (long)wins, (long)losses, (long)teamPrestige];
    } else {
        [hist appendFormat:@"%@ (%ld-%ld)\nPrestige: %ld",abbreviation, (long)wins, (long)losses, (long)teamPrestige];
    }

    if (![confChampion isEqualToString:@""] && confChampion.length > 0) {
        Game *ccg = [league findConference:conference].ccg;
        if (gameWLSchedule.count >= 13) {
            if ([confChampion isEqualToString:@"CC"]) {
                [hist appendFormat:@"\n%@ - W %@",ccg.gameName,[self gameSummaryString:ccg]];
            } else { 
                [hist appendFormat:@"\n%@ - L %@",ccg.gameName,[self gameSummaryString:ccg]];
            }
        }
    }

    if (gameSchedule.count > 12 && gameWLSchedule.count > 12) {
        if (![semifinalWL isEqualToString:@""] && semifinalWL.length > 0) {
            if ([semifinalWL isEqualToString:@"BW"] || [semifinalWL isEqualToString:@"BL"] || [semifinalWL containsString:@"SF"]) {
                if (gameSchedule.count > 12 && gameWLSchedule.count > 12) {
                    Game *bowl = gameSchedule[12];
                    if (bowl && ([bowl.gameName containsString:@"Bowl"] || [bowl.gameName containsString:@"Semis"])) {
                        [hist appendFormat:@"\n%@ - %@ %@",bowl.gameName,gameWLSchedule[12],[self gameSummaryString:bowl]];
                    }
                }

                if (gameSchedule.count > 13 && gameWLSchedule.count > 13) {
                    Game *bowl = gameSchedule[13];
                    if (bowl && ([bowl.gameName containsString:@"Bowl"] || [bowl.gameName containsString:@"Semis"])) {
                        [hist appendFormat:@"\n%@ - %@ %@",bowl.gameName,gameWLSchedule[13],[self gameSummaryString:bowl]];
                    }
                }
            }
        }

        if (![natlChampWL isEqualToString:@""] && natlChampWL.length > 0) {
            Game *ncg = league.ncg;
            [hist appendFormat:@"\n%@ - %@ %@",ncg.gameName,gameWLSchedule[gameWLSchedule.count - 1],[self gameSummaryString:ncg]];
        }
    }

    [teamHistoryDictionary setObject:hist forKey:[NSString stringWithFormat:@"%ld",(long)([HBSharedUtils currentLeague].baseYear + league.leagueHistoryDictionary.count)]];
}

-(void)updateStrengthOfWins {
    int strWins = 0;
    for ( int i = 0; i < gameSchedule.count; ++i ) {
        Game *g = gameSchedule[i];
        if (g.homeTeam == self) {
            strWins += pow(60 - g.awayTeam.rankTeamPollScore,2);
        } else {
            strWins += pow(60 - g.homeTeam.rankTeamPollScore,2);
        }
    }
    teamStrengthOfWins = strWins/50;
    for (Team *t in gameWinsAgainst) {
        teamStrengthOfWins += pow(t.wins,2);
    }
}

-(void)sortPlayers {
    [teamQBs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [HBSharedUtils compareDepthChartPositions:obj1 toObj2:obj2];
    }];
    [teamRBs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [HBSharedUtils compareDepthChartPositions:obj1 toObj2:obj2];
    }];
    [teamWRs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [HBSharedUtils compareDepthChartPositions:obj1 toObj2:obj2];
    }];
    [teamTEs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [HBSharedUtils compareDepthChartPositions:obj1 toObj2:obj2];
    }];
    [teamKs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [HBSharedUtils compareDepthChartPositions:obj1 toObj2:obj2];
    }];
    [teamOLs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [HBSharedUtils compareDepthChartPositions:obj1 toObj2:obj2];
    }];
    [teamCBs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [HBSharedUtils compareDepthChartPositions:obj1 toObj2:obj2];
    }];
    [teamSs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [HBSharedUtils compareDepthChartPositions:obj1 toObj2:obj2];
    }];
    [teamDLs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [HBSharedUtils compareDepthChartPositions:obj1 toObj2:obj2];
    }];
    [teamLBs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [HBSharedUtils compareDepthChartPositions:obj1 toObj2:obj2];
    }];
}

-(void)sortPlayersPostInjury {
    [teamQBs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [HBSharedUtils compareDepthChartPositionsPostInjury:obj1 toObj2:obj2];
    }];
    [teamRBs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [HBSharedUtils compareDepthChartPositionsPostInjury:obj1 toObj2:obj2];
    }];
    [teamWRs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [HBSharedUtils compareDepthChartPositionsPostInjury:obj1 toObj2:obj2];
    }];
    [teamTEs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [HBSharedUtils compareDepthChartPositionsPostInjury:obj1 toObj2:obj2];
    }];
    [teamKs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [HBSharedUtils compareDepthChartPositionsPostInjury:obj1 toObj2:obj2];
    }];
    [teamOLs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [HBSharedUtils compareDepthChartPositionsPostInjury:obj1 toObj2:obj2];
    }];
    [teamCBs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [HBSharedUtils compareDepthChartPositionsPostInjury:obj1 toObj2:obj2];
    }];
    [teamSs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [HBSharedUtils compareDepthChartPositionsPostInjury:obj1 toObj2:obj2];
    }];
    [teamDLs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [HBSharedUtils compareDepthChartPositionsPostInjury:obj1 toObj2:obj2];
    }];
    [teamLBs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [HBSharedUtils compareDepthChartPositionsPostInjury:obj1 toObj2:obj2];
    }];
}

-(int)getOffensiveTalent {
    return ([self getQB:0].ratOvr*5 + [self getWR:0].ratOvr + [self getWR:1].ratOvr + [self getWR:2].ratOvr + [self getRB:0].ratOvr + [self getRB:1].ratOvr + [self getCompositeOLPass] + [self getCompositeOLRush] ) / 12;
}

-(int)getDefensiveTalent {
    return ( [self getRushDef] + [self getPassDef] ) / 2;
}

-(PlayerQB*)getQB:(int)depth {
    if (teamQBs.count > 0 && depth < teamQBs.count && depth >= 0 ) {
        return teamQBs[depth];
    } else {
        return nil;
    }
}

-(PlayerRB*)getRB:(int)depth {
    if (teamRBs.count > 0 && depth < teamRBs.count && depth >= 0 ) {
        return teamRBs[depth];
    } else {
        return nil;
    }
}

-(PlayerWR*)getWR:(int)depth {
    if (teamWRs.count > 0 && depth < teamWRs.count && depth >= 0 ) {
        return teamWRs[depth];
    } else {
        return nil;
    }
}

-(PlayerK*)getK:(int)depth {
    if (teamKs.count > 0 && depth < teamKs.count && depth >= 0 ) {
        return teamKs[depth];
    } else {
        return nil;
    }
}

-(PlayerOL*)getOL:(int)depth {
    if (teamOLs.count > 0 && depth < teamOLs.count && depth >= 0 ) {
        return teamOLs[depth];
    } else {
        return nil;
    }
}

-(PlayerS*)getS:(int)depth {
    if (teamSs.count > 0 && depth < teamSs.count && depth >= 0 ) {
        return teamSs[depth];
    } else {
        return nil;
    }
}

-(PlayerCB*)getCB:(int)depth {
    if (teamCBs.count > 0 && depth < teamCBs.count && depth >= 0 ) {
        return teamCBs[depth];
    } else {
        return nil;
    }
}

-(PlayerDL*)getDL:(int)depth {
    if (teamDLs.count > 0 && depth < teamDLs.count && depth >= 0 ) {
        return teamDLs[depth];
    } else {
        return nil;
    }
}

-(PlayerTE*)getTE:(int)depth {
    if (teamTEs.count > 0 && depth < teamTEs.count && depth >= 0 ) {
        return teamTEs[depth];
    } else {
        return nil;
    }
}

-(PlayerLB*)getLB:(int)depth {
    if (teamLBs.count > 0 && depth < teamLBs.count && depth >= 0 ) {
        return teamLBs[depth];
    } else {
        return nil;
    }
}

-(int)getPassProf {
    int avgWRs = ([self getWR:0].ratOvr + [self getWR:1].ratOvr + [self getTE:0].ratOvr) / 4;
    return ([self getCompositeOLPass] + [self getQB:0].ratOvr * 2 + avgWRs) / 4;
}

-(int)getRushProf {
    int avgRBs = ([self getRB:0].ratOvr + [self getRB:1].ratOvr) / 2;
    int QB = [self getQB:0].ratSpeed;
    return (3 * [self getCompositeOLRush] + 3 * avgRBs + QB) / 7;
}

-(int)getPassDef {
    int avgCBs = ([self getCB:0].ratOvr + [self getCB:1].ratOvr + [self getCB:2].ratOvr) / 3;
    int avgLBs = ([self getLB:0].ratLBPas + [self getLB:1].ratLBPas + [self getLB:2].ratLBPas) / 3;
    int S = ([self getS:0].ratSCov);
    int def = (3 * avgCBs + avgLBs + S) / 5;
    return (def * 3 + [self getS:0].ratOvr + [self getCompositeF7Pass] * 2) / 6;
}

-(int)getRushDef {
    return [self getCompositeF7Rush];
}

-(int)getCompositeOLPass {
    int compositeOL = 0;
    if (teamOLs.count >= 5) {
        for ( int i = 0; i < 5; ++i ) {
            compositeOL += (teamOLs[i].ratOLPow + teamOLs[i].ratOLBkP)/2;
        }
        if (self.offensiveStrategy.passUsage > 0) {
            compositeOL += ([self getTE:0] != nil) ? [self getTE:0].ratTERunBlk : 0;
            return ([self getTE:0] != nil) ? compositeOL / 5.5 : compositeOL / 5;
        } else {
            return compositeOL / 5;
        }
    } else {
        for ( int i = 0; i < teamOLs.count; ++i ) {
            compositeOL += (teamOLs[i].ratOLPow + teamOLs[i].ratOLBkP)/2;
        }
        if (self.offensiveStrategy.passUsage > 0) {
            compositeOL += ([self getTE:0] != nil) ? [self getTE:0].ratTERunBlk : 0;
            return ([self getTE:0] != nil) ? compositeOL / (0.5 + (float)(teamOLs.count)) : compositeOL / teamOLs.count;
        } else {
            return compositeOL / teamOLs.count;
        }
    }
}

-(int)getCompositeOLRush {
    int compositeOL = 0;
    if (teamOLs.count >= 5) {
        for ( int i = 0; i < 5; ++i ) {
            compositeOL += (teamOLs[i].ratOLPow + teamOLs[i].ratOLBkR)/2;
        }
        if (self.offensiveStrategy.runUsage > 0) {
            compositeOL += ([self getTE:0] != nil) ? [self getTE:0].ratTERunBlk : 0;
            return ([self getTE:0] != nil) ? compositeOL / 5.5 : compositeOL / 5;
        } else {
            return compositeOL / 5;
        }
    } else {
        for ( int i = 0; i < teamOLs.count; ++i ) {
            compositeOL += (teamOLs[i].ratOLPow + teamOLs[i].ratOLBkR)/2;
        }
        if (self.offensiveStrategy.runUsage > 0) {
            compositeOL += ([self getTE:0] != nil) ? [self getTE:0].ratTERunBlk : 0;
            return ([self getTE:0] != nil) ? compositeOL / (0.5 + (float)(teamOLs.count)) : compositeOL / teamOLs.count;
        } else {
            return compositeOL / teamOLs.count;
        }
    }
}

-(int)getCompositeFootIQ {
    int comp = 0;
    comp += [self getQB:0].ratFootIQ * 5;
    comp += [self getRB:0].ratFootIQ + [self getRB:1].ratFootIQ;
    comp += [self getWR:0].ratFootIQ + [self getWR:1].ratFootIQ + [self getWR:2].ratFootIQ;
    for (int i = 0; i < 5; ++i) {
        comp += [self getOL:i].ratFootIQ/5;
    }
    comp += [self getS:0].ratFootIQ * 5;
    comp += [self getCB:0].ratFootIQ + [self getCB:1].ratFootIQ + [self getCB:2].ratFootIQ;
    for (int i = 0; i < 4; ++i) {
        comp += [self getDL:i].ratFootIQ/4;
    }
    for (int i = 0; i < 3; ++i) {
        comp += [self getLB:i].ratFootIQ;
    }
    return comp / 22;
}


-(int)getCompositeF7Pass {
    int compositeF7 = 0;
    if (teamDLs.count >= 4) {
        for ( int i = 0; i < 4; ++i ) {
            compositeF7 += (teamDLs[i].ratDLPow + teamDLs[i].ratDLPas)/2;
        }
    } else {
        for ( int i = 0; i < teamDLs.count; ++i ) {
            compositeF7 += (teamDLs[i].ratDLPow + teamDLs[i].ratDLPas)/2;
        }
    }
    
    if (self.defensiveStrategy.passUsage > 0) {
        PlayerLB *selLB = [self getLB:0];
        if (selLB != nil) {
            compositeF7 += (selLB.ratLBPas + selLB.ratLBTkl) / 2;
            return (compositeF7 / 4.58);
        } else {
            return compositeF7 / 4;
        }
    } else {
        return compositeF7 / 4;
    }
}

-(int)getCompositeF7Rush {
    int compositeDL = 0;
    if (teamDLs.count >= 4) {
        for ( int i = 0; i < 4; ++i ) {
            compositeDL += (teamDLs[i].ratDLPow + teamDLs[i].ratDLRsh)/2;
        }
    } else {
        for ( int i = 0; i < teamDLs.count; ++i ) {
            compositeDL += (teamDLs[i].ratDLPow + teamDLs[i].ratDLRsh)/2;
        }
    }
    
    if (self.defensiveStrategy.runUsage > 0) {
        PlayerLB *selLB = [self getLB:0];
        PlayerS *selS = [self getS:0];
        if (selLB != nil && selS != nil) {
            compositeDL += selLB.ratLBRsh + selS.ratSTkl;
            return (compositeDL / 5.5);
        } else {
            return compositeDL / 4;
        }
    } else {
        return compositeDL / 4;
    }
}

-(NSArray*)getTeamStatsArray {
    NSMutableArray *ts0 = [NSMutableArray array];
    //[ts0 appendFormat:@"%ld",(long)teamPollScore];
    //[ts0 appendString:@"AP Votes"];
    //[ts0 appendFormat:@"%@",[self getRankString:rankTeamPollScore]];

    [ts0 addObject:@[[NSString stringWithFormat:@"%d",teamPollScore], @"Poll Votes",[self getRankString:rankTeamPollScore]]];

    //[ts0 appendFormat:@"%ld,",(long)teamOffTalent];
    //[ts0 appendString:@"Off Talent,"];
    //[ts0 appendFormat:@"%@\n",[self getRankString:rankTeamOffTalent]];
    [ts0 addObject:@[[NSString stringWithFormat:@"%d",teamOffTalent], @"Offensive Talent",[self getRankString:rankTeamOffTalent]]];

    //[ts0 appendFormat:@"%ld,",(long)teamDefTalent];
    //[ts0 appendString:@"Def Talent,"];
    //[ts0 appendFormat:@"%@\n",[self getRankString:rankTeamDefTalent]];
    [ts0 addObject:@[[NSString stringWithFormat:@"%d",teamDefTalent], @"Defensive Talent",[self getRankString:rankTeamDefTalent]]];

    //[ts0 appendFormat:@"%ld,",(long)teamPrestige];
    //[ts0 appendString:@"Prestige,"];
    //[ts0 appendFormat:@"%@\n",[self getRankString:rankTeamPrestige]];
    [ts0 addObject:@[[NSString stringWithFormat:@"%d",teamPrestige], @"Prestige",[self getRankString:rankTeamPrestige]]];

    [ts0 addObject:@[[NSString stringWithFormat:@"%d",totalWins], @"Total Wins",[self getRankString:rankTeamTotalWins]]];
    
    [ts0 addObject:@[[NSString stringWithFormat:@"%d",totalCCs], @"Conf Championships"]];
    
    [ts0 addObject:@[[NSString stringWithFormat:@"%d",totalNCs], @"Natl Championships"]];

    //[ts0 appendFormat:@"%ld,",(long)teamStrengthOfWins];
    //[ts0 appendString:@"SOS,"];
    //[ts0 appendFormat:@"%@\n",[self getRankString:rankTeamStrengthOfWins]];

    [ts0 addObject:@[[NSString stringWithFormat:@"%d",teamStrengthOfWins], @"Strength of Schedule",[self getRankString:rankTeamStrengthOfWins]]];

    //[ts0 appendFormat:@"%ld,",(long)(teamPoints/[self numGames])];
    //[ts0 appendString:@"Points,"];
    //[ts0 appendFormat:@"%@\n",[self getRankString:rankTeamPoints]];

    [ts0 addObject:@[[NSString stringWithFormat:@"%d pts/gm",(teamPoints/[self numGames])], @"Points Per Game",[self getRankString:rankTeamPoints]]];

    //[ts0 appendFormat:@"%ld,",(long)(teamOppPoints/[self numGames])];
    //[ts0 appendString:@"Opp Points,"];
    //[ts0 appendFormat:@"%@\n",[self getRankString:teamOppPoints]];

    [ts0 addObject:@[[NSString stringWithFormat:@"%d pts/gm",(teamOppPoints/[self numGames])], @"Opp PPG",[self getRankString:rankTeamOppPoints]]];

    //[ts0 appendFormat:@"%ld,",(long)(teamYards/[self numGames])];
    //[ts0 appendString:@"Yards,"];
    //[ts0 appendFormat:@"%@\n",[self getRankString:rankTeamYards]];

    [ts0 addObject:@[[NSString stringWithFormat:@"%d yds/gm",(teamYards/[self numGames])], @"Yards Per Game",[self getRankString:rankTeamYards]]];

    //[ts0 appendFormat:@"%ld,",(long)(teamOppYards/[self numGames])];
    //[ts0 appendString:@"Opp Yards,"];
    //[ts0 appendFormat:@"%@\n",[self getRankString:rankTeamOppYards]];

    [ts0 addObject:@[[NSString stringWithFormat:@"%d yds/gm",(teamOppYards/[self numGames])], @"Opp YPG",[self getRankString:rankTeamOppYards]]];

    //[ts0 appendFormat:@"%ld,",(long)(teamPassYards/[self numGames])];
    //[ts0 appendString:@"Pass Yards,"];
    //[ts0 appendFormat:@"%@\n",[self getRankString:rankTeamPassYards]];

    [ts0 addObject:@[[NSString stringWithFormat:@"%d yds/gm",(teamPassYards/[self numGames])], @"Pass YPG",[self getRankString:rankTeamPassYards]]];

    //[ts0 appendFormat:@"%ld,",(long)(teamRushYards/[self numGames])];
    //[ts0 appendString:@"Rush Yards,"];
    //[ts0 appendFormat:@"%@\n",[self getRankString:rankTeamRushYards]];

    [ts0 addObject:@[[NSString stringWithFormat:@"%d yds/gm",(teamRushYards/[self numGames])], @"Rush YPG",[self getRankString:rankTeamRushYards]]];

    //[ts0 appendFormat:@"%ld,",(long)(teamOppPassYards/[self numGames])];
    //[ts0 appendString:@"Opp Pass YPG,"];
    //[ts0 appendFormat:@"%@\n",[self getRankString:rankTeamOppPassYards]];

    [ts0 addObject:@[[NSString stringWithFormat:@"%d yds/gm",(teamOppPassYards/[self numGames])], @"Opp Pass YPG",[self getRankString:rankTeamOppPassYards]]];

    //[ts0 appendFormat:@"%ld,",(long)(teamOppRushYards/[self numGames])];
    //[ts0 appendString:@"Opp Rush YPG,"];
    //[ts0 appendFormat:@"%@\n",[self getRankString:rankTeamOppRushYards]];

    [ts0 addObject:@[[NSString stringWithFormat:@"%d yds/gm",(teamOppRushYards/[self numGames])], @"Opp Rush YPG",[self getRankString:rankTeamOppRushYards]]];

    NSString *turnoverDifferential = @"0";
    if (teamTODiff > 0) {
        turnoverDifferential = [NSString stringWithFormat:@"+%d",teamTODiff];
    } else if (teamTODiff == 0) {
        turnoverDifferential = @"0";
    } else {
        turnoverDifferential = [NSString stringWithFormat:@"%d",teamTODiff];
    }
    //[ts0 appendString:@"TO Diff,"];
    //[ts0 appendFormat:@"%@\n",[self getRankString:rankTeamTODiff]];
    [ts0 addObject:@[turnoverDifferential, @"Turnover Differential",[self getRankString:rankTeamTODiff]]];

    return [ts0 copy];
}

-(NSString*)getSeasonSummaryString {
    NSMutableString *summary = [NSMutableString stringWithFormat:@"Your team, %@, finished the season ranked #%d with %d wins and %d losses.",name, rankTeamPollScore, wins, losses];
    int expectedPollFinish = 100 - teamPrestige;
    int diffExpected = expectedPollFinish - rankTeamPollScore;
    int oldPrestige = teamPrestige;
    int newPrestige;
    if (teamPrestige > 45 || diffExpected > 0) {
        newPrestige = (int)pow(teamPrestige, 1 + (float)diffExpected/1500);
        deltaPrestige = (newPrestige - oldPrestige);
    }

    if (deltaPrestige > 0) {
        [summary appendFormat:@"\n\nGreat job, coach! You exceeded expectations and gained %ld prestige! This will help your recruiting.", (long)deltaPrestige];
    } else if (deltaPrestige < 0) {
        [summary appendString:[[NSString stringWithFormat:@"\n\nA bit of a down year, coach? You fell short expectations and lost %ld prestige. This will hurt your recruiting.",(long)deltaPrestige] stringByReplacingOccurrencesOfString:@"-" withString:@""]];
    } else {
        [summary appendString:@"\n\nWell, your team performed exactly how many expected. This won't hurt or help recruiting, but try to improve next year!"];
    }

    if ([natlChampWL isEqualToString:@"NCW"]) {
        [summary appendString:@"\n\nYou won the National Championship! Recruits want to play for winners and you have proved that you are one. You gain 3 prestige!"];
        deltaPrestige += 3;
    }

    NSLog(@"RIVALRY SERIES FOR %@: %d - %d", abbreviation, rivalryWins, rivalryLosses);
    if ((rivalryWins > rivalryLosses) && (teamPrestige - [league findTeam:rivalTeam].teamPrestige < 25) ) {
        [summary appendString:@"\n\nRecruits were impressed that you defeated your rival. You gained 2 prestige."];
        deltaPrestige += 2;
    } else if ((rivalryLosses > rivalryWins) && ([league findTeam:rivalTeam].teamPrestige - teamPrestige < 20)) {
        [summary appendString:@"\n\nSince you couldn't win your rivalry series, recruits aren't excited to attend your school. You lost 2 prestige."];
        deltaPrestige -= 2;
    } else if (rivalryWins == rivalryLosses) {
        [summary appendString:@"\n\nThe season series between you and your rival was tied. You gain no prestige for this."];
    } else if ((rivalryWins > rivalryLosses) && (teamPrestige - [league findTeam:rivalTeam].teamPrestige >= 25)) {
        [summary appendString:@"\n\nYou won your rivalry series, but it was expected given the state of their program. You gain no prestige for this."];
    } else if ((rivalryWins < rivalryLosses) && (teamPrestige - [league findTeam:rivalTeam].teamPrestige >= 25)) {
        [summary appendString:@"\n\nYou lost your rivalry series, but this was expected given your rebuilding program. You lost no prestige for this."];
    }
    
    NSArray *draftRounds = self.league.allDraftedPlayers;
    int nflPts = 0, players = 0;
    for (NSArray *round in draftRounds) {
        for (Player *p in round) {
            if ([p.team isEqual:self]) {
                players++;
            }
        }
    }
    if (players > 2) {
         nflPts = 2;
    } else {
        nflPts = players;
    }
    if (nflPts > 0) {
        NSMutableString *playerString = [NSMutableString stringWithFormat:@"%d", players];
        if (nflPts == 1) {
            [playerString appendString:@" player"];
        } else {
            [playerString appendString:@" players"];
        }
        [summary appendFormat:@"\n\nYou had %@ players drafted this year. For this, you gained %d prestige.",playerString,nflPts];
        deltaPrestige += nflPts;
    }

    if (deltaPrestige > 0) {
        [summary appendFormat:@"\n\nOverall, your program gained %ld prestige this season.", (long)deltaPrestige];
    } else if (deltaPrestige < 0) {
        [summary appendString:[[NSString stringWithFormat:@"\n\nOverall, your program lost %ld prestige this season.", (long)deltaPrestige] stringByReplacingOccurrencesOfString:@"-" withString:@""]];
    } else {
        [summary appendString:@"\n\nOverall, your program didn't gain or lose prestige this season."];
    }

    return summary;
}

-(NSString*)getRankString:(int)num {
    if (num == 11) {
        return @"11th";
    } else if (num == 12) {
        return @"12th";
    } else if (num == 13) {
        return @"13th";
    } else if (num%10 == 1) {
        return [NSString stringWithFormat:@"%ldst",(long)num];
    } else if (num%10 == 2) {
        return [NSString stringWithFormat:@"%ldnd",(long)num];
    } else if (num%10 == 3){
        return [NSString stringWithFormat:@"%ldrd",(long)num];
    } else {
        return [NSString stringWithFormat:@"%ldth",(long)num];
    }
}

-(int)numGames {
    if (wins + losses > 0 ) {
        return wins + losses;
    } else return 1;
}

-(int)calculateConfWins {
    int tempConfWins = 0;
    Game *g;
    for (int i = 0; i < gameSchedule.count; ++i) {
        g = gameSchedule[i];
        if ( [g.gameName isEqualToString:@"In Conf" ] || [g.gameName isEqualToString:@"Rivalry Game"] ) {
            // in conference game, see if was won
            if ( [g.homeTeam isEqual: self] && g.homeScore > g.awayScore ) {
                tempConfWins++;
            } else if ( [g.awayTeam isEqual: self] && g.homeScore < g.awayScore ) {
                tempConfWins++;
            }
        }
    }
    if (tempConfWins == confWins) {
        return confWins;
    } else {
        return tempConfWins;
    }
}

-(int)calculateConfLosses {
    int tempConfLosses = 0;
    Game *g;
    for (int i = 0; i < gameSchedule.count; ++i) {
        g = gameSchedule[i];
        if ( [g.gameName isEqualToString:@"In Conf" ] || [g.gameName isEqualToString:@"Rivalry Game"] ) {
            // in conference game, see if was lost
            if ( [g.homeTeam isEqual: self] && g.homeScore < g.awayScore ) {
                tempConfLosses++;
            } else if ( [g.awayTeam isEqual: self] && g.homeScore > g.awayScore ) {
                tempConfLosses++;
            }
        }
    }
    if (tempConfLosses == confLosses) {
        return confLosses;
    } else {
        return tempConfLosses;
    }
}

-(NSString*)strRep {
    if (rankTeamPollScore > 0 && rankTeamPollScore < 26) {
        return [NSString stringWithFormat:@"#%ld %@ (%ld-%ld)",(long)rankTeamPollScore,abbreviation,(long)wins,(long)losses];
    } else {
        return [NSString stringWithFormat:@"%@ (%ld-%ld)",abbreviation,(long)wins,(long)losses];
    }
}

-(NSString*)strRepWithBowlResults {
    if (rankTeamPollScore > 0 && rankTeamPollScore < 26) {
        return [NSString stringWithFormat:@"#%ld %@ (%ld-%ld) %@ %@ %@",(long)rankTeamPollScore,abbreviation,(long)wins,(long)losses,confChampion,semifinalWL,natlChampWL];
    } else {
        return [NSString stringWithFormat:@"%@ (%ld-%ld) %@ %@ %@",abbreviation,(long)wins,(long)losses,confChampion,semifinalWL,natlChampWL];
    }

}

-(NSString*)weekSummaryString {
    NSInteger i = gameWLSchedule.count - 1;
    Game *g = gameSchedule[i];
    NSString *gameSummary = [NSString stringWithFormat:@"%@ %@",[gameWLSchedule lastObject],[self gameSummaryString:g]];
    NSString *rivalryGameStr = @"";
    if ([g.gameName isEqualToString:@"Rivalry Game"] || [g.homeTeam.rivalTeam isEqualToString:g.awayTeam.abbreviation] || [g.awayTeam.rivalTeam isEqualToString:g.homeTeam.abbreviation]) {
        if ( [[gameWLSchedule lastObject] isEqualToString:@"W"] ) {
            rivalryGameStr = @"Won against Rival! ";
        } else {
            rivalryGameStr = @"Lost against Rival! ";
        }
    }

    if (rankTeamPollScore > 0 && rankTeamPollScore < 26) {
        return [NSString stringWithFormat:@"%@#%d %@ %@",rivalryGameStr,rankTeamPollScore, name,gameSummary];
    } else {
        return [NSString stringWithFormat:@"%@%@ %@",rivalryGameStr,name,gameSummary];
    }
}

-(NSString*)gameSummaryString:(Game*)g {
    if ([g.homeTeam isEqual: self]) {
        if ([HBSharedUtils currentLeague].currentWeek > 0 && [HBSharedUtils currentLeague].currentWeek > 0 && g.awayTeam.rankTeamPollScore > 0 && g.awayTeam.rankTeamPollScore < 26) {
            return [NSString stringWithFormat:@"%ld - %ld vs #%ld %@",(long)g.homeScore,(long)g.awayScore,(long)g.awayTeam.rankTeamPollScore,g.awayTeam.abbreviation];
        } else {
            return [NSString stringWithFormat:@"%ld - %ld vs %@",(long)g.homeScore,(long)g.awayScore,g.awayTeam.abbreviation];
        }
    } else {
        if ([HBSharedUtils currentLeague].currentWeek > 0 && [HBSharedUtils currentLeague].currentWeek > 0 && g.homeTeam.rankTeamPollScore > 0 && g.homeTeam.rankTeamPollScore < 26) {
            return [NSString stringWithFormat:@"%ld - %ld vs #%ld %@",(long)g.awayScore,(long)g.homeScore,(long)g.homeTeam.rankTeamPollScore,g.homeTeam.abbreviation];
        } else {
            return [NSString stringWithFormat:@"%ld - %ld vs %@",(long)g.awayScore,(long)g.homeScore,g.homeTeam.abbreviation];
        }
    }
}

-(NSString*)gameSummaryStringScore:(Game*)g {
    if ([g.homeTeam isEqual: self]) {
        return [NSString stringWithFormat:@"%ld - %ld",(long)g.homeScore,(long)g.awayScore];
    } else {
        return [NSString stringWithFormat:@"%ld - %ld",(long)g.awayScore,(long)g.homeScore];
    }
}


-(NSString*)gameSummaryStringOpponent:(Game*)g {
    NSString *rank = @"";
    if ([g.homeTeam isEqual: self]) {
        if ([HBSharedUtils currentLeague].currentWeek > 0 && g.awayTeam.rankTeamPollScore < 26 && g.awayTeam.rankTeamPollScore > 0) {
            rank = [NSString stringWithFormat:@" #%ld",(long)g.awayTeam.rankTeamPollScore];
        }
        return [NSString stringWithFormat:@"vs%@ %@",rank,g.awayTeam.abbreviation];
    } else {
        if ([HBSharedUtils currentLeague].currentWeek > 0 && g.homeTeam.rankTeamPollScore < 26 && g.homeTeam.rankTeamPollScore > 0) {
            rank = [NSString stringWithFormat:@" #%ld",(long)g.homeTeam.rankTeamPollScore];
        }
        return [NSString stringWithFormat:@"@%@ %@",rank,g.homeTeam.abbreviation];
    }
}

-(void)_calculateTransferringPlayers:(NSMutableArray *)positionPlayers position:(NSString *)pos starterCount:(int)starterCount {
    int i = 0;
    int transferChance = 12;
    int transferYear = 2;
    
    [self sortPlayers];
    while (i < positionPlayers.count && positionPlayers.count > starterCount) {
        int chance = 1;
        Player *q = positionPlayers[i];
        CFCRegionDistance distance = [HBSharedUtils distanceFromRegion:[HBSharedUtils regionForState:q.personalDetails[@"home_state"]] toRegion:[HBSharedUtils regionForState:state]];
        if (distance != CFCRegionDistanceMatch || distance != CFCRegionDistanceNeighbor) {
            chance++;
        }
        // could add discipline stuff?
        if (q.gamesPlayedSeason < GRAD_TRANSFER_MIN_GAMES) {
            chance++;
        }
        
        if (q.year == 4) {
            chance++;
        }
        
        if (q.year < 2) {
            chance--;
        }
        
        BOOL starter = ([q isEqual: [self getQB:0]]
                        
                        || [q isEqual: [self getRB:0]]
                        || [q isEqual: [self getRB:1]]
                        
                        || [q isEqual: [self getWR:0]]
                        || [q isEqual: [self getWR:1]]
                        
                        || [q isEqual: [self getTE:0]]
                        
                        || [q isEqual: [self getOL:0]]
                        || [q isEqual: [self getOL:1]]
                        || [q isEqual: [self getOL:2]]
                        || [q isEqual: [self getOL:3]]
                        || [q isEqual: [self getOL:4]]
                        
                        || [q isEqual: [self getDL:0]]
                        || [q isEqual: [self getDL:1]]
                        || [q isEqual: [self getDL:2]]
                        || [q isEqual: [self getDL:3]]
                        
                        || [q isEqual: [self getLB:0]]
                        || [q isEqual: [self getLB:1]]
                        || [q isEqual: [self getLB:2]]
                        
                        || [q isEqual: [self getCB:0]]
                        || [q isEqual: [self getCB:1]]
                        || [q isEqual: [self getCB:2]]
                        
                        || [q isEqual: [self getS:0]]
                        
                        || [q isEqual: [self getK:0]]);
        
        int futurePositionalScore = 0;
        NSArray *playersAtPosition = [self getPlayersAtPosition: q.position];
        NSMutableDictionary *positionalOveralls = [NSMutableDictionary dictionary];
        [positionalOveralls setObject:@(q.ratOvr) forKey:q.name];
        [playersAtPosition enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Player *p = (Player *)obj;
            if (![self->playersLeaving containsObject:p]) {
                [positionalOveralls setObject:@(p.ratOvr) forKey:p.name];
            }
        }];
        
        NSArray *sortedOveralls = [positionalOveralls keysSortedByValueUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj2 compare:obj1];
        }];
        NSInteger plyrNameIndex = [sortedOveralls indexOfObject:self.name];
        switch (plyrNameIndex) {
            case 0:
                futurePositionalScore = 25;
                break;
            default:
                futurePositionalScore = 25 - ((int)(25.0 * ((float)plyrNameIndex / (float)sortedOveralls.count)));
                break;
        }
        
        if (![playersLeaving containsObject:q] && q.year > transferYear && !q.hasRedshirt && q.ratOvr > RAT_TRANSFER && !starter && !q.isHeisman && !q.isROTY && (int) ([HBSharedUtils randomValue] * (transferChance - 2)) < chance && !q.isTransfer && !q.isGradTransfer && futurePositionalScore < 20) {
            NSLog(@"XFER: Confirmed that %@ %@ is a valid transfer", q.team.abbreviation, [q getPosNameYrOvrPot_Str]);
            if (q.year == 4) {
                q.isTransfer = false;
                q.isGradTransfer = true;
                [league.newsStories[league.currentWeek + 1] addObject:[NSString stringWithFormat:@"%@ %@ on the move!\n%@ %@ %@ has decided to transfer after graduating from %@. If he signs with another school, he is immediately eligible to play.",q.position,[q getInitialName],self.abbreviation,q.position,q.name, self.name]];
            } else {
                q.isTransfer = true;
                q.isGradTransfer = false;
                [league.newsStories[league.currentWeek + 1] addObject:[NSString stringWithFormat:@"%@ %@ on the move!\n%@ %@ %@ has decided to leave town for greener pastures after getting limited playing time during his time at %@. If he signs with another school, he will have to sit for one year.",q.position,[q getInitialName],self.abbreviation,q.position,q.name, self.name]];
            }
            //q.team = nil;
            NSLog(@"XFER: Adding %@ %@ to team's outgoing transfers", q.team.abbreviation, [q getPosNameYrOvrPot_Str]);
            q.recruitStatus = CFCRecruitStatusUncommitted;
            if (![playersTransferring containsObject:q]) {
                [playersTransferring addObject:q];
            }
            
            // Removal done in advanceSeasonPlayers()
//            if ([positionPlayers containsObject:q]) {
//                [positionPlayers removeObject:q];
//            }
            
            if (league.transferList == nil) {
                league.transferList = @{
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
            }
            
            NSLog(@"XFER: Adding %@ %@ to league transfer portal as %@ transfer", q.team.abbreviation, [q getPosNameYrOvrPot_Str], (q.isGradTransfer) ? @"grad" : @"normal");
            [league.transferList[pos] addObject:q];
        }
        ++i;
    }
}

-(void)getTransferringPlayers {
    if (playersTransferring.count == 0) {
        playersTransferring = [NSMutableArray array];
        [self _calculateTransferringPlayers:teamQBs position:@"QB" starterCount:1];
        [self _calculateTransferringPlayers:teamRBs position:@"RB" starterCount:2];
        [self _calculateTransferringPlayers:teamWRs position:@"WR" starterCount:2];
        [self _calculateTransferringPlayers:teamTEs position:@"TE" starterCount:1];
        [self _calculateTransferringPlayers:teamOLs position:@"OL" starterCount:5];
        [self _calculateTransferringPlayers:teamDLs position:@"DL" starterCount:4];
        [self _calculateTransferringPlayers:teamLBs position:@"LB" starterCount:3];
        [self _calculateTransferringPlayers:teamCBs position:@"CB" starterCount:3];
        [self _calculateTransferringPlayers:teamSs position:@"S" starterCount:1];
        [self _calculateTransferringPlayers:teamKs position:@"K" starterCount:1];
        NSLog(@"XFER: There are %ld transfers for %@ this year.", (long)playersTransferring.count, abbreviation);
    }
}

-(void)getGraduatingPlayers {
    [self getTransferringPlayers];
    
    if (playersLeaving == nil || playersLeaving.count == 0) {
        playersLeaving = [NSMutableArray array];
        double draftChance = NFL_CHANCE;
        if (league.isHardMode) {
            draftChance += HARD_MODE_DRAFT_BONUS;
        }
        
        if ([natlChampWL isEqualToString:@"NCW"]) {
            draftChance += NCG_DRAFT_BONUS;
        }
        
        NSArray *players = [self getAllPlayers];
        for (Player *p in players) {
            if ((p.year >= 4 && !p.isTransfer && ![transferClass containsObject:p] && ![playersTransferring containsObject:p])
                || (p.year == 3 && p.gamesPlayed > 0 && p.ratOvr > NFL_OVR && [HBSharedUtils randomValue] < draftChance)) {
                [playersLeaving addObject:p];
                if (p.year == 3) {
                    NSLog(@"JUNIOR %@ LEAVING FOR DRAFT: %@", p.position, [p debugDescription]);
                }
            }
        }
    }
}

-(NSString*)injuryReport {
    if (injuredPlayers.count > 0) {
        NSMutableString *report = [NSMutableString string];
        for (Player *p in injuredPlayers) {
            [report appendFormat:@"%@: %@\n", [p getPosNameYrOvrPot_Str], [p.injury injuryDescription]];
        }
        return report;
    } else {
        return @"";
    }
}

-(void)checkForInjury {
    recoveredPlayers = [NSMutableArray array];
    if (league.isHardMode) {
        [self checkInjuryPosition:teamQBs starters:1];
        [self checkInjuryPosition:teamRBs starters:2];
        [self checkInjuryPosition:teamWRs starters:2];
        [self checkInjuryPosition:teamTEs starters:1];
        [self checkInjuryPosition:teamOLs starters:5];
        [self checkInjuryPosition:teamKs starters:1];
        [self checkInjuryPosition:teamSs starters:1];
        [self checkInjuryPosition:teamCBs starters:3];
        [self checkInjuryPosition:teamDLs starters:4];
        [self checkInjuryPosition:teamLBs starters:3];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"injuriesPosted" object:nil];
    }
}

-(void)checkInjuryPosition:(NSMutableArray*)positionGroup starters:(int)numStarters {
    int numInjured = 0;
    
    for (Player *p in positionGroup) {
        if ([p isInjured] && !p.isTransfer) {
            [p.injury advanceWeek];
            numInjured++;
            if (p.injury == nil || p.injury.duration == 0) {
                p.injury = nil;
                
                if (![recoveredPlayers containsObject:p]) {
                    [recoveredPlayers addObject:p];
                }
                
                if ([injuredPlayers containsObject:p]) {
                    [injuredPlayers removeObject:p];
                }
            }
        }
    }
    
    if (numInjured < numStarters) {
        for (int i = 0; i < numStarters; i++) {
            Player *p = positionGroup[i];
            double injChance = pow(1 - (double)p.ratDur/100, 3);
            if ([p.position isEqualToString:@"QB"] || [p.position isEqualToString:@"K"])
                injChance = pow(1 - (double)p.ratDur/100, 4);
            if (![p isInjured] && ([HBSharedUtils randomValue] < injChance || [HBSharedUtils randomValue] < 0.005) && numInjured < numStarters) {
                p.injury = [Injury newInjury];
                if (![injuredPlayers containsObject:p]) {
                    [injuredPlayers addObject:p];
                }
                numInjured++;
            }
        }
    }
    
    
    if (numInjured > 0) {
        [self sortPlayersPostInjury];
    }
}

-(NSString*)getGraduatingPlayersString {
    NSMutableString *sb = [NSMutableString string];
    for (Player *p in playersLeaving)
    {
        [sb appendFormat:@"%@\n", p.getPosNameYrOvrPot_OneLine];
    }

    if (sb.length == 0 || [sb isEqualToString:@""]) {
        [sb appendString:@"No graduating players"];
    }

    return [sb copy];
}

-(NSString*)getTransferringPlayersString {
    NSMutableString *sb = [NSMutableString string];
    for (Player *p in playersTransferring)
    {
        [sb appendFormat:@"%@\n", p.getPosNameYrOvrPot_OneLine];
    }
    
    if (sb.length == 0 || [sb isEqualToString:@""]) {
        [sb appendString:@"No transferring players"];
    }
    
    return [sb copy];
}


-(NSArray*)getOffensiveTeamStrategies {
    return @[
             [TeamStrategy newStrategy], // default - Balanced
             [TeamStrategy newStrategyWithName:@"Smashmouth" description:@"Play a conservative, run-heavy offense where the running game sets up the pass." rPref:2 runProt:1 runPot:-1 rUsg:1 pPref:1 passProt:2 passPot:1 pUsg:0],
             [TeamStrategy newStrategyWithName:@"West Coast" description:@"Play a dink-and-dunk passing game. Short accurate passes will set up the run game." rPref:2 runProt:0 runPot:1 rUsg:0 pPref:3 passProt:1 passPot:-2 pUsg:2],
             [TeamStrategy newStrategyWithName:@"Spread" description:@"Play a pass-heavy offense that focuses on big plays but runs the risk of turnovers." rPref:1 runProt:-2 runPot:1 rUsg:0 pPref:2 passProt:-2 passPot:1 pUsg:1],
             [TeamStrategy newStrategyWithName:@"Read Option" description:@"Play an offense that relies heavily on option reads for running plays based on coverage and LB positioning." rPref:3 runProt:-1 runPot:1 rUsg:1 pPref:2 passProt:-1 passPot:-1 pUsg:0],
             [TeamStrategy newStrategyWithName:@"Run-Pass Option" description:@"Play an offense relying on option reads for running and passing plays based on coverage and LB positioning." rPref:2 runProt:-1 runPot:1 rUsg:1 pPref:3 passProt:-1 passPot:-1 pUsg:1],

             ];
}

-(NSArray*)getDefensiveTeamStrategies {
    return @[
             [TeamStrategy newStrategyWithName:@"4-3 Man" description:@"Play a standard 4-3 man-to-man balanced defense." rPref:1 runProt:0 runPot:0 rUsg:1 pPref:1 passProt:0 passPot:0 pUsg:1],
             [TeamStrategy newStrategyWithName:@"4-6 Bear" description:@"Play a defense focused on stopping the run. Will allow few yards and big plays on the ground, but may give up big passing plays." rPref:2 runProt:0 runPot:2 rUsg:1 pPref:1 passProt:-1 passPot:-1 pUsg:0],
             [TeamStrategy newStrategyWithName:@"Cover 2" description:@"Play a zone defense with safety help in the back against the pass and LBs that stay home to cover the run." rPref:2 runProt:0 runPot:-1 rUsg:1 pPref:3 passProt:2 passPot:0 pUsg:1],
             [TeamStrategy newStrategyWithName:@"Cover 3" description:@"Play a zone defense that will stop big passing plays, but may allow short gains underneath." rPref:3 runProt:0 runPot:-2 rUsg:1 pPref:7 passProt:2 passPot:2 pUsg:1]//,
             //[TeamStrategy newStrategyWithName:@"3-4 Man" description:@"Play a standard 3-4 man-to-man balanced defense." rPref:1 runProt:0 runPot:0 rUsg:1 pPref:1 passProt:0 passPot:0 pUsg:1],
             ];
}

-(int)getCPUOffense {
    int OP, OR;
    OP = [self getPassProf];
    OR = [self getRushProf];
    if(OP > (OR + 5)) {
        return 3;
    } else if (OP > (OR + 3)) {
        return 2;
    } else if (OR > (OP + 5) && [self getQB:0].ratSpeed > 75 && [self getQB:0].ratSpeed >= [self getRB:0].ratRushSpd) {
        return 5;
    } else if (OR > (OP + 5) && [self getQB:0].ratSpeed < [self getRB:0].ratRushSpd) {
        return 4;
    } else if (OR > (OP + 5)) {
        return 1;
    } else {
        return 0;
    }
}

-(int)getCPUDefense {
    int DP, DR;
    DP = [self getPassDef];
    DR = [self getRushDef];
    if(DR > (DP + 5)) {
        return 3;
    } else if (DR > (DP + 3)) {
        return 2;
    } else if (DP > (DR + 3)) {
        return 1;
    } else {
        return 0;
    }
}

-(float)mapFloat:(float)floatIn {
    CGFloat const inMin = 0.0;
    CGFloat const inMax = 60.0;
    
    CGFloat const outMin = 0.0;
    CGFloat const outMax = 100.0;
    
    return outMin + (outMax - outMin) * (floatIn - inMin) / (inMax - inMin);
}

-(NSArray*)getGameSummaryStrings:(int)gameNumber {
    NSMutableArray *gs = [NSMutableArray array];
    if (gameNumber >= gameSchedule.count) {
        return @[@"? vs ?", @"T 0-0", @"#0 ??? (0-0)"];
    }
    
    if (gameNumber < gameSchedule.count) {
        Game *g = gameSchedule[gameNumber];
        gs[0] = g.gameName;
        if (gameNumber < gameWLSchedule.count) {
            gs[1] = [NSString stringWithFormat:@"%@ %@", gameWLSchedule[gameNumber], [self gameSummaryStringScore:g]];
            if (g.numOT > 0){
                if (g.numOT > 1) {
                    gs[1] = [gs[1] stringByAppendingFormat:@" (%dOT)",g.numOT];
                } else {
                    gs[1] = [gs[1] stringByAppendingString:@" (OT)"];
                }
            }
        } else {
            //gs[1] = @"---";
            Game *g = gameSchedule[gameNumber];
            // Calculating game spread: avg of offensive talent, defensive talent, prestige, and rank
            float homeAbility = ((float)[g.homeTeam getOffensiveTalent] + (float)[g.homeTeam getDefensiveTalent] + (self.league.currentWeek > 0 ? [self mapFloat:(float)(60-g.homeTeam.rankTeamPollScore)] : 0.0 + (float)g.homeTeam.teamPrestige));
            float awayAbility = ((float)[g.awayTeam getOffensiveTalent] + (float)[g.awayTeam getDefensiveTalent] + (self.league.currentWeek > 0 ? [self mapFloat:(float)(60-g.awayTeam.rankTeamPollScore)] : 0.0  + (float)g.awayTeam.teamPrestige));
            float basicSpread = (homeAbility - awayAbility) / (self.league.currentWeek > 0 ? 4.0 : 3.0);
            //NSLog(@"Home: %f, Away: %f, Diff: %f", homeAbility, awayAbility, basicSpread);
            
            float roundedSpread = floorf(basicSpread * 2) / 2;
            if (roundedSpread > 0.5) {
                gs[1] = [NSString stringWithFormat:@"%@ -%.1f",g.homeTeam.abbreviation,fabsf(roundedSpread)];
            } else if (roundedSpread < -0.5) {
                gs[1] = [NSString stringWithFormat:@"%@ -%.1f",g.awayTeam.abbreviation,fabsf(roundedSpread)];
            } else {
                gs[1] = @"PUSH";
            }
        }
        gs[2] = [self gameSummaryStringOpponent:g];
    }
    return gs;
}

-(void)setStarters:(NSArray<Player*>*)starters position:(int)position {
    switch (position) {
        case 0: {
            NSMutableArray *oldQBs = [NSMutableArray array];
            [oldQBs addObjectsFromArray:teamQBs];
            [teamQBs removeAllObjects];
            for (Player *p in starters) {
                [teamQBs addObject:(PlayerQB*)p];
            }
            for (PlayerQB *oldQb in oldQBs) {
                if (![teamQBs containsObject:oldQb]) {
                    [teamQBs addObject:oldQb];
                }
            }
            break;
        }
        case 1: {
            NSMutableArray *oldRBs = [NSMutableArray array];
            [oldRBs addObjectsFromArray:teamRBs];
            [teamRBs removeAllObjects];
            for (Player *p in starters) {
                [teamRBs addObject:(PlayerRB*)p];
            }
            for (PlayerRB *oldRb in oldRBs) {
                if (![teamRBs containsObject:oldRb]) {
                    [teamRBs addObject:oldRb];
                }
            }
            break;
        }
        case 2: {
            NSMutableArray *oldWRs = [NSMutableArray array];
            [oldWRs addObjectsFromArray:teamWRs];
            [teamWRs removeAllObjects];
            for (Player *p in starters) {
                [teamWRs addObject:(PlayerWR*)p];
            }
            for (PlayerWR *oldWR in oldWRs) {
                if (![teamWRs containsObject:oldWR]) {
                    [teamWRs addObject:oldWR];
                }
            }
            break;
        }
        case 3: {
            NSMutableArray *oldTEs = [NSMutableArray array];
            [oldTEs addObjectsFromArray:teamTEs];
            [teamTEs removeAllObjects];
            for (Player *p in starters) {
                [teamTEs addObject:(PlayerTE*)p];
            }
            for (PlayerTE *oldTE in oldTEs) {
                if (![teamTEs containsObject:oldTE]) {
                    [teamTEs addObject:oldTE];
                }
            }
            break;
        }
        case 4: {
            NSMutableArray *oldOLs = [NSMutableArray array];
            [oldOLs addObjectsFromArray:teamOLs];
            [teamOLs removeAllObjects];
            for (Player *p in starters) {
                [teamOLs addObject:(PlayerOL*)p];
            }
            for (PlayerOL *oldOL in oldOLs) {
                if (![teamOLs containsObject:oldOL]) {
                    [teamOLs addObject:oldOL];
                }
            }
            break;
        }
        case 5: {
            NSMutableArray *oldDLs = [NSMutableArray array];
            [oldDLs addObjectsFromArray:teamDLs];
            [teamDLs removeAllObjects];
            for (Player *p in starters) {
                [teamDLs addObject:(PlayerDL*)p];
            }
            for (PlayerDL *oldF7 in oldDLs) {
                if (![teamDLs containsObject:oldF7]) {
                    [teamDLs addObject:oldF7];
                }
            }
            break;
        }
        case 6: {
            NSMutableArray *oldLBs = [NSMutableArray array];
            [oldLBs addObjectsFromArray:teamLBs];
            [teamLBs removeAllObjects];
            for (Player *p in starters) {
                [teamLBs addObject:(PlayerLB*)p];
            }
            for (PlayerLB *oldF7 in oldLBs) {
                if (![teamLBs containsObject:oldF7]) {
                    [teamLBs addObject:oldF7];
                }
            }
            break;
        }
        case 7: {
            NSMutableArray *oldCBs = [NSMutableArray array];
            [oldCBs addObjectsFromArray:teamCBs];
            [teamCBs removeAllObjects];
            for (Player *p in starters) {
                [teamCBs addObject:(PlayerCB*)p];
            }
            for (PlayerCB *oldCB in oldCBs) {
                if (![teamCBs containsObject:oldCB]) {
                    [teamCBs addObject:oldCB];
                }
            }
            break;
        }
        case 8: {
            NSMutableArray *oldSs = [NSMutableArray array];
            [oldSs addObjectsFromArray:teamSs];
            [teamSs removeAllObjects];
            for (Player *p in starters) {
                [teamSs addObject:(PlayerS*)p];
            }
            for (PlayerS *oldS in oldSs) {
                if (![teamSs containsObject:oldS]) {
                    [teamSs addObject:oldS];
                }
            }
            break;
        }
        case 9: {
            NSMutableArray *oldKs = [NSMutableArray array];
            [oldKs addObjectsFromArray:teamKs];
            [teamKs removeAllObjects];
            for (Player *p in starters) {
                [teamKs addObject:(PlayerK*)p];
            }
            for (PlayerK *oldK in oldKs) {
                if (![teamKs containsObject:oldK]) {
                    [teamKs addObject:oldK];
                }
            }
            break;
        }
        default:
            break;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updatedStarters" object:nil];

}

-(void)updateRingOfHonor {
    [self getGraduatingPlayers];
    for (Player *p in teamQBs) {
        if (((isUserControlled && [playersLeaving containsObject:p]) || (!isUserControlled && p.year == 4))
            && (p.careerAllConferences > 2 || p.careerHeismans > 0 || p.careerAllAmericans > 1)) {
            if (![hallOfFamers containsObject:p]) {
                p.injury = nil; //sanity check to make sure our immortals are actually immortal
                [hallOfFamers addObject:p];
            }
        }
    }
    
    for (Player *p in teamRBs) {
        if (((isUserControlled && [playersLeaving containsObject:p]) || (!isUserControlled && p.year == 4))
            && (p.careerAllConferences > 2 || p.careerHeismans > 0 || p.careerAllAmericans > 1)) {
            if (![hallOfFamers containsObject:p]) {
                p.injury = nil; //sanity check to make sure our immortals are actually immortal
                [hallOfFamers addObject:p];
            }
        }
    }
    
    for (Player *p in teamWRs) {
        if (((isUserControlled && [playersLeaving containsObject:p]) || (!isUserControlled && p.year == 4))
            && (p.careerAllConferences > 2 || p.careerHeismans > 0 || p.careerAllAmericans > 1)) {
            if (![hallOfFamers containsObject:p]) {
                p.injury = nil; //sanity check to make sure our immortals are actually immortal
                [hallOfFamers addObject:p];
            }
        }
    }
    
    for (Player *p in teamTEs) {
        if (((isUserControlled && [playersLeaving containsObject:p]) || (!isUserControlled && p.year == 4))
            && (p.careerAllConferences > 2 || p.careerHeismans > 0 || p.careerAllAmericans > 1)) {
            if (![hallOfFamers containsObject:p]) {
                p.injury = nil; //sanity check to make sure our immortals are actually immortal
                [hallOfFamers addObject:p];
            }
        }
    }
    
    if (hallOfFamers.count > 0) {
        //for (Player *p in hallOfFamers) {
            //p.year = 5;
        //}//
        
        //sort normally
        [hallOfFamers sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [HBSharedUtils comparePlayers:obj1 toObj2:obj2];
        }];
        
        //sort by most hallowed (hallowScore = normalized OVR + 2 * all-conf + 4 * all-Amer + 6 * Heisman; tie-break w/ pure OVR, then gamesPlayed, then potential)
        int maxOvr = hallOfFamers[0].ratOvr;
        [hallOfFamers sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            Player *a = (Player*)obj1;
            Player *b = (Player*)obj2;
            int aHallowScore = (100 * ((double)a.ratOvr / (double) maxOvr)) + (2 * a.careerAllConferences) + (4 * a.careerAllAmericans) + (6 * a.careerHeismans);
            int bHallowScore = (100 * ((double)b.ratOvr / (double) maxOvr)) + (2 * b.careerAllConferences) + (4 * b.careerAllAmericans) + (6 * b.careerHeismans);
            if (aHallowScore > bHallowScore) {
                return -1;
            } else if (bHallowScore > aHallowScore) {
                return 1;
            } else {
                if (a.ratOvr > b.ratOvr) {
                    return -1;
                } else if (a.ratOvr < b.ratOvr) {
                    return 1;
                } else {
                    if (a.gamesPlayed > b.gamesPlayed) {
                        return -1;
                    } else if (a.gamesPlayed < b.gamesPlayed) {
                        return 1;
                    } else {
                        if (a.ratPot > b.ratPot) {
                            return -1;
                        } else if (a.ratPot < b.ratPot) {
                            return 1;
                        } else {
                            return 0;
                        }
                    }
                }

            }
        }];
    }
}

-(NSString *)teamMetadataJSON {
    NSMutableString *jsonString = [NSMutableString string];
    [jsonString appendString:@"{"];
    [jsonString appendFormat:@"\"name\" : \"%@\", \"abbreviation\" : \"%@\", \"prestige\" : \"%d\",  \"state\" : \"%@\", \"rival\" : \"%@\"",name, abbreviation, teamPrestige, state, rivalTeam];
    [jsonString appendString:@"}"];
    return jsonString;
}

-(NSNumberFormatter *)numberFormatter {
    static dispatch_once_t onceToken;
    static NSNumberFormatter *numFormatter;
    dispatch_once(&onceToken, ^{
        numFormatter = [[NSNumberFormatter alloc] init];
        numFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    });
    return numFormatter;
}

-(void)applyJSONMetadataChanges:(id)json {
    NSError *error;
    NSDictionary *jsonDict;
    if ([json isKindOfClass:[NSString class]]) {
        NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
        jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    } else if ([json isKindOfClass:[NSDictionary class]]) {
        jsonDict = (NSDictionary *)json;
    } else {
        NSLog(@"JSON is of invalid type");
        return;
    }
    
    if (!error) {
        if ([league isTeamNameValid:jsonDict[@"name"] allowUserTeam:YES allowOverwrite:YES]) {
            name = jsonDict[@"name"];
        }
        
        if ([HBSharedUtils isValidNumber:jsonDict[@"prestige"]])
        {
            NSLog(@"Changing prestige for %@ from base value of %d", abbreviation, teamPrestige);
            NSNumber *prestige = [[self numberFormatter] numberFromString:jsonDict[@"prestige"]];
            if (prestige.intValue > 95) {
                teamPrestige = 95;
            } else if (prestige.intValue < 25) {
                teamPrestige = 25;
            } else {
                teamPrestige = prestige.intValue;
            }
            NSLog(@"New prestige for %@: %d", abbreviation,teamPrestige);
            NSLog(@"recycling players...");
            [self recruitPlayers: @[@2, @4, @6, @2, @10, @2, @6, @8, @6, @2]];
        }
        
        if ([league isTeamAbbrValid:jsonDict[@"abbreviation"] allowUserTeam:YES allowOverwrite:YES]) {
            abbreviation = jsonDict[@"abbreviation"];
        }
        
        if ([league isStateValid:jsonDict[@"state"]]) {
            state = jsonDict[@"state"];
        }
        
        if ([league isTeamAbbrValid:jsonDict[@"rival"] allowUserTeam:YES allowOverwrite:YES]) {
            NSLog(@"CHANGING RIVAL FOR %@ TO %@", abbreviation, json[@"rival"]);
            rivalTeam = jsonDict[@"rival"];
        } else {
            NSLog(@"RIVAL FOR %@ REMAINING %@", abbreviation, rivalTeam);
        }
    } else {
        NSLog(@"ERROR parsing team metadata: %@", error);
    }
}

-(NSInteger)importIdentifier {
    int h = 0;
    
    for (int i = 0; i < (int)name.length; i++) {
        h = (31 * h) + [name characterAtIndex:i];
    }
    
    return h;
}

-(NSArray *)getPlayersAtPosition:(NSString*)pos {
    if ([pos isEqualToString:@"QB"]) return teamQBs;
    else if ([pos isEqualToString:@"RB"]) return teamRBs;
    else if ([pos isEqualToString:@"WR"]) return teamWRs;
    else if ([pos isEqualToString:@"OL"]) return teamOLs;
    else if ([pos isEqualToString:@"K"]) return teamKs;
    else if ([pos isEqualToString:@"S"]) return teamSs;
    else if ([pos isEqualToString:@"CB"]) return teamCBs;
    else if ([pos isEqualToString:@"DL"]) return teamDLs;
    else if ([pos isEqualToString:@"LB"]) return teamLBs;
    else return 0;
}

-(NSInteger)getTeamSize {
    return teamQBs.count + teamRBs.count + teamWRs.count + teamTEs.count + teamOLs.count + teamDLs.count + teamLBs.count + teamCBs.count + teamSs.count + teamKs.count;
}

-(void)addPlayer:(Player *)p {
    if ([p isKindOfClass:[PlayerQB class]]) {
        [teamQBs addObject:(PlayerQB*)p];
    } else if ([p isKindOfClass:[PlayerRB class]]) {
        [teamRBs addObject:(PlayerRB*)p];
    } else if ([p isKindOfClass:[PlayerTE class]]) {
        [teamTEs addObject:(PlayerTE*)p];
    } else if ([p isKindOfClass:[PlayerWR class]]) {
        [teamWRs addObject:(PlayerWR*)p];
    } else if ([p isKindOfClass:[PlayerOL class]]) {
        [teamOLs addObject:(PlayerOL*)p];
    } else if ([p isKindOfClass:[PlayerK class]]) {
        [teamKs addObject:(PlayerK*)p];
    } else if ([p isKindOfClass:[PlayerS class]]) {
        [teamSs addObject:(PlayerS*)p];
    } else if ([p isKindOfClass:[PlayerCB class]]) {
        [teamCBs addObject:(PlayerCB*)p];
    } else if ([p isKindOfClass:[PlayerDL class]]) {
        [teamDLs addObject:(PlayerDL*)p];
    } else if ([p isKindOfClass:[PlayerLB class]]) {
        [teamLBs addObject:(PlayerLB*)p];
    } else {
    }
}

- (NSNumber *)_meanOf:(NSArray *)array
{
    double runningTotal = 0.0;
    
    for(NSNumber *number in array)
    {
        runningTotal += [number doubleValue];
    }
    
    return [NSNumber numberWithDouble:(runningTotal / [array count])];
}

- (NSNumber *)_standardDeviationOf:(NSArray *)array
{
    if(![array count]) return nil;
    
    double mean = [[self _meanOf:array] doubleValue];
    double sumOfSquaredDifferences = 0.0;
    
    for(NSNumber *number in array)
    {
        double valueOfNumber = [number doubleValue];
        double difference = valueOfNumber - mean;
        sumOfSquaredDifferences += difference * difference;
    }
    
    return [NSNumber numberWithDouble:sqrt(sumOfSquaredDifferences / [array count])];
}

// based on https://247sports.com/Season/2017-Football/CompositeTeamRankings
-(void)calculateRecruitingClassRanking {
    NSMutableArray *mapped = [NSMutableArray arrayWithCapacity:self.recruitingClass.count];
    [self.recruitingClass sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [HBSharedUtils comparePlayers:obj1 toObj2:obj2];
    }];
    
    [self.recruitingClass enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Player *p = (Player *)obj;
        [mapped addObject:@(p.ratOvr)];
    }];
    
    float sum = 0;
    float stdDev = [[self _standardDeviationOf:mapped] floatValue];
    for (int n = 0; n < mapped.count; n++) {
        float Rn = [mapped[n] floatValue];
        float exponent = (-1 * pow((n - 1), 2)) / (2 * pow(stdDev, 2));
        float composite = Rn * pow(M_E, exponent);
        sum += composite;
    }
    self.teamRecruitingClassScore = (int)(ceilf(sum));
}

-(void)calculateRecruitingPoints {
    if (!league.didFinishTransferPeriod) {
        // calculate recruiting points, but never show number - just show as usage as "% effort extended"
        int estimatedRecruitingPoints = ([HBSharedUtils currentLeague].isHardMode) ? (int)ceilf(25.0 * [HBSharedUtils currentLeague].userTeam.teamPrestige) : (int)ceilf(30.0 * [HBSharedUtils currentLeague].userTeam.teamPrestige);
        recruitingPoints = MAX(estimatedRecruitingPoints, 600);
    }
}

@end
