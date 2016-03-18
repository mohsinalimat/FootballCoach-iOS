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
@class Player;
@class League;

@class PlayerQB;
@class PlayerRB;
@class PlayerWR;
@class PlayerOL;
@class PlayerK;
@class PlayerF7;
@class PlayerCB;
@class PlayerS;


#define PLAYERS_PER_TEAM 53

@interface Team : NSObject

@property (strong, nonatomic) League *league;

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *abbreviation;
@property (strong, nonatomic) NSString *conference;
@property (strong, nonatomic) NSString *rivalTeam;
@property (strong, nonatomic) NSMutableArray *teamHistory;
@property (nonatomic) BOOL isUserControlled;
@property (nonatomic) BOOL wonRivalryGame;
@property (nonatomic) NSInteger recruitingMoney;
@property (nonatomic) NSInteger numberOfRecruits;

@property (nonatomic) NSInteger wins;
@property (nonatomic) NSInteger losses;
@property (nonatomic) NSInteger totalWins;
@property (nonatomic) NSInteger totalLosses;
@property (nonatomic) NSInteger totalCCs;
@property (nonatomic) NSInteger totalNCs;

//Game Log variables
@property (strong, nonatomic) NSMutableArray *gameSchedule;
@property (strong, nonatomic) Game *oocGame0;
@property (strong, nonatomic) Game *oocGame4;
@property (strong, nonatomic) Game *oocGame9;
@property (strong, nonatomic) NSMutableArray *gameWLSchedule;
@property (strong, nonatomic) NSMutableArray *gameWinsAgainst;
@property (strong, nonatomic) NSString *confChampion;
@property (strong, nonatomic) NSString *semifinalWL;
@property (strong, nonatomic) NSString *natlChampWL;


//Team stats
@property (nonatomic) NSInteger teamPoints;
@property (nonatomic) NSInteger teamOppPoints;
@property (nonatomic) NSInteger teamYards;
@property (nonatomic) NSInteger teamOppYards;
@property (nonatomic) NSInteger teamPassYards;
@property (nonatomic) NSInteger teamRushYards;
@property (nonatomic) NSInteger teamOppPassYards;
@property (nonatomic) NSInteger teamOppRushYards;
@property (nonatomic) NSInteger teamTODiff;
@property (nonatomic) NSInteger teamOffTalent;
@property (nonatomic) NSInteger teamDefTalent;
@property (nonatomic) NSInteger teamPrestige;
@property (nonatomic) NSInteger teamPollScore;
@property (nonatomic) NSInteger teamStrengthOfWins;

@property (nonatomic) NSInteger rankTeamPoints;
@property (nonatomic) NSInteger rankTeamOppPoints;
@property (nonatomic) NSInteger rankTeamYards;
@property (nonatomic) NSInteger rankTeamOppYards;
@property (nonatomic) NSInteger rankTeamPassYards;
@property (nonatomic) NSInteger rankTeamRushYards;
@property (nonatomic) NSInteger rankTeamOppPassYards;
@property (nonatomic) NSInteger rankTeamOppRushYards;
@property (nonatomic) NSInteger rankTeamTODiff;
@property (nonatomic) NSInteger rankTeamOffTalent;
@property (nonatomic) NSInteger rankTeamDefTalent;
@property (nonatomic) NSInteger rankTeamPrestige;
@property (nonatomic) NSInteger rankTeamPollScore;
@property (nonatomic) NSInteger rankTeamStrengthOfWins;

//prestige/talent improvements
@property (nonatomic) NSInteger diffPrestige;
@property (nonatomic) NSInteger diffOffTalent;
@property (nonatomic) NSInteger diffDefTalent;

//players on team
//offense
@property (strong, nonatomic) NSMutableArray *teamQBs;
@property (strong, nonatomic) NSMutableArray *teamRBs;
@property (strong, nonatomic) NSMutableArray *teamWRs;
@property (strong, nonatomic) NSMutableArray *teamKs;
@property (strong, nonatomic) NSMutableArray *teamOLs;

