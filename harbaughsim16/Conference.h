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

@interface Conference : NSObject
@property (strong, nonatomic) NSString *confName;
@property (nonatomic) int confPrestige;
@property (strong, nonatomic) NSMutableArray<Team*> *confTeams;
@property (strong, nonatomic) League *league;
@property (strong, nonatomic) Game *ccg;
@property (nonatomic) int week;
@property (nonatomic) int robinWeek;

+(instancetype)newConferenceWithName:(NSString*)name league:(League*)league;
-(NSString*)getCCGString;
-(void)playConfChamp;
-(void)scheduleConfChamp;
-(void)playWeek;
-(void)insertOOCSchedule;
-(void)setUpOOCSchedule;
-(void)setUpSchedule;
@end
