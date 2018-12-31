//
//  Team.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/16/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Conference.h"
#import "Game.h"
#import "TeamStrategy.h"
#import "HeadCoach.h"

@class Player;
@class League;
@class Record;

@class PlayerQB;
@class PlayerRB;
@class PlayerWR;
@class PlayerOL;
@class PlayerTE;
@class PlayerK;
@class PlayerDL;
@class PlayerLB;
@class PlayerCB;
@class PlayerS;
@class TeamStreak;


@interface Team : NSObject <NSCoding> {
    //deprecated ivars
    int teamRecordCompletions;
    int teamRecordPassYards;
    int teamRecordPassTDs;
    int teamRecordInt;
    int teamRecordFum;
    int teamRecordRushYards;
    int teamRecordRushAtt;
    int teamRecordRushTDs;
    int teamRecordRecYards;
    int teamRecordReceptions;
    int teamRecordRecTDs;
    int teamRecordXPMade;
    int teamRecordFGMade;
    int teamRecordYearCompletions;
    int teamRecordYearPassYards;
    int teamRecordYearPassTDs;
    int teamRecordYearInt;
    int teamRecordYearFum;
    int teamRecordYearRushYards;
    int teamRecordYearRushAtt;
    int teamRecordYearRushTDs;
    int teamRecordYearRecYards;
    int teamRecordYearReceptions;
    int teamRecordYearRecTDs;
    int teamRecordYearXPMade;
    int teamRecordYearFGMade;
    NSMutableDictionary<NSString*, NSMutableArray*> *teamStreaks;
}

@property (strong, nonatomic) League *league;

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *abbreviation;
@property (strong, nonatomic) NSString *state;

@property (strong, nonatomic) NSString *conference;
@property (strong, nonatomic) NSString *rivalTeam;
@property (strong, nonatomic) NSMutableDictionary *teamHistoryDictionary;
@property (strong, nonatomic) NSMutableArray *teamHistory;
@property (strong, nonatomic) NSMutableDictionary<NSString*, TeamStreak*> *streaks;
@property (nonatomic) BOOL isUserControlled;
@property (nonatomic) BOOL wonRivalryGame;
@property (nonatomic) int recruitingPoints;
@property (nonatomic) int usedRecruitingPoints;
@property (nonatomic) int numberOfRecruits;
@property (nonatomic) int heismans;
@property (nonatomic) int rotys;
@property (strong, nonatomic) NSMutableArray<Player*> *playersLeaving;
@property (strong, nonatomic) NSMutableArray<Player*> *hallOfFamers;
@property (strong, nonatomic) NSMutableArray<Player*> *playersTransferring;

@property (nonatomic) int wins;
@property (nonatomic) int losses;
@property (nonatomic) int rivalryWins;
@property (nonatomic) int rivalryLosses;
@property (nonatomic) int confWins;
@property (nonatomic) int confLosses;
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

@property (strong, nonatomic) NSMutableArray<Player*> *injuredPlayers;
@property (strong, nonatomic) NSMutableArray<Player*> *recoveredPlayers;
@property (strong, nonatomic) NSMutableArray<Game*> *gameSchedule;
@property (strong, nonatomic) NSMutableArray<Player *> *recruitingClass;
@property (strong, nonatomic) NSMutableArray<Player *> *transferClass;

@property (strong, nonatomic) Game *oocGame0;
@property (strong, nonatomic) Game *oocGame4;
@property (strong, nonatomic) Game *oocGame9;
@property (strong, nonatomic) NSMutableArray<NSString*> *gameWLSchedule;
@property (strong, nonatomic) NSMutableArray<Team*> *gameWinsAgainst;
@property (strong, nonatomic) NSString *confChampion;
@property (strong, nonatomic) NSString *semifinalWL;
@property (strong, nonatomic) NSString *natlChampWL;

//Team stats
@property (nonatomic) int teamPoints;
@property (nonatomic) int teamOppPoints;
@property (nonatomic) int teamYards;
@property (nonatomic) int teamOppYards;
@property (nonatomic) int teamPassYards;
@property (nonatomic) int teamRushYards;
@property (nonatomic) int teamOppPassYards;
@property (nonatomic) int teamOppRushYards;
@property (nonatomic) int teamTODiff;
@property (nonatomic) int teamOffTalent;
@property (nonatomic) int teamDefTalent;
@property (nonatomic) int teamPrestige;
@property (nonatomic) int teamPollScore;
@property (nonatomic) int teamStrengthOfWins;
@property (nonatomic) int teamRecruitingClassScore;

