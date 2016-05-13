//
//  Conference.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/16/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "Conference.h"
#import "Team.h"
#import "HBSharedUtils.h"

@implementation Conference

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _confName = [aDecoder decodeObjectForKey:@"confName"];
        _confPrestige = [aDecoder decodeIntForKey:@"confPrestige"];
        _confTeams = [aDecoder decodeObjectForKey:@"confTeams"];
        _ccg = [aDecoder decodeObjectForKey:@"ccg"];
        _week = [aDecoder decodeIntForKey:@"week"];
        _robinWeek = [aDecoder decodeIntForKey:@"robinWeek"];
        _league = [aDecoder decodeObjectForKey:@"league"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_confName forKey:@"confName"];
    [aCoder encodeInt:_confPrestige forKey:@"confPrestige"];
    [aCoder encodeObject:_confTeams forKey:@"confTeams"];
    [aCoder encodeObject:_league forKey:@"league"];
    
    [aCoder encodeObject:_ccg forKey:@"ccg"];
    [aCoder encodeInt:_week forKey:@"week"];
    [aCoder encodeInt:_robinWeek forKey:@"robinWeek"];
}

+(instancetype)newConferenceWithName:(NSString*)name league:(League*)league {
    Conference *conf = [[Conference alloc] init];
    if (conf) {
        conf.confName = name;
        conf.confPrestige = 75;
        conf.confTeams = [NSMutableArray array];
        conf.league = league;
        conf.week = 0;
        conf.robinWeek = 0;
    }
    return conf;
}

-(NSString*)getCCGString {
    if (_ccg == nil) {
        // Give prediction, find top 2 teams
        Team *team1 = nil, *team2 = nil;
        int score1 = 0, score2 = 0;
        for (int i = [NSNumber numberWithInteger:_confTeams.count].intValue - 1; i >= 0; --i) { //count backwards so higher ranked teams are predicted
            Team *t = _confTeams[i];
            if ([t calculateConfWins] >= score1) {
                score2 = score1;
                score1 = [t calculateConfWins];
                team2 = team1;
                team1 = t;
            } else if ([t calculateConfWins] > score2) {
                score2 = [t calculateConfWins];
                team2 = t;
            }
        }
        return [NSString stringWithFormat:@"%@ Conference Championship:\n\t\t%@ vs %@", _confName,
        [team1 strRep], [team2 strRep]];
    } else {
        if (!_ccg.hasPlayed) {
            return [NSString stringWithFormat:@"%@ Conference Championship:\n\t\t%@ vs %@", _confName, [_ccg.homeTeam strRep], [_ccg.awayTeam strRep]];
        } else {
            NSString *sb = @"";
            Team *winner, *loser;
            sb = [_confName stringByAppendingString:@" Conference Championship:\n"];
            if (_ccg.homeScore > _ccg.awayScore) {
                winner = _ccg.homeTeam;
                loser = _ccg.awayTeam;
                sb = [sb stringByAppendingString:[[winner strRep] stringByAppendingString:@" W "]];
                sb = [sb stringByAppendingString:[NSString stringWithFormat:@"%ld - %ld,",(long)_ccg.homeScore, (long)_ccg.awayScore]];
                sb = [sb stringByAppendingString:[NSString stringWithFormat:@"vs %@", [loser strRep]]];
                //sb.append("vs " + [loser strRep]);
                return sb;
            } else {
                winner = _ccg.awayTeam;
                loser = _ccg.homeTeam;
                sb = [sb stringByAppendingString:[[winner strRep] stringByAppendingString:@" W "]];
                sb = [sb stringByAppendingString:[NSString stringWithFormat:@"%ld - %ld,",(long)_ccg.homeScore, (long)_ccg.awayScore]];
                sb = [sb stringByAppendingString:[NSString stringWithFormat:@"@ %@", [loser strRep]]];
                return sb;
            }
        }
    }

}

