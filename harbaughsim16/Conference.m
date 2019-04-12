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
#import "Player.h"
#import "PlayerQB.h"
#import "PlayerRB.h"
#import "PlayerWR.h"
#import "PlayerK.h"
#import "PlayerOL.h"
#import "PlayerDL.h"
#import "PlayerLB.h"
#import "PlayerCB.h"
#import "PlayerTE.h"
#import "PlayerS.h"

@implementation Conference
@synthesize ccg,confName,confTeams,confFullName,confPrestige,allConferencePlayers,league,week,robinWeek;

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.confName = [aDecoder decodeObjectForKey:@"confName"];
        self.confPrestige = [aDecoder decodeIntForKey:@"confPrestige"];
        self.confTeams = [aDecoder decodeObjectForKey:@"confTeams"];
        self.ccg = [aDecoder decodeObjectForKey:@"ccg"];
        self.week = [aDecoder decodeIntForKey:@"week"];
        self.robinWeek = [aDecoder decodeIntForKey:@"robinWeek"];
        self.league = [aDecoder decodeObjectForKey:@"league"];
        
        if (![aDecoder containsValueForKey:@"allConferencePlayers"]) {
            self.allConferencePlayers = @{};
        } else {
            self.allConferencePlayers = [aDecoder decodeObjectForKey:@"allConferencePlayers"];
        }
        
        if (![aDecoder containsValueForKey:@"confFullName"]) {
            if ([self.confName isEqualToString:@"SOUTH"]) {
                self.confFullName = @"Southern";
            } else if ([self.confName isEqualToString:@"COWBY"]) {
                self.confFullName = @"Cowboy";
            } else if ([self.confName isEqualToString:@"NORTH"]) {
                self.confFullName = @"Northern";
            } else if ([self.confName isEqualToString:@"PACIF"]) {
                self.confFullName = @"Pacific";
            } else if ([self.confName isEqualToString:@"MOUNT"]) {
                self.confFullName = @"Mountain";
            } else if ([self.confName isEqualToString:@"LAKES"]) {
                self.confFullName = @"Lakes";
            } else {
                self.confFullName = @"Unknown";
            }
        } else {
            self.confFullName = [aDecoder decodeObjectForKey:@"confFullName"];
        }
        
        
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.confName forKey:@"confName"];
    [aCoder encodeObject:self.confFullName forKey:@"confFullName"];
    [aCoder encodeInt:self.confPrestige forKey:@"confPrestige"];
    [aCoder encodeObject:self.confTeams forKey:@"confTeams"];
    [aCoder encodeObject:self.league forKey:@"league"];
    [aCoder encodeObject:self.allConferencePlayers forKey:@"allConferencePlayers"];
    [aCoder encodeObject:self.ccg forKey:@"ccg"];
    [aCoder encodeInt:self.week forKey:@"week"];
    [aCoder encodeInt:self.robinWeek forKey:@"robinWeek"];

}

+(instancetype)newConferenceWithName:(NSString*)name fullName:(NSString*)fullName league:(League*)league {
    return [Conference newConferenceWithName:name fullName:fullName league:league prestige:75];
}

+(instancetype)newConferenceWithName:(NSString*)name fullName:(NSString*)fullName league:(League*)league prestige:(int)defPrest {
    Conference *conf = [[Conference alloc] init];
    if (conf) {
        conf.confName = name;
        conf.confFullName = fullName;
        conf.confPrestige = defPrest;
        conf.confTeams = [NSMutableArray array];
        conf.allConferencePlayers = [NSDictionary dictionary];
        conf.league = league;
        conf.week = 0;
        conf.robinWeek = 0;
    }
    return conf;
}

