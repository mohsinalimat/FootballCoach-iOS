//
//  League.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/16/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "League.h"
#import "Player.h"
#import "Conference.h"
#import "Game.h"
#import "Team.h"
#import "AppDelegate.h"
#import "Record.h"

#import "PlayerQB.h"
#import "PlayerRB.h"
#import "PlayerWR.h"
#import "PlayerK.h"
#import "PlayerOL.h"
#import "PlayerF7.h"
#import "PlayerCB.h"
#import "PlayerS.h"
#import "Injury.h"

#import "HBSharedUtils.h"

#import "FCFileManager.h"
#import "AutoCoding.h"

@implementation League

- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeBool:_isHardMode forKey:@"isHardMode"];
    [encoder encodeBool:heismanDecided forKey:@"heismanDecided"];
    [encoder encodeBool:_canRebrandTeam forKey:@"canRebrandTeam"];
    [encoder encodeObject:_heisman forKey:@"heisman"];
    [encoder encodeObject:_heismanFinalists forKey:@"heismanFinalists"];
    [encoder encodeObject:heismanCandidates forKey:@"heismanCandidates"];
    [encoder encodeObject:heismanWinnerStrFull forKey:@"heismanWinnerStrFull"];
    [encoder encodeObject:leagueHistory forKey:@"leagueHistory"];
    [encoder encodeObject:_leagueHistoryDictionary forKey:@"leagueHistoryDictionary"];
    [encoder encodeObject:_allDraftedPlayers forKey:@"allDraftedPlayers"];
    [encoder encodeObject:_allLeaguePlayers forKey:@"allLeaguePlayers"];
    [encoder encodeObject:_hallOfFamers forKey:@"hallOfFamers"];
    [encoder encodeObject:heismanHistory forKey:@"heismanHistory"];
    [encoder encodeObject:_heismanHistoryDictionary forKey:@"heismanHistoryDictionary"];
    [encoder encodeObject:_conferences forKey:@"conferences"];
    [encoder encodeObject:_teamList forKey:@"teamList"];
    [encoder encodeObject:_nameList forKey:@"nameList"];
    [encoder encodeObject:_newsStories forKey:@"newsStories"];
    [encoder encodeInt:_currentWeek forKey:@"currentWeek"];
    [encoder encodeBool:_hasScheduledBowls forKey:@"hasScheduledBowls"];
    [encoder encodeObject:_semiG14 forKey:@"semiG14"];
    [encoder encodeObject:_semiG23 forKey:@"semiG23"];
    [encoder encodeObject:_ncg forKey:@"ncg"];
    [encoder encodeObject:_bowlGames forKey:@"bowlGames"];
    [encoder encodeObject:_userTeam forKey:@"userTeam"];
    [encoder encodeInt:_recruitingStage forKey:@"recruitingStage"];
    [encoder encodeObject:_blessedTeam forKey:@"blessedTeam"];
    [encoder encodeObject:_cursedTeam forKey:@"cursedTeam"];
    [encoder encodeObject:_blessedTeamCoachName forKey:@"blessedTeamCoachName"];
    [encoder encodeObject:_cursedTeamCoachName forKey:@"cursedTeamCoachName"];
    [encoder encodeInteger:_blessedStoryIndex forKey:@"blessedStoryIndex"];
    [encoder encodeInteger:_cursedStoryIndex forKey:@"cursedStoryIndex"];

    [encoder encodeObject:_singleSeasonCompletionsRecord forKey:@"singleSeasonCompletionsRecord"];
    [encoder encodeObject:_singleSeasonPassYardsRecord forKey:@"singleSeasonPassYardsRecord"];
    [encoder encodeObject:_singleSeasonPassTDsRecord forKey:@"singleSeasonPassTDsRecord"];
    [encoder encodeObject:_singleSeasonInterceptionsRecord forKey:@"singleSeasonInterceptionsRecord"];
    [encoder encodeObject:_singleSeasonFumblesRecord forKey:@"singleSeasonFumblesRecord"];
    [encoder encodeObject:_singleSeasonRushYardsRecord forKey:@"singleSeasonRushYardsRecord"];
    [encoder encodeObject:_singleSeasonRushTDsRecord forKey:@"singleSeasonRushTDsRecord"];
    [encoder encodeObject:_singleSeasonCarriesRecord forKey:@"singleSeasonCarriesRecord"];
    [encoder encodeObject:_singleSeasonRecYardsRecord forKey:@"singleSeasonRecYardsRecord"];
    [encoder encodeObject:_singleSeasonRecTDsRecord forKey:@"singleSeasonRecTDsRecord"];
    [encoder encodeObject:_singleSeasonCatchesRecord forKey:@"singleSeasonCatchesRecord"];
    [encoder encodeObject:_singleSeasonFgMadeRecord forKey:@"singleSeasonFgMadeRecord"];
    [encoder encodeObject:_singleSeasonXpMadeRecord forKey:@"singleSeasonXpMadeRecord"];

    [encoder encodeObject:_careerCompletionsRecord forKey:@"careerCompletionsRecord"];
    [encoder encodeObject:_careerPassYardsRecord forKey:@"careerPassYardsRecord"];
    [encoder encodeObject:_careerPassTDsRecord forKey:@"careerPassTDsRecord"];
    [encoder encodeObject:_careerInterceptionsRecord forKey:@"careerInterceptionsRecord"];
    [encoder encodeObject:_careerFumblesRecord forKey:@"careerFumblesRecord"];
    [encoder encodeObject:_careerRushYardsRecord forKey:@"careerRushYardsRecord"];
    [encoder encodeObject:_careerRushTDsRecord forKey:@"careerRushTDsRecord"];
    [encoder encodeObject:_careerCarriesRecord forKey:@"careerCarriesRecord"];
    [encoder encodeObject:_careerRecYardsRecord forKey:@"careerRecYardsRecord"];
    [encoder encodeObject:_careerRecTDsRecord forKey:@"careerRecTDsRecord"];
    [encoder encodeObject:_careerCatchesRecord forKey:@"careerCatchesRecord"];
    [encoder encodeObject:_careerFgMadeRecord forKey:@"careerFgMadeRecord"];
    [encoder encodeObject:_careerXpMadeRecord forKey:@"careerXpMadeRecord"];

    //deprecated
    [encoder encodeInt:leagueRecordFum forKey:@"leagueRecordFum"];
    [encoder encodeInt:leagueRecordInt forKey:@"leagueRecordInt"];
    [encoder encodeInt:leagueRecordFGMade forKey:@"leagueRecordFGMade"];
    [encoder encodeInt:leagueRecordRushAtt forKey:@"leagueRecordRushAtt"];
    [encoder encodeInt:leagueRecordXPMade forKey:@"leagueRecordXPMade"];
    [encoder encodeInt:leagueRecordPassTDs forKey:@"leagueRecordPassTDs"];
    [encoder encodeInt:leagueRecordRushTDs forKey:@"leagueRecordRushTDs"];
    [encoder encodeInt:leagueRecordRecTDs forKey:@"leagueRecordRecTDs"];
    [encoder encodeInt:leagueRecordReceptions forKey:@"leagueRecordReceptions"];
    [encoder encodeInt:leagueRecordCompletions forKey:@"leagueRecordCompletions"];
    [encoder encodeInt:leagueRecordRushYards forKey:@"leagueRecordRushYards"];
    [encoder encodeInt:leagueRecordRecYards forKey:@"leagueRecordRecYards"];
    [encoder encodeInt:leagueRecordPassYards forKey:@"leagueRecordPassYards"];

    [encoder encodeInt:leagueRecordYearFum forKey:@"leagueRecordYearFum"];
    [encoder encodeInt:leagueRecordYearInt forKey:@"leagueRecordYearInt"];
    [encoder encodeInt:leagueRecordYearFGMade forKey:@"leagueRecordYearFGMade"];
    [encoder encodeInt:leagueRecordYearXPMade forKey:@"leagueRecordYearXPMade"];
    [encoder encodeInt:leagueRecordYearRecTDs forKey:@"leagueRecordYearRecTDs"];
    [encoder encodeInt:leagueRecordYearReceptions forKey:@"leagueRecordYearReceptions"];
    [encoder encodeInt:leagueRecordYearRushAtt forKey:@"leagueRecordYearRushAtt"];
    [encoder encodeInt:leagueRecordYearRushYards forKey:@"leagueRecordYearRushYards"];
    [encoder encodeInt:leagueRecordYearRushTDs forKey:@"leagueRecordYearRushTDs"];
    [encoder encodeInt:leagueRecordYearPassTDs forKey:@"leagueRecordYearPassTDs"];
    [encoder encodeInt:leagueRecordYearCompletions forKey:@"leagueRecordYearCompletions"];
    [encoder encodeInt:leagueRecordYearPassYards forKey:@"leagueRecordYearPassYards"];

}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        
        heismanDecided = [decoder decodeBoolForKey:@"heismanDecided"];
        _heisman = [decoder decodeObjectForKey:@"heisman"];
        _heismanFinalists = [decoder decodeObjectForKey:@"heismanFinalists"];
        heismanCandidates = [decoder decodeObjectForKey:@"heismanCandidates"];
        heismanWinnerStrFull = [decoder decodeObjectForKey:@"heismanWinnerStrFull"];
        leagueHistory = [decoder decodeObjectForKey:@"leagueHistory"];
        heismanHistory = [decoder decodeObjectForKey:@"heismanHistory"];
        _conferences = [decoder decodeObjectForKey:@"conferences"];
        _teamList = [decoder decodeObjectForKey:@"teamList"];
        _nameList = [decoder decodeObjectForKey:@"nameList"];
        _newsStories = [decoder decodeObjectForKey:@"newsStories"];
        _currentWeek = [decoder decodeIntForKey:@"currentWeek"];
        _hasScheduledBowls = [decoder decodeBoolForKey:@"hasScheduledBowls"];
        _semiG14 = [decoder decodeObjectForKey:@"semiG14"];
        _semiG23 = [decoder decodeObjectForKey:@"semiG23"];
        _ncg = [decoder decodeObjectForKey:@"ncg"];
        _bowlGames = [decoder decodeObjectForKey:@"bowlGames"];
        _userTeam = [decoder decodeObjectForKey:@"userTeam"];
        _recruitingStage = [decoder decodeIntForKey:@"recruitingStage"];
        _canRebrandTeam = [decoder decodeBoolForKey:@"canRebrandTeam"];
        
        if (![decoder containsValueForKey:@"hallOfFamers"]) {
            _hallOfFamers = [NSMutableArray array];
        } else {
            _hallOfFamers = [decoder decodeObjectForKey:@"hallOfFamers"];
        }
        
        if (![decoder containsValueForKey:@"allDraftedPlayers"]) {
            _allDraftedPlayers = [NSMutableArray array];
        } else {
            _allDraftedPlayers = [decoder decodeObjectForKey:@"allDraftedPlayers"];
        }
        
        if (![decoder containsValueForKey:@"allLeaguePlayers"]) {
            _allLeaguePlayers = [NSMutableDictionary dictionary];
        } else {
            _allLeaguePlayers = [decoder decodeObjectForKey:@"allLeaguePlayers"];
        }
        
        if (![decoder containsValueForKey:@"isHardMode"]) {
            _isHardMode = NO;
        } else {
            _isHardMode = [decoder decodeBoolForKey:@"isHardMode"];
        }

        if (![decoder containsValueForKey:@"blessedTeam"]) {
            _blessedTeam = nil;
        } else {
            _blessedTeam = [decoder decodeObjectForKey:@"blessedTeam"];
        }

        if (![decoder containsValueForKey:@"cursedTeam"]) {
            _cursedTeam = nil;
        } else {
            _cursedTeam = [decoder decodeObjectForKey:@"cursedTeam"];
        }

        if (![decoder containsValueForKey:@"blessedTeamCoachName"]) {
            _blessedTeamCoachName = nil;
        } else {
            _blessedTeamCoachName = [decoder decodeObjectForKey:@"blessedTeamCoachName"];
        }

        if (![decoder containsValueForKey:@"cursedTeamCoachName"]) {
            _cursedTeamCoachName = nil;
        } else {
            _cursedTeamCoachName = [decoder decodeObjectForKey:@"cursedTeamCoachName"];
        }

        if (![decoder containsValueForKey:@"blessedStoryIndex"]) {
            _blessedStoryIndex = 0;
        } else {
            _blessedStoryIndex = [decoder decodeIntForKey:@"blessedStoryIndex"];
        }

        if (![decoder containsValueForKey:@"cursedStoryIndex"]) {
            _cursedStoryIndex = 0;
        } else {
            _cursedStoryIndex = [decoder decodeIntForKey:@"cursedStoryIndex"];
        }
        
        if (![decoder containsValueForKey:@"leagueHistoryDictionary"]) {
            NSInteger yearsActive = leagueHistory.count;
            _leagueHistoryDictionary = [NSMutableDictionary dictionary];
            for (int i = 0; i < yearsActive; i++) {
                [_leagueHistoryDictionary setObject:leagueHistory[i] forKey:[NSString stringWithFormat:@"%ld",(long)(2016 + i)]];
            }
        } else {
            _leagueHistoryDictionary = [decoder decodeObjectForKey:@"leagueHistoryDictionary"];
        }
        
        if (![decoder containsValueForKey:@"heismanHistoryDictionary"]) {
            NSInteger yearsActive = heismanHistory.count;
            _heismanHistoryDictionary = [NSMutableDictionary dictionary];
            for (int i = 0; i < yearsActive; i++) {
                [_heismanHistoryDictionary setObject:heismanHistory[i] forKey:[NSString stringWithFormat:@"%ld",(long)(2016 + i)]];
            }
        } else {
            _heismanHistoryDictionary = [decoder decodeObjectForKey:@"heismanHistoryDictionary"];
        }

        //single season
        //pass records
        if (![decoder containsValueForKey:@"singleSeasonCompletionsRecord"]) {
            _singleSeasonCompletionsRecord = nil;
        } else {
            _singleSeasonCompletionsRecord = [decoder decodeObjectForKey:@"singleSeasonCompletionsRecord"];
        }

        if (![decoder containsValueForKey:@"singleSeasonPassYardsRecord"]) {
            _singleSeasonPassYardsRecord = nil;
        } else {

            _singleSeasonPassYardsRecord = [decoder decodeObjectForKey:@"singleSeasonPassYardsRecord"];
        }

        if (![decoder containsValueForKey:@"singleSeasonPassTDsRecord"]) {
            _singleSeasonPassTDsRecord = nil;
        } else {
            _singleSeasonPassTDsRecord = [decoder decodeObjectForKey:@"singleSeasonPassTDsRecord"];
        }

        if (![decoder containsValueForKey:@"singleSeasonInterceptionsRecord"]) {
            _singleSeasonInterceptionsRecord = nil;
        } else {
            _singleSeasonInterceptionsRecord = [decoder decodeObjectForKey:@"singleSeasonInterceptionsRecord"];
        }

        // rush records
        if (![decoder containsValueForKey:@"singleSeasonFumblesRecord"]) {
            _singleSeasonFumblesRecord = nil;
        } else {
            _singleSeasonFumblesRecord = [decoder decodeObjectForKey:@"singleSeasonFumblesRecord"];
        }

        if (![decoder containsValueForKey:@"singleSeasonRushYardsRecord"]) {
            _singleSeasonRushYardsRecord = nil;
        } else {

            _singleSeasonRushYardsRecord = [decoder decodeObjectForKey:@"singleSeasonRushYardsRecord"];
        }

        if (![decoder containsValueForKey:@"singleSeasonRushTDsRecord"]) {
            _singleSeasonRushTDsRecord = nil;
        } else {
            _singleSeasonRushTDsRecord = [decoder decodeObjectForKey:@"singleSeasonRushTDsRecord"];
        }

        if (![decoder containsValueForKey:@"singleSeasonCarriesRecord"]) {
            _singleSeasonCarriesRecord = nil;
        } else {
            _singleSeasonCarriesRecord = [decoder decodeObjectForKey:@"singleSeasonCarriesRecord"];
        }


        //rec records
        if (![decoder containsValueForKey:@"singleSeasonRecYardsRecord"]) {
            _singleSeasonRecYardsRecord = nil;
        } else {

            _singleSeasonRecYardsRecord = [decoder decodeObjectForKey:@"singleSeasonRecYardsRecord"];
        }

        if (![decoder containsValueForKey:@"singleSeasonRecTDsRecord"]) {
            _singleSeasonRecTDsRecord = nil;
        } else {
            _singleSeasonRecTDsRecord = [decoder decodeObjectForKey:@"singleSeasonRecTDsRecord"];
        }

        if (![decoder containsValueForKey:@"singleSeasonCatchesRecord"]) {
            _singleSeasonCatchesRecord = nil;
        } else {
            _singleSeasonCatchesRecord = [decoder decodeObjectForKey:@"singleSeasonCatchesRecord"];
        }

        //kick records
        if (![decoder containsValueForKey:@"singleSeasonXpMadeRecord"]) {
            _singleSeasonXpMadeRecord = nil;
        } else {
            _singleSeasonXpMadeRecord = [decoder decodeObjectForKey:@"singleSeasonXpMadeRecord"];
        }

        if (![decoder containsValueForKey:@"singleSeasonFgMadeRecord"]) {
            _singleSeasonFgMadeRecord = nil;
        } else {
            _singleSeasonFgMadeRecord = [decoder decodeObjectForKey:@"singleSeasonFgMadeRecord"];
        }

        //career
        //pass records
        if (![decoder containsValueForKey:@"careerCompletionsRecord"]) {
            _careerCompletionsRecord = nil;
        } else {
            _careerCompletionsRecord = [decoder decodeObjectForKey:@"careerCompletionsRecord"];
        }

        if (![decoder containsValueForKey:@"careerPassYardsRecord"]) {
            _careerPassYardsRecord = nil;
        } else {

            _careerPassYardsRecord = [decoder decodeObjectForKey:@"careerPassYardsRecord"];
        }

        if (![decoder containsValueForKey:@"careerPassTDsRecord"]) {
            _careerPassTDsRecord = nil;
        } else {
            _careerPassTDsRecord = [decoder decodeObjectForKey:@"careerPassTDsRecord"];
        }

        if (![decoder containsValueForKey:@"careerInterceptionsRecord"]) {
            _careerInterceptionsRecord = nil;
        } else {
            _careerInterceptionsRecord = [decoder decodeObjectForKey:@"careerInterceptionsRecord"];
        }

        // rush records
        if (![decoder containsValueForKey:@"careerFumblesRecord"]) {
            _careerFumblesRecord = nil;
        } else {
            _careerFumblesRecord = [decoder decodeObjectForKey:@"careerFumblesRecord"];
        }

        if (![decoder containsValueForKey:@"careerRushYardsRecord"]) {
            _careerRushYardsRecord = nil;
        } else {

            _careerRushYardsRecord = [decoder decodeObjectForKey:@"careerRushYardsRecord"];
        }

        if (![decoder containsValueForKey:@"careerRushTDsRecord"]) {
            _careerRushTDsRecord = nil;
        } else {
            _careerRushTDsRecord = [decoder decodeObjectForKey:@"careerRushTDsRecord"];
        }

        if (![decoder containsValueForKey:@"careerCarriesRecord"]) {
            _careerCarriesRecord = nil;
        } else {
            _careerCarriesRecord = [decoder decodeObjectForKey:@"careerCarriesRecord"];
        }


        //rec records
        if (![decoder containsValueForKey:@"careerRecYardsRecord"]) {
            _careerRecYardsRecord = nil;
        } else {

            _careerRecYardsRecord = [decoder decodeObjectForKey:@"careerRecYardsRecord"];
        }

        if (![decoder containsValueForKey:@"careerRecTDsRecord"]) {
            _careerRecTDsRecord = nil;
        } else {
            _careerRecTDsRecord = [decoder decodeObjectForKey:@"careerRecTDsRecord"];
        }

        if (![decoder containsValueForKey:@"careerCatchesRecord"]) {
            _careerCatchesRecord = nil;
        } else {
            _careerCatchesRecord = [decoder decodeObjectForKey:@"careerCatchesRecord"];
        }

        //kick records
        if (![decoder containsValueForKey:@"careerXpMadeRecord"]) {
            _careerXpMadeRecord = nil;
        } else {
            _careerXpMadeRecord = [decoder decodeObjectForKey:@"careerXpMadeRecord"];
        }

        if (![decoder containsValueForKey:@"careerFgMadeRecord"]) {
            _careerFgMadeRecord = nil;
        } else {
            _careerFgMadeRecord = [decoder decodeObjectForKey:@"careerFgMadeRecord"];
        }

        //deprecated
        leagueRecordYearPassYards = 0;
        leagueRecordYearCompletions = 0;
        leagueRecordYearPassTDs = 0;
        leagueRecordYearRushTDs = 0;
        leagueRecordYearRushYards = 0;
        leagueRecordYearRushAtt = 0;
        leagueRecordYearFum = 0;
        leagueRecordYearInt = 0;
        leagueRecordYearRecTDs = 0;
        leagueRecordYearRecYards = 0;
        leagueRecordYearReceptions = 0;
        leagueRecordYearXPMade = 0;
        leagueRecordYearFGMade = 0;
        leagueRecordPassYards = 0;
        leagueRecordCompletions = 0;
        leagueRecordPassTDs = 0;
        leagueRecordRushTDs = 0;
        leagueRecordRushAtt = 0;
        leagueRecordRushYards = 0;
        leagueRecordRecYards = 0;
        leagueRecordRecTDs = 0;
        leagueRecordReceptions = 0;
        leagueRecordFum = 0;
        leagueRecordInt = 0;
        leagueRecordXPMade = 0;
        leagueRecordFGMade = 0;


    }
    return self;
}

