//
//  PrestigeHistoryViewController.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 1/4/18.
//  Copyright © 2018 Akshay Easwaran. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Charts;

@interface PrestigeHistoryViewController : UIViewController

-(instancetype)initWithDataSets:(NSArray<ChartDataSet *> *)sets;

@property (strong, nonatomic) NSArray<ChartDataSet *> *dataSets;
@property (weak, nonatomic) IBOutlet LineChartView *chartView;
@end
