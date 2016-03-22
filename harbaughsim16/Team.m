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

#import "AutoCoding.h"

@implementation Team
@synthesize league, name, abbreviation,conference,rivalTeam,teamHistory,isUserControlled,wonRivalryGame,recruitingMoney,numberOfRecruits,wins,losses,totalWins,totalLosses,totalCCs,totalNCs,totalCCLosses,totalNCLosses,totalBowlLosses,gameSchedule,oocGame0,oocGame4,oocGame9,gameWLSchedule,gameWinsAgainst,teamStreaks,confChampion,semifinalWL,natlChampWL,teamPoints,teamOppPoints,teamYards,teamOppYards,teamPassYards,teamRushYards,teamOppPassYards,teamOppRushYards,teamTODiff,teamOffTalent,teamDefTalent,teamPrestige,teamPollScore,teamStrengthOfWins,teamStatDefNum,teamStatOffNum,rankTeamPoints,rankTeamOppPoints,rankTeamYards,rankTeamOppYards,rankTeamPassYards,rankTeamRushYards,rankTeamOppPassYards,rankTeamOppRushYards,rankTeamTODiff,rankTeamOffTalent,rankTeamDefTalent,rankTeamPrestige,rankTeamPollScore,rankTeamStrengthOfWins,diffPrestige,diffOffTalent,diffDefTalent,teamSs,teamKs,teamCBs,teamF7s,teamOLs,teamQBs,teamRBs,teamWRs,offensiveStrategy,defensiveStrategy,totalBowls;
/*
- (NSArray *)propertyKeys
{
    NSMutableArray *array = [NSMutableArray array];
    Class class = [self class];
    while (class != [NSObject class])
    {
        unsigned int propertyCount;
        objc_property_t *properties = class_copyPropertyList(class, &propertyCount);
        for (int i = 0; i < propertyCount; i++)
        {
            //get property
            objc_property_t property = properties[i];
            const char *propertyName = property_getName(property);
            NSString *key = [NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding];
            
            //check if read-only
            BOOL readonly = NO;
            const char *attributes = property_getAttributes(property);
            NSString *encoding = [NSString stringWithCString:attributes encoding:NSUTF8StringEncoding];
            if ([[encoding componentsSeparatedByString:@","] containsObject:@"R"])
            {
                readonly = YES;
                
                //see if there is a backing ivar with a KVC-compliant name
                NSRange iVarRange = [encoding rangeOfString:@",V"];
                if (iVarRange.location != NSNotFound)
                {
                    NSString *iVarName = [encoding substringFromIndex:iVarRange.location + 2];
                    if ([iVarName isEqualToString:key] ||
                        [iVarName isEqualToString:[@"_" stringByAppendingString:key]])
                    {
                        //setValue:forKey: will still work
                        readonly = NO;
                    }
                }
            }
            
            if (!readonly)
            {
                //exclude read-only properties
                [array addObject:key];
            }
        }
        free(properties);
        class = [class superclass];
    }
    return array;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [self init]))
    {
        for (NSString *key in [self propertyKeys])
        {
            id value = [aDecoder decodeObjectForKey:key];
            [self setValue:value forKey:key];
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    for (NSString *key in [self propertyKeys])
    {
        id value = [self valueForKey:key];
        [aCoder encodeObject:value forKey:key];
    }
}*/

+(instancetype)newTeamWithName:(NSString *)nm abbreviation:(NSString *)abbr conference:(NSString *)conf league:(League *)league prestige:(int)prestige rivalTeam:(NSString *)rivalTeamAbbr {
    return [[Team alloc] initWithName:nm abbreviation:abbr conference:conf league:league prestige:prestige rivalTeam:rivalTeamAbbr];
}

-(instancetype)initWithName:(NSString*)nm abbreviation:(NSString*)abbr conference:(NSString*)conf league:(League*)ligue prestige:(int)prestige rivalTeam:(NSString*)rivalTeamAbbr {
    self = [super init];
    if (self) {
        league = ligue;
        isUserControlled = false;
        teamHistory = [NSMutableArray array];
        
        teamQBs = [NSMutableArray array];
        teamRBs = [NSMutableArray array];
        teamWRs = [NSMutableArray array];
        teamKs = [NSMutableArray array];
        teamOLs = [NSMutableArray array];
        teamF7s = [NSMutableArray array];
        teamSs = [NSMutableArray array];
        teamCBs = [NSMutableArray array];
        
        gameSchedule = [NSMutableArray array];
        oocGame0 = nil;
        oocGame4 = nil;
        oocGame9 = nil;
        gameWinsAgainst = [NSMutableArray array];
        gameWLSchedule = [NSMutableArray array];
        teamStreaks = [NSMutableDictionary dictionary];
        confChampion = @"";
        semifinalWL = @"";
        natlChampWL = @"";
        
        teamPrestige = prestige;
        [self recruitPlayers: @[@2, @4, @6, @2, @10, @2, @6, @14]];
        
        //set stats
        totalWins = 0;
        totalLosses = 0;
        totalCCs = 0;
        totalNCs = 0;
        
        totalBowls = 0;
        totalBowlLosses = 0;
        totalCCLosses = 0;
        totalNCLosses = 0;
        
        teamStatOffNum = 1;
        teamStatDefNum = 1;
        
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
        
        teamOffTalent = [self getOffensiveTalent];
        teamDefTalent = [self getDefensiveTalent];
         
        teamPollScore = teamPrestige + [self getOffensiveTalent] + [self getDefensiveTalent];
        
        offensiveStrategy = [self getOffensiveTeamStrategies][teamStatOffNum];
        defensiveStrategy = [self getDefensiveTeamStrategies][teamStatDefNum];
        numberOfRecruits = 30;
    }
    return self;
}
/*
-(instancetype)initWithString:(NSString*)loadStr league:(League*)league {
    self = [super init];
    if (self) {
        league = league;
        isUserControlled = NO;
        
        teamQBs = [NSMutableArray array];
        teamRBs = [NSMutableArray array];
        teamWRs = [NSMutableArray array];
        teamKs = [NSMutableArray array];
        teamOLs = [NSMutableArray array];
        teamF7s = [NSMutableArray array];
        teamSs = [NSMutableArray array];
        teamCBs = [NSMutableArray array];
        
        gameSchedule = [NSMutableArray array];
        oocGame0 = nil;
        oocGame4 = nil;
        oocGame9 = nil;
        gameWinsAgainst = [NSMutableArray array];
        gameWLSchedule = [NSMutableArray array];
        confChampion = @"";
        semifinalWL = @"";
        natlChampWL = @"";
        
        teamPoints = 0;
        teamOppPoints = 0;
        teamYards = 0;
        teamOppYards = 0;
        teamPassYards = 0;
        teamRushYards = 0;
        teamOppPassYards = 0;
        teamOppRushYards = 0;
        teamTODiff = 0;
        
        NSArray *lines = [loadStr componentsSeparatedByString:@"%"];
        NSArray *teamInfo = [lines[0] componentsSeparatedByString:@","];
        if (teamInfo.count == 9) {
            conference = teamInfo[0];
            name = teamInfo[1];
            abbreviation = teamInfo[2];
            teamPrestige = [teamInfo[3] intValue];
            totalWins = [teamInfo[4] intValue];
            totalLosses = [teamInfo[5] intValue];
            totalCCs = [teamInfo[6] intValue];
            totalNCs = [teamInfo[7] intValue];
            rivalTeam = teamInfo[8];
        }
        
        for (int i = 1; i < lines.count; ++i) {
            [self recruitPlayerCSV: lines[i]];
        }
        
        wonRivalryGame = false;
        _offensiveStrategy = [[TeamStrategy alloc] init];
        _defensiveStrategy = [[TeamStrategy alloc] init];
        numberOfRecruits = 30;
        
    }
    return self;
}*/

-(void)updateTalentRatings {
    teamOffTalent = [self getOffensiveTalent];
    teamDefTalent = [self getDefensiveTalent];
    teamPollScore = teamPrestige + [self getOffensiveTalent] + [self getDefensiveTalent];
}