-(NSString*)getCCGString {
    if (self.ccg == nil) {
        // Give prediction, find top 2 teams
        Team *team1 = nil, *team2 = nil;
        int score1 = 0, score2 = 0;
        for (int i = [NSNumber numberWithInteger:self.confTeams.count].intValue - 1; i >= 0; --i) { //count backwards so higher ranked teams are predicted
            Team *t = self.confTeams[i];
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
        return [NSString stringWithFormat:@"%@ Conference Championship:\n\t\t%@ vs %@", self.confName,
        [team1 strRep], [team2 strRep]];
    } else {
        if (!self.ccg.hasPlayed) {
            return [NSString stringWithFormat:@"%@ Conference Championship:\n\t\t%@ vs %@", self.confName, [self.ccg.homeTeam strRep], [self.ccg.awayTeam strRep]];
        } else {
            NSString *sb = @"";
            Team *winner, *loser;
            sb = [self.confName stringByAppendingString:@" Conference Championship:\n"];
            if (self.ccg.homeScore > self.ccg.awayScore) {
                winner = self.ccg.homeTeam;
                loser = self.ccg.awayTeam;
                sb = [sb stringByAppendingString:[[winner strRep] stringByAppendingString:@" W "]];
                sb = [sb stringByAppendingString:[NSString stringWithFormat:@"%ld - %ld,",(long)self.ccg.homeScore, (long)self.ccg.awayScore]];
                sb = [sb stringByAppendingString:[NSString stringWithFormat:@"vs %@", [loser strRep]]];
                //sb.append("vs " + [loser strRep]);
                return sb;
            } else {
                winner = self.ccg.awayTeam;
                loser = self.ccg.homeTeam;
                sb = [sb stringByAppendingString:[[winner strRep] stringByAppendingString:@" W "]];
                sb = [sb stringByAppendingString:[NSString stringWithFormat:@"%ld - %ld,",(long)self.ccg.homeScore, (long)self.ccg.awayScore]];
                sb = [sb stringByAppendingString:[NSString stringWithFormat:@"@ %@", [loser strRep]]];
                return sb;
            }
        }
    }

}

-(void)playConfChamp {
    [self.ccg playGame];
     if (self.ccg.homeScore > self.ccg.awayScore) {
         self.confTeams[0].confChampion = @"CC";
         self.confTeams[1].confChampion = @"CL";
         self.confTeams[0].totalCCs++;
         [self.confTeams[0] getCurrentHC].totalCCs++;
         self.confTeams[1].totalCCLosses++;
         [self.confTeams[1] getCurrentHC].totalCCLosses++;
         NSMutableArray *week13 = self.league.newsStories[13];
         [week13 addObject:[NSString stringWithFormat:@"%@ wins the %@!\n%@ took care of business in the conference championship against %@, winning at home with a score of %ld to %ld.",self.ccg.homeTeam.name, self.confName, self.ccg.homeTeam.strRep, self.ccg.awayTeam.strRep, (long)self.ccg.homeScore, (long)self.ccg.awayScore]];
     } else {
         self.confTeams[1].confChampion = @"CC";
         self.confTeams[0].confChampion = @"CL";
         self.confTeams[1].totalCCs++;
         [self.confTeams[1] getCurrentHC].totalCCs++;
         self.confTeams[0].totalCCLosses++;
         [self.confTeams[0] getCurrentHC].totalCCLosses++;
         NSMutableArray *week13 = self.league.newsStories[13];
         [week13 addObject:[NSString stringWithFormat:@"%@ wins the %@!\n%@ surprised many in the conference championship against %@, winning on the road with a score of %ld to %ld.",self.ccg.awayTeam.name, self.confName, self.ccg.awayTeam.strRep, self.ccg.homeTeam.strRep, (long)self.ccg.awayScore, (long)self.ccg.homeScore]];
     }
     self.confTeams = [[self.confTeams sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
         Team *a = (Team*)obj1;
         Team *b = (Team*)obj2;
         return a.teamPollScore > b.teamPollScore ? -1 : a.teamPollScore == b.teamPollScore ? 0 : 1;
     
     }] mutableCopy];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"newNewsStory" object:nil];
}

