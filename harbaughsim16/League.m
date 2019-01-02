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
#import "HeadCoach.h"

#import "PlayerQB.h"
#import "PlayerRB.h"
#import "PlayerWR.h"
#import "PlayerK.h"
#import "PlayerOL.h"
#import "PlayerTE.h"
#import "PlayerLB.h"
#import "PlayerDL.h"
#import "PlayerCB.h"
#import "PlayerS.h"
#import "Injury.h"

#import "HBSharedUtils.h"
#import "NSArray+Uniqueness.h"

#import "FCFileManager.h"
#import "AutoCoding.h"

@implementation League
@synthesize teamList,userTeam,cursedTeam,blessedTeam,cursedTeamCoachName,blessedTeamCoachName,canRebrandTeam,careerRecTDsRecord,careerPassTDsRecord,careerRushTDsRecord,singleSeasonRecTDsRecord,singleSeasonPassTDsRecord,singleSeasonRushTDsRecord,nameList,currentWeek,newsStories,recruitingStage,cursedStoryIndex,heismanFinalists,semiG14,semiG23,bowlGames,ncg,allLeaguePlayers,allDraftedPlayers,heisman,hallOfFamers,hasScheduledBowls,careerRecYardsRecord,careerRushYardsRecord,careerFgMadeRecord,careerXpMadeRecord,careerCarriesRecord,careerCatchesRecord,careerFumblesRecord,careerPassYardsRecord,careerCompletionsRecord,singleSeasonFgMadeRecord,singleSeasonXpMadeRecord,careerInterceptionsRecord,singleSeasonCarriesRecord,singleSeasonCatchesRecord,singleSeasonFumblesRecord,singleSeasonRecYardsRecord,singleSeasonPassYardsRecord,singleSeasonRushYardsRecord,singleSeasonCompletionsRecord,singleSeasonInterceptionsRecord,leagueHistoryDictionary,heismanHistoryDictionary,isHardMode,blessedStoryIndex,conferences, heismanCandidates, leagueVersion, baseYear,lastNameList, bowlTitles,coachList,coachStarList,coachFreeAgents, transferList,transferLog,didFinishTransferPeriod,roty,rotyFinalists,rotyCandidates,rotyHistoryDictionary,cotyWinnerStrFull,cotyWinner,isCareerMode,cotyFinalists;

- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeBool:self.isHardMode forKey:@"isHardMode"];
    [encoder encodeBool:heismanDecided forKey:@"heismanDecided"];
    [encoder encodeBool:self.canRebrandTeam forKey:@"canRebrandTeam"];
    [encoder encodeObject:self.heisman forKey:@"heisman"];
    [encoder encodeObject:self.heismanFinalists forKey:@"heismanFinalists"];
    [encoder encodeObject:heismanCandidates forKey:@"heismanCandidates"];
    [encoder encodeObject:heismanWinnerStrFull forKey:@"heismanWinnerStrFull"];
    [encoder encodeObject:leagueHistory forKey:@"leagueHistory"];
    [encoder encodeObject:self.leagueHistoryDictionary forKey:@"leagueHistoryDictionary"];
    [encoder encodeObject:self.allDraftedPlayers forKey:@"allDraftedPlayers"];
    [encoder encodeObject:self.allLeaguePlayers forKey:@"allLeaguePlayers"];
    [encoder encodeObject:self.hallOfFamers forKey:@"hallOfFamers"];
    [encoder encodeObject:heismanHistory forKey:@"heismanHistory"];
    [encoder encodeObject:self.heismanHistoryDictionary forKey:@"heismanHistoryDictionary"];
    [encoder encodeObject:self.conferences forKey:@"conferences"];
    [encoder encodeObject:self.teamList forKey:@"teamList"];
    [encoder encodeObject:self.nameList forKey:@"nameList"];
    [encoder encodeObject:self.lastNameList forKey:@"lastNameList"];
    [encoder encodeObject:self.newsStories forKey:@"newsStories"];
    [encoder encodeInt:self.currentWeek forKey:@"currentWeek"];
    [encoder encodeBool:self.hasScheduledBowls forKey:@"hasScheduledBowls"];
    [encoder encodeObject:self.semiG14 forKey:@"semiG14"];
    [encoder encodeObject:self.semiG23 forKey:@"semiG23"];
    [encoder encodeObject:self.ncg forKey:@"ncg"];
    [encoder encodeObject:self.bowlGames forKey:@"bowlGames"];
    [encoder encodeObject:self.userTeam forKey:@"userTeam"];
    [encoder encodeInt:self.recruitingStage forKey:@"recruitingStage"];
    [encoder encodeObject:self.blessedTeam forKey:@"blessedTeam"];
    [encoder encodeObject:self.cursedTeam forKey:@"cursedTeam"];
    [encoder encodeObject:self.blessedTeamCoachName forKey:@"blessedTeamCoachName"];
    [encoder encodeObject:self.cursedTeamCoachName forKey:@"cursedTeamCoachName"];
    [encoder encodeInteger:self.blessedStoryIndex forKey:@"blessedStoryIndex"];
    [encoder encodeInteger:self.cursedStoryIndex forKey:@"cursedStoryIndex"];
    [encoder encodeObject:self.bowlTitles forKey:@"bowlTitles"];

    [encoder encodeObject:self.singleSeasonCompletionsRecord forKey:@"singleSeasonCompletionsRecord"];
    [encoder encodeObject:self.singleSeasonPassYardsRecord forKey:@"singleSeasonPassYardsRecord"];
    [encoder encodeObject:self.singleSeasonPassTDsRecord forKey:@"singleSeasonPassTDsRecord"];
    [encoder encodeObject:self.singleSeasonInterceptionsRecord forKey:@"singleSeasonInterceptionsRecord"];
    [encoder encodeObject:self.singleSeasonFumblesRecord forKey:@"singleSeasonFumblesRecord"];
    [encoder encodeObject:self.singleSeasonRushYardsRecord forKey:@"singleSeasonRushYardsRecord"];
    [encoder encodeObject:self.singleSeasonRushTDsRecord forKey:@"singleSeasonRushTDsRecord"];
    [encoder encodeObject:self.singleSeasonCarriesRecord forKey:@"singleSeasonCarriesRecord"];
    [encoder encodeObject:self.singleSeasonRecYardsRecord forKey:@"singleSeasonRecYardsRecord"];
    [encoder encodeObject:self.singleSeasonRecTDsRecord forKey:@"singleSeasonRecTDsRecord"];
    [encoder encodeObject:self.singleSeasonCatchesRecord forKey:@"singleSeasonCatchesRecord"];
    [encoder encodeObject:self.singleSeasonFgMadeRecord forKey:@"singleSeasonFgMadeRecord"];
    [encoder encodeObject:self.singleSeasonXpMadeRecord forKey:@"singleSeasonXpMadeRecord"];

    [encoder encodeObject:self.careerCompletionsRecord forKey:@"careerCompletionsRecord"];
    [encoder encodeObject:self.careerPassYardsRecord forKey:@"careerPassYardsRecord"];
    [encoder encodeObject:self.careerPassTDsRecord forKey:@"careerPassTDsRecord"];
    [encoder encodeObject:self.careerInterceptionsRecord forKey:@"careerInterceptionsRecord"];
    [encoder encodeObject:self.careerFumblesRecord forKey:@"careerFumblesRecord"];
    [encoder encodeObject:self.careerRushYardsRecord forKey:@"careerRushYardsRecord"];
    [encoder encodeObject:self.careerRushTDsRecord forKey:@"careerRushTDsRecord"];
    [encoder encodeObject:self.careerCarriesRecord forKey:@"careerCarriesRecord"];
    [encoder encodeObject:self.careerRecYardsRecord forKey:@"careerRecYardsRecord"];
    [encoder encodeObject:self.careerRecTDsRecord forKey:@"careerRecTDsRecord"];
    [encoder encodeObject:self.careerCatchesRecord forKey:@"careerCatchesRecord"];
    [encoder encodeObject:self.careerFgMadeRecord forKey:@"careerFgMadeRecord"];
    [encoder encodeObject:self.careerXpMadeRecord forKey:@"careerXpMadeRecord"];

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

    [encoder encodeInteger:self.baseYear forKey:@"baseYear"];
    [encoder encodeObject:self.leagueVersion forKey:@"leagueVersion"];

    [encoder encodeBool:self.didFinishTransferPeriod forKey:@"didFinishTransferPeriod"];
    [encoder encodeObject:self.transferList forKey:@"transferList"];
    [encoder encodeObject:self.transferLog forKey:@"transferLog"];

    [encoder encodeObject:rotyFinalists forKey:@"rotyFinalists"];
    [encoder encodeObject:self.rotyHistoryDictionary forKey:@"rotyHistoryDictionary"];
    [encoder encodeObject:rotyCandidates forKey:@"rotyCandidates"];
    [encoder encodeObject:self.roty forKey:@"roty"];
    [encoder encodeBool:rotyDecided forKey:@"rotyDecided"];
    [encoder encodeObject:rotyWinnerStrFull forKey:@"rotyWinnerStrFull"];
    
    [encoder encodeObject:cotyWinnerStrFull forKey:@"cotyWinnerStrFull"];
    [encoder encodeObject:coachFreeAgents forKey:@"coachFreeAgents"];
    [encoder encodeObject:coachStarList forKey:@"coachStarList"];
    [encoder encodeObject:coachList forKey:@"coachList"];
    [encoder encodeObject:cotyWinner forKey:@"cotyWinner"];
    [encoder encodeObject:cotyFinalists forKey:@"cotyFinalists"];
    [encoder encodeBool:cotyDecided forKey:@"cotyDecided"];
    [encoder encodeBool:self.isCareerMode forKey:@"isCareerMode"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {

        heismanDecided = [decoder decodeBoolForKey:@"heismanDecided"];
        self.heisman = [decoder decodeObjectForKey:@"heisman"];
        self.heismanFinalists = [decoder decodeObjectForKey:@"heismanFinalists"];
        heismanCandidates = [decoder decodeObjectForKey:@"heismanCandidates"];
        heismanWinnerStrFull = [decoder decodeObjectForKey:@"heismanWinnerStrFull"];
        leagueHistory = [decoder decodeObjectForKey:@"leagueHistory"];
        heismanHistory = [decoder decodeObjectForKey:@"heismanHistory"];
        self.conferences = [decoder decodeObjectForKey:@"conferences"];
        self.teamList = [decoder decodeObjectForKey:@"teamList"];
        self.nameList = [decoder decodeObjectForKey:@"nameList"];
        self.newsStories = [decoder decodeObjectForKey:@"newsStories"];
        self.currentWeek = [decoder decodeIntForKey:@"currentWeek"];
        self.hasScheduledBowls = [decoder decodeBoolForKey:@"hasScheduledBowls"];
        self.semiG14 = [decoder decodeObjectForKey:@"semiG14"];
        self.semiG23 = [decoder decodeObjectForKey:@"semiG23"];
        self.ncg = [decoder decodeObjectForKey:@"ncg"];
        self.bowlGames = [decoder decodeObjectForKey:@"bowlGames"];
        self.userTeam = [decoder decodeObjectForKey:@"userTeam"];
        self.recruitingStage = [decoder decodeIntForKey:@"recruitingStage"];
        self.canRebrandTeam = [decoder decodeBoolForKey:@"canRebrandTeam"];

        if (![decoder containsValueForKey:@"hallOfFamers"]) {
            self.hallOfFamers = [NSMutableArray array];
        } else {
            self.hallOfFamers = [decoder decodeObjectForKey:@"hallOfFamers"];
        }

        if (![decoder containsValueForKey:@"allDraftedPlayers"]) {
            self.allDraftedPlayers = [NSMutableArray array];
        } else {
            self.allDraftedPlayers = [decoder decodeObjectForKey:@"allDraftedPlayers"];
        }

        if (![decoder containsValueForKey:@"allLeaguePlayers"]) {
            self.allLeaguePlayers = [NSMutableDictionary dictionary];
        } else {
            self.allLeaguePlayers = [decoder decodeObjectForKey:@"allLeaguePlayers"];
        }

        if (![decoder containsValueForKey:@"isHardMode"]) {
            self.isHardMode = NO;
        } else {
            self.isHardMode = [decoder decodeBoolForKey:@"isHardMode"];
        }

        if (![decoder containsValueForKey:@"blessedTeam"]) {
            self.blessedTeam = nil;
        } else {
            self.blessedTeam = [decoder decodeObjectForKey:@"blessedTeam"];
        }

        if (![decoder containsValueForKey:@"cursedTeam"]) {
            self.cursedTeam = nil;
        } else {
            self.cursedTeam = [decoder decodeObjectForKey:@"cursedTeam"];
        }

        if (![decoder containsValueForKey:@"blessedTeamCoachName"]) {
            self.blessedTeamCoachName = nil;
        } else {
            self.blessedTeamCoachName = [decoder decodeObjectForKey:@"blessedTeamCoachName"];
        }

        if (![decoder containsValueForKey:@"cursedTeamCoachName"]) {
            self.cursedTeamCoachName = nil;
        } else {
            self.cursedTeamCoachName = [decoder decodeObjectForKey:@"cursedTeamCoachName"];
        }

        if (![decoder containsValueForKey:@"blessedStoryIndex"]) {
            self.blessedStoryIndex = 0;
        } else {
            self.blessedStoryIndex = [decoder decodeIntForKey:@"blessedStoryIndex"];
        }

        if (![decoder containsValueForKey:@"cursedStoryIndex"]) {
            self.cursedStoryIndex = 0;
        } else {
            self.cursedStoryIndex = [decoder decodeIntForKey:@"cursedStoryIndex"];
        }

        if (![decoder containsValueForKey:@"baseYear"]) {
            self.baseYear = 2016;
        } else {
            self.baseYear = [decoder decodeIntForKey:@"baseYear"];
        }

        if (![decoder containsValueForKey:@"leagueVersion"]) {
            self.leagueVersion = HB_APP_VERSION_PRE_OVERHAUL;
        } else {
            self.leagueVersion = [decoder decodeObjectForKey:@"leagueVersion"];
        }

        if (![decoder containsValueForKey:@"leagueHistoryDictionary"]) {
            NSInteger yearsActive = leagueHistory.count;
            self.leagueHistoryDictionary = [NSMutableDictionary dictionary];
            for (int i = 0; i < yearsActive; i++) {
                [self.leagueHistoryDictionary setObject:leagueHistory[i] forKey:[NSString stringWithFormat:@"%ld",(long)(2016 + i)]];
            }
        } else {
            self.leagueHistoryDictionary = [decoder decodeObjectForKey:@"leagueHistoryDictionary"];
        }

        if (![decoder containsValueForKey:@"heismanHistoryDictionary"]) {
            NSInteger yearsActive = heismanHistory.count;
            self.heismanHistoryDictionary = [NSMutableDictionary dictionary];
            for (int i = 0; i < yearsActive; i++) {
                [self.heismanHistoryDictionary setObject:heismanHistory[i] forKey:[NSString stringWithFormat:@"%ld",(long)(2016 + i)]];
            }
        } else {
            self.heismanHistoryDictionary = [decoder decodeObjectForKey:@"heismanHistoryDictionary"];
            // check minimum year; if is 2016, then remap based on baseYear of save file
            NSMutableArray *keys = [NSMutableArray arrayWithArray:self.heismanHistoryDictionary.allKeys];
            [keys sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                return [obj1 compare:obj2];
            }];
            if ([[keys firstObject] isEqualToString:@"2016"] && baseYear != 2016) {
                NSMutableDictionary *newLeagueHistory = [NSMutableDictionary dictionary];
                for (NSString *yearKey in keys) {
                    NSInteger yearDiff = [yearKey integerValue] - 2016;
                    [newLeagueHistory setObject:self.heismanHistoryDictionary[yearKey] forKey:[NSString stringWithFormat:@"%ld",(long)(baseYear + yearDiff)]];
                }
                self.heismanHistoryDictionary = newLeagueHistory;
            }
        }

        if (![decoder containsValueForKey:@"bowlTitles"]) {
            self.bowlTitles = @[@"Lilac Bowl", @"Apple Bowl", @"Salty Bowl", @"Salsa Bowl", @"Mango Bowl",@"Patriot Bowl", @"Salad Bowl", @"Frost Bowl", @"Tropical Bowl", @"Music Bowl"];
        } else {
            self.bowlTitles = [decoder decodeObjectForKey:@"bowlTitles"];
        }

        //single season
        //pass records
        if (![decoder containsValueForKey:@"singleSeasonCompletionsRecord"]) {
            self.singleSeasonCompletionsRecord = nil;
        } else {
            self.singleSeasonCompletionsRecord = [decoder decodeObjectForKey:@"singleSeasonCompletionsRecord"];
        }

        if (![decoder containsValueForKey:@"singleSeasonPassYardsRecord"]) {
            self.singleSeasonPassYardsRecord = nil;
        } else {

            self.singleSeasonPassYardsRecord = [decoder decodeObjectForKey:@"singleSeasonPassYardsRecord"];
        }

        if (![decoder containsValueForKey:@"singleSeasonPassTDsRecord"]) {
            self.singleSeasonPassTDsRecord = nil;
        } else {
            self.singleSeasonPassTDsRecord = [decoder decodeObjectForKey:@"singleSeasonPassTDsRecord"];
        }

        if (![decoder containsValueForKey:@"singleSeasonInterceptionsRecord"]) {
            self.singleSeasonInterceptionsRecord = nil;
        } else {
            self.singleSeasonInterceptionsRecord = [decoder decodeObjectForKey:@"singleSeasonInterceptionsRecord"];
        }

        // rush records
        if (![decoder containsValueForKey:@"singleSeasonFumblesRecord"]) {
            self.singleSeasonFumblesRecord = nil;
        } else {
            self.singleSeasonFumblesRecord = [decoder decodeObjectForKey:@"singleSeasonFumblesRecord"];
        }

        if (![decoder containsValueForKey:@"singleSeasonRushYardsRecord"]) {
            self.singleSeasonRushYardsRecord = nil;
        } else {

            self.singleSeasonRushYardsRecord = [decoder decodeObjectForKey:@"singleSeasonRushYardsRecord"];
        }

        if (![decoder containsValueForKey:@"singleSeasonRushTDsRecord"]) {
            self.singleSeasonRushTDsRecord = nil;
        } else {
            self.singleSeasonRushTDsRecord = [decoder decodeObjectForKey:@"singleSeasonRushTDsRecord"];
        }

        if (![decoder containsValueForKey:@"singleSeasonCarriesRecord"]) {
            self.singleSeasonCarriesRecord = nil;
        } else {
            self.singleSeasonCarriesRecord = [decoder decodeObjectForKey:@"singleSeasonCarriesRecord"];
        }


        //rec records
        if (![decoder containsValueForKey:@"singleSeasonRecYardsRecord"]) {
            self.singleSeasonRecYardsRecord = nil;
        } else {

            self.singleSeasonRecYardsRecord = [decoder decodeObjectForKey:@"singleSeasonRecYardsRecord"];
        }

        if (![decoder containsValueForKey:@"singleSeasonRecTDsRecord"]) {
            self.singleSeasonRecTDsRecord = nil;
        } else {
            self.singleSeasonRecTDsRecord = [decoder decodeObjectForKey:@"singleSeasonRecTDsRecord"];
        }

        if (![decoder containsValueForKey:@"singleSeasonCatchesRecord"]) {
            self.singleSeasonCatchesRecord = nil;
        } else {
            self.singleSeasonCatchesRecord = [decoder decodeObjectForKey:@"singleSeasonCatchesRecord"];
        }

        //kick records
        if (![decoder containsValueForKey:@"singleSeasonXpMadeRecord"]) {
            self.singleSeasonXpMadeRecord = nil;
        } else {
            self.singleSeasonXpMadeRecord = [decoder decodeObjectForKey:@"singleSeasonXpMadeRecord"];
        }

        if (![decoder containsValueForKey:@"singleSeasonFgMadeRecord"]) {
            self.singleSeasonFgMadeRecord = nil;
        } else {
            self.singleSeasonFgMadeRecord = [decoder decodeObjectForKey:@"singleSeasonFgMadeRecord"];
        }

        //career
        //pass records
        if (![decoder containsValueForKey:@"careerCompletionsRecord"]) {
            self.careerCompletionsRecord = nil;
        } else {
            self.careerCompletionsRecord = [decoder decodeObjectForKey:@"careerCompletionsRecord"];
        }

        if (![decoder containsValueForKey:@"careerPassYardsRecord"]) {
            self.careerPassYardsRecord = nil;
        } else {

            self.careerPassYardsRecord = [decoder decodeObjectForKey:@"careerPassYardsRecord"];
        }

        if (![decoder containsValueForKey:@"careerPassTDsRecord"]) {
            self.careerPassTDsRecord = nil;
        } else {
            self.careerPassTDsRecord = [decoder decodeObjectForKey:@"careerPassTDsRecord"];
        }

        if (![decoder containsValueForKey:@"careerInterceptionsRecord"]) {
            self.careerInterceptionsRecord = nil;
        } else {
            self.careerInterceptionsRecord = [decoder decodeObjectForKey:@"careerInterceptionsRecord"];
        }

        // rush records
        if (![decoder containsValueForKey:@"careerFumblesRecord"]) {
            self.careerFumblesRecord = nil;
        } else {
            self.careerFumblesRecord = [decoder decodeObjectForKey:@"careerFumblesRecord"];
        }

        if (![decoder containsValueForKey:@"careerRushYardsRecord"]) {
            self.careerRushYardsRecord = nil;
        } else {

            self.careerRushYardsRecord = [decoder decodeObjectForKey:@"careerRushYardsRecord"];
        }

        if (![decoder containsValueForKey:@"careerRushTDsRecord"]) {
            self.careerRushTDsRecord = nil;
        } else {
            self.careerRushTDsRecord = [decoder decodeObjectForKey:@"careerRushTDsRecord"];
        }

        if (![decoder containsValueForKey:@"careerCarriesRecord"]) {
            self.careerCarriesRecord = nil;
        } else {
            self.careerCarriesRecord = [decoder decodeObjectForKey:@"careerCarriesRecord"];
        }


        //rec records
        if (![decoder containsValueForKey:@"careerRecYardsRecord"]) {
            self.careerRecYardsRecord = nil;
        } else {

            self.careerRecYardsRecord = [decoder decodeObjectForKey:@"careerRecYardsRecord"];
        }

        if (![decoder containsValueForKey:@"careerRecTDsRecord"]) {
            self.careerRecTDsRecord = nil;
        } else {
            self.careerRecTDsRecord = [decoder decodeObjectForKey:@"careerRecTDsRecord"];
        }

        if (![decoder containsValueForKey:@"careerCatchesRecord"]) {
            self.careerCatchesRecord = nil;
        } else {
            self.careerCatchesRecord = [decoder decodeObjectForKey:@"careerCatchesRecord"];
        }

        //kick records
        if (![decoder containsValueForKey:@"careerXpMadeRecord"]) {
            self.careerXpMadeRecord = nil;
        } else {
            self.careerXpMadeRecord = [decoder decodeObjectForKey:@"careerXpMadeRecord"];
        }

        if (![decoder containsValueForKey:@"careerFgMadeRecord"]) {
            self.careerFgMadeRecord = nil;
        } else {
            self.careerFgMadeRecord = [decoder decodeObjectForKey:@"careerFgMadeRecord"];
        }

        if (![decoder containsValueForKey:@"lastNameList"]) {
            NSArray *lastNamePathFrags = [[HBSharedUtils lastNamesCSV] componentsSeparatedByString:@"."];
            NSString *lastNamePath = lastNamePathFrags[0];
            NSString *lastNameFullPath = [[NSBundle mainBundle] pathForResource:lastNamePath ofType:@"csv"];
            NSError *error;
            NSString *lastNameCSV = [NSString stringWithContentsOfFile:lastNameFullPath encoding:NSUTF8StringEncoding error:&error];
            if (error) {
                NSLog(@"Last name list retrieve error: %@", error);
            }
            self.lastNameList = [NSMutableArray array];
            NSArray *lastNamesSplit = [lastNameCSV componentsSeparatedByString:@","];
            for (NSString *n in lastNamesSplit) {
                [lastNameList addObject:[n stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]]];
            }
        } else {
            self.lastNameList = [decoder decodeObjectForKey:@"lastNameList"];
        }

        if (![decoder containsValueForKey:@"transferList"]) {
            self.transferList = @{};
        } else {
            self.transferList = [decoder decodeObjectForKey:@"transferList"];
        }

        if (![decoder containsValueForKey:@"transferLog"]) {
            self.transferLog = [NSMutableArray array];
        } else {
            self.transferLog = [decoder decodeObjectForKey:@"transferLog"];
        }

        if (![decoder containsValueForKey:@"didFinishTransferPeriod"]) {
            self.didFinishTransferPeriod = NO;
        } else {
            self.didFinishTransferPeriod = [decoder decodeBoolForKey:@"didFinishTransferPeriod"];
        }

        if (![decoder containsValueForKey:@"rotyHistoryDictionary"]) {
            self.rotyHistoryDictionary = [NSMutableDictionary dictionary];
        } else {
            self.rotyHistoryDictionary = [decoder decodeObjectForKey:@"rotyHistoryDictionary"];
        }

        if (![decoder containsValueForKey:@"rotyCandidates"]) {
            self.rotyCandidates = [NSMutableArray array];
        } else {
            self.rotyCandidates = [decoder decodeObjectForKey:@"rotyCandidates"];
        }

        if (![decoder containsValueForKey:@"rotyFinalists"]) {
            self.rotyFinalists = [NSMutableArray array];
        } else {
            self.rotyFinalists = [decoder decodeObjectForKey:@"rotyFinalists"];
        }

        if (![decoder containsValueForKey:@"rotyDecided"]) {
            rotyDecided = NO;
        } else {
            rotyDecided = [decoder decodeBoolForKey:@"rotyDecided"];
        }

        if (![decoder containsValueForKey:@"rotyWinnerStrFull"]) {
            rotyWinnerStrFull = @"";
        } else {
            rotyWinnerStrFull = [decoder decodeObjectForKey:@"rotyWinnerStrFull"];
        }

        if (![decoder containsValueForKey:@"roty"]) {
            roty = nil;
        } else {
            roty = [decoder decodeObjectForKey:@"roty"];
        }
        
        // coaching
        if (![decoder containsValueForKey:@"cotyWinnerStrFull"]) {
            cotyWinnerStrFull = @"";
        } else {
            cotyWinnerStrFull = [decoder decodeObjectForKey:@"cotyWinnerStrFull"];
        }
        
        if (![decoder containsValueForKey:@"cotyWinner"]) {
            cotyWinner = nil;
        } else {
            cotyWinner = [decoder decodeObjectForKey:@"cotyWinner"];
        }
        
        if (![decoder containsValueForKey:@"coachFreeAgents"]) {
            coachFreeAgents = nil;
        } else {
            coachFreeAgents = [decoder decodeObjectForKey:@"coachFreeAgents"];
        }
        
        if (![decoder containsValueForKey:@"coachStarList"]) {
            coachStarList = nil;
        } else {
            coachStarList = [decoder decodeObjectForKey:@"coachStarList"];
        }
        
        if (![decoder containsValueForKey:@"coachList"]) {
            coachList = nil;
        } else {
            coachList = [decoder decodeObjectForKey:@"coachList"];
        }
        
        if (![decoder containsValueForKey:@"isCareerMode"]) {
            isCareerMode = NO;
        } else {
            isCareerMode = [decoder decodeBoolForKey:@"isCareerMode"];
        }
        
        if (![decoder containsValueForKey:@"cotyDecided"]) {
            cotyDecided = NO;
        } else {
            cotyDecided = [decoder decodeBoolForKey:@"cotyDecided"];
        }
        
        if (![decoder containsValueForKey:@"cotyFinalists"]) {
            cotyFinalists = [NSMutableArray array];
        } else {
            cotyFinalists = [decoder decodeObjectForKey:@"cotyFinalists"];
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
    if (singleSeasonCompletionsRecord != nil) {
        [records addObject:singleSeasonCompletionsRecord];
    }

    if (singleSeasonPassYardsRecord != nil) {
        [records addObject:singleSeasonPassYardsRecord];
    }

    if (singleSeasonPassTDsRecord != nil) {
        [records addObject:singleSeasonPassTDsRecord];
    }

    if (singleSeasonInterceptionsRecord != nil) {
        [records addObject:singleSeasonInterceptionsRecord];
    }

    if (singleSeasonCarriesRecord != nil) {
        [records addObject:singleSeasonCarriesRecord];
    }

    if (singleSeasonRushYardsRecord != nil) {
        [records addObject:singleSeasonRushYardsRecord];
    }

    if (singleSeasonRushTDsRecord != nil) {
        [records addObject:singleSeasonRushTDsRecord];
    }

    if (singleSeasonFumblesRecord != nil) {
        [records addObject:singleSeasonFumblesRecord];
    }

    if (singleSeasonCatchesRecord != nil) {
        [records addObject:singleSeasonCatchesRecord];
    }

    if (singleSeasonRecYardsRecord != nil) {
        [records addObject:singleSeasonRecYardsRecord];
    }

    if (singleSeasonRecTDsRecord != nil) {
        [records addObject:singleSeasonRecTDsRecord];
    }

    if (singleSeasonXpMadeRecord != nil) {
        [records addObject:singleSeasonXpMadeRecord];
    }

    if (singleSeasonFgMadeRecord != nil) {
        [records addObject:singleSeasonFgMadeRecord];
    }

    return records;
}

