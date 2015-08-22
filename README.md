# ZqwHorizontalTableView

//@property (nonatomic, weak) id<ZqwTableViewDelegate> actionDelegate;

- (void) zqwTableView:(ZqwHorizontalTableView*)tableView didTapAtColumn:(NSInteger)column;

@property (nonatomic, weak) id<ZqwTableViewDataSource> dataSource;

- (NSInteger)numberOfColumnsInZqwTableView:(ZqwHorizontalTableView *)tableView;

- (ZqwTableViewCell *)zqwTableView:(ZqwHorizontalTableView *)tableView cellAtColumn:(NSInteger)column;

- (CGFloat)zqwTableView:(ZqwHorizontalTableView *)tableView cellWidthAtColumn:(NSInteger)column;

@interface ZqwHorizontalTableView : UIScrollView

- (ZqwTableViewCell *)dequeueZqwTalbeViewCellForIdentifiy:(NSString *)identifiy;
- (void)reloadData;


how to use

download zip run it