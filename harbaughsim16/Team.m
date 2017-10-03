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
#import "PlayerF7.h"
#import "PlayerCB.h"
#import "PlayerS.h"
#import "HBSharedUtils.h"
#import "Record.h"

#import "AutoCoding.h"

#define NFL_OVR 90
#define NFL_CHANCE 0.50
#define NCG_DRAFT_BONUS 0.20
#define HARD_MODE_DRAFT_BONUS 0.20

@implementation Team
@synthesize league, name, abbreviation,conference,rivalTeam,isUserControlled,wonRivalryGame,recruitingMoney,numberOfRecruits,wins,losses,totalWins,totalLosses,totalCCs,totalNCs,totalCCLosses,totalNCLosses,totalBowlLosses,gameSchedule,oocGame0,oocGame4,oocGame9,gameWLSchedule,gameWinsAgainst,confChampion,semifinalWL,natlChampWL,teamPoints,teamOppPoints,teamYards,teamOppYards,teamPassYards,teamRushYards,teamOppPassYards,teamOppRushYards,teamTODiff,teamOffTalent,teamDefTalent,teamPrestige,teamPollScore,teamStrengthOfWins,teamStatDefNum,teamStatOffNum,rankTeamPoints,rankTeamOppPoints,rankTeamYards,rankTeamOppYards,rankTeamPassYards,rankTeamRushYards,rankTeamOppPassYards,rankTeamOppRushYards,rankTeamTODiff,rankTeamOffTalent,rankTeamDefTalent,rankTeamPrestige,rankTeamPollScore,rankTeamStrengthOfWins,diffPrestige,diffOffTalent,diffDefTalent,teamSs,teamKs,teamCBs,teamF7s,teamOLs,teamQBs,teamRBs,teamWRs,offensiveStrategy,defensiveStrategy,totalBowls,playersLeaving,singleSeasonCompletionsRecord,singleSeasonFgMadeRecord,singleSeasonRecTDsRecord,singleSeasonXpMadeRecord,singleSeasonCarriesRecord,singleSeasonCatchesRecord,singleSeasonFumblesRecord,singleSeasonPassTDsRecord,singleSeasonRushTDsRecord,singleSeasonRecYardsRecord,singleSeasonPassYardsRecord,singleSeasonRushYardsRecord,singleSeasonInterceptionsRecord,careerCompletionsRecord,careerFgMadeRecord,careerRecTDsRecord,careerXpMadeRecord,careerCarriesRecord,careerCatchesRecord,careerFumblesRecord,careerPassTDsRecord,careerRushTDsRecord,careerRecYardsRecord,careerPassYardsRecord,careerRushYardsRecord,careerInterceptionsRecord,streaks,deltaPrestige,heismans,rivalryWins,rivalryLosses,totalConfWins,totalConfLosses, confWins,confLosses,rankTeamTotalWins, injuredPlayers,recoveredPlayers,hallOfFamers,teamHistoryDictionary, teamHistory;