-(NSArray*)careerRecords {
    NSMutableArray *records = [NSMutableArray array];
    if (careerCompletionsRecord != nil) {
        [records addObject:careerCompletionsRecord];
    }

    if (careerPassYardsRecord != nil) {
        [records addObject:careerPassYardsRecord];
    }

    if (careerPassTDsRecord != nil) {
        [records addObject:careerPassTDsRecord];
    }

    if (careerInterceptionsRecord != nil) {
        [records addObject:careerInterceptionsRecord];
    }

    if (careerCarriesRecord != nil) {
        [records addObject:careerCarriesRecord];
    }

    if (careerRushYardsRecord != nil) {
        [records addObject:careerRushYardsRecord];
    }

    if (careerRushTDsRecord != nil) {
        [records addObject:careerRushTDsRecord];
    }

    if (careerFumblesRecord != nil) {
        [records addObject:careerFumblesRecord];
    }

    if (careerCatchesRecord != nil) {
        [records addObject:careerCatchesRecord];
    }

    if (careerRecYardsRecord != nil) {
        [records addObject:careerRecYardsRecord];
    }

    if (careerRecTDsRecord != nil) {
        [records addObject:careerRecTDsRecord];
    }

    if (careerXpMadeRecord != nil) {
        [records addObject:careerXpMadeRecord];
    }

    if (careerFgMadeRecord != nil) {
        [records addObject:careerFgMadeRecord];
    }

    return records;
}

-(BOOL)isSaveCorrupt {
    for (Team *t in teamList) {
         // check this at all points EXCEPT at the end of the season after transfers processed. Teams will be uneven after transfers process.
        if (didFinishTransferPeriod == NO && currentWeek > 15) {
            if ((t.teamQBs == nil || t.teamQBs.count < 2)
                || (t.teamRBs == nil || t.teamRBs.count < 4)
                || (t.teamWRs == nil || t.teamWRs.count < 6)
                || (t.teamTEs == nil || t.teamTEs.count < 2)
                || (t.teamOLs == nil || t.teamOLs.count < 10)
                || (t.teamDLs == nil || t.teamDLs.count < 8)
                || (t.teamLBs == nil || t.teamLBs.count < 6)
                || (t.teamCBs == nil || t.teamCBs.count < 6)
                || (t.teamSs == nil || t.teamSs.count < 2)
                || (t.teamKs == nil || t.teamKs.count < 2)) {
                return YES;
            }
        }

        // check this at all times EXCEPT immediately after transfers have been processed. p.team will be never be nil b/c we don't remove their team in -[Team getTransferringPlayers] or -[TransferPeriodViewController advanceRecruits]
        if (!didFinishTransferPeriod) {
            NSArray *players = [t getAllPlayers];
            for (Player *p in players) {
                if ((((p.isTransfer || p.isGradTransfer) && p.team == nil) || ![p.team isEqual:t])) {
                    return YES;
                }
            }
        }
    }

    // check this at all times. Conferences always need to be in working order.
    for (Conference *c in conferences) {
        if (![c.confTeams allObjectsAreUnique]) {
            return YES;
        }
    }
    return NO;
}

-(void)save {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"saveInProgress" object:nil];
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0), ^(void){
        if([FCFileManager existsItemAtPath:@"league.cfb"]) {
            NSError *error;
            BOOL success = [FCFileManager writeFileAtPath:@"league.cfb" content:self error:&error];
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
            BOOL success = [FCFileManager createFileAtPath:@"league.cfb" withContent:self error:&error];
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
        //NSError *error;
        //NSLog(@"Archived data: %@ error: %@", data, error);
        //NSLog(@"Unarchived data: %@",[NSKeyedUnarchiver unarchiveObjectWithData:ligueData]);
        League *ligue = (League*)[FCFileManager readFileAtPathAsCustomModel:@"league.cfb"];
         [ligue setUserTeam:ligue.userTeam];
         [(AppDelegate*)[[UIApplication sharedApplication] delegate] setLeague:ligue];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"newNewsStory" object:nil];
        return YES;
    } else {
        return NO;
    }
}

-(instancetype)initWithSaveFile:(NSString*)saveFileName {
    self = [super init];
    if (self) {
        recruitingStage = 0;
        heismanDecided = NO;
        hasScheduledBowls = NO;
        currentWeek = 0;
        League *ligue = (League*)[FCFileManager readFileAtPathAsCustomModel:saveFileName];
        self = ligue;
    }
    return self;
}

-(instancetype)loadFromSaveFileWithNames {
    return [[League alloc] initWithSaveFile:@"league.cfb"];
}

-(NSArray*)bowlGameTitles {
    if (bowlTitles == nil || bowlTitles.count == 0) {
        return @[@"Lilac Bowl", @"Apple Bowl", @"Salty Bowl", @"Salsa Bowl", @"Mango Bowl",@"Patriot Bowl", @"Salad Bowl", @"Frost Bowl", @"Tropical Bowl", @"Music Bowl"];
    } else {
        return bowlTitles;
    }
}

+(instancetype)newLeagueFromCSV:(NSString*)namesCSV {
    return [[League alloc] initFromCSV:namesCSV lastNamesCSV:namesCSV];
}

+(instancetype)newLeagueFromCSV:(NSString*)namesCSV lastNamesCSV:(NSString*)lastNameCSV {
    return [[League alloc] initFromCSV:namesCSV lastNamesCSV:lastNameCSV];
}

+(instancetype)newLeagueFromSaveFile:(NSString*)saveFileName {
    return [[League alloc] initWithSaveFile:saveFileName];
}