-(void)advanceSeason {
    
    if (wonRivalryGame && (teamPrestige - [league findTeam:rivalTeam].teamPrestige < 20) ) {
        teamPrestige += 2;
    } else if (!wonRivalryGame && ([league findTeam:rivalTeam].teamPrestige - teamPrestige < 20 || [name isEqualToString:@"American Samoa"])) {
        teamPrestige -= 2;
    }
    
    int expectedPollFinish = 100 - teamPrestige;
    int diffExpected = expectedPollFinish - rankTeamPollScore;
    int oldPrestige = teamPrestige;
    
    if ((teamPrestige > 45 && ![name isEqualToString:@"American Samoa"]) || diffExpected > 0 ) {
        teamPrestige = (int)pow(teamPrestige, 1 + (float)diffExpected/1500);// + diffExpected/2500);
    }
    
    if (rankTeamPollScore == 1 ) {
        // NCW
        teamPrestige += 3;
    }
    
    if (teamPrestige > 95) teamPrestige = 95;
    if (teamPrestige < 45 && ![name isEqualToString:@"American Samoa"]) teamPrestige = 45;
    
    diffPrestige = teamPrestige - oldPrestige;
    NSLog(@"ADVANCING SEASON FOR: %@...", abbreviation);
    [self advanceSeasonPlayers];
}

-(NSArray*)graduateSeniorsAndGetTeamNeeds {
    int qbNeeds=0, rbNeeds=0, wrNeeds=0, kNeeds=0, olNeeds=0, sNeeds=0, cbNeeds=0, f7Needs=0;
    
    int i = 0;
    if(teamQBs.count > 0) {
        while (i < teamQBs.count) {
            if ([teamQBs[i] year] == 4) {
                NSLog(@"Graduating senior %@ from %@", [teamQBs[i] name], abbreviation);
                [teamQBs removeObjectAtIndex:i];
                qbNeeds++;
            } else {
                i++;
            }
        }
    } else {
        qbNeeds = 2;
    }
    
    i = 0;
    if (teamRBs.count > 0) {
        while ( i < teamRBs.count ) {
            if ([teamRBs[i] year] == 4 ) {
                NSLog(@"Graduating senior %@ from %@", [teamRBs[i] name], abbreviation);
                [teamRBs removeObjectAtIndex:i];
                rbNeeds++;
            } else {
                i++;
            }
        }
    } else {
        rbNeeds = 4;
    }
    
    i = 0;
    if (teamWRs.count > 0) {
        while ( i < teamWRs.count ) {
            if ([teamWRs[i] year] == 4 ) {
                NSLog(@"Graduating senior %@ from %@", [teamWRs[i] name], abbreviation);
                [teamWRs removeObjectAtIndex:i];
                wrNeeds++;
            } else {
                i++;
            }
        }
    } else {
        wrNeeds = 5;
    }
    
    i = 0;
    if (teamKs.count > 0) {
        while ( i < teamKs.count ) {
            if ([teamKs[i] year] == 4 ) {
                NSLog(@"Graduating senior %@ from %@", [teamKs[i] name], abbreviation);
                [teamKs removeObjectAtIndex:i];
                kNeeds++;
            } else {
                i++;
            }
        }
    } else {
        kNeeds = 2;
    }
    
    i = 0;
    if (teamOLs.count > 0) {
        while ( i < teamOLs.count ) {
            if ([teamOLs[i] year] == 4 ) {
                NSLog(@"Graduating senior %@ from %@", [teamOLs[i] name], abbreviation);
                [teamOLs removeObjectAtIndex:i];
                olNeeds++;
            } else {
                i++;
            }
        }
    } else {
        olNeeds = 7;
    }
    
    i = 0;
    if (teamSs.count > 0) {
        while ( i < teamSs.count) {
            if ([teamSs[i] year] == 4 ) {
                NSLog(@"Graduating senior %@ from %@", [teamSs[i] name], abbreviation);
                [teamSs removeObjectAtIndex:i];
                sNeeds++;
            } else {
                i++;
            }
        }
    } else {
        sNeeds = 2;
    }
    
    i = 0;
    if (teamCBs.count > 0) {
        while ( i < teamCBs.count ) {
            if ([teamCBs[i] year] == 4 ) {
                NSLog(@"Graduating senior %@ from %@", [teamCBs[i] name], abbreviation);
                [teamCBs removeObjectAtIndex:i];
                cbNeeds++;
            } else {
                i++;
            }
        }
    } else {
        cbNeeds = 5;
    }
    
    i = 0;
    if (teamF7s.count > 0) {
        while ( i < teamF7s.count ) {
            if ([teamF7s[i] year] == 4 ) {
                NSLog(@"Graduating senior %@ from %@", [teamF7s[i] name], abbreviation);
                [teamF7s removeObjectAtIndex:i];
                f7Needs++;
            } else {
                i++;
            }
        }
    } else {
        f7Needs = 10;
    }
    
    return @[@(qbNeeds), @(rbNeeds), @(wrNeeds), @(kNeeds), @(olNeeds), @(sNeeds), @(cbNeeds), @(f7Needs)];
}

