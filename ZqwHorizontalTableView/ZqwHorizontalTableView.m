//
//  ZqwHorizontalTableView.m
//  ZqwHorizontalTableView
//
//  Created by 朱泉伟 on 15/8/21.
//  Copyright (c) 2015年 ZhuQuanWei. All rights reserved.
//

#import "ZqwHorizontalTableView.h"
#import "ZqwTableViewCell.h"

typedef struct {
    BOOL funcNumberOfColumns;
    BOOL funcCellAtColumn;
    BOOL funcWidthColumn;
}ZqwTableDataSourceResponse;

#define kZqwTableViewDefaultWidth 44.0f

@interface ZqwHorizontalTableView()

// 储存可视区域的视图及其index
@property (nonatomic, strong) NSMutableDictionary *visibleListViewsItems;
// 储存可循环的视图
@property (nonatomic, strong) NSMutableSet *dequeueViewPool;
@property (nonatomic, strong) NSMutableArray * cellWidthArray;
@property (nonatomic, strong) NSMutableDictionary *cellXOffsets;
@property (nonatomic, readonly) NSInteger numberOfCells;
@property (nonatomic, assign) ZqwTableDataSourceResponse dataSourceResponse;

@end

@implementation ZqwHorizontalTableView

#pragma mark -
#pragma mark getter setter

- (void) setDataSource:(id<ZqwTableViewDataSource>)dataSource
{
    _dataSource                         = dataSource;
    _dataSourceResponse.funcNumberOfColumns = [_dataSource respondsToSelector:@selector(numberOfColumnsInZqwTableView:)];
    _dataSourceResponse.funcCellAtColumn    = [_dataSource respondsToSelector:@selector(zqwTableView:cellAtColumn:)];
    _dataSourceResponse.funcWidthColumn    = [_dataSource respondsToSelector:@selector(zqwTableView:cellWidthAtColumn:)];
}

#pragma mark -
#pragma mark init

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
    self.visibleListViewsItems = [NSMutableDictionary dictionary];
    self.dequeueViewPool = [NSMutableSet set];
    self.cellWidthArray = [NSMutableArray array];
    self.cellXOffsets = [NSMutableDictionary dictionary];
    self.selectedIndex = NSNotFound;
    [self addTapTarget:self selector:@selector(handleTapGestrue:)];
}

#pragma mark -
#pragma mark layOut

- (void)layoutSubviews{
    [self layoutNeedDisplayCells];
}

- (void)layoutNeedDisplayCells{
    NSRange displayRange = [self displayRange];
    for (int i = (int)displayRange.location ; i < displayRange.length + displayRange.location; i ++) {
        ZqwTableViewCell* cell = [self cellForColumn:i];
        [self addCell:cell atColumn:i];
        cell.frame = [self rectForCellAtColumn:i];
        if (_selectedIndex == i) {
            cell.isSelected = YES;
        }
        else{
            cell.isSelected = NO;
        }
    }
    
    [self cleanUnusedCellsWithDispalyRange:displayRange];
}

- (void)reduceContentSize
{
    _numberOfCells = [_dataSource numberOfColumnsInZqwTableView:self];
    self.cellWidthArray = [NSMutableArray array];
    self.cellXOffsets = [NSMutableDictionary dictionary];
    CGFloat width = 0;
    for (int i = 0  ; i < _numberOfCells; i ++) {
        CGFloat cellWidth = (_dataSourceResponse.funcWidthColumn? [_dataSource zqwTableView:self cellWidthAtColumn:i] : kZqwTableViewDefaultWidth) ;
        [_cellWidthArray addObject:@(cellWidth)];
        width += cellWidth;
        [_cellXOffsets setObject:@(width) forKey:@(i)];
    }
    if (width < CGRectGetWidth(self.frame)) {
        width = CGRectGetWidth(self.frame) + 0.00001;
    }
    CGSize size = CGSizeMake(width, CGRectGetHeight(self.frame));
    
    [self setContentSize:size];
}

- (void)cleanUnusedCellsWithDispalyRange:(NSRange)range
{
    NSDictionary* dic = [_visibleListViewsItems copy];
    NSArray* keys = dic.allKeys;
    for (NSNumber* columnIndex  in keys) {
        int column = [columnIndex intValue];
        if (!NSLocationInRange(column, range)) {
            ZqwTableViewCell* cell = [_visibleListViewsItems objectForKey:columnIndex];
            [_visibleListViewsItems removeObjectForKey:columnIndex];
            [self enqueueTableViewCell:cell];
        }
    }
}