-(void)scheduleConfChamp {
    [self sortConfTeams];
     
    self.ccg = [Game newGameWithHome:self.confTeams[0]  away:self.confTeams[1] name:[NSString stringWithFormat:@"%@ CCG", self.confName]];
    [self.confTeams[0].gameSchedule addObject:self.ccg];
    [self.confTeams[1].gameSchedule addObject:self.ccg];
}

-(void)sortConfTeams {
    for ( int i = 0; i < self.confTeams.count; ++i ) {
        [self.confTeams[i] updatePollScore];
    }

    [self.confTeams sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Team *a = (Team*)obj1;
        Team *b = (Team*)obj2;
        if ([a.confChampion isEqualToString:@"CC"]) return -1;
        else if ([b.confChampion isEqualToString:@"CC"]) return 1;
        else if ([a calculateConfWins] > [b calculateConfWins]) {
            return -1;
        } else if ([b calculateConfWins] > [a calculateConfWins]) {
            return 1;
        } else {
            //check for h2h tiebreaker
            if ([a.gameWinsAgainst containsObject:b]) {
                return -1;
            } else if ([b.gameWinsAgainst containsObject:a]) {
                return 1;
            } else {
                return 0;
            }
        }
    }];
    
    int winsFirst = [self.confTeams[0] calculateConfWins];
    Team *t = self.confTeams[0];
    NSInteger i = 0;
    NSMutableArray<Team*> *teamTB = [NSMutableArray array];
    while ([t calculateConfWins] == winsFirst) {
        [teamTB addObject:t];
        ++i;
        if (i < self.confTeams.count) {
            t = self.confTeams[i];
        } else {
            break;
        }
    }
    if (teamTB.count > 2) {
        // ugh 3 way tiebreaker
        [teamTB sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [HBSharedUtils comparePlayoffTeams:obj1 toObj2:obj2];
        }];
        for (int j = 0; j < teamTB.count; ++j) {
            [self.confTeams replaceObjectAtIndex:j withObject:teamTB[j]];
        }
        
    }
    
    int winsSecond = [self.confTeams[1] calculateConfWins];
    t = self.confTeams[1];
    i = 1;
    [teamTB removeAllObjects];
    while ([t calculateConfWins] == winsSecond) {
        [teamTB addObject:t];
        ++i;
        if (i < self.confTeams.count) {
            t = self.confTeams[i];
        } else {
            break;
        }
    }
    if (teamTB.count > 2) {
        // ugh 3 way tiebreaker
        [teamTB sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [HBSharedUtils comparePlayoffTeams:obj1 toObj2:obj2];
        }];
        for (int j = 0; j < teamTB.count; ++j) {
            [self.confTeams replaceObjectAtIndex:(j+1) withObject:teamTB[j]];
        }
        
    }
}

-(Game*)ccgPrediction {
    if (!self.ccg) { // ccg hasn't been scheduled so we can project it
        [self sortConfTeams];
        
        return [Game newGameWithHome:self.confTeams[0]  away:self.confTeams[1] name:[NSString stringWithFormat:@"%@ CCG", self.confName]];
    } else { //ccg has been scheduled/played so send that forward
        return self.ccg;
    }
}

-(void)playWeek {
    if ( self.week == 12 ) {
        [self playConfChamp];
    } else {
        for (Team *t in confTeams) {
            [t.gameSchedule[self.week] playGame];
        }
        if (self.week == 11 ) [self scheduleConfChamp];
        self.week++;
    }
}

-(void)insertOOCSchedule {
    for (int i = 0; i < self.confTeams.count; ++i) {
        [[self.confTeams[i] gameSchedule] insertObject:[self.confTeams[i] oocGame0] atIndex:0];
        [[self.confTeams[i] gameSchedule] insertObject:[self.confTeams[i] oocGame4] atIndex:4];
        [[self.confTeams[i] gameSchedule] insertObject:[self.confTeams[i] oocGame9] atIndex:9];
    }
}

