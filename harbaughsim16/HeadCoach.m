//
//  HeadCoach.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 12/21/18.
//  Copyright © 2018 Akshay Easwaran. All rights reserved.
//

#import "HeadCoach.h"
#import "HBSharedUtils.h"
#import "Player.h"
#import "TeamStrategy.h"
#import "Record.h"

#import "AutoCoding.h"

@implementation HeadCoach

-(void)setWithCoder:(NSCoder *)aDecoder {
    [super setWithCoder:aDecoder];
    if (![aDecoder containsValueForKey:@"teamWins"]) {
        if (self.team != nil) {
            self.teamWins = self.team.wins;
        }
    }
    
    if (![aDecoder containsValueForKey:@"teamLosses"]) {
        if (self.team != nil) {
            self.teamLosses = self.team.losses;
        }
    }
}

+(instancetype)newHC:(Team *)t name:(NSString *)nm stars:(int)stars year:(int)yr {
    HeadCoach *hc = [HeadCoach new];
    hc.name = nm;
    hc.year = 0;
    hc.team = t;
    hc.startYear = (int)[t.league getCurrentYear];
    hc.homeState = [HBSharedUtils randomState];
    hc.age = 30 + (int) ([HBSharedUtils randomValue] * 28);
    hc.contractYear = (int)(6 * [HBSharedUtils randomValue]);
    hc.contractLength = 6;
    hc.ratPot = (int) (50 + 50 * [HBSharedUtils randomValue]);
    hc.ratOff = (int) (50 + stars * 5 - 15 * [HBSharedUtils randomValue] + 15 * [HBSharedUtils randomValue]);
    hc.ratDef = (int) (50 + stars * 5 - 15 * [HBSharedUtils randomValue] + 15 * [HBSharedUtils randomValue]);
    hc.ratTalent = (int) (45 + 50 * [HBSharedUtils randomValue]);
    hc.ratDiscipline = (int) (45 + 50 * [HBSharedUtils randomValue]);
    hc.ratOvr = [hc getHCOverall];
    hc.offStratNum = (int) ([HBSharedUtils randomValue] * [hc.team getOffensiveTeamStrategies].count);
    hc.defStratNum = (int) ([HBSharedUtils randomValue] * [hc.team getDefensiveTeamStrategies].count);
    hc.baselinePrestige = t.teamPrestige;
    hc.totalWins = 0;
    hc.totalLosses = 0;
    hc.totalRivalryWins = 0;
    hc.totalRivalryLosses = 0;
    hc.teamWins = 0;
    hc.teamLosses = 0;
    hc.totalCCs = 0;
    hc.totalCCLosses = 0;
    hc.totalNCs = 0;
    hc.totalNCLosses = 0;
    hc.totalBowls = 0;
    hc.totalBowlLosses = 0;
    hc.totalAllAmericans = 0;
    hc.totalAllConferences = 0;
    hc.careerConfCOTYs = 0;
    hc.careerCOTYs = 0;
    hc.cumulativePrestige = 0;
    hc.totalROTYs = 0;
    hc.careerDraftPicks = 0;
    hc.retirement = NO;
    hc.wonTopHC = NO;
    hc.wonConfHC = NO;
    hc.coachingHistoryDictionary = [NSMutableDictionary dictionary];
    hc.prestigeHistoryDictionary = [NSMutableDictionary dictionary];

    return hc;
}

+(instancetype)newHC:(Team *)t name:(NSString *)nm stars:(int)stars year:(int)yr newHire:(BOOL)newHire {
    HeadCoach *hc = [HeadCoach newHC:t name:nm stars:stars year:yr];
    hc.promotionCandidate = !newHire;
    return hc;
}

