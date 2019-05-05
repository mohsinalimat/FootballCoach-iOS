//
//  Game.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/16/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Team;
@class Player;
@class PlayerQB;
@class PlayerRB;
@class PlayerWR;
@class PlayerOL;
@class PlayerK;
@class PlayerDL;
@class PlayerLB;
@class PlayerCB;
@class PlayerS;

typedef NS_ENUM(NSInteger, FCQBStat) {
    FCQBStatPassAtt = 0,
    FCQBStatPassComp = 1,
    FCQBStatPassTD = 2,
    FCQBStatINT = 3,
    FCQBStatPassYards = 4,
    FCQBStatSacked = 5,
    FCQBStatRushAtt = 6,
    FCQBStatRushYards = 7,
    FCQBStatRushTD = 8,
    FCQBStatFumbles = 9
};

typedef NS_ENUM(NSInteger, FCRBStat) {
    FCRBStatRushAtt = 0,
    FCRBStatRushYards = 1,
    FCRBStatRushTD = 2,
    FCRBStatFumbles = 3
};

typedef NS_ENUM(NSInteger, FCWRStat) {
    FCWRStatCatches = 0,
    FCWRStatTargets = 1,
    FCWRStatRecYards = 2,
    FCWRStatRecTD = 3,
    FCWRStatDrops = 4,
    FCWRStatFumbles = 5
};

typedef NS_ENUM(NSInteger, FCDefensiveStat) {
    FCDefensiveStatTkl = 0,
    FCDefensiveStatPassDef = 1,
    FCDefensiveStatSacks = 2,
    FCDefensiveStatINT = 3,
    FCDefensiveStatForcedFum = 4
};

typedef NS_ENUM(NSInteger, FCKStat) {
    FCKStatXPMade = 0,
    FCKStatXPAtt = 1,
    FCKStatFGMade = 2,
    FCKStatFGAtt = 3
};

typedef NS_ENUM(NSInteger, FCGameSituation) {
    FCGameSituationPassCatch = 0,
    FCGameSituationPassDefense = 1,
    FCGameSituationRunCarry = 2,
    FCGameSituationRunDefense = 3,
    FCGameSituationFumble = 4,
    FCGameSituationInterception = 5,
    FCGameSituationSack = 6,
    FCGameSituationTackle = 7,
    FCGameSituationPassCompletion = 8
};

@interface Game : NSObject <NSCoding> {
    
    NSString *tdInfo;
    
    //private variables used when simming games
    int gameTime;
    BOOL gamePoss; //1 if home, 0 if away
    int gameYardLine;
    int gameDown;
    int gameYardsNeed;
    BOOL playingOT;
    BOOL bottomOT;
    
    BOOL pbpEnabled;
    
}
@property (nonatomic) int homeScore;
@property (nonatomic) int awayScore;
@property (strong, nonatomic) Team *homeTeam;
@property (strong, nonatomic) Team *awayTeam;
@property (nonatomic) BOOL hasPlayed;

@property (strong, nonatomic) NSString *gameName;

@property (strong, nonatomic) NSMutableArray<NSNumber*>* homeQScore;
@property (strong, nonatomic) NSMutableArray<NSNumber*>* awayQScore;
@property (nonatomic) int homeYards;
@property (nonatomic) int awayYards;
@property (nonatomic) int numOT;
@property (nonatomic) int homeTOs;
@property (nonatomic) int awayTOs;

@property (strong, nonatomic) NSMutableArray<Player*> *homeStarters;
@property (strong, nonatomic) NSMutableArray<Player*> *awayStarters;

@property (strong, nonatomic) NSMutableArray* HomeQBStats;
@property (strong, nonatomic) NSMutableArray* AwayQBStats;

@property (strong, nonatomic) NSMutableArray* HomeRB1Stats;
@property (strong, nonatomic) NSMutableArray* HomeRB2Stats;
@property (strong, nonatomic) NSMutableArray* AwayRB1Stats;
@property (strong, nonatomic) NSMutableArray* AwayRB2Stats;