-(void)setUpOOCSchedule {
    
    //schedule OOC games
    NSInteger confNum = [self.league.conferences indexOfObject:self];
    if (confNum > 2)
        confNum = -1;
    
    if ( confNum != -1 ) {
        for ( int offsetOOC = 3; offsetOOC < 6; ++offsetOOC ) {
            NSMutableArray<Team*> *availTeams = [NSMutableArray array];
            int selConf = (int)confNum + offsetOOC;
            if (selConf == 6) selConf = 3;
            if (selConf == 7) selConf = 4;
            if (selConf == 8) selConf = 5;
            
            for (int i = 0; i < 10; ++i) {
                [availTeams addObject:self.league.conferences[selConf].confTeams[i]];
            }
            
            for (int i = 0; i < 10; ++i) {
                int selTeam = (int)([HBSharedUtils randomValue] * availTeams.count);
                Team *a = self.confTeams[i];
                Team *b = availTeams[selTeam];
                
                Game *gm;
                if (offsetOOC % 2 == 0) {
                    gm = [Game newGameWithHome:a away:b name:[NSString stringWithFormat:@"%@ vs %@",[b.conference substringWithRange:NSMakeRange(0, MIN(3, b.conference.length))],[a.conference substringWithRange:NSMakeRange(0, MIN(3, a.conference.length))]]];
                } else {
                    gm = [Game newGameWithHome:b away:a name:[NSString stringWithFormat:@"%@ vs %@",[a.conference substringWithRange:NSMakeRange(0, MIN(3, a.conference.length))],[b.conference substringWithRange:NSMakeRange(0, MIN(3, b.conference.length))]]];
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

-(NSString *)confShortName {
    return [self.confName substringWithRange:NSMakeRange(0, 3)];
}

-(void)setUpSchedule {
    int confRoundWeek = 0;
    for (int r = 0; r < 9; ++r) {
        for (int g = 0; g < 5; ++g) {
            Team *a = self.confTeams[(confRoundWeek + g) % 9];
            Team *b;
            if ( g == 0 ) {
                b = self.confTeams[9];
            } else {
                b = self.confTeams[(9 - g + confRoundWeek) % 9];
            }
            
            Game *gm;
            if (r % 2 == 0) {
                gm = [Game
                      newGameWithHome:a away:b name:@"In Conf"];
            } else {
                gm = [Game
                      newGameWithHome:b away:a name:@"In Conf"];
            }
            
            [a.gameSchedule addObject:gm];
            [b.gameSchedule addObject:gm];
        }
        confRoundWeek++;
    }
}

-(void)refreshAllConferencePlayers {
    NSMutableArray *leadingHCs = [NSMutableArray array];
    NSMutableArray *leadingQBs = [NSMutableArray array];
    NSMutableArray *leadingRBs = [NSMutableArray array];
    NSMutableArray *leadingWRs = [NSMutableArray array];
    NSMutableArray *leadingTEs = [NSMutableArray array];
    NSMutableArray *leadingDLs = [NSMutableArray array];
    NSMutableArray *leadingLBs = [NSMutableArray array];
    NSMutableArray *leadingCBs = [NSMutableArray array];
    NSMutableArray *leadingSs = [NSMutableArray array];
    NSMutableArray *leadingKs = [NSMutableArray array];
    
    for (Team *t in self.confTeams) {
        [leadingHCs addObject:[t getCurrentHC]];
        [leadingQBs addObject:[t getQB:0]];
        
        [leadingRBs addObject:[t getRB:0]];
        [leadingRBs addObject:[t getRB:1]];
        
        [leadingWRs addObject:[t getWR:0]];
        [leadingWRs addObject:[t getWR:1]];
        [leadingWRs addObject:[t getWR:2]];
        
        [leadingTEs addObject:[t getTE:0]];
        
        [leadingDLs addObject:[t getDL:0]];
        [leadingDLs addObject:[t getDL:1]];
        [leadingDLs addObject:[t getDL:2]];
        [leadingDLs addObject:[t getDL:3]];
        
        [leadingLBs addObject:[t getLB:0]];
        [leadingLBs addObject:[t getLB:1]];
        [leadingLBs addObject:[t getLB:2]];
        
        [leadingCBs addObject:[t getCB:0]];
        [leadingCBs addObject:[t getCB:1]];
        [leadingCBs addObject:[t getCB:2]];
        
        [leadingSs addObject:[t getS:0]];
        
        [leadingKs addObject:[t getK:0]];
    }
    
    [leadingHCs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [HBSharedUtils compareCoachScore:obj1 toObj2:obj2];
    }];
    
    [leadingQBs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Player *a = (Player*)obj1;
        Player *b = (Player*)obj2;
        if (a.isHeisman || a.isROTY) return -1;
        else if (b.isHeisman || b.isROTY) return 1;
        else return [a getHeismanScore] > [b getHeismanScore] ? -1 : [a getHeismanScore] == [b getHeismanScore] ? 0 : 1;
    }];
    
    [leadingRBs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Player *a = (Player*)obj1;
        Player *b = (Player*)obj2;
        if (a.isHeisman || a.isROTY) return -1;
        else if (b.isHeisman || b.isROTY) return 1;
        else return [a getHeismanScore] > [b getHeismanScore] ? -1 : [a getHeismanScore] == [b getHeismanScore] ? 0 : 1;
    }];
    
    [leadingWRs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Player *a = (Player*)obj1;
        Player *b = (Player*)obj2;
        if (a.isHeisman || a.isROTY) return -1;
        else if (b.isHeisman || b.isROTY) return 1;
        else return [a getHeismanScore] > [b getHeismanScore] ? -1 : [a getHeismanScore] == [b getHeismanScore] ? 0 : 1;
    }];
    
    [leadingTEs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Player *a = (Player*)obj1;
        Player *b = (Player*)obj2;
        if (a.isHeisman || a.isROTY) return -1;
        else if (b.isHeisman || b.isROTY) return 1;
        else return [a getHeismanScore] > [b getHeismanScore] ? -1 : [a getHeismanScore] == [b getHeismanScore] ? 0 : 1;
    }];
    
    [leadingDLs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Player *a = (Player*)obj1;
        Player *b = (Player*)obj2;
        if (a.isHeisman || a.isROTY) return -1;
        else if (b.isHeisman || b.isROTY) return 1;
        else return [a getHeismanScore] > [b getHeismanScore] ? -1 : [a getHeismanScore] == [b getHeismanScore] ? 0 : 1;
    }];
    
    [leadingLBs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Player *a = (Player*)obj1;
        Player *b = (Player*)obj2;
        if (a.isHeisman || a.isROTY) return -1;
        else if (b.isHeisman || b.isROTY) return 1;
        else return [a getHeismanScore] > [b getHeismanScore] ? -1 : [a getHeismanScore] == [b getHeismanScore] ? 0 : 1;
    }];
    
    [leadingCBs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Player *a = (Player*)obj1;
        Player *b = (Player*)obj2;
        if (a.isHeisman || a.isROTY) return -1;
        else if (b.isHeisman || b.isROTY) return 1;
        else return [a getHeismanScore] > [b getHeismanScore] ? -1 : [a getHeismanScore] == [b getHeismanScore] ? 0 : 1;
    }];
    
    [leadingSs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Player *a = (Player*)obj1;
        Player *b = (Player*)obj2;
        if (a.isHeisman || a.isROTY) return -1;
        else if (b.isHeisman || b.isROTY) return 1;
        else return [a getHeismanScore] > [b getHeismanScore] ? -1 : [a getHeismanScore] == [b getHeismanScore] ? 0 : 1;
    }];
    
    [leadingKs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        PlayerK *a = (PlayerK*)obj1;
        PlayerK *b = (PlayerK*)obj2;
        if (a.isHeisman || a.isROTY) return -1;
        else if (b.isHeisman || b.isROTY) return 1;
        else return [a getHeismanScore] > [b getHeismanScore] ? -1 : [a getHeismanScore] == [b getHeismanScore] ? 0 : 1;
    }];
    
    HeadCoach *hc = leadingHCs[0];
    hc.careerConfCOTYs++;
    hc.wonConfHC = YES;
    
    PlayerQB *qb = leadingQBs[0];
    qb.careerAllConferences++;
    [qb.team getCurrentHC].totalAllConferences++;
    qb.isAllConference = YES;
    
    PlayerRB *rb1 = leadingRBs[0];
    rb1.careerAllConferences++;
    [rb1.team getCurrentHC].totalAllConferences++;
    rb1.isAllConference = YES;
    
    PlayerRB *rb2 = leadingRBs[1];
    rb2.careerAllConferences++;
    [rb2.team getCurrentHC].totalAllConferences++;
    rb2.isAllConference = YES;
    
    PlayerWR *wr1 = leadingWRs[0];
    wr1.careerAllConferences++;
    [wr1.team getCurrentHC].totalAllConferences++;
    wr1.isAllConference = YES;
    
    PlayerWR *wr2 = leadingWRs[1];
    wr2.careerAllConferences++;
    [wr2.team getCurrentHC].totalAllConferences++;
    wr2.isAllConference = YES;
    
    PlayerWR *wr3 = leadingWRs[2];
    wr3.careerAllConferences++;
    [wr3.team getCurrentHC].totalAllConferences++;
    wr3.isAllConference = YES;
    
    PlayerTE *te = leadingTEs[0];
    te.careerAllConferences++;
    [te.team getCurrentHC].totalAllConferences++;
    te.isAllConference = YES;
    
    PlayerDL *dl1 = leadingDLs[0];
    dl1.careerAllConferences++;
    [dl1.team getCurrentHC].totalAllConferences++;
    dl1.isAllConference = YES;
    
    PlayerDL *dl2 = leadingDLs[1];
    dl2.careerAllConferences++;
    [dl2.team getCurrentHC].totalAllConferences++;
    dl2.isAllConference = YES;
    
    PlayerDL *dl3 = leadingDLs[2];
    dl3.careerAllConferences++;
    [dl3.team getCurrentHC].totalAllConferences++;
    dl3.isAllConference = YES;
    
    PlayerDL *dl4 = leadingDLs[3];
    dl4.careerAllConferences++;
    [dl4.team getCurrentHC].totalAllConferences++;
    dl4.isAllConference = YES;
    
    PlayerLB *lb1 = leadingLBs[0];
    lb1.careerAllConferences++;
    [lb1.team getCurrentHC].totalAllConferences++;
    lb1.isAllConference = YES;
    
    PlayerLB *lb2 = leadingLBs[1];
    lb2.careerAllConferences++;
    [lb2.team getCurrentHC].totalAllConferences++;
    lb2.isAllConference = YES;
    
    PlayerLB *lb3 = leadingLBs[2];
    lb3.careerAllConferences++;
    [lb3.team getCurrentHC].totalAllConferences++;
    lb3.isAllConference = YES;
    
    PlayerCB *cb1 = leadingCBs[0];
    cb1.careerAllConferences++;
    [cb1.team getCurrentHC].totalAllConferences++;
    cb1.isAllConference = YES;
    
    PlayerCB *cb2 = leadingCBs[1];
    cb2.careerAllConferences++;
    [cb2.team getCurrentHC].totalAllConferences++;
    cb2.isAllConference = YES;
    
    PlayerCB *cb3 = leadingCBs[2];
    cb3.careerAllConferences++;
    [cb3.team getCurrentHC].totalAllConferences++;
    cb3.isAllConference = YES;
    
    PlayerS *s = leadingSs[0];
    s.careerAllConferences++;
    [s.team getCurrentHC].totalAllConferences++;
    s.isAllConference = YES;
    
    PlayerK *k = leadingKs[0];
    k.careerAllConferences++;
    [k.team getCurrentHC].totalAllConferences++;
    k.isAllConference = YES;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"awardsPosted" object:nil];

    self.allConferencePlayers = @{
                           @"HC" : @[hc],
                           @"QB" : @[qb],
                           @"RB" : @[rb1,rb2],
                           @"WR" : @[wr1,wr2,wr3],
                           @"TE" : @[te],
                           @"DL" : @[dl1,dl2,dl3,dl4],
                           @"LB" : @[lb1,lb2,lb3],
                           @"CB" : @[cb1,cb2,cb3],
                           @"S" : @[s],
                           @"K"  : @[k]
                           };
    
}