-(NSArray*)singleSeasonRecords {
    NSMutableArray *records = [NSMutableArray array];
    if (_singleSeasonCompletionsRecord != nil) {
        [records addObject:_singleSeasonCompletionsRecord];
    }

    if (_singleSeasonPassYardsRecord != nil) {
        [records addObject:_singleSeasonPassYardsRecord];
    }

    if (_singleSeasonPassTDsRecord != nil) {
        [records addObject:_singleSeasonPassTDsRecord];
    }

    if (_singleSeasonInterceptionsRecord != nil) {
        [records addObject:_singleSeasonInterceptionsRecord];
    }

    if (_singleSeasonCarriesRecord != nil) {
        [records addObject:_singleSeasonCarriesRecord];
    }

    if (_singleSeasonRushYardsRecord != nil) {
        [records addObject:_singleSeasonRushYardsRecord];
    }

    if (_singleSeasonRushTDsRecord != nil) {
        [records addObject:_singleSeasonRushTDsRecord];
    }

    if (_singleSeasonFumblesRecord != nil) {
        [records addObject:_singleSeasonFumblesRecord];
    }

    if (_singleSeasonCatchesRecord != nil) {
        [records addObject:_singleSeasonCatchesRecord];
    }

    if (_singleSeasonRecYardsRecord != nil) {
        [records addObject:_singleSeasonRecYardsRecord];
    }

    if (_singleSeasonRecTDsRecord != nil) {
        [records addObject:_singleSeasonRecTDsRecord];
    }

    if (_singleSeasonXpMadeRecord != nil) {
        [records addObject:_singleSeasonXpMadeRecord];
    }

    if (_singleSeasonFgMadeRecord != nil) {
        [records addObject:_singleSeasonFgMadeRecord];
    }

    return records;
}

-(NSArray*)careerRecords {
    NSMutableArray *records = [NSMutableArray array];
    if (_careerCompletionsRecord != nil) {
        [records addObject:_careerCompletionsRecord];
    }

    if (_careerPassYardsRecord != nil) {
        [records addObject:_careerPassYardsRecord];
    }

    if (_careerPassTDsRecord != nil) {
        [records addObject:_careerPassTDsRecord];
    }

    if (_careerInterceptionsRecord != nil) {
        [records addObject:_careerInterceptionsRecord];
    }

    if (_careerCarriesRecord != nil) {
        [records addObject:_careerCarriesRecord];
    }

    if (_careerRushYardsRecord != nil) {
        [records addObject:_careerRushYardsRecord];
    }

    if (_careerRushTDsRecord != nil) {
        [records addObject:_careerRushTDsRecord];
    }

    if (_careerFumblesRecord != nil) {
        [records addObject:_careerFumblesRecord];
    }

    if (_careerCatchesRecord != nil) {
        [records addObject:_careerCatchesRecord];
    }

    if (_careerRecYardsRecord != nil) {
        [records addObject:_careerRecYardsRecord];
    }

    if (_careerRecTDsRecord != nil) {
        [records addObject:_careerRecTDsRecord];
    }

    if (_careerXpMadeRecord != nil) {
        [records addObject:_careerXpMadeRecord];
    }

    if (_careerFgMadeRecord != nil) {
        [records addObject:_careerFgMadeRecord];
    }

    return records;
}

-(BOOL)isSaveCorrupt {
    for (Team *t in _teamList) {
        if (t.teamQBs.count < 2 || t.teamRBs.count < 4 || t.teamWRs.count < 6 || t.teamOLs.count < 10 || t.teamF7s.count < 14 || t.teamCBs.count < 6 || t.teamSs.count < 2 || t.teamKs.count < 2) {
            return YES;
        }
    }
    return NO;
}

-(void)save {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"saveInProgress" object:nil];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        if([FCFileManager existsItemAtPath:@"league.cfb"]) {
            NSError *error;
            BOOL success = [FCFileManager writeFileAtPath:@"league.cfb" content:[NSKeyedArchiver archivedDataWithRootObject:self] error:&error];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                if (success) {
                    NSLog(@"Save was successful");
                } else {
                    NSLog(@"Something went wrong on save: %@", error.localizedDescription);
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"saveFinished" object:nil];
            });
        } else {
            //Run UI Updates
            NSError *error;
            BOOL success = [FCFileManager createFileAtPath:@"league.cfb" withContent:[NSKeyedArchiver archivedDataWithRootObject:self] error:&error];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                if (success) {
                    NSLog(@"Create and Save were successful");
                } else {
                    NSLog(@"Something went wrong on create and save: %@", error.localizedDescription);
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"saveFinished" object:nil];
            });
        }
    });
}

+(BOOL)loadSavedData {
    if ([FCFileManager existsItemAtPath:@"league.cfb"]) {
        League *ligue = (League*)[NSKeyedUnarchiver unarchiveObjectWithData:[FCFileManager readFileAtPathAsData:@"league.cfb"]];
         [ligue setUserTeam:ligue.userTeam];
         [(AppDelegate*)[[UIApplication sharedApplication] delegate] setLeague:ligue];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"newNewsStory" object:nil];
        return YES;
    } else {
        return NO;
    }
}

-(instancetype)initWithSaveFile:(NSString*)saveFileName names:(NSString*)nameCSV {
    self = [super init];
    if (self) {
        _recruitingStage = 0;
        heismanDecided = NO;
        _hasScheduledBowls = NO;
        _currentWeek = 0;
        League *ligue = (League*)[FCFileManager readFileAtPathAsCustomModel:saveFileName];
        self = ligue;
    }
    return self;
}

-(instancetype)loadFromSaveFileWithNames:(NSString*)namesCSV {
    return [[League alloc] initWithSaveFile:@"league.cfb" names:namesCSV];
}

-(NSArray*)bowlGameTitles {
    return @[@"Lilac Bowl", @"Apple Bowl", @"Salty Bowl", @"Salsa Bowl", @"Mango Bowl",@"Patriot Bowl", @"Salad Bowl", @"Frost Bowl", @"Tropical Bowl", @"Music Bowl"];
}

+(instancetype)newLeagueFromCSV:(NSString*)namesCSV {
    return [[League alloc] initFromCSV:namesCSV];
}

+(instancetype)newLeagueFromSaveFile:(NSString*)saveFileName names:(NSString*)namesCSV {
    return [[League alloc] initWithSaveFile:saveFileName names:namesCSV];
}

