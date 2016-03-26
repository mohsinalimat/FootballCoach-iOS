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
@class PlayerF7;
@class PlayerCB;
@class PlayerS;

@interface Game : NSObject <NSCoding> {
    NSMutableString *gameEventLog;
    NSString *tdInfo;
    
    //private variables used when simming games
    int gameTime;
    BOOL gamePoss; //1 if home, 0 if away
    int gameYardLine;
    int gameDown;
    int gameYardsNeed;
    BOOL playingOT;
    BOOL bottomOT;
    
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

@property (strong, nonatomic) NSMutableArray* HomeKStats;
@property (strong, nonatomic) NSMutableArray* AwayKStats;

-(void)playGame;
-(instancetype)initWithHome:(Team*)home away:(Team*)away;
+(instancetype)newGameWithHome:(Team*)home away:(Team*)away;
+(instancetype)newGameWithHome:(Team*)home away:(Team*)away name:(NSString*)name;
-(instancetype)initWithHome:(Team*)home away:(Team*)away name:(NSString*)name;
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
-(void)qbSack:(Team*)offense;
-(void)safety;
-(void)qbInterception:(Team*)offense;
-(void)passingTD:(Team*)offense receiver:(PlayerWR*)selWR stats:(NSMutableArray*)selWRStats yardsGained:(int)yardsGained;
-(void)passCompletion:(Team*)offense defense:(Team*)defense receiver:(PlayerWR*)selWR stats:(NSMutableArray*)selWRStats yardsGained:(int)yardsGained;
-(void)passAttempt:(Team*)offense defense:(Team*)defense receiver:(PlayerWR*)selWR stats:(NSMutableArray*)selWRStats yardsGained:(int)yardsGained;
-(void)rushAttempt:(Team*)offense defense:(Team*)defense rusher:(PlayerRB*)selRB rb1Pref:(double)rb1Pref rb2Pref:(double)rb2Pref yardsGained:(int)yardsGained;
-(void)addPointsQuarter:(int)points;
-(int)normalize:(int)rating;
@end
