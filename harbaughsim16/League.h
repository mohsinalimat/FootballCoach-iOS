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
@class Record;
@class HeadCoach;

@interface League : NSObject <NSCoding> {
    BOOL heismanDecided;

    NSString *heismanWinnerStrFull;

    BOOL rotyDecided;

    NSString *rotyWinnerStrFull;

    //deprecated record tracking ivars
    int leagueRecordCompletions;
    int leagueRecordPassYards;
    int leagueRecordPassTDs;
    int leagueRecordInt;
    int leagueRecordFum;
    int leagueRecordRushYards;
    int leagueRecordRushAtt;
    int leagueRecordRushTDs;
    int leagueRecordRecYards;
    int leagueRecordReceptions;
    int leagueRecordRecTDs;
    int leagueRecordXPMade;
    int leagueRecordFGMade;
    int leagueRecordYearCompletions;
    int leagueRecordYearPassYards;
    int leagueRecordYearPassTDs;
    int leagueRecordYearInt;
    int leagueRecordYearFum;
    int leagueRecordYearRushYards;
    int leagueRecordYearRushAtt;
    int leagueRecordYearRushTDs;
    int leagueRecordYearRecYards;
    int leagueRecordYearReceptions;
    int leagueRecordYearRecTDs;
    int leagueRecordYearXPMade;
    int leagueRecordYearFGMade;
    NSMutableArray<NSArray*> *leagueHistory;
    NSMutableArray<NSString*> *heismanHistory;

}
@property (strong, nonatomic)  NSMutableDictionary *leagueHistoryDictionary;
@property (strong, nonatomic)  NSMutableDictionary *heismanHistoryDictionary;
@property (strong, nonatomic)  NSDictionary *allLeaguePlayers;
@property (strong, nonatomic)  NSArray *allDraftedPlayers;
@property (strong, nonatomic)  NSMutableArray<Player*> *heismanCandidates;
@property (strong, nonatomic)  NSMutableArray<Conference*> *conferences;
@property (strong, nonatomic)  NSMutableArray<Team*> *teamList;
@property (strong, nonatomic)  NSMutableArray<NSString*> *nameList;
@property (strong, nonatomic)  NSMutableArray<NSString*> *lastNameList;
@property (strong, nonatomic)  NSMutableArray<NSMutableArray*> *newsStories;
@property (strong, nonatomic)  NSMutableArray<Player *> *hallOfFamers;
@property (nonatomic) BOOL didFinishTransferPeriod;

@property (strong, nonatomic) NSDictionary<NSString *, NSMutableArray<Player *> *> *transferList;
@property (strong, nonatomic) NSMutableArray<NSString *> *transferLog;

@property (strong, nonatomic) Team *blessedTeam;
@property (strong, nonatomic) Team *cursedTeam;
@property (strong, nonatomic) NSString *blessedTeamCoachName;
@property (strong, nonatomic) NSString *cursedTeamCoachName;
@property (nonatomic) NSInteger blessedStoryIndex;
@property (nonatomic) NSInteger cursedStoryIndex;

@property (nonatomic) NSInteger baseYear;

//Current week, 1-14
@property (nonatomic) int currentWeek;
@property (nonatomic) BOOL isHardMode;

//Bowl Games
@property (strong, nonatomic) Player *heisman;
@property (strong, nonatomic) NSMutableArray<Player*> *heismanFinalists;
@property (nonatomic)  BOOL hasScheduledBowls;
@property (strong, nonatomic)  Game *semiG14;
@property (strong, nonatomic)  Game *semiG23;
@property (strong, nonatomic)  Game *ncg;
@property (strong, nonatomic)  NSMutableArray<Game*> *bowlGames;

// Coaching Carousel
@property (strong, nonatomic) NSMutableArray<HeadCoach*> *coachList;
@property (strong, nonatomic) NSMutableArray<HeadCoach*> *coachStarList;
@property (strong, nonatomic) NSMutableArray<HeadCoach*> *coachFreeAgents;
@property (strong, nonatomic) HeadCoach *cotyWinner;
@property (strong, nonatomic) NSString *cotyWinnerStrFull;
@property (nonatomic) BOOL isCareerMode;

