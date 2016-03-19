//
//  IntroViewController.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/18/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "IntroViewController.h"
#import "TeamSelectionViewController.h"
#import "League.h"
#import "Team.h"
#import "AppDelegate.h"

NSString *leaguePlayerNames = @"Tim, James, John, Robert, Michael, William, David, Richard, Charles, Joseph, Thomas, Daniel, Paul, Mark, Donald, George, Steven, Edward, Brian, Ronald, Anthony, Kevin, Jason, Johnson, Matthew, Jose, Larry, Frank, Scott, Eric, Andrew, Raymond, Joshua, Jerry, Dennis, Walter, Patrick, Peter, Harold, Douglas, Henry, Carl, Arthur, Ryan, Joe, Juan, Jack, Albert, Justin, Terry, Gerald, Samuel, Ralph, Roy, Ben, Bruce, Adam, Harry, Fred, Wayne, Billy, Jeremy, Aaron, Carlos, Russell, Bobby, Alan, Jimmy, Lebron, Kobe, Brady, Manning, Peyton, Eli, Beckham, Draymond, Jordan, Derrick, Dirk, Tim, Adrian, Ha-Ha, Hunter, Dick, Blewitt, Thor, Andre, Benton, Alwan, Carnell, Clayton, Clifton, Dajon, Damon, Damarco, Damon, Cordell, Darik, Delroy, Deon, Dequain, Dexter, Dontrell, Hakeem, Jamaar, Jahquil, Jarvis, Javan, Kaynard, Kendrick, Keon, Lamar, Lavon, Lucius, Luther, Malik, Marvin, Odell, Omari, Omarr, Orlando, Otis, Perry, Quinton, Randall, Reggie, Rodell, Rondall, Rufus, Shawnte, Spike, Talin, Trayvon, Tupac, Tre, Tyree, Tyrell, Tyronne, Umar, Vashan, Wendell, Wardell, Theo";


@implementation IntroViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
}


-(IBAction)newDynasty {
    //push team selection on to stack
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController pushViewController:[[TeamSelectionViewController alloc] initWithLeague:[League newLeagueFromCSV:leaguePlayerNames]] animated:YES];
}


@end
