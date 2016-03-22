//
//  Player.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/16/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Team.h"
#import "HBSharedUtils.h"

@interface Player : NSObject <NSCoding>

@property (strong, nonatomic) Team *team;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *position;
@property (nonatomic) int ratOvr;
@property (nonatomic) int year;
@property (nonatomic) int ratPot;
@property (nonatomic) int ratFootIQ;
@property (nonatomic) int ratImprovement;
@property (nonatomic) int cost;
@property (nonatomic) int gamesPlayed;
@property (strong, nonatomic) NSMutableArray *ratingsVector;


+(NSArray *)letterGrades;
-(NSString*)getYearString;
-(NSString*)getFullYearString;
-(void)advanceSeason;
-(int)getHeismanScore;
-(NSString*)getInitialName;
-(NSString*)getPosNameYrOvrPot_Str;
-(NSString*)getPosNameYrOvrPot_OneLine;
-(NSString*)getLetterGradeWithString:(NSString*)num;
-(NSString*)getLetterGradePotWithString:(NSString*)num;
-(NSString*)getLetterGrade:(int)num;
-(NSString*)getLetterGradePot:(int)num;
-(NSDictionary*)detailedStats:(int)games;
-(NSDictionary*)detailedRatings;
//-(NSArray*)getDetailedStatsList:(int)games;
@end