-(instancetype)initFromCSV:(NSString*)namesCSV lastNamesCSV:(NSString*)lastNameCSV {
    self = [super init];
    if (self){
        isHardMode = NO;
        isCareerMode = NO;
        recruitingStage = 0;
        heismanDecided = NO;
        hasScheduledBowls = NO;
        hallOfFamers = [NSMutableArray array];
        leagueHistory = [NSMutableArray array];
        leagueHistoryDictionary = [NSMutableDictionary dictionary];
        heismanHistory = [NSMutableArray array];
        heismanHistoryDictionary = [NSMutableDictionary dictionary];
        heismanFinalists = [NSMutableArray array];

        rotyHistoryDictionary = [NSMutableDictionary dictionary];
        rotyFinalists = [NSMutableArray array];
        rotyCandidates = [NSMutableArray array];
        rotyDecided = NO;
        rotyWinnerStrFull = nil;

        transferList = @{
                         @"QB" : [NSMutableArray array],
                         @"RB" : [NSMutableArray array],
                         @"WR" : [NSMutableArray array],
                         @"TE" : [NSMutableArray array],
                         @"OL" : [NSMutableArray array],
                         @"DL" : [NSMutableArray array],
                         @"LB" : [NSMutableArray array],
                         @"CB" : [NSMutableArray array],
                         @"S" : [NSMutableArray array],
                         @"K" : [NSMutableArray array]
                         };
        transferLog = [NSMutableArray array];
        didFinishTransferPeriod = NO;

        heisman = nil;
        currentWeek = 0;
        bowlGames = [NSMutableArray array];

        bowlTitles = @[@"Lilac Bowl", @"Apple Bowl", @"Salty Bowl", @"Salsa Bowl", @"Mango Bowl",@"Patriot Bowl", @"Salad Bowl", @"Frost Bowl", @"Tropical Bowl", @"Music Bowl"];

        conferences = [NSMutableArray array];
        blessedTeam = nil;
        cursedTeam = nil;
        blessedStoryIndex = 0;
        cursedStoryIndex = 0;

        leagueVersion = HB_CURRENT_APP_VERSION;
        baseYear = [[[NSCalendar currentCalendar] components: NSCalendarUnitYear fromDate:[NSDate date]] year];

        cotyWinner = nil;
        cotyWinnerStrFull = nil;
        coachFreeAgents = [NSMutableArray array];
        coachStarList = [NSMutableArray array];
        coachList = [NSMutableArray array];
        cotyFinalists = [NSMutableArray array];
        cotyDecided = NO;

        careerCompletionsRecord = nil;
        careerPassYardsRecord = nil;
        careerPassTDsRecord = nil;
        careerInterceptionsRecord = nil;
        careerFumblesRecord = nil;
        careerRushYardsRecord = nil;
        careerRushTDsRecord = nil;
        careerCarriesRecord = nil;
        careerRecYardsRecord = nil;
        careerRecTDsRecord = nil;
        careerCatchesRecord = nil;
        careerXpMadeRecord = nil;
        careerFgMadeRecord = nil;

        singleSeasonCompletionsRecord = nil;
        singleSeasonPassYardsRecord = nil;
        singleSeasonPassTDsRecord = nil;
        singleSeasonInterceptionsRecord = nil;
        singleSeasonFumblesRecord = nil;
        singleSeasonRushYardsRecord = nil;
        singleSeasonRushTDsRecord = nil;
        singleSeasonCarriesRecord = nil;
        singleSeasonRecYardsRecord = nil;
        singleSeasonRecTDsRecord = nil;
        singleSeasonCatchesRecord = nil;
        singleSeasonXpMadeRecord = nil;
        singleSeasonFgMadeRecord = nil;

        [conferences addObject:[Conference newConferenceWithName:@"SOUTH" fullName:@"Southern" league:self]];
        [conferences addObject:[Conference newConferenceWithName:@"LAKES" fullName:@"Lakes" league:self]];
        [conferences addObject:[Conference newConferenceWithName:@"NORTH" fullName:@"North" league:self]];
        [conferences addObject:[Conference newConferenceWithName:@"COWBY" fullName:@"Cowboy" league:self]];
        [conferences addObject:[Conference newConferenceWithName:@"PACIF" fullName:@"Pacific" league:self]];
        [conferences addObject:[Conference newConferenceWithName:@"MOUNT" fullName:@"Mountain" league:self]];

        newsStories = [NSMutableArray array];
        for (int i = 0; i < 16; i++) {
            [newsStories addObject:[NSMutableArray array]];
        }

        NSMutableArray *first = newsStories[0];
        [first addObject:@"New Season!\nReady for the new season, coach? Whether the National Championship is on your mind, or just a winning season, good luck!"];

        nameList = [NSMutableArray array];
        NSArray *namesSplit = [namesCSV componentsSeparatedByString:@","];
        for (NSString *n in namesSplit) {
            [nameList addObject:[n stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]]];
        }

        lastNameList = [NSMutableArray array];
        NSArray *lastNamesSplit = [lastNameCSV componentsSeparatedByString:@","];
        for (NSString *n in lastNamesSplit) {
            [lastNameList addObject:[n stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]]];
        }

        Conference *south = conferences[0];
        Conference *lakes = conferences[1];
        Conference *north = conferences[2];
        Conference *cowboy = conferences[3];
        Conference *pacific = conferences[4];
        Conference *mountain = conferences[5];

        //SOUTH
        [south.confTeams addObject:[Team newTeamWithName:@"Alabama" abbreviation:@"ALA" conference:@"SOUTH" league:self prestige:95 rivalTeam:@"ATH" state:@"Alabama"]]; //"Alabama", "ALA", "SOUTH", this, 95, "GEO" )
        [south.confTeams addObject:[Team newTeamWithName:@"Athens" abbreviation:@"ATH" conference:@"SOUTH" league:self prestige:90 rivalTeam:@"ALA" state:@"Georgia"]];//south.confTeams.add( new Team( "Georgia", "GEO", "SOUTH", this, 90, "ALA" ));
        [south.confTeams addObject:[Team newTeamWithName:@"Florida" abbreviation:@"FLA" conference:@"SOUTH" league:self prestige:85 rivalTeam:@"TEN" state:@"Florida"]];//Florida( new Team( "Florida", "FLA", "SOUTH", this, 85, "TEN" ));
        [south.confTeams addObject:[Team newTeamWithName:@"Tennessee" abbreviation:@"TEN" conference:@"SOUTH" league:self prestige:80 rivalTeam:@"FLA" state:@"Tennessee"]];//south.confTeams.add( new Team( "Tennessee", "TEN", "SOUTH", this, 80, "FLA" ));
        [south.confTeams addObject:[Team newTeamWithName:@"Atlanta" abbreviation:@"ATL" conference:@"SOUTH" league:self prestige:75 rivalTeam:@"KYW" state:@"Georgia"]];//south.confTeams.add( new Team( "Atlanta", "ATL", "SOUTH", this, 75, "KYW" ));
        [south.confTeams addObject:[Team newTeamWithName:@"New Orleans" abbreviation:@"NOR" conference:@"SOUTH" league:self prestige:75 rivalTeam:@"LOU" state:@"Louisiana"]];//south.confTeams.add( new Team( "New Orleans", "NOR", "SOUTH", this, 75, "LOU" ));
        [south.confTeams addObject:[Team newTeamWithName:@"Arkansas" abbreviation:@"ARK" conference:@"SOUTH" league:self prestige:70 rivalTeam:@"KTY" state:@"Arkansas"]];//south.confTeams.add( new Team( "Arkansas", "ARK", "SOUTH", this, 70, "KTY" ));
        [south.confTeams addObject:[Team newTeamWithName:@"Louisiana" abbreviation:@"LOU" conference:@"SOUTH" league:self prestige:65 rivalTeam:@"NOR" state:@"Louisiana"]];//south.confTeams.add( new Team( "Louisiana", "LOU", "SOUTH", this, 65, "NOR" ));
        [south.confTeams addObject:[Team newTeamWithName:@"Key West" abbreviation:@"KYW" conference:@"SOUTH" league:self prestige:65 rivalTeam:@"ATL" state:@"Florida"]];//south.confTeams.add( new Team( "Key West", "KYW", "SOUTH", this, 65, "ATL" ));
        [south.confTeams addObject:[Team newTeamWithName:@"Kentucky" abbreviation:@"KTY" conference:@"SOUTH" league:self prestige:50 rivalTeam:@"ARK" state:@"Kentucky"]];//south.confTeams.add( new Team( "Kentucky", "KTY", "SOUTH", this, 50, "ARK" ));


         //LAKES
         [lakes.confTeams addObject:[Team newTeamWithName:@"Ohio State" abbreviation:@"OHI" conference:@"LAKES" league:self prestige:90 rivalTeam:@"MIC" state:@"Ohio"]];//lakes.confTeams.add( new Team( "Ohio State", "OHI", "LAKES", this, 90, "MIC" ));
         [lakes.confTeams addObject:[Team newTeamWithName:@"Michigan" abbreviation:@"MIC" conference:@"LAKES" league:self prestige:90 rivalTeam:@"OHI" state:@"Michigan"]];//lakes.confTeams.add( new Team( "Michigan", "MIC", "LAKES", this, 90, "OHI" ));
         [lakes.confTeams addObject:[Team newTeamWithName:@"Michigan St" abbreviation:@"MSU" conference:@"LAKES" league:self prestige:80 rivalTeam:@"MIN" state:@"Michigan"]];//lakes.confTeams.add( new Team( "Michigan St", "MSU", "LAKES", this, 80, "MIN" ));
         [lakes.confTeams addObject:[Team newTeamWithName:@"Wisconsin" abbreviation:@"WIS" conference:@"LAKES" league:self prestige:70 rivalTeam:@"IND" state:@"Wisconsin"]];//lakes.confTeams.add( new Team( "Wisconsin", "WIS", "LAKES", this, 70, "IND" ));
         [lakes.confTeams addObject:[Team newTeamWithName:@"Minnesota" abbreviation:@"MIN" conference:@"LAKES" league:self prestige:70 rivalTeam:@"MSU" state:@"Minnesota"]];//lakes.confTeams.add( new Team( "Minnesota", "MIN", "LAKES", this, 70, "MSU" ));
         [lakes.confTeams addObject:[Team newTeamWithName:@"Univ of Chicago" abbreviation:@"CHI" conference:@"LAKES" league:self prestige:70 rivalTeam:@"DET" state:@"Illinois"]];//lakes.confTeams.add( new Team( "Univ of Chicago", "CHI", "LAKES", this, 70, "DET" ));
         [lakes.confTeams addObject:[Team newTeamWithName:@"Detroit St" abbreviation:@"DET" conference:@"LAKES" league:self prestige:65 rivalTeam:@"CHI" state:@"Michigan"]];//lakes.confTeams.add( new Team( "Detroit St", "DET", "LAKES", this, 65, "CHI" ));
         [lakes.confTeams addObject:[Team newTeamWithName:@"Indiana" abbreviation:@"IND" conference:@"LAKES" league:self prestige:65 rivalTeam:@"WIS" state:@"Indiana"]];//( new Team( "Indiana", "IND", "LAKES", this, 65, "WIS" ));
         [lakes.confTeams addObject:[Team newTeamWithName:@"Cleveland State" abbreviation:@"CLE" conference:@"LAKES" league:self prestige:55 rivalTeam:@"MIL" state:@"Ohio"]];//lakes.confTeams.add( new Team( "Cleveland St", "CLE", "LAKES", this, 55, "MIL" ));
         [lakes.confTeams addObject:[Team newTeamWithName:@"Milwaukee" abbreviation:@"MIL" conference:@"LAKES" league:self prestige:45 rivalTeam:@"CLE" state:@"Wisconsin"]];//lakes.confTeams.add( new Team( "Milwaukee", "MIL", "LAKES", this, 45, "CLE" ));

         //NORTH
        [north.confTeams addObject:[Team newTeamWithName:@"New York St" abbreviation:@"NYS" conference:@"NORTH" league:self prestige:90 rivalTeam:@"NYC" state:@"New York"]];//north.confTeams.add( new Team( "New York St", "NYS", "NORTH", this, 90, "NYC" ));
         [north.confTeams addObject:[Team newTeamWithName:@"New Jersey" abbreviation:@"NWJ" conference:@"NORTH" league:self prestige:85 rivalTeam:@"PEN" state:@"New Jersey"]];//north.confTeams.add( new Team( "New Jersey", "NWJ", "NORTH", this, 85, "PEN" ));
         [north.confTeams addObject:[Team newTeamWithName:@"New York City" abbreviation:@"NYC" conference:@"NORTH" league:self prestige:75 rivalTeam:@"NYS" state:@"New York"]];//north.confTeams.add( new Team( "New York City", "NYC", "NORTH", this, 75, "NYS" ));
         [north.confTeams addObject:[Team newTeamWithName:@"Pennsylvania" abbreviation:@"PEN" conference:@"NORTH" league:self prestige:75 rivalTeam:@"NWJ" state:@"Pennsylvania"]];//north.confTeams.add( new Team( "Pennsylvania", "PEN", "NORTH", this, 75, "NWJ" ));
         [north.confTeams addObject:[Team newTeamWithName:@"Maryland" abbreviation:@"MAR" conference:@"NORTH" league:self prestige:70 rivalTeam:@"WDC" state:@"Maryland"]];//north.confTeams.add( new Team( "Maryland", "MAR", "NORTH", this, 70, "WDC" ));
         [north.confTeams addObject:[Team newTeamWithName:@"Washington DC" abbreviation:@"WDC" conference:@"NORTH" league:self prestige:70 rivalTeam:@"MAR" state:@"District of Columbia"]];//north.confTeams.add( new Team( "Washington DC", "WDC", "NORTH", this, 70, "MAR" ));
         [north.confTeams addObject:[Team newTeamWithName:@"Boston St" abbreviation:@"BOS" conference:@"NORTH" league:self prestige:65 rivalTeam:@"VER" state:@"Massachusetts"]];//north.confTeams.add( new Team( "Boston St", "BOS", "NORTH", this, 65, "VER" ));
         [north.confTeams addObject:[Team newTeamWithName:@"Pittsburgh" abbreviation:@"PIT" conference:@"NORTH" league:self prestige:60 rivalTeam:@"MAI" state:@"Pennsylvania"]];//north.confTeams.add( new Team( "Pittsburgh", "PIT", "NORTH", this, 60, "MAI" ));
         [north.confTeams addObject:[Team newTeamWithName:@"Maine" abbreviation:@"MAI" conference:@"NORTH" league:self prestige:50 rivalTeam:@"PIT" state:@"Maine"]];//north.confTeams.add( new Team( "Maine", "MAI", "NORTH", this, 50, "PIT" ));
         [north.confTeams addObject:[Team newTeamWithName:@"Vermont" abbreviation:@"VER" conference:@"NORTH" league:self prestige:45 rivalTeam:@"BOS" state:@"Vermont"]];//north.confTeams.add( new Team( "Vermont", "VER", "NORTH", this, 45, "BOS" ));

         //COWBY
         [cowboy.confTeams addObject:[Team newTeamWithName:@"Oklahoma" abbreviation:@"OKL" conference:@"COWBY" league:self prestige:90 rivalTeam:@"TEX" state:@"Oklahoma"]];//cowboy.confTeams.add( new Team( "Oklahoma", "OKL", "COWBY", this, 90, "TEX" ));
         [cowboy.confTeams addObject:[Team newTeamWithName:@"Texas" abbreviation:@"TEX" conference:@"COWBY" league:self prestige:90 rivalTeam:@"OKL" state:@"Texas"]];//cowboy.confTeams.add( new Team( "Texas", "TEX", "COWBY", this, 90, "OKL" ));
         [cowboy.confTeams addObject:[Team newTeamWithName:@"Houston" abbreviation:@"HOU" conference:@"COWBY" league:self prestige:80 rivalTeam:@"DAL" state:@"Texas"]];//cowboy.confTeams.add( new Team( "Houston", "HOU", "COWBY", this, 80, "DAL" ));
         [cowboy.confTeams addObject:[Team newTeamWithName:@"Dallas" abbreviation:@"DAL" conference:@"COWBY" league:self prestige:80 rivalTeam:@"HOU" state:@"Texas"]];//cowboy.confTeams.add( new Team( "Dallas", "DAL", "COWBY", this, 80, "HOU" ));
         [cowboy.confTeams addObject:[Team newTeamWithName:@"Alamo St" abbreviation:@"AMO" conference:@"COWBY" league:self prestige:70 rivalTeam:@"PAS" state:@"Texas"]];//cowboy.confTeams.add( new Team( "Alamo St", "AMO", "COWBY", this, 70, "PAS" ));
         [cowboy.confTeams addObject:[Team newTeamWithName:@"Oklahoma St" abbreviation:@"OKS" conference:@"COWBY" league:self prestige:70 rivalTeam:@"TUL" state:@"Oklahoma"]];//cowboy.confTeams.add( new Team( "Oklahoma St", "OKS", "COWBY", this, 70, "TUL" ));
         [cowboy.confTeams addObject:[Team newTeamWithName:@"El Paso St" abbreviation:@"PAS" conference:@"COWBY" league:self prestige:60 rivalTeam:@"AMO" state:@"Texas"]];//cowboy.confTeams.add( new Team( "El Paso St", "PAS", "COWBY", this, 60, "AMO" ));
         [cowboy.confTeams addObject:[Team newTeamWithName:@"Texas St" abbreviation:@"TXS" conference:@"COWBY" league:self prestige:60 rivalTeam:@"AUS" state:@"Texas"]];//cowboy.confTeams.add( new Team( "Texas St", "TXS", "COWBY", this, 60, "AUS" ));
         [cowboy.confTeams addObject:[Team newTeamWithName:@"Tulsa" abbreviation:@"TUL" conference:@"COWBY" league:self prestige:55 rivalTeam:@"OKS" state:@"Oklahoma"]];//cowboy.confTeams.add( new Team( "Tulsa", "TUL", "COWBY", this, 55, "OKS" ));
         [cowboy.confTeams addObject:[Team newTeamWithName:@"Univ of Austin" abbreviation:@"AUS" conference:@"COWBY" league:self prestige:50 rivalTeam:@"TXS" state:@"Texas"]];//cowboy.confTeams.add( new Team( "Univ of Austin", "AUS", "COWBY", this, 50, "TXS" ));

         //PACIF
         [pacific.confTeams addObject:[Team newTeamWithName:@"California" abbreviation:@"CAL" conference:@"PACIF" league:self prestige:90 rivalTeam:@"ULA" state:@"California"]];//pacific.confTeams.add( new Team( "California", "CAL", "PACIF", this, 90, "ULA" ));
         [pacific.confTeams addObject:[Team newTeamWithName:@"Oregon" abbreviation:@"ORE" conference:@"PACIF" league:self prestige:85 rivalTeam:@"WAS" state:@"Oregon"]];//pacific.confTeams.add( new Team( "Oregon", "ORE", "PACIF", this, 85, "WAS" ));
         [pacific.confTeams addObject:[Team newTeamWithName:@"Los Angeles" abbreviation:@"ULA" conference:@"PACIF" league:self prestige:80 rivalTeam:@"CAL" state:@"California"]];//pacific.confTeams.add( new Team( "Los Angeles", "ULA", "PACIF", this, 80, "CAL" ));
         [pacific.confTeams addObject:[Team newTeamWithName:@"Oakland St" abbreviation:@"OAK" conference:@"PACIF" league:self prestige:75 rivalTeam:@"HOL" state:@"California"]];//pacific.confTeams.add( new Team( "Oakland St", "OAK", "PACIF", this, 75, "HOL" ));
         [pacific.confTeams addObject:[Team newTeamWithName:@"Washington" abbreviation:@"WAS" conference:@"PACIF" league:self prestige:75 rivalTeam:@"ORE" state:@"Washington"]];//pacific.confTeams.add( new Team( "Washington", "WAS", "PACIF", this, 75, "ORE" ));
         [pacific.confTeams addObject:[Team newTeamWithName:@"Hawaii" abbreviation:@"HAW" conference:@"PACIF" league:self prestige:70 rivalTeam:@"SAM" state:@"Hawaii"]];//pacific.confTeams.add( new Team( "Hawaii", "HAW", "PACIF", this, 70, "SAM" ));
         [pacific.confTeams addObject:[Team newTeamWithName:@"Pullman" abbreviation:@"PUL" conference:@"PACIF" league:self prestige:70 rivalTeam:@"SAN" state:@"Washington"]];//pacific.confTeams.add( new Team( "Seattle", "SEA", "PACIF", this, 70, "SAN" ));
         [pacific.confTeams addObject:[Team newTeamWithName:@"Hollywood St" abbreviation:@"HOL" conference:@"PACIF" league:self prestige:70 rivalTeam:@"OAK" state:@"California"]];//pacific.confTeams.add( new Team( "Hollywood St", "HOL", "PACIF", this, 70, "OAK" ));
         [pacific.confTeams addObject:[Team newTeamWithName:@"San Diego St" abbreviation:@"SAN" conference:@"PACIF" league:self prestige:60 rivalTeam:@"SEA" state:@"California"]];//pacific.confTeams.add( new Team( "San Diego St", "SAN", "PACIF", this, 60, "SEA" ));
         [pacific.confTeams addObject:[Team newTeamWithName:@"American Samoa" abbreviation:@"SAM" conference:@"PACIF" league:self prestige:25 rivalTeam:@"HAW" state:@"American Samoa"]];//pacific.confTeams.add( new Team( "American Samoa", "SAM", "PACIF", this, 25, "HAW" ));

         //MOUNT
         [mountain.confTeams addObject:[Team newTeamWithName:@"Colorado" abbreviation:@"COL" conference:@"MOUNT" league:self prestige:80 rivalTeam:@"DEN" state:@"Colorado"]];//mountain.confTeams.add( new Team( "Colorado", "COL", "MOUNT", this, 80, "DEN" ));
         [mountain.confTeams addObject:[Team newTeamWithName:@"Yellowstone St" abbreviation:@"YEL" conference:@"MOUNT" league:self prestige:75 rivalTeam:@"ALB" state:@"Wyoming"]];//mountain.confTeams.add( new Team( "Yellowstone St", "YEL", "MOUNT", this, 75, "ALB" ));
         [mountain.confTeams addObject:[Team newTeamWithName:@"Utah" abbreviation:@"UTA" conference:@"MOUNT" league:self prestige:75 rivalTeam:@"SAL"  state:@"Utah"]];//mountain.confTeams.add( new Team( "Utah", "UTA", "MOUNT", this, 75, "SAL" ));
         [mountain.confTeams addObject:[Team newTeamWithName:@"Univ of Denver" abbreviation:@"DEN" conference:@"MOUNT" league:self prestige:75 rivalTeam:@"COL" state:@"Colorado"]];//mountain.confTeams.add( new Team( "Univ of Denver", "DEN", "MOUNT", this, 75, "COL" ));
         [mountain.confTeams addObject:[Team newTeamWithName:@"Albuquerque" abbreviation:@"ALB" conference:@"MOUNT" league:self prestige:70 rivalTeam:@"YEL" state:@"New Mexico"]];//mountain.confTeams.add( new Team( "Albuquerque", "ALB", "MOUNT", this, 70, "YEL" ));
         [mountain.confTeams addObject:[Team newTeamWithName:@"Salt Lake St" abbreviation:@"SAL" conference:@"MOUNT" league:self prestige:65 rivalTeam:@"UTA" state:@"Utah"]];//mountain.confTeams.add( new Team( "Salt Lake St", "SAL", "MOUNT", this, 65, "UTA" ));
         [mountain.confTeams addObject:[Team newTeamWithName:@"Wyoming" abbreviation:@"WYO" conference:@"MOUNT" league:self prestige:60 rivalTeam:@"MON" state:@"Wyoming"]];//mountain.confTeams.add( new Team( "Wyoming", "WYO", "MOUNT", this, 60, "MON" ));
         [mountain.confTeams addObject:[Team newTeamWithName:@"Montana" abbreviation:@"MON" conference:@"MOUNT" league:self prestige:55 rivalTeam:@"WYO" state:@"Montana"]];//mountain.confTeams.add( new Team( "Montana", "MON", "MOUNT", this, 55, "WYO" ));
         [mountain.confTeams addObject:[Team newTeamWithName:@"Las Vegas" abbreviation:@"LSV" conference:@"MOUNT" league:self prestige:50 rivalTeam:@"PHO" state:@"Nevada"]];//mountain.confTeams.add( new Team( "Las Vegas", "LSV", "MOUNT", this, 50, "PHO" ));
         [mountain.confTeams addObject:[Team newTeamWithName:@"Phoenix" abbreviation:@"PHO" conference:@"MOUNT" league:self prestige:45 rivalTeam:@"LSV" state:@"Arizona"]];//mountain.confTeams.add( new Team( "Phoenix", "PHO", "MOUNT", this, 45, "LSV" ));


        teamList = [NSMutableArray array];
        for (int i = 0; i < conferences.count; ++i ) {
            for (int j = 0; j < [[conferences[i] confTeams] count]; j++ ) {
                [teamList addObject:[conferences[i] confTeams][j]];
            }
        }

        //set up schedule
        for (int i = 0; i < conferences.count; ++i ) {
            [conferences[i] setUpSchedule];
        }
        for (int i = 0; i < conferences.count; ++i ) {
            [conferences[i] setUpOOCSchedule];
        }
        for (int i = 0; i < conferences.count; ++i ) {
            [conferences[i] insertOOCSchedule];
        }
    }
    return self;
}