-(instancetype)initFromCSV:(NSString*)namesCSV {
    self = [super init];
    if (self){
        _isHardMode = NO;
        _recruitingStage = 0;
        heismanDecided = NO;
        _hasScheduledBowls = NO;
        _hallOfFamers = [NSMutableArray array];
        leagueHistory = [NSMutableArray array];
        _leagueHistoryDictionary = [NSMutableDictionary dictionary];
        heismanHistory = [NSMutableArray array];
        _heismanHistoryDictionary = [NSMutableDictionary dictionary];
        _heismanFinalists = [NSMutableArray array];
        _heisman = nil;
        _currentWeek = 0;
        _bowlGames = [NSMutableArray array];
        _conferences = [NSMutableArray array];
        _blessedTeam = nil;
        _cursedTeam = nil;
        _blessedStoryIndex = 0;
        _cursedStoryIndex = 0;

        _careerCompletionsRecord = nil;
        _careerPassYardsRecord = nil;
        _careerPassTDsRecord = nil;
        _careerInterceptionsRecord = nil;
        _careerFumblesRecord = nil;
        _careerRushYardsRecord = nil;
        _careerRushTDsRecord = nil;
        _careerCarriesRecord = nil;
        _careerRecYardsRecord = nil;
        _careerRecTDsRecord = nil;
        _careerCatchesRecord = nil;
        _careerXpMadeRecord = nil;
        _careerFgMadeRecord = nil;

        _singleSeasonCompletionsRecord = nil;
        _singleSeasonPassYardsRecord = nil;
        _singleSeasonPassTDsRecord = nil;
        _singleSeasonInterceptionsRecord = nil;
        _singleSeasonFumblesRecord = nil;
        _singleSeasonRushYardsRecord = nil;
        _singleSeasonRushTDsRecord = nil;
        _singleSeasonCarriesRecord = nil;
        _singleSeasonRecYardsRecord = nil;
        _singleSeasonRecTDsRecord = nil;
        _singleSeasonCatchesRecord = nil;
        _singleSeasonXpMadeRecord = nil;
        _singleSeasonFgMadeRecord = nil;

        [_conferences addObject:[Conference newConferenceWithName:@"SOUTH" fullName:@"Southern" league:self]];
        [_conferences addObject:[Conference newConferenceWithName:@"LAKES" fullName:@"Lakes" league:self]];
        [_conferences addObject:[Conference newConferenceWithName:@"NORTH" fullName:@"North" league:self]];
        [_conferences addObject:[Conference newConferenceWithName:@"COWBY" fullName:@"Cowboy" league:self]];
        [_conferences addObject:[Conference newConferenceWithName:@"PACIF" fullName:@"Pacific" league:self]];
        [_conferences addObject:[Conference newConferenceWithName:@"MOUNT" fullName:@"Mountain" league:self]];

        _newsStories = [NSMutableArray array];
        for (int i = 0; i < 16; i++) {
            [_newsStories addObject:[NSMutableArray array]];
        }

        NSMutableArray *first = _newsStories[0];
        [first addObject:@"New Season!\nReady for the new season, coach? Whether the National Championship is on your mind, or just a winning season, good luck!"];

        _nameList = [NSMutableArray array];
        NSArray *namesSplit = [namesCSV componentsSeparatedByString:@","];
        for (NSString *n in namesSplit) {
            [_nameList addObject:[n stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]]];
        }

        Conference *south = _conferences[0];
        Conference *lakes = _conferences[1];
        Conference *north = _conferences[2];
        Conference *cowboy = _conferences[3];
        Conference *pacific = _conferences[4];
        Conference *mountain = _conferences[5];

        //SOUTH
        [south.confTeams addObject:[Team newTeamWithName:@"Alabama" abbreviation:@"ALA" conference:@"SOUTH" league:self prestige:95 rivalTeam:@"GEO"]]; //"Alabama", "ALA", "SOUTH", this, 95, "GEO" )
        [south.confTeams addObject:[Team newTeamWithName:@"Georgia" abbreviation:@"GEO" conference:@"SOUTH" league:self prestige:90 rivalTeam:@"ALA"]];//south.confTeams.add( new Team( "Georgia", "GEO", "SOUTH", this, 90, "ALA" ));
        [south.confTeams addObject:[Team newTeamWithName:@"Florida" abbreviation:@"FLA" conference:@"SOUTH" league:self prestige:85 rivalTeam:@"TEN"]];//south.confTeams.add( new Team( "Florida", "FLA", "SOUTH", this, 85, "TEN" ));
        [south.confTeams addObject:[Team newTeamWithName:@"Tennessee" abbreviation:@"TEN" conference:@"SOUTH" league:self prestige:80 rivalTeam:@"FLA"]];//south.confTeams.add( new Team( "Tennessee", "TEN", "SOUTH", this, 80, "FLA" ));
        [south.confTeams addObject:[Team newTeamWithName:@"Atlanta" abbreviation:@"ATL" conference:@"SOUTH" league:self prestige:75 rivalTeam:@"KYW"]];//south.confTeams.add( new Team( "Atlanta", "ATL", "SOUTH", this, 75, "KYW" ));
        [south.confTeams addObject:[Team newTeamWithName:@"New Orleans" abbreviation:@"NOR" conference:@"SOUTH" league:self prestige:75 rivalTeam:@"LOU"]];//south.confTeams.add( new Team( "New Orleans", "NOR", "SOUTH", this, 75, "LOU" ));
        [south.confTeams addObject:[Team newTeamWithName:@"Arkansas" abbreviation:@"ARK" conference:@"SOUTH" league:self prestige:70 rivalTeam:@"KTY"]];//south.confTeams.add( new Team( "Arkansas", "ARK", "SOUTH", this, 70, "KTY" ));
        [south.confTeams addObject:[Team newTeamWithName:@"Louisiana" abbreviation:@"LOU" conference:@"SOUTH" league:self prestige:65 rivalTeam:@"NOR"]];//south.confTeams.add( new Team( "Louisiana", "LOU", "SOUTH", this, 65, "NOR" ));
        [south.confTeams addObject:[Team newTeamWithName:@"Key West" abbreviation:@"KYW" conference:@"SOUTH" league:self prestige:65 rivalTeam:@"ATL"]];//south.confTeams.add( new Team( "Key West", "KYW", "SOUTH", this, 65, "ATL" ));
        [south.confTeams addObject:[Team newTeamWithName:@"Kentucky" abbreviation:@"KTY" conference:@"SOUTH" league:self prestige:50 rivalTeam:@"ARK"]];//south.confTeams.add( new Team( "Kentucky", "KTY", "SOUTH", this, 50, "ARK" ));


         //LAKES
         [lakes.confTeams addObject:[Team newTeamWithName:@"Ohio State" abbreviation:@"OHI" conference:@"LAKES" league:self prestige:90 rivalTeam:@"MIC"]];//lakes.confTeams.add( new Team( "Ohio State", "OHI", "LAKES", this, 90, "MIC" ));
         [lakes.confTeams addObject:[Team newTeamWithName:@"Michigan" abbreviation:@"MIC" conference:@"LAKES" league:self prestige:90 rivalTeam:@"MIC"]];//lakes.confTeams.add( new Team( "Michigan", "MIC", "LAKES", this, 90, "OHI" ));
         [lakes.confTeams addObject:[Team newTeamWithName:@"Michigan St" abbreviation:@"MSU" conference:@"LAKES" league:self prestige:80 rivalTeam:@"MIN"]];//lakes.confTeams.add( new Team( "Michigan St", "MSU", "LAKES", this, 80, "MIN" ));
         [lakes.confTeams addObject:[Team newTeamWithName:@"Wisconsin" abbreviation:@"WIS" conference:@"LAKES" league:self prestige:70 rivalTeam:@"IND"]];//lakes.confTeams.add( new Team( "Wisconsin", "WIS", "LAKES", this, 70, "IND" ));
         [lakes.confTeams addObject:[Team newTeamWithName:@"Minnesota" abbreviation:@"MIN" conference:@"LAKES" league:self prestige:70 rivalTeam:@"MSU"]];//lakes.confTeams.add( new Team( "Minnesota", "MIN", "LAKES", this, 70, "MSU" ));
         [lakes.confTeams addObject:[Team newTeamWithName:@"Univ of Chicago" abbreviation:@"CHI" conference:@"LAKES" league:self prestige:70 rivalTeam:@"DET"]];//lakes.confTeams.add( new Team( "Univ of Chicago", "CHI", "LAKES", this, 70, "DET" ));
         [lakes.confTeams addObject:[Team newTeamWithName:@"Detroit St" abbreviation:@"DET" conference:@"LAKES" league:self prestige:65 rivalTeam:@"CHI"]];//lakes.confTeams.add( new Team( "Detroit St", "DET", "LAKES", this, 65, "CHI" ));
         [lakes.confTeams addObject:[Team newTeamWithName:@"Indiana" abbreviation:@"IND" conference:@"LAKES" league:self prestige:65 rivalTeam:@"WIS"]];//lakes.confTeams.add( new Team( "Indiana", "IND", "LAKES", this, 65, "WIS" ));
         [lakes.confTeams addObject:[Team newTeamWithName:@"Cleveland State" abbreviation:@"CLE" conference:@"LAKES" league:self prestige:55 rivalTeam:@"MIL"]];//lakes.confTeams.add( new Team( "Cleveland St", "CLE", "LAKES", this, 55, "MIL" ));
         [lakes.confTeams addObject:[Team newTeamWithName:@"Milwaukee" abbreviation:@"MIL" conference:@"LAKES" league:self prestige:45 rivalTeam:@"CLE"]];//lakes.confTeams.add( new Team( "Milwaukee", "MIL", "LAKES", this, 45, "CLE" ));

         //NORTH
        [north.confTeams addObject:[Team newTeamWithName:@"New York St" abbreviation:@"NYS" conference:@"NORTH" league:self prestige:90 rivalTeam:@"NYC"]];//north.confTeams.add( new Team( "New York St", "NYS", "NORTH", this, 90, "NYC" ));
         [north.confTeams addObject:[Team newTeamWithName:@"New Jersey" abbreviation:@"NWJ" conference:@"NORTH" league:self prestige:85 rivalTeam:@"PEN"]];//north.confTeams.add( new Team( "New Jersey", "NWJ", "NORTH", this, 85, "PEN" ));
         [north.confTeams addObject:[Team newTeamWithName:@"New York City" abbreviation:@"NYC" conference:@"NORTH" league:self prestige:75 rivalTeam:@"NYS"]];//north.confTeams.add( new Team( "New York City", "NYC", "NORTH", this, 75, "NYS" ));
         [north.confTeams addObject:[Team newTeamWithName:@"Pennsylvania" abbreviation:@"PEN" conference:@"NORTH" league:self prestige:75 rivalTeam:@"NWJ"]];//north.confTeams.add( new Team( "Pennsylvania", "PEN", "NORTH", this, 75, "NWJ" ));
         [north.confTeams addObject:[Team newTeamWithName:@"Maryland" abbreviation:@"MAR" conference:@"NORTH" league:self prestige:70 rivalTeam:@"WDC"]];//north.confTeams.add( new Team( "Maryland", "MAR", "NORTH", this, 70, "WDC" ));
         [north.confTeams addObject:[Team newTeamWithName:@"Washington DC" abbreviation:@"WDC" conference:@"NORTH" league:self prestige:70 rivalTeam:@"MAR"]];//north.confTeams.add( new Team( "Washington DC", "WDC", "NORTH", this, 70, "MAR" ));
         [north.confTeams addObject:[Team newTeamWithName:@"Boston St" abbreviation:@"BOS" conference:@"NORTH" league:self prestige:65 rivalTeam:@"VER"]];//north.confTeams.add( new Team( "Boston St", "BOS", "NORTH", this, 65, "VER" ));
         [north.confTeams addObject:[Team newTeamWithName:@"Pittsburgh" abbreviation:@"PIT" conference:@"NORTH" league:self prestige:60 rivalTeam:@"MAI"]];//north.confTeams.add( new Team( "Pittsburgh", "PIT", "NORTH", this, 60, "MAI" ));
         [north.confTeams addObject:[Team newTeamWithName:@"Maine" abbreviation:@"MAI" conference:@"NORTH" league:self prestige:50 rivalTeam:@"PIT"]];//north.confTeams.add( new Team( "Maine", "MAI", "NORTH", this, 50, "PIT" ));
         [north.confTeams addObject:[Team newTeamWithName:@"Vermont" abbreviation:@"VER" conference:@"NORTH" league:self prestige:45 rivalTeam:@"BOS"]];//north.confTeams.add( new Team( "Vermont", "VER", "NORTH", this, 45, "BOS" ));

         //COWBY
         [cowboy.confTeams addObject:[Team newTeamWithName:@"Oklahoma" abbreviation:@"OKL" conference:@"COWBY" league:self prestige:90 rivalTeam:@"TEX"]];//cowboy.confTeams.add( new Team( "Oklahoma", "OKL", "COWBY", this, 90, "TEX" ));
         [cowboy.confTeams addObject:[Team newTeamWithName:@"Texas" abbreviation:@"TEX" conference:@"COWBY" league:self prestige:90 rivalTeam:@"OKL"]];//cowboy.confTeams.add( new Team( "Texas", "TEX", "COWBY", this, 90, "OKL" ));
         [cowboy.confTeams addObject:[Team newTeamWithName:@"Houston" abbreviation:@"HOU" conference:@"COWBY" league:self prestige:80 rivalTeam:@"DAL"]];//cowboy.confTeams.add( new Team( "Houston", "HOU", "COWBY", this, 80, "DAL" ));
         [cowboy.confTeams addObject:[Team newTeamWithName:@"Dallas" abbreviation:@"DAL" conference:@"COWBY" league:self prestige:80 rivalTeam:@"HOU"]];//cowboy.confTeams.add( new Team( "Dallas", "DAL", "COWBY", this, 80, "HOU" ));
         [cowboy.confTeams addObject:[Team newTeamWithName:@"Alamo St" abbreviation:@"AMO" conference:@"COWBY" league:self prestige:70 rivalTeam:@"PAS"]];//cowboy.confTeams.add( new Team( "Alamo St", "AMO", "COWBY", this, 70, "PAS" ));
         [cowboy.confTeams addObject:[Team newTeamWithName:@"Oklahoma St" abbreviation:@"OKS" conference:@"COWBY" league:self prestige:70 rivalTeam:@"TUL"]];//cowboy.confTeams.add( new Team( "Oklahoma St", "OKS", "COWBY", this, 70, "TUL" ));
         [cowboy.confTeams addObject:[Team newTeamWithName:@"El Paso St" abbreviation:@"PAS" conference:@"COWBY" league:self prestige:60 rivalTeam:@"AMO"]];//cowboy.confTeams.add( new Team( "El Paso St", "PAS", "COWBY", this, 60, "AMO" ));
         [cowboy.confTeams addObject:[Team newTeamWithName:@"Texas St" abbreviation:@"TXS" conference:@"COWBY" league:self prestige:60 rivalTeam:@"AUS"]];//cowboy.confTeams.add( new Team( "Texas St", "TXS", "COWBY", this, 60, "AUS" ));
         [cowboy.confTeams addObject:[Team newTeamWithName:@"Tulsa" abbreviation:@"TUL" conference:@"COWBY" league:self prestige:55 rivalTeam:@"OKS"]];//cowboy.confTeams.add( new Team( "Tulsa", "TUL", "COWBY", this, 55, "OKS" ));
         [cowboy.confTeams addObject:[Team newTeamWithName:@"Univ of Austin" abbreviation:@"AUS" conference:@"COWBY" league:self prestige:50 rivalTeam:@"TXS"]];//cowboy.confTeams.add( new Team( "Univ of Austin", "AUS", "COWBY", this, 50, "TXS" ));

         //PACIF
         [pacific.confTeams addObject:[Team newTeamWithName:@"California" abbreviation:@"CAL" conference:@"PACIF" league:self prestige:90 rivalTeam:@"ULA"]];//pacific.confTeams.add( new Team( "California", "CAL", "PACIF", this, 90, "ULA" ));
         [pacific.confTeams addObject:[Team newTeamWithName:@"Oregon" abbreviation:@"ORE" conference:@"PACIF" league:self prestige:85 rivalTeam:@"WAS"]];//pacific.confTeams.add( new Team( "Oregon", "ORE", "PACIF", this, 85, "WAS" ));
         [pacific.confTeams addObject:[Team newTeamWithName:@"Los Angeles" abbreviation:@"ULA" conference:@"PACIF" league:self prestige:80 rivalTeam:@"CAL"]];//pacific.confTeams.add( new Team( "Los Angeles", "ULA", "PACIF", this, 80, "CAL" ));
         [pacific.confTeams addObject:[Team newTeamWithName:@"Oakland St" abbreviation:@"OAK" conference:@"PACIF" league:self prestige:75 rivalTeam:@"HOL"]];//pacific.confTeams.add( new Team( "Oakland St", "OAK", "PACIF", this, 75, "HOL" ));
         [pacific.confTeams addObject:[Team newTeamWithName:@"Washington" abbreviation:@"WAS" conference:@"PACIF" league:self prestige:75 rivalTeam:@"ORE"]];//pacific.confTeams.add( new Team( "Washington", "WAS", "PACIF", this, 75, "ORE" ));
         [pacific.confTeams addObject:[Team newTeamWithName:@"Hawaii" abbreviation:@"HAW" conference:@"PACIF" league:self prestige:70 rivalTeam:@"SAM"]];//pacific.confTeams.add( new Team( "Hawaii", "HAW", "PACIF", this, 70, "SAM" ));
         [pacific.confTeams addObject:[Team newTeamWithName:@"Seattle" abbreviation:@"SEA" conference:@"PACIF" league:self prestige:70 rivalTeam:@"SAN"]];//pacific.confTeams.add( new Team( "Seattle", "SEA", "PACIF", this, 70, "SAN" ));
         [pacific.confTeams addObject:[Team newTeamWithName:@"Hollywood St" abbreviation:@"HOL" conference:@"PACIF" league:self prestige:70 rivalTeam:@"OAK"]];//pacific.confTeams.add( new Team( "Hollywood St", "HOL", "PACIF", this, 70, "OAK" ));
         [pacific.confTeams addObject:[Team newTeamWithName:@"San Diego St" abbreviation:@"SAN" conference:@"PACIF" league:self prestige:60 rivalTeam:@"SEA"]];//pacific.confTeams.add( new Team( "San Diego St", "SAN", "PACIF", this, 60, "SEA" ));
         [pacific.confTeams addObject:[Team newTeamWithName:@"American Samoa" abbreviation:@"SAM" conference:@"PACIF" league:self prestige:25 rivalTeam:@"HAW"]];//pacific.confTeams.add( new Team( "American Samoa", "SAM", "PACIF", this, 25, "HAW" ));

         //MOUNT
         [mountain.confTeams addObject:[Team newTeamWithName:@"Colorado" abbreviation:@"COL" conference:@"MOUNT" league:self prestige:80 rivalTeam:@"DEN"]];//mountain.confTeams.add( new Team( "Colorado", "COL", "MOUNT", this, 80, "DEN" ));
         [mountain.confTeams addObject:[Team newTeamWithName:@"Yellowstone St" abbreviation:@"YEL" conference:@"MOUNT" league:self prestige:75 rivalTeam:@"ALB"]];//mountain.confTeams.add( new Team( "Yellowstone St", "YEL", "MOUNT", this, 75, "ALB" ));
         [mountain.confTeams addObject:[Team newTeamWithName:@"Utah" abbreviation:@"UTA" conference:@"MOUNT" league:self prestige:75 rivalTeam:@"SAL"]];//mountain.confTeams.add( new Team( "Utah", "UTA", "MOUNT", this, 75, "SAL" ));
         [mountain.confTeams addObject:[Team newTeamWithName:@"Univ of Denver" abbreviation:@"DEN" conference:@"MOUNT" league:self prestige:75 rivalTeam:@"COL"]];//mountain.confTeams.add( new Team( "Univ of Denver", "DEN", "MOUNT", this, 75, "COL" ));
         [mountain.confTeams addObject:[Team newTeamWithName:@"Albuquerque" abbreviation:@"ALB" conference:@"MOUNT" league:self prestige:70 rivalTeam:@"YEL"]];//mountain.confTeams.add( new Team( "Albuquerque", "ALB", "MOUNT", this, 70, "YEL" ));
         [mountain.confTeams addObject:[Team newTeamWithName:@"Salt Lake St" abbreviation:@"SAL" conference:@"MOUNT" league:self prestige:65 rivalTeam:@"UTA"]];//mountain.confTeams.add( new Team( "Salt Lake St", "SAL", "MOUNT", this, 65, "UTA" ));
         [mountain.confTeams addObject:[Team newTeamWithName:@"Wyoming" abbreviation:@"WYO" conference:@"MOUNT" league:self prestige:60 rivalTeam:@"MON"]];//mountain.confTeams.add( new Team( "Wyoming", "WYO", "MOUNT", this, 60, "MON" ));
         [mountain.confTeams addObject:[Team newTeamWithName:@"Montana" abbreviation:@"MON" conference:@"MOUNT" league:self prestige:55 rivalTeam:@"WYO"]];//mountain.confTeams.add( new Team( "Montana", "MON", "MOUNT", this, 55, "WYO" ));
         [mountain.confTeams addObject:[Team newTeamWithName:@"Las Vegas" abbreviation:@"LSV" conference:@"MOUNT" league:self prestige:50 rivalTeam:@"PHO"]];//mountain.confTeams.add( new Team( "Las Vegas", "LSV", "MOUNT", this, 50, "PHO" ));
         [mountain.confTeams addObject:[Team newTeamWithName:@"Phoenix" abbreviation:@"PHO" conference:@"MOUNT" league:self prestige:45 rivalTeam:@"LSV"]];//mountain.confTeams.add( new Team( "Phoenix", "PHO", "MOUNT", this, 45, "LSV" ));


        _teamList = [NSMutableArray array];
        for (int i = 0; i < _conferences.count; ++i ) {
            for (int j = 0; j < [[_conferences[i] confTeams] count]; j++ ) {
                [_teamList addObject:[_conferences[i] confTeams][j]];
            }
        }

        //set up schedule
        for (int i = 0; i < _conferences.count; ++i ) {
            [_conferences[i] setUpSchedule];
        }
        for (int i = 0; i < _conferences.count; ++i ) {
            [_conferences[i] setUpOOCSchedule ];
        }
        for (int i = 0; i < _conferences.count; ++i ) {
            [_conferences[i] insertOOCSchedule];
        }
    }
    return self;
}