//defense
@property (strong, nonatomic) NSMutableArray *teamF7s;
@property (strong, nonatomic) NSMutableArray *teamSs;
@property (strong, nonatomic) NSMutableArray *teamCBs;

@property (strong, nonatomic) TeamStrategy *offensiveStrategy;
@property (strong, nonatomic) TeamStrategy *defensiveStrategy;



-(instancetype)initWithName:(NSString*)name abbreviation:(NSString*)abbr conference:(NSString*)conference league:(League*)league prestige:(NSInteger)prestige rivalTeam:(NSString*)rivalTeamAbbr;
-(instancetype)initWithString:(NSString*)loadStr league:(League*)league;
+ (instancetype)newTeamWithName:(NSString*)name abbreviation:(NSString*)abbr conference:(NSString*)conference league:(League*)league prestige:(NSInteger)prestige rivalTeam:(NSString*)rivalTeamAbbr;

-(void)updateTalentRatings;
-(void)advanceSeason;
-(void)advanceSeasonPlayers;
-(void)recruitPlayers:(NSArray*)needs;
-(void)recruitPlayersFreshman:(NSArray*)needs;
-(void)recruitWalkOns;
-(void)recruitPlayersFromString:(NSString *)playerStr;
-(void)recruitPlayerCSV:(NSString*)line;
-(void)resetStats;
-(void)updatePollScore;
-(void)updateTeamHistory;
-(NSString*)getTeamHistoryString;
-(void)updateStrengthOfWins;
-(void)sortPlayers;
-(NSInteger)getOffensiveTalent;
-(NSInteger)getDefensiveTalent;

-(PlayerQB*)getQB:(NSInteger)depth;
-(PlayerRB*)getRB:(NSInteger)depth;
-(PlayerWR*)getWR:(NSInteger)depth;
-(PlayerK*)getK:(NSInteger)depth;
-(PlayerOL*)getOL:(NSInteger)depth;
-(PlayerS*)getS:(NSInteger)depth;
-(PlayerCB*)getCB:(NSInteger)depth;
-(PlayerF7*)getF7:(NSInteger)depth;

-(NSInteger)getPassProf;
-(NSInteger)getRushProf;
-(NSInteger)getPassDef;
-(NSInteger)getRushDef;
-(NSInteger)getCompositeOLPass;
-(NSInteger)getCompositeOLRush;
-(NSInteger)getCompositeF7Pass;
-(NSInteger)getCompositeF7Rush;
-(NSMutableArray*)getTeamStatsStrings;
-(NSString*)getTeamStatsStringCSV;
-(NSMutableArray*)getGameScheduleStrings;
-(NSMutableArray*)getGameSummaryStrings;
-(NSString*)getSeasonSummaryString;
-(NSMutableArray*)getPlayerStatsStrings;
-(NSMutableArray*)getPlayerStatsExpandListStrings;
-(NSDictionary*)getPlayerStatsExpandListMap:(NSArray*)playerStatsGroupHeaders;
-(NSString*)getRankString;
-(NSInteger)numGames;
-(NSInteger)getConfWins;
-(NSString*)strRep;
-(NSString*)strRepWithBowlResults;
-(NSString*)weekSummaryString;
-(NSString*)gameSummaryString:(Game*)g;
-(NSString*)gameSummaryStringScore:(Game*)g;
-(NSString*)gameSummaryStringOpponent:(Game*)g;
-(NSString*)getGraduatingPlayersString;
-(NSString*)getTeamNeeds;
-(NSMutableArray*)getQBRecruits;
-(NSMutableArray*)getRBRecruits;
-(NSMutableArray*)getWRRecruits;
-(NSMutableArray*)getKRecruits;
-(NSMutableArray*)getOLRecruits;
-(NSMutableArray*)getSRecruits;
-(NSMutableArray*)getCBRecruits;
-(NSMutableArray*)getF7Recruits;
-(NSString *)getRecruitsInfoSaveFile;
-(NSString *)getPlayerInfoSaveFile;
-(NSMutableArray*)getOffensiveTeamStrategies;
-(NSMutableArray*)getDefensiveTeamStrategies;

@end
