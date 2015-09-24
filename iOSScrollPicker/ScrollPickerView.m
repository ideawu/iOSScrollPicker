//
//  ScrollPickerView.m
//  iOSScrollPicker
//  https://github.com/ideawu/iOSScrollPicker
//
//  Created by ideawu on 9/23/15.
//  Copyright © 2015 ideawu. All rights reserved.
//

#import "ScrollPickerView.h"

@interface ScrollPickerView (){
	BOOL _inited;
}
@property (nonatomic) UITableView *tableView;
@end

@implementation ScrollPickerView

- (UITableView *)tableView{
	if(!_tableView){
		_tableView = [[UITableView alloc] initWithFrame:self.bounds];
	}
	return _tableView;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	if(!_inited){
		[self construct];
		_inited = YES;
	}
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
	
	
	CGFloat offset = self.anchorOffset;
	CGFloat top = offset - [self.delegate heightForCellAtIndex:0] / 2;
	if(_tableView.tableHeaderView){
		top -= _tableView.tableHeaderView.frame.size.height;
	}
	CGFloat bottom = 0;
	if(_horizontalScrolling){
		bottom = self.frame.size.width - offset - [self.delegate heightForCellAtIndex:([self.delegate numberOfRows] - 1)] / 2;
	}else{
		bottom = self.frame.size.height - offset - [self.delegate heightForCellAtIndex:([self.delegate numberOfRows] - 1)] / 2;
	}
	if(_tableView.tableFooterView){
		bottom -= _tableView.tableFooterView.frame.size.height;
	}

	_tableView.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);
	
	[self addSubview:_tableView];
	[self scrollToAnchorAtIndex:_selectedIndex];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex{
	[self scrollToAnchorAtIndex:selectedIndex];
}

- (CGFloat)anchorOffset{
	CGFloat offset = _anchorOffset;
	if(offset == 0){
		offset = self.tableView.frame.size.width / 2;
	}
	return offset;
}

#pragma mark Table view methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [_delegate numberOfRows];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return [self.delegate heightForCellAtIndex:indexPath.row];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *tag = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tag];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tag];
	}
	if(!_debug){
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	if(cell.contentView.subviews.count > 0){
		[cell.contentView.subviews[0] removeFromSuperview];
	}

	UIView *view = [_delegate viewForRowAtIndex:indexPath.row];
	if (self.horizontalScrolling) {
		CGRect frame = view.frame;
		view.transform = CGAffineTransformMakeRotation(M_PI_2);
		view.frame = frame;
	}
	[cell.contentView addSubview:view];
	
	if(_debug){
		cell.layer.borderWidth = 0.5;
		cell.layer.borderColor = [UIColor redColor].CGColor;
	}
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self scrollToAnchorAtIndex:indexPath.row];
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
	CGFloat offset = self.anchorOffset;
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
	if(index >= [self.delegate numberOfRows]){
		return;
	}
	//NSLog(@"select %d", (int)index);
	if(!_inited || index != _selectedIndex){
		if([self.delegate respondsToSelector:@selector(didSelectIndex:)]){
			[self.delegate didSelectIndex:index];
		}
	}
	_selectedIndex = index;
	NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
	[_tableView selectRowAtIndexPath:path animated:NO scrollPosition:UITableViewScrollPositionNone];
	
	CGFloat y = 0;
	for(NSUInteger i=0; i<index; i++){
		y += [self.delegate heightForCellAtIndex:i];
	}
	if(_tableView.tableHeaderView){
		y += _tableView.tableHeaderView.frame.size.height;
	}
	CGFloat offset = self.anchorOffset;
	CGPoint contentOffset = _tableView.contentOffset;
	contentOffset.y = y - offset + [self.delegate heightForCellAtIndex:index]/2;
	//NSLog(@"%f => %f", _tableView.contentOffset.y, y);
	[UIView animateWithDuration:0.2 animations:^{
		_tableView.contentOffset = contentOffset;
	}];
}


@end
