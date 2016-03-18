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

@implementation Team

+(instancetype)newTeamWithName:(NSString *)name abbreviation:(NSString *)abbr conference:(NSString *)conference league:(League *)league prestige:(NSInteger)prestige rivalTeam:(NSString *)rivalTeamAbbr {
    return [[Team alloc] initWithName:name abbreviation:abbr conference:conference league:league prestige:prestige rivalTeam:rivalTeamAbbr];
}

-(instancetype)initWithName:(NSString*)name abbreviation:(NSString*)abbr conference:(NSString*)conference league:(League*)league prestige:(NSInteger)prestige rivalTeam:(NSString*)rivalTeamAbbr {
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
        
        _offensiveStrategy = [[TeamStrategy alloc] init];
        _defensiveStrategy = [[TeamStrategy alloc] init];
        _numberOfRecruits = 30;
    }
    return self;
}

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
        _gameWinsAgainst = [NSArray array];
        _gameWLSchedule = [NSArray array];
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
            _teamPrestige = [teamInfo[3] integerValue];
            _totalWins = [teamInfo[4] integerValue];
            _totalLosses = [teamInfo[5] integerValue];
            _totalCCs = [teamInfo[6] integerValue];
            _totalNCs = [teamInfo[7] integerValue];
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
}

-(void)updateTalentRatings {
    _teamOffTalent = [self getOffensiveTalent];
    _teamDefTalent = [self getDefensiveTalent];
    _teamPollScore = _teamPrestige + [self getOffensiveTalent] + [self getDefensiveTalent];
}

-(void)advanceSeason {
    NSInteger expectedPollFinish = 100 - _teamPrestige;
    NSInteger diffExpected = expectedPollFinish - _rankTeamPollScore;
    NSInteger oldPrestige = _teamPrestige;
    
    if ( (_teamPrestige > 45 && ![_name isEqualToString:@"American Samoa"]) || diffExpected > 0 ) {
        _teamPrestige = (int)pow(_teamPrestige, 1 + (float)diffExpected/1500);
    }
    
    if (_wonRivalryGame) {
        _teamPrestige += 2;
    } else {
        _teamPrestige -= 2;
    }
    
    if (_teamPrestige > 95) _teamPrestige = 95;
    if (_teamPrestige < 45 && ![_name isEqualToString:@"American Samoa"]) _teamPrestige = 45;
    
    _diffPrestige = _teamPrestige - oldPrestige;
    [self advanceSeasonPlayers];
}

-(void)advanceSeasonPlayers {
    NSInteger qbNeeds=0, rbNeeds=0, wrNeeds=0, kNeeds=0, olNeeds=0, sNeeds=0, cbNeeds=0, f7Needs=0;
    
    int i = 0;
    while (i < _teamQBs.count) {
        if ([_teamQBs[i] year] == 4) {
            [_teamQBs removeObjectAtIndex:i];
            qbNeeds++;
        } else {
            [_teamQBs[i] advanceSeason];
            i++;
        }
    }
    
    i = 0;
    while ( i < _teamRBs.count ) {
        if ([_teamRBs[i] year] == 4 ) {
            [_teamRBs removeObjectAtIndex:i];
            rbNeeds++;
        } else {
            [_teamRBs[i] advanceSeason];
            i++;
        }
    }
    
    i = 0;
    while ( i < _teamWRs.count ) {
        if ([_teamWRs[i] year] == 4 ) {
            [_teamWRs removeObjectAtIndex:i];
            wrNeeds++;
        } else {
            [_teamWRs[i] advanceSeason];
            i++;
        }
    }
    
    i = 0;
    while ( i < _teamKs.count ) {
        if ([_teamKs[i] year] == 4 ) {
            [_teamKs removeObjectAtIndex:i];
            kNeeds++;
        } else {
            [_teamKs[i] advanceSeason];
            i++;
        }
    }
    
    i = 0;
    while ( i < _teamOLs.count ) {
        if ([_teamOLs[i] year] == 4 ) {
            [_teamOLs removeObjectAtIndex:i];
            olNeeds++;
        } else {
            [_teamOLs[i] advanceSeason];
            i++;
        }
    }
    
    i = 0;
    while ( i < _teamSs.count) {
        if ([_teamSs[i] year] == 4 ) {
            [_teamSs removeObjectAtIndex:i];
            sNeeds++;
        } else {
            [_teamSs[i] advanceSeason];
            i++;
        }
    }
    
    i = 0;
    while ( i < _teamCBs.count ) {
        if ([_teamCBs[i] year] == 4 ) {
            [_teamCBs removeObjectAtIndex:i];
            cbNeeds++;
        } else {
            [_teamCBs[i] advanceSeason];
            i++;
        }
    }
    
    i = 0;
    while ( i < _teamF7s.count ) {
        if ([_teamF7s[i] year] == 4 ) {
            [_teamF7s removeObjectAtIndex:i];
            f7Needs++;
        } else {
            [_teamF7s[i] advanceSeason];
            i++;
        }
    }
    
    if ( !_isUserControlled ) {
        [self recruitPlayersFreshman:@[@(qbNeeds), @(rbNeeds), @(wrNeeds), @(kNeeds), @(olNeeds), @(sNeeds), @(cbNeeds), @(f7Needs)]];
        [self resetStats];
    }
}

