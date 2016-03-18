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

@interface League : NSObject {
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
@property (nonatomic) NSInteger currentWeek;

//Bowl Games
@property (nonatomic)  BOOL hasScheduledBowls;
@property (strong, nonatomic)  Game *semiG14;
@property (strong, nonatomic)  Game *semiG23;
@property (strong, nonatomic)  Game *ncg;
@property (strong, nonatomic)  NSMutableArray<Game*> *bowlGames;

//User Team
@property (strong, nonatomic)  Team *userTeam;



+(NSArray*)bowlGameTitles;
+(instancetype)newLeagueFromCSV:(NSString*)namesCSV;
+(instancetype)newLeagueFromSaveFile:(NSString*)saveFileName names:(NSString*)namesCSV;

-(NSInteger)getConfNumber:(NSString*)conf;
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
-(BOOL)saveLeague:(NSData*)saveFile;
-(void)setTeamRanks;
-(NSArray*)getTeamRankingsStr:(NSInteger)selection;


@end
