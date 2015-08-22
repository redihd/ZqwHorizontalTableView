//
//  ZqwTableViewDataSource.h
//  ZqwHorizontalTableView
//
//  Created by 朱泉伟 on 15/8/21.
//  Copyright (c) 2015年 ZhuQuanWei. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZqwHorizontalTableView;
@class ZqwTableViewCell;

@protocol ZqwTableViewDataSource <NSObject>

- (NSInteger)numberOfColumnsInZqwTableView:(ZqwHorizontalTableView *)tableView;
- (ZqwTableViewCell *)zqwTableView:(ZqwHorizontalTableView *)tableView cellAtColumn:(NSInteger)column;
- (CGFloat)zqwTableView:(ZqwHorizontalTableView *)tableView cellWidthAtColumn:(NSInteger)column;

@end
