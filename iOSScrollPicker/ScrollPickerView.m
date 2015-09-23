//
//  ScrollPickerView.m
//  iOSScrollPicker
//
//  Created by ideawu on 9/23/15.
//  Copyright © 2015 ideawu. All rights reserved.
//

#import "ScrollPickerView.h"

@interface ScrollPickerView (){
	BOOL _inited;
	BOOL _debug;
}

@end

@implementation ScrollPickerView

- (void)layoutSubviews {
	if(!_inited){
		_inited = YES;
		[self construct];
	}
	[super layoutSubviews];
}

- (void)construct{
	_debug = YES;
	
	_tableView = [[UITableView alloc] initWithFrame:self.bounds];
	_tableView.backgroundColor = [UIColor clearColor];
	_tableView.delegate = self;
	_tableView.dataSource = self;
	_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	_tableView.showsVerticalScrollIndicator = NO;
	_tableView.showsHorizontalScrollIndicator = NO;

	if(_horizontalScrolling){
		_tableView.transform = CGAffineTransformMakeRotation(-M_PI_2);
		_tableView.frame = self.bounds;
	}

	NSUInteger offset = _pickLineOffset;
	if(offset == 0){
		if(_horizontalScrolling){
			offset = self.frame.size.width / 2;
		}else{
			offset = self.frame.size.height / 2;
		}
	}
	CGFloat top = offset - [self.delegate heightForCellAtIndex:0] / 2;
	CGFloat bottom = offset - [self.delegate heightForCellAtIndex:([self.delegate numberOfRows] - 1)] / 2;
	_tableView.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);

	[self addSubview:_tableView];
}

#pragma mark Table view methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [_delegate numberOfRows];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return [self.delegate heightForCellAtIndex:indexPath.row];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [_delegate cellForRowAtIndex:indexPath.row];
	//cell.selectionStyle = UITableViewCellSelectionStyleNone;
	if (self.horizontalScrolling) {
		cell.transform = CGAffineTransformMakeRotation(M_PI_2);
	}
	
	if(_debug){
		cell.layer.borderWidth = 0.5;
		cell.layer.borderColor = [UIColor redColor].CGColor;
	}
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[_tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionMiddle animated:YES];
	NSLog(@"select %d", (int)indexPath.row);
}

#pragma mark Scroll view methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	[self scrollToTheSelectedCell];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	if (!decelerate) {
		[self scrollToTheSelectedCell];
	}
}

- (NSInteger)maySelectedIndex{
	NSUInteger offset = _pickLineOffset;
	if(offset == 0){
		if(_horizontalScrolling){
			offset = self.frame.size.width / 2;
		}else{
			offset = self.frame.size.height / 2;
		}
	}
	CGPoint selectionPoint = CGPointMake(0, offset + _tableView.contentOffset.y);
	
	NSArray *visibleCells = [_tableView visibleCells];
	NSArray<NSIndexPath *> *indexPathArray = _tableView.indexPathsForVisibleRows;
	NSEnumerator *iter = [indexPathArray objectEnumerator];
	for(UITableViewCell *cell in visibleCells){
		//NSLog(@"#%@ %@ %@", cell.textLabel.text, NSStringFromCGPoint(cell.frame.origin), NSStringFromCGPoint(selectionPoint));
		NSIndexPath *path = [iter nextObject];
		if(CGRectContainsPoint(cell.frame, selectionPoint)){
			return path.row;
		}
	}
	return -1;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	if(!scrollView.dragging){
		return;
	}
	NSInteger index = [self maySelectedIndex];
	if(index >= 0){
		//NSLog(@"may select %d", (int)index);
		NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
		[_tableView selectRowAtIndexPath:path animated:NO scrollPosition:UITableViewScrollPositionNone];
	}
}

- (void)scrollToTheSelectedCell {
	NSInteger index = [self maySelectedIndex];
	if(index >= 0){
		NSLog(@"select %d", (int)index);
		NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
		[_tableView selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionMiddle];
	}
}


@end