-(void)advanceSeason:(int)avgYards avgDefYards:(int)avgDefYards offTalent:(int)offTalent defTalent:(int)defTalent {
    int prestigeDiff = [self.team calculatePrestigeChange];
    
    int oldOvr = [self getHCOverall];
    self.age++;
    self.year++;
    self.contractYear++;
    
    double off = (double)self.team.teamYards - avgYards;
    double def = avgDefYards - (double)self.team.teamOppYards;
    double offTal = self.team.diffOffTalent;
    double defTal = self.team.diffDefTalent;
    
    double offensiveMultiplier = (self.team.league.isHardMode) ? ([HBSharedUtils randomValue] * 2.5) : 4;
    double defensiveMultiplier = (self.team.league.isHardMode) ? ([HBSharedUtils randomValue] * 2.5) : 4;
    
    double offpts = ((off / avgYards) + (offTal / offTalent)) * offensiveMultiplier;
    double defpts = ((def / avgDefYards) + (defTal / defTalent)) * defensiveMultiplier;
    double coachScore = ([self getCoachScore] - [self.team.league findConference:self.team.conference].confPrestige)/10;
    if (coachScore < -4) coachScore = -4;
    
    self.ratOff += (2*prestigeDiff + offpts + coachScore + 2*(self.ratPot / 10))/6;
    if (self.ratOff > 95) self.ratOff = 95;
    if (self.ratOff < 20) self.ratOff = 20;
    
    self.ratDef += (2*prestigeDiff + defpts + coachScore + 2*(self.ratPot / 10))/6;
    if (self.ratDef > 95) self.ratDef = 95;
    if (self.ratDef < 20) self.ratDef = 20;
    
    self.ratTalent += (prestigeDiff + coachScore + self.ratPot)/3;
    if (self.ratTalent > 95) self.ratTalent = 95;
    if (self.ratTalent < 20) self.ratTalent = 20;
    
    if (self.age > 65 && !self.team.isUserControlled) {
        self.ratOff -= (int) ([HBSharedUtils randomValue] * 4);
        self.ratDef -= (int) ([HBSharedUtils randomValue] * 4);
        self.ratTalent -= (int) ([HBSharedUtils randomValue] * 4);
        self.ratDiscipline -= (int) ([HBSharedUtils randomValue] * 4);
    }
    
    if (self.age > 70 && self.team.isUserControlled && self.team.league.isCareerMode) {
        self.ratOff -= (int) ([HBSharedUtils randomValue] * (self.age / 20));
        self.ratDef -= (int) ([HBSharedUtils randomValue] * (self.age / 20));
        self.ratTalent -= (int) ([HBSharedUtils randomValue] * (self.age / 20));
        self.ratDiscipline -= (int) ([HBSharedUtils randomValue] * (self.age / 20));
    }
    
    if (self.ratDiscipline > 90) self.ratDiscipline = 90;
    if (self.ratDiscipline < 15) self.ratDiscipline = 15;
    
    self.ratOvr = [self getHCOverall];
    self.ratImprovement = self.ratOvr - oldOvr;

    self.cumulativePrestige += prestigeDiff;
}

-(int)getHCOverall {
    self.ratOvr = (self.ratOff + self.ratDef + self.ratTalent + self.ratDiscipline) / 4;
    return self.ratOvr;
}

-(FCCoachStatus)getCoachStatus {
    FCCoachStatus status = FCCoachStatusNormal;
    if (self.contractYear > 0) {
        if ((self.baselinePrestige + 7) < self.team.teamPrestige) status = FCCoachStatusSecure;
        else if ((self.baselinePrestige + 3) < self.team.teamPrestige) status = FCCoachStatusSafe;
        else if (self.baselinePrestige > (self.team.teamPrestige + 3)) status = FCCoachStatusUnsafe;
        else if (self.baselinePrestige > (self.team.teamPrestige + 5)) status = FCCoachStatusHotSeat;
        else status = FCCoachStatusOk; // appears if prestige delta is [-3, +3]
    }
    
    return status;
}

-(NSString *)getCoachStatusString {
    FCCoachStatus status = [self getCoachStatus];
    switch (status) {
        case FCCoachStatusNormal:
            return @"Normal";
            break;
        case FCCoachStatusOk:
            return @"Ok";
            break;
        case FCCoachStatusUnsafe:
            return @"Unsafe";
            break;
        case FCCoachStatusSafe:
            return @"Safe";
            break;
        case FCCoachStatusHotSeat:
            return @"Hot Seat";
            break;
        case FCCoachStatusSecure:
            return @"Secure";
            break;
        default:
            return @"Unknown";
            break;
    }
}

-(NSString *)uniqueIdentifier {
    int h = 0;
    
    for (int i = 0; i < (int)self.name.length; i++) {
        h = (31 * h) + [self.name characterAtIndex:i];
    }
    
    return [NSString stringWithFormat:@"%d",h];
}

-(NSDictionary*)detailedStats:(int)games {
    return [NSDictionary dictionary];
}