-(void)advanceSeasonPlayers {
    int qbNeeds=0, rbNeeds=0, wrNeeds=0, kNeeds=0, olNeeds=0, sNeeds=0, cbNeeds=0, f7Needs=0;
    
    int i = 0;
    if (teamQBs.count > 0) {
        while (i < teamQBs.count) {
            if ([teamQBs[i] year] == 4) {
                NSLog(@"Graduating senior %@ from %@", [teamQBs[i] name], abbreviation);
                [teamQBs removeObjectAtIndex:i];
                qbNeeds++;
            } else {
                [teamQBs[i] advanceSeason];
                i++;
            }
        }
    } else {
        qbNeeds = 2;
    }
    
    i = 0;
    if (teamRBs.count > 0) {
        while ( i < teamRBs.count ) {
            if ([teamRBs[i] year] == 4 ) {
                NSLog(@"Graduating senior %@ from %@", [teamRBs[i] name], abbreviation);
                [teamRBs removeObjectAtIndex:i];
                rbNeeds++;
            } else {
                [teamRBs[i] advanceSeason];
                i++;
            }
        }
    } else {
        rbNeeds = 4;
    }
    
    i = 0;
    if (teamWRs.count > 0) {
        while ( i < teamWRs.count ) {
            if ([teamWRs[i] year] == 4 ) {
                NSLog(@"Graduating senior %@ from %@", [teamWRs[i] name], abbreviation);
                [teamWRs removeObjectAtIndex:i];
                wrNeeds++;
            } else {
                [teamWRs[i] advanceSeason];
                i++;
            }
        }
    } else {
        wrNeeds = 5;
    }
    
    i = 0;
    if (teamKs.count > 0) {
        while ( i < teamKs.count ) {
            if ([teamKs[i] year] == 4 ) {
                NSLog(@"Graduating senior %@ from %@", [teamKs[i] name], abbreviation);
                [teamKs removeObjectAtIndex:i];
                kNeeds++;
            } else {
                [teamKs[i] advanceSeason];
                i++;
            }
        }
    } else {
        kNeeds = 2;
    }
    
    i = 0;
    if (teamOLs.count > 0) {
        while ( i < teamOLs.count ) {
            if ([teamOLs[i] year] == 4 ) {
                NSLog(@"Graduating senior %@ from %@", [teamOLs[i] name], abbreviation);
                [teamOLs removeObjectAtIndex:i];
                olNeeds++;
            } else {
                [teamOLs[i] advanceSeason];
                i++;
            }
        }
    } else {
        olNeeds = 7;
    }
    
    i = 0;
    if (teamSs.count > 0) {
        while ( i < teamSs.count) {
            if ([teamSs[i] year] == 4 ) {
                NSLog(@"Graduating senior %@ from %@", [teamSs[i] name], abbreviation);
                [teamSs removeObjectAtIndex:i];
                sNeeds++;
            } else {
                [teamSs[i] advanceSeason];
                i++;
            }
        }
    } else {
        sNeeds = 2;
    }
    
    i = 0;
    if (teamCBs.count > 0) {
        while ( i < teamCBs.count ) {
            if ([teamCBs[i] year] == 4 ) {
                NSLog(@"Graduating senior %@ from %@", [teamCBs[i] name], abbreviation);
                [teamCBs removeObjectAtIndex:i];
                cbNeeds++;
            } else {
                [teamCBs[i] advanceSeason];
                i++;
            }
        }
    } else {
        cbNeeds = 5;
    }
    
    i = 0;
    if (teamF7s.count > 0) {
        while ( i < teamF7s.count ) {
            if ([teamF7s[i] year] == 4 ) {
                NSLog(@"Graduating senior %@ from %@", [teamF7s[i] name], abbreviation);
                [teamF7s removeObjectAtIndex:i];
                f7Needs++;
            } else {
                [teamF7s[i] advanceSeason];
                i++;
            }
        }
    } else {
        f7Needs = 10;
    }
    
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
    int chance = 20 - (teamPrestige - 20*( teamPrestige/20 )); //between 0 and 20
    
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
             [teamCBs addObject:[PlayerCB newCBWithName:[league getRandName] year:(int)(4* [HBSharedUtils randomValue] + 1) stars:(stars - 1)]];
            //teamCBs.add( new PlayerCB(league.getRandName(), (int)(4*Math.random() + 1), stars-1) );
        } else {
            [teamCBs addObject:[PlayerCB newCBWithName:[league getRandName] year:(int)(4* [HBSharedUtils randomValue] + 1) stars:(stars)]];
            //teamCBs.add( new PlayerCB(league.getRandName(), (int)(4*Math.random() + 1), stars) );
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
            [teamSs addObject:[PlayerS newSWithName:[league getRandName] year:(int)(4* [HBSharedUtils randomValue] + 1) stars:(stars - 1)]];
        } else {
            [teamSs addObject:[PlayerS newSWithName:[league getRandName] year:(int)(4* [HBSharedUtils randomValue] + 1) stars:(stars)]];
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
    
    
    int stars = teamPrestige/20 + 1;
    int chance = 20 - (teamPrestige - 20*( teamPrestige/20 )); //between 0 and 20
    
    for( int i = 0; i < qbNeeds; ++i ) {
        //make QBs
        if ((([HBSharedUtils randomValue] * 100)/100) < 5*chance ) {
            [teamQBs addObject:[PlayerQB newQBWithName:[league getRandName] year:1 stars:(stars - 1) team:self]];
        } else {
            [teamQBs addObject:[PlayerQB newQBWithName:[league getRandName] year:1 stars:(stars) team:self]];
        }
    }
    
    for( int i = 0; i < kNeeds; ++i ) {
        //make Ks
        if ((([HBSharedUtils randomValue] * 100)/100) < 5*chance ) {
            [teamKs addObject:[PlayerK newKWithName:[league getRandName] year:1 stars:(stars - 1) team:self]];
        } else {
            [teamKs addObject:[PlayerK newKWithName:[league getRandName] year:1 stars:(stars) team:self]];
        }
    }
    
    for( int i = 0; i < rbNeeds; ++i ) {
        //make RBs
        if ((([HBSharedUtils randomValue] * 100)/100) < 5*chance ) {
            [teamRBs addObject:[PlayerRB newRBWithName:[league getRandName] year:1 stars:(stars - 1) team:self]];
        } else {
            [teamRBs addObject:[PlayerRB newRBWithName:[league getRandName] year:1 stars:(stars) team:self]];
        }
    }
    
    for( int i = 0; i < wrNeeds; ++i ) {
        //make WRs
        if ((([HBSharedUtils randomValue] * 100)/100) < 5*chance ) {
            [teamWRs addObject:[PlayerWR newWRWithName:[league getRandName] year:1 stars:(stars - 1) team:self]];
        } else {
            [teamWRs addObject:[PlayerWR newWRWithName:[league getRandName] year:1 stars:(stars) team:self]];
        }
    }
    
    for( int i = 0; i < olNeeds; ++i ) {
        //make OLs
        if ((([HBSharedUtils randomValue] * 100)/100) < 5*chance ) {
            [teamOLs addObject:[PlayerOL newOLWithName:[league getRandName] year:1 stars:(stars - 1) team:self]];
        } else {
            [teamOLs addObject:[PlayerOL newOLWithName:[league getRandName] year:1 stars:(stars) team:self]];
        }
    }
    
    for( int i = 0; i < cbNeeds; ++i ) {
        //make CBs
        if ((([HBSharedUtils randomValue] * 100)/100) < 5*chance ) {
            [teamCBs addObject:[PlayerCB newCBWithName:[league getRandName] year:1 stars:(stars - 1)]];
        } else {
            [teamCBs addObject:[PlayerCB newCBWithName:[league getRandName] year:1 stars:(stars)]];
        }
    }
    
    for( int i = 0; i < f7Needs; ++i ) {
        //make F7s
        if ((([HBSharedUtils randomValue] * 100)/100) < 5*chance ) {
            [teamF7s addObject:[PlayerF7 newF7WithName:[league getRandName] year:1 stars:(stars - 1) team:self]];
        } else {
            [teamF7s addObject:[PlayerF7 newF7WithName:[league getRandName] year:1 stars:(stars) team:self]];
        }
    }
    
    for( int i = 0; i < sNeeds; ++i ) {
        //make Ss
        if ((([HBSharedUtils randomValue] * 100)/100) < 5*chance ) {
            [teamSs addObject:[PlayerS newSWithName:[league getRandName] year:1 stars:(stars - 1)]];
        } else {
            [teamSs addObject:[PlayerS newSWithName:[league getRandName] year:1 stars:(stars)]];
        }
    }
    
    //done making players, sort them
    [self sortPlayers];

}

-(void)recruitWalkOns {
    int needs = 2 - [NSNumber numberWithInteger:teamQBs.count].intValue;
    for( int i = 0; i < needs; ++i ) {
        //make QBs
        //teamQBs.add( new PlayerQB(league.getRandName(), 1, 2, this) );
        [teamQBs addObject:[PlayerQB newQBWithName:[league getRandName] year:1 stars:2 team:self]];
    }
    
    needs = 4 - [NSNumber numberWithInteger:teamRBs.count].intValue;
    for( int i = 0; i < needs; ++i ) {
        //make RBs
        [teamRBs addObject:[PlayerRB newRBWithName:[league getRandName] year:1 stars:2 team:self]];
    }
    
    needs = 6 - [NSNumber numberWithInteger:teamWRs.count].intValue;
    for( int i = 0; i < needs; ++i ) {
        //make WRs
        [teamWRs addObject:[PlayerWR newWRWithName:[league getRandName] year:1 stars:2 team:self]];
    }
    
    needs = 10 - [NSNumber numberWithInteger:teamOLs.count].intValue;
    for( int i = 0; i < needs; ++i ) {
        //make OLs
        [teamOLs addObject:[PlayerOL newOLWithName:[league getRandName] year:1 stars:2 team:self]];
    }
    
    needs = 2 - [NSNumber numberWithInteger:teamKs.count].intValue;
    for( int i = 0; i < needs; ++i ) {
        //make Ks
        [teamKs addObject:[PlayerK newKWithName:[league getRandName] year:1 stars:2 team:self]];
    }
    
    needs = 2 - [NSNumber numberWithInteger:teamSs.count].intValue;
    for( int i = 0; i < needs; ++i ) {
        //make Ss
        [teamSs addObject:[PlayerS newSWithName:[league getRandName] year:1 stars:2]];
    }
    
    needs = 6 - [NSNumber numberWithInteger:teamCBs.count].intValue;
    for( int i = 0; i < needs; ++i ) {
        //make CBs
        [teamCBs addObject:[PlayerCB newCBWithName:[league getRandName] year:1 stars:2]];
    }
    
    needs = 14 - [NSNumber numberWithInteger:teamF7s.count].intValue;
    for( int i = 0; i < needs; ++i ) {
        //make F7s
        [teamF7s addObject:[PlayerF7 newF7WithName:[league getRandName] year:1 stars:2 team:self]];
    }
    
    //done making players, sort them
    [self sortPlayers];
}

-(void)recruitPlayersFromString:(NSString *)playerStr {
    NSArray *players = [playerStr componentsSeparatedByString:@"\n"];
    for (NSString *p in players) {
        [self recruitPlayerCSV:p];
    }
}

