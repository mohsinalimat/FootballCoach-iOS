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

@interface Game : NSObject {
    NSMutableString *gameEventLog;
    NSString *tdInfo;
    
    //private variables used when simming games
    NSInteger gameTime;
    BOOL gamePoss; //1 if home, 0 if away
    NSInteger gameYardLine;
    NSInteger gameDown;
    NSInteger gameYardsNeed;
    
}
@property (nonatomic) NSInteger homeScore;
@property (nonatomic) NSInteger awayScore;
@property (strong, nonatomic) Team *homeTeam;
@property (strong, nonatomic) Team *awayTeam;
@property (nonatomic) BOOL hasPlayed;

@property (strong, nonatomic) NSString *gameName;

@property (strong, nonatomic) NSMutableArray<NSNumber*>* homeQScore;
@property (strong, nonatomic) NSMutableArray<NSNumber*>* awayQScore;
@property (nonatomic) NSInteger homeYards;
@property (nonatomic) NSInteger awayYards;
@property (nonatomic) NSInteger numOT;
@property (nonatomic) NSInteger homeTOs;
@property (nonatomic) NSInteger awayTOs;

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
-(NSArray<NSString*>*)getGameSummaryStrings;
-(NSArray<NSString*>*)getGameScoutStrings;
-(NSInteger)getPassYards:(BOOL)ha;
-(NSInteger)getRushYards:(BOOL)ha;
-(NSInteger)getHFAdv;
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
-(void)passingTD:(Team*)offense receiver:(PlayerWR*)selWR stats:(NSMutableArray*)selWRStats yardsGained:(NSInteger)yardsGained;
-(void)passCompletion:(Team*)offense defense:(Team*)defense receiver:(PlayerWR*)selWR stats:(NSMutableArray*)selWRStats yardsGained:(NSInteger)yardsGained;
-(void)passAttempt:(Team*)offense defense:(Team*)defense receiver:(PlayerWR*)selWR stats:(NSMutableArray*)selWRStats yardsGained:(NSInteger)yardsGained;
-(void)rushAttempt:(Team*)offense defense:(Team*)defense rusher:(PlayerRB*)selRB rb1Pref:(double)rb1Pref rb2Pref:(double)rb2Pref yardsGained:(NSInteger)yardsGained;
-(void)addPointsQuarter:(NSInteger)points;
-(NSInteger)normalize:(NSInteger)rating;
@end