-(int)getConfNumber:(NSString*)conf {
    if ([conf isEqualToString:@"SOUTH"]) return 0;
    if ([conf isEqualToString:@"LAKES"]) return 1;
    if ([conf isEqualToString:@"NORTH"]) return 2;
    if ([conf isEqualToString:@"COWBY"]) return 3;
    if ([conf isEqualToString:@"PACIF"]) return 4;
    if ([conf isEqualToString:@"MOUNT"]) return 5;
    return 0;
}

-(void)playWeek {
    _canRebrandTeam = NO;
    
    if (_currentWeek <= 12 ) {
        for (int i = 0; i < _conferences.count; ++i) {
            [_conferences[i] playWeek];
        }


        // bless/curse progression updates should appear at week 6 (news stories index 6)
        //if blessed team wins > losses - post story about reaping benefits from blessing, otherwise, post story about them fumbling with it
        //if cursed team wins > losses - post story about success despite early season setbacks, otherwise, post story about how early setback has crippled team this season
        if (_currentWeek == 5) {
            NSMutableArray *newsWeek = _newsStories[6];
            if (_blessedTeam != nil && ![_blessedTeam isEqual:_userTeam]) {
                NSLog(@"BLESSED TEAM: %@ STORY: %ld COACH: %@", _blessedTeam.abbreviation, (long)_blessedStoryIndex, _blessedTeamCoachName);
                if (_blessedTeam.wins > _blessedTeam.losses) {
                    switch (_blessedStoryIndex) {
                        case 1: //new coach
                            [newsWeek addObject:[NSString stringWithFormat:@"%@'s (%ld-%ld) new hire making an impact early\nEarly on, it looks like %@'s unorthodox approach has created success at previously down-on-its-luck %@.",_blessedTeam.abbreviation,(long)_blessedTeam.wins, (long)_blessedTeam.losses,_blessedTeamCoachName, _blessedTeam.name]];
                            break;
                        case 3: //gatorade
                            [newsWeek addObject:[NSString stringWithFormat:@"%@'s new sports drink powering them to victory\nThe drink, developed last offseason, has spawned a revolution in the locker room at %@ (%ld-%ld), improving the team's play and conditioning.", _blessedTeam.abbreviation, _blessedTeam.name, (long)_blessedTeam.wins, (long)_blessedTeam.losses]];
                            break;
                        default:
                            break;
                    }
                } else {
                    switch (_blessedStoryIndex) {
                        case 1: //new coach
                            [newsWeek addObject:[NSString stringWithFormat:@"%@'s (%ld-%ld) new hire faltering early\n%@'s unorthodox approach has failed to take hold at %@, leaving the team floundering under .500.",_blessedTeam.abbreviation, (long)_blessedTeam.wins, (long)_blessedTeam.losses,_blessedTeamCoachName,_blessedTeam.name]];
                            break;
                        case 3: //gatorade
                            [newsWeek addObject:[NSString stringWithFormat:@"%@'s new sports drink flops\nThe drink, developed last offseason, was supposed to improve player hydration and conditioning at %@ (%ld-%ld), yet it has failed to make meaningful improvements early on this season.", _blessedTeam.abbreviation,_blessedTeam.name, (long)_blessedTeam.wins, (long)_blessedTeam.losses]];
                            break;
                        default:
                            break;
                    }
                }
            }

            if (_cursedTeam != nil && ![_cursedTeam isEqual:_userTeam]) {
                NSLog(@"CURSED TEAM: %@ STORY: %ld COACH: %@", _cursedTeam.abbreviation, (long)_cursedStoryIndex, _cursedTeamCoachName);
                if (_cursedTeam.wins > _cursedTeam.losses) {
                    switch (_cursedStoryIndex) {
                        case 1: //recruiting sanctions
                            [newsWeek addObject:[NSString stringWithFormat:@"%@ successful despite sanctions\n%@'s (%ld-%ld) limited recruiting ability has not hindered them yet, as the team has fought its way to success early on this season.",_cursedTeam.abbreviation,_cursedTeam.name, (long)_cursedTeam.wins, (long)_cursedTeam.losses]];
                            break;
                        case 3: //suspended coach
                            [newsWeek addObject:[NSString stringWithFormat:@"%@'s coach returns from suspension to an improved team\n%@ (%ld-%ld) gets back head coach %@ this week, and he comes back to a team playing well early on this season.", _cursedTeam.abbreviation, _cursedTeam.name, (long)_cursedTeam.wins, (long)_cursedTeam.losses, _cursedTeamCoachName]];
                            break;
                        case 5: //recruiting sanctions
                            [newsWeek addObject:[NSString stringWithFormat:@"%@ successful despite sanctions\n%@'s (%ld-%ld) limited recruiting ability has not hindered them yet, as the team has fought its way to success early on this season.",_cursedTeam.abbreviation,_cursedTeam.name, (long)_cursedTeam.wins, (long)_cursedTeam.losses]];
                            break;
                        default:
                            break;
                    }
                } else {
                    switch (_cursedStoryIndex) {
                        case 1: //recruiting sanctions
                            [newsWeek addObject:[NSString stringWithFormat:@"%@'s demons haunt them\n%@'s (%ld-%ld) limited recruiting ability has manifested itself in a sub-.500 season early on.",_cursedTeam.abbreviation,_cursedTeam.name, (long)_cursedTeam.wins, (long)_cursedTeam.losses]];
                            break;
                        case 3: //suspended coach
                            [newsWeek addObject:[NSString stringWithFormat:@"%@'s coach returns from suspension\n%@ (%ld-%ld) gets back head coach %@ this week, and he has his work cut out for him as the team has stumbled early on this year.", _cursedTeam.abbreviation, _cursedTeam.name, (long)_cursedTeam.wins, (long)_cursedTeam.losses, _cursedTeamCoachName]];
                            break;
                        case 5: //recruiting sanctions
                            [newsWeek addObject:[NSString stringWithFormat:@"%@'s demons haunt them\n%@'s (%ld-%ld) limited recruiting ability has manifested itself in a sub-.500 season early on.",_cursedTeam.abbreviation,_cursedTeam.name, (long)_cursedTeam.wins, (long)_cursedTeam.losses]];
                            break;
                        default:
                            break;
                    }
                }
            }
        }

        //calculate poty leader and post story about how he is leading competition
        if (_currentWeek == 9) {
            NSArray *heismanContenders = [self getHeismanLeaders];
            Player *heismanLeader = heismanContenders[0];
            NSMutableArray *week11 = _newsStories[10];
            [week11 addObject:[NSString stringWithFormat:@"%@'s %@ leads the pack\n%@ %@ %@ is the frontrunner for Player of the Year, playing a key role in the team's %ld-%ld season.", heismanLeader.team.abbreviation, [heismanLeader getInitialName], heismanLeader.team.name, heismanLeader.position, heismanLeader.name, (long)heismanLeader.team.wins, (long)heismanLeader.team.losses]];
        }
    }

    if (_currentWeek == 12) {
        //bowl week
        for (int i = 0; i < _teamList.count; ++i) {
            [_teamList[i] updatePollScore];
        }

        _teamList = [[_teamList sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            Team *a = (Team*)obj1;
            Team *b = (Team*)obj2;
            return a.teamPollScore > b.teamPollScore ? -1 : a.teamPollScore == b.teamPollScore ? 0 : 1;

        }] mutableCopy];

        [self scheduleBowlGames];
    } else if (_currentWeek == 13 ) {
        _heisman = [self calculateHeismanCandidates][0];
        [_heismanHistoryDictionary setObject:[NSString stringWithFormat:@"%@ %@ [%@], %@ (%ld-%ld)",_heisman.position,_heisman.getInitialName,_heisman.getYearString,_heisman.team.abbreviation,(long)_heisman.team.wins,(long)_heisman.team.losses] forKey:[NSString stringWithFormat:@"%ld",(long)(2016+_heismanHistoryDictionary.count)]];
        
        [self playBowlGames];

    } else if (_currentWeek == 14 ) {
        
        [_ncg playGame];
        if (_ncg.homeScore > _ncg.awayScore ) {
            //_ncg.homeTeam.semifinalWL = @"";
            //_ncg.awayTeam.semifinalWL = @"";
            _ncg.homeTeam.natlChampWL = @"NCW";
            _ncg.awayTeam.natlChampWL = @"NCL";
            _ncg.homeTeam.totalNCs++;
            _ncg.awayTeam.totalNCLosses++;
            NSMutableArray *week15 = _newsStories[15];
            [week15 addObject:[NSString stringWithFormat:@"%@ wins the National Championship!\n%@ defeats %@ in the national championship game %ld to %ld. Congratulations %@!", _ncg.homeTeam.name, [_ncg.homeTeam strRep], [_ncg.awayTeam strRep], (long)_ncg.homeScore, (long)_ncg.awayScore, _ncg.homeTeam.name]];

        } else {
            //_ncg.homeTeam.semifinalWL = @"";
            //_ncg.awayTeam.semifinalWL = @"";
            _ncg.awayTeam.natlChampWL = @"NCW";
            _ncg.homeTeam.natlChampWL = @"NCL";
            _ncg.awayTeam.totalNCs++;
            _ncg.homeTeam.totalNCLosses++;
            NSMutableArray *week15 = _newsStories[15];
            [week15 addObject:[NSString stringWithFormat:@"%@ wins the National Championship!\n%@ defeats %@ in the national championship game %ld to %ld. Congratulations %@!", _ncg.awayTeam.name, [_ncg.awayTeam strRep], [_ncg.homeTeam strRep], (long)_ncg.awayScore, (long)_ncg.homeScore, _ncg.awayTeam.name]];
        }
        
        [self refreshAllLeaguePlayers];
        for (Conference *c in _conferences) {
            [c refreshAllConferencePlayers];
        }
        [self completeProDraft];
        _canRebrandTeam = YES;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"newNewsStory" object:nil];

    [self setTeamRanks];
    _currentWeek++;
    //[self save];
}