-(void)playConfChamp {
    [_ccg playGame];
     if (_ccg.homeScore > _ccg.awayScore ) {
         _confTeams[0].confChampion = @"CC";
         _confTeams[0].totalCCs++;
         _confTeams[1].totalCCLosses++;
         NSMutableArray *week13 = _league.newsStories[13];
         [week13 addObject:[NSString stringWithFormat:@"%@ wins the %@!\n%@ took care of business in the conference championship against %@, winning at home with a score of %ld to %ld.",_ccg.homeTeam.name, _confName, _ccg.homeTeam.strRep, _ccg.awayTeam.strRep, (long)_ccg.homeScore, (long)_ccg.awayScore]];
     } else {
         _confTeams[1].confChampion = @"CC";
         _confTeams[1].totalCCs++;
         _confTeams[0].totalCCLosses++;
         NSMutableArray *week13 = _league.newsStories[13];
         [week13 addObject:[NSString stringWithFormat:@"%@ wins the %@!\n%@ surprised many in the conference championship against %@, winning on the road with a score of %ld to %ld.",_ccg.awayTeam.name, _confName, _ccg.awayTeam.strRep, _ccg.homeTeam.strRep, (long)_ccg.awayScore, (long)_ccg.homeScore]];
     }
     _confTeams = [[_confTeams sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
         Team *a = (Team*)obj1;
         Team *b = (Team*)obj2;
         return a.teamPollScore > b.teamPollScore ? -1 : a.teamPollScore == b.teamPollScore ? 0 : 1;
     
     }] mutableCopy];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"newNewsStory" object:nil];
}

-(void)scheduleConfChamp {
    [self sortConfTeams];
     
    _ccg = [Game newGameWithHome:_confTeams[0]  away:_confTeams[1] name:[NSString stringWithFormat:@"%@ CCG", _confName]];
    [_confTeams[0].gameSchedule addObject:_ccg];
    [_confTeams[1].gameSchedule addObject:_ccg];
}

-(void)sortConfTeams {
    for ( int i = 0; i < _confTeams.count; ++i ) {
        [_confTeams[i] updatePollScore];;
    }
    
    _confTeams = [[_confTeams sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Team *a = (Team*)obj1;
        Team *b = (Team*)obj2;
        if ([a.confChampion isEqualToString:@"CC"]) return -1;
        else if ([b.confChampion isEqualToString:@"CC"]) return 1;
        if ([a calculateConfWins] > [b calculateConfWins]) {
            return -1;
        } else if ([a calculateConfWins] == [b calculateConfWins]) {
            //check for h2h tiebreaker
            if ([a.gameWinsAgainst containsObject:b]) {
                return -1;
            } else if ([b.gameWinsAgainst containsObject:a]) {
                return 1;
            } else {
                return a.teamPollScore > b.teamPollScore ? -1 : a.teamPollScore == b.teamPollScore ? 0 : 1;
            }
        } else {
            return 1;
        }
    }] mutableCopy];
    
    int winsFirst = [_confTeams[0] calculateConfWins];
    Team *t = _confTeams[0];
    int i = 0;
    NSMutableArray *teamTB = [NSMutableArray array];
    while ([t calculateConfWins] == winsFirst) {
        [teamTB addObject:t];
        ++i;
        t = _confTeams[i];
    }
    if (teamTB.count > 2) {
        // ugh 3 way tiebreaker
        [teamTB sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            Team *a = (Team*)obj1;
            Team *b = (Team*)obj2;
            if ([a calculateConfWins] > [b calculateConfWins]) {
                return -1;
            } else if ([a calculateConfWins] == [b calculateConfWins]) {
                //check for h2h tiebreaker
                if ([a.gameWinsAgainst containsObject:b]) {
                    return -1;
                } else if ([b.gameWinsAgainst containsObject:a]) {
                    return 1;
                } else {
                    return a.teamPollScore > b.teamPollScore ? -1 : a.teamPollScore == b.teamPollScore ? 0 : 1;
                }
            } else {
                return 1;
            }
        }];
        for (int j = 0; j < teamTB.count; ++j) {
            [_confTeams replaceObjectAtIndex:j withObject:teamTB[j]];
        }
        
    }
    
    int winsSecond = [_confTeams[1] calculateConfWins];
    t = _confTeams[1];
    i = 1;
    [teamTB removeAllObjects];
    while ([t calculateConfWins] == winsSecond) {
        [teamTB addObject:t];
        ++i;
        t = _confTeams[i];
    }
    if (teamTB.count > 2) {
        // ugh 3 way tiebreaker
        [teamTB sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            Team *a = (Team*)obj1;
            Team *b = (Team*)obj2;
            if ([a calculateConfWins] > [b calculateConfWins]) {
                return -1;
            } else if ([a calculateConfWins] == [b calculateConfWins]) {
                //check for h2h tiebreaker
                if ([a.gameWinsAgainst containsObject:b]) {
                    return -1;
                } else if ([b.gameWinsAgainst containsObject:a]) {
                    return 1;
                } else {
                    return a.teamPollScore > b.teamPollScore ? -1 : a.teamPollScore == b.teamPollScore ? 0 : 1;
                }
            } else {
                return 1;
            }
        }];
        for (int j = 0; j < teamTB.count; ++j) {
            [_confTeams replaceObjectAtIndex:(j + 1) withObject:teamTB[j]];
        }
        
    }
}

