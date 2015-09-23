//
//  ScrollPickerView.h
//  iOSScrollPicker
//
//  Created by ideawu on 9/23/15.
//  Copyright © 2015 ideawu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ScrollPickerView;

@protocol ScrollPickerViewDelegate <NSObject>
- (NSInteger)numberOfRows;
- (CGFloat)heightForCellAtIndex:(NSUInteger)index;
- (UITableViewCell *)cellForRowAtIndex:(NSUInteger)index;
@optional
- (void)maySelectIndex:(NSUInteger)index;
- (void)didSelectIndex:(NSUInteger)index;
@end


@interface ScrollPickerView : UIView<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) UIView *headerView;
@property (nonatomic) UIView *footerView;

@property (nonatomic) id <ScrollPickerViewDelegate> delegate;

@property (nonatomic) BOOL horizontalScrolling;
@property (nonatomic) NSUInteger pickLineOffset; // rename anchorOffset

@property (nonatomic) BOOL debug;

@end
