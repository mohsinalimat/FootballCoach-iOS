//
//  PrestigeHistoryViewController.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 1/4/18.
//  Copyright © 2018 Akshay Easwaran. All rights reserved.
//

#import "PrestigeHistoryViewController.h"
#import "HBSharedUtils.h"

@interface PrestigeHistoryViewController ()
{
    ChartData *lineChartData;
    BOOL _drawingValues;
}
@end

@implementation PrestigeHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    lineChartData = [[LineChartData alloc] initWithDataSets:self.dataSets];
    [lineChartData setDrawValues:NO];
    _drawingValues = NO;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"show"] style:UIBarButtonItemStylePlain target:self action:@selector(toggleDrawingDataValues)];
    
    self.chartView.xAxis.labelPosition = XAxisLabelPositionBottom;
    
    self.chartView.rightAxis.enabled = NO;
    self.chartView.chartDescription.enabled = NO;
    self.chartView.legend.enabled = NO;
    
    self.chartView.xAxis.drawGridLinesEnabled = NO;
    self.chartView.xAxis.labelTextColor = [UIColor lightTextColor];
    self.chartView.xAxis.axisLineColor = [UIColor whiteColor];
    self.chartView.xAxis.gridColor = [UIColor lightTextColor];
    
    self.chartView.leftAxis.drawGridLinesEnabled = NO;
    self.chartView.leftAxis.labelTextColor = [UIColor lightTextColor];
    self.chartView.leftAxis.axisLineColor = [UIColor whiteColor];
    self.chartView.leftAxis.gridColor = [UIColor lightTextColor];
    
    self.chartView.drawMarkers = YES;
    self.chartView.marker = [[ChartMarkerView alloc] init];
    
    if ([self.title containsString:@"Coach Score"]) {
        CoachScoreYearMarkerView *marker = [[CoachScoreYearMarkerView alloc]
                                          initWithColor: [UIColor colorWithWhite:255/255. alpha:1.0]
                                          font: [UIFont systemFontOfSize:12.0]
                                          textColor: [HBSharedUtils styleColor]
                                          insets: UIEdgeInsetsMake(8.0, 8.0, 20.0, 8.0)
                                          xAxisValueFormatter: self.chartView.xAxis.valueFormatter];
        marker.chartView = self.chartView;
        marker.minimumSize = CGSizeMake(80.f, 40.f);
        self.chartView.marker = marker;
    } else {
        PrestigeYearMarkerView *marker = [[PrestigeYearMarkerView alloc]
                                          initWithColor: [UIColor colorWithWhite:255/255. alpha:1.0]
                                          font: [UIFont systemFontOfSize:12.0]
                                          textColor: [HBSharedUtils styleColor]
                                          insets: UIEdgeInsetsMake(8.0, 8.0, 20.0, 8.0)
                                          xAxisValueFormatter: self.chartView.xAxis.valueFormatter];
        marker.chartView = self.chartView;
        marker.minimumSize = CGSizeMake(80.f, 40.f);
        self.chartView.marker = marker;
    }
    
    [self.chartView setData:lineChartData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)toggleDrawingDataValues {
    if (_drawingValues) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"show"] style:UIBarButtonItemStylePlain target:self action:@selector(toggleDrawingDataValues)];
    } else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"hide"] style:UIBarButtonItemStylePlain target:self action:@selector(toggleDrawingDataValues)];
    }
    _drawingValues = !_drawingValues;
    [lineChartData setDrawValues:_drawingValues];
    [self.chartView setData:lineChartData];
}

-(instancetype)initWithDataSets:(NSArray<ChartDataSet *> *)sets {
    self = [self initWithNibName:@"PrestigeHistoryViewController" bundle:nil];
    if (self) {
        self.dataSets = sets;
    }
    return self;
}

@end
