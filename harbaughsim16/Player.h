//
//  Player.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/16/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Team.h"

@interface Player : NSObject

@property (strong, nonatomic) Team *team;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *position;
@property (nonatomic) NSInteger ratOvr;
@property (nonatomic) NSInteger year;
@property (nonatomic) NSInteger ratPot;
@property (nonatomic) NSInteger ratFootIQ;
@property (nonatomic) NSInteger ratImprovement;
@property (nonatomic) NSInteger cost;
@property (strong, nonatomic) NSMutableArray *ratingsVector;


+(NSArray *)letterGrades;
-(NSString*)getYearString;
-(void)advanceSeason;
-(NSInteger)getHeismanScore;
-(NSString*)getInitialName;
-(NSString*)getPosNameYrOvrPot_Str;
-(NSString*)getPosNameYrOvrPot_OneLine;
-(NSString*)getLetterGradeWithString:(NSString*)num;
-(NSString*)getLetterGradePotWithString:(NSString*)num;
-(NSString*)getLetterGrade:(NSInteger)num;
-(NSString*)getLetterGradePot:(NSInteger)num;
-(NSArray*)getDetailedStatsList:(NSInteger)games;
@end
