//
//  GameDetailViewController.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/18/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "GameDetailViewController.h"
#import "Game.h"
#import "Team.h"
#import "Player.h"

#import "PlayerQB.h"
#import "PlayerRB.h"
#import "PlayerWR.h"
#import "PlayerK.h"
#import "PlayerOL.h"
#import "PlayerF7.h"
#import "PlayerCB.h"
#import "PlayerS.h"

#import "HexColors.h"

@interface HBGameDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *homeLabel;
@property (weak, nonatomic) IBOutlet UILabel *awayLabel;
@property (weak, nonatomic) IBOutlet UILabel *homeScore;
@property (weak, nonatomic) IBOutlet UILabel *awayScore;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@end

@implementation HBGameDetailCell
@end

@interface GameDetailViewController ()
{
    Game *selectedGame;
    IBOutlet HBGameDetailCell *gameDetailCell;
    
    
    //game detail cell
    
    //game stats
        //home qb
        //away qb
    
        //home rbs (2)
        //away rbs (2)
    
        //home WRs
        //away WRs
    
        //home K
        //away K
}
@end

@implementation GameDetailViewController

-(instancetype)initWithGame:(Game *)game {
    self = [super init];
    if(self) {
        selectedGame = game;
    }
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Game";
    NSString *homeRank = @"";
    if (selectedGame.homeTeam.rankTeamPollScore < 26) {
        homeRank = [NSString stringWithFormat:@"#%d ",selectedGame.homeTeam.rankTeamPollScore];
    }
    [gameDetailCell.homeLabel setText:[NSString stringWithFormat:@"%@%@",homeRank,selectedGame.homeTeam.name]];
    NSString *awayRank = @"";
    if (selectedGame.awayTeam.rankTeamPollScore < 26) {
        awayRank = [NSString stringWithFormat:@"#%d ",selectedGame.awayTeam.rankTeamPollScore];
    }
    [gameDetailCell.awayLabel setText:[NSString stringWithFormat:@"%@%@",awayRank,selectedGame.awayTeam.name]];
    [gameDetailCell.homeScore setText:[NSString stringWithFormat:@"%d",selectedGame.homeScore]];
    [gameDetailCell.awayScore setText:[NSString stringWithFormat:@"%d",selectedGame.awayScore]];
    [gameDetailCell.nameLabel setText:selectedGame.gameName];
    if (selectedGame.hasPlayed) {
        [gameDetailCell.timeLabel setText:@"Final"];
    } else {
        [gameDetailCell.timeLabel setText:@"TBP"];
    }
    
    [self.view setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"#009740"]];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 175;
    } else {
        return UITableViewAutomaticDimension;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return @"Quarterbacks";
    } else if (section == 2) {
        return @"Running Backs";
    } else if (section == 3) {
        return @"Wide Receivers";
    } else if (section == 4) {
        return @"Kickers";
    } else {
        return nil;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 2;
    } else if (section == 2) {
        return 4;
    } else if (section == 3) {
        return 6;
    } else {
        return 2;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return gameDetailCell;
    } else {
        UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
            [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        NSString *abbrev = @"";
        Player *player;
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                abbrev = selectedGame.homeTeam.abbreviation;
                player = [selectedGame.homeTeam getQB:0];
            } else {
                abbrev = selectedGame.awayTeam.abbreviation;
                player = [selectedGame.awayTeam getQB:0];
            }
        } else if (indexPath.section == 2) {
            if (indexPath.row == 0) {
                abbrev = selectedGame.homeTeam.abbreviation;
                player = [selectedGame.homeTeam getRB:0];
            } else if (indexPath.row == 1) {
                abbrev = selectedGame.homeTeam.abbreviation;
                player = [selectedGame.homeTeam getRB:1];
            } else if (indexPath.row == 2) {
                abbrev = selectedGame.awayTeam.abbreviation;
                player = [selectedGame.awayTeam getRB:0];
            } else {
                abbrev = selectedGame.awayTeam.abbreviation;
                player = [selectedGame.awayTeam getRB:1];
            }
        } else if (indexPath.section == 3) {
            if (indexPath.row == 0) {
                abbrev = selectedGame.homeTeam.abbreviation;
                player = [selectedGame.homeTeam getWR:0];
            } else if (indexPath.row == 1) {
                abbrev = selectedGame.homeTeam.abbreviation;
                player = [selectedGame.homeTeam getWR:1];
            } else if (indexPath.row == 2) {
                abbrev = selectedGame.homeTeam.abbreviation;
                player = [selectedGame.homeTeam getWR:2];
            } else if (indexPath.row == 3) {
                abbrev = selectedGame.awayTeam.abbreviation;
                player = [selectedGame.awayTeam getWR:0];
            } else if (indexPath.row == 4) {
                abbrev = selectedGame.awayTeam.abbreviation;
                player = [selectedGame.awayTeam getWR:1];
            } else {
                abbrev = selectedGame.awayTeam.abbreviation;
                player = [selectedGame.awayTeam getWR:2];
            }
        } else {
            if (indexPath.row == 0) {
                abbrev = selectedGame.homeTeam.abbreviation;
                player = [selectedGame.homeTeam getK:0];
            } else {
                abbrev = selectedGame.awayTeam.abbreviation;
                player = [selectedGame.awayTeam getK:0];
            }
        }
        
        [cell.textLabel setText:[player getInitialName]];
        [cell.detailTextLabel setText:abbrev];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        //do nothing
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            
        } else {
            
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            
        } else if (indexPath.row == 1) {
            
        } else if (indexPath.row == 2) {
            
        } else {
            
        }
    } else if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            
        } else if (indexPath.row == 1) {
            
        } else if (indexPath.row == 2) {
            
        } else if (indexPath.row == 3) {
            
        } else if (indexPath.row == 4) {
            
        } else {
            
        }
    } else {
        if (indexPath.row == 0) {
            
        } else {
            
        }
    }
}
@end
