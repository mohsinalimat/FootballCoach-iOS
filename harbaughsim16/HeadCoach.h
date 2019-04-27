//
//  HeadCoach.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 12/21/18.
//  Copyright © 2018 Akshay Easwaran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AutoCoding.h"
#import "TeamStrategy.h"
#import "Team.h"
#import "HBSharedUtils.h"

NS_ASSUME_NONNULL_BEGIN

@interface HeadCoach : NSObject <NSCoding>
@property (strong, nonatomic) Team *team;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *position;
@property (strong, nonatomic) NSString *homeState;
@property (strong, nonatomic) NSMutableDictionary *coachingHistoryDictionary;
@property (strong, nonatomic) NSMutableDictionary *prestigeHistoryDictionary; // { @"2019" : { @"team" : @"ATL", @"prestige" : 90 } } 
@property (nonatomic) int year;
@property (nonatomic) int startYear;
@property (nonatomic) int age;
@property (nonatomic) int ratOvr;
@property (nonatomic) int ratImprovement;
@property (nonatomic) int ratPot;
@property (nonatomic) int ratOff;
@property (nonatomic) int ratDef;
@property (nonatomic) int ratTalent;
@property (nonatomic) int ratDiscipline;
@property (nonatomic) int offStratNum;
@property (nonatomic) int defStratNum;
@property (nonatomic) int gamesCoached;
@property (nonatomic) int baselinePrestige;
@property (nonatomic) int cumulativePrestige;
@property (nonatomic) int contractYear;
@property (nonatomic) int contractLength;
@property (nonatomic) int totalRivalryWins;
@property (nonatomic) int totalRivalryLosses;
@property (nonatomic) int totalConfWins;
@property (nonatomic) int totalConfLosses;
@property (nonatomic) int totalWins;
@property (nonatomic) int totalLosses;
@property (nonatomic) int totalCCs;
@property (nonatomic) int totalNCs;
@property (nonatomic) int totalCCLosses;
@property (nonatomic) int totalNCLosses;
@property (nonatomic) int totalBowls;
@property (nonatomic) int totalBowlLosses;
@property (nonatomic) int totalHeismans;
@property (nonatomic) int totalAllAmericans;
@property (nonatomic) int totalAllConferences;
@property (nonatomic) int totalROTYs;
@property (nonatomic) int careerCOTYs;
@property (nonatomic) int careerConfCOTYs;
@property (nonatomic) int careerDraftPicks;
@property (nonatomic) BOOL retirement;
@property (nonatomic) BOOL wonConfHC;
@property (nonatomic) BOOL wonTopHC;
@property (nonatomic) BOOL promotionCandidate;

-(FCCoachStatus)getCoachStatus;
-(NSString *)getCoachStatusString;
-(int)getHCOverall;
-(NSString *)uniqueIdentifier;
-(NSString *)getInitialName;
-(int)getCoachScore;
-(int)getCoachCareerScore;
-(void)advanceSeason:(int)avgYards avgDefYards:(int)avgDefYards offTalent:(int)offTalent defTalent:(int)defTalent;
-(NSDictionary*)detailedCareerStats;
-(NSDictionary*)detailedRatings;
+(instancetype)newHC:(Team *)t name:(NSString *)nm stars:(int)stars year:(int)yr;
+(instancetype)newHC:(Team *)t name:(NSString *)nm stars:(int)stars year:(int)yr newHire:(BOOL)newHire;

-(NSString *)coachMetadataJSON;
-(NSInteger)importIdentifier;
-(void)applyJSONMetadataChanges:(id)json;

-(NSString *)coachAwardReportString;
-(NSString *)playerAwardReportString;
-(NSString *)teamsCoachedString;
-(void)updateCoachHistory;

-(NSString *)getCoachArchetype;
@end

NS_ASSUME_NONNULL_END
