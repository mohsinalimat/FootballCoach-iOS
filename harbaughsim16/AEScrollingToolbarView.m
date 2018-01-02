//
//  AEScrollingToolbarView.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 12/31/17.
//  Copyright © 2017 Akshay Easwaran. All rights reserved.
//

#import "AEScrollingToolbarView.h"
#import "HBSharedUtils.h"

@implementation AEScrollingToolbarView

-(id)initWithFrame:(CGRect)frame {
    if (IS_IPHONE_X) {
        frame.size.height += 20;
    }
    
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)];
    if (self) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 14)];
        [self.scrollView setDelegate:self];
        [self.scrollView setPagingEnabled:YES];
        [self.scrollView setBackgroundColor:[UIColor whiteColor]];
        [self.scrollView setShowsHorizontalScrollIndicator:NO];
        [self addSubview:self.scrollView];
        
        self.pages = [NSMutableArray array];
        
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        CGFloat pageCenterPoint = self.scrollView.frame.size.height + 2;
        if (IS_IPHONE_X) {
            pageCenterPoint -= 10;
        }
        self.pageControl = [[UIPageControl alloc] init];
        self.pageControl.center = CGPointMake(self.center.x, pageCenterPoint);
        self.pageControl.numberOfPages = self.pages.count;
        self.pageControl.tintColor = self.tintColor;
        [self addSubview:self.pageControl];
    }
    return self;
}

-(void)addPage:(UIView *)pg {
    [pg setFrame:CGRectMake(self.scrollView.frame.size.width * self.pages.count, 0, pg.frame.size.width, self.scrollView.frame.size.height)];
    [self.scrollView addSubview:pg];
    [self.pages addObject:pg];
    [self.pageControl setNumberOfPages:self.pages.count];
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width * self.pages.count, self.scrollView.frame.size.height)];
}

-(void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    [self.scrollView setBackgroundColor:backgroundColor];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int pageNumber = (int)round(scrollView.contentOffset.x / scrollView.frame.size.width);
    self.pageControl.currentPage = pageNumber;
}

-(void)moveToPage:(NSInteger)pg {
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width * pg, 0) animated:YES];
    self.pageControl.currentPage = pg;
}

@end
