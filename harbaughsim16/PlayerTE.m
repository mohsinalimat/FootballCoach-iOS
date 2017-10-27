//
//  PlayerTE.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 10/27/17.
//  Copyright © 2017 Akshay Easwaran. All rights reserved.
//

#import "PlayerTE.h"

@implementation PlayerTE
+(instancetype)newTEWithName:(NSString *)nm team:(Team *)t year:(int)yr potential:(int)pot footballIQ:(int)iq runBlk:(int)runBlk catch:(int)cat speed:(int)spd eva:(int)eva dur:(int)dur {
    PlayerTE *te = [PlayerTE newWRWithName:nm team:t year:yr potential:pot footballIQ:iq catch:cat speed:spd eva:eva dur:dur];
    te.ratTERunBlk = runBlk;
    te.ratOvr = (cat * 2 + runBlk * 2 + eva) / 5;
    te.position = @"TE";
    return te;
}

+(instancetype)newTEWithName:(NSString*)nm year:(int)yr stars:(int)stars team:(Team*)t {
    PlayerTE *te = [PlayerTE newWRWithName:nm year:yr stars:stars team:t];
    te.ratTERunBlk = (int) (60 + yr * 5 + stars * 5 - 25 * [HBSharedUtils randomValue]);
    te.ratOvr = (te.ratRecCat * 2 + te.ratTERunBlk * 2 + te.ratRecEva) / 5;
    te.position = @"TE";
    return te;
}

-(void)advanceSeason {
    int oldOvr = self.ratOvr;
    if (self.hasRedshirt) {
        self.ratFootIQ += (int)([HBSharedUtils randomValue]*(self.ratPot - 25))/10;
        self.ratRecCat += (int)([HBSharedUtils randomValue]*(self.ratPot - 25))/10;
        self.ratTERunBlk += (int)([HBSharedUtils randomValue]*(self.ratPot - 25))/10;
        self.ratRecSpd += (int)([HBSharedUtils randomValue]*(self.ratPot - 25))/10;
        self.ratRecEva += (int)([HBSharedUtils randomValue]*(self.ratPot - 25))/10;
        if ([HBSharedUtils randomValue]*100 < self.ratPot ) {
            //breakthrough
            self.ratRecCat += (int)([HBSharedUtils randomValue]*(self.ratPot - 30))/10;
            self.ratTERunBlk += (int)([HBSharedUtils randomValue]*(self.ratPot - 30))/10;
            self.ratRecSpd += (int)([HBSharedUtils randomValue]*(self.ratPot - 30))/10;
            self.ratRecEva += (int)([HBSharedUtils randomValue]*(self.ratPot - 30))/10;
        }
    } else {
        self.ratFootIQ += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 35))/10;
        self.ratRecCat += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 35))/10;
        self.ratTERunBlk += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 35))/10;
        self.ratRecSpd += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 35))/10;
        self.ratRecEva += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 35))/10;
        if ([HBSharedUtils randomValue]*100 < self.ratPot ) {
            //breakthrough
            self.ratRecCat += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 40))/10;
            self.ratTERunBlk += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 40))/10;
            self.ratRecSpd += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 40))/10;
            self.ratRecEva += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 40))/10;
        }
    }
    self.ratOvr = (self.ratRecCat*2 + self.ratTERunBlk + self.ratRecEva)/4;
    self.ratImprovement = self.ratOvr - oldOvr;
    
    self.statsTargets = 0;
    self.statsReceptions = 0;
    self.statsRecYards = 0;
    self.statsTD = 0;
    self.statsDrops = 0;
    self.statsFumbles = 0;
    
    self.year++;
    self.gamesPlayedSeason = 0;
    self.isHeisman = NO;
    self.isAllAmerican = NO;
    self.isAllConference = NO;
    self.injury = nil;
    if (self.hasRedshirt) {
        self.hasRedshirt = NO;
        self.wasRedshirted = YES;
    }
}
@end