-(void)recruitPlayerCSV:(NSString*)line {
    
}

-(void)resetStats {
    gameSchedule = [NSMutableArray array];
    oocGame0 = nil;
    oocGame4 = nil;
    oocGame9 = nil;
    gameWinsAgainst = [NSMutableArray array];
    gameWLSchedule = [NSMutableArray array];
    confChampion = @"";
    semifinalWL = @"";
    natlChampWL = @"";
    wins = 0;
    losses = 0;
    
    teamPoints = 0;
    teamOppPoints = 0;
    teamYards = 0;
    teamOppYards = 0;
    teamPassYards = 0;
    teamRushYards = 0;
    teamOppPassYards = 0;
    teamOppRushYards = 0;
    teamTODiff = 0;
    diffOffTalent = [self getOffensiveTalent] - teamOffTalent;
    teamOffTalent = [self getOffensiveTalent];
    diffDefTalent = [self getDefensiveTalent] - teamDefTalent;
    teamDefTalent = [self getDefensiveTalent];
    teamPollScore = teamPrestige + [self getOffensiveTalent] + [self getDefensiveTalent];
}

-(void)updatePollScore {
    [self updateStrengthOfWins];
    int preseasonBias = 8 - (wins + losses);
    if (preseasonBias < 0) preseasonBias = 0;
    teamPollScore = (wins*200 + 3*(teamPoints-teamOppPoints) + (teamYards-teamOppYards)/40 + 3*(preseasonBias)*(teamPrestige + [self getOffensiveTalent] + [self getDefensiveTalent]) + teamStrengthOfWins)/10;
    if ([@"CC" isEqualToString:confChampion] ) {
        //bonus for winning conference
        teamPollScore += 50;
    }
    if ( [@"NCW" isEqualToString:natlChampWL] ) {
        //bonus for winning champ game
        teamPollScore += 100;
    }
    if (losses == 0 ) {
        teamPollScore += 30;
    } else if ( losses == 1 ) {
        teamPollScore += 15;
    } else {
        teamPollScore += 0;
    }
}

-(void)updateTeamHistory {
    if (rankTeamPollScore > 0 && rankTeamPollScore < 26) {
        [teamHistory addObject:[NSString stringWithFormat:@"#%ld %@ (%ld-%ld) %@ %@ %@",(long)rankTeamPollScore, abbreviation, (long)wins, (long)losses, confChampion, semifinalWL, natlChampWL]];
    } else {
        [teamHistory addObject:[NSString stringWithFormat:@"%@ (%ld-%ld) %@ %@ %@", abbreviation, (long)wins, (long)losses, confChampion, semifinalWL, natlChampWL]];
    }
}

-(NSString*)getTeamHistoryString {
    NSString *teamHistoryString = @"";
    for (int i = 0; i < teamHistory.count; ++i) {
        teamHistoryString = [[teamHistoryString stringByAppendingString:teamHistory[i]] stringByAppendingString:@"\n"];
    }
    
    NSString *hist = @"";
    hist = [NSString stringWithFormat:@"Overall W-L: %ld-%ld\nConference Championships: %ld\nNational Championships: %ld\n\nYear by year summary:\n%@", (long)totalWins, (long)totalLosses, (long)totalCCs, (long)totalNCs, teamHistoryString];
    
    return hist;
}

-(void)updateStrengthOfWins {
    int strWins = 0;
    for ( int i = 0; i < 12; ++i ) {
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
        return a.ratOvr > b.ratOvr ? -1 : a.ratOvr == b.ratOvr ? 0 : 1;
    }];
    [teamRBs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Player *a = (Player*)obj1;
        Player *b = (Player*)obj2;
        return a.ratOvr > b.ratOvr ? -1 : a.ratOvr == b.ratOvr ? 0 : 1;
    }];
    [teamWRs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Player *a = (Player*)obj1;
        Player *b = (Player*)obj2;
        return a.ratOvr > b.ratOvr ? -1 : a.ratOvr == b.ratOvr ? 0 : 1;
    }];
    [teamKs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Player *a = (Player*)obj1;
        Player *b = (Player*)obj2;
        return a.ratOvr > b.ratOvr ? -1 : a.ratOvr == b.ratOvr ? 0 : 1;
    }];
    [teamOLs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Player *a = (Player*)obj1;
        Player *b = (Player*)obj2;
        return a.ratOvr > b.ratOvr ? -1 : a.ratOvr == b.ratOvr ? 0 : 1;
    }];
    
    [teamCBs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Player *a = (Player*)obj1;
        Player *b = (Player*)obj2;
        return a.ratOvr > b.ratOvr ? -1 : a.ratOvr == b.ratOvr ? 0 : 1;
    }];
    [teamSs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Player *a = (Player*)obj1;
        Player *b = (Player*)obj2;
        return a.ratOvr > b.ratOvr ? -1 : a.ratOvr == b.ratOvr ? 0 : 1;
    }];
    [teamF7s sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Player *a = (Player*)obj1;
        Player *b = (Player*)obj2;
        return a.ratOvr > b.ratOvr ? -1 : a.ratOvr == b.ratOvr ? 0 : 1;
    }];
}

-(int)getOffensiveTalent {
    return ([self getQB:0].ratOvr*5 +
            [self getWR:0].ratOvr + [self getWR:1].ratOvr + [self getWR:2].ratOvr +
            [self getRB:0].ratOvr + [self getRB:1].ratOvr +
            [self getCompositeOLPass] + [self getCompositeOLRush] ) / 12;
}

-(int)getDefensiveTalent {
    return ( [self getRushDef] + [self getPassDef] ) / 2;
}

-(PlayerQB*)getQB:(int)depth {
    if ( depth < teamQBs.count && depth >= 0 ) {
        return teamQBs[depth];
    } else {
        return teamQBs[0];
    }
}

-(PlayerRB*)getRB:(int)depth {
    if ( depth < teamRBs.count && depth >= 0 ) {
        return teamRBs[depth];
    } else {
        return teamRBs[0];
    }
}

-(PlayerWR*)getWR:(int)depth {
    if ( depth < teamWRs.count && depth >= 0 ) {
        return teamWRs[depth];
    } else {
        return teamWRs[0];
    }
}

-(PlayerK*)getK:(int)depth {
    if ( depth < teamKs.count && depth >= 0 ) {
        return teamKs[depth];
    } else {
        return teamKs[0];
    }
}

-(PlayerOL*)getOL:(int)depth {
    if ( depth < teamOLs.count && depth >= 0 ) {
        return teamOLs[depth];
    } else {
        return teamOLs[0];
    }
}

-(PlayerS*)getS:(int)depth {
    if ( depth < teamSs.count && depth >= 0 ) {
        return teamSs[depth];
    } else {
        return teamSs[0];
    }
}

-(PlayerCB*)getCB:(int)depth {
    if ( depth < teamCBs.count && depth >= 0 ) {
        return teamCBs[depth];
    } else {
        return teamCBs[0];
    }
}