-(void)scheduleBowlGames {
    //bowl week
    for (int i = 0; i < _teamList.count; ++i) {
        [_teamList[i] updatePollScore];
    }

    _teamList = [[_teamList sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Team *a = (Team*)obj1;
        Team *b = (Team*)obj2;
        return a.teamPollScore > b.teamPollScore ? -1 : a.teamPollScore == b.teamPollScore ? 0 : 1;

    }] mutableCopy];

    //semifinals
    _semiG14 = [Game newGameWithHome:_teamList[0] away:_teamList[3] name:@"Semis, 1v4"];
    [[_teamList[0] gameSchedule] addObject:_semiG14];
    [[_teamList[3] gameSchedule] addObject:_semiG14];

    _semiG23 = [Game newGameWithHome:_teamList[1] away:_teamList[2] name:@"Semis, 2v3"];
    [[_teamList[1] gameSchedule] addObject:_semiG23];
    [[_teamList[2] gameSchedule] addObject:_semiG23];

    //other bowls
    NSMutableArray *bowlEligibleTeams = [NSMutableArray array];
    for (int i = 4; i < ([self bowlGameTitles].count * 2); i++) {
        [bowlEligibleTeams addObject:_teamList[i]];
    }

    [_bowlGames removeAllObjects];
    int j = 0;
    int teamIndex = 0;
    while (j < [self bowlGameTitles].count && teamIndex < bowlEligibleTeams.count) {
        NSString *bowlName = [self bowlGameTitles][j];
        Team *home = bowlEligibleTeams[teamIndex];
        Team *away = bowlEligibleTeams[teamIndex + 1];
        Game *bowl = [Game newGameWithHome:home away:away name:bowlName];
        [_bowlGames addObject:bowl];
        [home.gameSchedule addObject:bowl];
        [away.gameSchedule addObject:bowl];
        j++;
        teamIndex+=2;
    }


    _hasScheduledBowls = true;

}

-(void)playBowlGames {
    NSMutableArray *bowlNews = _newsStories[14];
    [bowlNews removeAllObjects];

    for (Game *g in _bowlGames) {
        [self playBowl:g];
    }

    [_semiG14 playGame];
    [_semiG23 playGame];
    Team *semi14winner;
    Team *semi23winner;
    if (_semiG14.homeScore > _semiG14.awayScore ) {
        _semiG14.homeTeam.semifinalWL = @"SFW";
        _semiG14.homeTeam.totalBowls++;
        _semiG14.awayTeam.semifinalWL = @"SFL";
        _semiG14.awayTeam.totalBowlLosses++;
        semi14winner = _semiG14.homeTeam;
        //_newsStories.get(14).add(semiG14.homeTeam.name + " wins the " + semiG14.gameName +"!\n" + semiG14.homeTeam.strRep() + " defeats " + semiG14.awayTeam.strRep() + " in the semifinals, winning " + semiG14.homeScore + " to " + semiG14.awayScore + ". " + semiG14.homeTeam.name + " advances to the National Championship!" );
        NSMutableArray *week14 = _newsStories[14];
        [week14 addObject:[NSString stringWithFormat:@"%@ wins the %@!\n%@ defeats %@ in the semifinals, winning %ld to %ld. %@ advances to the National Championship!",_semiG14.homeTeam.name, _semiG14.gameName, _semiG14.homeTeam.strRep, _semiG14.awayTeam.strRep, (long)_semiG14.homeScore, (long)_semiG14.awayScore, _semiG14.homeTeam.name]];

    } else {
        _semiG14.homeTeam.semifinalWL = @"SFL";
        _semiG14.homeTeam.totalBowlLosses++;
        _semiG14.awayTeam.semifinalWL = @"SFW";
        _semiG14.awayTeam.totalBowls++;
        semi14winner = _semiG14.awayTeam;
        NSMutableArray *week14 = _newsStories[14];
        [week14 addObject:[NSString stringWithFormat:@"%@ wins the %@!\n%@ defeats %@ in the semifinals, winning %ld to %ld. %@ advances to the National Championship!",_semiG14.awayTeam.name, _semiG14.gameName, _semiG14.awayTeam.strRep, _semiG14.homeTeam.strRep, (long)_semiG14.awayScore, (long)_semiG14.homeScore, _semiG14.awayTeam.name]];
    }

    if (_semiG23.homeScore > _semiG23.awayScore ) {
        _semiG23.homeTeam.semifinalWL = @"SFW";
        _semiG23.homeTeam.totalBowls++;
        _semiG23.awayTeam.semifinalWL = @"SFL";
        _semiG23.awayTeam.totalBowlLosses++;
        semi23winner = _semiG23.homeTeam;
        //_newsStories.get(14).add(semiG14.homeTeam.name + " wins the " + semiG14.gameName +"!\n" + semiG14.homeTeam.strRep() + " defeats " + semiG14.awayTeam.strRep() + " in the semifinals, winning " + semiG14.homeScore + " to " + semiG14.awayScore + ". " + semiG14.homeTeam.name + " advances to the National Championship!" );
        NSMutableArray *week14 = _newsStories[14];
        [week14 addObject:[NSString stringWithFormat:@"%@ wins the %@!\n%@ defeats %@ in the semifinals, winning %ld to %ld. %@ advances to the National Championship!",_semiG23.homeTeam.name, _semiG23.gameName, _semiG23.homeTeam.strRep, _semiG23.awayTeam.strRep, (long)_semiG23.homeScore, (long)_semiG23.awayScore, _semiG23.homeTeam.name]];

    } else {
        _semiG23.homeTeam.semifinalWL = @"SFL";
        _semiG23.homeTeam.totalBowlLosses++;
        _semiG23.awayTeam.semifinalWL = @"SFW";
        _semiG23.awayTeam.totalBowls++;
        semi23winner = _semiG23.awayTeam;
        NSMutableArray *week14 = _newsStories[14];
        [week14 addObject:[NSString stringWithFormat:@"%@ wins the %@!\n%@ defeats %@ in the semifinals, winning %ld to %ld. %@ advances to the National Championship!",_semiG23.awayTeam.name, _semiG23.gameName, _semiG23.awayTeam.strRep, _semiG23.homeTeam.strRep, (long)_semiG23.awayScore, (long)_semiG23.homeScore, _semiG23.awayTeam.name]];

    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"newNewsStory" object:nil];

    //schedule NCG
    _ncg = [Game newGameWithHome:semi14winner away:semi23winner name:@"NCG"];
    [semi14winner.gameSchedule addObject:_ncg];
    [semi23winner.gameSchedule addObject:_ncg];

}

-(void)playBowl:(Game*)g {
    [g playGame];
    if (g.homeScore > g.awayScore ) {
        g.homeTeam.semifinalWL = @"BW";
        g.homeTeam.totalBowls++;
        g.awayTeam.semifinalWL = @"BL";
        g.awayTeam.totalBowlLosses++;
        NSMutableArray *week14 = _newsStories[14];
        [week14 addObject:[NSString stringWithFormat:@"%@ wins the %@!\n%@ defeats %@ in the %@, winning %d to %d.",g.homeTeam.name, g.gameName, g.homeTeam.strRep, g.awayTeam.strRep, g.gameName, g.homeScore, g.awayScore]];

    } else {
        g.homeTeam.semifinalWL = @"BL";
        g.homeTeam.totalBowlLosses++;
        g.awayTeam.semifinalWL = @"BW";
        g.awayTeam.totalBowls++;
        NSMutableArray *week14 = _newsStories[14];
        [week14 addObject:[NSString stringWithFormat:@"%@ wins the %@!\n%@ defeats %@ in the %@, winning %d to %d.",g.awayTeam.name, g.gameName, g.awayTeam.strRep, g.homeTeam.strRep, g.gameName, g.awayScore, g.homeScore]];
       // [[NSNotificationCenter defaultCenter] postNotificationName:@"newNewsStory" object:nil];
    }
     [[NSNotificationCenter defaultCenter] postNotificationName:@"newNewsStory" object:nil];
}

-(void)updateLeagueHistory {
    //update league history
    _teamList = [[_teamList sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Team *a = (Team*)obj1;
        Team *b = (Team*)obj2;
        if ([a.natlChampWL isEqualToString:@"NCW"]) {
            return -1;
        } else if ([b.natlChampWL isEqualToString:@"NCW"]) {
            return 1;
        } else {
            return a.teamPollScore > b.teamPollScore ? -1 : a.teamPollScore == b.teamPollScore ? 0 : 1;
        }
    }] mutableCopy];

    NSMutableArray *yearTop10 = [NSMutableArray array];
    Team *tt;
    for (int i = 0; i < 10; ++i) {
        tt = _teamList[i];
        [yearTop10  addObject:[NSString stringWithFormat:@"%@ (%ld-%ld)",tt.abbreviation, (long)tt.wins, (long)tt.losses]];
    }
    [_leagueHistoryDictionary setObject:yearTop10 forKey:[NSString stringWithFormat:@"%ld",(long)(2016 + _leagueHistoryDictionary.count)]];
}

-(NSString*)randomBlessedTeamStory:(Team*)t {
    _blessedTeamCoachName = [self getRandName];
   NSArray *stories = @[
                         [NSString stringWithFormat:@"%@ gets new digs!\nAn anonymous benefactor has completely covered the cost of new training facilities for %@, resulting in large scale improvements to the program's infrastructure.",t.abbreviation,t.name],
                         [NSString stringWithFormat:@"%@ makes a big splash at head coach!\n%@ has hired alumnus and professional football coach %@ in hopes of revitalizing the program.", t.abbreviation, t.name, _blessedTeamCoachName],
                         [NSString stringWithFormat:@"%@ hires new AD!\n%@ has hired alumnus %@ as athletic director, who has pledged to invest more in the school's football program.", t.abbreviation, t.name, _blessedTeamCoachName],
                         [NSString stringWithFormat:@"New drink fuels %@!\nA new recovery drink developed by the science department at %@ has been a hit at offseason practice. The players are singing its praises and coming out of this offseason better than ever.", t.abbreviation, t.name],
                         [NSString stringWithFormat:@"%@ gets a fresh coat of paint!\nAfter starting a successful athletic apparel company, one of %@'s alumni proclaims that the team will never have to play another game with the same uniform combination.",t.abbreviation,t.name],
                         [NSString stringWithFormat:@"%@ improving in the classroom!\n%@ has seen a dramatic increase in their academic standards over the past couple of years. Recruits have taken notice and are showing more interest in attending a school with high academic integrity.",t.abbreviation,t.name]
                         ];
    _blessedStoryIndex = ([HBSharedUtils randomValue] * stories.count);
    return stories[_blessedStoryIndex];
}

-(NSString*)randomCursedTeamStory:(Team*)t {
     _cursedTeamCoachName = [self getRandName];
    NSArray *stories = @[
                         [NSString stringWithFormat:@"League hits %@ with sanctions!\n%@ hit with two-year probation after league investigation finds program committed minor infractions.",t.abbreviation,t.name],
                         [NSString stringWithFormat:@"Scandal at %@!\n%@ puts itself on a 3-year probation after school self-reports dozens of recruiting violations.",t.abbreviation,t.name],
                         [NSString stringWithFormat:@"The end of an era at %@\n%@ head coach %@ announces sudden retirement effectively immediately.", t.abbreviation,t.abbreviation, _cursedTeamCoachName],
                         [NSString stringWithFormat:@"%@ head coach in hot water!\nAfter a scandal involving a sleepover at a prospect's home, %@'s head coach %@ has been suspended. No charges have been filed, but it is safe to say he won't be having any more pajama parties any time soon.", t.abbreviation, t.name, _cursedTeamCoachName],
                         [NSString stringWithFormat:@"%@ won the College Basketball National Championship\nReporters everywhere are now wondering if %@ has lost its emphasis on football.", t.abbreviation,t.name],
                         [NSString stringWithFormat:@"%@ didn't come to play school\n%@'s reputation takes a hit after news surfaced that the university falsified grades for student-athletes in order to retain their athletic eligibility. Recruits are leery of being associated with such a program.",t.abbreviation,t.name]
                         ];
    _cursedStoryIndex = ([HBSharedUtils randomValue] * stories.count);
    if (_isHardMode && [_cursedTeam isEqual:_userTeam]) {
        while (_cursedStoryIndex == 2) {
            _cursedStoryIndex = ([HBSharedUtils randomValue] * stories.count);
        }
    }
    return stories[_cursedStoryIndex];
}


-(void)advanceSeason {
    _currentWeek = 0;
    _ncg = nil;
    _heisman = nil;
    // Bless a random team with lots of prestige
    int blessNumber = (int)([HBSharedUtils randomValue]*9);
    Team *blessTeam = _teamList[50 + blessNumber];
    while ([blessTeam isEqual:_userTeam] || [blessTeam isEqual:_blessedTeam] || [blessTeam isEqual:_cursedTeam]) {
        blessNumber = (int)([HBSharedUtils randomValue]*9);
        blessTeam = _teamList[50 + blessNumber];
    }

    if (!blessTeam.isUserControlled && ![blessTeam.name isEqualToString:@"American Samoa"]) {
        blessTeam.teamPrestige += 30;
        _blessedTeam = blessTeam;
        if (blessTeam.teamPrestige > 90) blessTeam.teamPrestige = 90;
    }

    //Curse a good team
    int curseNumber = (int)([HBSharedUtils randomValue]*7);
    Team *curseTeam = _teamList[3 + curseNumber];
    if (!_isHardMode) {
        while ([curseTeam isEqual:_userTeam] || [curseTeam isEqual:_blessedTeam] || [curseTeam isEqual:_cursedTeam]) {
            curseNumber = (int)([HBSharedUtils randomValue]*7);
            curseTeam = _teamList[3 + curseNumber];
        }
        
        if (!curseTeam.isUserControlled && curseTeam.teamPrestige > 85) {
            curseTeam.teamPrestige -= 20;
            _cursedTeam = curseTeam;
        }
    } else {
        while ([curseTeam isEqual:_blessedTeam] || [curseTeam isEqual:_cursedTeam]) {
            curseNumber = (int)([HBSharedUtils randomValue]*7);
            curseTeam = _teamList[3 + curseNumber];
        }
        
        if (curseTeam.teamPrestige > 85) {
            curseTeam.teamPrestige -= 20;
            _cursedTeam = curseTeam;
        }
    }
    
    [self updateHallOfFame];
    for (int t = 0; t < _teamList.count; ++t) {
        [_teamList[t] updateRingOfHonor];
        [_teamList[t] advanceSeason];
    }
    for (int c = 0; c < _conferences.count; ++c) {
        _conferences[c].robinWeek = 0;
        _conferences[c].week = 0;
        _conferences[c].ccg = nil;
    }
    //set up schedule
    for (int i = 0; i < _conferences.count; ++i ) {
        [_conferences[i] setUpSchedule];
    }
    for (int i = 0; i < _conferences.count; ++i ) {
        [_conferences[i] setUpOOCSchedule];
    }
    for (int i = 0; i < _conferences.count; ++i ) {
        [_conferences[i] insertOOCSchedule];
    }

    _hasScheduledBowls = false;
    heismanDecided = NO;
    [_bowlGames removeAllObjects];

    for (NSMutableArray *week in _newsStories) {
        [week removeAllObjects];
    }

    if (_blessedTeam) {
        NSMutableArray *week0 = _newsStories[0];
        [week0 addObject:[self randomBlessedTeamStory:_blessedTeam]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"newNewsStory" object:nil];
    }

    if (_cursedTeam) {
        NSMutableArray *week0 = _newsStories[0];
        [week0 addObject:[self randomCursedTeamStory:_cursedTeam]];
        if (_isHardMode && [_cursedTeam isEqual:_userTeam]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"userTeamSanctioned" object:nil];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"newNewsStory" object:nil];
    }

    [self setTeamRanks];
}

