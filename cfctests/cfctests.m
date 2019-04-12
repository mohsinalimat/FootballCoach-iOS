//
//  cfctests.m
//  cfctests
//
//  Created by Akshay Easwaran on 1/10/18.
//  Copyright © 2018 Akshay Easwaran. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "Player.h"
#import "Conference.h"
#import "Game.h"
#import "Team.h"
#import "Record.h"

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

@interface cfctests : XCTestCase
{
    League *currentLeague;
}
@end

@implementation cfctests

- (void)setUp {
    [super setUp];
    NSArray *firstNamePathFrags = [[HBSharedUtils firstNamesCSV] componentsSeparatedByString:@"."];
    NSString *firstNamePath = firstNamePathFrags[0];
    NSString *firstNameFullPath = [[NSBundle mainBundle] pathForResource:firstNamePath ofType:@"csv"];
    NSError *firstError;
    NSString *firstNameCSV = [NSString stringWithContentsOfFile:firstNameFullPath encoding:NSUTF8StringEncoding error:&firstError];
    if (firstError) {
        NSLog(@"[Name CSV Import] First name list retrieve error: %@", firstError);
    }
    
    NSArray *lastNamePathFrags = [[HBSharedUtils lastNamesCSV] componentsSeparatedByString:@"."];
    NSString *lastNamePath = lastNamePathFrags[0];
    NSString *lastNameFullPath = [[NSBundle mainBundle] pathForResource:lastNamePath ofType:@"csv"];
    NSError *lastError;
    NSString *lastNameCSV = [NSString stringWithContentsOfFile:lastNameFullPath encoding:NSUTF8StringEncoding error:&lastError];
    if (lastError) {
        NSLog(@"[Name CSV Import] Last name list retrieve error: %@", lastError);
    }
    currentLeague = [League newLeagueFromCSV:firstNameCSV lastNamesCSV:lastNameCSV];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testValidTeamCreated {
    Team *t = [Team newTeamWithName:@"Georgia Tech" abbreviation:@"GT" conference:@"ACC" league:currentLeague prestige:85 rivalTeam:@"GEO" state:@"Georgia"];
    XCTAssertNotNil(t.league, @"Team's league is nil");
    XCTAssertTrue([t.name isEqualToString:@"Georgia Tech"], @"Team name not set correctly");
    XCTAssertTrue([t.abbreviation isEqualToString:@"GT"], @"Team abbreviation not set correctly");
    XCTAssertTrue([t.conference isEqualToString:@"ACC"], @"Team conference not set correctly");
    XCTAssertTrue([t.rivalTeam isEqualToString:@"GEO"], @"Team rival not set correctly");
    XCTAssertTrue([t.state isEqualToString:@"Georgia"], @"Team state not set correctly");
    
    XCTAssertTrue(t.teamQBs.count == 2, @"Team did not create the expected number of QBs (2)");
    XCTAssertTrue(t.teamRBs.count == 4, @"Team did not create the expected number of RBs (4)");
    XCTAssertTrue(t.teamWRs.count == 6, @"Team did not create the expected number of WRs (6)");
    XCTAssertTrue(t.teamTEs.count == 2, @"Team did not create the expected number of TEs (2)");
    XCTAssertTrue(t.teamOLs.count == 10, @"Team did not create the expected number of OLs (10)");
    XCTAssertTrue(t.teamDLs.count == 8, @"Team did not create the expected number of DLs (8)");
    XCTAssertTrue(t.teamLBs.count == 6, @"Team did not create the expected number of LBs (6)");
    XCTAssertTrue(t.teamCBs.count == 6, @"Team did not create the expected number of CBs (6)");
    XCTAssertTrue(t.teamSs.count == 2, @"Team did not create the expected number of Ss (2)");
    XCTAssertTrue(t.teamKs.count == 2, @"Team did not create the expected number of Ks (2)");
}

- (void)testValidLeagueCreated {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    XCTAssertTrue(currentLeague.conferences.count == 6, @"League does not have 6 conferences");
    for (Conference *c in currentLeague.conferences) {
        XCTAssertTrue(c.confTeams.count == 10, @"Conference %@ does not have 10 teams", c.confName);
    }
    XCTAssertTrue(currentLeague.teamList.count == 60, @"League does not have 60 teams");
}

-(void)testValidGameCreated {
    Team *home = currentLeague.teamList[0];
    XCTAssertNotNil(home, @"Home team is nil");
    
    Team *away = currentLeague.teamList[1];
    XCTAssertNotNil(away, @"Away team is nil");
    
    Game *g = [Game newGameWithHome:home away:away];
    XCTAssertNotNil(g, @"game is nil");
    
    XCTAssertEqual(g.HomeQBStats.count, 10, @"Game HomeQBStats don't have 10 spaces");
    XCTAssertEqual(g.HomeRB1Stats.count, 4, @"Game HomeRB1Stats don't have 4 spaces");
    XCTAssertEqual(g.HomeRB2Stats.count, 4, @"Game HomeRB2Stats don't have 4 spaces");
    XCTAssertEqual(g.HomeWR1Stats.count, 6, @"Game HomeWR1Stats don't have 6 spaces");
    XCTAssertEqual(g.HomeWR2Stats.count, 6, @"Game HomeWR2Stats don't have 6 spaces");
    XCTAssertEqual(g.HomeWR3Stats.count, 6, @"Game HomeWR3Stats don't have 6 spaces");
    XCTAssertEqual(g.HomeTEStats.count, 6, @"Game HomeTEStats don't have 6 spaces");
    XCTAssertEqual(g.HomeKStats.count, 6, @"Game HomeKStats don't have 6 spaces");
    
    XCTAssertEqual(g.AwayQBStats.count, 10, @"Game AwayQBStats don't have 10 spaces");
    XCTAssertEqual(g.AwayRB1Stats.count, 4, @"Game AwayRB1Stats don't have 4 spaces");
    XCTAssertEqual(g.AwayRB2Stats.count, 4, @"Game AwayRB2Stats don't have 4 spaces");
    XCTAssertEqual(g.AwayWR1Stats.count, 6, @"Game AwayWR1Stats don't have 6 spaces");
    XCTAssertEqual(g.AwayWR2Stats.count, 6, @"Game AwayWR2Stats don't have 6 spaces");
    XCTAssertEqual(g.AwayWR3Stats.count, 6, @"Game AwayWR3Stats don't have 6 spaces");
    XCTAssertEqual(g.AwayTEStats.count, 6, @"Game AwayTEStats don't have 6 spaces");
    XCTAssertEqual(g.AwayKStats.count, 6, @"Game AwayKStats don't have 6 spaces");
    
    [self measureBlock:^{
        [g playGame];
    }];
    
    XCTAssertLessThan([g.HomeQBStats[3] intValue], 5, @"HomeQB threw %d INT, more than expected (5)", [g.HomeQBStats[3] intValue]);
    XCTAssertLessThan([g.AwayQBStats[3] intValue], 5, @"AwayQB threw %d INT, more than expected (5)", [g.AwayQBStats[3] intValue]);
    
    XCTAssertTrue(g.homeStarters.count == 24);
    XCTAssertTrue(g.awayStarters.count == 24);
    

}

//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end