-(PlayerF7*)getF7:(int)depth {
    if ( depth < teamF7s.count && depth >= 0 ) {
        return teamF7s[depth];
    } else {
        return teamF7s[0];
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
    for ( int i = 0; i < 5; ++i ) {
        compositeOL += (teamOLs[i].ratOLPow + teamOLs[i].ratOLBkP)/2;
    }
    return compositeOL / 5;
}

-(int)getCompositeOLRush {
    int compositeOL = 0;
    for ( int i = 0; i < 5; ++i ) {
        compositeOL += (teamOLs[i].ratOLPow + teamOLs[i].ratOLBkR)/2;
    }
    return compositeOL / 5;
}

-(int)getCompositeF7Pass {
    int compositeF7 = 0;
    for ( int i = 0; i < 7; ++i ) {
        compositeF7 += (teamF7s[i].ratF7Pow + teamF7s[i].ratF7Pas)/2;
    }
    return compositeF7 / 7;
}

-(int)getCompositeF7Rush {
    int compositeF7 = 0;
    for ( int i = 0; i < 7; ++i ) {
        compositeF7 += (teamF7s[i].ratF7Pow + teamF7s[i].ratF7Rsh)/2;
    }
    return compositeF7 / 7;
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
    
    [ts0 addObject:@[[NSString stringWithFormat:@"%d pts/gm",(teamOppPoints/[self numGames])], @"Opponent Points Per Game",[self getRankString:rankTeamOppPoints]]];
    
    //[ts0 appendFormat:@"%ld,",(long)(teamYards/[self numGames])];
    //[ts0 appendString:@"Yards,"];
    //[ts0 appendFormat:@"%@\n",[self getRankString:rankTeamYards]];
    
    [ts0 addObject:@[[NSString stringWithFormat:@"%d yds/gm",(teamYards/[self numGames])], @"Yards Per Game",[self getRankString:rankTeamYards]]];
    
    //[ts0 appendFormat:@"%ld,",(long)(teamOppYards/[self numGames])];
    //[ts0 appendString:@"Opp Yards,"];
    //[ts0 appendFormat:@"%@\n",[self getRankString:rankTeamOppYards]];
    
    [ts0 addObject:@[[NSString stringWithFormat:@"%d yds/gm",(teamOppYards/[self numGames])], @"Opp Yards Per Game",[self getRankString:rankTeamYards]]];
    
    //[ts0 appendFormat:@"%ld,",(long)(teamPassYards/[self numGames])];
    //[ts0 appendString:@"Pass Yards,"];
    //[ts0 appendFormat:@"%@\n",[self getRankString:rankTeamPassYards]];
    
    [ts0 addObject:@[[NSString stringWithFormat:@"%d yds/gm",(teamPassYards/[self numGames])], @"Pass Yards Per Game",[self getRankString:rankTeamPassYards]]];
    
    //[ts0 appendFormat:@"%ld,",(long)(teamRushYards/[self numGames])];
    //[ts0 appendString:@"Rush Yards,"];
    //[ts0 appendFormat:@"%@\n",[self getRankString:rankTeamRushYards]];
    
    [ts0 addObject:@[[NSString stringWithFormat:@"%d yds/gm",(teamRushYards/[self numGames])], @"Rush Yards Per Game",[self getRankString:rankTeamRushYards]]];
    
    //[ts0 appendFormat:@"%ld,",(long)(teamOppPassYards/[self numGames])];
    //[ts0 appendString:@"Opp Pass YPG,"];
    //[ts0 appendFormat:@"%@\n",[self getRankString:rankTeamOppPassYards]];
    
    [ts0 addObject:@[[NSString stringWithFormat:@"%d yds/gm",(teamOppPassYards/[self numGames])], @"Opp Pass Yards Per Game",[self getRankString:rankTeamOppPassYards]]];
    
    //[ts0 appendFormat:@"%ld,",(long)(teamOppRushYards/[self numGames])];
    //[ts0 appendString:@"Opp Rush YPG,"];
    //[ts0 appendFormat:@"%@\n",[self getRankString:rankTeamOppRushYards]];
    
    [ts0 addObject:@[[NSString stringWithFormat:@"%d yds/gm",(teamOppRushYards/[self numGames])], @"Opp Rush Yards Per Game",[self getRankString:rankTeamOppRushYards]]];
    
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


-(NSString*)getTeamStatsStringCSV {
    NSMutableString *ts0 = [NSMutableString string];;
    
    [ts0 appendFormat:@"%ld,",(long)teamPollScore];
    [ts0 appendString:@"AP Votes,"];
    [ts0 appendFormat:@"%@\n",[self getRankString:rankTeamPollScore]];
    
    [ts0 appendFormat:@"%ld,",(long)teamStrengthOfWins];
    [ts0 appendString:@"SOS,"];
    [ts0 appendFormat:@"%@\n",[self getRankString:rankTeamStrengthOfWins]];
    
    [ts0 appendFormat:@"%ld,",(long)(teamPoints/[self numGames])];
    [ts0 appendString:@"Points,"];
    [ts0 appendFormat:@"%@\n",[self getRankString:rankTeamPoints]];
    
    [ts0 appendFormat:@"%ld,",(long)(teamOppPoints/[self numGames])];
    [ts0 appendString:@"Opp Points,"];
    [ts0 appendFormat:@"%@\n",[self getRankString:teamOppPoints]];
    
    [ts0 appendFormat:@"%ld,",(long)(teamYards/[self numGames])];
    [ts0 appendString:@"Yards,"];
    [ts0 appendFormat:@"%@\n",[self getRankString:rankTeamYards]];
    
    [ts0 appendFormat:@"%ld,",(long)(teamOppYards/[self numGames])];
    [ts0 appendString:@"Opp Yards,"];
    [ts0 appendFormat:@"%@\n",[self getRankString:rankTeamOppYards]];
    
    [ts0 appendFormat:@"%ld,",(long)(teamPassYards/[self numGames])];
    [ts0 appendString:@"Pass Yards,"];
    [ts0 appendFormat:@"%@\n",[self getRankString:rankTeamPassYards]];
    
    [ts0 appendFormat:@"%ld,",(long)(teamRushYards/[self numGames])];
    [ts0 appendString:@"Rush Yards,"];
    [ts0 appendFormat:@"%@\n",[self getRankString:rankTeamRushYards]];
    
    [ts0 appendFormat:@"%ld,",(long)(teamOppPassYards/[self numGames])];
    [ts0 appendString:@"Opp Pass YPG,"];
    [ts0 appendFormat:@"%@\n",[self getRankString:rankTeamOppPassYards]];
    
    [ts0 appendFormat:@"%ld,",(long)(teamOppRushYards/[self numGames])];
    [ts0 appendString:@"Opp Rush YPG,"];
    [ts0 appendFormat:@"%@\n",[self getRankString:rankTeamOppRushYards]];
    
    if (teamTODiff > 0) {
        [ts0 appendFormat:@"+%ld,",(long)teamTODiff];
    } else if (teamTODiff == 0) {
        [ts0 appendString:@"0,"];
    } else {
        [ts0 appendFormat:@"%ld,",(long)teamTODiff];
    }
    [ts0 appendString:@"TO Diff,"];
    [ts0 appendFormat:@"%@\n",[self getRankString:rankTeamTODiff]];
    
    [ts0 appendFormat:@"%ld,",(long)teamOffTalent];
    [ts0 appendString:@"Off Talent,"];
    [ts0 appendFormat:@"%@\n",[self getRankString:rankTeamOffTalent]];
    
    [ts0 appendFormat:@"%ld,",(long)teamDefTalent];
    [ts0 appendString:@"Def Talent,"];
    [ts0 appendFormat:@"%@\n",[self getRankString:rankTeamDefTalent]];
    
    [ts0 appendFormat:@"%ld,",(long)teamPrestige];
    [ts0 appendString:@"Prestige,"];
    [ts0 appendFormat:@"%@\n",[self getRankString:rankTeamPrestige]];
    
    return [ts0 copy];;
}

-(NSString*)getSeasonSummaryString {
    NSMutableString *summary = [NSMutableString stringWithFormat:@"Your team, %@, finished the season ranked #%d with %d wins and %d losses.",name, rankTeamPollScore, wins, losses];
    int expectedPollFinish = 100 - teamPrestige;
    int diffExpected = expectedPollFinish - rankTeamPollScore;
    int oldPrestige = teamPrestige;
    int newPrestige = oldPrestige;
    if (teamPrestige > 45 || diffExpected > 0 ) {
        newPrestige = (int)pow(teamPrestige, 1 + (float)diffExpected/1500);// + diffExpected/2500);
    }
    
    if ([natlChampWL isEqualToString:@"NCW"]) {
            [summary appendString:@"\n\nYou won the National Championship! Recruits want to play for winners and you have proved that you are one. You gain +3 prestige!"];
    }
    
    if ((newPrestige - oldPrestige) > 0) {
        [summary appendFormat:@"\n\nGreat job, coach! You exceeded expectations and gained %ld prestige! This will help your recruiting.", (long)(newPrestige - oldPrestige)];
    } else if ((newPrestige - oldPrestige) < 0) {
        [summary appendFormat:@"\n\nA bit of a down year, coach? You fell short expectations and lost %ld prestige. This will hurt your recruiting.",(long)(oldPrestige - newPrestige) ];
    } else {
        [summary appendString:@"\n\nWell, your team performed exactly how many expected. This won't hurt or help recruiting, but try to improve next year!"];
    }
    
    if (wonRivalryGame && (teamPrestige - [league findTeam:rivalTeam].teamPrestige < 20) ) {
        [summary appendString:@"\n\nFuture recruits were impressed that you won your rivalry game. You gained 2 prestige."];
    } else if (!wonRivalryGame && ([league findTeam:rivalTeam].teamPrestige - teamPrestige < 20 || [name isEqualToString:@"American Samoa"])) {
        [summary appendString:@"\n\nSince you couldn't win your rivalry game, recruits aren't excited to attend your school. You lost 2 prestige."];
    } else if (wonRivalryGame) {
        [summary appendString:@"\n\nGood job winning your rivalry game, but it was expected given the state of their program. You gain no prestige for this."];
    }else {
        [summary appendString:@"\n\nYou lost your rivalry game, but this was expected given your rebuilding program. You lost no prestige for this."];
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

-(int)getConfWins {
    int confWins = 0;
    Game *g;
    for (int i = 0; i < gameWLSchedule.count; ++i) {
        g = gameSchedule[i];
        if ( [g.gameName isEqualToString:@"In Conf" ] || [g.gameName isEqualToString:@"Rivalry Game"] ) {
            // in conference game, see if was won
            if ( [g.homeTeam isEqual: self] && g.homeScore > g.awayScore ) {
                confWins++;
            } else if ( [g.awayTeam isEqual: self] && g.homeScore < g.awayScore ) {
                confWins++;
            }
        }
    }
    return confWins;
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
    int i = wins + losses - 1;
    Game *g = gameSchedule[i];
    NSString *gameSummary = [NSString stringWithFormat:@"%@ %@",gameWLSchedule[i],[self gameSummaryString:g]];
    NSString *rivalryGameStr = @"";
    if ([g.gameName isEqualToString:@"Rivalry Game"]) {
        if ( [gameWLSchedule[i] isEqualToString:@"W"] ) rivalryGameStr = @"Won against Rival! ";
        else rivalryGameStr = @"Lost against Rival! ";
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

-(NSString*)getGraduatingPlayersString {
    NSMutableString *sb = [NSMutableString string];
    
    for ( PlayerQB *p in teamQBs ) {
        if (p.year == 4) {
            [sb appendFormat:@"%@\n",p.getPosNameYrOvrPot_OneLine];
        }
    }
    for ( PlayerRB *p in teamRBs ) {
        if (p.year == 4) {
            [sb appendFormat:@"%@\n",p.getPosNameYrOvrPot_OneLine];
        }
    }
    for ( PlayerWR *p in teamWRs ) {
        if (p.year == 4) {
            [sb appendFormat:@"%@\n",p.getPosNameYrOvrPot_OneLine];
        }
    }
    for ( PlayerOL *p in teamOLs ) {
        if (p.year == 4) {
            [sb appendFormat:@"%@\n",p.getPosNameYrOvrPot_OneLine];
        }
    }
    for ( PlayerK *p in teamKs ) {
        if (p.year == 4) {
            [sb appendFormat:@"%@\n",p.getPosNameYrOvrPot_OneLine];
        }
    }
    for ( PlayerS *p in teamSs ) {
        if (p.year == 4) {
            [sb appendFormat:@"%@\n",p.getPosNameYrOvrPot_OneLine];
        }
    }
    for ( PlayerCB *p in teamCBs) {
        if (p.year == 4) {
            [sb appendFormat:@"%@\n",p.getPosNameYrOvrPot_OneLine];
        }
    }
    for ( PlayerF7 *p in teamF7s ) {
        if (p.year == 4) {
            [sb appendFormat:@"%@\n",p.getPosNameYrOvrPot_OneLine];
        }
    }
    return [sb copy];
}

-(NSArray*)getQBRecruits {
    NSMutableArray* recruits = [NSMutableArray array];
    int stars;
    for (int i = 0; i < numberOfRecruits; ++i) {
        stars = (int)(5*(float)(numberOfRecruits - i/2)/numberOfRecruits);
        recruits[i] = [PlayerQB newQBWithName:[league getRandName] year:1 stars:stars team:nil];
    }
    [recruits sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Player *a = (Player*)obj1;
        Player *b = (Player*)obj2;
        return a.ratOvr > b.ratOvr ? -1 : a.ratOvr == b.ratOvr ? 0 : 1;
    }];
    return recruits;

}

-(NSArray*)getRBRecruits {
    int numRBrecruits = 2*numberOfRecruits;
    NSMutableArray* recruits = [NSMutableArray array];
    int stars;
    for (int i = 0; i < numRBrecruits; ++i) {
        stars = (int)(5*(float)(numRBrecruits - i/2)/numRBrecruits);
        recruits[i] = [PlayerRB newRBWithName:[league getRandName] year:1 stars:stars team:nil];
    }
    
    [recruits sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Player *a = (Player*)obj1;
        Player *b = (Player*)obj2;
        return a.ratOvr > b.ratOvr ? -1 : a.ratOvr == b.ratOvr ? 0 : 1;
    }];
    return recruits;
}

-(NSArray*)getWRRecruits {
    int numWRrecruits = 2*numberOfRecruits;
    NSMutableArray* recruits = [NSMutableArray array];
    int stars;
    for (int i = 0; i < numWRrecruits; ++i) {
        stars = (int)(5*(float)(numWRrecruits - i/2)/numWRrecruits);
        recruits[i] = [PlayerWR newWRWithName:[league getRandName] year:1 stars:stars team:nil];
    }
    
    [recruits sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Player *a = (Player*)obj1;
        Player *b = (Player*)obj2;
        return a.ratOvr > b.ratOvr ? -1 : a.ratOvr == b.ratOvr ? 0 : 1;
    }];
    return recruits;
}

-(NSArray*)getKRecruits {
    NSMutableArray* recruits = [NSMutableArray array];
    int stars;
    for (int i = 0; i < numberOfRecruits; ++i) {
        stars = (int)(5*(float)(numberOfRecruits - i/2)/numberOfRecruits);
        recruits[i] = [PlayerK newKWithName:[league getRandName] year:1 stars:stars team:nil];
    }
    [recruits sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Player *a = (Player*)obj1;
        Player *b = (Player*)obj2;
        return a.ratOvr > b.ratOvr ? -1 : a.ratOvr == b.ratOvr ? 0 : 1;
    }];
    return recruits;
}

-(NSArray*)getOLRecruits {
    int numOLrecruits = 3*numberOfRecruits;
    NSMutableArray* recruits = [NSMutableArray array];
    int stars;
    for (int i = 0; i < numOLrecruits; ++i) {
        stars = (int)(5*(float)(numOLrecruits - i/2)/numOLrecruits);
        recruits[i] = [PlayerOL newOLWithName:[league getRandName] year:1 stars:stars team:nil];
    }
    
    [recruits sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Player *a = (Player*)obj1;
        Player *b = (Player*)obj2;
        return a.ratOvr > b.ratOvr ? -1 : a.ratOvr == b.ratOvr ? 0 : 1;
    }];
    return recruits;
}


-(NSArray*)getSRecruits {
    NSMutableArray* recruits = [NSMutableArray array];
    int stars;
    for (int i = 0; i < numberOfRecruits; ++i) {
        stars = (int)(5*(float)(numberOfRecruits - i/2)/numberOfRecruits);
        recruits[i] = [PlayerS newSWithName:[league getRandName] year:1 stars:stars];
    }
    [recruits sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Player *a = (Player*)obj1;
        Player *b = (Player*)obj2;
        return a.ratOvr > b.ratOvr ? -1 : a.ratOvr == b.ratOvr ? 0 : 1;
    }];
    return recruits;
}


