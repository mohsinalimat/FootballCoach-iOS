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

@implementation Team

+(instancetype)newTeamWithName:(NSString *)name abbreviation:(NSString *)abbr conference:(NSString *)conference league:(League *)league prestige:(int)prestige rivalTeam:(NSString *)rivalTeamAbbr {
    return [[Team alloc] initWithName:name abbreviation:abbr conference:conference league:league prestige:prestige rivalTeam:rivalTeamAbbr];
}

-(instancetype)initWithName:(NSString*)name abbreviation:(NSString*)abbr conference:(NSString*)conference league:(League*)league prestige:(int)prestige rivalTeam:(NSString*)rivalTeamAbbr {
    self = [super init];
    if (self) {
        _league = league;
        _isUserControlled = false;
        _teamHistory = [NSMutableArray array];
        
        _teamQBs = [NSMutableArray array];
        _teamRBs = [NSMutableArray array];
        _teamWRs = [NSMutableArray array];
        _teamKs = [NSMutableArray array];
        _teamOLs = [NSMutableArray array];
        _teamF7s = [NSMutableArray array];
        _teamSs = [NSMutableArray array];
        _teamCBs = [NSMutableArray array];
        
        _gameSchedule = [NSMutableArray array];
        _oocGame0 = nil;
        _oocGame4 = nil;
        _oocGame9 = nil;
        _gameWinsAgainst = [NSMutableArray array];
        _gameWLSchedule = [NSMutableArray array];
        _teamStreaks = [NSMutableDictionary dictionary];
        _confChampion = @"";
        _semifinalWL = @"";
        _natlChampWL = @"";
        
        _teamPrestige = prestige;
        [self recruitPlayers: @[@2, @4, @6, @2, @10, @2, @6, @14]];
        
        //set stats
        _totalWins = 0;
        _totalLosses = 0;
        _totalCCs = 0;
        _totalNCs = 0;
        
        _totalBowls = 0;
        _totalBowlLosses = 0;
        _totalCCLosses = 0;
        _totalNCLosses = 0;
        
        _teamStatOffNum = 1;
        _teamStatDefNum = 1;
        
        _name = name;
        _abbreviation = abbr;
        _conference = conference;
        _rivalTeam = rivalTeamAbbr;
        _wonRivalryGame = false;
        _teamPoints = 0;
        _teamOppPoints = 0;
        _teamYards = 0;
        _teamOppYards = 0;
        _teamPassYards = 0;
        _teamRushYards = 0;
        _teamOppPassYards = 0;
        _teamOppRushYards = 0;
        _teamTODiff = 0;
        
        _teamOffTalent = [self getOffensiveTalent];
        _teamDefTalent = [self getDefensiveTalent];
         
        _teamPollScore = _teamPrestige + [self getOffensiveTalent] + [self getDefensiveTalent];
        
        _offensiveStrategy = [self getOffensiveTeamStrategies][_teamStatOffNum];
        _defensiveStrategy = [self getDefensiveTeamStrategies][_teamStatDefNum];
        _numberOfRecruits = 30;
    }
    return self;
}
/*
-(instancetype)initWithString:(NSString*)loadStr league:(League*)league {
    self = [super init];
    if (self) {
        _league = league;
        _isUserControlled = NO;
        
        _teamQBs = [NSMutableArray array];
        _teamRBs = [NSMutableArray array];
        _teamWRs = [NSMutableArray array];
        _teamKs = [NSMutableArray array];
        _teamOLs = [NSMutableArray array];
        _teamF7s = [NSMutableArray array];
        _teamSs = [NSMutableArray array];
        _teamCBs = [NSMutableArray array];
        
        _gameSchedule = [NSMutableArray array];
        _oocGame0 = nil;
        _oocGame4 = nil;
        _oocGame9 = nil;
        _gameWinsAgainst = [NSMutableArray array];
        _gameWLSchedule = [NSMutableArray array];
        _confChampion = @"";
        _semifinalWL = @"";
        _natlChampWL = @"";
        
        _teamPoints = 0;
        _teamOppPoints = 0;
        _teamYards = 0;
        _teamOppYards = 0;
        _teamPassYards = 0;
        _teamRushYards = 0;
        _teamOppPassYards = 0;
        _teamOppRushYards = 0;
        _teamTODiff = 0;
        
        NSArray *lines = [loadStr componentsSeparatedByString:@"%"];
        NSArray *teamInfo = [lines[0] componentsSeparatedByString:@","];
        if (teamInfo.count == 9) {
            _conference = teamInfo[0];
            _name = teamInfo[1];
            _abbreviation = teamInfo[2];
            _teamPrestige = [teamInfo[3] intValue];
            _totalWins = [teamInfo[4] intValue];
            _totalLosses = [teamInfo[5] intValue];
            _totalCCs = [teamInfo[6] intValue];
            _totalNCs = [teamInfo[7] intValue];
            _rivalTeam = teamInfo[8];
        }
        
        for (int i = 1; i < lines.count; ++i) {
            [self recruitPlayerCSV: lines[i]];
        }
        
        _wonRivalryGame = false;
        _offensiveStrategy = [[TeamStrategy alloc] init];
        _defensiveStrategy = [[TeamStrategy alloc] init];
        _numberOfRecruits = 30;
        
    }
    return self;
}*/

-(void)updateTalentRatings {
    _teamOffTalent = [self getOffensiveTalent];
    _teamDefTalent = [self getDefensiveTalent];
    _teamPollScore = _teamPrestige + [self getOffensiveTalent] + [self getDefensiveTalent];
}

-(void)advanceSeason {
    
    if (_wonRivalryGame && (_teamPrestige - [_league findTeam:_rivalTeam].teamPrestige < 20) ) {
        _teamPrestige += 2;
    } else if (!_wonRivalryGame && ([_league findTeam:_rivalTeam].teamPrestige - _teamPrestige < 20 || [_name isEqualToString:@"American Samoa"])) {
        _teamPrestige -= 2;
    }
    
    int expectedPollFinish = 100 - _teamPrestige;
    int diffExpected = expectedPollFinish - _rankTeamPollScore;
    int oldPrestige = _teamPrestige;
    
    if ((_teamPrestige > 45 && ![_name isEqualToString:@"American Samoa"]) || diffExpected > 0 ) {
        _teamPrestige = (int)pow(_teamPrestige, 1 + (float)diffExpected/1500);// + diffExpected/2500);
    }
    
    if (_rankTeamPollScore == 1 ) {
        // NCW
        _teamPrestige += 3;
    }
    
    if (_teamPrestige > 95) _teamPrestige = 95;
    if (_teamPrestige < 45 && ![_name isEqualToString:@"American Samoa"]) _teamPrestige = 45;
    
    _diffPrestige = _teamPrestige - oldPrestige;
    NSLog(@"ADVANCING SEASON FOR: %@...", _abbreviation);
    [self advanceSeasonPlayers];
}

