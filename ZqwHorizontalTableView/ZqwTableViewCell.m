//
//  ZqwTableViewCell.m
//  ZqwHorizontalTableView
//
//  Created by 朱泉伟 on 15/8/21.
//  Copyright (c) 2015年 ZhuQuanWei. All rights reserved.
//

#import "ZqwTableViewCell.h"

@implementation ZqwTableViewCell

#pragma mark -
#pragma mark init

- (instancetype)initWithIdentifiy:(NSString *)identifiy{
    self = [super init];
    self.identifiy = identifiy;
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}
// 进行一些基本属性设置
- (void)commonInit{
    
}

- (void) layoutSubviews
{
//    _contentView.frame = self.bounds;
//    if (_isSelected) {
//        self.backgroundColor = [UIColor grayColor];
//    }
//    else
//    {
//        
//    }
}


#pragma mark -
#pragma mark reset

- (void) prepareForReused
{
    _index = NSNotFound;
    [self setIsSelected:NO];
}

#pragma mark -
#pragma mark setter

- (void) setIsSelected:(BOOL)isSelected
{
    if (_isSelected != isSelected) {
        _isSelected = isSelected;
        [self setNeedsLayout];
    }
}


- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self setIsSelected:YES];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self setIsSelected:NO];
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    [self setIsSelected:NO];
}

@end