-(NSArray*)getCBRecruits {
    int numCBrecruits = 2*numberOfRecruits;
    NSMutableArray* recruits = [NSMutableArray array];
    int stars;
    for (int i = 0; i < numCBrecruits; ++i) {
        stars = (int)(5*(float)(numCBrecruits - i/2)/numCBrecruits);
        recruits[i] = [PlayerCB newCBWithName:[league getRandName] year:1 stars:stars];
    }
    
    [recruits sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Player *a = (Player*)obj1;
        Player *b = (Player*)obj2;
        return a.ratOvr > b.ratOvr ? -1 : a.ratOvr == b.ratOvr ? 0 : 1;
    }];
    return recruits;
}

-(NSArray*)getF7Recruits {
    int numF7recruits = 3*numberOfRecruits;
    NSMutableArray* recruits = [NSMutableArray array];
    int stars;
    for (int i = 0; i < numF7recruits; ++i) {
        stars = (int)(5*(float)(numF7recruits - i/2)/numF7recruits);
        recruits[i] = [PlayerF7 newF7WithName:[league getRandName] year:1 stars:stars team:nil];
    }
    
    [recruits sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Player *a = (Player*)obj1;
        Player *b = (Player*)obj2;
        return a.ratOvr > b.ratOvr ? -1 : a.ratOvr == b.ratOvr ? 0 : 1;
    }];
    return recruits;
}