-(void)playWeek {
    canRebrandTeam = NO;

    if (currentWeek <= 12 ) {
        for (int i = 0; i < conferences.count; ++i) {
            [conferences[i] playWeek];
        }


        // bless/curse progression updates should appear at week 6 (news stories index 6)
        //if blessed team wins > losses - post story about reaping benefits from blessing, otherwise, post story about them fumbling with it
        //if cursed team wins > losses - post story about success despite early season setbacks, otherwise, post story about how early setback has crippled team this season
        if (currentWeek == 5) {
            NSMutableArray *newsWeek = newsStories[6];
            if (blessedTeam != nil && ![blessedTeam isEqual:userTeam]) {
                NSLog(@"BLESSED TEAM: %@ STORY: %ld COACH: %@", blessedTeam.abbreviation, (long)blessedStoryIndex, blessedTeamCoachName);
                if (blessedTeam.wins > blessedTeam.losses) {
                    switch (blessedStoryIndex) {
                        case 1: //new coach
                            [newsWeek addObject:[NSString stringWithFormat:@"%@'s (%ld-%ld) new hire making an impact early\nEarly on, it looks like %@'s unorthodox approach has created success at previously down-on-its-luck %@.",blessedTeam.abbreviation,(long)blessedTeam.wins, (long)blessedTeam.losses,blessedTeamCoachName, blessedTeam.name]];
                            break;
                        case 3: //gatorade
                            [newsWeek addObject:[NSString stringWithFormat:@"%@'s new sports drink powering them to victory\nThe drink, developed last offseason, has spawned a revolution in the locker room at %@ (%ld-%ld), improving the team's play and conditioning.", blessedTeam.abbreviation, blessedTeam.name, (long)blessedTeam.wins, (long)blessedTeam.losses]];
                            break;
                        default:
                            break;
                    }
                } else {
                    switch (blessedStoryIndex) {
                        case 1: //new coach
                            [newsWeek addObject:[NSString stringWithFormat:@"%@'s (%ld-%ld) new hire faltering early\n%@'s unorthodox approach has failed to take hold at %@, leaving the team floundering under .500.",blessedTeam.abbreviation, (long)blessedTeam.wins, (long)blessedTeam.losses,blessedTeamCoachName,blessedTeam.name]];
                            break;
                        case 3: //gatorade
                            [newsWeek addObject:[NSString stringWithFormat:@"%@'s new sports drink flops\nThe drink, developed last offseason, was supposed to improve player hydration and conditioning at %@ (%ld-%ld), yet it has failed to make meaningful improvements early on this season.", blessedTeam.abbreviation,blessedTeam.name, (long)blessedTeam.wins, (long)blessedTeam.losses]];
                            break;
                        default:
                            break;
                    }
                }
            }

            if (cursedTeam != nil && ![cursedTeam isEqual:userTeam]) {
                NSLog(@"CURSED TEAM: %@ STORY: %ld COACH: %@", cursedTeam.abbreviation, (long)cursedStoryIndex, cursedTeamCoachName);
                if (cursedTeam.wins > cursedTeam.losses) {
                    switch (cursedStoryIndex) {
                        case 1: //recruiting sanctions
                            [newsWeek addObject:[NSString stringWithFormat:@"%@ successful despite sanctions\n%@'s (%ld-%ld) limited recruiting ability has not hindered them yet, as the team has fought its way to success early on this season.",cursedTeam.abbreviation,cursedTeam.name, (long)cursedTeam.wins, (long)cursedTeam.losses]];
                            break;
                        case 3: //suspended coach
                            [newsWeek addObject:[NSString stringWithFormat:@"%@'s coach returns from suspension to an improved team\n%@ (%ld-%ld) gets back head coach %@ this week, and he comes back to a team playing well early on this season.", cursedTeam.abbreviation, cursedTeam.name, (long)cursedTeam.wins, (long)cursedTeam.losses, cursedTeamCoachName]];
                            break;
                        case 5: //recruiting sanctions
                            [newsWeek addObject:[NSString stringWithFormat:@"%@ successful despite sanctions\n%@'s (%ld-%ld) limited recruiting ability has not hindered them yet, as the team has fought its way to success early on this season.",cursedTeam.abbreviation,cursedTeam.name, (long)cursedTeam.wins, (long)cursedTeam.losses]];
                            break;
                        default:
                            break;
                    }
                } else {
                    switch (cursedStoryIndex) {
                        case 1: //recruiting sanctions
                            [newsWeek addObject:[NSString stringWithFormat:@"%@'s demons haunt them\n%@'s (%ld-%ld) limited recruiting ability has manifested itself in a sub-.500 season early on.",cursedTeam.abbreviation,cursedTeam.name, (long)cursedTeam.wins, (long)cursedTeam.losses]];
                            break;
                        case 3: //suspended coach
                            [newsWeek addObject:[NSString stringWithFormat:@"%@'s coach returns from suspension\n%@ (%ld-%ld) gets back head coach %@ this week, and he has his work cut out for him as the team has stumbled early on this year.", cursedTeam.abbreviation, cursedTeam.name, (long)cursedTeam.wins, (long)cursedTeam.losses, cursedTeamCoachName]];
                            break;
                        case 5: //recruiting sanctions
                            [newsWeek addObject:[NSString stringWithFormat:@"%@'s demons haunt them\n%@'s (%ld-%ld) limited recruiting ability has manifested itself in a sub-.500 season early on.",cursedTeam.abbreviation,cursedTeam.name, (long)cursedTeam.wins, (long)cursedTeam.losses]];
                            break;
                        default:
                            break;
                    }
                }
            }
        }

        //calculate poty leader and post story about how he is leading competition
        if (currentWeek == 9) {
            NSMutableArray *week11 = newsStories[10];

            NSArray *heismanContenders = [self getHeismanLeaders];
            Player *heismanLeader = heismanContenders[0];
            [week11 addObject:[NSString stringWithFormat:@"%@'s %@ leads the pack\n%@ %@ %@ is the frontrunner for Player of the Year, playing a key role in the team's %ld-%ld season.", heismanLeader.team.abbreviation, [heismanLeader getInitialName], heismanLeader.team.name, heismanLeader.position, heismanLeader.name, (long)heismanLeader.team.wins, (long)heismanLeader.team.losses]];

            NSArray *rotyContenders = [self getROTYLeaders];
            Player *rotyLeader = rotyContenders[0];
            [week11 addObject:[NSString stringWithFormat:@"%@'s %@ leads the rookies\n%@ %@ %@ is the frontrunner for Rookie of the Year, playing a key role in the team's %ld-%ld season.", rotyLeader.team.abbreviation, [rotyLeader getInitialName], rotyLeader.team.name, rotyLeader.position, rotyLeader.name, (long)rotyLeader.team.wins, (long)rotyLeader.team.losses]];
        }
    }

    if (currentWeek == 12) {
        //bowl week
        for (int i = 0; i < teamList.count; ++i) {
            [teamList[i] updatePollScore];
        }

        teamList = [[teamList sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            Team *a = (Team*)obj1;
            Team *b = (Team*)obj2;
            return a.teamPollScore > b.teamPollScore ? -1 : a.teamPollScore == b.teamPollScore ? 0 : 1;

        }] mutableCopy];

        [self scheduleBowlGames];
    } else if (currentWeek == 13 ) {
        [self playBowlGames];

    } else if (currentWeek == 14 ) {

        [ncg playGame];
        if (ncg.homeScore > ncg.awayScore ) {
            //ncg.homeTeam.semifinalWL = @"";
            //ncg.awayTeam.semifinalWL = @"";
            ncg.homeTeam.natlChampWL = @"NCW";
            ncg.awayTeam.natlChampWL = @"NCL";
            ncg.homeTeam.totalNCs++;
            [ncg.homeTeam getCurrentHC].totalNCs++;
            ncg.awayTeam.totalNCLosses++;
            [ncg.awayTeam getCurrentHC].totalNCLosses++;
            NSMutableArray *week15 = newsStories[15];
            [week15 addObject:[NSString stringWithFormat:@"%@ wins the National Championship!\n%@ defeats %@ in the national championship game %ld to %ld. Congratulations %@!", ncg.homeTeam.name, [ncg.homeTeam strRep], [ncg.awayTeam strRep], (long)ncg.homeScore, (long)ncg.awayScore, ncg.homeTeam.name]];

        } else {
            //ncg.homeTeam.semifinalWL = @"";
            //ncg.awayTeam.semifinalWL = @"";
            ncg.awayTeam.natlChampWL = @"NCW";
            ncg.homeTeam.natlChampWL = @"NCL";
            ncg.awayTeam.totalNCs++;
            [ncg.awayTeam getCurrentHC].totalNCs++;
            ncg.homeTeam.totalNCLosses++;
            [ncg.homeTeam getCurrentHC].totalNCLosses++;
            NSMutableArray *week15 = newsStories[15];
            [week15 addObject:[NSString stringWithFormat:@"%@ wins the National Championship!\n%@ defeats %@ in the national championship game %ld to %ld. Congratulations %@!", ncg.awayTeam.name, [ncg.awayTeam strRep], [ncg.homeTeam strRep], (long)ncg.awayScore, (long)ncg.homeScore, ncg.awayTeam.name]];
        }

        [self refreshAllLeaguePlayers];
        for (Conference *c in conferences) {
            [c refreshAllConferencePlayers];
        }
        [self completeProDraft];
        canRebrandTeam = YES;
    }
    [self generateCFPNews];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"newNewsStory" object:nil];



    [self setTeamRanks];
    currentWeek++;
}

-(void)generateCFPNews {
    [self setTeamRanks];
    NSArray<Team*> *teams = [teamList sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [HBSharedUtils comparePollScore:obj1 toObj2:obj2];
    }];

    if (currentWeek == 8) {
        [newsStories[9] addObject:[NSString stringWithFormat:@"Committee Announces First Playoff Rankings\nThe Playoff Committee has released its first rankings for this season's playoff. At the top of the list is %@, with %@, %@, and %@ rounding out the top 4.", teams[0].name, teams[1].name, teams[2].name, teams[3].name]];
    } else if (currentWeek > 8 && currentWeek < 12) {
        [newsStories[currentWeek + 1] addObject:[NSString stringWithFormat:@"Committee Releases Playoff Rankings after Week %lu\nThe Playoff Committee has updated its rankings after last week's games. At the top of the list is %@, with %@, %@, and %@ rounding out the top 4.", (long)currentWeek,teams[0].name, teams[1].name, teams[2].name, teams[3].name]];
    }
}


-(void)scheduleBowlGames {
    //bowl week
    for (int i = 0; i < teamList.count; ++i) {
        [teamList[i] updatePollScore];
    }

    teamList = [[teamList sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Team *a = (Team*)obj1;
        Team *b = (Team*)obj2;
        return a.teamPollScore > b.teamPollScore ? -1 : a.teamPollScore == b.teamPollScore ? 0 : 1;

    }] mutableCopy];

    //semifinals
    semiG14 = [Game newGameWithHome:teamList[0] away:teamList[3] name:@"Semis, 1v4"];
    [[teamList[0] gameSchedule] addObject:semiG14];
    [[teamList[3] gameSchedule] addObject:semiG14];

    semiG23 = [Game newGameWithHome:teamList[1] away:teamList[2] name:@"Semis, 2v3"];
    [[teamList[1] gameSchedule] addObject:semiG23];
    [[teamList[2] gameSchedule] addObject:semiG23];

    // announce semifinal scheduling
    [newsStories[currentWeek + 1] addObject:[NSString stringWithFormat:@"Playoff Teams Announced!\n%@ will travel to %@ and %@ will host %@ to determine which two teams will play for the national championship!", [teamList[3] strRep], [teamList[0] strRep], [teamList[1] strRep], [teamList[2] strRep]]];

    //other bowls
    NSMutableArray *bowlEligibleTeams = [NSMutableArray array];
    for (int i = 4; i < ([self bowlGameTitles].count * 2); i++) {
        [bowlEligibleTeams addObject:teamList[i]];
    }

    [bowlGames removeAllObjects];
    int j = 0;
    int teamIndex = 0;
    while (j < [self bowlGameTitles].count && teamIndex < bowlEligibleTeams.count) {
        NSString *bowlName = [self bowlGameTitles][j];
        Team *home = bowlEligibleTeams[teamIndex];
        Team *away = bowlEligibleTeams[teamIndex + 1];
        Game *bowl = [Game newGameWithHome:home away:away name:bowlName];
        [bowlGames addObject:bowl];
        [home.gameSchedule addObject:bowl];
        [away.gameSchedule addObject:bowl];
        j++;
        teamIndex+=2;

        // announce bowl scheduling
        [newsStories[currentWeek + 1] addObject:[NSString stringWithFormat:@"%@ Selection Announced!\n%@ will host %@ in the %@ next week!",bowlName, [home strRep], [away strRep], bowlName]];
    }

    hasScheduledBowls = true;

}

-(void)playBowlGames {
    NSMutableArray *bowlNews = newsStories[14];
    [bowlNews removeAllObjects];

    for (Game *g in bowlGames) {
        [self playBowl:g];
    }

    [semiG14 playGame];
    [semiG23 playGame];
    Team *semi14winner;
    Team *semi23winner;
    if (semiG14.homeScore > semiG14.awayScore ) {
        semiG14.homeTeam.semifinalWL = @"SFW";
        semiG14.homeTeam.totalBowls++;
        [semiG14.homeTeam getCurrentHC].totalBowls++;
        semiG14.awayTeam.semifinalWL = @"SFL";
        semiG14.awayTeam.totalBowlLosses++;
        [semiG14.awayTeam getCurrentHC].totalBowlLosses++;
        semi14winner = semiG14.homeTeam;
        //newsStories.get(14).add(semiG14.homeTeam.name + " wins the " + semiG14.gameName +"!\n" + semiG14.homeTeam.strRep() + " defeats " + semiG14.awayTeam.strRep() + " in the semifinals, winning " + semiG14.homeScore + " to " + semiG14.awayScore + ". " + semiG14.homeTeam.name + " advances to the National Championship!" );
        NSMutableArray *week14 = newsStories[14];
        [week14 addObject:[NSString stringWithFormat:@"%@ wins the %@!\n%@ defeats %@ in the semifinals, winning %ld to %ld. %@ advances to the National Championship!",semiG14.homeTeam.name, semiG14.gameName, semiG14.homeTeam.strRep, semiG14.awayTeam.strRep, (long)semiG14.homeScore, (long)semiG14.awayScore, semiG14.homeTeam.name]];

    } else {
        semiG14.homeTeam.semifinalWL = @"SFL";
        semiG14.homeTeam.totalBowlLosses++;
        [semiG14.homeTeam getCurrentHC].totalBowlLosses++;
        semiG14.awayTeam.semifinalWL = @"SFW";
        semiG14.awayTeam.totalBowls++;
        [semiG14.awayTeam getCurrentHC].totalBowls++;
        semi14winner = semiG14.awayTeam;
        NSMutableArray *week14 = newsStories[14];
        [week14 addObject:[NSString stringWithFormat:@"%@ wins the %@!\n%@ defeats %@ in the semifinals, winning %ld to %ld. %@ advances to the National Championship!",semiG14.awayTeam.name, semiG14.gameName, semiG14.awayTeam.strRep, semiG14.homeTeam.strRep, (long)semiG14.awayScore, (long)semiG14.homeScore, semiG14.awayTeam.name]];
    }

    if (semiG23.homeScore > semiG23.awayScore ) {
        semiG23.homeTeam.semifinalWL = @"SFW";
        semiG23.homeTeam.totalBowls++;
        [semiG23.homeTeam getCurrentHC].totalBowls++;
        semiG23.awayTeam.semifinalWL = @"SFL";
        semiG23.awayTeam.totalBowlLosses++;
        [semiG23.awayTeam getCurrentHC].totalBowlLosses++;
        semi23winner = semiG23.homeTeam;
        //newsStories.get(14).add(semiG14.homeTeam.name + " wins the " + semiG14.gameName +"!\n" + semiG14.homeTeam.strRep() + " defeats " + semiG14.awayTeam.strRep() + " in the semifinals, winning " + semiG14.homeScore + " to " + semiG14.awayScore + ". " + semiG14.homeTeam.name + " advances to the National Championship!" );
        NSMutableArray *week14 = newsStories[14];
        [week14 addObject:[NSString stringWithFormat:@"%@ wins the %@!\n%@ defeats %@ in the semifinals, winning %ld to %ld. %@ advances to the National Championship!",semiG23.homeTeam.name, semiG23.gameName, semiG23.homeTeam.strRep, semiG23.awayTeam.strRep, (long)semiG23.homeScore, (long)semiG23.awayScore, semiG23.homeTeam.name]];

    } else {
        semiG23.homeTeam.semifinalWL = @"SFL";
        semiG23.homeTeam.totalBowlLosses++;
        [semiG23.homeTeam getCurrentHC].totalBowlLosses++;
        semiG23.awayTeam.semifinalWL = @"SFW";
        semiG23.awayTeam.totalBowls++;
        [semiG23.awayTeam getCurrentHC].totalBowls++;
        semi23winner = semiG23.awayTeam;
        NSMutableArray *week14 = newsStories[14];
        [week14 addObject:[NSString stringWithFormat:@"%@ wins the %@!\n%@ defeats %@ in the semifinals, winning %ld to %ld. %@ advances to the National Championship!",semiG23.awayTeam.name, semiG23.gameName, semiG23.awayTeam.strRep, semiG23.homeTeam.strRep, (long)semiG23.awayScore, (long)semiG23.homeScore, semiG23.awayTeam.name]];

    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"newNewsStory" object:nil];

    //schedule NCG
    ncg = [Game newGameWithHome:semi14winner away:semi23winner name:@"NCG"];
    [semi14winner.gameSchedule addObject:ncg];
    [semi23winner.gameSchedule addObject:ncg];

}

-(void)playBowl:(Game*)g {
    [g playGame];
    if (g.homeScore > g.awayScore ) {
        g.homeTeam.semifinalWL = @"BW";
        g.homeTeam.totalBowls++;
        [g.homeTeam getCurrentHC].totalBowls++;
        g.awayTeam.semifinalWL = @"BL";
        g.awayTeam.totalBowlLosses++;
        [g.awayTeam getCurrentHC].totalBowlLosses++;
        NSMutableArray *week14 = newsStories[14];
        [week14 addObject:[NSString stringWithFormat:@"%@ wins the %@!\n%@ defeats %@ in the %@, winning %d to %d.",g.homeTeam.name, g.gameName, g.homeTeam.strRep, g.awayTeam.strRep, g.gameName, g.homeScore, g.awayScore]];

    } else {
        g.homeTeam.semifinalWL = @"BL";
        g.homeTeam.totalBowlLosses++;
        [g.homeTeam getCurrentHC].totalBowlLosses++;
        g.awayTeam.semifinalWL = @"BW";
        g.awayTeam.totalBowls++;
        [g.awayTeam getCurrentHC].totalBowls++;
        NSMutableArray *week14 = newsStories[14];
        [week14 addObject:[NSString stringWithFormat:@"%@ wins the %@!\n%@ defeats %@ in the %@, winning %d to %d.",g.awayTeam.name, g.gameName, g.awayTeam.strRep, g.homeTeam.strRep, g.gameName, g.awayScore, g.homeScore]];
    }
     [[NSNotificationCenter defaultCenter] postNotificationName:@"newNewsStory" object:nil];
}

