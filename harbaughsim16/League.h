//
//  League.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/16/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Player;
@class Game;
@class Team;
@class Conference;

@interface League : NSObject <NSCoding> {
    BOOL heismanDecided;
    Player *heisman;
    NSMutableArray<Player*> *heismanCandidates;
    NSString *heismanWinnerStrFull;
}

@property (strong, nonatomic)  NSMutableArray<NSArray*> *leagueHistory;
@property (strong, nonatomic)  NSMutableArray<NSString*> *heismanHistory;
@property (strong, nonatomic)  NSMutableArray<Conference*> *conferences;
@property (strong, nonatomic)  NSMutableArray<Team*> *teamList;
@property (strong, nonatomic)  NSMutableArray<NSString*> *nameList;
@property (strong, nonatomic)  NSMutableArray<NSMutableArray*> *newsStories;

//Current week, 1-14
@property (nonatomic) int currentWeek;

//Bowl Games
@property (nonatomic)  BOOL hasScheduledBowls;
@property (strong, nonatomic)  Game *semiG14;
@property (strong, nonatomic)  Game *semiG23;
@property (strong, nonatomic)  Game *ncg;
@property (strong, nonatomic)  NSMutableArray<Game*> *bowlGames;

//User Team
@property (strong, nonatomic)  Team *userTeam;
@property (nonatomic) int recruitingStage;
@property (nonatomic) BOOL canRebrandTeam;


//records
@property (nonatomic) int leagueRecordCompletions;
@property (nonatomic) int leagueRecordPassYards;
@property (nonatomic) int leagueRecordPassTDs;
@property (nonatomic) int leagueRecordInt;

@property (nonatomic) int leagueRecordFum;
@property (nonatomic) int leagueRecordRushYards;
@property (nonatomic) int leagueRecordRushAtt;
@property (nonatomic) int leagueRecordRushTDs;

@property (nonatomic) int leagueRecordRecYards;
@property (nonatomic) int leagueRecordReceptions;
@property (nonatomic) int leagueRecordRecTDs;

@property (nonatomic) int leagueRecordXPMade;
@property (nonatomic) int leagueRecordFGMade;

//Record years
@property (nonatomic) int leagueRecordYearCompletions;
@property (nonatomic) int leagueRecordYearPassYards;
@property (nonatomic) int leagueRecordYearPassTDs;
@property (nonatomic) int leagueRecordYearInt;

@property (nonatomic) int leagueRecordYearFum;
@property (nonatomic) int leagueRecordYearRushYards;
@property (nonatomic) int leagueRecordYearRushAtt;
@property (nonatomic) int leagueRecordYearRushTDs;

@property (nonatomic) int leagueRecordYearRecYards;
@property (nonatomic) int leagueRecordYearReceptions;
@property (nonatomic) int leagueRecordYearRecTDs;

@property (nonatomic) int leagueRecordYearXPMade;
@property (nonatomic) int leagueRecordYearFGMade;

+(BOOL)loadSavedData;
+(NSArray*)bowlGameTitles;
+(instancetype)newLeagueFromCSV:(NSString*)namesCSV;
+(instancetype)newLeagueFromSaveFile:(NSString*)saveFileName names:(NSString*)namesCSV;

-(int)getConfNumber:(NSString*)conf;
-(void)playWeek;
-(void)scheduleBowlGames;
-(void)playBowlGames;
-(void)playBowl:(Game*)g;
-(void)updateLeagueHistory;
-(void)advanceSeason;
-(void)updateTeamHistories;
-(void)updateTeamTalentRatings;
-(NSString*)getRandName;
-(NSArray<Player*>*)getHeisman;
-(NSString*)getTop5HeismanStr;
-(NSString*)getHeismanCeremonyStr;
-(NSString*)getLeagueHistoryStr;
-(NSArray*)getTeamListStr;
-(NSString*)getBowlGameWatchStr;
-(NSString*)getGameSummaryBowl:(Game*)g;
-(NSString*)getCCGsStr;
-(Team*)findTeam:(NSString*)name;
-(Conference*)findConference:(NSString*)name;
-(NSString*)ncgSummaryStr;
-(NSString*)seasonSummaryStr;
-(void)setTeamRanks;
-(NSArray*)getTeamRankingsStr:(int)selection;
-(void)save;
-(void)advanceSeasonForAllExceptUser;
-(NSArray*)getBowlPredictions;
-(NSArray*)getHeismanLeaders;
@end
