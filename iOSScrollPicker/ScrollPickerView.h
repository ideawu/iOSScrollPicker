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
@end


@interface ScrollPickerView : UIView<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) id <ScrollPickerViewDelegate> delegate;

@property (nonatomic) BOOL horizontalScrolling;
@property (nonatomic) NSUInteger pickLineOffset; // rename anchorOffset

@end