-(void)updateLeagueHistory {

    [self getHeismanCeremonyStr];
    [heismanHistoryDictionary setObject:[NSString stringWithFormat:@"%@ %@ [%@], %@ (%ld-%ld)",heisman.position,heisman.getInitialName,heisman.getYearString,heisman.team.abbreviation,(long)heisman.team.wins,(long)heisman.team.losses] forKey:[NSString stringWithFormat:@"%ld",(long)([HBSharedUtils currentLeague].baseYear + leagueHistoryDictionary.count)]];

    [self getROTYCeremonyStr];
    if (rotyHistoryDictionary == nil) {
        rotyHistoryDictionary = [NSMutableDictionary dictionary];
    }
    [rotyHistoryDictionary setObject:[NSString stringWithFormat:@"%@ %@ [%@], %@ (%ld-%ld)",roty.position,roty.getInitialName,roty.getYearString,roty.team.abbreviation,(long)roty.team.wins,(long)roty.team.losses] forKey:[NSString stringWithFormat:@"%ld",(long)([HBSharedUtils currentLeague].baseYear + leagueHistoryDictionary.count)]];

    //update league history
    teamList = [[teamList sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
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
        tt = teamList[i];
        [yearTop10  addObject:[NSString stringWithFormat:@"%@ (%ld-%ld)",tt.abbreviation, (long)tt.wins, (long)tt.losses]];
    }
    [leagueHistoryDictionary setObject:yearTop10 forKey:[NSString stringWithFormat:@"%ld",(long)([HBSharedUtils currentLeague].baseYear + leagueHistoryDictionary.count)]];
}

-(NSString*)randomBlessedTeamStory:(Team*)t {
    blessedTeamCoachName = [t getCurrentHC].name;
   NSArray *stories = @[
                         [NSString stringWithFormat:@"%@ gets new digs!\nAn anonymous benefactor has completely covered the cost of new training facilities for %@, resulting in large scale improvements to the program's infrastructure.",t.abbreviation,t.name],
                         [NSString stringWithFormat:@"%@ makes a big splash at head coach!\n%@ has hired alumnus and professional football coach %@ in hopes of revitalizing the program.", t.abbreviation, t.name, blessedTeamCoachName],
                         [NSString stringWithFormat:@"%@ hires new AD!\n%@ has hired alumnus %@ as athletic director, who has pledged to invest more in the school's football program.", t.abbreviation, t.name, [self getRandName]],
                         [NSString stringWithFormat:@"New drink fuels %@!\nA new recovery drink developed by the science department at %@ has been a hit at offseason practice. The players are singing its praises and coming out of this offseason better than ever.", t.abbreviation, t.name],
                         [NSString stringWithFormat:@"%@ gets a fresh coat of paint!\nAfter starting a successful athletic apparel company, one of %@'s alumni proclaims that the team will never have to play another game with the same uniform combination.",t.abbreviation,t.name],
                         [NSString stringWithFormat:@"%@ improving in the classroom!\n%@ has seen a dramatic increase in their academic performance over the past couple of years. Recruits have taken notice and are showing more interest in attending a school with high academic integrity.",t.abbreviation,t.name]
                         ];
    blessedStoryIndex = ([HBSharedUtils randomValue] * stories.count);
    return stories[blessedStoryIndex];
}

-(NSString*)randomCursedTeamStory:(Team*)t {
    cursedTeamCoachName = [t getCurrentHC].name;
    NSArray *stories = @[
                         [NSString stringWithFormat:@"League hits %@ with sanctions!\n%@ hit with two-year probation after league investigation finds program committed minor infractions.",t.abbreviation,t.name],
                         [NSString stringWithFormat:@"Scandal at %@!\n%@ puts itself on a 3-year probation after school self-reports dozens of recruiting violations.",t.abbreviation,t.name],
                         [NSString stringWithFormat:@"%@ head coach in hot water!\nAfter a scandal involving a sleepover at a prospect's home, %@'s head coach %@ has been suspended. No charges have been filed, but it is safe to say he won't be having any more pajama parties any time soon.", t.abbreviation, t.name, cursedTeamCoachName],
                         [NSString stringWithFormat:@"%@ won the College Basketball National Championship\nReporters everywhere are now wondering if %@ has lost its emphasis on football.", t.abbreviation,t.name],
                         [NSString stringWithFormat:@"%@ didn't come to play school\n%@'s reputation takes a hit after news surfaced that the university falsified grades for student-athletes in order to retain their athletic eligibility. Recruits are leery of being associated with such a program.",t.abbreviation,t.name]
                         ];
    cursedStoryIndex = ([HBSharedUtils randomValue] * stories.count);
    if (isHardMode && [cursedTeam isEqual:userTeam]) {
        while (cursedStoryIndex == 2) {
            cursedStoryIndex = ([HBSharedUtils randomValue] * stories.count);
        }
    }
    return stories[cursedStoryIndex];
}


-(void)advanceSeason {
    currentWeek = 0;
    ncg = nil;
    heisman = nil;
    heismanWinnerStrFull = nil;

    rotyWinnerStrFull = nil;
    roty = nil;
    rotyFinalists = [NSMutableArray array];
    rotyCandidates = [NSMutableArray array];
    rotyDecided = NO;

    didFinishTransferPeriod = NO;
    transferList = nil;

    // Bless a random team with lots of prestige
    int blessNumber = (int)([HBSharedUtils randomValue]*9);
    Team *blessTeam = teamList[50 + blessNumber];
    while ([blessTeam isEqual:userTeam] || [blessTeam isEqual:blessedTeam] || [blessTeam isEqual:cursedTeam]) {
        blessNumber = (int)([HBSharedUtils randomValue]*9);
        blessTeam = teamList[50 + blessNumber];
    }

    if (!blessTeam.isUserControlled && ![blessTeam.name isEqualToString:@"American Samoa"]) {
        blessTeam.teamPrestige += 30;
        blessedTeam = blessTeam;
        if (blessTeam.teamPrestige > 90) blessTeam.teamPrestige = 90;
    }

    //Curse a good team
    int curseNumber = (int)([HBSharedUtils randomValue]*7);
    Team *curseTeam = teamList[3 + curseNumber];
    if (!isHardMode) {
        while ([curseTeam isEqual:userTeam] || [curseTeam isEqual:blessedTeam] || [curseTeam isEqual:cursedTeam]) {
            curseNumber = (int)([HBSharedUtils randomValue]*7);
            curseTeam = teamList[3 + curseNumber];
        }

        if (!curseTeam.isUserControlled) {
            curseTeam.teamPrestige -= 20;
            cursedTeam = curseTeam;
        }
    } else {
        while ([curseTeam isEqual:blessedTeam] || [curseTeam isEqual:cursedTeam]) {
            curseNumber = (int)([HBSharedUtils randomValue]*7);
            curseTeam = teamList[3 + curseNumber];
        }

        if (curseTeam.teamPrestige > 85) {
            curseTeam.teamPrestige -= 20;
            if ([curseTeam.name isEqualToString:@"American Samoa"]) {
                curseTeam.teamPrestige = MAX(0, curseTeam.teamPrestige);
            } else {
                curseTeam.teamPrestige = MAX(25, curseTeam.teamPrestige);
            }
            cursedTeam = curseTeam;
        }
    }

    [self updateHallOfFame];
    for (int t = 0; t < teamList.count; ++t) {
        [teamList[t] updateRingOfHonor];
        [teamList[t] advanceSeason];
    }
    for (int c = 0; c < conferences.count; ++c) {
        conferences[c].robinWeek = 0;
        conferences[c].week = 0;
        conferences[c].ccg = nil;
    }
    //set up schedule
    for (int i = 0; i < conferences.count; ++i ) {
        [conferences[i] setUpSchedule];
    }
    for (int i = 0; i < conferences.count; ++i ) {
        [conferences[i] setUpOOCSchedule];
    }
    for (int i = 0; i < conferences.count; ++i ) {
        [conferences[i] insertOOCSchedule];
    }

    hasScheduledBowls = false;
    heismanDecided = NO;
    [bowlGames removeAllObjects];

    for (NSMutableArray *week in newsStories) {
        [week removeAllObjects];
    }

    if (blessedTeam) {
        NSMutableArray *week0 = newsStories[0];
        [week0 addObject:[self randomBlessedTeamStory:blessedTeam]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"newNewsStory" object:nil];
    }

    if (cursedTeam) {
        NSMutableArray *week0 = newsStories[0];
        [week0 addObject:[self randomCursedTeamStory:cursedTeam]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"newNewsStory" object:nil];
    }

    [self setTeamRanks];
}

-(void)updateTeamHistories {
    for (int i = 0; i < teamList.count; ++i) {
        [teamList[i] updateTeamHistory];
    }
}

-(void)updateTeamTalentRatings {
    for (Team *t in teamList) {
        [t updateTalentRatings];
    }
}

-(NSString*)getRandName {
    int fn = (int)([HBSharedUtils randomValue] * nameList.count);
    int ln = (int)([HBSharedUtils randomValue] * lastNameList.count);
    return [NSString stringWithFormat:@"%@ %@",[nameList[fn] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]],[lastNameList[ln] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
}

-(NSArray<Player*>*)calculateHeismanCandidates {
    if (!heismanDecided && currentWeek < 13) {
        if (heisman) {
            heisman.isHeisman = NO;
            heisman = nil;
        }
        int heismanScore = 0;
        int tempScore = 0;
        if (heismanCandidates != nil) {
            [heismanCandidates removeAllObjects];
        } else {
            heismanCandidates = [NSMutableArray array];
        }
        for ( int i = 0; i < teamList.count; ++i ) {
            //qb
            if (teamList[i].teamQBs.count > 0) {
                PlayerQB *qb = teamList[i].teamQBs[0];
                if (![heismanCandidates containsObject:qb]) {
                    [heismanCandidates addObject:qb];
                }
                tempScore = [qb getHeismanScore] + teamList[i].wins*150;
                if ( tempScore > heismanScore ) {
                    heisman = qb;
                    heismanScore = tempScore;
                }
            }

            //rb
            if (teamList[i].teamRBs.count > 1) {
                for (int rb = 0; rb < 2; ++rb) {
                    Player *rback = teamList[i].teamRBs[rb];
                    if (![heismanCandidates containsObject:rback]) {
                        [heismanCandidates addObject:rback];
                    }
                    tempScore = [rback getHeismanScore] + teamList[i].wins*150;
                    if ( tempScore > heismanScore ) {
                        heisman = rback;
                        heismanScore = tempScore;
                    }
                }
            }

            //wr
            if (teamList[i].teamWRs.count > 2) {
                for (int wr = 0; wr < 3; ++wr) {
                    PlayerWR *wrec = teamList[i].teamWRs[wr];
                    if (![heismanCandidates containsObject:wrec]) {
                        [heismanCandidates addObject:wrec];
                    }
                    tempScore = [wrec getHeismanScore] + teamList[i].wins*150;
                    if ( tempScore > heismanScore ) {
                        heisman = wrec;
                        heismanScore = tempScore;
                    }
                }
            }

            //te
            if (teamList[i].teamTEs.count > 1) {
                PlayerTE *wrec = teamList[i].teamTEs[0];
                if (![heismanCandidates containsObject:wrec]) {
                    [heismanCandidates addObject:wrec];
                }
                tempScore = [wrec getHeismanScore] + teamList[i].wins*150;
                if ( tempScore > heismanScore ) {
                    heisman = wrec;
                    heismanScore = tempScore;
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
    if (!heismanDecided || !heismanFinalists) {
        NSMutableArray *tempHeis = [NSMutableArray array];
        NSArray *candidates = [self calculateHeismanCandidates];
        int i = 0;
        while (tempHeis.count < 5 && i < candidates.count) {
            Player *p = candidates[i];
            if (p != nil && ![tempHeis containsObject:p]) {
                [tempHeis addObject:p];
            }

            i++;
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
        return [heismanFinalists copy];
    }
}

-(NSString*)getHeismanCeremonyStr {
    if (heisman != nil && heismanWinnerStrFull != nil && heismanWinnerStrFull.length != 0) {
        heisman.isHeisman = YES;
        return heismanWinnerStrFull;
    } else {
        BOOL putNewsStory = false;

        heismanCandidates = [[self calculateHeismanCandidates] mutableCopy];
        heisman = heismanCandidates[0];
        heismanDecided = true;
        putNewsStory = true;

        NSString* heismanTop5 = @"\n";
        NSMutableString* heismanStats = [NSMutableString string];
        NSString* heismanWinnerStr = @"";
        heismanFinalists = [NSMutableArray array];
        //full results string
        int i = 0;
        int place = 1;
        while (heismanFinalists.count < 5 && i < heismanCandidates.count) {
            Player *p = heismanCandidates[i];
            heismanTop5 = [heismanTop5 stringByAppendingString:[NSString stringWithFormat:@"%d. %@ (%ld-%ld) - ",place,p.team.abbreviation,(long)p.team.wins,(long)p.team.losses]];
            if ([p isKindOfClass:[PlayerQB class]]) {
                PlayerQB *pqb = (PlayerQB*)p;
                heismanTop5 = [heismanTop5 stringByAppendingString:[NSString stringWithFormat:@" QB %@: %ld votes\n\t(%ld TDs, %ld Int, %ld Yds)\n",[pqb getInitialName],(long)[pqb getHeismanScore],(long)pqb.statsTD,(long)pqb.statsInt,(long)pqb.statsPassYards]];
            } else if ([p isKindOfClass:[PlayerRB class]]) {
                PlayerRB *prb = (PlayerRB*)p;
                heismanTop5 = [heismanTop5 stringByAppendingString:[NSString stringWithFormat:@" RB %@: %ld votes\n\t(%ld TDs, %ld Fum, %ld Yds)\n",[prb getInitialName],(long)[prb getHeismanScore],(long)prb.statsTD,(long)prb.statsFumbles,(long)prb.statsRushYards]];
            } else if ([p isKindOfClass:[PlayerTE class]]) {
                PlayerTE *pwr = (PlayerTE*)p;
                heismanTop5 = [heismanTop5 stringByAppendingString:[NSString stringWithFormat:@" TE %@: %ld votes\n\t(%ld TDs, %ld Fum, %ld Yds)\n",[pwr getInitialName],(long)[pwr getHeismanScore],(long)pwr.statsTD,(long)pwr.statsFumbles,(long)pwr.statsRecYards]];
            } else if ([p isKindOfClass:[PlayerWR class]]) {
                PlayerWR *pwr = (PlayerWR*)p;
                heismanTop5 = [heismanTop5 stringByAppendingString:[NSString stringWithFormat:@" WR %@: %ld votes\n\t(%ld TDs, %ld Fum, %ld Yds)\n",[pwr getInitialName],(long)[pwr getHeismanScore],(long)pwr.statsTD,(long)pwr.statsFumbles,(long)pwr.statsRecYards]];
            }
            if (p != nil && ![heismanFinalists containsObject:p]) {
                [heismanFinalists addObject:p];
                place++;
            }
            i++;
        }

        heisman.team.heismans++;
        heisman.careerHeismans++;
        heisman.isHeisman = YES;
        if ([heisman isKindOfClass:[PlayerQB class]]) {
            //qb heisman
            PlayerQB *heisQB = (PlayerQB*)heisman;
            if (heisQB.statsInt > 1 || heisQB.statsInt == 0) {
                heismanWinnerStr = [NSString stringWithFormat:@"%ld's POTY: %@ QB %@!\n?Congratulations to %@ QB %@ [%@], who had %ld TDs, %ld interceptions, and %ld passing yards and led %@ to a %ld-%ld record and a #%ld poll ranking.",(long)([HBSharedUtils currentLeague].baseYear + self.leagueHistoryDictionary.count), heisQB.team.abbreviation, [heisQB getInitialName],heisQB.team.abbreviation, heisQB.name, [heisman getYearString], (long)heisQB.statsTD, (long)heisQB.statsInt, (long)heisQB.statsPassYards, heisQB.team.name, (long)heisQB.team.wins,(long)heisQB.team.losses,(long)heisQB.team.rankTeamPollScore];
            } else {
                heismanWinnerStr = [NSString stringWithFormat:@"%ld's POTY: %@ QB %@!\n?Congratulations to %@ QB %@ [%@], who had %ld TDs, %ld interception, and %ld passing yards and led %@ to a %ld-%ld record and a #%ld poll ranking.",(long)([HBSharedUtils currentLeague].baseYear + self.leagueHistoryDictionary.count), heisQB.team.abbreviation, [heisQB getInitialName],heisQB.team.abbreviation, heisQB.name, [heisman getYearString], (long)heisQB.statsTD, (long)heisQB.statsInt, (long)heisQB.statsPassYards, heisQB.team.name, (long)heisQB.team.wins,(long)heisQB.team.losses,(long)heisQB.team.rankTeamPollScore];
            }

            [heismanStats appendString:[NSString stringWithFormat:@"%@\n\nFull Results: %@",heismanWinnerStr, heismanTop5]];
        } else if ([heisman isKindOfClass:[PlayerRB class]]) {
            //rb heisman
            PlayerRB *heisRB = (PlayerRB*)heisman;
            if (heisRB.statsFumbles > 1 || heisRB.statsFumbles == 0) {
                heismanWinnerStr = [NSString stringWithFormat:@"%ld's POTY: %@ RB %@!\n?Congratulations to %@ RB %@ [%@], who had %ld TDs, %ld fumbles, and %ld rushing yards and led %@ to a %ld-%ld record and a #%ld poll ranking.",(long)([HBSharedUtils currentLeague].baseYear + self.leagueHistoryDictionary.count), heisRB.team.abbreviation, [heisRB getInitialName], heisRB.team.abbreviation, heisRB.name, [heisman getYearString], (long)heisRB.statsTD, (long)heisRB.statsFumbles, (long)heisRB.statsRushYards, heisRB.team.name, (long)heisRB.team.wins,(long)heisRB.team.losses,(long)heisRB.team.rankTeamPollScore];
            } else {
                heismanWinnerStr = [NSString stringWithFormat:@"%ld's POTY: %@ RB %@!\n?Congratulations to %@ RB %@ [%@], who had %ld TDs, %ld fumble, and %ld rushing yards and led %@ to a %ld-%ld record and a #%ld poll ranking.",(long)([HBSharedUtils currentLeague].baseYear + self.leagueHistoryDictionary.count), heisRB.team.abbreviation, [heisRB getInitialName],heisRB.team.abbreviation, heisRB.name, [heisman getYearString], (long)heisRB.statsTD, (long)heisRB.statsFumbles, (long)heisRB.statsRushYards, heisRB.team.name, (long)heisRB.team.wins,(long)heisRB.team.losses,(long)heisRB.team.rankTeamPollScore];
            }
            [heismanStats appendString:[NSString stringWithFormat:@"%@\n\nFull Results: %@",heismanWinnerStr, heismanTop5]];
        } else if ([heisman isKindOfClass:[PlayerTE class]]) {
            //te heisman
            PlayerTE *heisWR = (PlayerTE*)heisman;
            if (heisWR.statsFumbles > 1 || heisWR.statsFumbles == 0) {
                heismanWinnerStr = [NSString stringWithFormat:@"%ld's POTY: %@ TE %@!\n?Congratulations to %@ TE %@ [%@], who had %ld TDs, %ld fumbles, and %ld receiving yards and led %@ to a %ld-%ld record and a #%ld poll ranking.",(long)([HBSharedUtils currentLeague].baseYear + self.leagueHistoryDictionary.count), heisWR.team.abbreviation, [heisWR getInitialName], heisWR.team.abbreviation, heisWR.name, [heisman getYearString], (long)heisWR.statsTD, (long)heisWR.statsFumbles, (long)heisWR.statsRecYards, heisWR.team.name, (long)heisWR.team.wins,(long)heisWR.team.losses,(long)heisWR.team.rankTeamPollScore];
            } else {
                heismanWinnerStr = [NSString stringWithFormat:@"%ld's POTY: %@ TE %@!\n?Congratulations to %@ TE %@ [%@], who had %ld TDs, %ld fumble, and %ld receiving yards and led %@ to a %ld-%ld record and a #%ld poll ranking.",(long)([HBSharedUtils currentLeague].baseYear + self.leagueHistoryDictionary.count), heisWR.team.abbreviation, [heisWR getInitialName],heisWR.team.abbreviation, heisWR.name, [heisman getYearString], (long)heisWR.statsTD, (long)heisWR.statsFumbles, (long)heisWR.statsRecYards, heisWR.team.name, (long)heisWR.team.wins,(long)heisWR.team.losses,(long)heisWR.team.rankTeamPollScore];
            }

            [heismanStats appendString:[NSString stringWithFormat:@"%@\n\nFull Results: %@",heismanWinnerStr, heismanTop5]];
        } else if ([heisman isKindOfClass:[PlayerWR class]]) {
            //wr heisman
            PlayerWR *heisWR = (PlayerWR*)heisman;
            if (heisWR.statsFumbles > 1 || heisWR.statsFumbles == 0) {
                heismanWinnerStr = [NSString stringWithFormat:@"%ld's POTY: %@ WR %@!\n?Congratulations to %@ WR %@ [%@], who had %ld TDs, %ld fumbles, and %ld receiving yards and led %@ to a %ld-%ld record and a #%ld poll ranking.",(long)([HBSharedUtils currentLeague].baseYear + self.leagueHistoryDictionary.count), heisWR.team.abbreviation, [heisWR getInitialName], heisWR.team.abbreviation, heisWR.name, [heisman getYearString], (long)heisWR.statsTD, (long)heisWR.statsFumbles, (long)heisWR.statsRecYards, heisWR.team.name, (long)heisWR.team.wins,(long)heisWR.team.losses,(long)heisWR.team.rankTeamPollScore];
            } else {
                heismanWinnerStr = [NSString stringWithFormat:@"%ld's POTY: %@ WR %@!\n?Congratulations to %@ WR %@ [%@], who had %ld TDs, %ld fumble, and %ld receiving yards and led %@ to a %ld-%ld record and a #%ld poll ranking.",(long)([HBSharedUtils currentLeague].baseYear + self.leagueHistoryDictionary.count), heisWR.team.abbreviation, [heisWR getInitialName],heisWR.team.abbreviation, heisWR.name, [heisman getYearString], (long)heisWR.statsTD, (long)heisWR.statsFumbles, (long)heisWR.statsRecYards, heisWR.team.name, (long)heisWR.team.wins,(long)heisWR.team.losses,(long)heisWR.team.rankTeamPollScore];
            }

            [heismanStats appendString:[NSString stringWithFormat:@"%@\n\nFull Results: %@",heismanWinnerStr, heismanTop5]];
        }

        // Add news story
        if (putNewsStory) {
            NSMutableArray *week13 = newsStories[13];
            NSString *newsString = [heismanWinnerStr stringByReplacingOccurrencesOfString:@"?" withString:@""];
            if (![week13 containsObject:newsString]) {
                [week13 addObject:newsString];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"newNewsStory" object:nil];
        }

        heismanWinnerStrFull = heismanStats;
        return heismanStats;
    }
}

-(NSArray*)getBowlPredictions {
    if (!hasScheduledBowls) {
        [teamList sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            Team *a = (Team*)obj1;
            Team *b = (Team*)obj2;
            return a.teamPollScore > b.teamPollScore ? -1 : a.teamPollScore == b.teamPollScore ? 0 : 1;

        }];


        NSMutableArray* sb = [NSMutableArray array];
        Team *t1;
        Team *t2;

        t1 = teamList[0];
        t2 = teamList[3];

        [sb addObject:[Game newGameWithHome:t1 away:t2 name:@"Semis, 1v4"]];


        t1 = teamList[1];
        t2 = teamList[2];

        [sb addObject:[Game newGameWithHome:t1 away:t2 name:@"Semis, 2v3"]];

        NSMutableArray *bowlEligibleTeams = [NSMutableArray array];
        for (int i = 4; i < ([self bowlGameTitles].count * 2); i++) {
            [bowlEligibleTeams addObject:teamList[i]];
        }

        [bowlGames removeAllObjects];
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
        if (!ncg) {
            // Games have already been scheduled, give actual teams
            NSMutableArray *sb = [NSMutableArray array];
            [sb addObject:semiG14];
            [sb addObject:semiG23];

            for (Game *bowl in bowlGames) {
                [sb addObject:bowl];
            }

            return [sb copy];
        } else {
            // Games have already been scheduled, give actual teams
            NSMutableArray *sb = [NSMutableArray array];
            [sb addObject:ncg];
            [sb addObject:semiG14];
            [sb addObject:semiG23];

            for (Game *bowl in bowlGames) {
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
    for (int i = 0; i < teamList.count; i++){
        if ([teamList[i].abbreviation isEqualToString:name]) {
            return teamList[i];
        }
    }
    return nil;
}

-(Conference*)findConference:(NSString*)name {
    for (int i = 0; i < conferences.count; i++){
        if ([conferences[i].confName isEqualToString:name]) {
            return conferences[i];
        }
    }
    return nil;
}

-(NSString*)ncgSummaryStr {
    // Give summary of what happened in the NCG
    if (ncg.homeScore > ncg.awayScore) {
        return [NSString stringWithFormat:@"%@ (%ld-%ld) won the National Championship, beating %@ (%ld-%ld) in the NCG %ld-%ld.",ncg.homeTeam.name,(long)ncg.homeTeam.wins,(long)ncg.homeTeam.losses,ncg.awayTeam.name, (long)ncg.awayTeam.wins,(long)ncg.awayTeam.losses, (long)ncg.homeScore, (long)ncg.awayScore];
    } else {
        return [NSString stringWithFormat:@"%@ (%ld-%ld) won the National Championship, beating %@ (%ld-%ld) in the NCG %ld-%ld.",ncg.awayTeam.name,(long)ncg.awayTeam.wins,(long)ncg.awayTeam.losses,ncg.homeTeam.name, (long)ncg.homeTeam.wins,(long)ncg.homeTeam.losses, (long)ncg.awayScore, (long)ncg.homeScore];
    }
}

-(NSString*)seasonSummaryStr {
    NSMutableString *sb = [NSMutableString string];
    [sb appendString:[self ncgSummaryStr]];
    [sb appendString:[NSString stringWithFormat:@"\n\n%@",[userTeam getSeasonSummaryString]]];
    return [sb copy];
}

-(void)setTeamRanks {

    teamList = [[teamList sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Team *a = (Team*)obj1;
        Team *b = (Team*)obj2;
        return a.teamRecruitingClassScore > b.teamRecruitingClassScore ? -1 : a.teamRecruitingClassScore == b.teamRecruitingClassScore ? [a.name compare:b.name] : 1;
    }] mutableCopy];

    for (int t = 0; t < teamList.count; ++t) {
        teamList[t].rankTeamRecruitingClassScore = t+1;
    }

    //get team ranks for PPG, YPG, etc
    for (int i = 0; i < teamList.count; ++i) {
        [teamList[i] updatePollScore];
    }

    teamList = [[teamList sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Team *a = (Team*)obj1;
        Team *b = (Team*)obj2;
        return a.teamPollScore > b.teamPollScore ? -1 : a.teamPollScore == b.teamPollScore ? (a.wins > b.wins ? -1 : a.wins == b.wins ? (a.teamPoints > b.teamPoints ? -1 : a.teamPoints == b.teamPoints ? 0 : 1) : 1) : 1;
    }] mutableCopy];

    for (int t = 0; t < teamList.count; ++t) {
        teamList[t].rankTeamPollScore = t+1;
    }

    teamList = [[teamList sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Team *a = (Team*)obj1;
        Team *b = (Team*)obj2;
        return a.teamStrengthOfWins > b.teamStrengthOfWins ? -1 : a.teamStrengthOfWins == b.teamStrengthOfWins ? 0 : 1;
    }] mutableCopy];
    for (int t = 0; t < teamList.count; ++t) {
        teamList[t].rankTeamStrengthOfWins = t+1;
    }

    if (currentWeek > 0) {
        teamList = [[teamList sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            Team *a = (Team*)obj1;
            Team *b = (Team*)obj2;
            return a.teamPoints/a.numGames > b.teamPoints/b.numGames ? -1 : a.teamPoints/a.numGames == b.teamPoints/b.numGames ? 0 : 1;
        }] mutableCopy];
        for (int t = 0; t < teamList.count; ++t) {
            teamList[t].rankTeamPoints = t+1;
        }

        teamList = [[teamList sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            Team *a = (Team*)obj1;
            Team *b = (Team*)obj2;
            return a.teamOppPoints/a.numGames < b.teamOppPoints/b.numGames ? -1 : a.teamOppPoints/a.numGames == b.teamOppPoints/b.numGames ? 0 : 1;
        }] mutableCopy];
        for (int t = 0; t < teamList.count; ++t) {
            teamList[t].rankTeamOppPoints = t+1;
        }

        teamList = [[teamList sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            Team *a = (Team*)obj1;
            Team *b = (Team*)obj2;
            return a.teamYards/a.numGames > b.teamYards/b.numGames ? -1 : a.teamYards/a.numGames == b.teamYards/b.numGames ? 0 : 1;
        }] mutableCopy];
        for (int t = 0; t < teamList.count; ++t) {
            teamList[t].rankTeamYards = t+1;
        }

        teamList = [[teamList sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            Team *a = (Team*)obj1;
            Team *b = (Team*)obj2;
            return a.teamOppYards/a.numGames < b.teamOppYards/b.numGames ? -1 : a.teamOppYards/a.numGames == b.teamOppYards/b.numGames ? 0 : 1;
        }] mutableCopy];
        for (int t = 0; t < teamList.count; ++t) {
            teamList[t].rankTeamOppYards = t+1;
        }

        teamList = [[teamList sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            Team *a = (Team*)obj1;
            Team *b = (Team*)obj2;
            return a.teamPassYards/a.numGames > b.teamPassYards/b.numGames ? -1 : a.teamPassYards/a.numGames == b.teamPassYards/b.numGames ? 0 : 1;
        }] mutableCopy];
        for (int t = 0; t < teamList.count; ++t) {
            teamList[t].rankTeamPassYards = t+1;
        }

        teamList = [[teamList sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            Team *a = (Team*)obj1;
            Team *b = (Team*)obj2;
            return a.teamRushYards/a.numGames > b.teamRushYards/b.numGames ? -1 : a.teamRushYards/a.numGames == b.teamRushYards/b.numGames ? 0 : 1;
        }] mutableCopy];
        for (int t = 0; t < teamList.count; ++t) {
            teamList[t].rankTeamRushYards = t+1;
        }

        teamList = [[teamList sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            Team *a = (Team*)obj1;
            Team *b = (Team*)obj2;
            return a.teamOppPassYards/a.numGames < b.teamOppPassYards/b.numGames ? -1 : a.teamOppPassYards/a.numGames == b.teamOppPassYards/b.numGames ? 0 : 1;
        }] mutableCopy];
        for (int t = 0; t < teamList.count; ++t) {
            teamList[t].rankTeamOppPassYards = t+1;
        }

        teamList = [[teamList sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            Team *a = (Team*)obj1;
            Team *b = (Team*)obj2;
            return a.teamOppRushYards/a.numGames < b.teamOppRushYards/b.numGames ? -1 : a.teamOppRushYards/a.numGames == b.teamOppRushYards/b.numGames ? 0 : 1;
        }] mutableCopy];
        for (int t = 0; t < teamList.count; ++t) {
            teamList[t].rankTeamOppRushYards = t+1;
        }

        teamList = [[teamList sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            Team *a = (Team*)obj1;
            Team *b = (Team*)obj2;
            return a.teamTODiff > b.teamTODiff ? -1 : a.teamTODiff == b.teamTODiff ? 0 : 1;
        }] mutableCopy];
        for (int t = 0; t < teamList.count; ++t) {
            teamList[t].rankTeamTODiff= t+1;
        }
    }

    teamList = [[teamList sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Team *a = (Team*)obj1;
        Team *b = (Team*)obj2;
        return a.teamOffTalent > b.teamOffTalent ? -1 : a.teamOffTalent == b.teamOffTalent ? 0 : 1;
    }] mutableCopy];
    for (int t = 0; t < teamList.count; ++t) {
        teamList[t].rankTeamOffTalent = t+1;
    }

    teamList = [[teamList sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Team *a = (Team*)obj1;
        Team *b = (Team*)obj2;
        return a.teamDefTalent > b.teamDefTalent ? -1 : a.teamDefTalent == b.teamDefTalent ? 0 : 1;
    }] mutableCopy];
    for (int t = 0; t < teamList.count; ++t) {
        teamList[t].rankTeamDefTalent = t+1;
    }

    teamList = [[teamList sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Team *a = (Team*)obj1;
        Team *b = (Team*)obj2;
        return a.teamPrestige > b.teamPrestige ? -1 : a.teamPrestige == b.teamPrestige ? 0 : 1;
    }] mutableCopy];
    for (int t = 0; t < teamList.count; ++t) {
        teamList[t].rankTeamPrestige = t+1;
    }

    teamList = [[teamList sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
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

    for (int t = 0; t < teamList.count; ++t) {
        teamList[t].rankTeamTotalWins = t+1;
    }
}

-(void)refreshAllLeaguePlayers {
    NSMutableArray *leadingQBs = [NSMutableArray array];
    NSMutableArray *leadingRBs = [NSMutableArray array];
    NSMutableArray *leadingWRs = [NSMutableArray array];
    NSMutableArray *leadingTEs = [NSMutableArray array];
    NSMutableArray *leadingKs = [NSMutableArray array];

    for (Team *t in teamList) {
        [leadingQBs addObject:[t getQB:0]];
        [leadingRBs addObject:[t getRB:0]];
        [leadingRBs addObject:[t getRB:1]];
        [leadingWRs addObject:[t getWR:0]];
        [leadingWRs addObject:[t getWR:1]];
        [leadingWRs addObject:[t getWR:2]];
        [leadingTEs addObject:[t getTE:0]];
        [leadingKs addObject:[t getK:0]];
    }

    [leadingQBs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Player *a = (Player*)obj1;
        Player *b = (Player*)obj2;
        if (a.isHeisman || a.isROTY) return -1;
        else if (b.isHeisman || b.isROTY) return 1;
        else return [a getHeismanScore] > [b getHeismanScore] ? -1 : [a getHeismanScore] == [b getHeismanScore] ? 0 : 1;
    }];

    [leadingRBs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Player *a = (Player*)obj1;
        Player *b = (Player*)obj2;
        if (a.isHeisman || a.isROTY) return -1;
        else if (b.isHeisman || b.isROTY) return 1;
        else return [a getHeismanScore] > [b getHeismanScore] ? -1 : [a getHeismanScore] == [b getHeismanScore] ? 0 : 1;
    }];

    [leadingWRs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Player *a = (Player*)obj1;
        Player *b = (Player*)obj2;
        if (a.isHeisman || a.isROTY) return -1;
        else if (b.isHeisman || b.isROTY) return 1;
        else return [a getHeismanScore] > [b getHeismanScore] ? -1 : [a getHeismanScore] == [b getHeismanScore] ? 0 : 1;
    }];

    [leadingTEs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Player *a = (Player*)obj1;
        Player *b = (Player*)obj2;
        if (a.isHeisman || a.isROTY) return -1;
        else if (b.isHeisman || b.isROTY) return 1;
        else return [a getHeismanScore] > [b getHeismanScore] ? -1 : [a getHeismanScore] == [b getHeismanScore] ? 0 : 1;
    }];

    [leadingKs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        PlayerK *a = (PlayerK*)obj1;
        PlayerK *b = (PlayerK*)obj2;
        if (a.isHeisman || a.isROTY) return -1;
        else if (b.isHeisman || b.isROTY) return 1;
        else return [a getHeismanScore] > [b getHeismanScore] ? -1 : [a getHeismanScore] == [b getHeismanScore] ? 0 : 1;
    }];

    PlayerQB *qb = leadingQBs[0];
    qb.careerAllAmericans++;
    [qb.team getCurrentHC].totalAllAmericans++;
    qb.isAllAmerican = YES;

    PlayerRB *rb1 = leadingRBs[0];
    rb1.careerAllAmericans++;
    [rb1.team getCurrentHC].totalAllAmericans++;
    rb1.isAllAmerican = YES;

    PlayerRB *rb2 = leadingRBs[1];
    rb2.careerAllAmericans++;
    [rb2.team getCurrentHC].totalAllAmericans++;
    rb2.isAllAmerican = YES;

    PlayerWR *wr1 = leadingWRs[0];
    wr1.careerAllAmericans++;
    [wr1.team getCurrentHC].totalAllAmericans++;
    wr1.isAllAmerican = YES;

    PlayerWR *wr2 = leadingWRs[1];
    wr2.careerAllAmericans++;
    [wr2.team getCurrentHC].totalAllAmericans++;
    wr2.isAllAmerican = YES;

    PlayerWR *wr3 = leadingWRs[2];
    wr3.careerAllAmericans++;
    [wr3.team getCurrentHC].totalAllAmericans++;
    wr3.isAllAmerican = YES;

    PlayerTE *te = leadingTEs[0];
    te.careerAllAmericans++;
    [te.team getCurrentHC].totalAllAmericans++;
    te.isAllAmerican = YES;

    PlayerK *k = leadingKs[0];
    k.careerAllAmericans++;
    [k.team getCurrentHC].totalAllAmericans++;
    k.isAllAmerican = YES;

    [[NSNotificationCenter defaultCenter] postNotificationName:@"awardsPosted" object:nil];

    allLeaguePlayers = @{
                           @"QB" : @[qb],
                           @"RB" : @[rb1,rb2],
                           @"WR" : @[wr1,wr2,wr3],
                           @"TE" : @[te],
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

    NSArray *teamList = [HBSharedUtils currentLeague].teamList;
    for (Team *t in teamList) {
        [t getGraduatingPlayers];
        [players addObjectsFromArray:t.playersLeaving];
    }
    if (!heisman) {
        NSArray *candidates = [self calculateHeismanCandidates];
        if (candidates.count > 0) {
            heisman = candidates[0];
        }
    }

    [players sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Player *a = (Player*)obj1;
        Player *b = (Player*)obj2;
        int adjADraftGrade = 0;
        int adjBDraftGrade = 0;
        int adjAHeisScore = 100 * ((double)[a getHeismanScore]/(double)[self->heisman getHeismanScore]);
        int adjBHeisScore = 100 * ((double)[b getHeismanScore]/(double)[self->heisman getHeismanScore]);

        if ([a isKindOfClass:[PlayerQB class]]) {
            PlayerQB *p = (PlayerQB*)a;

            adjADraftGrade = (int)(((double)(p.ratOvr + p.ratFootIQ + p.ratPassAcc + p.ratPassEva + p.ratPassPow + adjAHeisScore) / 6.0) * 12.0);
        } else if ([a isKindOfClass:[PlayerRB class]]) {
            PlayerRB *p = (PlayerRB*)a;
            adjADraftGrade = (int)(((double)(p.ratOvr + p.ratFootIQ + p.ratRushEva + p.ratRushPow + p.ratRushSpd + adjAHeisScore) / 6.0) * 12.0);
        } else if ([a isKindOfClass:[PlayerTE class]]) {
            PlayerTE *p = (PlayerTE*)a;
            adjADraftGrade = (int)(((double)(p.ratOvr + p.ratFootIQ + p.ratRecCat + p.ratTERunBlk + p.ratRecSpd + adjAHeisScore) / 6.0) * 12.0);
        } else if ([a isKindOfClass:[PlayerWR class]]) {
            PlayerWR *p = (PlayerWR*)a;
            adjADraftGrade = (int)(((double)(p.ratOvr + p.ratFootIQ + p.ratRecCat + p.ratRecEva + p.ratRecSpd + adjAHeisScore) / 6.0) * 12.0);
        }else if ([a isKindOfClass:[PlayerOL class]]) {
            PlayerOL *p = (PlayerOL*)a;
            adjADraftGrade = (int)(((double)(p.ratOvr + p.ratFootIQ + p.ratOLBkP + p.ratOLPow + p.ratOLBkR) / 5.0) * 11.0);
        } else if ([a isKindOfClass:[PlayerDL class]]) {
            PlayerDL *p = (PlayerDL*)a;
            adjADraftGrade = (int)(((double)(p.ratOvr + p.ratFootIQ + p.ratDLPas + p.ratDLPow + p.ratDLRsh) / 5.0) * 10.5);
        } else if ([a isKindOfClass:[PlayerLB class]]) {
            PlayerLB *p = (PlayerLB*)a;
            adjADraftGrade = (int)(((double)(p.ratOvr + p.ratFootIQ + p.ratLBPas + p.ratLBTkl + p.ratLBRsh) / 5.0) * 10.5);
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
        } else if ([b isKindOfClass:[PlayerTE class]]) {
            PlayerTE *p = (PlayerTE*)b;
            adjBDraftGrade = (int)(((double)(p.ratOvr + p.ratFootIQ + p.ratRecCat + p.ratTERunBlk + p.ratRecSpd + adjBHeisScore) / 6.0) * 12.0);
        } else if ([b isKindOfClass:[PlayerWR class]]) {
            PlayerWR *p = (PlayerWR*)b;
            adjBDraftGrade = (int)(((double)(p.ratOvr + p.ratFootIQ + p.ratRecCat + p.ratRecEva + p.ratRecSpd + adjBHeisScore) / 6.0) * 12.0);
        } else if ([b isKindOfClass:[PlayerOL class]]) {
            PlayerOL *p = (PlayerOL*)b;
            adjBDraftGrade = (int)(((double)(p.ratOvr + p.ratFootIQ + p.ratOLBkP + p.ratOLPow + p.ratOLBkR) / 5.0) * 11.0);
        } else if ([b isKindOfClass:[PlayerDL class]]) {
            PlayerDL *p = (PlayerDL*)b;
            adjBDraftGrade = (int)(((double)(p.ratOvr + p.ratFootIQ + p.ratDLPas + p.ratDLPow + p.ratDLRsh) / 5.0) * 10.5);
        } else if ([b isKindOfClass:[PlayerLB class]]) {
            PlayerLB *p = (PlayerLB*)b;
            adjBDraftGrade = (int)(((double)(p.ratOvr + p.ratFootIQ + p.ratLBPas + p.ratLBTkl + p.ratLBRsh) / 5.0) * 10.5);
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
    Team *userTeam = [HBSharedUtils currentLeague].userTeam;
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

    allDraftedPlayers = @[round1, round2, round3, round4, round5, round6, round7];

}

-(void)updateHallOfFame {
    for (Team *t in teamList) {
        for (Player *p in t.teamQBs) {
            if (((t.isUserControlled && [t.playersLeaving containsObject:p]) || (!t.isUserControlled && p.year == 4))
                && (p.careerAllConferences > 3 || p.careerHeismans > 0 || p.careerAllAmericans > 2)) {
                if (![hallOfFamers containsObject:p]) {
                    p.injury = nil; //sanity check to make sure our immortals are actually immortal
                    [hallOfFamers addObject:p];
                }
            }
        }

        for (Player *p in t.teamRBs) {
            if (((t.isUserControlled && [t.playersLeaving containsObject:p]) || (!t.isUserControlled && p.year == 4))
                && (p.careerAllConferences > 3 || p.careerHeismans > 0 || p.careerAllAmericans > 2)) {
                if (![hallOfFamers containsObject:p]) {
                    p.injury = nil; //sanity check to make sure our immortals are actually immortal
                    [hallOfFamers addObject:p];
                }
            }
        }

        for (Player *p in t.teamWRs) {
            if (((t.isUserControlled && [t.playersLeaving containsObject:p]) || (!t.isUserControlled && p.year == 4))
                && (p.careerAllConferences > 3 || p.careerHeismans > 0 || p.careerAllAmericans > 2)) {
                if (![hallOfFamers containsObject:p]) {
                    p.injury = nil; //sanity check to make sure our immortals are actually immortal
                    [hallOfFamers addObject:p];
                }
            }
        }

        for (Player *p in t.teamTEs) {
            if (((t.isUserControlled && [t.playersLeaving containsObject:p]) || (!t.isUserControlled && p.year == 4))
                && (p.careerAllConferences > 3 || p.careerHeismans > 0 || p.careerAllAmericans > 2)) {
                if (![hallOfFamers containsObject:p]) {
                    p.injury = nil; //sanity check to make sure our immortals are actually immortal
                    [hallOfFamers addObject:p];
                }
            }
        }

        if (hallOfFamers.count > 0) {
            //for (Player *p in hallOfFamers) {
               // p.year = 5;
            //}

            //sort normally
            [hallOfFamers sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                return [HBSharedUtils comparePlayers:obj1 toObj2:obj2];
            }];

            //sort by most hallowed (hallowScore = normalized OVR + 2 * all-conf + 4 * all-Amer + 6 * Heisman; tie-break w/ pure OVR, then gamesPlayed, then potential)
            int maxOvr = hallOfFamers[0].ratOvr;
            [hallOfFamers sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
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

-(BOOL)isTeamNameValid:(NSString*)name allowUserTeam:(BOOL)allowUserTeam allowOverwrite:(BOOL)allowOverwrite  {
    if (name.length == 0) {
        return NO;
    }

    //Create character set
    NSMutableCharacterSet *validChars = [NSMutableCharacterSet lowercaseLetterCharacterSet];
    [validChars addCharactersInString:@"&. "];

    //Check against that
    NSRange  range = [name.lowercaseString rangeOfCharacterFromSet:[validChars invertedSet]];
    if (NSNotFound != range.location) {
        NSLog(@"Found invalid character in team name: %@", name);
        return false;
    }

    if (!allowOverwrite) {
        for (int i = 0; i < teamList.count; i++) {
            // compare using all lower case so no dumb duplicates
            if (allowUserTeam) {
                if ([teamList[i].name.lowercaseString isEqualToString:name.lowercaseString]) {
                    return false;
                }
            } else {
                if ([teamList[i].name.lowercaseString isEqualToString:name.lowercaseString] && !teamList[i].isUserControlled) {
                    return false;
                }
            }
        }
    }

    return true;
}

-(BOOL)isTeamAbbrValid:(NSString*)abbr allowUserTeam:(BOOL)allowUserTeam allowOverwrite:(BOOL)allowOverwrite {
    if (abbr.length == 0 || abbr.length > 4) {
        return NO;
    }

    //Create character set
    NSCharacterSet *validChars = [NSCharacterSet lowercaseLetterCharacterSet];

    //Invert the set
    validChars = [validChars invertedSet];

    //Check against that
    NSRange  range = [abbr.lowercaseString rangeOfCharacterFromSet:validChars];
    if (NSNotFound != range.location) {
        NSLog(@"Found invalid character in team abbr: %@", abbr);
        return false;
    }

    if (allowOverwrite == FALSE) {
        for (int i = 0; i < teamList.count; i++) {
            // compare using all lower case so no dumb duplicates
            if (allowUserTeam) {
                if ([teamList[i].abbreviation.lowercaseString isEqualToString:abbr.lowercaseString]) {
                    return false;
                }
            } else {
                if ([teamList[i].abbreviation.lowercaseString isEqualToString:abbr.lowercaseString] && !teamList[i].isUserControlled) {
                    return false;
                }
            }
        }
    } else {
        NSLog(@"IGNORING EXISTING DATA");
    }

    return true;
}

-(BOOL)isConfNameValid:(NSString*)name allowOverwrite:(BOOL)canOverwrite {
    if (name.length == 0) {
        return NO;
    }

    //Create character set
    NSMutableCharacterSet *validChars = [NSMutableCharacterSet alphanumericCharacterSet];
    [validChars addCharactersInString:@" "];

    //Check against that
    NSRange  range = [name.lowercaseString rangeOfCharacterFromSet:[validChars invertedSet]];
    if (NSNotFound != range.location) {
        NSLog(@"Found invalid character in conf name: %@", name);
        return false;
    }

    if (!canOverwrite) {
        for (int i = 0; i < conferences.count; i++) {
            // compare using all lower case so no dumb duplicates
            if ([conferences[i].confFullName.lowercaseString isEqualToString:name.lowercaseString]) {
                return false;
            }
        }
    }

    return true;
}

-(BOOL)isConfAbbrValid:(NSString*)abbr allowOverwrite:(BOOL)canOverwrite {
    if (abbr.length == 0 || abbr.length > 5) {
        return NO;
    }

    //Create character set
    NSCharacterSet *validChars = [NSCharacterSet alphanumericCharacterSet];

    //Invert the set
    validChars = [validChars invertedSet];

    //Check against that
    NSRange  range = [abbr.lowercaseString rangeOfCharacterFromSet:validChars];
    if (NSNotFound != range.location) {
        NSLog(@"Found invalid character in conf abbr: %@", abbr);
        return false;
    }

    if (!canOverwrite) {
        for (int i = 0; i < conferences.count; i++) {
            // compare using all lower case so no dumb duplicates
            if ([conferences[i].confName.lowercaseString isEqualToString:abbr.lowercaseString]) {
                return false;
            }
        }
    }
    return true;
}

-(BOOL)isStateValid:(NSString *)stt {
    if (stt.length == 0) {
        return NO;
    }

    return [[HBSharedUtils states] containsObject:stt];
}

-(NSString *)leagueMetadataJSON {
    NSMutableString *jsonString = [NSMutableString stringWithString:@""];
    [jsonString appendString:@"\{"];
    [jsonString appendString:@"\"bowlGames\" : \["];
    for (NSString *bowl in [self bowlGameTitles]) {
        [jsonString appendFormat:@"\"%@\",", bowl];
    }
    NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@","];
    jsonString = [NSMutableString stringWithString:[jsonString stringByTrimmingCharactersInSet:charSet]];
    [jsonString appendString:@"],"];

    [jsonString appendString:@"\"conferences\" : \["];
    for (Conference *c in conferences) {
        [jsonString appendFormat:@"%@,", [c conferenceMetadataJSON]];
    }

    jsonString = [NSMutableString stringWithString:[jsonString stringByTrimmingCharactersInSet:charSet]];
    [jsonString appendString:@"]"];
    [jsonString appendString:@"}"];

    return (jsonString != nil) ? jsonString : @"";
}

-(void)applyJSONMetadataChanges:(NSString *)json {
    NSError *error;
    NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];

    if (!error) {
        NSArray *jsonConfs = jsonDict[@"conferences"];
        for (int i = 0; i < conferences.count; i++) {
            // Apply the changes from the JSON file
            [conferences[i] applyJSONMetadataChanges:jsonConfs[i]];

            // Reset team data just in case there were rivalry changes
            for (Team *t in conferences[i].confTeams) {
                [t resetStats];
            }
        }

        // Rebuild the schedule just in case there were rivalry changes
        for (Conference *c in conferences) {
            [c setUpSchedule];
            [c setUpOOCSchedule];
            [c insertOOCSchedule];
        }

        NSMutableArray *bowlNames = [NSMutableArray arrayWithArray:jsonDict[@"bowlGames"]];
        if (bowlNames.count < 10) {
            NSInteger need = 10 - bowlNames.count;
            NSArray *baseBowlNames = @[@"Lilac Bowl", @"Apple Bowl", @"Salty Bowl", @"Salsa Bowl", @"Mango Bowl",@"Patriot Bowl", @"Salad Bowl", @"Frost Bowl", @"Tropical Bowl", @"Music Bowl"];
            for (int i = 0; i < need; i++) {
                [bowlNames addObject:baseBowlNames[i]];
            }
        }
        bowlTitles = [bowlNames copy];
        NSLog(@"BOWLS: %@", bowlTitles);
    } else {
        NSLog(@"ERROR parsing league metadata: %@", error);
    }
}

-(NSInteger)getCurrentYear {
    return baseYear + [HBSharedUtils currentLeague].leagueHistoryDictionary.count;
}

-(BOOL)transferListEmpty {
    if (transferList != nil) {
        for (NSMutableArray *players in transferList.allValues) {
            if (players.count > 0) {
                return NO;
            }
        }
    }
    return YES;
}

-(NSArray<Player*>*)calculateROTYCandidates {
    if (!rotyDecided && currentWeek <= 13) {
        if (roty) {
            roty.isROTY = NO;
            roty = nil;
        }
        int heismanScore = 0;
        int tempScore = 0;
        if (rotyCandidates != nil) {
            [rotyCandidates removeAllObjects];
        } else {
            rotyCandidates = [NSMutableArray array];
        }
        for ( int i = 0; i < teamList.count; ++i ) {
            //qb
            if (teamList[i].teamQBs.count > 0) {
                PlayerQB *qb = teamList[i].teamQBs[0];
                if (qb.year == 1 && ![rotyCandidates containsObject:qb]) {
                    [rotyCandidates addObject:qb];
                }
                tempScore = [qb getHeismanScore] + teamList[i].wins*150;
                if ( tempScore > heismanScore ) {
                    roty = qb;
                    heismanScore = tempScore;
                }
            }

            //rb
            if (teamList[i].teamRBs.count > 1) {
                for (int rb = 0; rb < 2; ++rb) {
                    Player *rback = teamList[i].teamRBs[rb];
                    if (rback.year == 1 && ![rotyCandidates containsObject:rback]) {
                        [rotyCandidates addObject:rback];
                    }
                    tempScore = [rback getHeismanScore] + teamList[i].wins*150;
                    if ( tempScore > heismanScore ) {
                        roty = rback;
                        heismanScore = tempScore;
                    }
                }
            }

            //wr
            if (teamList[i].teamWRs.count > 2) {
                for (int wr = 0; wr < 3; ++wr) {
                    PlayerWR *wrec = teamList[i].teamWRs[wr];
                    if (wrec.year == 1 && ![rotyCandidates containsObject:wrec]) {
                        [rotyCandidates addObject:wrec];
                    }
                    tempScore = [wrec getHeismanScore] + teamList[i].wins*150;
                    if ( tempScore > heismanScore ) {
                        roty = wrec;
                        heismanScore = tempScore;
                    }
                }
            }

            //te
            if (teamList[i].teamTEs.count > 1) {
                PlayerTE *wrec = teamList[i].teamTEs[0];
                if (wrec.year == 1 && ![rotyCandidates containsObject:wrec]) {
                    [rotyCandidates addObject:wrec];
                }
                tempScore = [wrec getHeismanScore] + teamList[i].wins*150;
                if ( tempScore > heismanScore ) {
                    roty = wrec;
                    heismanScore = tempScore;
                }
            }
        }

        [rotyCandidates sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            Player *a = (Player*)obj1;
            Player *b = (Player*)obj2;
            if (a.isROTY) {
                return -1;
            } else if (b.isROTY) {
                return 1;
            } else {
                return [a getHeismanScore] > [b getHeismanScore] ? -1 : [a getHeismanScore] == [b getHeismanScore] ? 0 : 1;
            }

        }];

        return rotyCandidates;
    } else {
        [rotyCandidates sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            Player *a = (Player*)obj1;
            Player *b = (Player*)obj2;
            if (a.isROTY) {
                return -1;
            } else if (b.isROTY) {
                return 1;
            } else {
                return [a getHeismanScore] > [b getHeismanScore] ? -1 : [a getHeismanScore] == [b getHeismanScore] ? 0 : 1;
            }

        }];

        return rotyCandidates;
    }
}

-(NSString*)getROTYCeremonyStr {
    if (roty != nil && rotyWinnerStrFull != nil && rotyWinnerStrFull.length != 0) {
        roty.isROTY = YES;
        return rotyWinnerStrFull;
    } else {
        BOOL putNewsStory = false;

        rotyCandidates = [[self calculateROTYCandidates] mutableCopy];
        roty = rotyCandidates[0];
        rotyDecided = true;
        putNewsStory = true;

        NSString* rotyTop5 = @"\n";
        NSMutableString* rotyStats = [NSMutableString string];
        NSString* rotyWinnerStr = @"";
        rotyFinalists = [NSMutableArray array];
        //full results string
        int i = 0;
        int place = 1;
        while (rotyFinalists.count < 5 && i < rotyCandidates.count) {
            Player *p = rotyCandidates[i];
            rotyTop5 = [rotyTop5 stringByAppendingString:[NSString stringWithFormat:@"%d. %@ (%ld-%ld) - ",place,p.team.abbreviation,(long)p.team.wins,(long)p.team.losses]];
            if ([p isKindOfClass:[PlayerQB class]]) {
                PlayerQB *pqb = (PlayerQB*)p;
                rotyTop5 = [rotyTop5 stringByAppendingString:[NSString stringWithFormat:@" QB %@: %ld votes\n\t(%ld TDs, %ld Int, %ld Yds)\n",[pqb getInitialName],(long)[pqb getHeismanScore],(long)pqb.statsTD,(long)pqb.statsInt,(long)pqb.statsPassYards]];
            } else if ([p isKindOfClass:[PlayerRB class]]) {
                PlayerRB *prb = (PlayerRB*)p;
                rotyTop5 = [rotyTop5 stringByAppendingString:[NSString stringWithFormat:@" RB %@: %ld votes\n\t(%ld TDs, %ld Fum, %ld Yds)\n",[prb getInitialName],(long)[prb getHeismanScore],(long)prb.statsTD,(long)prb.statsFumbles,(long)prb.statsRushYards]];
            } else if ([p isKindOfClass:[PlayerTE class]]) {
                PlayerTE *pwr = (PlayerTE*)p;
                rotyTop5 = [rotyTop5 stringByAppendingString:[NSString stringWithFormat:@" TE %@: %ld votes\n\t(%ld TDs, %ld Fum, %ld Yds)\n",[pwr getInitialName],(long)[pwr getHeismanScore],(long)pwr.statsTD,(long)pwr.statsFumbles,(long)pwr.statsRecYards]];
            } else if ([p isKindOfClass:[PlayerWR class]]) {
                PlayerWR *pwr = (PlayerWR*)p;
                rotyTop5 = [rotyTop5 stringByAppendingString:[NSString stringWithFormat:@" WR %@: %ld votes\n\t(%ld TDs, %ld Fum, %ld Yds)\n",[pwr getInitialName],(long)[pwr getHeismanScore],(long)pwr.statsTD,(long)pwr.statsFumbles,(long)pwr.statsRecYards]];
            }
            if (p != nil && ![rotyFinalists containsObject:p]) {
                [rotyFinalists addObject:p];
                place++;
            }
            i++;
        }

        roty.team.rotys++;
        roty.careerROTYs++;
        [roty.team getCurrentHC].totalROTYs++;
        roty.isROTY = YES;
        if ([roty isKindOfClass:[PlayerQB class]]) {
            //qb heisman
            PlayerQB *heisQB = (PlayerQB*)roty;
            if (heisQB.statsInt > 1 || heisQB.statsInt == 0) {
                rotyWinnerStr = [NSString stringWithFormat:@"%ld's ROTY: %@ QB %@!\n?Congratulations to %@ QB %@ [%@], who had %ld TDs, %ld interceptions, and %ld passing yards and helped %@ get to a %ld-%ld record and a #%ld poll ranking.",(long)([HBSharedUtils currentLeague].baseYear + self.leagueHistoryDictionary.count), heisQB.team.abbreviation, [heisQB getInitialName],heisQB.team.abbreviation, heisQB.name, [heisQB getYearString], (long)heisQB.statsTD, (long)heisQB.statsInt, (long)heisQB.statsPassYards, heisQB.team.name, (long)heisQB.team.wins,(long)heisQB.team.losses,(long)heisQB.team.rankTeamPollScore];
            } else {
                rotyWinnerStr = [NSString stringWithFormat:@"%ld's ROTY: %@ QB %@!\n?Congratulations to %@ QB %@ [%@], who had %ld TDs, %ld interception, and %ld passing yards and helped %@ get to a %ld-%ld record and a #%ld poll ranking.",(long)([HBSharedUtils currentLeague].baseYear + self.leagueHistoryDictionary.count), heisQB.team.abbreviation, [heisQB getInitialName],heisQB.team.abbreviation, heisQB.name, [heisQB getYearString], (long)heisQB.statsTD, (long)heisQB.statsInt, (long)heisQB.statsPassYards, heisQB.team.name, (long)heisQB.team.wins,(long)heisQB.team.losses,(long)heisQB.team.rankTeamPollScore];
            }

            [rotyStats appendString:[NSString stringWithFormat:@"%@\n\nFull Results: %@",rotyWinnerStr, rotyTop5]];
        } else if ([roty isKindOfClass:[PlayerRB class]]) {
            //rb heisman
            PlayerRB *heisRB = (PlayerRB*)roty;
            if (heisRB.statsFumbles > 1 || heisRB.statsFumbles == 0) {
                rotyWinnerStr = [NSString stringWithFormat:@"%ld's ROTY: %@ RB %@!\n?Congratulations to %@ RB %@ [%@], who had %ld TDs, %ld fumbles, and %ld rushing yards and helped %@ get to a %ld-%ld record and a #%ld poll ranking.",(long)([HBSharedUtils currentLeague].baseYear + self.leagueHistoryDictionary.count), heisRB.team.abbreviation, [heisRB getInitialName], heisRB.team.abbreviation, heisRB.name, [heisRB getYearString], (long)heisRB.statsTD, (long)heisRB.statsFumbles, (long)heisRB.statsRushYards, heisRB.team.name, (long)heisRB.team.wins,(long)heisRB.team.losses,(long)heisRB.team.rankTeamPollScore];
            } else {
                rotyWinnerStr = [NSString stringWithFormat:@"%ld's ROTY: %@ RB %@!\n?Congratulations to %@ RB %@ [%@], who had %ld TDs, %ld fumble, and %ld rushing yards and helped %@ get to a %ld-%ld record and a #%ld poll ranking.",(long)([HBSharedUtils currentLeague].baseYear + self.leagueHistoryDictionary.count), heisRB.team.abbreviation, [heisRB getInitialName],heisRB.team.abbreviation, heisRB.name, [heisRB getYearString], (long)heisRB.statsTD, (long)heisRB.statsFumbles, (long)heisRB.statsRushYards, heisRB.team.name, (long)heisRB.team.wins,(long)heisRB.team.losses,(long)heisRB.team.rankTeamPollScore];
            }
            [rotyStats appendString:[NSString stringWithFormat:@"%@\n\nFull Results: %@",rotyWinnerStr, rotyTop5]];
        } else if ([roty isKindOfClass:[PlayerTE class]]) {
            //te heisman
            PlayerTE *heisWR = (PlayerTE*)roty;
            if (heisWR.statsFumbles > 1 || heisWR.statsFumbles == 0) {
                rotyWinnerStr = [NSString stringWithFormat:@"%ld's ROTY: %@ TE %@!\n?Congratulations to %@ TE %@ [%@], who had %ld TDs, %ld fumbles, and %ld receiving yards and helped %@ get to a %ld-%ld record and a #%ld poll ranking.",(long)([HBSharedUtils currentLeague].baseYear + self.leagueHistoryDictionary.count), heisWR.team.abbreviation, [heisWR getInitialName], heisWR.team.abbreviation, heisWR.name, [heisWR getYearString], (long)heisWR.statsTD, (long)heisWR.statsFumbles, (long)heisWR.statsRecYards, heisWR.team.name, (long)heisWR.team.wins,(long)heisWR.team.losses,(long)heisWR.team.rankTeamPollScore];
            } else {
                rotyWinnerStr = [NSString stringWithFormat:@"%ld's ROTY: %@ TE %@!\n?Congratulations to %@ TE %@ [%@], who had %ld TDs, %ld fumble, and %ld receiving yards and helped %@ get to a %ld-%ld record and a #%ld poll ranking.",(long)([HBSharedUtils currentLeague].baseYear + self.leagueHistoryDictionary.count), heisWR.team.abbreviation, [heisWR getInitialName],heisWR.team.abbreviation, heisWR.name, [heisWR getYearString], (long)heisWR.statsTD, (long)heisWR.statsFumbles, (long)heisWR.statsRecYards, heisWR.team.name, (long)heisWR.team.wins,(long)heisWR.team.losses,(long)heisWR.team.rankTeamPollScore];
            }

            [rotyStats appendString:[NSString stringWithFormat:@"%@\n\nFull Results: %@",rotyWinnerStr, rotyTop5]];
        } else if ([roty isKindOfClass:[PlayerWR class]]) {
            //wr heisman
            PlayerWR *heisWR = (PlayerWR*)roty;
            if (heisWR.statsFumbles > 1 || heisWR.statsFumbles == 0) {
                rotyWinnerStr = [NSString stringWithFormat:@"%ld's ROTY: %@ WR %@!\n?Congratulations to %@ WR %@ [%@], who had %ld TDs, %ld fumbles, and %ld receiving yards and helped %@ get to a %ld-%ld record and a #%ld poll ranking.",(long)([HBSharedUtils currentLeague].baseYear + self.leagueHistoryDictionary.count), heisWR.team.abbreviation, [heisWR getInitialName], heisWR.team.abbreviation, heisWR.name, [heisWR getYearString], (long)heisWR.statsTD, (long)heisWR.statsFumbles, (long)heisWR.statsRecYards, heisWR.team.name, (long)heisWR.team.wins,(long)heisWR.team.losses,(long)heisWR.team.rankTeamPollScore];
            } else {
                rotyWinnerStr = [NSString stringWithFormat:@"%ld's ROTY: %@ WR %@!\n?Congratulations to %@ WR %@ [%@], who had %ld TDs, %ld fumble, and %ld receiving yards and helped %@ get to a %ld-%ld record and a #%ld poll ranking.",(long)([HBSharedUtils currentLeague].baseYear + self.leagueHistoryDictionary.count), heisWR.team.abbreviation, [heisWR getInitialName],heisWR.team.abbreviation, heisWR.name, [heisWR getYearString], (long)heisWR.statsTD, (long)heisWR.statsFumbles, (long)heisWR.statsRecYards, heisWR.team.name, (long)heisWR.team.wins,(long)heisWR.team.losses,(long)heisWR.team.rankTeamPollScore];
            }

            [rotyStats appendString:[NSString stringWithFormat:@"%@\n\nFull Results: %@",rotyWinnerStr, rotyTop5]];
        }

        // Add news story
        if (putNewsStory) {
            NSMutableArray *week13 = newsStories[13];
            NSString *newsString = [rotyWinnerStr stringByReplacingOccurrencesOfString:@"?" withString:@""];
            if (![week13 containsObject:newsString]) {
                [week13 addObject:newsString];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"newNewsStory" object:nil];
        }

        rotyWinnerStrFull = rotyStats;
        return rotyStats;
    }
}

-(NSArray*)getROTYLeaders {
    if (!rotyDecided || !rotyFinalists) {
        NSMutableArray *tempHeis = [NSMutableArray array];
        NSArray *candidates = [self calculateROTYCandidates];
        int i = 0;
        while (tempHeis.count < 5 && i < candidates.count) {
            Player *p = candidates[i];
            if (p != nil && ![tempHeis containsObject:p]) {
                [tempHeis addObject:p];
            }

            i++;
        }

        [tempHeis sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            Player *a = (Player*)obj1;
            Player *b = (Player*)obj2;
            if (a.isROTY) {
                return -1;
            } else if (b.isROTY) {
                return 1;
            } else {
                return [a getHeismanScore] > [b getHeismanScore] ? -1 : [a getHeismanScore] == [b getHeismanScore] ? 0 : 1;
            }
        }];

        return [tempHeis copy];
    } else {
        return [rotyFinalists copy];
    }
}

