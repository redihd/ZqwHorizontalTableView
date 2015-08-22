//
//  ZqwTableViewCell.h
//  ZqwHorizontalTableView
//
//  Created by 朱泉伟 on 15/8/21.
//  Copyright (c) 2015年 ZhuQuanWei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZqwTableViewCell : UIView

@property (nonatomic, strong) UIView* contentView;

@property (nonatomic, copy) NSString * identifiy;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) NSInteger index;

- (void) prepareForReused;
- (instancetype)initWithIdentifiy:(NSString *)identifiy;

@end