-(void)updateTeamHistories {
    for (int i = 0; i < _teamList.count; ++i) {
        [_teamList[i] updateTeamHistory];
    }
}

-(void)updateTeamTalentRatings {
    for (Team *t in _teamList) {
        [t updateTalentRatings];
    }
}

-(NSString*)getRandName {
    int fn = (int)([HBSharedUtils randomValue] * _nameList.count);
    int ln = (int)([HBSharedUtils randomValue] * _nameList.count);
    return [NSString stringWithFormat:@"%@ %@",_nameList[fn],_nameList[ln]];
}

-(NSArray<Player*>*)calculateHeismanCandidates {
    if (!heismanDecided && _currentWeek < 13) {
        if (_heisman) {
            _heisman.isHeisman = NO;
            _heisman = nil;
        }
        int heismanScore = 0;
        int tempScore = 0;
        if (heismanCandidates != nil) {
            [heismanCandidates removeAllObjects];
        } else {
            heismanCandidates = [NSMutableArray array];
        }
        for ( int i = 0; i < _teamList.count; ++i ) {
            //qb
            if (_teamList[i].teamQBs.count > 0) {
                PlayerQB *qb = _teamList[i].teamQBs[0];
                if (![heismanCandidates containsObject:qb]) {
                    [heismanCandidates addObject:qb];
                }
                tempScore = [qb getHeismanScore] + _teamList[i].wins*100;
                if ( tempScore > heismanScore ) {
                    _heisman = qb;
                    heismanScore = tempScore;
                }
            }

            //rb
            if (_teamList[i].teamRBs.count > 1) {
                for (int rb = 0; rb < 2; ++rb) {
                    Player *rback =_teamList[i].teamRBs[rb];
                    if (![heismanCandidates containsObject:rback]) {
                        [heismanCandidates addObject:rback];
                    }
                    tempScore = [rback getHeismanScore] + _teamList[i].wins*100;
                    if ( tempScore > heismanScore ) {
                        _heisman = rback;
                        heismanScore = tempScore;
                    }
                }
            }

            //wr
            if (_teamList[i].teamWRs.count > 2) {
                for (int wr = 0; wr < 3; ++wr) {
                    PlayerWR *wrec = _teamList[i].teamWRs[wr];
                    if (![heismanCandidates containsObject:wrec]) {
                        [heismanCandidates addObject:wrec];
                    }
                    tempScore = [wrec getHeismanScore] + _teamList[i].wins*100;
                    if ( tempScore > heismanScore ) {
                        _heisman = wrec;
                        heismanScore = tempScore;
                    }
                }
            }
        }

        [heismanCandidates sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            Player *a = (Player*)obj1;
            Player *b = (Player*)obj2;
            if (a.isHeisman) {
                return -1;
            } else if (b.isHeisman) {
                return 1;
            } else {
                return [a getHeismanScore] > [b getHeismanScore] ? -1 : [a getHeismanScore] == [b getHeismanScore] ? 0 : 1;
            }

        }];

        return heismanCandidates;
    } else {
        [heismanCandidates sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            Player *a = (Player*)obj1;
            Player *b = (Player*)obj2;
            if (a.isHeisman) {
                return -1;
            } else if (b.isHeisman) {
                return 1;
            } else {
                return [a getHeismanScore] > [b getHeismanScore] ? -1 : [a getHeismanScore] == [b getHeismanScore] ? 0 : 1;
            }

        }];

        return heismanCandidates;
    }
}

-(NSArray*)getHeismanLeaders {
    if (!heismanDecided || !_heismanFinalists) {
        NSMutableArray *tempHeis = [NSMutableArray array];
        NSArray *candidates = [self calculateHeismanCandidates];
        for (int i = 0; i < 5; i++) {
            Player *p = candidates[i];
            [tempHeis addObject:p];
        }

        [tempHeis sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            Player *a = (Player*)obj1;
            Player *b = (Player*)obj2;
            if (a.isHeisman) {
                return -1;
            } else if (b.isHeisman) {
                return 1;
            } else {
                return [a getHeismanScore] > [b getHeismanScore] ? -1 : [a getHeismanScore] == [b getHeismanScore] ? 0 : 1;
            }
        }];

        return [tempHeis copy];
    } else {
        return [_heismanFinalists copy];
    }
}

-(NSString*)getHeismanCeremonyStr {
    BOOL putNewsStory = false;

    heismanCandidates = [[self calculateHeismanCandidates] mutableCopy];
    _heisman = heismanCandidates[0];
    heismanDecided = true;
    putNewsStory = true;

    NSString* heismanTop5 = @"\n";
    NSMutableString* heismanStats = [NSMutableString string];
    NSString* heismanWinnerStr = @"";
    _heismanFinalists = [NSMutableArray array];
    //full results string

    for (int i = 0; i < 5; ++i) {
        Player *p = heismanCandidates[i];
        heismanTop5 = [heismanTop5 stringByAppendingString:[NSString stringWithFormat:@"%d. %@ (%ld-%ld) - ",(i+1),p.team.abbreviation,(long)p.team.wins,(long)p.team.losses]];
        if ([p isKindOfClass:[PlayerQB class]]) {
            PlayerQB *pqb = (PlayerQB*)p;
            heismanTop5 = [heismanTop5 stringByAppendingString:[NSString stringWithFormat:@" QB %@: %ld votes\n\t(%ld TDs, %ld Int, %ld Yds)\n",[pqb getInitialName],(long)[pqb getHeismanScore],(long)pqb.statsTD,(long)pqb.statsInt,(long)pqb.statsPassYards]];
        } else if ([p isKindOfClass:[PlayerRB class]]) {
            PlayerRB *prb = (PlayerRB*)p;
            heismanTop5 = [heismanTop5 stringByAppendingString:[NSString stringWithFormat:@" RB %@: %ld votes\n\t(%ld TDs, %ld Fum, %ld Yds)\n",[prb getInitialName],(long)[prb getHeismanScore],(long)prb.statsTD,(long)prb.statsFumbles,(long)prb.statsRushYards]];
        } else if ([p isKindOfClass:[PlayerWR class]]) {
            PlayerWR *pwr = (PlayerWR*)p;
            heismanTop5 = [heismanTop5 stringByAppendingString:[NSString stringWithFormat:@" WR %@: %ld votes\n\t(%ld TDs, %ld Fum, %ld Yds)\n",[pwr getInitialName],(long)[pwr getHeismanScore],(long)pwr.statsTD,(long)pwr.statsFumbles,(long)pwr.statsRecYards]];
        }
        [_heismanFinalists addObject:p];
    }

    _heisman.team.heismans++;
    _heisman.careerHeismans++;
    _heisman.isHeisman = YES;
    if ([_heisman isKindOfClass:[PlayerQB class]]) {
        //qb heisman
        PlayerQB *heisQB = (PlayerQB*)_heisman;
        if (heisQB.statsInt > 1 || heisQB.statsInt == 0) {
            heismanWinnerStr = [NSString stringWithFormat:@"%ld's POTY: %@ QB %@!\n?Congratulations to %@ QB %@ [%@], who had %ld TDs, %ld interceptions, and %ld passing yards and led %@ to a %ld-%ld record and a #%ld poll ranking.",(long)(2016 + self.leagueHistoryDictionary.count), heisQB.team.abbreviation, [heisQB getInitialName],heisQB.team.abbreviation, heisQB.name, [_heisman getYearString], (long)heisQB.statsTD, (long)heisQB.statsInt, (long)heisQB.statsPassYards, heisQB.team.name, (long)heisQB.team.wins,(long)heisQB.team.losses,(long)heisQB.team.rankTeamPollScore];
        } else {
            heismanWinnerStr = [NSString stringWithFormat:@"%ld's POTY: %@ QB %@!\n?Congratulations to %@ QB %@ [%@], who had %ld TDs, %ld interception, and %ld passing yards and led %@ to a %ld-%ld record and a #%ld poll ranking.",(long)(2016 + self.leagueHistoryDictionary.count), heisQB.team.abbreviation, [heisQB getInitialName],heisQB.team.abbreviation, heisQB.name, [_heisman getYearString], (long)heisQB.statsTD, (long)heisQB.statsInt, (long)heisQB.statsPassYards, heisQB.team.name, (long)heisQB.team.wins,(long)heisQB.team.losses,(long)heisQB.team.rankTeamPollScore];
        }

        [heismanStats appendString:[NSString stringWithFormat:@"%@\n\nFull Results: %@",heismanWinnerStr, heismanTop5]];
    } else if ([_heisman isKindOfClass:[PlayerRB class]]) {
        //rb heisman
        PlayerRB *heisRB = (PlayerRB*)_heisman;
        if (heisRB.statsFumbles > 1 || heisRB.statsFumbles == 0) {
            heismanWinnerStr = [NSString stringWithFormat:@"%ld's POTY: %@ RB %@!\n?Congratulations to %@ RB %@ [%@], who had %ld TDs, %ld fumbles, and %ld rushing yards and led %@ to a %ld-%ld record and a #%ld poll ranking.",(long)(2016 + self.leagueHistoryDictionary.count), heisRB.team.abbreviation, [heisRB getInitialName], heisRB.team.abbreviation, heisRB.name, [_heisman getYearString], (long)heisRB.statsTD, (long)heisRB.statsFumbles, (long)heisRB.statsRushYards, heisRB.team.name, (long)heisRB.team.wins,(long)heisRB.team.losses,(long)heisRB.team.rankTeamPollScore];
        } else {
            heismanWinnerStr = [NSString stringWithFormat:@"%ld's POTY: %@ RB %@!\n?Congratulations to %@ RB %@ [%@], who had %ld TDs, %ld fumble, and %ld rushing yards and led %@ to a %ld-%ld record and a #%ld poll ranking.",(long)(2016 + self.leagueHistoryDictionary.count), heisRB.team.abbreviation, [heisRB getInitialName],heisRB.team.abbreviation, heisRB.name, [_heisman getYearString], (long)heisRB.statsTD, (long)heisRB.statsFumbles, (long)heisRB.statsRushYards, heisRB.team.name, (long)heisRB.team.wins,(long)heisRB.team.losses,(long)heisRB.team.rankTeamPollScore];
        }
        [heismanStats appendString:[NSString stringWithFormat:@"%@\n\nFull Results: %@",heismanWinnerStr, heismanTop5]];
    } else if ([_heisman isKindOfClass:[PlayerWR class]]) {
        //wr heisman
        PlayerWR *heisWR = (PlayerWR*)_heisman;
        if (heisWR.statsFumbles > 1 || heisWR.statsFumbles == 0) {
            heismanWinnerStr = [NSString stringWithFormat:@"%ld's POTY: %@ WR %@!\n?Congratulations to %@ WR %@ [%@], who had %ld TDs, %ld fumbles, and %ld receiving yards and led %@ to a %ld-%ld record and a #%ld poll ranking.",(long)(2016 + self.leagueHistoryDictionary.count), heisWR.team.abbreviation, [heisWR getInitialName], heisWR.team.abbreviation, heisWR.name, [_heisman getYearString], (long)heisWR.statsTD, (long)heisWR.statsFumbles, (long)heisWR.statsRecYards, heisWR.team.name, (long)heisWR.team.wins,(long)heisWR.team.losses,(long)heisWR.team.rankTeamPollScore];
        } else {
            heismanWinnerStr = [NSString stringWithFormat:@"%ld's POTY: %@ WR %@!\n?Congratulations to %@ WR %@ [%@], who had %ld TDs, %ld fumble, and %ld receiving yards and led %@ to a %ld-%ld record and a #%ld poll ranking.",(long)(2016 + self.leagueHistoryDictionary.count), heisWR.team.abbreviation, [heisWR getInitialName],heisWR.team.abbreviation, heisWR.name, [_heisman getYearString], (long)heisWR.statsTD, (long)heisWR.statsFumbles, (long)heisWR.statsRecYards, heisWR.team.name, (long)heisWR.team.wins,(long)heisWR.team.losses,(long)heisWR.team.rankTeamPollScore];
        }

        [heismanStats appendString:[NSString stringWithFormat:@"%@\n\nFull Results: %@",heismanWinnerStr, heismanTop5]];
    }

    // Add news story
    if (putNewsStory) {
        NSMutableArray *week13 = _newsStories[13];
        [week13 addObject:[heismanWinnerStr stringByReplacingOccurrencesOfString:@"?" withString:@""]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"newNewsStory" object:nil];
    }

    heismanWinnerStrFull = heismanStats;
    return heismanStats;
}

-(NSArray*)getBowlPredictions {
    if (!_hasScheduledBowls) {
        [_teamList sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            Team *a = (Team*)obj1;
            Team *b = (Team*)obj2;
            return a.teamPollScore > b.teamPollScore ? -1 : a.teamPollScore == b.teamPollScore ? 0 : 1;

        }];


        NSMutableArray* sb = [NSMutableArray array];
        Team *t1;
        Team *t2;

        t1 = _teamList[0];
        t2 = _teamList[3];

        [sb addObject:[Game newGameWithHome:t1 away:t2 name:@"Semis, 1v4"]];


        t1 = _teamList[1];
        t2 = _teamList[2];

        [sb addObject:[Game newGameWithHome:t1 away:t2 name:@"Semis, 2v3"]];

        NSMutableArray *bowlEligibleTeams = [NSMutableArray array];
        for (int i = 4; i < ([self bowlGameTitles].count * 2); i++) {
            [bowlEligibleTeams addObject:_teamList[i]];
        }

        [_bowlGames removeAllObjects];
        int j = 0;
        int teamIndex = 0;
        while (j < [self bowlGameTitles].count && teamIndex < bowlEligibleTeams.count) {
            NSString *bowlName = [self bowlGameTitles][j];
            Team *home = bowlEligibleTeams[teamIndex];
            Team *away = bowlEligibleTeams[teamIndex + 1];
            Game *bowl = [Game newGameWithHome:home away:away name:bowlName];
            j++;
            teamIndex+=2;
            [sb addObject:bowl];
        }


        return [sb copy];
    } else {
        if (!_ncg) {
            // Games have already been scheduled, give actual teams
            NSMutableArray *sb = [NSMutableArray array];
            [sb addObject:_semiG14];
            [sb addObject:_semiG23];

            for (Game *bowl in _bowlGames) {
                [sb addObject:bowl];
            }

            return [sb copy];
        } else {
            // Games have already been scheduled, give actual teams
            NSMutableArray *sb = [NSMutableArray array];
            [sb addObject:_ncg];
            [sb addObject:_semiG14];
            [sb addObject:_semiG23];

            for (Game *bowl in _bowlGames) {
                [sb addObject:bowl];
            }

            return [sb copy];
        }
    }
}