-(void)recruitPlayers:(NSArray*)needs {
    
    NSInteger qbNeeds, rbNeeds, wrNeeds, kNeeds, olNeeds, sNeeds, cbNeeds, f7Needs = 0;
    qbNeeds = [needs[0] integerValue];
    rbNeeds = [needs[1] integerValue];
    wrNeeds = [needs[2] integerValue];
    kNeeds = [needs[3] integerValue];
    olNeeds = [needs[4] integerValue];
    sNeeds = [needs[5] integerValue];
    cbNeeds = [needs[6] integerValue];
    f7Needs = [needs[7] integerValue];
    
    /*
    NSInteger stars = _teamPrestige/20 + 1;
    NSInteger chance = 20 - (_teamPrestige - 20*( _teamPrestige/20 )); //between 0 and 20
    
    for( int i = 0; i < qbNeeds; ++i ) {
        //make QBs
        if ( 100*arc4random() < 5*chance ) {
            _teamQBs.add( new PlayerQB(league.getRandName(), (int)(4*Math.random() + 1), stars-1, this) );
        } else {
            _teamQBs.add( new PlayerQB(league.getRandName(), (int)(4*Math.random() + 1), stars, this) );
        }
    }
    
    for( int i = 0; i < kNeeds; ++i ) {
        //make Ks
        if ( 100*arc4random() < 5*chance ) {
            teamKs.add( new PlayerK(league.getRandName(), (int)(4*Math.random() + 1), stars-1) );
        } else {
            teamKs.add( new PlayerK(league.getRandName(), (int)(4*Math.random() + 1), stars) );
        }
    }
    
    for( int i = 0; i < rbNeeds; ++i ) {
        //make RBs
        if ( 100*arc4random() < 5*chance ) {
            teamRBs.add( new PlayerRB(league.getRandName(), (int)(4*Math.random() + 1), stars-1, this) );
        } else {
            teamRBs.add( new PlayerRB(league.getRandName(), (int)(4*Math.random() + 1), stars, this) );
        }
    }
    
    for( int i = 0; i < wrNeeds; ++i ) {
        //make WRs
        if ( 100*arc4random() < 5*chance ) {
            teamWRs.add( new PlayerWR(league.getRandName(), (int)(4*Math.random() + 1), stars-1, this) );
        } else {
            teamWRs.add( new PlayerWR(league.getRandName(), (int)(4*Math.random() + 1), stars, this) );
        }
    }
    
    for( int i = 0; i < olNeeds; ++i ) {
        //make OLs
        if ( 100*arc4random() < 5*chance ) {
            teamOLs.add( new PlayerOL(league.getRandName(), (int)(4*Math.random() + 1), stars-1) );
        } else {
            teamOLs.add( new PlayerOL(league.getRandName(), (int)(4*Math.random() + 1), stars) );
        }
    }
    
    for( int i = 0; i < cbNeeds; ++i ) {
        //make CBs
        if ( 100*arc4random() < 5*chance ) {
            [_teamCBs addObject:[[PlayerCB alloc] initWithName:[_league getRandomName] year:(NSInteger)(4*arc4random() + 1) stars:(stars - 1)]];
            //teamCBs.add( new PlayerCB(league.getRandName(), (int)(4*Math.random() + 1), stars-1) );
        } else {
            [_teamCBs addObject:[[PlayerCB alloc] initWithName:[_league getRandomName] year:(NSInteger)(4*arc4random() + 1) stars:(stars)]];
            //teamCBs.add( new PlayerCB(league.getRandName(), (int)(4*Math.random() + 1), stars) );
        }
    }
    
    for( int i = 0; i < f7Needs; ++i ) {
        //make F7s
        if ( 100*arc4random() < 5*chance ) {
            teamF7s.add( new PlayerF7(league.getRandName(), (int)(4*Math.random() + 1), stars-1) );
        } else {
            teamF7s.add( new PlayerF7(league.getRandName(), (int)(4*Math.random() + 1), stars) );
        }
    }
    
    for( int i = 0; i < sNeeds; ++i ) {
        //make Ss
        if ( 100*arc4random() < 5*chance ) {
            teamSs.add( new PlayerS(league.getRandName(), (int)(4*Math.random() + 1), stars-1) );
        } else {
            teamSs.add( new PlayerS(league.getRandName(), (int)(4*Math.random() + 1), stars) );
        }
    }*/
    
    //done making players, sort them
    [self sortPlayers];
}

