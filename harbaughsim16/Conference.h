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
@property (nonatomic) NSInteger confPrestige;
@property (strong, nonatomic) NSMutableArray<Team*> *confTeams;
@property (strong, nonatomic) League *league;
@property (strong, nonatomic) Game *ccg;
@property (nonatomic) NSInteger week;
@property (nonatomic) NSInteger robinWeek;

+(instancetype)newConferenceWithName:(NSString*)name league:(League*)league;
-(NSString*)getCCGString;
-(void)playConfChamp;
-(void)scheduleConfChamp;
-(void)playWeek;
-(void)insertOOCSchedule;
-(void)setUpOOCSchedule;
-(void)setUpSchedule;
@end