-(NSString*)getGameSummaryBowl:(Game*)g {
    if (!g.hasPlayed) {
        return [NSString stringWithFormat: @"%@ vs %@", g.homeTeam.strRep,g.awayTeam.strRep];
    } else {
        if (g.homeScore > g.awayScore) {
            return [NSString stringWithFormat:@"%@ W %ld-%ld vs %@", g.homeTeam.strRep, (long)g.homeScore, (long)g.awayScore, g.awayTeam.strRep];
        } else {
            return [NSString stringWithFormat:@"%@ W %ld-%ld vs %@", g.awayTeam.strRep, (long)g.awayScore, (long)g.homeScore, g.homeTeam.strRep];
        }
    }
}

-(Team*)findTeam:(NSString*)name {
    for (int i = 0; i < _teamList.count; i++){
        if ([_teamList[i].abbreviation isEqualToString:name]) {
            return _teamList[i];
        }
    }
    return nil;
}

-(Conference*)findConference:(NSString*)name {
    for (int i = 0; i < _teamList.count; i++){
        if ([_conferences[i].confName isEqualToString:name]) {
            return _conferences[i];
        }
    }
    return nil;
}

-(NSString*)ncgSummaryStr {
    // Give summary of what happened in the NCG
    if (_ncg.homeScore > _ncg.awayScore) {
        return [NSString stringWithFormat:@"%@ (%ld-%ld) won the National Championship, winning against %@ (%ld-%ld) in the NCG %ld-%ld.",_ncg.homeTeam.name,(long)_ncg.homeTeam.wins,(long)_ncg.homeTeam.losses,_ncg.awayTeam.name, (long)_ncg.awayTeam.wins,(long)_ncg.awayTeam.losses, (long)_ncg.homeScore, (long)_ncg.awayScore];
    } else {
        return [NSString stringWithFormat:@"%@ (%ld-%ld) won the National Championship, winning against %@ (%ld-%ld) in the NCG %ld-%ld.",_ncg.awayTeam.name,(long)_ncg.awayTeam.wins,(long)_ncg.awayTeam.losses,_ncg.homeTeam.name, (long)_ncg.homeTeam.wins,(long)_ncg.homeTeam.losses, (long)_ncg.awayScore, (long)_ncg.homeScore];
    }
}

-(NSString*)seasonSummaryStr {
    NSMutableString *sb = [NSMutableString string];
    [sb appendString:[self ncgSummaryStr]];
    [sb appendString:[NSString stringWithFormat:@"\n\n%@",[_userTeam getSeasonSummaryString]]];
    return [sb copy];
}

-(void)setTeamRanks {
    //get team ranks for PPG, YPG, etc
    for (int i = 0; i < _teamList.count; ++i) {
        [_teamList[i] updatePollScore];
    }

    _teamList = [[_teamList sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Team *a = (Team*)obj1;
        Team *b = (Team*)obj2;
        return a.teamPollScore > b.teamPollScore ? -1 : a.teamPollScore == b.teamPollScore ? (a.wins > b.wins ? -1 : a.wins == b.wins ? (a.teamPoints > b.teamPoints ? -1 : a.teamPoints == b.teamPoints ? 0 : 1) : 1) : 1;
    }] mutableCopy];

    for (int t = 0; t < _teamList.count; ++t) {
        _teamList[t].rankTeamPollScore = t+1;
    }

    _teamList = [[_teamList sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Team *a = (Team*)obj1;
        Team *b = (Team*)obj2;
        return a.teamStrengthOfWins > b.teamStrengthOfWins ? -1 : a.teamStrengthOfWins == b.teamStrengthOfWins ? 0 : 1;
    }] mutableCopy];
    for (int t = 0; t < _teamList.count; ++t) {
        _teamList[t].rankTeamStrengthOfWins = t+1;
    }

    if (_currentWeek > 0) {
        _teamList = [[_teamList sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            Team *a = (Team*)obj1;
            Team *b = (Team*)obj2;
            return a.teamPoints/a.numGames > b.teamPoints/b.numGames ? -1 : a.teamPoints/a.numGames == b.teamPoints/b.numGames ? 0 : 1;
        }] mutableCopy];
        for (int t = 0; t < _teamList.count; ++t) {
            _teamList[t].rankTeamPoints = t+1;
        }

        _teamList = [[_teamList sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            Team *a = (Team*)obj1;
            Team *b = (Team*)obj2;
            return a.teamOppPoints/a.numGames < b.teamOppPoints/b.numGames ? -1 : a.teamOppPoints/a.numGames == b.teamOppPoints/b.numGames ? 0 : 1;
        }] mutableCopy];
        for (int t = 0; t < _teamList.count; ++t) {
            _teamList[t].rankTeamOppPoints = t+1;
        }

        _teamList = [[_teamList sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            Team *a = (Team*)obj1;
            Team *b = (Team*)obj2;
            return a.teamYards/a.numGames > b.teamYards/b.numGames ? -1 : a.teamYards/a.numGames == b.teamYards/b.numGames ? 0 : 1;
        }] mutableCopy];
        for (int t = 0; t < _teamList.count; ++t) {
            _teamList[t].rankTeamYards = t+1;
        }

        _teamList = [[_teamList sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            Team *a = (Team*)obj1;
            Team *b = (Team*)obj2;
            return a.teamOppYards/a.numGames < b.teamOppYards/b.numGames ? -1 : a.teamOppYards/a.numGames == b.teamOppYards/b.numGames ? 0 : 1;
        }] mutableCopy];
        for (int t = 0; t < _teamList.count; ++t) {
            _teamList[t].rankTeamOppYards = t+1;
        }

        _teamList = [[_teamList sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            Team *a = (Team*)obj1;
            Team *b = (Team*)obj2;
            return a.teamPassYards/a.numGames > b.teamPassYards/b.numGames ? -1 : a.teamPassYards/a.numGames == b.teamPassYards/b.numGames ? 0 : 1;
        }] mutableCopy];
        for (int t = 0; t < _teamList.count; ++t) {
            _teamList[t].rankTeamPassYards = t+1;
        }

        _teamList = [[_teamList sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            Team *a = (Team*)obj1;
            Team *b = (Team*)obj2;
            return a.teamRushYards/a.numGames > b.teamRushYards/b.numGames ? -1 : a.teamRushYards/a.numGames == b.teamRushYards/b.numGames ? 0 : 1;
        }] mutableCopy];
        for (int t = 0; t < _teamList.count; ++t) {
            _teamList[t].rankTeamRushYards = t+1;
        }

        _teamList = [[_teamList sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            Team *a = (Team*)obj1;
            Team *b = (Team*)obj2;
            return a.teamOppPassYards/a.numGames < b.teamOppPassYards/b.numGames ? -1 : a.teamOppPassYards/a.numGames == b.teamOppPassYards/b.numGames ? 0 : 1;
        }] mutableCopy];
        for (int t = 0; t < _teamList.count; ++t) {
            _teamList[t].rankTeamOppPassYards = t+1;
        }

        _teamList = [[_teamList sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            Team *a = (Team*)obj1;
            Team *b = (Team*)obj2;
            return a.teamOppRushYards/a.numGames < b.teamOppRushYards/b.numGames ? -1 : a.teamOppRushYards/a.numGames == b.teamOppRushYards/b.numGames ? 0 : 1;
        }] mutableCopy];
        for (int t = 0; t < _teamList.count; ++t) {
            _teamList[t].rankTeamOppRushYards = t+1;
        }

        _teamList = [[_teamList sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            Team *a = (Team*)obj1;
            Team *b = (Team*)obj2;
            return a.teamTODiff > b.teamTODiff ? -1 : a.teamTODiff == b.teamTODiff ? 0 : 1;
        }] mutableCopy];
        for (int t = 0; t < _teamList.count; ++t) {
            _teamList[t].rankTeamTODiff= t+1;
        }
    }

    _teamList = [[_teamList sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Team *a = (Team*)obj1;
        Team *b = (Team*)obj2;
        return a.teamOffTalent > b.teamOffTalent ? -1 : a.teamOffTalent == b.teamOffTalent ? 0 : 1;
    }] mutableCopy];
    for (int t = 0; t < _teamList.count; ++t) {
        _teamList[t].rankTeamOffTalent = t+1;
    }

    _teamList = [[_teamList sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Team *a = (Team*)obj1;
        Team *b = (Team*)obj2;
        return a.teamDefTalent > b.teamDefTalent ? -1 : a.teamDefTalent == b.teamDefTalent ? 0 : 1;
    }] mutableCopy];
    for (int t = 0; t < _teamList.count; ++t) {
        _teamList[t].rankTeamDefTalent = t+1;
    }

    _teamList = [[_teamList sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Team *a = (Team*)obj1;
        Team *b = (Team*)obj2;
        return a.teamPrestige > b.teamPrestige ? -1 : a.teamPrestige == b.teamPrestige ? 0 : 1;
    }] mutableCopy];
    for (int t = 0; t < _teamList.count; ++t) {
        _teamList[t].rankTeamPrestige = t+1;
    }

    _teamList = [[_teamList sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Team *a = (Team*)obj1;
        Team *b = (Team*)obj2;
        if (a.totalWins > b.totalWins) {
            return -1;
        } else if (a.totalWins < b.totalWins) {
            return 1;
        } else {
            if (a.totalLosses < b.totalLosses) {
                return -1;
            } else if (a.totalLosses > b.totalLosses) {
                return 1;
            } else {
                return 0;
            }
        }
    }] mutableCopy];

    for (int t = 0; t < _teamList.count; ++t) {
        _teamList[t].rankTeamTotalWins = t+1;
    }
}

-(void)refreshAllLeaguePlayers {
    NSMutableArray *leadingQBs = [NSMutableArray array];
    NSMutableArray *leadingRBs = [NSMutableArray array];
    NSMutableArray *leadingWRs = [NSMutableArray array];
    NSMutableArray *leadingKs = [NSMutableArray array];
    
    for (Team *t in _teamList) {
        [leadingQBs addObject:[t getQB:0]];
        [leadingRBs addObject:[t getRB:0]];
        [leadingRBs addObject:[t getRB:1]];
        [leadingWRs addObject:[t getWR:0]];
        [leadingWRs addObject:[t getWR:1]];
        [leadingWRs addObject:[t getWR:2]];
        [leadingKs addObject:[t getK:0]];
    }
    
    [leadingQBs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Player *a = (Player*)obj1;
        Player *b = (Player*)obj2;
        if (a.isHeisman) return -1;
        else if (b.isHeisman) return 1;
        else return [a getHeismanScore] > [b getHeismanScore] ? -1 : [a getHeismanScore] == [b getHeismanScore] ? 0 : 1;
    }];
    
    [leadingRBs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Player *a = (Player*)obj1;
        Player *b = (Player*)obj2;
        if (a.isHeisman) return -1;
        else if (b.isHeisman) return 1;
        else return [a getHeismanScore] > [b getHeismanScore] ? -1 : [a getHeismanScore] == [b getHeismanScore] ? 0 : 1;
    }];
    
    [leadingWRs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Player *a = (Player*)obj1;
        Player *b = (Player*)obj2;
        if (a.isHeisman) return -1;
        else if (b.isHeisman) return 1;
        else return [a getHeismanScore] > [b getHeismanScore] ? -1 : [a getHeismanScore] == [b getHeismanScore] ? 0 : 1;
    }];
    
    [leadingKs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        PlayerK *a = (PlayerK*)obj1;
        PlayerK *b = (PlayerK*)obj2;
        if (a.isHeisman) return -1;
        else if (b.isHeisman) return 1;
        else return [a getHeismanScore] > [b getHeismanScore] ? -1 : [a getHeismanScore] == [b getHeismanScore] ? 0 : 1;
    }];
    
    PlayerQB *qb = leadingQBs[0];
    qb.careerAllAmericans++;
    qb.isAllAmerican = YES;
    
    PlayerRB *rb1 = leadingRBs[0];
    rb1.careerAllAmericans++;
    rb1.isAllAmerican = YES;
    
    PlayerRB *rb2 = leadingRBs[1];
    rb2.careerAllAmericans++;
    rb2.isAllAmerican = YES;
    
    PlayerWR *wr1 = leadingWRs[0];
    wr1.careerAllAmericans++;
    wr1.isAllAmerican = YES;
    
    PlayerWR *wr2 = leadingWRs[1];
    wr2.careerAllAmericans++;
    wr2.isAllAmerican = YES;
    
    PlayerWR *wr3 = leadingWRs[2];
    wr3.careerAllAmericans++;
    wr3.isAllAmerican = YES;
    
    PlayerK *k = leadingKs[0];
    k.careerAllAmericans++;
    k.isAllAmerican = YES;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"awardsPosted" object:nil];
    
    _allLeaguePlayers = @{
                           @"QB" : @[qb],
                           @"RB" : @[rb1,rb2],
                           @"WR" : @[wr1,wr2,wr3],
                           @"K"  : @[k]
                           };
    
}