-(NSArray*)graduateSeniorsAndGetTeamNeeds {
    int qbNeeds=0, rbNeeds=0, wrNeeds=0, kNeeds=0, olNeeds=0, sNeeds=0, cbNeeds=0, f7Needs=0;
    
    int i = 0;
    if(_teamQBs.count > 0) {
        while (i < _teamQBs.count) {
            if ([_teamQBs[i] year] == 4) {
                NSLog(@"Graduating senior %@ from %@", [_teamQBs[i] name], _abbreviation);
                [_teamQBs removeObjectAtIndex:i];
                qbNeeds++;
            } else {
                i++;
            }
        }
    } else {
        qbNeeds = 2;
    }
    
    i = 0;
    if (_teamRBs.count > 0) {
        while ( i < _teamRBs.count ) {
            if ([_teamRBs[i] year] == 4 ) {
                NSLog(@"Graduating senior %@ from %@", [_teamRBs[i] name], _abbreviation);
                [_teamRBs removeObjectAtIndex:i];
                rbNeeds++;
            } else {
                i++;
            }
        }
    } else {
        rbNeeds = 4;
    }
    
    i = 0;
    if (_teamWRs.count > 0) {
        while ( i < _teamWRs.count ) {
            if ([_teamWRs[i] year] == 4 ) {
                NSLog(@"Graduating senior %@ from %@", [_teamWRs[i] name], _abbreviation);
                [_teamWRs removeObjectAtIndex:i];
                wrNeeds++;
            } else {
                i++;
            }
        }
    } else {
        wrNeeds = 5;
    }
    
    i = 0;
    if (_teamKs.count > 0) {
        while ( i < _teamKs.count ) {
            if ([_teamKs[i] year] == 4 ) {
                NSLog(@"Graduating senior %@ from %@", [_teamKs[i] name], _abbreviation);
                [_teamKs removeObjectAtIndex:i];
                kNeeds++;
            } else {
                i++;
            }
        }
    } else {
        kNeeds = 2;
    }
    
    i = 0;
    if (_teamOLs.count > 0) {
        while ( i < _teamOLs.count ) {
            if ([_teamOLs[i] year] == 4 ) {
                NSLog(@"Graduating senior %@ from %@", [_teamOLs[i] name], _abbreviation);
                [_teamOLs removeObjectAtIndex:i];
                olNeeds++;
            } else {
                i++;
            }
        }
    } else {
        olNeeds = 7;
    }
    
    i = 0;
    if (_teamSs.count > 0) {
        while ( i < _teamSs.count) {
            if ([_teamSs[i] year] == 4 ) {
                NSLog(@"Graduating senior %@ from %@", [_teamSs[i] name], _abbreviation);
                [_teamSs removeObjectAtIndex:i];
                sNeeds++;
            } else {
                i++;
            }
        }
    } else {
        sNeeds = 2;
    }
    
    i = 0;
    if (_teamCBs.count > 0) {
        while ( i < _teamCBs.count ) {
            if ([_teamCBs[i] year] == 4 ) {
                NSLog(@"Graduating senior %@ from %@", [_teamCBs[i] name], _abbreviation);
                [_teamCBs removeObjectAtIndex:i];
                cbNeeds++;
            } else {
                i++;
            }
        }
    } else {
        cbNeeds = 5;
    }
    
    i = 0;
    if (_teamF7s.count > 0) {
        while ( i < _teamF7s.count ) {
            if ([_teamF7s[i] year] == 4 ) {
                NSLog(@"Graduating senior %@ from %@", [_teamF7s[i] name], _abbreviation);
                [_teamF7s removeObjectAtIndex:i];
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
    if (_teamQBs.count > 0) {
        while (i < _teamQBs.count) {
            if ([_teamQBs[i] year] == 4) {
                NSLog(@"Graduating senior %@ from %@", [_teamQBs[i] name], _abbreviation);
                [_teamQBs removeObjectAtIndex:i];
                qbNeeds++;
            } else {
                [_teamQBs[i] advanceSeason];
                i++;
            }
        }
    } else {
        qbNeeds = 2;
    }
    
    i = 0;
    if (_teamRBs.count > 0) {
        while ( i < _teamRBs.count ) {
            if ([_teamRBs[i] year] == 4 ) {
                NSLog(@"Graduating senior %@ from %@", [_teamRBs[i] name], _abbreviation);
                [_teamRBs removeObjectAtIndex:i];
                rbNeeds++;
            } else {
                [_teamRBs[i] advanceSeason];
                i++;
            }
        }
    } else {
        rbNeeds = 4;
    }
    
    i = 0;
    if (_teamWRs.count > 0) {
        while ( i < _teamWRs.count ) {
            if ([_teamWRs[i] year] == 4 ) {
                NSLog(@"Graduating senior %@ from %@", [_teamWRs[i] name], _abbreviation);
                [_teamWRs removeObjectAtIndex:i];
                wrNeeds++;
            } else {
                [_teamWRs[i] advanceSeason];
                i++;
            }
        }
    } else {
        wrNeeds = 5;
    }
    
    i = 0;
    if (_teamKs.count > 0) {
        while ( i < _teamKs.count ) {
            if ([_teamKs[i] year] == 4 ) {
                NSLog(@"Graduating senior %@ from %@", [_teamKs[i] name], _abbreviation);
                [_teamKs removeObjectAtIndex:i];
                kNeeds++;
            } else {
                [_teamKs[i] advanceSeason];
                i++;
            }
        }
    } else {
        kNeeds = 2;
    }
    
    i = 0;
    if (_teamOLs.count > 0) {
        while ( i < _teamOLs.count ) {
            if ([_teamOLs[i] year] == 4 ) {
                NSLog(@"Graduating senior %@ from %@", [_teamOLs[i] name], _abbreviation);
                [_teamOLs removeObjectAtIndex:i];
                olNeeds++;
            } else {
                [_teamOLs[i] advanceSeason];
                i++;
            }
        }
    } else {
        olNeeds = 7;
    }
    
    i = 0;
    if (_teamSs.count > 0) {
        while ( i < _teamSs.count) {
            if ([_teamSs[i] year] == 4 ) {
                NSLog(@"Graduating senior %@ from %@", [_teamSs[i] name], _abbreviation);
                [_teamSs removeObjectAtIndex:i];
                sNeeds++;
            } else {
                [_teamSs[i] advanceSeason];
                i++;
            }
        }
    } else {
        sNeeds = 2;
    }
    
    i = 0;
    if (_teamCBs.count > 0) {
        while ( i < _teamCBs.count ) {
            if ([_teamCBs[i] year] == 4 ) {
                NSLog(@"Graduating senior %@ from %@", [_teamCBs[i] name], _abbreviation);
                [_teamCBs removeObjectAtIndex:i];
                cbNeeds++;
            } else {
                [_teamCBs[i] advanceSeason];
                i++;
            }
        }
    } else {
        cbNeeds = 5;
    }
    
    i = 0;
    if (_teamF7s.count > 0) {
        while ( i < _teamF7s.count ) {
            if ([_teamF7s[i] year] == 4 ) {
                NSLog(@"Graduating senior %@ from %@", [_teamF7s[i] name], _abbreviation);
                [_teamF7s removeObjectAtIndex:i];
                f7Needs++;
            } else {
                [_teamF7s[i] advanceSeason];
                i++;
            }
        }
    } else {
        f7Needs = 10;
    }
    
    if ( !_isUserControlled ) {
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
    
    
    int stars = _teamPrestige/20 + 1;
    int chance = 20 - (_teamPrestige - 20*( _teamPrestige/20 )); //between 0 and 20
    
    for( int i = 0; i < qbNeeds; ++i ) {
        //make QBs
        if ((([HBSharedUtils randomValue] * 100)/100) < 5*chance ) {
            [_teamQBs addObject:[PlayerQB newQBWithName:[_league getRandName] year:(int)(4* [HBSharedUtils randomValue] + 1) stars:(stars - 1) team:self]];
        } else {
            [_teamQBs addObject:[PlayerQB newQBWithName:[_league getRandName] year:(int)(4* [HBSharedUtils randomValue] + 1) stars:(stars) team:self]];
        }
    }
    
    for( int i = 0; i < kNeeds; ++i ) {
        //make Ks
        if ((([HBSharedUtils randomValue] * 100)/100) < 5*chance ) {
            [_teamKs addObject:[PlayerK newKWithName:[_league getRandName] year:(int)(4* [HBSharedUtils randomValue] + 1) stars:(stars - 1) team:self]];
        } else {
            [_teamKs addObject:[PlayerK newKWithName:[_league getRandName] year:(int)(4* [HBSharedUtils randomValue] + 1) stars:(stars) team:self]];
        }
    }
    
    for( int i = 0; i < rbNeeds; ++i ) {
        //make RBs
        if ((([HBSharedUtils randomValue] * 100)/100) < 5*chance ) {
            [_teamRBs addObject:[PlayerRB newRBWithName:[_league getRandName] year:(int)(4* [HBSharedUtils randomValue] + 1) stars:(stars - 1) team:self]];
        } else {
            [_teamRBs addObject:[PlayerRB newRBWithName:[_league getRandName] year:(int)(4* [HBSharedUtils randomValue] + 1) stars:(stars) team:self]];
        }
    }
    
    for( int i = 0; i < wrNeeds; ++i ) {
        //make WRs
        if ((([HBSharedUtils randomValue] * 100)/100) < 5*chance ) {
            [_teamWRs addObject:[PlayerWR newWRWithName:[_league getRandName] year:(int)(4* [HBSharedUtils randomValue] + 1) stars:(stars - 1) team:self]];
        } else {
            [_teamWRs addObject:[PlayerWR newWRWithName:[_league getRandName] year:(int)(4* [HBSharedUtils randomValue] + 1) stars:(stars) team:self]];
        }
    }
    
    for( int i = 0; i < olNeeds; ++i ) {
        //make OLs
        if ((([HBSharedUtils randomValue] * 100)/100) < 5*chance ) {
            [_teamOLs addObject:[PlayerOL newOLWithName:[_league getRandName] year:(int)(4* [HBSharedUtils randomValue] + 1) stars:(stars - 1) team:self]];
        } else {
            [_teamOLs addObject:[PlayerOL newOLWithName:[_league getRandName] year:(int)(4* [HBSharedUtils randomValue] + 1) stars:(stars) team:self]];
        }
    }
    
    for( int i = 0; i < cbNeeds; ++i ) {
        //make CBs
        if ((([HBSharedUtils randomValue] * 100)/100) < 5*chance ) {
             [_teamCBs addObject:[PlayerCB newCBWithName:[_league getRandName] year:(int)(4* [HBSharedUtils randomValue] + 1) stars:(stars - 1)]];
            //teamCBs.add( new PlayerCB(league.getRandName(), (int)(4*Math.random() + 1), stars-1) );
        } else {
            [_teamCBs addObject:[PlayerCB newCBWithName:[_league getRandName] year:(int)(4* [HBSharedUtils randomValue] + 1) stars:(stars)]];
            //teamCBs.add( new PlayerCB(league.getRandName(), (int)(4*Math.random() + 1), stars) );
        }
    }
    
    for( int i = 0; i < f7Needs; ++i ) {
        //make F7s
        if ((([HBSharedUtils randomValue] * 100)/100) < 5*chance ) {
            [_teamF7s addObject:[PlayerF7 newF7WithName:[_league getRandName] year:(int)(4* [HBSharedUtils randomValue] + 1) stars:(stars - 1) team:self]];
        } else {
            [_teamF7s addObject:[PlayerF7 newF7WithName:[_league getRandName] year:(int)(4* [HBSharedUtils randomValue] + 1) stars:(stars) team:self]];
        }
    }
    
    for( int i = 0; i < sNeeds; ++i ) {
        //make Ss
        if ((([HBSharedUtils randomValue] * 100)/100) < 5*chance ) {
            [_teamSs addObject:[PlayerS newSWithName:[_league getRandName] year:(int)(4* [HBSharedUtils randomValue] + 1) stars:(stars - 1)]];
        } else {
            [_teamSs addObject:[PlayerS newSWithName:[_league getRandName] year:(int)(4* [HBSharedUtils randomValue] + 1) stars:(stars)]];
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
    
    
    int stars = _teamPrestige/20 + 1;
    int chance = 20 - (_teamPrestige - 20*( _teamPrestige/20 )); //between 0 and 20
    
    for( int i = 0; i < qbNeeds; ++i ) {
        //make QBs
        if ((([HBSharedUtils randomValue] * 100)/100) < 5*chance ) {
            [_teamQBs addObject:[PlayerQB newQBWithName:[_league getRandName] year:1 stars:(stars - 1) team:self]];
        } else {
            [_teamQBs addObject:[PlayerQB newQBWithName:[_league getRandName] year:1 stars:(stars) team:self]];
        }
    }
    
    for( int i = 0; i < kNeeds; ++i ) {
        //make Ks
        if ((([HBSharedUtils randomValue] * 100)/100) < 5*chance ) {
            [_teamKs addObject:[PlayerK newKWithName:[_league getRandName] year:1 stars:(stars - 1) team:self]];
        } else {
            [_teamKs addObject:[PlayerK newKWithName:[_league getRandName] year:1 stars:(stars) team:self]];
        }
    }
    
    for( int i = 0; i < rbNeeds; ++i ) {
        //make RBs
        if ((([HBSharedUtils randomValue] * 100)/100) < 5*chance ) {
            [_teamRBs addObject:[PlayerRB newRBWithName:[_league getRandName] year:1 stars:(stars - 1) team:self]];
        } else {
            [_teamRBs addObject:[PlayerRB newRBWithName:[_league getRandName] year:1 stars:(stars) team:self]];
        }
    }
    
    for( int i = 0; i < wrNeeds; ++i ) {
        //make WRs
        if ((([HBSharedUtils randomValue] * 100)/100) < 5*chance ) {
            [_teamWRs addObject:[PlayerWR newWRWithName:[_league getRandName] year:1 stars:(stars - 1) team:self]];
        } else {
            [_teamWRs addObject:[PlayerWR newWRWithName:[_league getRandName] year:1 stars:(stars) team:self]];
        }
    }
    
    for( int i = 0; i < olNeeds; ++i ) {
        //make OLs
        if ((([HBSharedUtils randomValue] * 100)/100) < 5*chance ) {
            [_teamOLs addObject:[PlayerOL newOLWithName:[_league getRandName] year:1 stars:(stars - 1) team:self]];
        } else {
            [_teamOLs addObject:[PlayerOL newOLWithName:[_league getRandName] year:1 stars:(stars) team:self]];
        }
    }
    
    for( int i = 0; i < cbNeeds; ++i ) {
        //make CBs
        if ((([HBSharedUtils randomValue] * 100)/100) < 5*chance ) {
            [_teamCBs addObject:[PlayerCB newCBWithName:[_league getRandName] year:1 stars:(stars - 1)]];
        } else {
            [_teamCBs addObject:[PlayerCB newCBWithName:[_league getRandName] year:1 stars:(stars)]];
        }
    }
    
    for( int i = 0; i < f7Needs; ++i ) {
        //make F7s
        if ((([HBSharedUtils randomValue] * 100)/100) < 5*chance ) {
            [_teamF7s addObject:[PlayerF7 newF7WithName:[_league getRandName] year:1 stars:(stars - 1) team:self]];
        } else {
            [_teamF7s addObject:[PlayerF7 newF7WithName:[_league getRandName] year:1 stars:(stars) team:self]];
        }
    }
    
    for( int i = 0; i < sNeeds; ++i ) {
        //make Ss
        if ((([HBSharedUtils randomValue] * 100)/100) < 5*chance ) {
            [_teamSs addObject:[PlayerS newSWithName:[_league getRandName] year:1 stars:(stars - 1)]];
        } else {
            [_teamSs addObject:[PlayerS newSWithName:[_league getRandName] year:1 stars:(stars)]];
        }
    }
    
    //done making players, sort them
    [self sortPlayers];

}

-(void)recruitWalkOns {
    int needs = 2 - [NSNumber numberWithInteger:_teamQBs.count].intValue;
    for( int i = 0; i < needs; ++i ) {
        //make QBs
        //_teamQBs.add( new PlayerQB(league.getRandName(), 1, 2, this) );
        [_teamQBs addObject:[PlayerQB newQBWithName:[_league getRandName] year:1 stars:2 team:self]];
    }
    
    needs = 4 - [NSNumber numberWithInteger:_teamRBs.count].intValue;
    for( int i = 0; i < needs; ++i ) {
        //make RBs
        [_teamRBs addObject:[PlayerRB newRBWithName:[_league getRandName] year:1 stars:2 team:self]];
    }
    
    needs = 6 - [NSNumber numberWithInteger:_teamWRs.count].intValue;
    for( int i = 0; i < needs; ++i ) {
        //make WRs
        [_teamWRs addObject:[PlayerWR newWRWithName:[_league getRandName] year:1 stars:2 team:self]];
    }
    
    needs = 10 - [NSNumber numberWithInteger:_teamOLs.count].intValue;
    for( int i = 0; i < needs; ++i ) {
        //make OLs
        [_teamOLs addObject:[PlayerOL newOLWithName:[_league getRandName] year:1 stars:2 team:self]];
    }
    
    needs = 2 - [NSNumber numberWithInteger:_teamKs.count].intValue;
    for( int i = 0; i < needs; ++i ) {
        //make Ks
        [_teamKs addObject:[PlayerK newKWithName:[_league getRandName] year:1 stars:2 team:self]];
    }
    
    needs = 2 - [NSNumber numberWithInteger:_teamSs.count].intValue;
    for( int i = 0; i < needs; ++i ) {
        //make Ss
        [_teamSs addObject:[PlayerS newSWithName:[_league getRandName] year:1 stars:2]];
    }
    
    needs = 6 - [NSNumber numberWithInteger:_teamCBs.count].intValue;
    for( int i = 0; i < needs; ++i ) {
        //make CBs
        [_teamCBs addObject:[PlayerCB newCBWithName:[_league getRandName] year:1 stars:2]];
    }
    
    needs = 14 - [NSNumber numberWithInteger:_teamF7s.count].intValue;
    for( int i = 0; i < needs; ++i ) {
        //make F7s
        [_teamF7s addObject:[PlayerF7 newF7WithName:[_league getRandName] year:1 stars:2 team:self]];
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
    _gameSchedule = [NSMutableArray array];
    _oocGame0 = nil;
    _oocGame4 = nil;
    _oocGame9 = nil;
    _gameWinsAgainst = [NSMutableArray array];
    _gameWLSchedule = [NSMutableArray array];
    _confChampion = @"";
    _semifinalWL = @"";
    _natlChampWL = @"";
    _wins = 0;
    _losses = 0;
    
    _teamPoints = 0;
    _teamOppPoints = 0;
    _teamYards = 0;
    _teamOppYards = 0;
    _teamPassYards = 0;
    _teamRushYards = 0;
    _teamOppPassYards = 0;
    _teamOppRushYards = 0;
    _teamTODiff = 0;
    _diffOffTalent = [self getOffensiveTalent] - _teamOffTalent;
    _teamOffTalent = [self getOffensiveTalent];
    _diffDefTalent = [self getDefensiveTalent] - _teamDefTalent;
    _teamDefTalent = [self getDefensiveTalent];
    _teamPollScore = _teamPrestige + [self getOffensiveTalent] + [self getDefensiveTalent];
}

-(void)updatePollScore {
    [self updateStrengthOfWins];
    int preseasonBias = 8 - (_wins + _losses);
    if (preseasonBias < 0) preseasonBias = 0;
    _teamPollScore = (_wins*200 + 3*(_teamPoints-_teamOppPoints) + (_teamYards-_teamOppYards)/40 + 3*(preseasonBias)*(_teamPrestige + [self getOffensiveTalent] + [self getDefensiveTalent]) + _teamStrengthOfWins)/10;
    if ([@"CC" isEqualToString:_confChampion] ) {
        //bonus for winning conference
        _teamPollScore += 50;
    }
    if ( [@"NCW" isEqualToString:_natlChampWL] ) {
        //bonus for winning champ game
        _teamPollScore += 100;
    }
    if (_losses == 0 ) {
        _teamPollScore += 30;
    } else if ( _losses == 1 ) {
        _teamPollScore += 15;
    } else {
        _teamPollScore += 0;
    }
}

-(void)updateTeamHistory {
    if (_rankTeamPollScore > 0 && _rankTeamPollScore < 26) {
        [_teamHistory addObject:[NSString stringWithFormat:@"#%ld %@ (%ld-%ld) %@ %@ %@",(long)_rankTeamPollScore, _abbreviation, (long)_wins, (long)_losses, _confChampion, _semifinalWL, _natlChampWL]];
    } else {
        [_teamHistory addObject:[NSString stringWithFormat:@"%@ (%ld-%ld) %@ %@ %@", _abbreviation, (long)_wins, (long)_losses, _confChampion, _semifinalWL, _natlChampWL]];
    }
}

-(NSString*)getTeamHistoryString {
    NSString *teamHistoryString = @"";
    for (int i = 0; i < _teamHistory.count; ++i) {
        teamHistoryString = [[teamHistoryString stringByAppendingString:_teamHistory[i]] stringByAppendingString:@"\n"];
    }
    
    NSString *hist = @"";
    hist = [NSString stringWithFormat:@"Overall W-L: %ld-%ld\nConference Championships: %ld\nNational Championships: %ld\n\nYear by year summary:\n%@", (long)_totalWins, (long)_totalLosses, (long)_totalCCs, (long)_totalNCs, teamHistoryString];
    
    return hist;
}

-(void)updateStrengthOfWins {
    int strWins = 0;
    for ( int i = 0; i < 12; ++i ) {
        Game *g = _gameSchedule[i];
        if (g.homeTeam == self) {
            strWins += pow(60 - g.awayTeam.rankTeamPollScore,2);
        } else {
            strWins += pow(60 - g.homeTeam.rankTeamPollScore,2);
        }
    }
    _teamStrengthOfWins = strWins/50;
    for (Team *t in _gameWinsAgainst) {
        _teamStrengthOfWins += pow(t.wins,2);
    }
}

-(void)sortPlayers {
    [_teamQBs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Player *a = (Player*)obj1;
        Player *b = (Player*)obj2;
        return a.ratOvr > b.ratOvr ? -1 : a.ratOvr == b.ratOvr ? 0 : 1;
    }];
    [_teamRBs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Player *a = (Player*)obj1;
        Player *b = (Player*)obj2;
        return a.ratOvr > b.ratOvr ? -1 : a.ratOvr == b.ratOvr ? 0 : 1;
    }];
    [_teamWRs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Player *a = (Player*)obj1;
        Player *b = (Player*)obj2;
        return a.ratOvr > b.ratOvr ? -1 : a.ratOvr == b.ratOvr ? 0 : 1;
    }];
    [_teamKs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Player *a = (Player*)obj1;
        Player *b = (Player*)obj2;
        return a.ratOvr > b.ratOvr ? -1 : a.ratOvr == b.ratOvr ? 0 : 1;
    }];
    [_teamOLs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Player *a = (Player*)obj1;
        Player *b = (Player*)obj2;
        return a.ratOvr > b.ratOvr ? -1 : a.ratOvr == b.ratOvr ? 0 : 1;
    }];
    
    [_teamCBs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Player *a = (Player*)obj1;
        Player *b = (Player*)obj2;
        return a.ratOvr > b.ratOvr ? -1 : a.ratOvr == b.ratOvr ? 0 : 1;
    }];
    [_teamSs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Player *a = (Player*)obj1;
        Player *b = (Player*)obj2;
        return a.ratOvr > b.ratOvr ? -1 : a.ratOvr == b.ratOvr ? 0 : 1;
    }];
    [_teamF7s sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
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
    if ( depth < _teamQBs.count && depth >= 0 ) {
        return _teamQBs[depth];
    } else {
        return _teamQBs[0];
    }
}

-(PlayerRB*)getRB:(int)depth {
    if ( depth < _teamRBs.count && depth >= 0 ) {
        return _teamRBs[depth];
    } else {
        return _teamRBs[0];
    }
}

-(PlayerWR*)getWR:(int)depth {
    if ( depth < _teamWRs.count && depth >= 0 ) {
        return _teamWRs[depth];
    } else {
        return _teamWRs[0];
    }
}

-(PlayerK*)getK:(int)depth {
    if ( depth < _teamKs.count && depth >= 0 ) {
        return _teamKs[depth];
    } else {
        return _teamKs[0];
    }
}

-(PlayerOL*)getOL:(int)depth {
    if ( depth < _teamOLs.count && depth >= 0 ) {
        return _teamOLs[depth];
    } else {
        return _teamOLs[0];
    }
}

-(PlayerS*)getS:(int)depth {
    if ( depth < _teamSs.count && depth >= 0 ) {
        return _teamSs[depth];
    } else {
        return _teamSs[0];
    }
}

-(PlayerCB*)getCB:(int)depth {
    if ( depth < _teamCBs.count && depth >= 0 ) {
        return _teamCBs[depth];
    } else {
        return _teamCBs[0];
    }
}

-(PlayerF7*)getF7:(int)depth {
    if ( depth < _teamF7s.count && depth >= 0 ) {
        return _teamF7s[depth];
    } else {
        return _teamF7s[0];
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
        compositeOL += (_teamOLs[i].ratOLPow + _teamOLs[i].ratOLBkP)/2;
    }
    return compositeOL / 5;
}

-(int)getCompositeOLRush {
    int compositeOL = 0;
    for ( int i = 0; i < 5; ++i ) {
        compositeOL += (_teamOLs[i].ratOLPow + _teamOLs[i].ratOLBkR)/2;
    }
    return compositeOL / 5;
}

-(int)getCompositeF7Pass {
    int compositeF7 = 0;
    for ( int i = 0; i < 7; ++i ) {
        compositeF7 += (_teamF7s[i].ratF7Pow + _teamF7s[i].ratF7Pas)/2;
    }
    return compositeF7 / 7;
}

-(int)getCompositeF7Rush {
    int compositeF7 = 0;
    for ( int i = 0; i < 7; ++i ) {
        compositeF7 += (_teamF7s[i].ratF7Pow + _teamF7s[i].ratF7Rsh)/2;
    }
    return compositeF7 / 7;
}

-(NSArray*)getTeamStatsArray {
    NSMutableArray *ts0 = [NSMutableArray array];
    
    //[ts0 appendFormat:@"%ld",(long)_teamPollScore];
    //[ts0 appendString:@"AP Votes"];
    //[ts0 appendFormat:@"%@",[self getRankString:_rankTeamPollScore]];
    
    [ts0 addObject:@[[NSString stringWithFormat:@"%d",_teamPollScore], @"AP Votes",[self getRankString:_rankTeamPollScore]]];
    
    //[ts0 appendFormat:@"%ld,",(long)_teamOffTalent];
    //[ts0 appendString:@"Off Talent,"];
    //[ts0 appendFormat:@"%@\n",[self getRankString:_rankTeamOffTalent]];
    [ts0 addObject:@[[NSString stringWithFormat:@"%d",_teamOffTalent], @"Offensive Talent",[self getRankString:_rankTeamOffTalent]]];
    
    //[ts0 appendFormat:@"%ld,",(long)_teamDefTalent];
    //[ts0 appendString:@"Def Talent,"];
    //[ts0 appendFormat:@"%@\n",[self getRankString:_rankTeamDefTalent]];
    [ts0 addObject:@[[NSString stringWithFormat:@"%d",_teamDefTalent], @"Defensive Talent",[self getRankString:_rankTeamDefTalent]]];
    
    //[ts0 appendFormat:@"%ld,",(long)_teamPrestige];
    //[ts0 appendString:@"Prestige,"];
    //[ts0 appendFormat:@"%@\n",[self getRankString:_rankTeamPrestige]];
    [ts0 addObject:@[[NSString stringWithFormat:@"%d",_teamPrestige], @"Prestige",[self getRankString:_rankTeamPrestige]]];
    
    //[ts0 appendFormat:@"%ld,",(long)_teamStrengthOfWins];
    //[ts0 appendString:@"SOS,"];
    //[ts0 appendFormat:@"%@\n",[self getRankString:_rankTeamStrengthOfWins]];
    
    [ts0 addObject:@[[NSString stringWithFormat:@"%d",_teamStrengthOfWins], @"Strength of Schedule",[self getRankString:_rankTeamStrengthOfWins]]];
    
    //[ts0 appendFormat:@"%ld,",(long)(_teamPoints/[self numGames])];
    //[ts0 appendString:@"Points,"];
    //[ts0 appendFormat:@"%@\n",[self getRankString:_rankTeamPoints]];
    
    [ts0 addObject:@[[NSString stringWithFormat:@"%d pts/gm",(_teamPoints/[self numGames])], @"Points Per Game",[self getRankString:_rankTeamPoints]]];
    
    //[ts0 appendFormat:@"%ld,",(long)(_teamOppPoints/[self numGames])];
    //[ts0 appendString:@"Opp Points,"];
    //[ts0 appendFormat:@"%@\n",[self getRankString:_teamOppPoints]];
    
    [ts0 addObject:@[[NSString stringWithFormat:@"%d pts/gm",(_teamOppPoints/[self numGames])], @"Opponent Points Per Game",[self getRankString:_rankTeamOppPoints]]];
    
    //[ts0 appendFormat:@"%ld,",(long)(_teamYards/[self numGames])];
    //[ts0 appendString:@"Yards,"];
    //[ts0 appendFormat:@"%@\n",[self getRankString:_rankTeamYards]];
    
    [ts0 addObject:@[[NSString stringWithFormat:@"%d yds/gm",(_teamYards/[self numGames])], @"Yards Per Game",[self getRankString:_rankTeamYards]]];
    
    //[ts0 appendFormat:@"%ld,",(long)(_teamOppYards/[self numGames])];
    //[ts0 appendString:@"Opp Yards,"];
    //[ts0 appendFormat:@"%@\n",[self getRankString:_rankTeamOppYards]];
    
    [ts0 addObject:@[[NSString stringWithFormat:@"%d yds/gm",(_teamOppYards/[self numGames])], @"Opp Yards Per Game",[self getRankString:_rankTeamYards]]];
    
    //[ts0 appendFormat:@"%ld,",(long)(_teamPassYards/[self numGames])];
    //[ts0 appendString:@"Pass Yards,"];
    //[ts0 appendFormat:@"%@\n",[self getRankString:_rankTeamPassYards]];
    
    [ts0 addObject:@[[NSString stringWithFormat:@"%d yds/gm",(_teamPassYards/[self numGames])], @"Pass Yards Per Game",[self getRankString:_rankTeamPassYards]]];
    
    //[ts0 appendFormat:@"%ld,",(long)(_teamRushYards/[self numGames])];
    //[ts0 appendString:@"Rush Yards,"];
    //[ts0 appendFormat:@"%@\n",[self getRankString:_rankTeamRushYards]];
    
    [ts0 addObject:@[[NSString stringWithFormat:@"%d yds/gm",(_teamRushYards/[self numGames])], @"Rush Yards Per Game",[self getRankString:_rankTeamRushYards]]];
    
    //[ts0 appendFormat:@"%ld,",(long)(_teamOppPassYards/[self numGames])];
    //[ts0 appendString:@"Opp Pass YPG,"];
    //[ts0 appendFormat:@"%@\n",[self getRankString:_rankTeamOppPassYards]];
    
    [ts0 addObject:@[[NSString stringWithFormat:@"%d yds/gm",(_teamOppPassYards/[self numGames])], @"Opp Pass Yards Per Game",[self getRankString:_rankTeamOppPassYards]]];
    
    //[ts0 appendFormat:@"%ld,",(long)(_teamOppRushYards/[self numGames])];
    //[ts0 appendString:@"Opp Rush YPG,"];
    //[ts0 appendFormat:@"%@\n",[self getRankString:_rankTeamOppRushYards]];
    
    [ts0 addObject:@[[NSString stringWithFormat:@"%d yds/gm",(_teamOppRushYards/[self numGames])], @"Opp Rush Yards Per Game",[self getRankString:_rankTeamOppRushYards]]];
    
    NSString *turnoverDifferential = @"0";
    if (_teamTODiff > 0) {
        turnoverDifferential = [NSString stringWithFormat:@"+%d",_teamTODiff];
    } else if (_teamTODiff == 0) {
        turnoverDifferential = @"0";
    } else {
        turnoverDifferential = [NSString stringWithFormat:@"%d",_teamTODiff];
    }
    //[ts0 appendString:@"TO Diff,"];
    //[ts0 appendFormat:@"%@\n",[self getRankString:_rankTeamTODiff]];
    [ts0 addObject:@[turnoverDifferential, @"Turnover Differential",[self getRankString:_rankTeamTODiff]]];
    
    return [ts0 copy];
}


-(NSString*)getTeamStatsStringCSV {
    NSMutableString *ts0 = [NSMutableString string];;
    
    [ts0 appendFormat:@"%ld,",(long)_teamPollScore];
    [ts0 appendString:@"AP Votes,"];
    [ts0 appendFormat:@"%@\n",[self getRankString:_rankTeamPollScore]];
    
    [ts0 appendFormat:@"%ld,",(long)_teamStrengthOfWins];
    [ts0 appendString:@"SOS,"];
    [ts0 appendFormat:@"%@\n",[self getRankString:_rankTeamStrengthOfWins]];
    
    [ts0 appendFormat:@"%ld,",(long)(_teamPoints/[self numGames])];
    [ts0 appendString:@"Points,"];
    [ts0 appendFormat:@"%@\n",[self getRankString:_rankTeamPoints]];
    
    [ts0 appendFormat:@"%ld,",(long)(_teamOppPoints/[self numGames])];
    [ts0 appendString:@"Opp Points,"];
    [ts0 appendFormat:@"%@\n",[self getRankString:_teamOppPoints]];
    
    [ts0 appendFormat:@"%ld,",(long)(_teamYards/[self numGames])];
    [ts0 appendString:@"Yards,"];
    [ts0 appendFormat:@"%@\n",[self getRankString:_rankTeamYards]];
    
    [ts0 appendFormat:@"%ld,",(long)(_teamOppYards/[self numGames])];
    [ts0 appendString:@"Opp Yards,"];
    [ts0 appendFormat:@"%@\n",[self getRankString:_rankTeamOppYards]];
    
    [ts0 appendFormat:@"%ld,",(long)(_teamPassYards/[self numGames])];
    [ts0 appendString:@"Pass Yards,"];
    [ts0 appendFormat:@"%@\n",[self getRankString:_rankTeamPassYards]];
    
    [ts0 appendFormat:@"%ld,",(long)(_teamRushYards/[self numGames])];
    [ts0 appendString:@"Rush Yards,"];
    [ts0 appendFormat:@"%@\n",[self getRankString:_rankTeamRushYards]];
    
    [ts0 appendFormat:@"%ld,",(long)(_teamOppPassYards/[self numGames])];
    [ts0 appendString:@"Opp Pass YPG,"];
    [ts0 appendFormat:@"%@\n",[self getRankString:_rankTeamOppPassYards]];
    
    [ts0 appendFormat:@"%ld,",(long)(_teamOppRushYards/[self numGames])];
    [ts0 appendString:@"Opp Rush YPG,"];
    [ts0 appendFormat:@"%@\n",[self getRankString:_rankTeamOppRushYards]];
    
    if (_teamTODiff > 0) {
        [ts0 appendFormat:@"+%ld,",(long)_teamTODiff];
    } else if (_teamTODiff == 0) {
        [ts0 appendString:@"0,"];
    } else {
        [ts0 appendFormat:@"%ld,",(long)_teamTODiff];
    }
    [ts0 appendString:@"TO Diff,"];
    [ts0 appendFormat:@"%@\n",[self getRankString:_rankTeamTODiff]];
    
    [ts0 appendFormat:@"%ld,",(long)_teamOffTalent];
    [ts0 appendString:@"Off Talent,"];
    [ts0 appendFormat:@"%@\n",[self getRankString:_rankTeamOffTalent]];
    
    [ts0 appendFormat:@"%ld,",(long)_teamDefTalent];
    [ts0 appendString:@"Def Talent,"];
    [ts0 appendFormat:@"%@\n",[self getRankString:_rankTeamDefTalent]];
    
    [ts0 appendFormat:@"%ld,",(long)_teamPrestige];
    [ts0 appendString:@"Prestige,"];
    [ts0 appendFormat:@"%@\n",[self getRankString:_rankTeamPrestige]];
    
    return [ts0 copy];;
}

-(NSString*)getSeasonSummaryString {
    NSMutableString *summary = [NSMutableString stringWithFormat:@"Your team, %@, finished the season ranked #%d with %d wins and %d losses.",_name, _rankTeamPollScore, _wins, _losses];
    int expectedPollFinish = 100 - _teamPrestige;
    int diffExpected = expectedPollFinish - _rankTeamPollScore;
    int oldPrestige = _teamPrestige;
    int newPrestige = oldPrestige;
    if (_teamPrestige > 45 || diffExpected > 0 ) {
        newPrestige = (int)pow(_teamPrestige, 1 + (float)diffExpected/1500);// + diffExpected/2500);
    }
    
    if ([_natlChampWL isEqualToString:@"NCW"]) {
            [summary appendString:@"\n\nYou won the National Championship! Recruits want to play for winners and you have proved that you are one. You gain +3 prestige!"];
    }
    
    if ((newPrestige - oldPrestige) > 0) {
        [summary appendFormat:@"\n\nGreat job, coach! You exceeded expectations and gained %ld prestige! This will help your recruiting.", (long)(newPrestige - oldPrestige)];
    } else if ((newPrestige - oldPrestige) < 0) {
        [summary appendFormat:@"\n\nA bit of a down year, coach? You fell short expectations and lost %ld prestige. This will hurt your recruiting.",(long)(oldPrestige - newPrestige) ];
    } else {
        [summary appendString:@"\n\nWell, your team performed exactly how many expected. This won't hurt or help recruiting, but try to improve next year!"];
    }
    
    if (_wonRivalryGame && (_teamPrestige - [_league findTeam:_rivalTeam].teamPrestige < 20) ) {
        [summary appendString:@"\n\nFuture recruits were impressed that you won your rivalry game. You gained 2 prestige."];
    } else if (!_wonRivalryGame && ([_league findTeam:_rivalTeam].teamPrestige - _teamPrestige < 20 || [_name isEqualToString:@"American Samoa"])) {
        [summary appendString:@"\n\nSince you couldn't win your rivalry game, recruits aren't excited to attend your school. You lost 2 prestige."];
    } else if (_wonRivalryGame) {
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
    if (_wins + _losses > 0 ) {
        return _wins + _losses;
    } else return 1;
}

-(int)getConfWins {
    int confWins = 0;
    Game *g;
    for (int i = 0; i < _gameWLSchedule.count; ++i) {
        g = _gameSchedule[i];
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
    if (_rankTeamPollScore > 0 && _rankTeamPollScore < 26) {
        return [NSString stringWithFormat:@"#%ld %@ (%ld-%ld)",(long)_rankTeamPollScore,_abbreviation,(long)_wins,(long)_losses];
    } else {
        return [NSString stringWithFormat:@"%@ (%ld-%ld)",_abbreviation,(long)_wins,(long)_losses];
    }
}

-(NSString*)strRepWithBowlResults {
    if (_rankTeamPollScore > 0 && _rankTeamPollScore < 26) {
        return [NSString stringWithFormat:@"#%ld %@ (%ld-%ld) %@ %@ %@",(long)_rankTeamPollScore,_abbreviation,(long)_wins,(long)_losses,_confChampion,_semifinalWL,_natlChampWL];
    } else {
        return [NSString stringWithFormat:@"%@ (%ld-%ld) %@ %@ %@",_abbreviation,(long)_wins,(long)_losses,_confChampion,_semifinalWL,_natlChampWL];
    }
    
}

-(NSString*)weekSummaryString {
    int i = _wins + _losses - 1;
    Game *g = _gameSchedule[i];
    NSString *gameSummary = [NSString stringWithFormat:@"%@ %@",_gameWLSchedule[i],[self gameSummaryString:g]];
    NSString *rivalryGameStr = @"";
    if ([g.gameName isEqualToString:@"Rivalry Game"]) {
        if ( [_gameWLSchedule[i] isEqualToString:@"W"] ) rivalryGameStr = @"Won against Rival! ";
        else rivalryGameStr = @"Lost against Rival! ";
    }

    if (_rankTeamPollScore > 0 && _rankTeamPollScore < 26) {
        return [NSString stringWithFormat:@"%@#%d %@ %@",rivalryGameStr,_rankTeamPollScore, _name,gameSummary];
    } else {
        return [NSString stringWithFormat:@"%@%@ %@",rivalryGameStr,_name,gameSummary];
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
    
    for ( PlayerQB *p in _teamQBs ) {
        if (p.year == 4) {
            [sb appendFormat:@"%@\n",p.getPosNameYrOvrPot_OneLine];
        }
    }
    for ( PlayerRB *p in _teamRBs ) {
        if (p.year == 4) {
            [sb appendFormat:@"%@\n",p.getPosNameYrOvrPot_OneLine];
        }
    }
    for ( PlayerWR *p in _teamWRs ) {
        if (p.year == 4) {
            [sb appendFormat:@"%@\n",p.getPosNameYrOvrPot_OneLine];
        }
    }
    for ( PlayerOL *p in _teamOLs ) {
        if (p.year == 4) {
            [sb appendFormat:@"%@\n",p.getPosNameYrOvrPot_OneLine];
        }
    }
    for ( PlayerK *p in _teamKs ) {
        if (p.year == 4) {
            [sb appendFormat:@"%@\n",p.getPosNameYrOvrPot_OneLine];
        }
    }
    for ( PlayerS *p in _teamSs ) {
        if (p.year == 4) {
            [sb appendFormat:@"%@\n",p.getPosNameYrOvrPot_OneLine];
        }
    }
    for ( PlayerCB *p in _teamCBs) {
        if (p.year == 4) {
            [sb appendFormat:@"%@\n",p.getPosNameYrOvrPot_OneLine];
        }
    }
    for ( PlayerF7 *p in _teamF7s ) {
        if (p.year == 4) {
            [sb appendFormat:@"%@\n",p.getPosNameYrOvrPot_OneLine];
        }
    }
    return [sb copy];
}

-(NSArray*)getQBRecruits {
    NSMutableArray* recruits = [NSMutableArray array];
    int stars;
    for (int i = 0; i < _numberOfRecruits; ++i) {
        stars = (int)(5*(float)(_numberOfRecruits - i/2)/_numberOfRecruits);
        recruits[i] = [PlayerQB newQBWithName:[_league getRandName] year:1 stars:stars team:nil];
    }
    [recruits sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Player *a = (Player*)obj1;
        Player *b = (Player*)obj2;
        return a.ratOvr > b.ratOvr ? -1 : a.ratOvr == b.ratOvr ? 0 : 1;
    }];
    return recruits;

}

-(NSArray*)getRBRecruits {
    int numRBrecruits = 2*_numberOfRecruits;
    NSMutableArray* recruits = [NSMutableArray array];
    int stars;
    for (int i = 0; i < numRBrecruits; ++i) {
        stars = (int)(5*(float)(numRBrecruits - i/2)/numRBrecruits);
        recruits[i] = [PlayerRB newRBWithName:[_league getRandName] year:1 stars:stars team:nil];
    }
    
    [recruits sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Player *a = (Player*)obj1;
        Player *b = (Player*)obj2;
        return a.ratOvr > b.ratOvr ? -1 : a.ratOvr == b.ratOvr ? 0 : 1;
    }];
    return recruits;
}

-(NSArray*)getWRRecruits {
    int numWRrecruits = 2*_numberOfRecruits;
    NSMutableArray* recruits = [NSMutableArray array];
    int stars;
    for (int i = 0; i < numWRrecruits; ++i) {
        stars = (int)(5*(float)(numWRrecruits - i/2)/numWRrecruits);
        recruits[i] = [PlayerWR newWRWithName:[_league getRandName] year:1 stars:stars team:nil];
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
    for (int i = 0; i < _numberOfRecruits; ++i) {
        stars = (int)(5*(float)(_numberOfRecruits - i/2)/_numberOfRecruits);
        recruits[i] = [PlayerK newKWithName:[_league getRandName] year:1 stars:stars team:nil];
    }
    [recruits sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Player *a = (Player*)obj1;
        Player *b = (Player*)obj2;
        return a.ratOvr > b.ratOvr ? -1 : a.ratOvr == b.ratOvr ? 0 : 1;
    }];
    return recruits;
}

-(NSArray*)getOLRecruits {
    int numOLrecruits = 3*_numberOfRecruits;
    NSMutableArray* recruits = [NSMutableArray array];
    int stars;
    for (int i = 0; i < numOLrecruits; ++i) {
        stars = (int)(5*(float)(numOLrecruits - i/2)/numOLrecruits);
        recruits[i] = [PlayerOL newOLWithName:[_league getRandName] year:1 stars:stars team:nil];
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
    for (int i = 0; i < _numberOfRecruits; ++i) {
        stars = (int)(5*(float)(_numberOfRecruits - i/2)/_numberOfRecruits);
        recruits[i] = [PlayerS newSWithName:[_league getRandName] year:1 stars:stars];
    }
    [recruits sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Player *a = (Player*)obj1;
        Player *b = (Player*)obj2;
        return a.ratOvr > b.ratOvr ? -1 : a.ratOvr == b.ratOvr ? 0 : 1;
    }];
    return recruits;
}


-(NSArray*)getCBRecruits {
    int numCBrecruits = 2*_numberOfRecruits;
    NSMutableArray* recruits = [NSMutableArray array];
    int stars;
    for (int i = 0; i < numCBrecruits; ++i) {
        stars = (int)(5*(float)(numCBrecruits - i/2)/numCBrecruits);
        recruits[i] = [PlayerCB newCBWithName:[_league getRandName] year:1 stars:stars];
    }
    
    [recruits sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Player *a = (Player*)obj1;
        Player *b = (Player*)obj2;
        return a.ratOvr > b.ratOvr ? -1 : a.ratOvr == b.ratOvr ? 0 : 1;
    }];
    return recruits;
}

-(NSArray*)getF7Recruits {
    int numF7recruits = 3*_numberOfRecruits;
    NSMutableArray* recruits = [NSMutableArray array];
    int stars;
    for (int i = 0; i < numF7recruits; ++i) {
        stars = (int)(5*(float)(numF7recruits - i/2)/numF7recruits);
        recruits[i] = [PlayerF7 newF7WithName:[_league getRandName] year:1 stars:stars team:nil];
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
    for (PlayerQB *qb in _teamQBs) {
        [sb appendString:[NSString stringWithFormat:@"QB %@,%ld,%ld,%ld,%ld,%ld,%ld,%ld,%ld\n",qb.name,(long)qb.year,(long)qb.ratPot,(long)qb.ratFootIQ,(long)qb.ratPassPow,(long)qb.ratPassAcc,(long)qb.ratPassEva,(long)qb.ratOvr,(long)qb.ratImprovement]];
    }
    for (PlayerRB *rb in _teamRBs) {
        [sb appendString:[NSString stringWithFormat:@"RB %@,%ld,%ld,%ld,%ld,%ld,%ld,%ld,%ld\n",rb.name,(long)rb.year,(long)rb.ratPot,(long)rb.ratFootIQ,(long)rb.ratRushPow,(long)rb.ratRushSpd,(long)rb.ratRushEva,(long)rb.ratOvr,(long)rb.ratImprovement]];
    }
    for (PlayerWR *wr in _teamWRs) {
        [sb appendString:[NSString stringWithFormat:@"WR %@,%ld,%ld,%ld,%ld,%ld,%ld,%ld,%ld\n",wr.name,(long)wr.year,(long)wr.ratPot,(long)wr.ratFootIQ,(long)wr.ratRecCat,(long)wr.ratRecSpd,(long)wr.ratRecEva,(long)wr.ratOvr,(long)wr.ratImprovement]];
    }
    for (PlayerK *k in _teamKs) {
         [sb appendString:[NSString stringWithFormat:@"K %@,%ld,%ld,%ld,%ld,%ld,%ld,%ld,%ld\n",k.name,(long)k.year,(long)k.ratPot,(long)k.ratFootIQ,(long)k.ratKickPow,(long)k.ratKickAcc,(long)k.ratKickFum,(long)k.ratOvr,(long)k.ratImprovement]];
    }
    for (PlayerOL *ol in _teamOLs) {
        [sb appendString:[NSString stringWithFormat:@"OL %@,%ld,%ld,%ld,%ld,%ld,%ld,%ld,%ld\n",ol.name,(long)ol.year,(long)ol.ratPot,(long)ol.ratFootIQ,(long)ol.ratOLPow,(long)ol.ratOLBkP,(long)ol.ratOLBkR,(long)ol.ratOvr,(long)ol.ratImprovement]];
    }
    for (PlayerS *s in _teamSs) {
        [sb appendString:[NSString stringWithFormat:@"S %@,%ld,%ld,%ld,%ld,%ld,%ld,%ld,%ld\n",s.name,(long)s.year,(long)s.ratPot,(long)s.ratFootIQ,(long)s.ratSCov,(long)s.ratSSpd,(long)s.ratSTkl,(long)s.ratOvr,(long)s.ratImprovement]];
    }
    for (PlayerCB *cb in _teamCBs) {
        [sb appendString:[NSString stringWithFormat:@"CB %@,%ld,%ld,%ld,%ld,%ld,%ld,%ld,%ld\n",cb.name,(long)cb.year,(long)cb.ratPot,(long)cb.ratFootIQ,(long)cb.ratCBCov,(long)cb.ratCBSpd,(long)cb.ratCBTkl,(long)cb.ratOvr,(long)cb.ratImprovement]];
    }
    for (PlayerF7 *f7 in _teamF7s) {
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
    Game *g = _gameSchedule[gameNumber];
    gs[0] = g.gameName;
    if (gameNumber < _gameWLSchedule.count) {
        gs[1] = [NSString stringWithFormat:@"%@ %@", _gameWLSchedule[gameNumber], [self gameSummaryStringScore:g]];
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
            [oldQBs addObjectsFromArray:_teamQBs];
            [_teamQBs removeAllObjects];
            for (Player *p in starters) {
                [_teamQBs addObject:(PlayerQB*)p];
            }
            for (PlayerQB *oldQb in oldQBs) {
                if (![_teamQBs containsObject:oldQb]) {
                    [_teamQBs addObject:oldQb];
                }
            }
            break;
        }
        case 1: {
            NSMutableArray *oldRBs = [NSMutableArray array];
            [oldRBs addObjectsFromArray:_teamRBs];
            [_teamRBs removeAllObjects];
            for (Player *p in starters) {
                [_teamRBs addObject:(PlayerRB*)p];
            }
            for (PlayerRB *oldRb in oldRBs) {
                if (![_teamRBs containsObject:oldRb]) {
                    [_teamRBs addObject:oldRb];
                }
            }
            break;
        }
        case 2: {
            NSMutableArray *oldWRs = [NSMutableArray array];
            [oldWRs addObjectsFromArray:_teamWRs];
            [_teamWRs removeAllObjects];
            for (Player *p in starters) {
                [_teamWRs addObject:(PlayerWR*)p];
            }
            for (PlayerWR *oldWR in oldWRs) {
                if (![_teamWRs containsObject:oldWR]) {
                    [_teamWRs addObject:oldWR];
                }
            }
            break;
        }
        case 3: {
            NSMutableArray *oldOLs = [NSMutableArray array];
            [oldOLs addObjectsFromArray:_teamOLs];
            [_teamOLs removeAllObjects];
            for (Player *p in starters) {
                [_teamOLs addObject:(PlayerOL*)p];
            }
            for (PlayerOL *oldOL in oldOLs) {
                if (![_teamOLs containsObject:oldOL]) {
                    [_teamOLs addObject:oldOL];
                }
            }
            break;
        }
        case 4: {
            NSMutableArray *oldF7s = [NSMutableArray array];
            [oldF7s addObjectsFromArray:_teamF7s];
            [_teamF7s removeAllObjects];
            for (Player *p in starters) {
                [_teamF7s addObject:(PlayerF7*)p];
            }
            for (PlayerF7 *oldF7 in oldF7s) {
                if (![_teamF7s containsObject:oldF7]) {
                    [_teamF7s addObject:oldF7];
                }
            }
            break;
        }
        case 5: {
            NSMutableArray *oldCBs = [NSMutableArray array];
            [oldCBs addObjectsFromArray:_teamCBs];
            [_teamCBs removeAllObjects];
            for (Player *p in starters) {
                [_teamCBs addObject:(PlayerCB*)p];
            }
            for (PlayerCB *oldCB in oldCBs) {
                if (![_teamCBs containsObject:oldCB]) {
                    [_teamCBs addObject:oldCB];
                }
            }
            break;
        }
        case 6: {
            NSMutableArray *oldSs = [NSMutableArray array];
            [oldSs addObjectsFromArray:_teamSs];
            [_teamSs removeAllObjects];
            for (Player *p in starters) {
                [_teamSs addObject:(PlayerS*)p];
            }
            for (PlayerS *oldS in oldSs) {
                if (![_teamSs containsObject:oldS]) {
                    [_teamSs addObject:oldS];
                }
            }
            break;
        }
        case 7:{
            NSMutableArray *oldKs = [NSMutableArray array];
            [oldKs addObjectsFromArray:_teamKs];
            [_teamKs removeAllObjects];
            for (Player *p in starters) {
                [_teamKs addObject:(PlayerK*)p];
            }
            for (PlayerK *oldK in oldKs) {
                if (![_teamKs containsObject:oldK]) {
                    [_teamKs addObject:oldK];
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
    for ( int i = 1; i < _teamQBs.count; ++i) {
        [benchStr addObject:[self getQB:i].getPosNameYrOvrPot_Str];
    }
    for ( int i = 2; i < _teamRBs.count; ++i) {
        [benchStr addObject:[self getRB:i].getPosNameYrOvrPot_Str];
    }
    for ( int i = 3; i < _teamWRs.count; ++i) {
        [benchStr addObject:[self getWR:i].getPosNameYrOvrPot_Str];
    }
    for ( int i = 5; i < _teamOLs.count; ++i) {
        [benchStr addObject:[self getOL:i].getPosNameYrOvrPot_Str];
    }
    for ( int i = 1; i < _teamKs.count; ++i) {
        [benchStr addObject:[self getK:i].getPosNameYrOvrPot_Str];
    }
    for ( int i = 1; i < _teamSs.count; ++i) {
        [benchStr addObject:[self getS:i].getPosNameYrOvrPot_Str];
    }
    for ( int i = 3; i < _teamCBs.count; ++i) {
        [benchStr addObject:[self getCB:i].getPosNameYrOvrPot_Str];
    }
    for ( int i = 7; i < _teamF7s.count; ++i) {
        [benchStr addObject:[self getF7:i].getPosNameYrOvrPot_Str];
    }
    [playerStatsMap setObject:benchStr forKey:ph];//.put(ph, benchStr);
    
    return playerStatsMap;
}
*/

@end