-(void)setWithCoder:(NSCoder *)aDecoder {
    [super setWithCoder:aDecoder];

    if (teamHistory.count > 0) {
        if (teamHistoryDictionary == nil) {
            teamHistoryDictionary = [NSMutableDictionary dictionary];
        }
        if (teamHistoryDictionary.count < teamHistory.count) {
            for (int i = 0; i < teamHistory.count; i++) {
                [teamHistoryDictionary setObject:teamHistory[i] forKey:[NSString stringWithFormat:@"%ld",(long)(2016 + i)]];
            }
        }
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
            if (a.isHeisman) {
                return -1;
            } else if (b.isHeisman) {
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

+(instancetype)newTeamWithName:(NSString *)nm abbreviation:(NSString *)abbr conference:(NSString *)conf league:(League *)league prestige:(int)prestige rivalTeam:(NSString *)rivalTeamAbbr {
    return [[Team alloc] initWithName:nm abbreviation:abbr conference:conf league:league prestige:prestige rivalTeam:rivalTeamAbbr];
}

-(instancetype)initWithName:(NSString*)nm abbreviation:(NSString*)abbr conference:(NSString*)conf league:(League*)ligue prestige:(int)prestige rivalTeam:(NSString*)rivalTeamAbbr {
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
        teamF7s = [NSMutableArray array];
        teamSs = [NSMutableArray array];
        teamCBs = [NSMutableArray array];

        gameSchedule = [NSMutableArray array];
        playersLeaving = [NSMutableArray array];
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

        teamPrestige = prestige;
        [self recruitPlayers: @[@2, @4, @6, @2, @10, @2, @6, @14]];

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
        if (!self.isUserControlled) {
            int expectedPollFinish = 100 - teamPrestige;
            int diffExpected = expectedPollFinish - rankTeamPollScore;
            int oldPrestige = teamPrestige;
            int newPrestige;
            if (teamPrestige > 45 || diffExpected > 0) {
                newPrestige = (int)pow(teamPrestige, 1 + (float)diffExpected/1500);
                deltaPrestige = (newPrestige - oldPrestige);
            }
        }
        
        if ([league findTeam:rivalTeam].isUserControlled && league.isHardMode) {
            // My rival is the user team, lock my prestige if it is Hard Mode
            Team *rival = [league findTeam:rivalTeam];
            if (teamPrestige < rival.teamPrestige - 10) {
                teamPrestige = rival.teamPrestige - 10;
            }
        } else if (isUserControlled && league.isHardMode) {
            // I am the user team, lock my rivals prestige
            Team *rival = [league findTeam:rivalTeam];
            if (rival.teamPrestige < teamPrestige - 10) {
                rival.teamPrestige = teamPrestige - 10;
            }
        }

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
    PlayerWR *wr3 = [self getWR:2];
    PlayerK *k = [self getK:0];

    [qb checkRecords];
    [rb1 checkRecords];
    [rb2 checkRecords];
    [wr1 checkRecords];
    [wr2 checkRecords];
    [wr3 checkRecords];
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
    int qbNeeds=0, rbNeeds=0, wrNeeds=0, kNeeds=0, olNeeds=0, sNeeds=0, cbNeeds=0, f7Needs=0;
    int curYear = (int)league.leagueHistoryDictionary.count + 2016;
    int i = 0;
    
    if (playersLeaving == nil || playersLeaving.count == 0) {
        [self getGraduatingPlayers];
    }
    
    if (playersLeaving.count > 0) {
        for (Player *p in playersLeaving) {
            p.endYear = curYear;
        }
        
        while (i < teamQBs.count) {
            if ([playersLeaving containsObject:teamQBs[i]]) {
                [teamQBs removeObjectAtIndex:i];
                qbNeeds++;
            } else {
                [teamQBs[i] advanceSeason];
                i++;
            }
        }
        
        i = 0;
        while (i < teamRBs.count) {
            if ([playersLeaving containsObject:teamRBs[i]]) {
                [teamRBs removeObjectAtIndex:i];
                rbNeeds++;
            } else {
                [teamRBs[i] advanceSeason];
                i++;
            }
        }
        
        i = 0;
        while (i < teamWRs.count) {
            if ([playersLeaving containsObject:teamWRs[i]]) {
                [teamWRs removeObjectAtIndex:i];
                wrNeeds++;
            } else {
                [teamWRs[i] advanceSeason];
                i++;
            }
        }
        
        i = 0;
        while (i < teamKs.count) {
            if ([playersLeaving containsObject:teamKs[i]]) {
                [teamKs removeObjectAtIndex:i];
                kNeeds++;
            } else {
                [teamKs[i] advanceSeason];
                i++;
            }
        }
        
        i = 0;
        while (i < teamOLs.count) {
            if ([playersLeaving containsObject:teamOLs[i]]) {
                [teamOLs removeObjectAtIndex:i];
                olNeeds++;
            } else {
                [teamOLs[i] advanceSeason];
                i++;
            }
        }
        
        i = 0;
        while (i < teamSs.count) {
            if ([playersLeaving containsObject:teamSs[i]]) {
                [teamSs removeObjectAtIndex:i];
                sNeeds++;
            } else {
                [teamSs[i] advanceSeason];;
                i++;
            }
        }
        
        i = 0;
        while (i < teamCBs.count) {
            if ([playersLeaving containsObject:teamCBs[i]]) {
                [teamCBs removeObjectAtIndex:i];
                cbNeeds++;
            } else {
                [teamCBs[i] advanceSeason];
                i++;
            }
        }
        
        i = 0;
        while (i < teamF7s.count) {
            if ([playersLeaving containsObject:teamF7s[i]]) {
                [teamF7s removeObjectAtIndex:i];
                f7Needs++;
            } else {
                [teamF7s[i] advanceSeason];
                i++;
            }
        }
    }
 
    [playersLeaving removeAllObjects];
    [injuredPlayers removeAllObjects];
    
    if ( !isUserControlled ) {
        [self recruitPlayersFreshman:@[@(qbNeeds), @(rbNeeds), @(wrNeeds), @(kNeeds), @(olNeeds), @(sNeeds), @(cbNeeds), @(f7Needs)]];
        [self resetStats];
    }
}

-(void)recruitPlayers:(NSArray*)needs {

    int qbNeeds, rbNeeds, wrNeeds, kNeeds, olNeeds, sNeeds, cbNeeds, f7Needs = 0;
    qbNeeds = [needs[0] intValue];
    rbNeeds = [needs[1] intValue];
    wrNeeds = [needs[2] intValue];
    kNeeds = [needs[3] intValue];
    olNeeds = [needs[4] intValue];
    sNeeds = [needs[5] intValue];
    cbNeeds = [needs[6] intValue];
    f7Needs = [needs[7] intValue];


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

    for( int i = 0; i < f7Needs; ++i ) {
        //make F7s
        if ((([HBSharedUtils randomValue] * 100)/100) < 5*chance ) {
            [teamF7s addObject:[PlayerF7 newF7WithName:[league getRandName] year:(int)(4* [HBSharedUtils randomValue] + 1) stars:(stars - 1) team:self]];
        } else {
            [teamF7s addObject:[PlayerF7 newF7WithName:[league getRandName] year:(int)(4* [HBSharedUtils randomValue] + 1) stars:(stars) team:self]];
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

-(void)recruitPlayersFreshman:(NSArray*)needs {

    int qbNeeds, rbNeeds, wrNeeds, kNeeds, olNeeds, sNeeds, cbNeeds, f7Needs = 0;
    qbNeeds = [needs[0] intValue];
    rbNeeds = [needs[1] intValue];
    wrNeeds = [needs[2] intValue];
    kNeeds = [needs[3] intValue];
    olNeeds = [needs[4] intValue];
    sNeeds = [needs[5] intValue];
    cbNeeds = [needs[6] intValue];
    f7Needs = [needs[7] intValue];

    if (qbNeeds > 2) {
        qbNeeds = 2;
    } else {
        if (teamQBs.count >= 2) {
            qbNeeds = 0;
        }
    }

    if (rbNeeds > 4) {
        rbNeeds = 4;
    } else {
        if (teamRBs.count >= 4) {
            rbNeeds = 0;
        }
    }

    if (wrNeeds > 6) {
        wrNeeds = 6;
    } else {
        if (teamWRs.count >= 6) {
            wrNeeds = 0;
        }
    }

    if (kNeeds > 2) {
        kNeeds = 2;
    } else {
        if (teamKs.count >= 2) {
            kNeeds = 0;
        }
    }

    if (olNeeds > 10) {
        olNeeds = 10;
    } else {
        if (teamOLs.count >= 10) {
            olNeeds = 0;
        }
    }

    if (sNeeds > 2) {
        sNeeds = 2;
    } else {
        if (teamSs.count >= 2) {
            sNeeds = 0;
        }
    }

    if (cbNeeds > 6) {
        cbNeeds = 6;
    } else {
        if (teamCBs.count >= 6) {
            cbNeeds = 0;
        }
    }

    if (f7Needs > 14) {
        f7Needs = 14;
    } else {
        if (teamF7s.count >= 14) {
            f7Needs = 0;
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

        if ((([HBSharedUtils randomValue] * 100)/100) < 5*chance ) {
            [teamQBs addObject:[PlayerQB newQBWithName:[league getRandName] year:1 stars:(stars - 1) team:self]];
        } else {
            [teamQBs addObject:[PlayerQB newQBWithName:[league getRandName] year:1 stars:(stars) team:self]];
        }
    }

    for( int i = 0; i < kNeeds; ++i ) {
        //make Ks
        stars = teamPrestige/20 + 1;
        if ([HBSharedUtils randomValue] < starsBonusChance) {
            stars += 1;
        } else if ([HBSharedUtils randomValue] < starsBonusDoubleChance) {
            stars += 2;
        }

        if ((([HBSharedUtils randomValue] * 100)/100) < 5*chance ) {
            [teamKs addObject:[PlayerK newKWithName:[league getRandName] year:1 stars:(stars - 1) team:self]];
        } else {
            [teamKs addObject:[PlayerK newKWithName:[league getRandName] year:1 stars:(stars) team:self]];
        }
    }

    for( int i = 0; i < rbNeeds; ++i ) {
        //make RBs
        stars = teamPrestige/20 + 1;
        if ([HBSharedUtils randomValue] < starsBonusChance) {
            stars += 1;
        } else if ([HBSharedUtils randomValue] < starsBonusDoubleChance) {
            stars += 2;
        }

        if ((([HBSharedUtils randomValue] * 100)/100) < 5*chance ) {
            [teamRBs addObject:[PlayerRB newRBWithName:[league getRandName] year:1 stars:(stars - 1) team:self]];
        } else {
            [teamRBs addObject:[PlayerRB newRBWithName:[league getRandName] year:1 stars:(stars) team:self]];
        }
    }

    for( int i = 0; i < wrNeeds; ++i ) {
        //make WRs
        stars = teamPrestige/20 + 1;
        if ([HBSharedUtils randomValue] < starsBonusChance) {
            stars += 1;
        } else if ([HBSharedUtils randomValue] < starsBonusDoubleChance) {
            stars += 2;
        }

        if ((([HBSharedUtils randomValue] * 100)/100) < 5*chance ) {
            [teamWRs addObject:[PlayerWR newWRWithName:[league getRandName] year:1 stars:(stars - 1) team:self]];
        } else {
            [teamWRs addObject:[PlayerWR newWRWithName:[league getRandName] year:1 stars:(stars) team:self]];
        }
    }

    for( int i = 0; i < olNeeds; ++i ) {
        //make OLs
        stars = teamPrestige/20 + 1;
        if ([HBSharedUtils randomValue] < starsBonusChance) {
            stars += 1;
        } else if ([HBSharedUtils randomValue] < starsBonusDoubleChance) {
            stars += 2;
        }

        if ((([HBSharedUtils randomValue] * 100)/100) < 5*chance ) {
            [teamOLs addObject:[PlayerOL newOLWithName:[league getRandName] year:1 stars:(stars - 1) team:self]];
        } else {
            [teamOLs addObject:[PlayerOL newOLWithName:[league getRandName] year:1 stars:(stars) team:self]];
        }
    }

    for( int i = 0; i < cbNeeds; ++i ) {
        //make CBs
        stars = teamPrestige/20 + 1;
        if ([HBSharedUtils randomValue] < starsBonusChance) {
            stars += 1;
        } else if ([HBSharedUtils randomValue] < starsBonusDoubleChance) {
            stars += 2;
        }

        if ((([HBSharedUtils randomValue] * 100)/100) < 5*chance ) {
            [teamCBs addObject:[PlayerCB newCBWithName:[league getRandName] year:1 stars:(stars - 1) team:self]];
        } else {
            [teamCBs addObject:[PlayerCB newCBWithName:[league getRandName] year:1 stars:(stars) team:self]];
        }
    }

    for( int i = 0; i < f7Needs; ++i ) {
        //make F7s
        stars = teamPrestige/20 + 1;
        if ([HBSharedUtils randomValue] < starsBonusChance) {
            stars += 1;
        } else if ([HBSharedUtils randomValue] < starsBonusDoubleChance) {
            stars += 2;
        }

        if ((([HBSharedUtils randomValue] * 100)/100) < 5*chance ) {
            [teamF7s addObject:[PlayerF7 newF7WithName:[league getRandName] year:1 stars:(stars - 1) team:self]];
        } else {
            [teamF7s addObject:[PlayerF7 newF7WithName:[league getRandName] year:1 stars:(stars) team:self]];
        }
    }

    for( int i = 0; i < sNeeds; ++i ) {
        //make Ss
        stars = teamPrestige/20 + 1;
        if ([HBSharedUtils randomValue] < starsBonusChance) {
            stars += 1;
        } else if ([HBSharedUtils randomValue] < starsBonusDoubleChance) {
            stars += 2;
        }

        if ((([HBSharedUtils randomValue] * 100)/100) < 5*chance ) {
            [teamSs addObject:[PlayerS newSWithName:[league getRandName] year:1 stars:(stars - 1) team:self]];
        } else {
            [teamSs addObject:[PlayerS newSWithName:[league getRandName] year:1 stars:(stars) team:self]];
        }
    }

    //done making players, sort them
    [self sortPlayers];

}

-(void)recruitWalkOns:(NSArray*)needs {
    int qbNeeds, rbNeeds, wrNeeds, kNeeds, olNeeds, sNeeds, cbNeeds, f7Needs = 0;
    qbNeeds = [needs[0] intValue];
    rbNeeds = [needs[1] intValue];
    wrNeeds = [needs[2] intValue];
    kNeeds = [needs[3] intValue];
    olNeeds = [needs[4] intValue];
    sNeeds = [needs[5] intValue];
    cbNeeds = [needs[6] intValue];
    f7Needs = [needs[7] intValue];

    for( int i = 0; i < qbNeeds; ++i ) {
        //make QBs
        [teamQBs addObject:[PlayerQB newQBWithName:[league getRandName] year:1 stars:1 team:self]];
    }

    for( int i = 0; i < rbNeeds; ++i ) {
        //make RBs
        [teamRBs addObject:[PlayerRB newRBWithName:[league getRandName] year:1 stars:1 team:self]];
    }

    for( int i = 0; i < wrNeeds; ++i ) {
        //make WRs
        [teamWRs addObject:[PlayerWR newWRWithName:[league getRandName] year:1 stars:1 team:self]];
    }

    for( int i = 0; i < olNeeds; ++i ) {
        //make OLs
        [teamOLs addObject:[PlayerOL newOLWithName:[league getRandName] year:1 stars:1 team:self]];
    }

    for( int i = 0; i < kNeeds; ++i ) {
        //make Ks
        [teamKs addObject:[PlayerK newKWithName:[league getRandName] year:1 stars:1 team:self]];
    }

    for( int i = 0; i < sNeeds; ++i ) {
        //make Ss
        [teamSs addObject:[PlayerS newSWithName:[league getRandName] year:1 stars:1 team:self]];
    }

    for( int i = 0; i < cbNeeds; ++i ) {
        //make CBs
        [teamCBs addObject:[PlayerCB newCBWithName:[league getRandName] year:1 stars:1 team:self]];
    }

    for( int i = 0; i < f7Needs; ++i ) {
        //make F7s
        [teamF7s addObject:[PlayerF7 newF7WithName:[league getRandName] year:1 stars:1 team:self]];
    }

    //done making players, sort them
    [self sortPlayers];
}

-(void)resetStats {
    gameSchedule = [NSMutableArray array];
    oocGame0 = nil;
    oocGame4 = nil;
    oocGame9 = nil;
    gameWinsAgainst = [NSMutableArray array];
    gameWLSchedule = [NSMutableArray array];
    injuredPlayers = [NSMutableArray array];
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
    teamStatOffNum = [self getCPUOffense];
    teamStatDefNum = [self getCPUDefense];
    offensiveStrategy = [self getOffensiveTeamStrategies][teamStatOffNum];
    defensiveStrategy = [self getDefensiveTeamStrategies][teamStatDefNum];
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
            [hist appendFormat:@"\n%@ - W %@",ccg.gameName,[self gameSummaryString:ccg]];
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

    [teamHistoryDictionary setObject:hist forKey:[NSString stringWithFormat:@"%ld",(long)(2016 + league.leagueHistoryDictionary.count)]];
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
        Player *a = (Player*)obj1;
        Player *b = (Player*)obj2;
        if (!a.hasRedshirt && !b.hasRedshirt && !a.isInjured && !b.isInjured) {
            if (a.ratOvr > b.ratOvr) {
                return -1;
            } else if (a.ratOvr < b.ratOvr) {
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
        } else if (a.hasRedshirt) {
            return 1;
        } else if (b.hasRedshirt) {
            return -1;
        } else if (a.isInjured) {
            return 1;
        } else if (b.isInjured) {
            return  -1;
        } else {
            if (a.ratOvr > b.ratOvr) {
                return -1;
            } else if (a.ratOvr < b.ratOvr) {
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
    }];
    [teamRBs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Player *a = (Player*)obj1;
        Player *b = (Player*)obj2;
        if (!a.hasRedshirt && !b.hasRedshirt && !a.isInjured && !b.isInjured) {
            if (a.ratOvr > b.ratOvr) {
                return -1;
            } else if (a.ratOvr < b.ratOvr) {
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
        } else if (a.hasRedshirt) {
            return 1;
        } else if (b.hasRedshirt) {
            return -1;
        } else if (a.isInjured) {
            return 1;
        } else if (b.isInjured) {
            return  -1;
        } else {
            if (a.ratOvr > b.ratOvr) {
                return -1;
            } else if (a.ratOvr < b.ratOvr) {
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
    }];
    [teamWRs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Player *a = (Player*)obj1;
        Player *b = (Player*)obj2;
        if (!a.hasRedshirt && !b.hasRedshirt && !a.isInjured && !b.isInjured) {
            if (a.ratOvr > b.ratOvr) {
                return -1;
            } else if (a.ratOvr < b.ratOvr) {
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
        } else if (a.hasRedshirt) {
            return 1;
        } else if (b.hasRedshirt) {
            return -1;
        } else if (a.isInjured) {
            return 1;
        } else if (b.isInjured) {
            return  -1;
        } else {
            if (a.ratOvr > b.ratOvr) {
                return -1;
            } else if (a.ratOvr < b.ratOvr) {
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
    }];
    [teamKs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Player *a = (Player*)obj1;
        Player *b = (Player*)obj2;
        if (!a.hasRedshirt && !b.hasRedshirt && !a.isInjured && !b.isInjured) {
            if (a.ratOvr > b.ratOvr) {
                return -1;
            } else if (a.ratOvr < b.ratOvr) {
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
        } else if (a.hasRedshirt) {
            return 1;
        } else if (b.hasRedshirt) {
            return -1;
        } else if (a.isInjured) {
            return 1;
        } else if (b.isInjured) {
            return  -1;
        } else {
            if (a.ratOvr > b.ratOvr) {
                return -1;
            } else if (a.ratOvr < b.ratOvr) {
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
    }];
    [teamOLs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Player *a = (Player*)obj1;
        Player *b = (Player*)obj2;
        if (!a.hasRedshirt && !b.hasRedshirt && !a.isInjured && !b.isInjured) {
            if (a.ratOvr > b.ratOvr) {
                return -1;
            } else if (a.ratOvr < b.ratOvr) {
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
        } else if (a.hasRedshirt) {
            return 1;
        } else if (b.hasRedshirt) {
            return -1;
        } else if (a.isInjured) {
            return 1;
        } else if (b.isInjured) {
            return  -1;
        } else {
            if (a.ratOvr > b.ratOvr) {
                return -1;
            } else if (a.ratOvr < b.ratOvr) {
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
    }];

    [teamCBs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Player *a = (Player*)obj1;
        Player *b = (Player*)obj2;
        if (!a.hasRedshirt && !b.hasRedshirt && !a.isInjured && !b.isInjured) {
            if (a.ratOvr > b.ratOvr) {
                return -1;
            } else if (a.ratOvr < b.ratOvr) {
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
        } else if (a.hasRedshirt) {
            return 1;
        } else if (b.hasRedshirt) {
            return -1;
        } else if (a.isInjured) {
            return 1;
        } else if (b.isInjured) {
            return  -1;
        } else {
            if (a.ratOvr > b.ratOvr) {
                return -1;
            } else if (a.ratOvr < b.ratOvr) {
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
    }];
    [teamSs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Player *a = (Player*)obj1;
        Player *b = (Player*)obj2;
        if (!a.hasRedshirt && !b.hasRedshirt && !a.isInjured && !b.isInjured) {
            if (a.ratOvr > b.ratOvr) {
                return -1;
            } else if (a.ratOvr < b.ratOvr) {
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
        } else if (a.hasRedshirt) {
            return 1;
        } else if (b.hasRedshirt) {
            return -1;
        } else if (a.isInjured) {
            return 1;
        } else if (b.isInjured) {
            return  -1;
        } else {
            if (a.ratOvr > b.ratOvr) {
                return -1;
            } else if (a.ratOvr < b.ratOvr) {
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
    }];
    [teamF7s sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Player *a = (Player*)obj1;
        Player *b = (Player*)obj2;
        if (!a.hasRedshirt && !b.hasRedshirt && !a.isInjured && !b.isInjured) {
            if (a.ratOvr > b.ratOvr) {
                return -1;
            } else if (a.ratOvr < b.ratOvr) {
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
        } else if (a.hasRedshirt) {
            return 1;
        } else if (b.hasRedshirt) {
            return -1;
        } else if (a.isInjured) {
            return 1;
        } else if (b.isInjured) {
            return  -1;
        } else {
            if (a.ratOvr > b.ratOvr) {
                return -1;
            } else if (a.ratOvr < b.ratOvr) {
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

-(PlayerF7*)getF7:(int)depth {
    if (teamF7s.count > 0 && depth < teamF7s.count && depth >= 0 ) {
        return teamF7s[depth];
    } else {
        return nil;
    }
}

-(int)getPassProf {
    int avgWRs = ( [self getWR:0].ratOvr + [self getWR:1].ratOvr + [self getWR:2].ratOvr)/3;
    return ([self getCompositeOLPass] + [self getQB:0].ratOvr*2 + avgWRs)/4;
}

-(int)getRushProf {
    int avgRBs = ( [self getRB:0].ratOvr + [self getRB:1].ratOvr )/2;
    return ([ self getCompositeOLRush] + avgRBs )/2;
}

-(int)getPassDef {
    int avgCBs = ( [self getCB:0].ratOvr + [self getCB:1].ratOvr + [self getCB:2].ratOvr)/3;
    return (avgCBs*3 + [self getS:0].ratOvr + [self getCompositeF7Pass]*2)/6;
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
        return compositeOL / 5;
    } else {
        for ( int i = 0; i < teamOLs.count; ++i ) {
            compositeOL += (teamOLs[i].ratOLPow + teamOLs[i].ratOLBkP)/2;
        }
        return compositeOL / teamOLs.count;
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
    for (int i = 0; i < 7; ++i) {
        comp += [self getF7:i].ratFootIQ/7;
    }
    return comp / 20;
}

-(int)getCompositeOLRush {
    int compositeOL = 0;
    if (teamOLs.count >= 5) {
        for ( int i = 0; i < 5; ++i ) {
            compositeOL += (teamOLs[i].ratOLPow + teamOLs[i].ratOLBkR)/2;
        }
        return compositeOL / 5;
    } else {
        for ( int i = 0; i < teamOLs.count; ++i ) {
            compositeOL += (teamOLs[i].ratOLPow + teamOLs[i].ratOLBkR)/2;
        }
        return compositeOL / teamOLs.count;
    }
}

-(int)getCompositeF7Pass {
    int compositeF7 = 0;
    if (teamF7s.count >= 7) {
        for ( int i = 0; i < 7; ++i ) {
            compositeF7 += (teamF7s[i].ratF7Pow + teamF7s[i].ratF7Pas)/2;
        }
        return compositeF7 / 7;
    } else {
        for ( int i = 0; i < teamF7s.count; ++i ) {
            compositeF7 += (teamF7s[i].ratF7Pow + teamF7s[i].ratF7Pas)/2;
        }
        return compositeF7 / teamF7s.count;
    }
}

-(int)getCompositeF7Rush {
    int compositeF7 = 0;
    if (teamF7s.count >= 7) {
        for ( int i = 0; i < 7; ++i ) {
            compositeF7 += (teamF7s[i].ratF7Pow + teamF7s[i].ratF7Rsh)/2;
        }
        return compositeF7 / 7;
    } else {
        for ( int i = 0; i < teamF7s.count; ++i ) {
            compositeF7 += (teamF7s[i].ratF7Pow + teamF7s[i].ratF7Rsh)/2;
        }
        return compositeF7 / teamF7s.count;
    }

}

-(NSArray*)getTeamStatsArray {
    NSMutableArray *ts0 = [NSMutableArray array];
    //[ts0 appendFormat:@"%ld",(long)teamPollScore];
    //[ts0 appendString:@"AP Votes"];
    //[ts0 appendFormat:@"%@",[self getRankString:rankTeamPollScore]];

    [ts0 addObject:@[[NSString stringWithFormat:@"%d",teamPollScore], @"AP Votes",[self getRankString:rankTeamPollScore]]];

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
    if ((rivalryWins > rivalryLosses) && (teamPrestige - [league findTeam:rivalTeam].teamPrestige < 20) ) {
        [summary appendString:@"\n\nRecruits were impressed that you defeated your rival. You gained 2 prestige."];
        deltaPrestige += 2;
    } else if ((rivalryLosses > rivalryWins) && ([league findTeam:rivalTeam].teamPrestige - teamPrestige < 20 || [name isEqualToString:@"American Samoa"])) {
        [summary appendString:@"\n\nSince you couldn't win your rivalry series, recruits aren't excited to attend your school. You lost 2 prestige."];
        deltaPrestige -= 2;
    } else if (rivalryWins == rivalryLosses) {
        [summary appendString:@"\n\nThe season series between you and your rival was tied. You gain no prestige for this."];
    } else if ((rivalryWins > rivalryLosses) && (teamPrestige - [league findTeam:rivalTeam].teamPrestige >= 20)) {
        [summary appendString:@"\n\nYou won your rivalry series, but it was expected given the state of their program. You gain no prestige for this."];
    } else if ((rivalryWins < rivalryLosses) && (teamPrestige - [league findTeam:rivalTeam].teamPrestige >= 20)) {
        [summary appendString:@"\n\nYou lost your rivalry series, but this was expected given your rebuilding program. You lost no prestige for this."];
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
        if (g.awayTeam.rankTeamPollScore > 0 && g.awayTeam.rankTeamPollScore < 26) {
            return [NSString stringWithFormat:@"%ld - %ld vs #%ld %@",(long)g.homeScore,(long)g.awayScore,(long)g.awayTeam.rankTeamPollScore,g.awayTeam.abbreviation];
        } else {
            return [NSString stringWithFormat:@"%ld - %ld vs %@",(long)g.homeScore,(long)g.awayScore,g.awayTeam.abbreviation];
        }
    } else {
        if (g.homeTeam.rankTeamPollScore > 0 && g.homeTeam.rankTeamPollScore < 26) {
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
        if (g.awayTeam.rankTeamPollScore < 26 && g.awayTeam.rankTeamPollScore > 0) {
            rank = [NSString stringWithFormat:@" #%ld",(long)g.awayTeam.rankTeamPollScore];
        }
        return [NSString stringWithFormat:@"vs%@ %@",rank,g.awayTeam.abbreviation];
    } else {
        if (g.homeTeam.rankTeamPollScore < 26 && g.homeTeam.rankTeamPollScore > 0) {
            rank = [NSString stringWithFormat:@" #%ld",(long)g.homeTeam.rankTeamPollScore];
        }
        return [NSString stringWithFormat:@"@%@ %@",rank,g.homeTeam.abbreviation];
    }
}

-(void)getGraduatingPlayers {
    if (playersLeaving.count == 0) {
        playersLeaving = [NSMutableArray array];
        int i = 0;
        double draftChance = NFL_CHANCE;
        if (league.isHardMode) {
            draftChance += HARD_MODE_DRAFT_BONUS;
        }
        
        if ([natlChampWL isEqualToString:@"NCW"]) {
            draftChance += NCG_DRAFT_BONUS;
        }

        while (i < teamQBs.count) {
            if (teamQBs[i].year >= 4 || (teamQBs[i].year == 3 && teamQBs[i].gamesPlayed && teamQBs[i].ratOvr > NFL_OVR && [HBSharedUtils randomValue] < draftChance)) {
                [playersLeaving addObject:teamQBs[i]];
                if (teamQBs[i].year == 3) {
                    NSLog(@"JUNIOR QB LEAVING");
                }
            }
            ++i;
        }

        i = 0;
        while (i < teamRBs.count) {
            if (teamRBs[i].year >= 4 || (teamRBs[i].year == 3 && teamRBs[i].gamesPlayed && teamRBs[i].ratOvr > NFL_OVR && [HBSharedUtils randomValue] < draftChance)) {
                [playersLeaving addObject:teamRBs[i]];
                if (teamRBs[i].year == 3) {
                    NSLog(@"JUNIOR RB LEAVING");
                }
            }
            ++i;
        }

        i = 0;
        while (i < teamWRs.count) {
            if (teamWRs[i].year >= 4 || (teamWRs[i].year == 3 && teamWRs[i].gamesPlayed && teamWRs[i].ratOvr > NFL_OVR && [HBSharedUtils randomValue] < draftChance)) {
                [playersLeaving addObject:teamWRs[i]];
                if (teamWRs[i].year == 3) {
                    NSLog(@"JUNIOR WR LEAVING");
                }
            }
            ++i;
        }

        i = 0;
        while (i < teamKs.count) {
            if (teamKs[i].year >= 4 || (teamKs[i].year == 3 && teamKs[i].gamesPlayed && teamKs[i].ratOvr > NFL_OVR && [HBSharedUtils randomValue] < draftChance)) {
                [playersLeaving addObject:teamKs[i]];
                if (teamKs[i].year == 3) {
                    NSLog(@"JUNIOR K LEAVING");
                }
            }
            ++i;
        }

        i = 0;
        while (i < teamOLs.count) {
            if (teamOLs[i].year >= 4 || (teamOLs[i].year == 3 && teamOLs[i].gamesPlayed && teamOLs[i].ratOvr > NFL_OVR && [HBSharedUtils randomValue] < draftChance)) {
                [playersLeaving addObject:teamOLs[i]];
                if (teamOLs[i].year == 3) {
                    NSLog(@"JUNIOR OL LEAVING");
                }
            }
            ++i;
        }

        i = 0;
        while (i < teamSs.count) {
            if (teamSs[i].year >= 4 || (teamSs[i].year == 3 && teamSs[i].gamesPlayed && teamSs[i].ratOvr > NFL_OVR && [HBSharedUtils randomValue] < draftChance)) {
                [playersLeaving addObject:teamSs[i]];
                if (teamSs[i].year == 3) {
                    NSLog(@"JUNIOR S LEAVING");
                }
            }
            ++i;
        }

        i = 0;
        while (i < teamCBs.count) {
            if (teamCBs[i].year >= 4 || (teamCBs[i].year == 3 && teamCBs[i].gamesPlayed && teamCBs[i].ratOvr > NFL_OVR && [HBSharedUtils randomValue] < draftChance)) {
                [playersLeaving addObject:teamCBs[i]];
                if (teamCBs[i].year == 3) {
                    NSLog(@"JUNIOR CB LEAVING");
                }
            }
            ++i;
        }

        i = 0;
        while (i < teamF7s.count) {
            if (teamF7s[i].year >= 4 || (teamF7s[i].year == 3 && teamF7s[i].gamesPlayed && teamF7s[i].ratOvr > NFL_OVR && [HBSharedUtils randomValue] < draftChance)) {
                [playersLeaving addObject:teamF7s[i]];
                if (teamF7s[i].year == 3) {
                    NSLog(@"JUNIOR F7 LEAVING");
                }
            }
            ++i;
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
        [self checkInjuryPosition:teamWRs starters:3];
        [self checkInjuryPosition:teamOLs starters:5];
        [self checkInjuryPosition:teamKs starters:1];
        [self checkInjuryPosition:teamSs starters:1];
        [self checkInjuryPosition:teamCBs starters:3];
        [self checkInjuryPosition:teamF7s starters:7];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"injuriesPosted" object:nil];
    }
}

-(void)checkInjuryPosition:(NSMutableArray*)positionGroup starters:(int)numStarters {
    int numInjured = 0;
    
    for (Player *p in positionGroup) {
        if ([p isInjured]) {
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
        [self sortPlayers];
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

-(NSArray*)getOffensiveTeamStrategies {
    return @[
             [TeamStrategy newStrategyWithName:@"Aggressive" description:@"Play a more aggressive offense. Will pass with lower completion percentage and higher chance of interception. However, catches will go for more yards." rYB:-1 rAB:2 pYB:3 pAB:1],
             [TeamStrategy newStrategyWithName:@"No Preference" description:@"Will play a normal offense with no bonus either way, but no penalties either." rYB:0 rAB:0 pYB:0 pAB:0],
             [TeamStrategy newStrategyWithName:@"Conservative" description:@"Play a more conservative offense, running a bit more and passing slightly less. Passes are more accurate but shorter. Rushes are more likely to gain yards but less likely to break free for big plays." rYB:1 rAB:-2 pYB:-3 pAB:-1]

             ];
}

-(NSArray*)getDefensiveTeamStrategies {
    return @[
             [TeamStrategy newStrategyWithName:@"Stack the Box" description:@"Focus on stopping the run. Will give up more big passing plays but will allow less rushing yards and far less big plays from rushing." rYB:1 rAB:0 pYB:-1 pAB:-1],
             [TeamStrategy newStrategyWithName:@"No Preference" description:@"Will play a normal defense with no bonus either way, but no penalties either." rYB:0 rAB:0 pYB:0 pAB:0],
             [TeamStrategy newStrategyWithName:@"No Fly Zone" description:@"Focus on stopping the pass. Will give up less yards on catches and will be more likely to intercept passes, but will allow more rushing yards." rYB:-1 rAB:0 pYB:1 pAB:1]

             ];
}

-(int)getCPUOffense {
    int OP, OR, OS = 0;
    OP = [self getPassProf];
    OR = [self getRushProf];
    if(OP > (OR + 2)) {
        OS = 0;
    } else if(OR > (OP + 2)) {
        OS = 2;
    } else OS = 1;
    return OS;
}

-(int)getCPUDefense {
    int DP, DR, DS = 0;
    DP = [self getPassDef];
    DR = [self getRushDef];
    if(DR > (DP + 2)) {
        DS = 0;
    } else if(DP > (DR + 2)) {
        DS = 2;
    } else DS = 1;
    return DS;
}

-(NSString*)getRankStrStarUser:(int)num {
    if (num == 11) {
        return @"** 11th **";
    } else if (num == 12) {
        return @"** 12th **";
    } else if (num == 13) {
        return @"** 13th **";
    } else if (num%10 == 1) {
        return [NSString stringWithFormat:@"** %ldst **",(long)num];
    } else if (num%10 == 2) {
        return [NSString stringWithFormat:@"** %ldnd **",(long)num];
    } else if (num%10 == 3){
        return [NSString stringWithFormat:@"** %ldrd **",(long)num];
    } else {
        return [NSString stringWithFormat:@"** %ldth **",(long)num];
    }
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
            gs[1] = @"---";
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
        case 4: {
            NSMutableArray *oldF7s = [NSMutableArray array];
            [oldF7s addObjectsFromArray:teamF7s];
            [teamF7s removeAllObjects];
            for (Player *p in starters) {
                [teamF7s addObject:(PlayerF7*)p];
            }
            for (PlayerF7 *oldF7 in oldF7s) {
                if (![teamF7s containsObject:oldF7]) {
                    [teamF7s addObject:oldF7];
                }
            }
            break;
        }
        case 5: {
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
        case 6: {
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
        case 7:{
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
    
    if (hallOfFamers.count > 0) {
        //for (Player *p in hallOfFamers) {
            //p.year = 5;
        //}//
        
        //sort normally
        [hallOfFamers sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            Player *a = (Player*)obj1;
            Player *b = (Player*)obj2;
            if (!a.hasRedshirt && !b.hasRedshirt && !a.isInjured && !b.isInjured) {
                if (a.ratOvr > b.ratOvr) {
                    return -1;
                } else if (a.ratOvr < b.ratOvr) {
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
            } else if (a.hasRedshirt) {
                return 1;
            } else if (b.hasRedshirt) {
                return -1;
            } else if (a.isInjured) {
                return 1;
            } else if (b.isInjured) {
                return  -1;
            } else {
                if (a.ratOvr > b.ratOvr) {
                    return -1;
                } else if (a.ratOvr < b.ratOvr) {
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

@end