-(void)completeProDraft {
    NSMutableArray *players = [NSMutableArray array];
    NSMutableArray *round1 = [NSMutableArray array];
    NSMutableArray *round2 = [NSMutableArray array];
    NSMutableArray *round3 = [NSMutableArray array];
    NSMutableArray *round4 = [NSMutableArray array];
    NSMutableArray *round5 = [NSMutableArray array];
    NSMutableArray *round6 = [NSMutableArray array];
    NSMutableArray *round7 = [NSMutableArray array];
    
    NSArray *teamList = [HBSharedUtils getLeague].teamList;
    for (Team *t in teamList) {
        [t getGraduatingPlayers];
        [players addObjectsFromArray:t.playersLeaving];
    }
    if (!_heisman) {
        NSArray *candidates = [self calculateHeismanCandidates];
        if (candidates.count > 0) {
            _heisman = candidates[0];
        }
    }
    
    [players sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Player *a = (Player*)obj1;
        Player *b = (Player*)obj2;
        int adjADraftGrade = 0;
        int adjBDraftGrade = 0;
        int adjAHeisScore = 100 * ((double)[a getHeismanScore]/(double)[_heisman getHeismanScore]);
        int adjBHeisScore = 100 * ((double)[b getHeismanScore]/(double)[_heisman getHeismanScore]);
        
        if ([a isKindOfClass:[PlayerQB class]]) {
            PlayerQB *p = (PlayerQB*)a;
            
            adjADraftGrade = (int)(((double)(p.ratOvr + p.ratFootIQ + p.ratPassAcc + p.ratPassEva + p.ratPassPow + adjAHeisScore) / 6.0) * 12.0);
        } else if ([a isKindOfClass:[PlayerRB class]]) {
            PlayerRB *p = (PlayerRB*)a;
            adjADraftGrade = (int)(((double)(p.ratOvr + p.ratFootIQ + p.ratRushEva + p.ratRushPow + p.ratRushSpd + adjAHeisScore) / 6.0) * 12.0);
        } else if ([a isKindOfClass:[PlayerWR class]]) {
            PlayerWR *p = (PlayerWR*)a;
            adjADraftGrade = (int)(((double)(p.ratOvr + p.ratFootIQ + p.ratRecCat + p.ratRecEva + p.ratRecSpd + adjAHeisScore) / 6.0) * 12.0);
        } else if ([a isKindOfClass:[PlayerOL class]]) {
            PlayerOL *p = (PlayerOL*)a;
            adjADraftGrade = (int)(((double)(p.ratOvr + p.ratFootIQ + p.ratOLBkP + p.ratOLPow + p.ratOLBkR) / 5.0) * 11.0);
        } else if ([a isKindOfClass:[PlayerF7 class]]) {
            PlayerF7 *p = (PlayerF7*)a;
            adjADraftGrade = (int)(((double)(p.ratOvr + p.ratFootIQ + p.ratF7Pas + p.ratF7Pow + p.ratF7Rsh) / 5.0) * 10.5);
        } else if ([a isKindOfClass:[PlayerCB class]]) {
            PlayerCB *p = (PlayerCB*)a;
            adjADraftGrade = (int)(((double)(p.ratOvr + p.ratFootIQ + p.ratCBCov + p.ratCBSpd + p.ratCBTkl) / 5.0) * 10.5);
        } else if ([a isKindOfClass:[PlayerS class]]) {
            PlayerS *p = (PlayerS*)a;
            adjADraftGrade = (int)(((double)(p.ratOvr + p.ratFootIQ + p.ratSCov + p.ratSSpd + p.ratSTkl) / 5.0) * 10.5);
        } else {
            PlayerK *k = (PlayerK*)a;
            adjADraftGrade = (int)(((double)(k.ratOvr + k.ratFootIQ + k.ratKickPow + k.ratKickAcc + k.ratKickFum) / 11.0) * 12.0);
        }
        
        
        if ([b isKindOfClass:[PlayerQB class]]) {
            PlayerQB *p = (PlayerQB*)b;
            adjBDraftGrade = (int)(((double)(p.ratOvr + p.ratFootIQ + p.ratPassAcc + p.ratPassEva + p.ratPassPow + adjBHeisScore) / 6.0) * 12.0);
        } else if ([b isKindOfClass:[PlayerRB class]]) {
            PlayerRB *p = (PlayerRB*)b;
            adjBDraftGrade = (int)(((double)(p.ratOvr + p.ratFootIQ + p.ratRushEva + p.ratRushPow + p.ratRushSpd  + adjBHeisScore) / 6.0) * 12.0);
        } else if ([b isKindOfClass:[PlayerWR class]]) {
            PlayerWR *p = (PlayerWR*)b;
            adjBDraftGrade = (int)(((double)(p.ratOvr + p.ratFootIQ + p.ratRecCat + p.ratRecEva + p.ratRecSpd + adjBHeisScore) / 6.0) * 12.0);
        } else if ([b isKindOfClass:[PlayerOL class]]) {
            PlayerOL *p = (PlayerOL*)b;
            adjBDraftGrade = (int)(((double)(p.ratOvr + p.ratFootIQ + p.ratOLBkP + p.ratOLPow + p.ratOLBkR) / 5.0) * 11.0);
        } else if ([b isKindOfClass:[PlayerF7 class]]) {
            PlayerF7 *p = (PlayerF7*)b;
            adjBDraftGrade = (int)(((double)(p.ratOvr + p.ratFootIQ + p.ratF7Pas + p.ratF7Pow + p.ratF7Rsh) / 5.0) * 10.5);
        } else if ([b isKindOfClass:[PlayerCB class]]) {
            PlayerCB *p = (PlayerCB*)b;
            adjBDraftGrade = (int)(((double)(p.ratOvr + p.ratFootIQ + p.ratCBCov + p.ratCBSpd + p.ratCBTkl) / 5.0) * 10.5);
        } else if ([b isKindOfClass:[PlayerS class]]) {
            PlayerS *p = (PlayerS*)b;
            adjBDraftGrade = (int)(((double)(p.ratOvr + p.ratFootIQ + p.ratSCov + p.ratSSpd + p.ratSTkl) / 5.0) * 10.5);
        } else  {
            PlayerK *k = (PlayerK*)b;
            adjBDraftGrade = (int)(((double)(k.ratOvr + k.ratFootIQ + k.ratKickPow + k.ratKickAcc + k.ratKickFum) / 11.0) * 12.0);
        }
        
        return adjADraftGrade > adjBDraftGrade ? -1 : adjADraftGrade == adjBDraftGrade ? 0 : 1;
    }];
    NSLog(@"TOTAL DRAFTABLE PLAYERS: %ld", (unsigned long)(long)players.count);
    int userDraftees = 0;
    Team *userTeam = [HBSharedUtils getLeague].userTeam;
    for (int i = 0; i < 32; i++) {
        Player *p = players[i];
        if ([p.team isEqual:userTeam]) {
            userDraftees++;
        }
        p.draftPosition = @{@"round" : @"1", @"pick" : [NSString stringWithFormat:@"%li", (long)(i+1)]};
        [round1 addObject:p];
    }
    
    //add to user awards
    
    for (int j = 32; j < 64; j++) {
        Player *p = players[j];
        if ([p.team isEqual:userTeam]) {
            userDraftees++;
        }
        p.draftPosition = @{@"round" : @"2", @"pick" : [NSString stringWithFormat:@"%li", (long)(j+1)]};
        [round2 addObject:p];
    }
    
    for (int k = 64; k < 96; k++) {
        Player *p = players[k];
        if ([p.team isEqual:userTeam]) {
            userDraftees++;
        }
        p.draftPosition = @{@"round" : @"3", @"pick" : [NSString stringWithFormat:@"%li", (long)(k+1)]};
        [round3 addObject:p];
    }
    
    for (int r = 96; r < 128; r++) {
        Player *p = players[r];
        if ([p.team isEqual:userTeam]) {
            userDraftees++;
        }
        p.draftPosition = @{@"round" : @"4", @"pick" : [NSString stringWithFormat:@"%li", (long)(r+1)]};
        [round4 addObject:p];
    }
    
    for (int c = 128; c < 160; c++) {
        Player *p = players[c];
        if ([p.team isEqual:userTeam]) {
            userDraftees++;
        }
        p.draftPosition = @{@"round" : @"5", @"pick" : [NSString stringWithFormat:@"%li", (long)(c+1)]};
        [round5 addObject:p];
    }
    
    for (int a = 160; a < 192; a++) {
        Player *p = players[a];
        if ([p.team isEqual:userTeam]) {
            userDraftees++;
        }
        p.draftPosition = @{@"round" : @"6", @"pick" : [NSString stringWithFormat:@"%li", (long)(a+1)]};
        [round6 addObject:p];
    }
    
    for (int b = 192; b < 224; b++) {
        Player *p = players[b];
        if ([p.team isEqual:userTeam]) {
            userDraftees++;
        }
        p.draftPosition = @{@"round" : @"7", @"pick" : [NSString stringWithFormat:@"%li", (long)b]};
        [round7 addObject:p];
    }
    
    _allDraftedPlayers = @[round1, round2, round3, round4, round5, round6, round7];
   
}

-(void)updateHallOfFame {
    for (Team *t in _teamList) {
        for (Player *p in t.teamQBs) {
            if (((t.isUserControlled && [t.playersLeaving containsObject:p]) || (!t.isUserControlled && p.year == 4))
                && (p.careerAllConferences > 3 || p.careerHeismans > 0 || p.careerAllAmericans > 2)) {
                if (![_hallOfFamers containsObject:p]) {
                    p.injury = nil; //sanity check to make sure our immortals are actually immortal
                    [_hallOfFamers addObject:p];
                }
            }
        }
        
        for (Player *p in t.teamRBs) {
            if (((t.isUserControlled && [t.playersLeaving containsObject:p]) || (!t.isUserControlled && p.year == 4))
                && (p.careerAllConferences > 3 || p.careerHeismans > 0 || p.careerAllAmericans > 2)) {
                if (![_hallOfFamers containsObject:p]) {
                    p.injury = nil; //sanity check to make sure our immortals are actually immortal
                    [_hallOfFamers addObject:p];
                }
            }
        }
        
        for (Player *p in t.teamWRs) {
            if (((t.isUserControlled && [t.playersLeaving containsObject:p]) || (!t.isUserControlled && p.year == 4))
                && (p.careerAllConferences > 3 || p.careerHeismans > 0 || p.careerAllAmericans > 2)) {
                if (![_hallOfFamers containsObject:p]) {
                    p.injury = nil; //sanity check to make sure our immortals are actually immortal
                    [_hallOfFamers addObject:p];
                }
            }
        }
        
        if (_hallOfFamers.count > 0) {
            for (Player *p in _hallOfFamers) {
                p.year = 5;
            }
            
            //sort normally
            [_hallOfFamers sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                Player *a = (Player*)obj1;
                Player *b = (Player*)obj2;
                if (!a.hasRedshirt && !b.hasRedshirt && !a.isInjured && !b.isInjured) {
                    if (a.ratOvr > b.ratOvr) {
                        return -1;
                    } else if (a.ratOvr < b.ratOvr) {
                        return 1;
                    } else {
                        if (a.ratPot > b.ratPot) {
                            return -1;
                        } else if (a.ratPot < b.ratPot) {
                            return 1;
                        } else {
                            return 0;
                        }
                    }
                } else if (a.hasRedshirt) {
                    return 1;
                } else if (b.hasRedshirt) {
                    return -1;
                } else if (a.isInjured) {
                    return 1;
                } else if (b.isInjured) {
                    return  -1;
                } else {
                    if (a.ratOvr > b.ratOvr) {
                        return -1;
                    } else if (a.ratOvr < b.ratOvr) {
                        return 1;
                    } else {
                        if (a.ratPot > b.ratPot) {
                            return -1;
                        } else if (a.ratPot < b.ratPot) {
                            return 1;
                        } else {
                            return 0;
                        }
                    }
                }
            }];
            
            //sort by most hallowed (hallowScore = normalized OVR + 2 * all-conf + 4 * all-Amer + 6 * Heisman; tie-break w/ pure OVR, then gamesPlayed, then potential)
            int maxOvr = _hallOfFamers[0].ratOvr;
            [_hallOfFamers sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                Player *a = (Player*)obj1;
                Player *b = (Player*)obj2;
                int aHallowScore = (100 * ((double)a.ratOvr / (double) maxOvr)) + (2 * a.careerAllConferences) + (4 * a.careerAllAmericans) + (6 * a.careerHeismans);
                int bHallowScore = (100 * ((double)b.ratOvr / (double) maxOvr)) + (2 * b.careerAllConferences) + (4 * b.careerAllAmericans) + (6 * b.careerHeismans);
                if (aHallowScore > bHallowScore) {
                    return -1;
                } else if (bHallowScore > aHallowScore) {
                    return 1;
                } else {
                    if (a.ratOvr > b.ratOvr) {
                        return -1;
                    } else if (a.ratOvr < b.ratOvr) {
                        return 1;
                    } else {
                        if (a.gamesPlayed > b.gamesPlayed) {
                            return -1;
                        } else if (a.gamesPlayed < b.gamesPlayed) {
                            return 1;
                        } else {
                            if (a.ratPot > b.ratPot) {
                                return -1;
                            } else if (a.ratPot < b.ratPot) {
                                return 1;
                            } else {
                                return 0;
                            }
                        }
                    }
                }
            }];
        }
    }
}

-(BOOL)isTeamNameValid:(NSString*)name {
    if (name.length == 0) {
        return NO;
    }
    
    //Create character set
    NSCharacterSet *validChars = [NSCharacterSet lowercaseLetterCharacterSet];
    
    //Invert the set
    validChars = [validChars invertedSet];
    
    //Check against that
    NSRange  range = [name.lowercaseString rangeOfCharacterFromSet:validChars];
    if (NSNotFound != range.location) {
        return false;
    }
    
    for (int i = 0; i < _teamList.count; i++) {
        // compare using all lower case so no dumb duplicates
        if ([_teamList[i].name.lowercaseString isEqualToString:name.lowercaseString] &&
            !_teamList[i].isUserControlled) {
            return false;
        }
    }
    
    return true;
}

-(BOOL)isTeamAbbrValid:(NSString*)abbr {
    if (abbr.length == 0 || abbr.length > 3) {
        return NO;
    }
    
    //Create character set
    NSCharacterSet *validChars = [NSCharacterSet lowercaseLetterCharacterSet];
    
    //Invert the set
    validChars = [validChars invertedSet];
    
    //Check against that
    NSRange  range = [abbr.lowercaseString rangeOfCharacterFromSet:validChars];
    if (NSNotFound != range.location) {
        return false;
    }
    
    for (int i = 0; i < _teamList.count; i++) {
        // compare using all lower case so no dumb duplicates
        if ([_teamList[i].abbreviation.lowercaseString isEqualToString:abbr.lowercaseString] &&
            !_teamList[i].isUserControlled) {
            return false;
        }
    }
    
    return true;
}

-(BOOL)isConfNameValid:(NSString*)name {
    if (name.length == 0) {
        return NO;
    }
    
    //Create character set
    NSCharacterSet *validChars = [NSCharacterSet lowercaseLetterCharacterSet];
    
    //Invert the set
    validChars = [validChars invertedSet];
    
    //Check against that
    NSRange  range = [name.lowercaseString rangeOfCharacterFromSet:validChars];
    if (NSNotFound != range.location) {
        return false;
    }
    
    for (int i = 0; i < _conferences.count; i++) {
        // compare using all lower case so no dumb duplicates
        if ([_conferences[i].confFullName.lowercaseString isEqualToString:name.lowercaseString]) {
            return false;
        }
    }
    
    return true;
}

-(BOOL)isConfAbbrValid:(NSString*)abbr {
    if (abbr.length == 0 || abbr.length > 3) {
        return NO;
    }
    
    //Create character set
    NSCharacterSet *validChars = [NSCharacterSet lowercaseLetterCharacterSet];
    
    //Invert the set
    validChars = [validChars invertedSet];
    
    //Check against that
    NSRange  range = [abbr.lowercaseString rangeOfCharacterFromSet:validChars];
    if (NSNotFound != range.location) {
        return false;
    }
    
    for (int i = 0; i < _conferences.count; i++) {
        // compare using all lower case so no dumb duplicates
        if ([_conferences[i].confName.lowercaseString isEqualToString:abbr.lowercaseString]) {
            return false;
        }
    }
    
    return true;
}


@end