-(NSString *)conferenceMetadataJSON {
    NSMutableString *jsonString = [NSMutableString string];
    [jsonString appendString:@"{"];
    [jsonString appendFormat:@"\"confName\" : \"%@\", \"confFullName\" : \"%@\", \"confPrestige\" : \"%d\", \"confTeams\" : [",confName, confFullName,confPrestige];
    for (Team *t in confTeams) {
        [jsonString appendFormat:@"%@,",[t teamMetadataJSON]];
    }
    
    NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@","];
    jsonString = [NSMutableString stringWithString:[jsonString stringByTrimmingCharactersInSet:charSet]];
    [jsonString appendString:@"]"];
    [jsonString appendString:@"}"];
    return jsonString;
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
        NSLog(@"[Importing Conference Metadata] JSON is of invalid type");
        return;
    }
    
    if (!error) {
        if ([league isConfAbbrValid:jsonDict[@"confName"] allowOverwrite:YES]) {
            confName = jsonDict[@"confName"];
        }
        
        if ([league isConfNameValid:jsonDict[@"confFullName"] allowOverwrite:YES]) {
            confFullName = jsonDict[@"confFullName"];
        }
        
        if ([HBSharedUtils isValidNumber:jsonDict[@"confPrestige"]])
        {
            NSLog(@"[Importing Conference Metadata] Changing conf prestige for %@ from base value of %d", confName, confPrestige);
            NSNumber *prestige = [[HBSharedUtils prestigeNumberFormatter] numberFromString:jsonDict[@"confPrestige"]];
            if (prestige.intValue > 95) {
                confPrestige = 95;
            } else if (prestige.intValue < 25) {
                confPrestige = 25;
            } else {
                confPrestige = prestige.intValue;
            }
            NSLog(@"[Importing Conference Metadata] New prestige for %@: %d", confName,confPrestige);
        }
        
        NSArray *jsonConfTeams = jsonDict[@"confTeams"];
        
        // rely on the file to tell us how many teams to change
        for (int i = 0; i < jsonConfTeams.count; i++) {
            [confTeams[i] applyJSONMetadataChanges:jsonConfTeams[i]];
            [confTeams[i] setConference:confName];
        }
    } else {
        NSLog(@"[Importing Conference Metadata] ERROR parsing conf metadata: %@", error);
    }
}

-(void)updateConfPrestige {
    int CP = 0;
    for (Team *t in confTeams) {
        CP += t.teamPrestige;
    }
    confPrestige = CP / confTeams.count;
}

-(NSString *)debugDescription {
    return [NSString stringWithFormat:@"%@ Conference (Week: %d, Robin Week: %d, Abbr: %@, Pres: %d) - Teams: %@", confFullName, week, robinWeek, confName, confPrestige, confTeams];
}

@end
