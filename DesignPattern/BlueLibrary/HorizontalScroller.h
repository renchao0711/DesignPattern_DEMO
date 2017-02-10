//
//  HorizontalScroller.h
//  BlueLibrary
//
//  Created by 任超 on 17/2/9.
//  Copyright © 2017年 Eli Ganem. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HorizontalScroller;

@protocol HorizontalScrollerDelegate <NSObject>

@required

-(NSInteger)numberOfViewForHorizontalScroller:(HorizontalScroller *)scroller;

-(UIView *)horizontalScroller:(HorizontalScroller *)scroller viewAtIndex:(int)index;

-(void)horizontalScroller:(HorizontalScroller *)scroller clickedViewAtIndex:(int)index;

@optional

-(NSInteger)initialViewIndexForHorizontalScroller:(HorizontalScroller *)scroller;

@end

@interface HorizontalScroller : UIView

@property (assign) id<HorizontalScrollerDelegate> delegate;

-(void)reload;

@end
