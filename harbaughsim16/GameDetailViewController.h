//
//  GameDetailViewController.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/18/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCTableViewController.h"
@class Game;

@interface GameDetailViewController : FCTableViewController
-(instancetype)initWithGame:(Game*)game;
@end
