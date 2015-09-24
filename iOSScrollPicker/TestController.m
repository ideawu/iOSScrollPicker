//
//  TestController.m
//  iOSScrollPicker
//  https://github.com/ideawu/iOSScrollPicker
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

	CGFloat screen_width = [UIScreen mainScreen].bounds.size.width;
	
	{
		ScrollPickerView *picker = [[ScrollPickerView alloc] initWithFrame:CGRectMake(10, 10, 40, screen_width - 20)];
		picker.delegate = self;
		picker.horizontalScrolling = NO;
		picker.debug = YES;
		picker.anchorOffset = 50;
		picker.layer.borderWidth = 1;
		picker.layer.borderColor = [UIColor grayColor].CGColor;
		
		{
			UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screen_width - 20, 215)];
			label.text = @"wwwwwwww";
			label.backgroundColor = [UIColor yellowColor];
			picker.headerView = label;
		}
		{
			UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screen_width - 20, 115)];
			//label.text = @"wwwwwwww";
			label.backgroundColor = [UIColor blueColor];
			picker.footerView = label;
		}

		[self.view addSubview:picker];
		
		{
			CGRect frame;
			frame.size = CGSizeMake(10, 10);
			frame.origin.x = picker.frame.origin.x + picker.frame.size.width + 3;
			frame.origin.y = picker.frame.origin.y + picker.anchorOffset - frame.size.height / 2;
			UIView *marker = [[UIView alloc] initWithFrame:frame];
			marker.backgroundColor = [UIColor redColor];
			[self.view addSubview:marker];
		}
	}
	
	
	{
		ScrollPickerView *picker = [[ScrollPickerView alloc] initWithFrame:CGRectMake(10, 350, screen_width - 20, 40)];
		picker.delegate = self;
		picker.horizontalScrolling = YES;
		picker.debug = NO;
		picker.selectedIndex = 5;
		picker.layer.borderWidth = 1;
		picker.layer.borderColor = [UIColor grayColor].CGColor;
		
		{
			UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screen_width - 20, 205)];
			label.text = @"wwwwwwww";
			label.backgroundColor = [UIColor yellowColor];
			picker.headerView = label;
		}
		{
			UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screen_width - 20, 305)];
			//label.text = @"wwwwwwww";
			label.backgroundColor = [UIColor blueColor];
			picker.footerView = label;
		}

		[self.view addSubview:picker];

		{
			CGRect frame;
			frame.size = CGSizeMake(30, 35);
			frame.origin.x = picker.frame.origin.x + picker.anchorOffset - frame.size.width / 2;
			frame.origin.y = picker.frame.origin.y - /*frame.size.height*/ - 3;
			UIView *marker = [[UIView alloc] initWithFrame:frame];
			marker.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.5];
			marker.userInteractionEnabled = NO;
			
			[self.view addSubview:marker];
		}
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfRows{
	//NSLog(@"%s", __func__);
	return 20;
}

- (UIView *)viewForRowAtIndex:(NSUInteger)index{
	//NSLog(@"%s %d", __func__, (int)index);
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 50)];
	label.text = [NSString stringWithFormat:@"%d", (int)index];
	label.textAlignment = NSTextAlignmentCenter;
	//label.backgroundColor = [UIColor greenColor];
	return label;
}

- (CGFloat)heightForCellAtIndex:(NSUInteger)index{
	return 50;
}

- (void)maySelectIndex:(NSUInteger)index{
	//NSLog(@"%s %d", __func__, (int)index);
}
- (void)didSelectIndex:(NSUInteger)index{
	NSLog(@"%s %d", __func__, (int)index);
}


@end
