//
//  Conference.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/16/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "League.h"
#import "Game.h"

@interface Conference : NSObject <NSCoding>
@property (strong, nonatomic) NSString *confName;
@property (strong, nonatomic) NSString *confFullName;
@property (strong, nonatomic) NSDictionary *allConferencePlayers;
@property (nonatomic) int confPrestige;
@property (strong, nonatomic) NSMutableArray<Team*> *confTeams;
@property (strong, nonatomic) League *league;
@property (strong, nonatomic) Game *ccg;
@property (nonatomic) int week;
@property (nonatomic) int robinWeek;

+(instancetype)newConferenceWithName:(NSString*)name fullName:(NSString*)fullName league:(League*)league;
-(NSString *)confShortName;
-(Game*)ccgPrediction;
-(void)sortConfTeams;
-(void)playConfChamp;
-(void)scheduleConfChamp;
-(void)playWeek;
-(void)insertOOCSchedule;
-(void)setUpOOCSchedule;
-(void)setUpSchedule;
-(void)refreshAllConferencePlayers;

-(NSString *)conferenceMetadataJSON;
-(void)applyJSONMetadataChanges:(id)json;
@end