-(NSDictionary*)detailedCareerStats {
    NSMutableDictionary *stats = [NSMutableDictionary dictionary];
    [stats setObject:[NSString stringWithFormat:@"%d",self.year] forKey:@"yearsCoachedFor"];
    [stats setObject:[NSString stringWithFormat:@"%d",self.totalWins] forKey:@"totalWins"];
    [stats setObject:[NSString stringWithFormat:@"%d",self.totalLosses] forKey:@"totalLosses"];
    [stats setObject:[NSString stringWithFormat:@"%d",self.totalConfWins] forKey:@"totalConfWins"];
    [stats setObject:[NSString stringWithFormat:@"%d",self.totalConfLosses] forKey:@"totalConfLosses"];
    [stats setObject:[NSString stringWithFormat:@"%d",self.totalRivalryWins] forKey:@"totalRivalryWins"];
    [stats setObject:[NSString stringWithFormat:@"%d",self.totalRivalryLosses] forKey:@"totalRivalryLosses"];
    [stats setObject:[NSString stringWithFormat:@"%d",self.totalBowls] forKey:@"totalBowls"];
    [stats setObject:[NSString stringWithFormat:@"%d",self.totalBowlLosses] forKey:@"totalBowlLosses"];
    [stats setObject:[NSString stringWithFormat:@"%d",self.totalCCs] forKey:@"totalCCs"];
    [stats setObject:[NSString stringWithFormat:@"%d",self.totalCCLosses] forKey:@"totalCCLosses"];
    [stats setObject:[NSString stringWithFormat:@"%d",self.totalNCs] forKey:@"totalNCs"];
    [stats setObject:[NSString stringWithFormat:@"%d",self.totalNCLosses] forKey:@"totalNCLosses"];
    [stats setObject:[NSString stringWithFormat:@"%d",self.careerConfCOTYs] forKey:@"totalConfCOTYs"];
    [stats setObject:[NSString stringWithFormat:@"%d",self.careerCOTYs] forKey:@"totalCOTYs"];
    [stats setObject:[NSString stringWithFormat:@"%d",self.totalROTYs] forKey:@"totalROTYs"];
    [stats setObject:[NSString stringWithFormat:@"%d",self.careerDraftPicks] forKey:@"careerDraftPicks"];
    [stats setObject:[NSString stringWithFormat:@"%d",self.cumulativePrestige] forKey:@"cumulativePrestige"];
    [stats setObject:[NSString stringWithFormat:@"%d",self.teamWins] forKey:@"teamWins"];
    [stats setObject:[NSString stringWithFormat:@"%d",self.teamLosses] forKey:@"teamLosses"];
    return stats;
}

-(NSDictionary*)detailedRatings {
    return @{@"offensiveAbility" : [HBSharedUtils getLetterGrade:self.ratOff], @"defensiveAbility" : [HBSharedUtils getLetterGrade:self.ratDef],  @"talentProgression" : [HBSharedUtils getLetterGrade:self.ratTalent], @"discipline" :  [HBSharedUtils getLetterGrade:self.ratDiscipline], @"jobStatus" : [self getCoachStatusString],@"potential" : [HBSharedUtils getLetterGrade:self.ratPot],@"contractYearsLeft" : @(self.contractLength - self.contractYear - 1),@"contractLength" : @(self.contractLength), @"offensivePlaybook" : [self.team getOffensiveTeamStrategies][self.offStratNum].stratName,@"defensivePlaybook" : [self.team getDefensiveTeamStrategies][self.defStratNum].stratName, @"startYear" : @(self.startYear),@"age" : @(self.age),@"ratOvr" : @(self.ratOvr)};
}

