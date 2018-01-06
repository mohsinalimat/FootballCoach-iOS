//
//  AEScrollingToolbarView.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 12/31/17.
//  Copyright © 2017 Akshay Easwaran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AEScrollingToolbarView : UIView <UIScrollViewDelegate>
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableArray<UIView*> *pages;
@property (strong, nonatomic) UIPageControl *pageControl;
-(void)addPage:(UIView *)pg;
-(void)moveToPage:(NSInteger)pg;
@end