-(void)recruitPlayersFreshman:(NSArray*)needs {
    
}

-(void)recruitWalkOns {
    
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
    _gameWinsAgainst = [NSArray array];
    _gameWLSchedule = [NSArray array];
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
    NSInteger preseasonBias = 8 - (_wins + _losses);
    if (preseasonBias < 0) preseasonBias = 0;
    _teamPollScore = (_wins*200 + 3*(_teamPoints-_teamOppPoints) +
                     (_teamYards-_teamOppYards)/40 +
                     3*(preseasonBias)*(_teamPrestige + [self getOffensiveTalent] + [self getDefensiveTalent]) +
                     _teamStrengthOfWins)/10;
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
    [_teamHistory addObject:[NSString stringWithFormat:@"%lu: #%ld %@ (%ld-%ld) %@ %@ %@",(_teamHistory.count + 2015),(long)_rankTeamPollScore, _abbreviation, (long)_wins, (long)_losses, _confChampion, _semifinalWL, _natlChampWL]];
    //teamHistory.add((teamHistory.size() + 2015) + ": #" + rankTeamPollScore + " " + abbr + " (" + wins + "-" + losses + ") " + confChampion + " " + semiFinalWL + natChampWL);
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
    NSInteger strWins = 0;
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
    
}

-(NSInteger)getOffensiveTalent {
    return ([self getQB:0].ratOvr*5 +
            [self getWR:0].ratOvr + [self getWR:1].ratOvr + [self getWR:2].ratOvr +
            [self getRB:0].ratOvr + [self getRB:1].ratOvr +
            [self getCompositeOLPass] + [self getCompositeOLRush] ) / 12;
}

-(NSInteger)getDefensiveTalent {
    return ( [self getRushDef] + [self getPassDef] ) / 2;
}

-(Player*)getQB:(NSInteger)depth {
    if ( depth < _teamQBs.count && depth >= 0 ) {
        return _teamQBs[depth];
    } else {
        return _teamQBs[0];
    }
}

-(Player*)getRB:(NSInteger)depth {
    if ( depth < _teamRBs.count && depth >= 0 ) {
        return _teamRBs[depth];
    } else {
        return _teamRBs[0];
    }
}

-(Player*)getWR:(NSInteger)depth {
    if ( depth < _teamWRs.count && depth >= 0 ) {
        return _teamWRs[depth];
    } else {
        return _teamWRs[0];
    }
}

-(Player*)getK:(NSInteger)depth {
    if ( depth < _teamKs.count && depth >= 0 ) {
        return _teamKs[depth];
    } else {
        return _teamKs[0];
    }
}

-(Player*)getOL:(NSInteger)depth {
    if ( depth < _teamOLs.count && depth >= 0 ) {
        return _teamOLs[depth];
    } else {
        return _teamOLs[0];
    }
}

-(Player*)getS:(NSInteger)depth {
    if ( depth < _teamSs.count && depth >= 0 ) {
        return _teamSs[depth];
    } else {
        return _teamSs[0];
    }
}

-(Player*)getCB:(NSInteger)depth {
    if ( depth < _teamCBs.count && depth >= 0 ) {
        return _teamCBs[depth];
    } else {
        return _teamCBs[0];
    }
}

-(Player*)getF7:(NSInteger)depth {
    if ( depth < _teamF7s.count && depth >= 0 ) {
        return _teamF7s[depth];
    } else {
        return _teamF7s[0];
    }
}

-(NSInteger)getPassProf {
    NSInteger avgWRs = ( [self getWR:0].ratOvr + [self getWR:1].ratOvr + [self getWR:2].ratOvr)/3;
    return ([self getCompositeOLPass] + [self getQB:0].ratOvr*2 + avgWRs)/4;
}

-(NSInteger)getRushProf {
    NSInteger avgRBs = ( [self getRB:0].ratOvr + [self getRB:1].ratOvr )/2;
    return ([ self getCompositeOLRush] + avgRBs )/2;
}

-(NSInteger)getPassDef {
    NSInteger avgCBs = ( [self getCB:0].ratOvr + [self getCB:1].ratOvr + [self getCB:2].ratOvr)/3;
    return (avgCBs*3 + [self getS:0].ratOvr + [self getCompositeF7Pass]*2)/6;
}

