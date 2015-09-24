//
//  ScrollPickerView.h
//  iOSScrollPicker
//  https://github.com/ideawu/iOSScrollPicker
//
//  Created by ideawu on 9/23/15.
//  Copyright © 2015 ideawu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ScrollPickerView;

@protocol ScrollPickerViewDelegate <NSObject>
- (NSInteger)numberOfRows;
- (CGFloat)heightForCellAtIndex:(NSUInteger)index;
- (UIView *)viewForRowAtIndex:(NSUInteger)index;
@optional
- (void)maySelectIndex:(NSUInteger)index;
- (void)didSelectIndex:(NSUInteger)index;
@end


@interface ScrollPickerView : UIView<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) id <ScrollPickerViewDelegate> delegate;

@property (nonatomic) UIView *headerView;
@property (nonatomic) UIView *footerView;

@property (nonatomic) BOOL horizontalScrolling;
// default: the middle of the view
@property (nonatomic) CGFloat anchorOffset;
@property (nonatomic) NSUInteger selectedIndex;

@property (nonatomic) BOOL debug;

@end
