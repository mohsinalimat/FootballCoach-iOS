//
//  NewsUpdatesViewController.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 5/5/19.
//  Copyright © 2019 Akshay Easwaran. All rights reserved.
//

#import "NewsUpdatesViewController.h"

#import "League.h"
#import "Team.h"

@interface NewsUpdatesViewController ()
{
    NSArray *newsStories;
    NSString *newsCategory;
}
@end

@implementation NewsUpdatesViewController

-(instancetype)initWithStories:(NSArray<NSString *> *)stories title:(NSString *)title {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        newsStories = stories;
        newsCategory = title;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"News - %@", newsCategory];
    self.view.backgroundColor = [HBSharedUtils styleColor];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return newsStories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        [cell.textLabel setNumberOfLines:0];
        [cell setBackgroundColor:[UIColor whiteColor]];
        [cell.textLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.textLabel setFont:[UIFont systemFontOfSize:MEDIUM_FONT_SIZE]];
        [cell.detailTextLabel setFont:[UIFont systemFontOfSize:SMALL_FONT_SIZE]];
    }
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:newsStories[indexPath.row] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:MEDIUM_FONT_SIZE]}];
    NSRange firstLine = [attString.string rangeOfString:@"\n"];
    [attString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:LARGE_FONT_SIZE weight:UIFontWeightMedium] range:NSMakeRange(0, firstLine.location)];
    if ([HBSharedUtils currentLeague].userTeam.abbreviation != nil && [attString.string containsString:[HBSharedUtils currentLeague].userTeam.abbreviation]) {
        [attString addAttribute:NSForegroundColorAttributeName value:[HBSharedUtils styleColor] range:NSMakeRange(0, firstLine.location)];
    } else {
        [attString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, firstLine.location)];
    }
    
    [cell.textLabel setAttributedText:attString];
    [cell.textLabel sizeToFit];
    [cell.detailTextLabel setText:newsCategory];
    
    
    return cell;
}


@end