// Coaching stuff
-(NSArray<HeadCoach*> *)getCOTYLeaders {
    if (!cotyDecided || !cotyFinalists) {
        NSMutableArray *tempHeis = [NSMutableArray array];
        NSArray *candidates = [self calculateCOTYCandidates];
        int i = 0;
        while (tempHeis.count < 5 && i < candidates.count) {
            Player *p = candidates[i];
            if (p != nil && ![tempHeis containsObject:p]) {
                [tempHeis addObject:p];
            }
            
            i++;
        }
        
        [tempHeis sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [HBSharedUtils compareCoachScore:obj1 toObj2:obj2];
        }];
        
        return [tempHeis copy];
    } else {
        return [cotyFinalists copy];
    }
}

-(NSArray *)calculateCOTYCandidates {
    cotyWinner = nil;
    NSMutableArray<HeadCoach *> *cotyCandidates = [NSMutableArray array];
    for (Team *t in teamList) {
        if (![cotyCandidates containsObject:[t getCurrentHC]]) {
            [cotyCandidates addObject:[t getCurrentHC]];
        }
    }
    [cotyCandidates sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [HBSharedUtils compareCoachScore:obj1 toObj2:obj2];
    }];
    return cotyCandidates;
}

-(NSString *)getCoachAwardStr {
    if (cotyWinner != nil && cotyWinnerStrFull != nil && cotyWinnerStrFull.length != 0) {
        cotyWinner.wonTopHC = YES;
        return cotyWinnerStrFull;
    } else {
        NSMutableArray *cotyCandidates = [[self calculateCOTYCandidates] mutableCopy];
        cotyWinner = cotyCandidates[0];
        cotyDecided = true;
        cotyFinalists = [NSMutableArray array];

        NSMutableString* heismanTop5 = [NSMutableString stringWithString:@"\n"];
        NSMutableString* heismanStats = [NSMutableString string];
        NSString* heismanWinnerStr = @"";
        //heismanFinalists = [NSMutableArray array];
        //full results string
        int i = 0;
        int place = 1;
        while (i < cotyCandidates.count && i < 5) {
            HeadCoach *hc = cotyCandidates[i];
            [heismanTop5 appendFormat:@"%d. %@ HC %@ (%ld-%ld) - %d votes\n",place,hc.team.abbreviation,[hc getInitialName],(long)hc.team.wins,(long)hc.team.losses, [hc getCoachScore]];
            [cotyFinalists addObject:hc];
            i++;
            place++;
        }

        cotyWinner.team.totalCOTYs++;
        cotyWinner.careerCOTYs++;
        cotyWinner.wonTopHC = YES;
        heismanWinnerStr = [NSString stringWithFormat:@"%ld's COTY: %@ HC %@!\n?Congratulations to the Coach of the Year, %@!\nHe led %@ to a %d-%d record and a #%d poll ranking.",(long)([HBSharedUtils currentLeague].baseYear + self.leagueHistoryDictionary.count), cotyWinner.team.abbreviation, [cotyWinner getInitialName], cotyWinner.name, cotyWinner.team.name, cotyWinner.team.wins, cotyWinner.team.losses, cotyWinner.team.rankTeamPollScore];

        [heismanStats appendString:[NSString stringWithFormat:@"%@\n\nFull Results: %@",heismanWinnerStr, heismanTop5]];

        // Add news story
        NSMutableArray *week13 = newsStories[13];
        NSString *newsString = [heismanWinnerStr stringByReplacingOccurrencesOfString:@"?" withString:@""];
        if (![week13 containsObject:newsString]) {
            [week13 addObject:newsString];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"newNewsStory" object:nil];

        cotyWinnerStrFull = heismanStats;
        return heismanStats;
    }
}

