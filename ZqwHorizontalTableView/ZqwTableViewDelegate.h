//
//  ZqwTableViewDelegate.h
//  ZqwHorizontalTableView
//
//  Created by 朱泉伟 on 15/8/21.
//  Copyright (c) 2015年 ZhuQuanWei. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZqwHorizontalTableView;

@protocol ZqwTableViewDelegate <NSObject>

- (void) zqwTableView:(ZqwHorizontalTableView*)tableView didTapAtColumn:(NSInteger)column;


@end