-(NSInteger)getRushDef {
    return [self getCompositeF7Rush];
}
/*

-(NSInteger)getCompositeOLPass {
    
}

-(NSInteger)getCompositeOLRush {
    
}

-(NSInteger)getCompositeF7Pass {
    
}

-(NSInteger)getCompositeF7Rush {
    
}

-(NSArray*)getTeamStatsStrings {
    
}

-(NSString*)getTeamStatsStringCSV {
    
}

-(NSArray*)getGameScheduleStrings {
    
}

-(NSArray*)getGameSummaryStrings {
    
}

-(NSString*)getSeasonSummaryString {
    
}

-(NSArray*)getPlayerStatsStrings {
    
}

-(NSArray*)getPlayerStatsExpandListStrings {
    
}

-(NSDictionary*)getPlayerStatsExpandListMap:(NSArray*)playerStatsGroupHeaders {
    
}

-(NSString*)getRankString {
    
}

-(NSString*)getRankStringStarUser:(NSInteger)num {
    
}

-(NSInteger)numGames {
    
}

-(NSInteger)getConfWins {
    
}

-(NSString*)strRep {
    
}

-(NSString*)strRepWithBowlResults {
    
}

-(NSString*)weekSummaryString {
    
}

-(NSString*)gameSummaryString:(Game*)g {
    
}

-(NSString*)gameSummaryStringScore:(Game*)g {
    
}

-(NSString*)gameSummaryStringOpponent:(Game*)g {
    
}

-(NSString*)getGraduatingPlayersString {
    
}

-(NSString*)getTeamNeeds {
    
}

-(NSArray*)getQBRecruits {
   
    
}

-(NSArray*)getRBRecruits {
    
}

-(NSArray*)getWRRecruits {
    
}

-(NSArray*)getKRecruits {
    
}

-(NSArray*)getOLRecruits {
    
}

-(NSArray*)getSRecruits {
    
}

-(NSArray*)getCBRecruits {
    
}

-(NSArray*)getF7Recruits {
    
}

-(NSString *)getRecruitsInfoSaveFile {
    
}

-(NSString *)getPlayerInfoSaveFile {
    NSMutableString *sb = [NSMutableString string];
    for (PlayerQB *qb in teamQBs) {
        [sb appendString:[NSString stringWithFormat:@"QB %@,%@,%@,%@,%@,%@,%@,%@,%@\n",qb.name,qb.year,qb.ratPot,qb.ratFootIQ,qb.ratPassPow,qb.ratPassAcc,qb.ratPassEva, qb.ratOvr, qb.ratImprovement]];
    }
    for (PlayerRB *rb in teamRBs) {
        sb.append("RB," + rb.name + "," + rb.year + "," + rb.ratPot + "," + rb.ratFootIQ + "," + rb.ratRushPow + "," + rb.ratRushSpd + "," + rb.ratRushEva + "," + rb.ratOvr + "," + rb.ratImprovement + "%\n");
    }
    for (PlayerWR *wr in teamWRs) {
        sb.append("WR," + wr.name + "," + wr.year + "," + wr.ratPot + "," + wr.ratFootIQ + "," + wr.ratRecCat + "," + wr.ratRecSpd + "," + wr.ratRecEva + "," + wr.ratOvr + "," + wr.ratImprovement + "%\n");
    }
    for (PlayerK *k in teamKs) {
        sb.append("K," + k.name + "," + k.year + "," + k.ratPot + "," + k.ratFootIQ + "," + k.ratKickPow + "," + k.ratKickAcc + "," + k.ratKickFum + "," + k.ratOvr + "," + k.ratImprovement + "%\n");
    }
    for (PlayerOL *ol in teamOLs) {
        sb.append("OL," + ol.name + "," + ol.year + "," + ol.ratPot + "," + ol.ratFootIQ + "," + ol.ratOLPow + "," + ol.ratOLBkR + "," + ol.ratOLBkP + "," + ol.ratOvr + "," + ol.ratImprovement + "%\n");
    }
    for (PlayerS *s in teamSs) {
        sb.append("S," + s.name + "," + s.year + "," + s.ratPot + "," + s.ratFootIQ + "," + s.ratSCov + "," + s.ratSSpd + "," + s.ratSTkl + "," + s.ratOvr + "," + s.ratImprovement + "%\n");
    }
    for (PlayerCB *cb in teamCBs) {
        sb.append("CB," + cb.name + "," + cb.year + "," + cb.ratPot + "," + cb.ratFootIQ + "," + cb.ratCBCov + "," + cb.ratCBSpd + "," + cb.ratCBTkl + "," + cb.ratOvr + "," + cb.ratImprovement + "%\n");
    }
    for (PlayerF7 *f7 in teamF7s) {
        sb.append("F7," + f7.name + "," + f7.year + "," + f7.ratPot + "," + f7.ratFootIQ + "," + f7.ratF7Pow + "," + f7.ratF7Rsh + "," + f7.ratF7Pas + "," + f7.ratOvr + "," + f7.ratImprovement + "%\n");
    }
    return [sb copy];
}*/

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

@end