-(void)advanceHC {
    [coachList removeAllObjects];
    [coachStarList removeAllObjects];
    [teamList sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [HBSharedUtils compareTeamPrestige:obj1 toObj2:obj2];
    }];
    for (Team *t in teamList) {
        [t advanceHC];
    }
}

-(void)updateHCHistory {
    for (Team *t in teamList) {
        [t updateCoachHistory];
    }
}

-(NSMutableArray<Team *> *)getHardModeTeamVacancyList {
    NSMutableArray<Team *> *vacancies = [NSMutableArray array];
    for (Conference *c in conferences) {
        [vacancies addObject:[c.confTeams lastObject]];
        [vacancies addObject:c.confTeams[c.confTeams.count - 2]];
    }
    return vacancies;
}

-(NSMutableArray<Team*> *)getFiredCoachTeams:(int)rating oldTeam:(NSString *)oldTeam {
    NSMutableArray<Team *> *vacancies = [NSMutableArray array];
    for (Team *t in teamList) {
        if ([t getMinCoachHireReq] < rating && t.coaches.count == 0 && ![t.name isEqualToString:oldTeam]) {
            [vacancies addObject:t];
        }
    }
    return vacancies;
}

-(NSMutableArray<Team*> *)getPromotedCoachTeams:(int)rating offers:(double)offers oldTeam:(NSString *)oldTeam {
    NSMutableArray<Team *> *vacancies = [NSMutableArray array];
    for (Team *t in teamList) {
        if ([t getMinCoachHireReq] < rating && t.coaches.count == 0 && ![t.name isEqualToString:oldTeam] && offers < 0.50) {
            [vacancies addObject:t];
        }
    }
    return vacancies;
}