-(NSString *)getRecruitsInfoSaveFile {
    NSMutableString *sb = [NSMutableString string];
    NSArray *qbs = [self getQBRecruits];
    NSArray *rbs = [self getRBRecruits];
    NSArray *wrs = [self getWRRecruits];
    NSArray *ks = [self getKRecruits];
    NSArray *ols = [self getOLRecruits];
    NSArray *cbs = [self getCBRecruits];
    NSArray *f7s = [self getF7Recruits];
    NSArray *ss = [self getSRecruits];
    
    for (PlayerQB *qb in qbs) {
        [sb appendString:[NSString stringWithFormat:@"QB %@,%ld,%ld,%ld,%ld,%ld,%ld,%ld,%ld\n",qb.name,(long)qb.year,(long)qb.ratPot,(long)qb.ratFootIQ,(long)qb.ratPassPow,(long)qb.ratPassAcc,(long)qb.ratPassEva,(long)qb.ratOvr,(long)qb.ratImprovement]];
    }
    for (PlayerRB *rb in rbs) {
        [sb appendString:[NSString stringWithFormat:@"RB %@,%ld,%ld,%ld,%ld,%ld,%ld,%ld,%ld\n",rb.name,(long)rb.year,(long)rb.ratPot,(long)rb.ratFootIQ,(long)rb.ratRushPow,(long)rb.ratRushSpd,(long)rb.ratRushEva,(long)rb.ratOvr,(long)rb.ratImprovement]];
    }
    for (PlayerWR *wr in wrs) {
        [sb appendString:[NSString stringWithFormat:@"WR %@,%ld,%ld,%ld,%ld,%ld,%ld,%ld,%ld\n",wr.name,(long)wr.year,(long)wr.ratPot,(long)wr.ratFootIQ,(long)wr.ratRecCat,(long)wr.ratRecSpd,(long)wr.ratRecEva,(long)wr.ratOvr,(long)wr.ratImprovement]];
    }
    for (PlayerK *k in ks) {
        [sb appendString:[NSString stringWithFormat:@"K %@,%ld,%ld,%ld,%ld,%ld,%ld,%ld,%ld\n",k.name,(long)k.year,(long)k.ratPot,(long)k.ratFootIQ,(long)k.ratKickPow,(long)k.ratKickAcc,(long)k.ratKickFum,(long)k.ratOvr,(long)k.ratImprovement]];
    }
    for (PlayerOL *ol in ols) {
        [sb appendString:[NSString stringWithFormat:@"OL %@,%ld,%ld,%ld,%ld,%ld,%ld,%ld,%ld\n",ol.name,(long)ol.year,(long)ol.ratPot,(long)ol.ratFootIQ,(long)ol.ratOLPow,(long)ol.ratOLBkP,(long)ol.ratOLBkR,(long)ol.ratOvr,(long)ol.ratImprovement]];
    }
    for (PlayerS *s in ss) {
        [sb appendString:[NSString stringWithFormat:@"S %@,%ld,%ld,%ld,%ld,%ld,%ld,%ld,%ld\n",s.name,(long)s.year,(long)s.ratPot,(long)s.ratFootIQ,(long)s.ratSCov,(long)s.ratSSpd,(long)s.ratSTkl,(long)s.ratOvr,(long)s.ratImprovement]];
    }
    for (PlayerCB *cb in cbs) {
        [sb appendString:[NSString stringWithFormat:@"CB %@,%ld,%ld,%ld,%ld,%ld,%ld,%ld,%ld\n",cb.name,(long)cb.year,(long)cb.ratPot,(long)cb.ratFootIQ,(long)cb.ratCBCov,(long)cb.ratCBSpd,(long)cb.ratCBTkl,(long)cb.ratOvr,(long)cb.ratImprovement]];
    }
    for (PlayerF7 *f7 in f7s) {
        [sb appendString:[NSString stringWithFormat:@"F7 %@,%ld,%ld,%ld,%ld,%ld,%ld,%ld,%ld\n",f7.name,(long)f7.year,(long)f7.ratPot,(long)f7.ratFootIQ,(long)f7.ratF7Pow,(long)f7.ratF7Pas,(long)f7.ratF7Rsh,(long)f7.ratOvr,(long)f7.ratImprovement]];
    }
    return [sb copy];
}

-(NSString *)getPlayerInfoSaveFile {
    NSMutableString *sb = [NSMutableString string];
    for (PlayerQB *qb in teamQBs) {
        [sb appendString:[NSString stringWithFormat:@"QB %@,%ld,%ld,%ld,%ld,%ld,%ld,%ld,%ld\n",qb.name,(long)qb.year,(long)qb.ratPot,(long)qb.ratFootIQ,(long)qb.ratPassPow,(long)qb.ratPassAcc,(long)qb.ratPassEva,(long)qb.ratOvr,(long)qb.ratImprovement]];
    }
    for (PlayerRB *rb in teamRBs) {
        [sb appendString:[NSString stringWithFormat:@"RB %@,%ld,%ld,%ld,%ld,%ld,%ld,%ld,%ld\n",rb.name,(long)rb.year,(long)rb.ratPot,(long)rb.ratFootIQ,(long)rb.ratRushPow,(long)rb.ratRushSpd,(long)rb.ratRushEva,(long)rb.ratOvr,(long)rb.ratImprovement]];
    }
    for (PlayerWR *wr in teamWRs) {
        [sb appendString:[NSString stringWithFormat:@"WR %@,%ld,%ld,%ld,%ld,%ld,%ld,%ld,%ld\n",wr.name,(long)wr.year,(long)wr.ratPot,(long)wr.ratFootIQ,(long)wr.ratRecCat,(long)wr.ratRecSpd,(long)wr.ratRecEva,(long)wr.ratOvr,(long)wr.ratImprovement]];
    }
    for (PlayerK *k in teamKs) {
         [sb appendString:[NSString stringWithFormat:@"K %@,%ld,%ld,%ld,%ld,%ld,%ld,%ld,%ld\n",k.name,(long)k.year,(long)k.ratPot,(long)k.ratFootIQ,(long)k.ratKickPow,(long)k.ratKickAcc,(long)k.ratKickFum,(long)k.ratOvr,(long)k.ratImprovement]];
    }
    for (PlayerOL *ol in teamOLs) {
        [sb appendString:[NSString stringWithFormat:@"OL %@,%ld,%ld,%ld,%ld,%ld,%ld,%ld,%ld\n",ol.name,(long)ol.year,(long)ol.ratPot,(long)ol.ratFootIQ,(long)ol.ratOLPow,(long)ol.ratOLBkP,(long)ol.ratOLBkR,(long)ol.ratOvr,(long)ol.ratImprovement]];
    }
    for (PlayerS *s in teamSs) {
        [sb appendString:[NSString stringWithFormat:@"S %@,%ld,%ld,%ld,%ld,%ld,%ld,%ld,%ld\n",s.name,(long)s.year,(long)s.ratPot,(long)s.ratFootIQ,(long)s.ratSCov,(long)s.ratSSpd,(long)s.ratSTkl,(long)s.ratOvr,(long)s.ratImprovement]];
    }
    for (PlayerCB *cb in teamCBs) {
        [sb appendString:[NSString stringWithFormat:@"CB %@,%ld,%ld,%ld,%ld,%ld,%ld,%ld,%ld\n",cb.name,(long)cb.year,(long)cb.ratPot,(long)cb.ratFootIQ,(long)cb.ratCBCov,(long)cb.ratCBSpd,(long)cb.ratCBTkl,(long)cb.ratOvr,(long)cb.ratImprovement]];
    }
    for (PlayerF7 *f7 in teamF7s) {
        [sb appendString:[NSString stringWithFormat:@"F7 %@,%ld,%ld,%ld,%ld,%ld,%ld,%ld,%ld\n",f7.name,(long)f7.year,(long)f7.ratPot,(long)f7.ratFootIQ,(long)f7.ratF7Pow,(long)f7.ratF7Pas,(long)f7.ratF7Rsh,(long)f7.ratOvr,(long)f7.ratImprovement]];
    }
    return [sb copy];
}

