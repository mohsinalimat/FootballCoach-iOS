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
/*
@property (strong, nonatomic)  Game *roseBowl;
@property (strong, nonatomic)  Game *sugarBowl;
@property (strong, nonatomic)  Game *orangeBowl;
@property (strong, nonatomic)  Game *peachBowl;
@property (strong, nonatomic)  Game *cottonBowl;
@property (strong, nonatomic)  Game *fiestaBowl;*/

//User Team
@property (strong, nonatomic)  Team *userTeam;



+(NSArray*)bowlGameTitles;



@end