-(Game*)ccgPrediction {
    if (!_ccg) { // ccg hasn't been scheduled so we can project it
        [self sortConfTeams];
        
        return [Game newGameWithHome:_confTeams[0]  away:_confTeams[1] name:[NSString stringWithFormat:@"%@ CCG", _confName]];
    } else { //ccg has been scheduled/played so send that forward
        return _ccg;
    }
}

-(void)playWeek {
    if ( _week == 12 ) {
        [self playConfChamp];
    } else {
        for ( int i = 0; i < _confTeams.count; ++i ) {
            [[_confTeams[i] gameSchedule][_week] playGame];
        }
        if (_week == 11 ) [self scheduleConfChamp];
        _week++;
    }
}

-(void)insertOOCSchedule {
    for (int i = 0; i < _confTeams.count; ++i) {
        [[_confTeams[i] gameSchedule] insertObject:[_confTeams[i] oocGame0] atIndex:0];
        [[_confTeams[i] gameSchedule] insertObject:[_confTeams[i] oocGame4] atIndex:4];
        [[_confTeams[i] gameSchedule] insertObject:[_confTeams[i] oocGame9] atIndex:9];
    }
}

-(void)setUpOOCSchedule {
    
    //schedule OOC games
    int confNum = -1;
    if ([@"SOUTH" isEqualToString:_confName]) {
        confNum = 0;
    } else if ([@"LAKES" isEqualToString:_confName]) {
        confNum = 1;
    } else if ([@"NORTH" isEqualToString:_confName]) {
        confNum = 2;
    }
    
    if ( confNum != -1 ) {
        for ( int offsetOOC = 3; offsetOOC < 6; ++offsetOOC ) {
            NSMutableArray<Team*> *availTeams = [NSMutableArray array];
            int selConf = confNum + offsetOOC;
            if (selConf == 6) selConf = 3;
            if (selConf == 7) selConf = 4;
            if (selConf == 8) selConf = 5;
            
            for (int i = 0; i < 10; ++i) {
                [availTeams addObject:_league.conferences[selConf].confTeams[i]];
            }
            
            for (int i = 0; i < 10; ++i) {
                int selTeam = (int)([HBSharedUtils randomValue] * availTeams.count);
                Team *a = _confTeams[i];
                Team *b = availTeams[selTeam];
                
                Game *gm;
                if ([HBSharedUtils randomValue] > 0.5) {
                    gm = [Game newGameWithHome:a away:b name:[NSString stringWithFormat:@"%@ vs %@",[b.conference substringWithRange:NSMakeRange(0, 3)],[a.conference substringWithRange:NSMakeRange(0, 3)]]];
                } else {
                    gm = [Game newGameWithHome:b away:a name:[NSString stringWithFormat:@"%@ vs %@",[a.conference substringWithRange:NSMakeRange(0, 3)],[b.conference substringWithRange:NSMakeRange(0, 3)]]];
                }
                
                if ( offsetOOC == 3 ) {
                    a.oocGame0 = gm;
                    b.oocGame0 = gm;
                    [availTeams removeObjectAtIndex:selTeam];
                } else if ( offsetOOC == 4 ) {
                    a.oocGame4 = gm;
                    b.oocGame4 = gm;
                    [availTeams removeObjectAtIndex:selTeam];
                } else if ( offsetOOC == 5 ) {
                    a.oocGame9 = gm;
                    b.oocGame9 = gm;
                    [availTeams removeObjectAtIndex:selTeam];
                }
            }
        }
    }

}

-(void)setUpSchedule {
    
    _robinWeek = 0;
    for (int r = 0; r < 9; ++r) {
        for (int g = 0; g < 5; ++g) {
            Team *a = _confTeams[(_robinWeek + g) % 9];
            Team *b;
            if ( g == 0 ) {
                b = _confTeams[9];
            } else {
                b = _confTeams[(9 - g + _robinWeek) % 9];
            }
            
            Game *gm;
            if ([HBSharedUtils randomValue] > 0.5) {
                gm = [Game
                      newGameWithHome:a away:b name:@"In Conf"];
            } else {
                gm = [Game
                      newGameWithHome:b away:a name:@"In Conf"];
            }
            
            [a.gameSchedule addObject:gm];
            [b.gameSchedule addObject:gm];
        }
        _robinWeek++;
    }
    
}


@end