-(NSString*)getInitialName {
    NSArray *names = [self.name componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *firstName = names[0];
    return [NSString stringWithFormat:@"%@. %@", [firstName substringWithRange:NSMakeRange(0, 1)], names[1]];
}

-(int)getCoachScore {
//    [self.team getSeasonSummaryString]; // just running this to generate the deltaPrestige
    int prestigeDiff = [self.team calculatePrestigeChange];
    return (prestigeDiff * 10) + (self.team.teamStrengthOfWins / 20) + (3 * self.team.wins) - self.team.losses + [self.team.league findConference:self.team.conference].confPrestige;
}

-(int)getCoachCareerScore {
    if (self.year < 1) return 0;
    else
        return ((5 * self.totalWins) - (2 * self.totalLosses) + (10 * self.totalNCs) + (3 * self.totalCCs) + (10 * self.careerCOTYs) + (3 * self.careerConfCOTYs) + self.totalAllConferences + (2 * self.totalAllAmericans) + (5 * self.cumulativePrestige));
}

-(NSString *)coachMetadataJSON {
    NSMutableString *jsonString = [NSMutableString string];
    [jsonString appendString:@"{"];
    [jsonString appendFormat:@"\"name\" : \"%@\", \"age\" : \"%d\", \"startYear\" : \"%d\", \"contractYear\" : \"%d\", \"contractLength\" : \"%d\", \"homeState\" : \"%@\", \"baselinePrestige\" : \"%d\", \"cumulativePrestige\" : \"%d\", \"ratOvr\" : \"%d\", \"ratDef\" : \"%d\", \"ratOff\" : \"%d\", \"ratTalent\" : \"%d\", \"ratDiscipline\" : \"%d\", \"ratPot\" : \"%d\"",self.name,self.age, self.startYear,self.contractYear, self.contractLength, self.homeState, self.baselinePrestige,self.cumulativePrestige,self.ratOvr,self.ratDef,self.ratOff,self.ratTalent,self.ratDiscipline,self.ratPot];
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
        NSLog(@"[Importing Coach Metadata] JSON is of invalid type");
        return;
    }
    
    if (!error) {
        self.name = [jsonDict[@"name"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        if ([jsonDict[@"baselinePrestige"] rangeOfCharacterFromSet:notDigits].location == NSNotFound)
        {
            NSLog(@"[Importing Coach Metadata] Changing baseline prestige for %@ from original value of %d", self.name, self.baselinePrestige);
            NSNumber *prestige = [[self numberFormatter] numberFromString:jsonDict[@"baselinePrestige"]];
            if (prestige.intValue > 95) {
                self.baselinePrestige = 95;
            } else if (prestige.intValue < 25) {
                self.baselinePrestige = 25;
            } else {
                self.baselinePrestige = prestige.intValue;
            }
            NSLog(@"[Importing Coach Metadata] New prestige for %@: %d", self.name,self.baselinePrestige);
        }
        
        if ([jsonDict[@"cumulativePrestige"] rangeOfCharacterFromSet:notDigits].location == NSNotFound)
        {
            NSLog(@"[Importing Coach Metadata] Changing cumulative prestige for %@ from original value of %d", self.name, self.cumulativePrestige);
            NSNumber *prestige = [[self numberFormatter] numberFromString:jsonDict[@"cumulativePrestige"]];
            if (prestige.intValue > 95) {
                self.cumulativePrestige = 95;
            } else if (prestige.intValue < 25) {
                self.cumulativePrestige = 25;
            } else {
                self.cumulativePrestige = prestige.intValue;
            }
            NSLog(@"[Importing Coach Metadata] New prestige for %@: %d", self.name,self.cumulativePrestige);
        }
        
        if ([jsonDict[@"startYear"] rangeOfCharacterFromSet:notDigits].location == NSNotFound)
        {
            NSLog(@"[Importing Coach Metadata] Changing start year for %@ from original value of %d", self.name, self.startYear);
            NSNumber *year = [[self numberFormatter] numberFromString:jsonDict[@"startYear"]];
            if (year.intValue > self.team.league.baseYear) {
                self.startYear = (int)self.team.league.baseYear;
            } else if (year.intValue < (self.team.league.baseYear - 85)) { // https://herosports.com/college-football/oldest-coaches-moglia-solich-mack-brown-ahah --> giving some room for coaches to be as old as 84
                self.startYear = (int)(self.team.league.baseYear - 85);
            } else {
                self.startYear = year.intValue;
            }
            NSLog(@"[Importing Coach Metadata] New start year for %@: %d", self.name,self.startYear);
        }
        
        if ([jsonDict[@"contractYear"] rangeOfCharacterFromSet:notDigits].location == NSNotFound)
        {
            NSLog(@"[Importing Coach Metadata] Changing contract year for %@ from original value of %d", self.name, self.contractYear);
            NSNumber *year = [[self numberFormatter] numberFromString:jsonDict[@"contractYear"]];
            if (year.intValue > 10) {
                self.contractYear = 10;
            } else if (year.intValue < 1) {
                self.contractYear = 1;
            } else {
                self.contractYear = year.intValue;
            }
            NSLog(@"[Importing Coach Metadata] New contract year for %@: %d", self.name,self.contractYear);
        }
        
        if ([jsonDict[@"contractLength"] rangeOfCharacterFromSet:notDigits].location == NSNotFound)
        {
            NSLog(@"[Importing Coach Metadata] Changing contract length for %@ from original value of %d", self.name, self.contractLength);
            NSNumber *year = [[self numberFormatter] numberFromString:jsonDict[@"contractLength"]];
            if (year.intValue > 10) {
                self.contractLength = 10;
            } else if (year.intValue < 1) {
                self.contractLength = 1;
            } else {
                self.contractLength = year.intValue;
            }
            NSLog(@"[Importing Coach Metadata] New contract length for %@: %d", self.name,self.contractLength);
        }
        
        if ([jsonDict[@"age"] rangeOfCharacterFromSet:notDigits].location == NSNotFound)
        {
            NSLog(@"[Importing Coach Metadata] Changing age for %@ from original value of %d", self.name, self.age);
            NSNumber *year = [[self numberFormatter] numberFromString:jsonDict[@"age"]];
            if (year.intValue > 80) {
                self.age = 80;
            } else if (year.intValue < 30) {
                self.age = 30;
            } else {
                self.age = year.intValue;
            }
            NSLog(@"[Importing Coach Metadata] New age for %@: %d", self.name,self.age);
        }
        
        if ([jsonDict[@"ratOvr"] rangeOfCharacterFromSet:notDigits].location == NSNotFound)
        {
            NSLog(@"[Importing Coach Metadata] Changing ratOvr for %@ from original value of %d", self.name, self.ratOvr);
            NSNumber *year = [[self numberFormatter] numberFromString:jsonDict[@"ratOvr"]];
            if (year.intValue > 95) {
                self.ratOvr = 95;
            } else if (year.intValue < 25) {
                self.ratOvr = 25;
            } else {
                self.ratOvr = year.intValue;
            }
            NSLog(@"[Importing Coach Metadata] New ratOvr for %@: %d", self.name,self.ratOvr);
        }
        
        if ([jsonDict[@"ratPot"] rangeOfCharacterFromSet:notDigits].location == NSNotFound)
        {
            NSLog(@"[Importing Coach Metadata] Changing ratPot for %@ from original value of %d", self.name, self.ratPot);
            NSNumber *year = [[self numberFormatter] numberFromString:jsonDict[@"ratPot"]];
            if (year.intValue > 95) {
                self.ratPot = 95;
            } else if (year.intValue < 25) {
                self.ratPot = 25;
            } else {
                self.ratPot = year.intValue;
            }
            NSLog(@"[Importing Coach Metadata] New ratPot for %@: %d", self.name,self.ratPot);
        }
        
        if ([jsonDict[@"ratOff"] rangeOfCharacterFromSet:notDigits].location == NSNotFound)
        {
            NSLog(@"[Importing Coach Metadata] Changing ratOff for %@ from original value of %d", self.name, self.ratOff);
            NSNumber *year = [[self numberFormatter] numberFromString:jsonDict[@"ratOff"]];
            if (year.intValue > 95) {
                self.ratOff = 95;
            } else if (year.intValue < 25) {
                self.ratOff = 25;
            } else {
                self.ratOff = year.intValue;
            }
            NSLog(@"[Importing Coach Metadata] New ratOff for %@: %d", self.name,self.ratOff);
        }
        
        if ([jsonDict[@"ratDef"] rangeOfCharacterFromSet:notDigits].location == NSNotFound)
        {
            NSLog(@"[Importing Coach Metadata] Changing ratDef for %@ from original value of %d", self.name, self.ratDef);
            NSNumber *year = [[self numberFormatter] numberFromString:jsonDict[@"ratDef"]];
            if (year.intValue > 95) {
                self.ratDef = 95;
            } else if (year.intValue < 25) {
                self.ratDef = 25;
            } else {
                self.ratDef = year.intValue;
            }
            NSLog(@"[Importing Coach Metadata] New ratDef for %@: %d", self.name,self.ratDef);
        }
        
        if ([jsonDict[@"ratTalent"] rangeOfCharacterFromSet:notDigits].location == NSNotFound)
        {
            NSLog(@"[Importing Coach Metadata] Changing ratTalent for %@ from original value of %d", self.name, self.ratTalent);
            NSNumber *year = [[self numberFormatter] numberFromString:jsonDict[@"ratTalent"]];
            if (year.intValue > 95) {
                self.ratTalent = 95;
            } else if (year.intValue < 25) {
                self.ratTalent = 25;
            } else {
                self.ratTalent = year.intValue;
            }
            NSLog(@"[Importing Coach Metadata] New ratTalent for %@: %d", self.name,self.ratTalent);
        }
        
        if ([jsonDict[@"ratDiscipline"] rangeOfCharacterFromSet:notDigits].location == NSNotFound)
        {
            NSLog(@"[Importing Coach Metadata] Changing ratDiscipline for %@ from original value of %d", self.name, self.ratDiscipline);
            NSNumber *year = [[self numberFormatter] numberFromString:jsonDict[@"ratDiscipline"]];
            if (year.intValue > 95) {
                self.ratDiscipline = 95;
            } else if (year.intValue < 25) {
                self.ratDiscipline = 25;
            } else {
                self.ratDiscipline = year.intValue;
            }
            NSLog(@"[Importing League Metadata] New ratDiscipline for %@: %d", self.name,self.ratDiscipline);
        }
        
        if ([self.team.league isStateValid:[jsonDict[@"state"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]) {
            self.homeState = [jsonDict[@"state"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        }
    
    } else {
        NSLog(@"[Importing Coach Metadata] ERROR parsing coach metadata: %@", error);
    }
}

-(NSInteger)importIdentifier {
    int h = 0;
    
    for (int i = 0; i < (int)self.name.length; i++) {
        h = (31 * h) + [self.name characterAtIndex:i];
    }
    
    return h;
}

-(NSString *)debugDescription {
    return [NSString stringWithFormat:@"%@ HC %@ [Age: %d, Ovr: %d]",self.team.abbreviation, self.name, self.age,self.ratOvr];
}

-(NSString *)description {
    return [self debugDescription];
}

-(NSString *)playerAwardReportString {
    NSMutableString *awards = [NSMutableString string];
    int parts = 0;
    if (self.totalROTYs > 0) {
        [awards appendFormat:@"%lix ROTY",(long)self.totalROTYs];
        parts++;
    }
    
    if (self.totalAllConferences > 0) {
        [awards appendFormat:@"?%lix All-Conference",(long)self.totalAllConferences];
        parts++;
    }
    
    if (self.totalAllAmericans > 0) {
        [awards appendFormat:@"?%lix All-League",(long)self.totalAllAmericans];
        parts++;
    }
    
    if (self.totalHeismans > 0) {
        [awards appendFormat:@"?%lix POTY",(long)self.totalHeismans];
        parts++;
    }
    
    if (self.careerDraftPicks > 0) {
        [awards appendFormat:@"?%li Drafted",(long)self.careerDraftPicks];
        parts++;
    }
    
    if (parts > 1) {
        [awards replaceOccurrencesOfString:@"?" withString:@", " options:NSCaseInsensitiveSearch range:NSMakeRange(0, awards.length)];
    } else {
        [awards replaceOccurrencesOfString:@"?" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, awards.length)];
    }
    
    awards = [NSMutableString stringWithString:[[awards stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    return (awards.length > 0) ? awards : @"None";
}

-(NSString *)coachAwardReportString {
    NSMutableString *awards = [NSMutableString string];
    int parts = 0;
    if (self.careerConfCOTYs > 0) {
        [awards appendFormat:@"%lix Conf COTY",(long)self.careerConfCOTYs];
        parts++;
    }
    
    if (self.careerCOTYs > 0) {
        [awards appendFormat:@"?%lix COTY",(long)self.careerCOTYs];
        parts++;
    }
    
    if (parts > 1) {
        [awards replaceOccurrencesOfString:@"?" withString:@", " options:NSCaseInsensitiveSearch range:NSMakeRange(0, awards.length)];
    } else {
        [awards replaceOccurrencesOfString:@"?" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, awards.length)];
    }
    
    awards = [NSMutableString stringWithString:[[awards stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    return (awards.length > 0) ? awards : @"None";
}


-(NSString *)teamsCoachedString {
    __block NSMutableString *awards = [NSMutableString string];
    __block int parts = 0;

    if (self.coachingHistoryDictionary.count > 0) {
        NSArray *keys = [self.coachingHistoryDictionary.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj1 compare:obj2];
        }];
        for (NSString *k in keys) {
            NSString *hist = self.coachingHistoryDictionary[k];
            NSArray *stringParts = [hist componentsSeparatedByString:@"\n"];
            NSString *teamInfo = (stringParts.count > 0) ? stringParts[0] : [NSString stringWithFormat:@"%@ (0-0)",self.team.abbreviation];
            
            NSError *error = NULL;
            NSRegularExpression *regex = [NSRegularExpression
                                          regularExpressionWithPattern:@"([A-Z])\\w+"
                                          options:NSRegularExpressionCaseInsensitive
                                          error:&error];
            [regex enumerateMatchesInString:teamInfo options:0 range:NSMakeRange(0, [teamInfo length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
                if (match != nil) {
                    NSString *matchedTeam = [teamInfo substringWithRange:match.range];
                    if (![awards containsString:matchedTeam]) {
                        [awards appendFormat:@"?%@",matchedTeam];
                        parts++;
                    }
                }
            }];
        }
    } else {
        [awards appendFormat:@"?%@",self.team.abbreviation];
        parts++;
    }
    
    if (parts > 1) {
        [awards replaceOccurrencesOfString:@"?" withString:@", " options:NSCaseInsensitiveSearch range:NSMakeRange(0, awards.length)];
    } else {
        [awards replaceOccurrencesOfString:@"?" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, awards.length)];
    }
    
    awards = [NSMutableString stringWithString:[[awards stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    return (awards.length > 0) ? awards : @"None";
}

-(void)updateCoachHistory {
    NSMutableString *hist = [NSMutableString string];
    
    if (self.team.rankTeamPollScore > 0 && self.team.rankTeamPollScore < 26) {
        [hist appendFormat:@"#%ld %@ (%ld-%ld)\nPrestige: %ld",(long)self.team.rankTeamPollScore, self.team.abbreviation, (long)self.team.wins, (long)self.team.losses, (long)self.team.teamPrestige];
    } else {
        [hist appendFormat:@"%@ (%ld-%ld)\nPrestige: %ld",self.team.abbreviation, (long)self.team.wins, (long)self.team.losses, (long)self.team.teamPrestige];
    }
    
    [hist appendFormat:@"\nCoach Score: %d", [self getCoachScore]];
    
    if (![self.team.confChampion isEqualToString:@""] && self.team.confChampion.length > 0) {
        Game *ccg = [self.team.league findConference:self.team.conference].ccg;
        if (self.team.gameWLSchedule.count >= 13) {
            if ([self.team.confChampion isEqualToString:@"CC"]) {
                [hist appendFormat:@"\n%@ - W %@",ccg.gameName,[self.team gameSummaryString:ccg]];
            } else {
                [hist appendFormat:@"\n%@ - L %@",ccg.gameName,[self.team gameSummaryString:ccg]];
            }
        }
    }
    
    if (self.team.gameSchedule.count > 12 && self.team.gameWLSchedule.count > 12) {
        if (![self.team.semifinalWL isEqualToString:@""] && self.team.semifinalWL.length > 0) {
            if ([self.team.semifinalWL isEqualToString:@"BW"] || [self.team.semifinalWL isEqualToString:@"BL"] || [self.team.semifinalWL containsString:@"SF"]) {
                if (self.team.gameSchedule.count > 12 && self.team.gameWLSchedule.count > 12) {
                    Game *bowl = self.team.gameSchedule[12];
                    if (bowl && ([bowl.gameName containsString:@"Bowl"] || [bowl.gameName containsString:@"Semis"])) {
                        [hist appendFormat:@"\n%@ - %@ %@",bowl.gameName,self.team.gameWLSchedule[12],[self.team gameSummaryString:bowl]];
                    }
                }
                
                if (self.team.gameSchedule.count > 13 && self.team.gameWLSchedule.count > 13) {
                    Game *bowl = self.team.gameSchedule[13];
                    if (bowl && ([bowl.gameName containsString:@"Bowl"] || [bowl.gameName containsString:@"Semis"])) {
                        [hist appendFormat:@"\n%@ - %@ %@",bowl.gameName,self.team.gameWLSchedule[13],[self.team gameSummaryString:bowl]];
                    }
                }
            }
        }
        
        if (![self.team.natlChampWL isEqualToString:@""] && self.team.natlChampWL.length > 0) {
            Game *ncg = self.team.league.ncg;
            [hist appendFormat:@"\n%@ - %@ %@",ncg.gameName,self.team.gameWLSchedule[self.team.gameWLSchedule.count - 1],[self.team gameSummaryString:ncg]];
        }
    }
    
    [self.coachingHistoryDictionary setObject:hist forKey:[NSString stringWithFormat:@"%ld",(long)([self.team.league getCurrentYear])]];
    [self.prestigeHistoryDictionary setObject:@{@"team" : self.team.abbreviation, @"prestige" : @(self.team.teamPrestige), @"coachScore" : @([self getCoachScore])} forKey:[NSString stringWithFormat:@"%ld",(long)([self.team.league getCurrentYear])]];
}

-(NSString *)getCoachArchetype {
    if (self.ratOff >= self.ratDef && self.ratOff >= self.ratTalent && self.ratOff >= self.ratDiscipline) {
        return @"Offensive Guru";
    } else if (self.ratDef >= self.ratTalent && self.ratDef >= self.ratDiscipline && self.ratDef >= self.ratOff) {
        return @"Defensive Wizard";
    } else if (self.ratTalent >= self.ratDiscipline && self.ratTalent >= self.ratOff && self.ratTalent >= self.ratDef) {
        return @"Talent Prospector";
    }
//    else if (self.ratDiscipline >= self.ratOff && self.ratDiscipline >= self.ratDef && self.ratDiscipline >= self.ratTalent) {
//        return @"Disciplinarian";
//    }
    else {
        return @"Players' Coach";
    }
}

-(void)checkCoachRecords {
    // Wins
    if (self.teamWins > self.team.careerCoachWinsRecord.statistic) {
        self.team.careerCoachWinsRecord = [Record newRecord:@"Total Wins With Team" coach:self stat:self.teamWins year:(int)([HBSharedUtils currentLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    if (self.totalWins > self.team.league.careerCoachWinsRecord.statistic) {
        self.team.league.careerCoachWinsRecord = [Record newRecord:@"Career Wins" coach:self stat:self.totalWins year:(int)([HBSharedUtils currentLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    // Conf Wins
    if (self.totalConfWins > self.team.careerCoachConfWinsRecord.statistic) {
        self.team.careerCoachConfWinsRecord = [Record newRecord:@"Conference Wins" coach:self stat:self.totalConfWins year:(int)([HBSharedUtils currentLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    if (self.totalWins > self.team.league.careerCoachWinsRecord.statistic) {
        self.team.league.careerCoachConfWinsRecord = [Record newRecord:@"Conference Wins" coach:self stat:self.totalConfWins year:(int)([HBSharedUtils currentLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    // Conf Titles
    if (self.totalCCs > self.team.careerCoachConfTitlesRecord.statistic) {
        self.team.careerCoachConfTitlesRecord = [Record newRecord:@"Conference Titles" coach:self stat:self.totalCCs year:(int)([HBSharedUtils currentLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    if (self.totalCCs > self.team.league.careerCoachConfTitlesRecord.statistic) {
        self.team.league.careerCoachConfTitlesRecord = [Record newRecord:@"Conference Titles" coach:self stat:self.totalCCs year:(int)([HBSharedUtils currentLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    // Natl Titles
    if (self.totalNCs > self.team.careerCoachNatlTitlesRecord.statistic) {
        self.team.careerCoachNatlTitlesRecord = [Record newRecord:@"National Titles" coach:self stat:self.totalNCs year:(int)([HBSharedUtils currentLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    if (self.totalNCs > self.team.league.careerCoachConfTitlesRecord.statistic) {
        self.team.league.careerCoachNatlTitlesRecord = [Record newRecord:@"National Titles" coach:self stat:self.totalNCs year:(int)([HBSharedUtils currentLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    // Rivalry Wins
    if (self.totalRivalryWins > self.team.careerCoachRivalryWinsRecord.statistic) {
        self.team.careerCoachRivalryWinsRecord = [Record newRecord:@"Rivalry Wins" coach:self stat:self.totalRivalryWins year:(int)([HBSharedUtils currentLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    if (self.totalRivalryWins > self.team.league.careerCoachConfTitlesRecord.statistic) {
        self.team.league.careerCoachRivalryWinsRecord = [Record newRecord:@"Rivalry Wins" coach:self stat:self.totalRivalryWins year:(int)([HBSharedUtils currentLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    // Bowl Wins
    if (self.totalBowls > self.team.careerCoachBowlWinsRecord.statistic) {
        self.team.careerCoachBowlWinsRecord = [Record newRecord:@"Bowl Wins" coach:self stat:self.totalBowls year:(int)([HBSharedUtils currentLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    if (self.totalBowls > self.team.league.careerCoachBowlWinsRecord.statistic) {
        self.team.league.careerCoachBowlWinsRecord = [Record newRecord:@"Bowl Wins" coach:self stat:self.totalBowls year:(int)([HBSharedUtils currentLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }
   
}

@end
