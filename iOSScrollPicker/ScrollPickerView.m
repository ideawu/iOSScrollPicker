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
}

@end

@implementation ScrollPickerView

- (UITableView *)tableView{
	if(!_tableView){
		_tableView = [[UITableView alloc] initWithFrame:self.bounds];
	}
	return _tableView;
}

- (void)layoutSubviews {
	if(!_inited){
		_inited = YES;
		[self construct];
	}
	[super layoutSubviews];
}

- (void)construct{
	if(!_tableView){
		_tableView = [[UITableView alloc] initWithFrame:self.bounds];
	}
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

	if(_headerView){
		_tableView.tableHeaderView = _headerView;
	}
	if(_footerView){
		_tableView.tableFooterView = _footerView;
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
	if(_tableView.tableHeaderView){
		top -= _tableView.tableHeaderView.frame.size.height;
	}
	CGFloat bottom = offset - [self.delegate heightForCellAtIndex:([self.delegate numberOfRows] - 1)] / 2;
	if(_tableView.tableFooterView){
		bottom -= _tableView.tableFooterView.frame.size.height;
	}
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
	if(!_debug){
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
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
	//[_tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionMiddle animated:YES];
	[self scrollToAnchorAtIndex:indexPath.row];
	//NSLog(@"select %d", (int)indexPath.row);
	if([self.delegate respondsToSelector:@selector(didSelectIndex:)]){
		[self.delegate didSelectIndex:indexPath.row];
	}
}

#pragma mark Scroll view methods

- (void)scrollToTheSelectedCell {
	NSInteger index = [self maySelectedIndex];
	if(index >= 0){
		[self scrollToAnchorAtIndex:index];
	}
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	[self scrollToTheSelectedCell];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	if (!decelerate) {
		[self scrollToTheSelectedCell];
	}
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	if(!scrollView.dragging){
		return;
	}
	NSInteger index = [self maySelectedIndex];
	if(index >= 0){
		//NSLog(@"may select %d", (int)index);
		if([self.delegate respondsToSelector:@selector(maySelectIndex:)]){
			[self.delegate maySelectIndex:index];
		}
		NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
		[_tableView selectRowAtIndexPath:path animated:NO scrollPosition:UITableViewScrollPositionNone];
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
	NSArray *indexPathArray = _tableView.indexPathsForVisibleRows;
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

- (void)scrollToAnchorAtIndex:(NSUInteger)index{
	//NSLog(@"select %d", (int)index);
	if([self.delegate respondsToSelector:@selector(didSelectIndex:)]){
		[self.delegate didSelectIndex:index];
	}
	//NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
	//[_tableView selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionMiddle];
	
	CGFloat y = 0;
	for(NSUInteger i=0; i<index; i++){
		y += [self.delegate heightForCellAtIndex:i];
	}
	if(_tableView.tableHeaderView){
		y += _tableView.tableHeaderView.frame.size.height;
	}
	NSUInteger offset = _pickLineOffset;
	if(offset == 0){
		if(_horizontalScrolling){
			offset = self.frame.size.width / 2;
		}else{
			offset = self.frame.size.height / 2;
		}
	}
	CGPoint contentOffset = _tableView.contentOffset;
	contentOffset.y = y - offset + [self.delegate heightForCellAtIndex:index]/2;
	//NSLog(@"%f => %f", _tableView.contentOffset.y, y);
	[UIView animateWithDuration:0.2 animations:^{
		_tableView.contentOffset = contentOffset;
	}];
}


@end