-(NSArray*)getOffensiveTeamStrategies {
    return @[
             [TeamStrategy newStrategyWithName:@"Aggressive" description:@"Play a more aggressive offense. Will pass with lower completion percentage and higher chance of interception. However, catches will go for more yards." rYB:-1 rAB:2 pYB:3 pAB:2],
             [TeamStrategy newStrategyWithName:@"No Preference" description:@"Will play a normal offense with no bonus either way, but no penalties either." rYB:0 rAB:0 pYB:0 pAB:0],
             [TeamStrategy newStrategyWithName:@"Conservative" description:@"Play a more conservative offense, running a bit more and passing slightly less. Passes are more accurate but shorter. Rushes are more likely to gain yards but less likely to break free for big plays." rYB:1 rAB:-2 pYB:-3 pAB:-2]
             
             ];
}

-(NSArray*)getDefensiveTeamStrategies {
    return @[
             [TeamStrategy newStrategyWithName:@"Stack the Box" description:@"Focus on stopping the run. Will give up more big passing plays but will allow less rushing yards and far less big plays from rushing." rYB:1 rAB:0 pYB:-1 pAB:-1],
             [TeamStrategy newStrategyWithName:@"No Preference" description:@"Will play a normal defense with no bonus either way, but no penalties either." rYB:0 rAB:0 pYB:0 pAB:0],
             [TeamStrategy newStrategyWithName:@"No Fly Zone" description:@"Focus on stopping the pass. Will give up less yards on catches and will be more likely to intercept passes, but will allow more rushing yards." rYB:-1 rAB:0 pYB:1 pAB:1]
             
             ];
}

- (NSComparisonResult)compare:(id)other
{
    Team *otherTeam = (Team*)other;
    if (self.getConfWins > otherTeam.getConfWins) {
        return -1;
    } else if (self.getConfWins == otherTeam.getConfWins) {
        if ([self.gameWinsAgainst containsObject:otherTeam]) {
            return -1;
        } else if ([otherTeam.gameWinsAgainst containsObject:self]) {
            return 1;
        } else {
            return 0;
        }
    } else {
        return 1;
    }
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
    Game *g = gameSchedule[gameNumber];
    gs[0] = g.gameName;
    if (gameNumber < gameWLSchedule.count) {
        gs[1] = [NSString stringWithFormat:@"%@ %@", gameWLSchedule[gameNumber], [self gameSummaryStringScore:g]];
        if (g.numOT > 0) gs[1] = [gs[1] stringByAppendingFormat:@" (%dOT)",g.numOT];
    } else {
        gs[1] = @"---";
    }
    gs[2] = [self gameSummaryStringOpponent:g];
    return gs;
}

-(NSArray*)getPlayerStatsExpandListStrings {
    NSMutableArray *pList = [NSMutableArray array];
    [pList addObject:[self getQB:0].getPosNameYrOvrPot_Str];
    
    for (int i = 0; i < 2; ++i) {
        [pList addObject:[self getRB:i].getPosNameYrOvrPot_Str];
    }
    
    for (int i = 0; i < 3; ++i) {
        [pList addObject:[self getWR:i].getPosNameYrOvrPot_Str];
    }
    
    for (int i = 0; i < 5; ++i) {
        [pList addObject:[self getOL:i].getPosNameYrOvrPot_Str];
    }
    
    [pList addObject:[self getK:0].getPosNameYrOvrPot_Str];
    
    [pList addObject:[self getS:0].getPosNameYrOvrPot_Str];
    
    for (int i = 0; i < 3; ++i) {
        [pList addObject:[self getCB:i].getPosNameYrOvrPot_Str];
    }
    
    for (int i = 0; i < 7; ++i) {
        [pList addObject:[self getF7:i].getPosNameYrOvrPot_Str];
    }
    
    [pList addObject:@"BENCH > BENCH"];
    
    return [pList copy];
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

}

/*
-(NSDictionary*)getPlayerStatsExpandListMap:(NSArray*)playerStatsGroupHeaders {
    NSMutableDictionary *playerStatsMap = [NSMutableDictionary dictionary];
    NSString *ph;
 
    ph = playerStatsGroupHeaders[0];
    [playerStatsMap setObject:[[self getQB:0] getDetailedStatsList:[self numGames]] forKey:ph];//.put(ph, getQB(0).getDetailStatsList(numGames()));
    
    for (int i = 1; i < 3; ++i) {
        ph = playerStatsGroupHeaders[i];
        [playerStatsMap setObject:[[self getRB:i-1] getDetailedStatsList:[self numGames]] forKey:ph];
    }
    
    for (int i = 3; i < 6; ++i) {
        ph = playerStatsGroupHeaders[i];
        [playerStatsMap setObject:[[self getWR:i-3] getDetailedStatsList:[self numGames]] forKey:ph];
    }
    
    for (int i = 6; i < 11; ++i) {
        ph = playerStatsGroupHeaders[i];
        [playerStatsMap setObject:[[self getOL:i-6] getDetailedStatsList:[self numGames]] forKey:ph];
    }
    
    ph = playerStatsGroupHeaders[11];
    [playerStatsMap setObject:[[self getK:0] getDetailedStatsList:[self numGames]] forKey:ph];
    
    ph = playerStatsGroupHeaders[12];
    [playerStatsMap setObject:[[self getS:0] getDetailedStatsList:[self numGames]] forKey:ph];
    
    for (int i = 13; i < 16; ++i) {
        ph = playerStatsGroupHeaders[i];
        [playerStatsMap setObject:[[self getCB:i-13] getDetailedStatsList:[self numGames]] forKey:ph];
    }
    
    for (int i = 16; i < 23; ++i) {
        ph = playerStatsGroupHeaders[i];
        [playerStatsMap setObject:[[self getF7:i-16] getDetailedStatsList:[self numGames]] forKey:ph];
    }
    
    //Bench
    ph = playerStatsGroupHeaders[23];
    NSMutableArray* benchStr = [NSMutableArray array];;
    for ( int i = 1; i < teamQBs.count; ++i) {
        [benchStr addObject:[self getQB:i].getPosNameYrOvrPot_Str];
    }
    for ( int i = 2; i < teamRBs.count; ++i) {
        [benchStr addObject:[self getRB:i].getPosNameYrOvrPot_Str];
    }
    for ( int i = 3; i < teamWRs.count; ++i) {
        [benchStr addObject:[self getWR:i].getPosNameYrOvrPot_Str];
    }
    for ( int i = 5; i < teamOLs.count; ++i) {
        [benchStr addObject:[self getOL:i].getPosNameYrOvrPot_Str];
    }
    for ( int i = 1; i < teamKs.count; ++i) {
        [benchStr addObject:[self getK:i].getPosNameYrOvrPot_Str];
    }
    for ( int i = 1; i < teamSs.count; ++i) {
        [benchStr addObject:[self getS:i].getPosNameYrOvrPot_Str];
    }
    for ( int i = 3; i < teamCBs.count; ++i) {
        [benchStr addObject:[self getCB:i].getPosNameYrOvrPot_Str];
    }
    for ( int i = 7; i < teamF7s.count; ++i) {
        [benchStr addObject:[self getF7:i].getPosNameYrOvrPot_Str];
    }
    [playerStatsMap setObject:benchStr forKey:ph];//.put(ph, benchStr);
    
    return playerStatsMap;
}
*/

@end