@property (nonatomic) int teamStatOffNum;
@property (nonatomic) int teamStatDefNum;

@property (nonatomic) int rankTeamPoints;
@property (nonatomic) int rankTeamOppPoints;
@property (nonatomic) int rankTeamYards;
@property (nonatomic) int rankTeamOppYards;
@property (nonatomic) int rankTeamPassYards;
@property (nonatomic) int rankTeamRushYards;
@property (nonatomic) int rankTeamOppPassYards;
@property (nonatomic) int rankTeamOppRushYards;
@property (nonatomic) int rankTeamTODiff;
@property (nonatomic) int rankTeamOffTalent;
@property (nonatomic) int rankTeamDefTalent;
@property (nonatomic) int rankTeamPrestige;
@property (nonatomic) int rankTeamPollScore;
@property (nonatomic) int rankTeamStrengthOfWins;
@property (nonatomic) int rankTeamTotalWins;
@property (nonatomic) int rankTeamRecruitingClassScore;

//prestige/talent improvements
@property (nonatomic) int diffPrestige;
@property (nonatomic) int deltaPrestige;
@property (nonatomic) int diffOffTalent;
@property (nonatomic) int diffDefTalent;

//players on team
//offense
@property (strong, nonatomic) NSMutableArray<PlayerQB*> *teamQBs;
@property (strong, nonatomic) NSMutableArray<PlayerRB*> *teamRBs;
@property (strong, nonatomic) NSMutableArray<PlayerWR*> *teamWRs;
@property (strong, nonatomic) NSMutableArray<PlayerTE*> *teamTEs;
@property (strong, nonatomic) NSMutableArray<PlayerK*> *teamKs;
@property (strong, nonatomic) NSMutableArray<PlayerOL*> *teamOLs;

//defense
@property (strong, nonatomic) NSMutableArray<PlayerLB*> *teamLBs;
@property (strong, nonatomic) NSMutableArray<PlayerDL*> *teamDLs;
@property (strong, nonatomic) NSMutableArray<PlayerDL*> *teamF7s;
@property (strong, nonatomic) NSMutableArray<PlayerS*> *teamSs;
@property (strong, nonatomic) NSMutableArray<PlayerCB*> *teamCBs;

@property (strong, nonatomic) TeamStrategy *offensiveStrategy;
@property (strong, nonatomic) TeamStrategy *defensiveStrategy;


//Single Season Records
@property (strong, nonatomic) Record *singleSeasonCompletionsRecord;
@property (strong, nonatomic) Record *singleSeasonPassYardsRecord;
@property (strong, nonatomic) Record *singleSeasonPassTDsRecord;
@property (strong, nonatomic) Record *singleSeasonInterceptionsRecord;

@property (strong, nonatomic) Record *singleSeasonFumblesRecord;
@property (strong, nonatomic) Record *singleSeasonRushYardsRecord;
@property (strong, nonatomic) Record *singleSeasonCarriesRecord;
@property (strong, nonatomic) Record *singleSeasonRushTDsRecord;

@property (strong, nonatomic) Record *singleSeasonRecYardsRecord;
@property (strong, nonatomic) Record *singleSeasonRecTDsRecord;
@property (strong, nonatomic) Record *singleSeasonCatchesRecord;

@property (strong, nonatomic) Record *singleSeasonXpMadeRecord;
@property (strong, nonatomic) Record *singleSeasonFgMadeRecord;

//career Records
@property (strong, nonatomic) Record *careerCompletionsRecord;
@property (strong, nonatomic) Record *careerPassYardsRecord;
@property (strong, nonatomic) Record *careerPassTDsRecord;
@property (strong, nonatomic) Record *careerInterceptionsRecord;

@property (strong, nonatomic) Record *careerFumblesRecord;
@property (strong, nonatomic) Record *careerRushYardsRecord;
@property (strong, nonatomic) Record *careerCarriesRecord;
@property (strong, nonatomic) Record *careerRushTDsRecord;

@property (strong, nonatomic) Record *careerRecYardsRecord;
@property (strong, nonatomic) Record *careerRecTDsRecord;
@property (strong, nonatomic) Record *careerCatchesRecord;

@property (strong, nonatomic) Record *careerXpMadeRecord;
@property (strong, nonatomic) Record *careerFgMadeRecord;