@property (strong, nonatomic) NSMutableArray* HomeWR1Stats;
@property (strong, nonatomic) NSMutableArray* HomeWR2Stats;
@property (strong, nonatomic) NSMutableArray* HomeWR3Stats;
@property (strong, nonatomic) NSMutableArray* AwayWR1Stats;
@property (strong, nonatomic) NSMutableArray* AwayWR2Stats;
@property (strong, nonatomic) NSMutableArray* AwayWR3Stats;

@property (strong, nonatomic) NSMutableArray* HomeTEStats;
@property (strong, nonatomic) NSMutableArray* AwayTEStats;

@property (strong, nonatomic) NSMutableArray* HomeDL1Stats; // 0 tkl, 1 pass def, 2 sacks, 3 INT, 4 Fum
@property (strong, nonatomic) NSMutableArray* HomeDL2Stats;
@property (strong, nonatomic) NSMutableArray* HomeDL3Stats;
@property (strong, nonatomic) NSMutableArray* HomeDL4Stats;
@property (strong, nonatomic) NSMutableArray* AwayDL1Stats;
@property (strong, nonatomic) NSMutableArray* AwayDL2Stats;
@property (strong, nonatomic) NSMutableArray* AwayDL3Stats;
@property (strong, nonatomic) NSMutableArray* AwayDL4Stats;

@property (strong, nonatomic) NSMutableArray* HomeLB1Stats;
@property (strong, nonatomic) NSMutableArray* HomeLB2Stats;
@property (strong, nonatomic) NSMutableArray* HomeLB3Stats;
@property (strong, nonatomic) NSMutableArray* AwayLB1Stats;
@property (strong, nonatomic) NSMutableArray* AwayLB2Stats;
@property (strong, nonatomic) NSMutableArray* AwayLB3Stats;

@property (strong, nonatomic) NSMutableArray* HomeCB1Stats;
@property (strong, nonatomic) NSMutableArray* HomeCB2Stats;
@property (strong, nonatomic) NSMutableArray* HomeCB3Stats;
@property (strong, nonatomic) NSMutableArray* AwayCB1Stats;
@property (strong, nonatomic) NSMutableArray* AwayCB2Stats;
@property (strong, nonatomic) NSMutableArray* AwayCB3Stats;

@property (strong, nonatomic) NSMutableArray* HomeSStats;
@property (strong, nonatomic) NSMutableArray* AwaySStats;

@property (strong, nonatomic) NSMutableArray* HomeKStats;
@property (strong, nonatomic) NSMutableArray* AwayKStats;

@property (strong, nonatomic) NSMutableString *gameEventLog;

@property (strong, nonatomic) NSMutableDictionary<NSString *, NSNumber*> *homePlayerPrefs;
@property (strong, nonatomic) NSMutableDictionary<NSString *, NSNumber*> *awayPlayerPrefs;

-(void)playGame;
+(instancetype)newGameWithHome:(Team*)home away:(Team*)away;
+(instancetype)newGameWithHome:(Team*)home away:(Team*)away name:(NSString*)name;
-(NSString*)gameSummary;
-(NSDictionary*)gameReport;
-(int)getPassYards:(BOOL)ha;
-(int)getRushYards:(BOOL)ha;
-(int)getHFAdv;
-(NSString*)getEventPrefix;
-(NSString*)convGameTime;
-(void)addNewsStory;
-(void)runPlay:(Team*)offense defense:(Team*)defense;
-(void)passingPlay:(Team*)offense defense:(Team*)defense;
-(void)rushingPlay:(Team*)offense defense:(Team*)defense;
-(void)fieldGoalAtt:(Team*)offense defense:(Team*)defense;
-(void)kickXP:(Team*)offense defense:(Team*)defense;
-(void)kickOff:(Team*)offense;
-(void)puntPlay:(Team*)offense;

-(void)addPointsQuarter:(int)points;
-(int)normalize:(int)rating;
@end