- (void)addCell:(ZqwTableViewCell *)cell atColumn:(NSInteger)column{
    [self addSubview:cell];
    cell.index =  column;
    [self updateVisibleCell:cell withIndex:column];
}

#pragma mark -
#pragma mark layout helper

- (NSRange)displayRange{
    if (_numberOfCells == 0) {
        return NSMakeRange(0, 0);
    }
    int  beginIndex = 0;
    CGFloat beiginWidth = self.contentOffset.x;
    CGFloat displayBeginWidth = -0.00000001f;
    
    for (int i = 0 ; i < _numberOfCells; i++) {
        CGFloat cellWidth = [(NSNumber *)_cellWidthArray[i] floatValue];
        displayBeginWidth += cellWidth;
        if (displayBeginWidth > beiginWidth) {
            beginIndex = i;
            break;
        }
    }
    int endIndex = beginIndex;
    CGFloat displayEndWidth = self.contentOffset.x + CGRectGetWidth(self.frame);
    for (int i = beginIndex; i < _numberOfCells; i ++) {
        CGFloat cellXoffset = [(NSNumber *)_cellXOffsets[@(i)] floatValue];
        if (cellXoffset > displayEndWidth) {
            endIndex = i;
            break;
        }
        if (i == _numberOfCells - 1) {
            endIndex = i;
            break;
        }
    }
    return NSMakeRange(beginIndex, endIndex - beginIndex + 1);
}

- (CGRect)rectForCellAtColumn:(int)columnIndex{
    if (columnIndex < 0 || columnIndex >= _numberOfCells) {
        return CGRectZero;
    }
    CGFloat cellXoffSet = [(NSNumber *)_cellXOffsets[@(columnIndex)] floatValue];
    CGFloat cellWidth  = [(NSNumber *)_cellWidthArray[columnIndex] floatValue];
    return CGRectMake(cellXoffSet - cellWidth, 0, cellWidth, CGRectGetHeight(self.frame));
}

#pragma mark -
#pragma mark dataSource

- (ZqwTableViewCell *)cellForColumn:(NSInteger)columnIndex{
    ZqwTableViewCell * cell = [_visibleListViewsItems objectForKey:@(columnIndex)];
    if (!cell) {
        cell = [_dataSource zqwTableView:self cellAtColumn:columnIndex];
    }
    return cell;
}

- (void)reloadData{
    
    [self reduceContentSize];
    [self layoutNeedDisplayCells];
}

#pragma mark -
#pragma mark tapGesture

- (void)addTapTarget:(id)target selector:(SEL)selecotr{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:selecotr];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tapGesture];
}

- (void)handleTapGestrue:(UITapGestureRecognizer *)tapGestrue{
    CGPoint point = [tapGestrue locationInView:self];
    NSArray* cells = _visibleListViewsItems.allValues;
    for (ZqwTableViewCell* each in cells) {
        CGRect rect = each.frame;
        if (CGRectContainsPoint(rect, point)) {
            if ([_actionDelegate respondsToSelector:@selector(zqwTableView:didTapAtColumn:)]) {
                [_actionDelegate zqwTableView:self didTapAtColumn:each.index];
            }
            each.isSelected = YES;
            _selectedIndex = each.index;
        }
        else
        {
            each.isSelected = NO;
        }
    }
}

#pragma mark -
#pragma mark VisibleCell
- (void)updateVisibleCell:(ZqwTableViewCell *)cell withIndex:(NSInteger)index{
    _visibleListViewsItems[@(index)] = cell;
    cell.contentView.backgroundColor = [UIColor clearColor];
}

#pragma mark -
#pragma mark  cell dequeue

- (void) enqueueTableViewCell:(ZqwTableViewCell *)cell{
    if (cell) {
        [cell prepareForReused];
        [_dequeueViewPool addObject:cell];
        [cell removeFromSuperview];
    }
}

- (ZqwTableViewCell *)dequeueZqwTalbeViewCellForIdentifiy:(NSString *)identifiy{
    ZqwTableViewCell* cell = Nil;
    for (ZqwTableViewCell * each  in _dequeueViewPool) {
        if ([each.identifiy isEqualToString:identifiy]) {
            cell = each;
            break;
        }
    }
    if (cell) {
        [_dequeueViewPool removeObject:cell];
    }
    return cell;
}

@end