// coaching
@property (strong, nonatomic) NSMutableArray<HeadCoach *> *coaches;
@property (nonatomic) int totalCOTYs;
@property (nonatomic) BOOL coachFired;
@property (nonatomic) BOOL coachGotNewContract;
@property (nonatomic) BOOL coachRetired;
@property (strong, nonatomic) NSString *coachContractString;


-(instancetype)initWithName:(NSString*)nm abbreviation:(NSString*)abbr conference:(NSString*)conf league:(League*)ligue prestige:(int)prestige rivalTeam:(NSString*)rivalTeamAbbr state:(NSString*)stt;
+(instancetype)newTeamWithName:(NSString *)nm abbreviation:(NSString *)abbr conference:(NSString *)conf league:(League *)league prestige:(int)prestige rivalTeam:(NSString *)rivalTeamAbbr state:(NSString*)stt;

-(void)updateTalentRatings;
-(void)advanceSeason;
-(void)advanceSeasonPlayers;
-(void)recruitPlayers:(NSArray*)needs;
-(void)recruitPlayersFreshman:(NSArray*)needs;
-(void)recruitWalkOns:(NSArray*)needs;
-(void)resetStats;
-(void)updatePollScore;
-(void)updateTeamHistory;
-(void)updateStrengthOfWins;
-(void)sortPlayers;
-(int)getOffensiveTalent;
-(int)getDefensiveTalent;

-(void)addPlayer:(Player*)p;
-(PlayerQB*)getQB:(int)depth;
-(PlayerRB*)getRB:(int)depth;
-(PlayerWR*)getWR:(int)depth;
-(PlayerK*)getK:(int)depth;
-(PlayerOL*)getOL:(int)depth;
-(PlayerS*)getS:(int)depth;
-(PlayerCB*)getCB:(int)depth;
-(PlayerTE*)getTE:(int)depth;
-(PlayerDL*)getDL:(int)depth;
-(PlayerLB*)getLB:(int)depth;
-(HeadCoach*)getHC:(int)depth;
-(HeadCoach*)getCurrentHC;

-(int)getPassProf;
-(int)getRushProf;
-(int)getPassDef;
-(int)getRushDef;
-(int)getCompositeOLPass;
-(int)getCompositeOLRush;
-(int)getCompositeF7Pass;
-(int)getCompositeF7Rush;
-(int)getCompositeFootIQ;

-(NSMutableArray*)getGameSummaryStrings:(int)gameNumber;
-(NSString*)getSeasonSummaryString;

-(int)numGames;
-(int)calculateConfWins;
-(int)calculateConfLosses;

-(NSString*)strRep;
-(NSString*)strRepWithBowlResults;
-(NSString*)weekSummaryString;
-(NSString*)gameSummaryString:(Game*)g;
-(NSString*)gameSummaryStringScore:(Game*)g;
-(NSString*)gameSummaryStringOpponent:(Game*)g;
-(NSString*)getGraduatingPlayersString;

-(NSArray<TeamStrategy *>*)getOffensiveTeamStrategies;
-(NSArray<TeamStrategy *>*)getDefensiveTeamStrategies;

-(NSArray*)getTeamStatsArray;

-(void)setStarters:(NSArray<Player*>*)starters position:(int)position;

-(void)getGraduatingPlayers;

-(NSArray*)singleSeasonRecords;
-(NSArray*)careerRecords;

-(Player*)playerToWatch;

-(NSString*)injuryReport;
-(void)checkForInjury;

-(void)updateRingOfHonor;

-(int)getCPUOffense;
-(int)getCPUDefense;

-(NSString *)teamMetadataJSON;
-(NSInteger)importIdentifier;
-(void)applyJSONMetadataChanges:(id)json;

-(NSArray *)getPlayersAtPosition:(NSString*)pos;
-(NSInteger)getTeamSize;

-(void)calculateRecruitingClassRanking;
-(NSMutableArray<Player*>*)getAllPlayers;
-(void)calculateCoachingContracts:(int)totalPrestigeDiff newPrestige:(int)newPrestige;
-(void)updateCoachHistory;
-(void)setupUserCoach:(NSString *)name;
-(void)createNewCustomHeadCoach:(NSString *)name stars:(int)stars;
-(void)promoteCoach;
-(int)getMinCoachHireReq;
-(void)advanceHC;
-(void)calculateRecruitingPoints;
-(void)getTransferringPlayers;
-(NSString*)getTransferringPlayersString;
@end
