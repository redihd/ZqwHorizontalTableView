//
//  ViewController.m
//  ZqwHorizontalTableView
//
//  Created by 朱泉伟 on 15/8/21.
//  Copyright (c) 2015年 ZhuQuanWei. All rights reserved.
//

#import "ViewController.h"
#import "ZqwHorizontalTableView.h"
#import "ZqwTableViewCell.h"

@interface ViewController ()<ZqwTableViewDataSource,ZqwTableViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) ZqwHorizontalTableView * tableView;
@property (nonatomic, strong) UIButton * leftButton;
@property (nonatomic, strong) UIButton * rightButton;

@end

@implementation ViewController

#pragma mark -
#pragma mark lazyLaod

- (UIButton *)leftButton{
    if (nil == _leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftButton setTitle:@"left" forState:UIControlStateNormal];
        [_leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_leftButton setBackgroundColor:[UIColor blueColor]];
    }
    return _leftButton;
}

- (UIButton *)rightButton{
    if (nil == _rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButton setTitle:@"right" forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_rightButton setBackgroundColor:[UIColor blueColor]];
    }
    return _rightButton;
}

- (ZqwHorizontalTableView *)tableView{
    if (nil == _tableView) {
        _tableView = [[ZqwHorizontalTableView alloc] initWithFrame:self.view.bounds];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.dataSource = self;
        _tableView.actionDelegate = self;
        _tableView.delegate = self;
        _tableView.pagingEnabled = YES;
    }
    return _tableView;
}

#pragma mark -
#pragma mark life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    self.leftButton.frame = CGRectMake(20, 20, 100, 100);
    self.rightButton.frame = CGRectMake(200, 20, 100, 100);
    [self.view addSubview:self.leftButton];
    [self.view addSubview:self.rightButton];
    [_tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfColumnsInZqwTableView:(ZqwHorizontalTableView *)tableView{
    return 4;
}

- (ZqwTableViewCell *)zqwTableView:(ZqwHorizontalTableView *)tableView cellAtColumn:(NSInteger)column{
    static NSString* const cellIdentifiy = @"detifail";
    ZqwTableViewCell* cell = (ZqwTableViewCell*)[tableView dequeueZqwTalbeViewCellForIdentifiy:cellIdentifiy];
    UILabel *label = nil;
    if (!cell) {
        cell = [[ZqwTableViewCell alloc] initWithIdentifiy:cellIdentifiy];
        label = [[UILabel alloc] initWithFrame:cell.bounds];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [label.font fontWithSize:20];
        label.tag = 1;
        [cell addSubview:label];
    }
        cell.backgroundColor = [self getRandomColor];
    label = (UILabel *)[cell viewWithTag:1];
    label.text = [NSString stringWithFormat:@"%ld",column];

    return cell;
}

- (CGFloat)zqwTableView:(ZqwHorizontalTableView *)tableView cellWidthAtColumn:(NSInteger)column{
    return 375;
}

#pragma mark -
#pragma mark delegate

- (void)zqwTableView:(ZqwHorizontalTableView *)tableView didTapAtColumn:(NSInteger)column{
    NSLog(@"%td",column);
}

#pragma mark -
#pragma mark color helper

- (UIColor *)getRandomColor{
    CGFloat red = arc4random() / (CGFloat)INT_MAX;
    CGFloat green = arc4random() / (CGFloat)INT_MAX;
    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
    return  [UIColor colorWithRed:red
                            green:green
                             blue:blue
                            alpha:1.0];
}

#pragma mark -
#pragma mark action

- (void)leftButtonClick{
    if (self.tableView.contentOffset.x >= 375) {
        [self.tableView setContentOffset:CGPointMake(self.tableView.contentOffset.x - 375, 0) animated:YES];
    }
}

- (void)rightButtonClick{
    if (self.tableView.contentOffset.x < self.tableView.contentSize.width - 375) {
        [self.tableView setContentOffset:CGPointMake(self.tableView.contentOffset.x + 375, 0) animated:YES];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{

}

@end