-(void)newJobTransfer:(NSString *)coachTeam {
    for (Team *t in teamList) {
        if ([t.name isEqualToString:coachTeam]) {
            t.isUserControlled = YES;
            userTeam = t;
        }
    }
}

-(void)coachingCarousel {
    [teamList sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [HBSharedUtils compareTeamPrestige:obj1 toObj2:obj2];
    }];

    for (HeadCoach *coach in coachStarList) {
        NSString *tmName = coach.team.name;
        int tmPrestige = coach.team.teamPrestige;
        Team *oldTeam = coach.team;
        int confPrestige = [self findConference:coach.team.conference].confPrestige;
        for (Team *t in teamList) {
            if (t.coaches.count == 0 && coach.ratOvr >= [t getMinCoachHireReq] && ![t.name isEqualToString:tmName]) {
                if ((t.teamPrestige > tmPrestige && [self findConference:t.conference].confPrestige > confPrestige) || t.teamPrestige > (tmPrestige + 5) || [self findConference:t.conference].confPrestige + 10 > confPrestige) {
                    [oldTeam.coaches removeObject:coach];
                    [t getCurrentHC].team = t;
                    [t.coaches addObject:coach];
                    [t getCurrentHC].contractLength = 6;
                    [t getCurrentHC].contractYear = 0;
                    [t getCurrentHC].baselinePrestige = t.teamPrestige;
                   // newsStories.get(currentWeek + 1).add("Rising Star Coach Hired: " + teamList.get(t).name + ">Rising star head coach " + teamList.get(t).HC.get(0).name + " has announced his departure from " + tmName + " after being selected by " + teamList.get(t).name + " as their new head coach. His previous track record has had him on the top list of many schools.");
                    if ([HBSharedUtils randomValue] < 0.20) {
                        [oldTeam promoteCoach];
//                        teamList.get(j).HC.get(0).history.add("");
//                        newsStories.get(currentWeek + 1).add("Replacement Promoted: " + teamList.get(j).name + ">" + teamList.get(j).name + " hopes to continue their recent success, despite the recent loss of coach " + teamList.get(t).HC.get(0).name + ". The team has promoted his assistant coach " + teamList.get(j).HC.get(0).name + " to the head coaching job at the school.");
                    }
                }
            }
        }
    }

    [coachList sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [HBSharedUtils compareCoachOvr:obj1 toObj2:obj2];
    }];
    for (int i = 0; i < coachList.count; i++) {
        HeadCoach *c = coachList[i];
        for (Team *t in teamList) {
            if (t.coaches.count == 0 && c.ratOvr >= [t getMinCoachHireReq] && ![t isEqual:c.team] && [HBSharedUtils randomValue] > 0.60) {
                Team *oldTeam = c.team;
                c.team = t;
                [t.coaches addObject:c];
                [t getCurrentHC].contractLength = 6;
                [t getCurrentHC].contractYear = 0;
                [t getCurrentHC].baselinePrestige = t.teamPrestige;
//                newsStories.get(currentWeek + 1).add("Coaching Switch: " + teamList.get(t).name + ">After an extensive search for a new head coach, " + teamList.get(t).name + " has hired " + teamList.get(t).HC.get(0).name + " to lead the team. Coach " + teamList.get(t).HC.get(0).name + " previously coached at " + coachList.get(i).team.name + ", before being let go this past season.");
                [oldTeam.coaches removeObject:c];
                [coachList removeObject:c];
                break; // should break from Team loop
            }
        }
    }

    [coachFreeAgents sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [HBSharedUtils compareCoachOvr:obj1 toObj2:obj2];
    }];

    for (int i = 0; i < coachFreeAgents.count; i++) {
        HeadCoach *c = coachList[i];
        for (Team *t in teamList) {
            if (t.coaches.count == 0 && c.ratOvr >= [t getMinCoachHireReq] && ![t isEqual:c.team] && [HBSharedUtils randomValue] > 0.60) {
                Team *oldTeam = c.team;
                c.team = t;
                [t.coaches addObject:c];
                [t getCurrentHC].contractLength = 6;
                [t getCurrentHC].contractYear = 0;
                [t getCurrentHC].baselinePrestige = t.teamPrestige;
                //                newsStories.get(currentWeek + 1).add("Return to the Sidelines: " + teamList.get(t).name + ">After an extensive search for a new head coach, " + teamList.get(t).name + " has hired " + teamList.get(t).HC.get(0).name + " to lead the team. Coach " + teamList.get(t).HC.get(0).name + " has been out of football, but is returning this season!");
                [oldTeam.coaches removeObject:c];
                [coachFreeAgents removeObject:c];
                break; // should break from Team loop
            }
        }
    }

    for (Team *t in teamList) {
        if (t.coaches.count == 0) {
            [t promoteCoach];
            //teamList.get(t).HC.get(0).history.add("");
            //newsStories.get(currentWeek + 1).add("Coaching Promotion: " + teamList.get(t).name + ">Following the departure of their previous head coach, " + teamList.get(t).name + " has promoted assistant " + teamList.get(t).HC.get(0).name + " to lead the team.");
        }
    }
}

-(void)coachHiringForSingleTeam:(Team *)t {
    for (HeadCoach *coach in coachStarList) {
        NSString *tmName = coach.team.name;
        int tmPrestige = coach.team.teamPrestige;
        Team *oldTeam = coach.team;
        int confPrestige = [self findConference:coach.team.conference].confPrestige;
        if (t.coaches.count == 0 && coach.ratOvr >= [t getMinCoachHireReq] && ![t.name isEqualToString:tmName]) {
            if ((t.teamPrestige > tmPrestige && [self findConference:t.conference].confPrestige > confPrestige) || t.teamPrestige > (tmPrestige + 5) || [self findConference:t.conference].confPrestige + 10 > confPrestige) {
                [oldTeam.coaches removeObject:coach];
                [t getCurrentHC].team = t;
                [t.coaches addObject:coach];
                [t getCurrentHC].contractLength = 6;
                [t getCurrentHC].contractYear = 0;
                [t getCurrentHC].baselinePrestige = t.teamPrestige;
                // newsStories.get(currentWeek + 1).add("Rising Star Coach Hired: " + teamList.get(t).name + ">Rising star head coach " + teamList.get(t).HC.get(0).name + " has announced his departure from " + tmName + " after being selected by " + teamList.get(t).name + " as their new head coach. His previous track record has had him on the top list of many schools.");
                if ([HBSharedUtils randomValue] < 0.20) {
                    [oldTeam promoteCoach];
                    //                        teamList.get(j).HC.get(0).history.add("");
                    //                        newsStories.get(currentWeek + 1).add("Replacement Promoted: " + teamList.get(j).name + ">" + teamList.get(j).name + " hopes to continue their recent success, despite the recent loss of coach " + teamList.get(t).HC.get(0).name + ". The team has promoted his assistant coach " + teamList.get(j).HC.get(0).name + " to the head coaching job at the school.");
                }
            }
        }
    }

    [coachList sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [HBSharedUtils compareCoachOvr:obj1 toObj2:obj2];
    }];
    for (int i = 0; i < coachList.count; i++) {
        HeadCoach *c = coachList[i];
        if (t.coaches.count == 0 && c.ratOvr >= [t getMinCoachHireReq] && ![t isEqual:c.team] && [HBSharedUtils randomValue] > 0.60) {
            Team *oldTeam = c.team;
            c.team = t;
            [t.coaches addObject:c];
            [t getCurrentHC].contractLength = 6;
            [t getCurrentHC].contractYear = 0;
            [t getCurrentHC].baselinePrestige = t.teamPrestige;
            // newsStories.get(currentWeek + 1).add("Coaching Change: " + school.name + ">After an extensive search for a new head coach, " + school.name + " has hired " + school.HC.get(0).name + " to lead the team. Coach " + school.HC.get(0).name + " previously coached at " + coachList.get(i).team.name + ", before being let go this past season.");
            [oldTeam.coaches removeObject:c];
            [coachList removeObject:c];
            break; // should break from Team loop
        }
    }

    if (t.coaches.count == 0) {
        [coachFreeAgents sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [HBSharedUtils compareCoachOvr:obj1 toObj2:obj2];
        }];

        for (int i = 0; i < coachFreeAgents.count; i++) {
            HeadCoach *c = coachList[i];
            if (t.coaches.count == 0 && c.ratOvr >= [t getMinCoachHireReq] && ![t isEqual:c.team] && [HBSharedUtils randomValue] > 0.60) {
                Team *oldTeam = c.team;
                c.team = t;
                [t.coaches addObject:c];
                [t getCurrentHC].contractLength = 6;
                [t getCurrentHC].contractYear = 0;
                [t getCurrentHC].baselinePrestige = t.teamPrestige;
                //newsStories.get(currentWeek + 1).add("Back to Coaching: " + school.name + ">After an extensive search for a new head coach, " + school.name + " has hired " + school.HC.get(0).name + " to lead the team. Coach " + school.HC.get(0).name + " has been out of football, but is returning this upcoming season!");
                [oldTeam.coaches removeObject:c];
                [coachFreeAgents removeObject:c];
                break; // should break from Team loop
            }
        }
    }


    if (t.coaches.count == 0) {
        [t promoteCoach];
//        school.HC.get(0).history.add("");
//        newsStories.get(currentWeek + 1).add("Coaching Promotion: " + school.name + ">Following the departure of their previous head coach, " + school.name + " has promoted assistant " + school.HC.get(0).name + " to lead the team.");
    }
}

-(void)coachingHotSeat {
    if (currentWeek == 0) {
        for (Team *t in teamList) {
            if ([t getCurrentHC].baselinePrestige < t.teamPrestige && [t getCurrentHC].contractYear == [t getCurrentHC].contractLength) {
                //newsStories.get(0).add("Coaching Hot Seat: " + teamList.get(i).name + ">Head Coach " + teamList.get(i).HC.get(0).name + " has struggled over the course of his current contract with " + teamList.get(i).name + " and has failed to raise the team prestige. Because this is his final contract year, the team will be evaluating whether to continue with the coach at the end of " + "this season. He'll remain on the hot seat throughout this year.");
            } else if (t.teamPrestige > ([t getCurrentHC].baselinePrestige + 10) && t.teamPrestige < teamList[(int)(teamList.count * 0.35)].teamPrestige) {
                //newsStories.get(0).add("Coaching Rising Star: " + teamList.get(i).HC.get(0).name + ">" + teamList.get(i).name + " head coach " + teamList.get(i).HC.get(0).name + " has been building a strong program and if he continues this path, he'll be on the top of the wishlist at a major program in the future.");
            }
        }
    } else if (currentWeek == 7) {
        for (Team *t in teamList) {
            if ([t getCurrentHC].baselinePrestige < t.teamPrestige && [t getCurrentHC].contractYear == [t getCurrentHC].contractLength && t.rankTeamPollScore > (100 - [t getCurrentHC].baselinePrestige)) {
                //newsStories.get(currentWeek + 1).add("Coaching Hot Seat: " + teamList.get(i).name + ">Head Coach " + teamList.get(i).HC.get(0).name + " future is in jeopardy at  " + teamList.get(i).name + ". The coach has failed to get out of the hot seat this season with disappointing losses and failing to live up to the school's standards.");
            }
        }
    }
}

-(int)getAvgCoachTalent {
    int avg = 0;
    for (Team *t in teamList) {
        if (t != userTeam && t.coaches.count > 0)
            avg += [t getCurrentHC].ratTalent;
    }
    return avg / (teamList.count - 1);
}

-(int)getAvgCoachDef {
    int avg = 0;
    for (Team *t in teamList) {
        if (t != userTeam && t.coaches.count > 0)
            avg += [t getCurrentHC].ratDef;
    }
    return avg / (teamList.count - 1);
}

-(int)getAvgCoachOff {
    int avg = 0;
    for (Team *t in teamList) {
        if (t != userTeam && t.coaches.count > 0)
            avg += [t getCurrentHC].ratOff;
    }
    return avg / (teamList.count - 1);
}

-(int)getAvgCoachDiscipline {
    int avg = 0;
    for (Team *t in teamList) {
        if (t != userTeam && t.coaches.count > 0)
            avg += [t getCurrentHC].ratDiscipline;
    }
    return avg / (teamList.count - 1);
}

-(int)getAvgYards {
    int average = 0;
    for (Team *t in teamList) {
        average += t.teamYards;
    }
    average = average / teamList.count;
    return average;
}

-(int)getAvgConfPrestige {
    int avgPrestige = 0;
    for (Conference *c in conferences) {
        [c updateConfPrestige];
    }
    for (Conference *c in conferences) {
        avgPrestige += c.confPrestige;
    }
    return avgPrestige / conferences.count;
}

@end