//User Team
@property (strong, nonatomic) Team *userTeam;
@property (nonatomic) int recruitingStage;
@property (nonatomic) BOOL canRebrandTeam;

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

@property (strong, nonatomic) NSString *leagueVersion;

+(BOOL)loadSavedData;
-(BOOL)isSaveCorrupt;
@property (strong, nonatomic) NSArray<NSString *> *bowlTitles;
-(NSArray*)bowlGameTitles;

+(instancetype)newLeagueFromCSV:(NSString*)namesCSV;
+(instancetype)newLeagueFromCSV:(NSString*)namesCSV lastNamesCSV:(NSString*)lastNameCSV;
+(instancetype)newLeagueFromSaveFile:(NSString*)saveFileName;

-(void)playWeek;
-(void)scheduleBowlGames;
-(void)playBowlGames;
-(void)playBowl:(Game*)g;
-(void)updateLeagueHistory;
-(void)advanceSeason;
-(void)updateTeamHistories;
-(void)updateTeamTalentRatings;

-(NSString*)getRandName;
-(NSArray<Player*>*)calculateHeismanCandidates;
-(NSString*)getHeismanCeremonyStr;
-(NSString*)getGameSummaryBowl:(Game*)g;

-(Team*)findTeam:(NSString*)name;
-(Conference*)findConference:(NSString*)name;

-(NSString*)ncgSummaryStr;
-(NSString*)seasonSummaryStr;

-(void)setTeamRanks;
-(void)save;

-(NSArray*)getBowlPredictions;
-(NSArray*)getHeismanLeaders;
-(void)refreshAllLeaguePlayers;
-(NSArray*)singleSeasonRecords;
-(NSArray*)careerRecords;

-(void)completeProDraft;
-(void)updateHallOfFame;

-(BOOL)isTeamNameValid:(NSString*)name allowUserTeam:(BOOL)allowUserTeam allowOverwrite:(BOOL)allowOverwrite ;
-(BOOL)isTeamAbbrValid:(NSString*)abbr allowUserTeam:(BOOL)allowUserTeam allowOverwrite:(BOOL)allowOverwrite ;
-(BOOL)isConfNameValid:(NSString*)name allowOverwrite:(BOOL)canOverwrite;
-(BOOL)isConfAbbrValid:(NSString*)abbr allowOverwrite:(BOOL)canOverwrite;
-(BOOL)isStateValid:(NSString*)stt;

-(NSString *)leagueMetadataJSON;
-(void)applyJSONMetadataChanges:(NSString *)json;

-(NSInteger)getCurrentYear;
// Transfer stuff
-(BOOL)transferListEmpty;

@property (strong, nonatomic) NSMutableDictionary *rotyHistoryDictionary;
@property (strong, nonatomic) NSMutableArray<Player*> *rotyCandidates;
@property (strong, nonatomic) Player *roty;
@property (strong, nonatomic) NSMutableArray<Player*> *rotyFinalists;
-(NSArray*)getROTYLeaders;
-(NSString*)getROTYCeremonyStr;

//Coaching stuff
-(void)advanceHC;
-(NSString *)getCoachAwardStr;
-(NSArray *)calculateCOTYCandidates;
-(int)getAvgCoachDiscipline;
-(int)getAvgCoachTalent;
-(int)getAvgCoachOff;
-(int)getAvgCoachDef;
-(void)coachHiringForSingleTeam:(Team *)t;
-(void)coachingCarousel;
-(void)newJobTransfer:(NSString *)coachTeam;
-(NSMutableArray<Team*> *)getPromotedCoachTeams:(int)rating offers:(double)offers oldTeam:(NSString *)oldTeam;
-(NSMutableArray<Team *> *)getHardModeTeamVacancyList;
-(NSMutableArray<Team*> *)getFiredCoachTeams:(int)rating oldTeam:(NSString *)oldTeam;
-(void)updateHCHistory;
-(int)getAvgYards;
-(int)getAvgConfPrestige;
@end
