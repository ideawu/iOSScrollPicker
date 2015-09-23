//
//  TestController.m
//  iOSScrollPicker
//
//  Created by ideawu on 9/23/15.
//  Copyright © 2015 ideawu. All rights reserved.
//

#import "TestController.h"
#import "ScrollPickerView.h"

@interface TestController ()<ScrollPickerViewDelegate>

@end

@implementation TestController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.view.backgroundColor = [UIColor whiteColor];
	self.navigationItem.title = @"Test";
    // Do any additional setup after loading the view.
	
	{
		ScrollPickerView *view = [[ScrollPickerView alloc] initWithFrame:CGRectMake(10, 10, 100, 300)];
		view.delegate = self;
		view.horizontalScrolling = NO;
		view.layer.borderWidth = 1;
		view.layer.borderColor = [UIColor grayColor].CGColor;
		[self.view addSubview:view];
	}
	{
		ScrollPickerView *view = [[ScrollPickerView alloc] initWithFrame:CGRectMake(10, 350, 300, 100)];
		view.delegate = self;
		view.horizontalScrolling = YES;
		view.layer.borderWidth = 1;
		view.layer.borderColor = [UIColor grayColor].CGColor;
		[self.view addSubview:view];
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (NSInteger)numberOfRows{
	NSLog(@"%s", __func__);
	return 20;
}

- (UITableViewCell *)cellForRowAtIndex:(NSUInteger)index{
	NSLog(@"%s %d", __func__, (int)index);
	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
	cell.textLabel.text = [NSString stringWithFormat:@"%d", (int)index];
	return cell;
}

- (CGFloat)heightForCellAtIndex:(NSUInteger)index{
	return 50;
}

@end
