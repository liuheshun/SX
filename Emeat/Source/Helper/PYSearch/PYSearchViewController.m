//
//  GitHub: https://github.com/iphone5solo/PYSearch
//  Created by CoderKo1o.
//  Copyright © 2016 iphone5solo. All rights reserved.
//

#import "PYSearchViewController.h"
#import "PYSearchConst.h"
#import "PYSearchSuggestionViewController.h"
#import "SearchCollectionViewCell.h"
#import <CommonCrypto/CommonDigest.h>
#import "HomePageDetailsViewController.h"
#import "ShopCertificationViewController.h"


#define PYRectangleTagMaxCol 3
#define PYTextColor PYSEARCH_COLOR(113, 113, 113)
#define PYSEARCH_COLORPolRandomColor self.colorPol[arc4random_uniform((uint32_t)self.colorPol.count)]

@interface PYSearchViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, PYSearchSuggestionViewDataSource ,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

/**
 The header view of search view
 */
@property (nonatomic, weak) UIView *headerView;

/**
 The view of popular search
 */
@property (nonatomic, weak) UIView *hotSearchView;

/**
 The view of search history
 */
@property (nonatomic, weak) UIView *searchHistoryView;

/**
 The records of search
 */
@property (nonatomic, strong) NSMutableArray *searchHistories;

/**
 Whether keyboard is showing.
 */
@property (nonatomic, assign) BOOL keyboardShowing;

/**
 The height of keyborad
 */
@property (nonatomic, assign) CGFloat keyboardHeight;

/**
 The search suggestion view contoller
 */
@property (nonatomic, weak) PYSearchSuggestionViewController *searchSuggestionVC;

/**
 The content view of popular search tags
 */
@property (nonatomic, weak) UIView *hotSearchTagsContentView;

/**
 The tags of rank
 */
@property (nonatomic, copy) NSArray<UILabel *> *rankTags;

/**
 The text labels of rank
 */
@property (nonatomic, copy) NSArray<UILabel *> *rankTextLabels;

/**
 The view of rank which contain tag and text label.
 */
@property (nonatomic, copy) NSArray<UIView *> *rankViews;

/**
 The content view of search history tags.
 */
@property (nonatomic, weak) UIView *searchHistoryTagsContentView;

/**
 The base table view  of search view controller
 */
@property (nonatomic, strong) UITableView *baseSearchTableView;

/**
 Whether did press suggestion cell
 */
@property (nonatomic, assign) BOOL didClickSuggestionCell;

/**
 The current orientation of device
 */
@property (nonatomic, assign) UIDeviceOrientation currentOrientation;

/**
 The width of cancel button
 */
@property (nonatomic, assign) CGFloat cancelButtonWidth;

///热搜推荐
@property (nonatomic,strong) NSMutableArray *dataMarray;

@property (nonatomic,strong) NSString *isShowShareString;



@end

@implementation PYSearchViewController
{
    UICollectionView *mainCollectionView;

}
- (instancetype)init
{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setup];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    self.dataMarray = [NSMutableArray array];
    [self requestListData:1];
    
    if (self.currentOrientation != [[UIDevice currentDevice] orientation]) { // orientation changed, reload layout
        self.hotSearches = self.hotSearches;
        self.searchHistories = self.searchHistories;
        self.currentOrientation = [[UIDevice currentDevice] orientation];
    }

    CGFloat adaptWidth = 0.0;
    if (self.searchViewControllerShowMode == PYSearchViewControllerShowModePush) {
        UIButton *backButton = self.navigationItem.leftBarButtonItem.customView;
        adaptWidth = backButton.py_width;
    } else if (self.searchViewControllerShowMode == PYSearchViewControllerShowModeModal) {
        UIButton *cancelButton = self.navigationItem.rightBarButtonItem.customView;
        self.cancelButtonWidth = cancelButton.py_width > self.cancelButtonWidth ? cancelButton.py_width : self.cancelButtonWidth;
        adaptWidth = self.cancelButtonWidth;
    }
    
    // Adapt the search bar layout problem in the navigation bar on iOS 11
    // More details : https://github.com/iphone5solo/PYSearch/issues/108
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0) { // iOS 11
        UINavigationBar *navBar = self.navigationController.navigationBar;
        if (self.navigationItem.rightBarButtonItem) { // Cancel button
            CGFloat space = 8;
            navBar.layoutMargins = UIEdgeInsetsZero;
            for (UIView *subview in navBar.subviews) {
                if ([NSStringFromClass(subview.class) containsString:@"ContentView"]) {
                    subview.layoutMargins = UIEdgeInsetsMake(0, space, 0, space); // Fix cancel button width is modified
                    break;
                }
            }
        }
        _searchBar.py_width = self.view.py_width - adaptWidth - PYSEARCH_MARGIN * 4;
        _searchBar.py_height = self.view.py_width > self.view.py_height ? 24 : 30;
        _searchTextField.frame = _searchBar.bounds;
    } else {
        UIView *titleView = self.navigationItem.titleView;
        titleView.py_x = PYSEARCH_MARGIN * 1.5;
        titleView.py_y = self.view.py_width > self.view.py_height ? 3 : 7;
        titleView.py_width = self.view.py_width - self.cancelButtonWidth - titleView.py_x * 2 - 3;
        titleView.py_height = self.view.py_width > self.view.py_height ? 24 : 30;
    }
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (NULL == self.searchResultController.parentViewController) {
        [self.searchBar becomeFirstResponder];
    } else if (YES == self.showKeyboardWhenReturnSearchResult) {
        [self.searchBar becomeFirstResponder];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.cancelButtonWidth == 0) { // Just adapt iOS 11.2
        [self viewDidLayoutSubviews];
    }
    
    // Adjust the view according to the `navigationBar.translucent`
    if (NO == self.navigationController.navigationBar.translucent) {
        self.baseSearchTableView.contentInset = UIEdgeInsetsMake(0, 0, self.view.py_y, 0);
        self.searchSuggestionVC.view.frame = CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame) - self.view.py_y, self.view.py_width, self.view.py_height + self.view.py_y);
        if (!self.navigationController.navigationBar.barTintColor) {
            self.navigationController.navigationBar.barTintColor = PYSEARCH_COLOR(249, 249, 249);
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.searchBar resignFirstResponder];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (instancetype)searchViewControllerWithHotSearches:(NSArray<NSString *> *)hotSearches searchBarPlaceholder:(NSString *)placeholder
{
    PYSearchViewController *searchVC = [[self alloc] init];
    searchVC.hotSearches = hotSearches;
    searchVC.searchBar.placeholder = placeholder;
    return searchVC;
}

+ (instancetype)searchViewControllerWithHotSearches:(NSArray<NSString *> *)hotSearches searchBarPlaceholder:(NSString *)placeholder didSearchBlock:(PYDidSearchBlock)block
{
    PYSearchViewController *searchVC = [self searchViewControllerWithHotSearches:hotSearches searchBarPlaceholder:placeholder];
    searchVC.didSearchBlock = [block copy];
    return searchVC;
}

#pragma mark - Lazy
- (UITableView *)baseSearchTableView
{
    if (!_baseSearchTableView) {
        UITableView *baseSearchTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        baseSearchTableView.backgroundColor = [UIColor clearColor];
        baseSearchTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        if ([baseSearchTableView respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) { // For the adapter iPad
            baseSearchTableView.cellLayoutMarginsFollowReadableWidth = NO;
        }
        baseSearchTableView.delegate = self;
        baseSearchTableView.dataSource = self;
        [self.view addSubview:baseSearchTableView];
        _baseSearchTableView = baseSearchTableView;
    }
    return _baseSearchTableView;
}

- (PYSearchSuggestionViewController *)searchSuggestionVC
{
    if (!_searchSuggestionVC) {
        PYSearchSuggestionViewController *searchSuggestionVC = [[PYSearchSuggestionViewController alloc] initWithStyle:UITableViewStyleGrouped];
        __weak typeof(self) _weakSelf = self;
        searchSuggestionVC.didSelectCellBlock = ^(UITableViewCell *didSelectCell) {
            __strong typeof(_weakSelf) _swSelf = _weakSelf;
            _swSelf.searchBar.text = didSelectCell.textLabel.text;
            NSIndexPath *indexPath = [_swSelf.searchSuggestionVC.tableView indexPathForCell:didSelectCell];
            
            if ([_swSelf.delegate respondsToSelector:@selector(searchViewController:didSelectSearchSuggestionAtIndexPath:searchBar:)]) {
                [_swSelf.delegate searchViewController:_swSelf didSelectSearchSuggestionAtIndexPath:indexPath searchBar:_swSelf.searchBar];
                [_swSelf saveSearchCacheAndRefreshView];
            } else if ([_swSelf.delegate respondsToSelector:@selector(searchViewController:didSelectSearchSuggestionAtIndex:searchText:)]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                [_swSelf.delegate searchViewController:_swSelf didSelectSearchSuggestionAtIndex:indexPath.row searchText:_swSelf.searchBar.text];
#pragma clang diagnostic pop
                [_swSelf saveSearchCacheAndRefreshView];
            } else {
                [_swSelf searchBarSearchButtonClicked:_swSelf.searchBar];
            }
        };
        searchSuggestionVC.view.frame = CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame), PYScreenW, PYScreenH);
        searchSuggestionVC.view.backgroundColor = self.baseSearchTableView.backgroundColor;
        searchSuggestionVC.view.hidden = YES;
        _searchSuggestionView = (UITableView *)searchSuggestionVC.view;
        searchSuggestionVC.dataSource = self;
        [self.view addSubview:searchSuggestionVC.view];
        [self addChildViewController:searchSuggestionVC];
        _searchSuggestionVC = searchSuggestionVC;
    }
    return _searchSuggestionVC;
}

- (UIButton *)emptyButton
{
    if (!_emptyButton) {
        UIButton *emptyButton = [[UIButton alloc] init];
        emptyButton.titleLabel.font = self.searchHistoryHeader.font;
        [emptyButton setTitleColor:PYTextColor forState:UIControlStateNormal];
        [emptyButton setTitle:[NSBundle py_localizedStringForKey:PYSearchEmptyButtonText] forState:UIControlStateNormal];
        [emptyButton setImage:[NSBundle py_imageNamed:@"empty"] forState:UIControlStateNormal];
        [emptyButton addTarget:self action:@selector(emptySearchHistoryDidClick) forControlEvents:UIControlEventTouchUpInside];
        [emptyButton sizeToFit];
        emptyButton.py_width += PYSEARCH_MARGIN;
        emptyButton.py_height += PYSEARCH_MARGIN;
        emptyButton.py_centerY = self.searchHistoryHeader.py_centerY;
        emptyButton.py_x = self.searchHistoryView.py_width - emptyButton.py_width;
        emptyButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [self.searchHistoryView addSubview:emptyButton];
        _emptyButton = emptyButton;
    }
    return _emptyButton;
}

- (UIView *)searchHistoryTagsContentView
{
    if (!_searchHistoryTagsContentView) {
        UIView *searchHistoryTagsContentView = [[UIView alloc] init];
        searchHistoryTagsContentView.py_width = self.searchHistoryView.py_width;
        searchHistoryTagsContentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        searchHistoryTagsContentView.py_y = CGRectGetMaxY(self.hotSearchTagsContentView.frame) + PYSEARCH_MARGIN;
        [self.searchHistoryView addSubview:searchHistoryTagsContentView];
        _searchHistoryTagsContentView = searchHistoryTagsContentView;
    }
    return _searchHistoryTagsContentView;
}

- (UILabel *)searchHistoryHeader
{
    if (!_searchHistoryHeader) {
        UILabel *titleLabel = [self setupTitleLabel:[NSBundle py_localizedStringForKey:PYSearchSearchHistoryText]];
        [self.searchHistoryView addSubview:titleLabel];
        _searchHistoryHeader = titleLabel;
    }
    return _searchHistoryHeader;
}

- (UIView *)searchHistoryView
{
    if (!_searchHistoryView) {
        UIView *searchHistoryView = [[UIView alloc] init];
        searchHistoryView.py_x = self.hotSearchView.py_x;
        searchHistoryView.py_y = self.hotSearchView.py_y;
        searchHistoryView.py_width = self.headerView.py_width - searchHistoryView.py_x * 2;
        searchHistoryView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.headerView addSubview:searchHistoryView];
        _searchHistoryView = searchHistoryView;
    }
    return _searchHistoryView;
}

- (NSMutableArray *)searchHistories
{
    if (!_searchHistories) {
        _searchHistories = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithFile:self.searchHistoriesCachePath]];
    }
    return _searchHistories;
}

- (NSMutableArray *)colorPol
{
    if (!_colorPol) {
        NSArray *colorStrPol = @[@"009999", @"0099cc", @"0099ff", @"00cc99", @"00cccc", @"336699", @"3366cc", @"3366ff", @"339966", @"666666", @"666699", @"6666cc", @"6666ff", @"996666", @"996699", @"999900", @"999933", @"99cc00", @"99cc33", @"660066", @"669933", @"990066", @"cc9900", @"cc6600" , @"cc3300", @"cc3366", @"cc6666", @"cc6699", @"cc0066", @"cc0033", @"ffcc00", @"ffcc33", @"ff9900", @"ff9933", @"ff6600", @"ff6633", @"ff6666", @"ff6699", @"ff3366", @"ff3333"];
        NSMutableArray *colorPolM = [NSMutableArray array];
        for (NSString *colorStr in colorStrPol) {
            UIColor *color = [UIColor py_colorWithHexString:colorStr];
            [colorPolM addObject:color];
        }
        _colorPol = colorPolM;
    }
    return _colorPol;
}

- (void)setup
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.baseSearchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.navigationController.navigationBar.backIndicatorImage = nil;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeSystem];
    cancleButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [cancleButton setTitle:[NSBundle py_localizedStringForKey:PYSearchCancelButtonText] forState:UIControlStateNormal];
    [cancleButton addTarget:self action:@selector(cancelDidClick)  forControlEvents:UIControlEventTouchUpInside];
    [cancleButton sizeToFit];
    cancleButton.py_width += PYSEARCH_MARGIN;
    self.cancelButton = cancleButton;
    self.cancelBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancleButton];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    backButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [backButton setTitle:[NSBundle py_localizedStringForKey:PYSearchBackButtonText] forState:UIControlStateNormal];
    [backButton setImage:[NSBundle py_imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backDidClick)  forControlEvents:UIControlEventTouchUpInside];
    [backButton sizeToFit];
    
    backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -35, 0, -15);
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    backButton.py_width -= PYSEARCH_MARGIN;
    self.backButton = backButton;
    self.backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    /**
     * Initialize settings
     */
    self.hotSearchStyle = PYHotSearchStyleDefault;
    self.searchHistoryStyle = PYHotSearchStyleDefault;
    self.searchResultShowMode = PYSearchResultShowModeDefault;
    self.searchViewControllerShowMode = PYSearchViewControllerShowDefault;
    self.searchSuggestionHidden = NO;
    self.searchHistoriesCachePath = PYSEARCH_SEARCH_HISTORY_CACHE_PATH;
    self.searchHistoriesCount = 20;
    self.showSearchHistory = YES;
    self.showHotSearch = YES;
    self.showSearchResultWhenSearchTextChanged = NO;
    self.showSearchResultWhenSearchBarRefocused = NO;
    self.showKeyboardWhenReturnSearchResult = YES;
    self.removeSpaceOnSearchString = YES;
    self.searchBarCornerRadius = 0.0;
    
    UIView *titleView = [[UIView alloc] init];
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:titleView.bounds];
    [titleView addSubview:searchBar];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0) { // iOS 11
        [NSLayoutConstraint activateConstraints:@[
                                                  [searchBar.topAnchor constraintEqualToAnchor:titleView.topAnchor],
                                                  [searchBar.leftAnchor constraintEqualToAnchor:titleView.leftAnchor],
                                                  [searchBar.rightAnchor constraintEqualToAnchor:titleView.rightAnchor constant:-PYSEARCH_MARGIN],
                                                  [searchBar.bottomAnchor constraintEqualToAnchor:titleView.bottomAnchor]
                                                  ]];
    } else {
        searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    self.navigationItem.titleView = titleView;
    searchBar.placeholder = [NSBundle py_localizedStringForKey:PYSearchSearchPlaceholderText];
    searchBar.backgroundImage = [NSBundle py_imageNamed:@"clearImage"];
    searchBar.delegate = self;
    for (UIView *subView in [[searchBar.subviews lastObject] subviews]) {
        if ([[subView class] isSubclassOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)subView;
            textField.font = [UIFont systemFontOfSize:16];
            _searchTextField = textField;
            break;
        }
    }
    self.searchBar = searchBar;
    
    UIView *headerView = [[UIView alloc] init];
    headerView.py_width = PYScreenW;
    headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    UIView *hotSearchView = [[UIView alloc] init];
    hotSearchView.py_x = PYSEARCH_MARGIN * 1.5;
    hotSearchView.py_width = headerView.py_width - hotSearchView.py_x * 2;
    hotSearchView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    UILabel *titleLabel = [self setupTitleLabel:[NSBundle py_localizedStringForKey:PYSearchHotSearchText]];
    self.hotSearchHeader = titleLabel;
    [hotSearchView addSubview:titleLabel];
    UIView *hotSearchTagsContentView = [[UIView alloc] init];
    hotSearchTagsContentView.py_width = hotSearchView.py_width;
    hotSearchTagsContentView.py_y = CGRectGetMaxY(titleLabel.frame) + PYSEARCH_MARGIN;
    hotSearchTagsContentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [hotSearchView addSubview:hotSearchTagsContentView];
    [headerView addSubview:hotSearchView];
    self.hotSearchTagsContentView = hotSearchTagsContentView;
    self.hotSearchView = hotSearchView;
    self.headerView = headerView;
    self.baseSearchTableView.tableHeaderView = headerView;
    
    UIView *footerView = [[UIView alloc] init];
    footerView.py_width = PYScreenW;
    UILabel *emptySearchHistoryLabel = [[UILabel alloc] init];
    emptySearchHistoryLabel.textColor = [UIColor darkGrayColor];
    emptySearchHistoryLabel.font = [UIFont systemFontOfSize:13];
    emptySearchHistoryLabel.userInteractionEnabled = YES;
    emptySearchHistoryLabel.text = [NSBundle py_localizedStringForKey:PYSearchEmptySearchHistoryText];
    emptySearchHistoryLabel.textAlignment = NSTextAlignmentCenter;
    emptySearchHistoryLabel.py_height = 49;
    [emptySearchHistoryLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(emptySearchHistoryDidClick)]];
    emptySearchHistoryLabel.py_width = footerView.py_width;
    emptySearchHistoryLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.emptySearchHistoryLabel = emptySearchHistoryLabel;
    [footerView addSubview:emptySearchHistoryLabel];
    footerView.py_height = emptySearchHistoryLabel.py_height;
    self.baseSearchTableView.tableFooterView = footerView;
    
    self.hotSearches = nil;
}

- (UILabel *)setupTitleLabel:(NSString *)title
{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.font = [UIFont systemFontOfSize:15*kScale];
    titleLabel.tag = 1;
    titleLabel.textColor = RGB(51, 51, 51, 1);
    [titleLabel sizeToFit];
    titleLabel.py_x = 0;
    titleLabel.py_y = 0;
    return titleLabel;
}

- (void)setupHotSearchRectangleTags
{
    UIView *contentView = self.hotSearchTagsContentView;
    contentView.py_width = PYSEARCH_REALY_SCREEN_WIDTH;
    contentView.py_x = -PYSEARCH_MARGIN * 1.5;
    contentView.py_y += 2;
    contentView.backgroundColor = [UIColor whiteColor];
    self.baseSearchTableView.backgroundColor = [UIColor py_colorWithHexString:@"#efefef"];
    // remove all subviews in hotSearchTagsContentView
    [self.hotSearchTagsContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
  
    CGFloat rectangleTagH = 40;
    for (int i = 0; i < self.hotSearches.count; i++) {
        UILabel *rectangleTagLabel = [[UILabel alloc] init];
        rectangleTagLabel.userInteractionEnabled = YES;
        rectangleTagLabel.font = [UIFont systemFontOfSize:14];
        rectangleTagLabel.textColor = PYTextColor;
        rectangleTagLabel.backgroundColor = [UIColor clearColor];
        rectangleTagLabel.text = self.hotSearches[i];
        rectangleTagLabel.py_width = contentView.py_width / PYRectangleTagMaxCol;
        rectangleTagLabel.py_height = rectangleTagH;
        rectangleTagLabel.textAlignment = NSTextAlignmentCenter;
        [rectangleTagLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagDidCLick:)]];
        rectangleTagLabel.py_x = rectangleTagLabel.py_width * (i % PYRectangleTagMaxCol);
        rectangleTagLabel.py_y = rectangleTagLabel.py_height * (i / PYRectangleTagMaxCol);
        [contentView addSubview:rectangleTagLabel];
    }
    contentView.py_height = CGRectGetMaxY(contentView.subviews.lastObject.frame);
    
    self.hotSearchView.py_height = CGRectGetMaxY(contentView.frame) + PYSEARCH_MARGIN * 2;
    self.baseSearchTableView.tableHeaderView.py_height = self.headerView.py_height = MAX(CGRectGetMaxY(self.hotSearchView.frame), CGRectGetMaxY(self.searchHistoryView.frame));
    
    for (int i = 0; i < PYRectangleTagMaxCol - 1; i++) {
        UIImageView *verticalLine = [[UIImageView alloc] initWithImage:[NSBundle py_imageNamed:@"cell-content-line-vertical"]];
        verticalLine.py_height = contentView.py_height;
        verticalLine.alpha = 0.7;
        verticalLine.py_x = contentView.py_width / PYRectangleTagMaxCol * (i + 1);
        verticalLine.py_width = 0.5;
        [contentView addSubview:verticalLine];
    }
    
    for (int i = 0; i < ceil(((double)self.hotSearches.count / PYRectangleTagMaxCol)) - 1; i++) {
        UIImageView *verticalLine = [[UIImageView alloc] initWithImage:[NSBundle py_imageNamed:@"cell-content-line"]];
        verticalLine.py_height = 0.5;
        verticalLine.alpha = 0.7;
        verticalLine.py_y = rectangleTagH * (i + 1);
        verticalLine.py_width = contentView.py_width;
        [contentView addSubview:verticalLine];
    }
    [self layoutForDemand];
    // Note：When the operating system for the iOS 9.x series tableHeaderView height settings are invalid, you need to reset the tableHeaderView
    [self.baseSearchTableView setTableHeaderView:self.baseSearchTableView.tableHeaderView];
}

- (void)setupHotSearchRankTags
{
    UIView *contentView = self.hotSearchTagsContentView;
    [self.hotSearchTagsContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSMutableArray *rankTextLabelsM = [NSMutableArray array];
    NSMutableArray *rankTagM = [NSMutableArray array];
    NSMutableArray *rankViewM = [NSMutableArray array];
    for (int i = 0; i < self.hotSearches.count; i++) {
        UIView *rankView = [[UIView alloc] init];
        rankView.py_height = 40;
        rankView.py_width = (self.baseSearchTableView.py_width - PYSEARCH_MARGIN * 3) * 0.5;
        rankView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [contentView addSubview:rankView];
        // rank tag
        UILabel *rankTag = [[UILabel alloc] init];
        rankTag.textAlignment = NSTextAlignmentCenter;
        rankTag.font = [UIFont systemFontOfSize:10];
        rankTag.layer.cornerRadius = 3;
        rankTag.clipsToBounds = YES;
        rankTag.text = [NSString stringWithFormat:@"%d", i + 1];
        [rankTag sizeToFit];
        rankTag.py_width = rankTag.py_height += PYSEARCH_MARGIN * 0.5;
        rankTag.py_y = (rankView.py_height - rankTag.py_height) * 0.5;
        [rankView addSubview:rankTag];
        [rankTagM addObject:rankTag];
        // rank text
        UILabel *rankTextLabel = [[UILabel alloc] init];
        rankTextLabel.text = self.hotSearches[i];
        rankTextLabel.userInteractionEnabled = YES;
        [rankTextLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagDidCLick:)]];
        rankTextLabel.textAlignment = NSTextAlignmentLeft;
        rankTextLabel.backgroundColor = [UIColor clearColor];
        rankTextLabel.textColor = PYTextColor;
        rankTextLabel.font = [UIFont systemFontOfSize:14];
        rankTextLabel.py_x = CGRectGetMaxX(rankTag.frame) + PYSEARCH_MARGIN;
        rankTextLabel.py_width = (self.baseSearchTableView.py_width - PYSEARCH_MARGIN * 3) * 0.5 - rankTextLabel.py_x;
        rankTextLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        rankTextLabel.py_height = rankView.py_height;
        [rankTextLabelsM addObject:rankTextLabel];
        [rankView addSubview:rankTextLabel];
        
        UIImageView *line = [[UIImageView alloc] initWithImage:[NSBundle py_imageNamed:@"cell-content-line"]];
        line.py_height = 0.5;
        line.alpha = 0.7;
        line.py_x = -PYScreenW * 0.5;
        line.py_y = rankView.py_height - 1;
        line.py_width = self.baseSearchTableView.py_width;
        line.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [rankView addSubview:line];
        [rankViewM addObject:rankView];
        
        // set tag's background color and text color
        switch (i) {
            case 0: // NO.1
                rankTag.backgroundColor = [UIColor py_colorWithHexString:self.rankTagBackgroundColorHexStrings[0]];
                rankTag.textColor = [UIColor whiteColor];
                break;
            case 1: // NO.2
                rankTag.backgroundColor = [UIColor py_colorWithHexString:self.rankTagBackgroundColorHexStrings[1]];
                rankTag.textColor = [UIColor whiteColor];
                break;
            case 2: // NO.3
                rankTag.backgroundColor = [UIColor py_colorWithHexString:self.rankTagBackgroundColorHexStrings[2]];
                rankTag.textColor = [UIColor whiteColor];
                break;
            default: // Other
                rankTag.backgroundColor = [UIColor py_colorWithHexString:self.rankTagBackgroundColorHexStrings[3]];
                rankTag.textColor = PYTextColor;
                break;
        }
    }
    self.rankTextLabels = rankTextLabelsM;
    self.rankTags = rankTagM;
    self.rankViews = rankViewM;
    
    for (int i = 0; i < self.rankViews.count; i++) { // default is two column
        UIView *rankView = self.rankViews[i];
        rankView.py_x = (PYSEARCH_MARGIN + rankView.py_width) * (i % 2);
        rankView.py_y = rankView.py_height * (i / 2);
    }
    
    contentView.py_height = CGRectGetMaxY(self.rankViews.lastObject.frame);
    self.hotSearchView.py_height = CGRectGetMaxY(contentView.frame) + PYSEARCH_MARGIN * 2;
    self.baseSearchTableView.tableHeaderView.py_height = self.headerView.py_height = MAX(CGRectGetMaxY(self.hotSearchView.frame), CGRectGetMaxY(self.searchHistoryView.frame));
    [self layoutForDemand];
    
    // Note：When the operating system for the iOS 9.x series tableHeaderView height settings are invalid, you need to reset the tableHeaderView
    [self.baseSearchTableView setTableHeaderView:self.baseSearchTableView.tableHeaderView];
}

- (void)setupHotSearchNormalTags
{
    self.hotSearchTags = [self addAndLayoutTagsWithTagsContentView:self.hotSearchTagsContentView tagTexts:self.hotSearches];
    [self setHotSearchStyle:self.hotSearchStyle];
}

- (void)setupSearchHistoryTags
{
    self.baseSearchTableView.tableFooterView = nil;
    self.searchHistoryTagsContentView.py_y = PYSEARCH_MARGIN;
    self.emptyButton.py_y = self.searchHistoryHeader.py_y - PYSEARCH_MARGIN * 0.5;
    self.searchHistoryTagsContentView.py_y = CGRectGetMaxY(self.emptyButton.frame) + PYSEARCH_MARGIN;
    self.searchHistoryTags = [self addAndLayoutTagsWithTagsContentView:self.searchHistoryTagsContentView tagTexts:[self.searchHistories copy]];
}

- (NSArray *)addAndLayoutTagsWithTagsContentView:(UIView *)contentView tagTexts:(NSArray<NSString *> *)tagTexts;
{
    [contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSMutableArray *tagsM = [NSMutableArray array];
    for (int i = 0; i < tagTexts.count; i++) {
        UILabel *label = [self labelWithTitle:tagTexts[i]];
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagDidCLick:)]];
        [contentView addSubview:label];
        [tagsM addObject:label];
    }
    
    CGFloat currentX = 0;
    CGFloat currentY = 0;
    CGFloat countRow = 0;
    CGFloat countCol = 0;
    
    for (int i = 0; i < contentView.subviews.count; i++) {
        UILabel *subView = contentView.subviews[i];
        // When the number of search words is too large, the width is width of the contentView
        if (subView.py_width > contentView.py_width) subView.py_width = contentView.py_width;
        if (currentX + subView.py_width + PYSEARCH_MARGIN * countRow > contentView.py_width) {
            subView.py_x = 0;
            subView.py_y = (currentY += subView.py_height) + PYSEARCH_MARGIN * ++countCol;
            currentX = subView.py_width;
            countRow = 1;
        } else {
            subView.py_x = (currentX += subView.py_width) - subView.py_width + PYSEARCH_MARGIN * countRow;
            subView.py_y = currentY + PYSEARCH_MARGIN * countCol;
            countRow ++;
        }
    }
    
    contentView.py_height = CGRectGetMaxY(contentView.subviews.lastObject.frame);
    if (self.hotSearchTagsContentView == contentView) { // popular search tag
        self.hotSearchView.py_height = CGRectGetMaxY(contentView.frame) + PYSEARCH_MARGIN * 2;
    } else if (self.searchHistoryTagsContentView == contentView) { // search history tag
        self.searchHistoryView.py_height = CGRectGetMaxY(contentView.frame) + PYSEARCH_MARGIN * 2;
    }
    
    [self layoutForDemand];
    self.baseSearchTableView.tableHeaderView.py_height = self.headerView.py_height = MAX(CGRectGetMaxY(self.hotSearchView.frame), CGRectGetMaxY(self.searchHistoryView.frame));
    self.baseSearchTableView.tableHeaderView.hidden = NO;
    
    // Note：When the operating system for the iOS 9.x series tableHeaderView height settings are invalid, you need to reset the tableHeaderView
    [self.baseSearchTableView setTableHeaderView:self.baseSearchTableView.tableHeaderView];
    return [tagsM copy];
}

- (void)layoutForDemand {
    if (NO == self.swapHotSeachWithSearchHistory) {
        self.hotSearchView.py_y = PYSEARCH_MARGIN * 2;
        self.searchHistoryView.py_y = self.hotSearches.count > 0 && self.showHotSearch ? CGRectGetMaxY(self.hotSearchView.frame) : PYSEARCH_MARGIN * 1.5;
    } else { // swap popular search whith search history
        self.searchHistoryView.py_y = PYSEARCH_MARGIN * 1.5;
        self.hotSearchView.py_y = self.searchHistories.count > 0 && self.showSearchHistory ? CGRectGetMaxY(self.searchHistoryView.frame) : PYSEARCH_MARGIN * 2;
    }
}

#pragma mark - setter
- (void)setSearchBarCornerRadius:(CGFloat)searchBarCornerRadius
{
    _searchBarCornerRadius = searchBarCornerRadius;
    
    for (UIView *subView in self.searchTextField.subviews) {
        if ([NSStringFromClass([subView class]) isEqualToString:@"_UISearchBarSearchFieldBackgroundView"]) {
            subView.layer.cornerRadius = searchBarCornerRadius;
            subView.clipsToBounds = YES;
            break;
        }
    }
}

- (void)setSwapHotSeachWithSearchHistory:(BOOL)swapHotSeachWithSearchHistory
{
    _swapHotSeachWithSearchHistory = swapHotSeachWithSearchHistory;
    
    self.hotSearches = self.hotSearches;
    self.searchHistories = self.searchHistories;
}

- (void)setHotSearchTitle:(NSString *)hotSearchTitle
{
    _hotSearchTitle = [hotSearchTitle copy];
    
    self.hotSearchHeader.text = _hotSearchTitle;
}

- (void)setSearchHistoryTitle:(NSString *)searchHistoryTitle
{
    _searchHistoryTitle = [searchHistoryTitle copy];
    
    if (PYSearchHistoryStyleCell == self.searchHistoryStyle) {
        [self.baseSearchTableView reloadData];
    } else {
        self.searchHistoryHeader.text = _searchHistoryTitle;
    }
}

- (void)setShowSearchResultWhenSearchTextChanged:(BOOL)showSearchResultWhenSearchTextChanged
{
    _showSearchResultWhenSearchTextChanged = showSearchResultWhenSearchTextChanged;
    
    if (YES == _showSearchResultWhenSearchTextChanged) {
        self.searchSuggestionHidden = YES;
    }
}

- (void)setShowHotSearch:(BOOL)showHotSearch
{
    _showHotSearch = showHotSearch;
    
    [self setHotSearches:self.hotSearches];
    [self setSearchHistoryStyle:self.searchHistoryStyle];
}

- (void)setShowSearchHistory:(BOOL)showSearchHistory
{
    _showSearchHistory = showSearchHistory;
    
    [self setHotSearches:self.hotSearches];
    [self setSearchHistoryStyle:self.searchHistoryStyle];
}

- (void)setCancelBarButtonItem:(UIBarButtonItem *)cancelBarButtonItem
{
    _cancelBarButtonItem = cancelBarButtonItem;
    self.navigationItem.rightBarButtonItem = cancelBarButtonItem;
}

- (void)setCancelButton:(UIButton *)cancelButton
{
    _cancelButton = cancelButton;
    self.navigationItem.rightBarButtonItem.customView = cancelButton;
}

- (void)setSearchHistoriesCachePath:(NSString *)searchHistoriesCachePath
{
    _searchHistoriesCachePath = [searchHistoriesCachePath copy];
    
    self.searchHistories = nil;
    if (PYSearchHistoryStyleCell == self.searchHistoryStyle) {
        [self.baseSearchTableView reloadData];
    } else {
        [self setSearchHistoryStyle:self.searchHistoryStyle];
    }
}

- (void)setHotSearchTags:(NSArray<UILabel *> *)hotSearchTags
{
    // popular search tagLabel's tag is 1, search history tagLabel's tag is 0.
    for (UILabel *tagLabel in hotSearchTags) {
        tagLabel.tag = 1;
    }
    _hotSearchTags = hotSearchTags;
}

- (void)setSearchBarBackgroundColor:(UIColor *)searchBarBackgroundColor
{
    _searchBarBackgroundColor = searchBarBackgroundColor;
    _searchTextField.backgroundColor = searchBarBackgroundColor;
}

- (void)setSearchSuggestions:(NSArray<NSString *> *)searchSuggestions
{
    if ([self.dataSource respondsToSelector:@selector(searchSuggestionView:cellForRowAtIndexPath:)]) {
        // set searchSuggestion is nil when cell of suggestion view is custom.
        _searchSuggestions = nil;
        return;
    }
    
    _searchSuggestions = [searchSuggestions copy];
    self.searchSuggestionVC.searchSuggestions = [searchSuggestions copy];
    
    self.baseSearchTableView.hidden = !self.searchSuggestionHidden && [self.searchSuggestionVC.tableView numberOfRowsInSection:0];
    self.searchSuggestionVC.view.hidden = self.searchSuggestionHidden || ![self.searchSuggestionVC.tableView numberOfRowsInSection:0];
}

- (void)setRankTagBackgroundColorHexStrings:(NSArray<NSString *> *)rankTagBackgroundColorHexStrings
{
    if (rankTagBackgroundColorHexStrings.count < 4) {
        NSArray *colorStrings = @[@"#f14230", @"#ff8000", @"#ffcc01", @"#ebebeb"];
        _rankTagBackgroundColorHexStrings = colorStrings;
    } else {
        _rankTagBackgroundColorHexStrings = @[rankTagBackgroundColorHexStrings[0], rankTagBackgroundColorHexStrings[1], rankTagBackgroundColorHexStrings[2], rankTagBackgroundColorHexStrings[3]];
    }
    
    self.hotSearches = self.hotSearches;
}

- (void)setHotSearches:(NSArray *)hotSearches
{
    _hotSearches = hotSearches;
    if (0 == hotSearches.count || !self.showHotSearch) {
        self.hotSearchHeader.hidden = YES;
        self.hotSearchTagsContentView.hidden = YES;
        if (PYSearchHistoryStyleCell == self.searchHistoryStyle) {
            UIView *tableHeaderView = self.baseSearchTableView.tableHeaderView;
            tableHeaderView.py_height = PYSEARCH_MARGIN * 1.5;
            [self.baseSearchTableView setTableHeaderView:tableHeaderView];
        }
        return;
    };
    
    self.baseSearchTableView.tableHeaderView.hidden = NO;
    self.hotSearchHeader.hidden = NO;
    self.hotSearchTagsContentView.hidden = NO;
    if (PYHotSearchStyleDefault == self.hotSearchStyle
        || PYHotSearchStyleColorfulTag == self.hotSearchStyle
        || PYHotSearchStyleBorderTag == self.hotSearchStyle
        || PYHotSearchStyleARCBorderTag == self.hotSearchStyle) {
        [self setupHotSearchNormalTags];
    } else if (PYHotSearchStyleRankTag == self.hotSearchStyle) {
        [self setupHotSearchRankTags];
    } else if (PYHotSearchStyleRectangleTag == self.hotSearchStyle) {
        [self setupHotSearchRectangleTags];
    }
    [self setSearchHistoryStyle:self.searchHistoryStyle];
}

- (void)setSearchHistoryStyle:(PYSearchHistoryStyle)searchHistoryStyle
{
    _searchHistoryStyle = searchHistoryStyle;
    
    if (!self.searchHistories.count || !self.showSearchHistory || UISearchBarStyleDefault == searchHistoryStyle) {
        self.searchHistoryHeader.hidden = YES;
        self.searchHistoryTagsContentView.hidden = YES;
        self.searchHistoryView.hidden = YES;
        self.emptyButton.hidden = YES;
        return;
    };
    
    self.searchHistoryHeader.hidden = NO;
    self.searchHistoryTagsContentView.hidden = NO;
    self.searchHistoryView.hidden = NO;
    self.emptyButton.hidden = NO;
    [self setupSearchHistoryTags];
    
    switch (searchHistoryStyle) {
        case PYSearchHistoryStyleColorfulTag:
            for (UILabel *tag in self.searchHistoryTags) {
                tag.textColor = [UIColor whiteColor];
                tag.layer.borderColor = nil;
                tag.layer.borderWidth = 0.0;
                tag.backgroundColor = PYSEARCH_COLORPolRandomColor;
            }
            break;
        case PYSearchHistoryStyleBorderTag:
            for (UILabel *tag in self.searchHistoryTags) {
                tag.backgroundColor = [UIColor clearColor];
                tag.layer.borderColor = PYSEARCH_COLOR(223, 223, 223).CGColor;
                tag.layer.borderWidth = 0.5;
            }
            break;
        case PYSearchHistoryStyleARCBorderTag:
            for (UILabel *tag in self.searchHistoryTags) {
                tag.backgroundColor = [UIColor clearColor];
                tag.layer.borderColor = PYSEARCH_COLOR(223, 223, 223).CGColor;
                tag.layer.borderWidth = 0.5;
                tag.layer.cornerRadius = tag.py_height * 0.5;
            }
            break;
        default:
            break;
    }
}

- (void)setHotSearchStyle:(PYHotSearchStyle)hotSearchStyle
{
    _hotSearchStyle = hotSearchStyle;
    
    switch (hotSearchStyle) {
        case PYHotSearchStyleColorfulTag:
            for (UILabel *tag in self.hotSearchTags) {
                tag.textColor = [UIColor whiteColor];
                tag.layer.borderColor = nil;
                tag.layer.borderWidth = 0.0;
                tag.backgroundColor = PYSEARCH_COLORPolRandomColor;
            }
            break;
        case PYHotSearchStyleBorderTag:
            for (UILabel *tag in self.hotSearchTags) {
                tag.backgroundColor = [UIColor clearColor];
                tag.layer.borderColor = PYSEARCH_COLOR(223, 223, 223).CGColor;
                tag.layer.borderWidth = 0.5;
            }
            break;
        case PYHotSearchStyleARCBorderTag:
            for (UILabel *tag in self.hotSearchTags) {
                tag.backgroundColor = [UIColor clearColor];
                tag.layer.borderColor = PYSEARCH_COLOR(223, 223, 223).CGColor;
                tag.layer.borderWidth = 0.5;
                tag.layer.cornerRadius = tag.py_height * 0.5;
            }
            break;
        case PYHotSearchStyleRectangleTag:
            self.hotSearches = self.hotSearches;
            break;
        case PYHotSearchStyleRankTag:
            self.rankTagBackgroundColorHexStrings = nil;
            break;
            
        default:
            break;
    }
}

- (void)setSearchViewControllerShowMode:(PYSearchViewControllerShowMode)searchViewControllerShowMode
{
    _searchViewControllerShowMode = searchViewControllerShowMode;
    if (_searchViewControllerShowMode == PYSearchViewControllerShowModeModal) { // modal
        self.navigationItem.rightBarButtonItem = _cancelBarButtonItem;
        self.navigationItem.leftBarButtonItem = nil;
    } else if (_searchViewControllerShowMode == PYSearchViewControllerShowModePush) { // push
        self.navigationItem.hidesBackButton = YES;
        self.navigationItem.leftBarButtonItem = _backBarButtonItem;
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)cancelDidClick
{
    [self.searchBar resignFirstResponder];
    
    if ([self.delegate respondsToSelector:@selector(didClickCancel:)]) {
        [self.delegate didClickCancel:self];
        return;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)backDidClick
{
    [self.searchBar resignFirstResponder];
    
    if ([self.delegate respondsToSelector:@selector(didClickBack:)]) {
        [self.delegate didClickBack:self];
        return;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)keyboardDidShow:(NSNotification *)noti
{
    NSDictionary *info = noti.userInfo;
    self.keyboardHeight = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    self.keyboardShowing = YES;
    // Adjust the content inset of suggestion view
    self.searchSuggestionVC.tableView.contentInset = UIEdgeInsetsMake(-30, 0, self.keyboardHeight + 30, 0);
}


- (void)emptySearchHistoryDidClick
{
    [self.searchHistories removeAllObjects];
    [NSKeyedArchiver archiveRootObject:self.searchHistories toFile:self.searchHistoriesCachePath];
    if (PYSearchHistoryStyleCell == self.searchHistoryStyle) {
        [self.baseSearchTableView reloadData];
    } else {
        self.searchHistoryStyle = self.searchHistoryStyle;
    }
    if (YES == self.swapHotSeachWithSearchHistory) {
        self.hotSearches = self.hotSearches;
    }
    PYSEARCH_LOG(@"%@", [NSBundle py_localizedStringForKey:PYSearchEmptySearchHistoryLogText]);
}

- (void)tagDidCLick:(UITapGestureRecognizer *)gr
{
    UILabel *label = (UILabel *)gr.view;
    self.searchBar.text = label.text;
    // popular search tagLabel's tag is 1, search history tagLabel's tag is 0.
    if (1 == label.tag) {
        if ([self.delegate respondsToSelector:@selector(searchViewController:didSelectHotSearchAtIndex:searchText:)]) {
            [self.delegate searchViewController:self didSelectHotSearchAtIndex:[self.hotSearchTags indexOfObject:label] searchText:label.text];
            [self saveSearchCacheAndRefreshView];
        } else {
            [self searchBarSearchButtonClicked:self.searchBar];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(searchViewController:didSelectSearchHistoryAtIndex:searchText:)]) {
            [self.delegate searchViewController:self didSelectSearchHistoryAtIndex:[self.searchHistoryTags indexOfObject:label] searchText:label.text];
            [self saveSearchCacheAndRefreshView];
        } else {
            [self searchBarSearchButtonClicked:self.searchBar];
        }
    }
    PYSEARCH_LOG(@"Search %@", label.text);
}

- (UILabel *)labelWithTitle:(NSString *)title
{
    UILabel *label = [[UILabel alloc] init];
    label.userInteractionEnabled = YES;
    label.font = [UIFont systemFontOfSize:12];
    label.text = title;
    label.textColor = [UIColor grayColor];
    label.backgroundColor = [UIColor py_colorWithHexString:@"#fafafa"];
    label.layer.cornerRadius = 3;
    label.clipsToBounds = YES;
    label.textAlignment = NSTextAlignmentCenter;
    [label sizeToFit];
    label.py_width += 20;
    label.py_height += 14;
    return label;
}

- (void)saveSearchCacheAndRefreshView
{
    UISearchBar *searchBar = self.searchBar;
    [searchBar resignFirstResponder];
    NSString *searchText = searchBar.text;
    if (self.removeSpaceOnSearchString) { // remove sapce on search string
       searchText = [searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    if (self.showSearchHistory && searchText.length > 0) {
        [self.searchHistories removeObject:searchText];
        [self.searchHistories insertObject:searchText atIndex:0];
        
        if (self.searchHistories.count > self.searchHistoriesCount) {
            [self.searchHistories removeLastObject];
        }
        [NSKeyedArchiver archiveRootObject:self.searchHistories toFile:self.searchHistoriesCachePath];
        
        if (PYSearchHistoryStyleCell == self.searchHistoryStyle) {
            [self.baseSearchTableView reloadData];
        } else {
            self.searchHistoryStyle = self.searchHistoryStyle;
        }
    }
    
    [self handleSearchResultShow];
}

- (void)handleSearchResultShow
{
    switch (self.searchResultShowMode) {
        case PYSearchResultShowModePush:
            self.searchResultController.view.hidden = NO;
            [self.navigationController pushViewController:self.searchResultController animated:YES];
            break;
        case PYSearchResultShowModeEmbed:
            if (self.searchResultController) {
                [self.view addSubview:self.searchResultController.view];
                [self addChildViewController:self.searchResultController];
                self.searchResultController.view.hidden = NO;
                self.searchResultController.view.py_y = NO == self.navigationController.navigationBar.translucent ? 0 : CGRectGetMaxY(self.navigationController.navigationBar.frame);
                self.searchResultController.view.py_height = self.view.py_height - self.searchResultController.view.py_y;
                self.searchSuggestionVC.view.hidden = YES;
            } else {
                PYSEARCH_LOG(@"PYSearchDebug： searchResultController cannot be nil when searchResultShowMode is PYSearchResultShowModeEmbed.");
            }
            break;
        case PYSearchResultShowModeCustom:
            
            break;
        default:
            break;
    }
}

#pragma mark - PYSearchSuggestionViewDataSource
- (NSInteger)numberOfSectionsInSearchSuggestionView:(UITableView *)searchSuggestionView
{
    if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInSearchSuggestionView:)]) {
        return [self.dataSource numberOfSectionsInSearchSuggestionView:searchSuggestionView];
    }
    return 1;
}

- (NSInteger)searchSuggestionView:(UITableView *)searchSuggestionView numberOfRowsInSection:(NSInteger)section
{
    if ([self.dataSource respondsToSelector:@selector(searchSuggestionView:numberOfRowsInSection:)]) {
        NSInteger numberOfRow = [self.dataSource searchSuggestionView:searchSuggestionView numberOfRowsInSection:section];
        searchSuggestionView.hidden = self.searchSuggestionHidden || !self.searchBar.text.length || 0 == numberOfRow;
        self.baseSearchTableView.hidden = !searchSuggestionView.hidden;
        return numberOfRow;
    }
    return self.searchSuggestions.count;
}

- (UITableViewCell *)searchSuggestionView:(UITableView *)searchSuggestionView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataSource respondsToSelector:@selector(searchSuggestionView:cellForRowAtIndexPath:)]) {
        return [self.dataSource searchSuggestionView:searchSuggestionView cellForRowAtIndexPath:indexPath];
    }
    return nil;
}

- (CGFloat)searchSuggestionView:(UITableView *)searchSuggestionView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataSource respondsToSelector:@selector(searchSuggestionView:heightForRowAtIndexPath:)]) {
        return [self.dataSource searchSuggestionView:searchSuggestionView heightForRowAtIndexPath:indexPath];
    }
    return 44.0;
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if ([self.delegate respondsToSelector:@selector(searchViewController:didSearchWithSearchBar:searchText:)]) {
        [self.delegate searchViewController:self didSearchWithSearchBar:searchBar searchText:searchBar.text];
        [self saveSearchCacheAndRefreshView];
        return;
    }
    if (self.didSearchBlock) self.didSearchBlock(self, searchBar, searchBar.text);
    [self saveSearchCacheAndRefreshView];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (PYSearchResultShowModeEmbed == self.searchResultShowMode && self.showSearchResultWhenSearchTextChanged) {
        [self handleSearchResultShow];
        self.searchResultController.view.hidden = 0 == searchText.length;
    } else if (self.searchResultController) {
        self.searchResultController.view.hidden = YES;
    }
    self.baseSearchTableView.hidden = searchText.length && !self.searchSuggestionHidden && [self.searchSuggestionVC.tableView numberOfRowsInSection:0];
    self.searchSuggestionVC.view.hidden = self.searchSuggestionHidden || !searchText.length || ![self.searchSuggestionVC.tableView numberOfRowsInSection:0];
    if (self.searchSuggestionVC.view.hidden) {
        self.searchSuggestions = nil;
    }
    [self.view bringSubviewToFront:self.searchSuggestionVC.view];
    if ([self.delegate respondsToSelector:@selector(searchViewController:searchTextDidChange:searchText:)]) {
        [self.delegate searchViewController:self searchTextDidChange:searchBar searchText:searchText];
    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    if (PYSearchResultShowModeEmbed == self.searchResultShowMode) {
        self.searchResultController.view.hidden = 0 == searchBar.text.length || !self.showSearchResultWhenSearchBarRefocused;
        self.searchSuggestionVC.view.hidden = self.searchSuggestionHidden || !searchBar.text.length || ![self.searchSuggestionVC.tableView numberOfRowsInSection:0];
        if (self.searchSuggestionVC.view.hidden) {
            self.searchSuggestions = nil;
        }
        self.baseSearchTableView.hidden = searchBar.text.length && !self.searchSuggestionHidden && ![self.searchSuggestionVC.tableView numberOfRowsInSection:0];
    }
    [self setSearchSuggestions:self.searchSuggestions];
    return YES;
}

- (void)closeDidClick:(UIButton *)sender
{
    UITableViewCell *cell = (UITableViewCell *)sender.superview;
    [self.searchHistories removeObject:cell.textLabel.text];
    [NSKeyedArchiver archiveRootObject:self.searchHistories toFile:self.searchHistoriesCachePath];
    [self.baseSearchTableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    self.baseSearchTableView.tableFooterView.hidden = 0 == self.searchHistories.count || !self.showSearchHistory;
    return self.showSearchHistory && PYSearchHistoryStyleCell == self.searchHistoryStyle ? self.searchHistories.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"PYSearchHistoryCellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.textLabel.textColor = PYTextColor;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.backgroundColor = [UIColor clearColor];
        
        UIButton *closetButton = [[UIButton alloc] init];
        closetButton.py_size = CGSizeMake(cell.py_height, cell.py_height);
        [closetButton setImage:[NSBundle py_imageNamed:@"close"] forState:UIControlStateNormal];
        UIImageView *closeView = [[UIImageView alloc] initWithImage:[NSBundle py_imageNamed:@"close"]];
        [closetButton addTarget:self action:@selector(closeDidClick:) forControlEvents:UIControlEventTouchUpInside];
        closeView.contentMode = UIViewContentModeCenter;
        cell.accessoryView = closetButton;
        UIImageView *line = [[UIImageView alloc] initWithImage:[NSBundle py_imageNamed:@"cell-content-line"]];
        line.py_height = 0.5;
        line.alpha = 0.7;
        line.py_x = PYSEARCH_MARGIN;
        line.py_y = 43;
        line.py_width = tableView.py_width;
        line.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [cell.contentView addSubview:line];
    }
    
    cell.imageView.image = [NSBundle py_imageNamed:@"search_history"];
    cell.textLabel.text = self.searchHistories[indexPath.row];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.showSearchHistory && self.searchHistories.count && PYSearchHistoryStyleCell == self.searchHistoryStyle ? (self.searchHistoryTitle.length ? self.searchHistoryTitle : [NSBundle py_localizedStringForKey:PYSearchSearchHistoryText]) : nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.searchHistories.count && self.showSearchHistory && PYSearchHistoryStyleCell == self.searchHistoryStyle ? 25 : 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 240*kScale;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *Lab = [[UILabel alloc] initWithFrame:CGRectMake(15*kScale, 0, kWidth-30*kScale, 60*kScale)];
    Lab.textColor = RGB(51, 51, 51, 1);
    Lab.font = [UIFont systemFontOfSize:15.0f*kScale];
    Lab.text = @"热搜推荐";
    Lab.textAlignment = NSTextAlignmentLeft;
    [view addSubview:Lab];
    
    //1.初始化layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置collectionView滚动方向
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //设置headerView的尺寸大小
//    layout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 30);
    //该方法也可以设置itemSize
    layout.itemSize =CGSizeMake(115*kScale, 167*kScale+22*kScale);
    
    //2.初始化collectionView
    mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 60*kScale, kWidth, 167*kScale+22*kScale) collectionViewLayout:layout];
    [view addSubview:mainCollectionView];
    mainCollectionView.backgroundColor = [UIColor clearColor];
    mainCollectionView.showsHorizontalScrollIndicator = NO;
    

    //3.注册collectionViewCell
    //注意，此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致 均为 cellId
    [mainCollectionView registerClass:[SearchCollectionViewCell class] forCellWithReuseIdentifier:@"hot_cellId"];
    
    //注册headerView  此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致  均为reusableView
    [mainCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView"];
    
    //4.设置代理
    mainCollectionView.delegate = self;
    mainCollectionView.dataSource = self;
   
    
    
    return view;
}



#pragma mark collectionView代理方法
//返回section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataMarray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"hot_cellId" forIndexPath:indexPath];
//    if (cell == nil) {
//        cell = (SearchCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"hot_cellId" forIndexPath:indexPath];
//
//    }
    cell.backgroundColor = [UIColor whiteColor];
//    DLog(@"%ld" ,self.dataMarray.count);
    if (self.dataMarray.count != 0) {
        cell.cartBtn.tag = indexPath.row;
        [cell.cartBtn addTarget:self action:@selector(cartBtnAction:) forControlEvents:1];
        HomePageModel *model = self.dataMarray[indexPath.item];
        [cell configHomePageCellWithModel:model];
        ///是否可以查看价格
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        
        if ([[user valueForKey:@"approve"] isEqualToString:@"1"]) {
            
            
        }else if ([[user valueForKey:@"approve"] isEqualToString:@"0"] || [[user valueForKey:@"approve"] isEqualToString:@"2"]){
            ///点击查看价格点击事件
            [cell.newsPriceBtn addTarget:self action:@selector(checkPricesAction) forControlEvents:1];
        }
    }
   
    return cell;
}



#pragma mark ==============查看价格

-(void)checkPricesAction{
    
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    if ([[user valueForKey:@"isLoginState"] isEqualToString:@"0"]) {
        LoginViewController *VC = [LoginViewController new];
        VC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:VC animated:YES];
    }else if ([[user valueForKey:@"isLoginState"] isEqualToString:@"1"]){
        
        
        if ([[user valueForKey:@"approve"] isEqualToString:@"0"]) {///认证未通过
            MMPopupItemHandler block = ^(NSInteger index){
                if (index == 0) {
                    NSString *str = [NSString stringWithFormat:@"tel:%@",@"4001106111"];
                    dispatch_async(dispatch_get_main_queue(), ^(){
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                    });
                }
            };
            NSArray *items = @[MMItemMake(@"联系客服", MMItemTypeNormal, block) , MMItemMake(@"再等等", MMItemTypeNormal, block)];
            MMMyCustomView *alertView =  [[MMMyCustomView alloc] initWithTitle:@"认证提示" detail:@"您的认证申请还未通过，请耐心等待！\n客服热线：4001106111" items:items];
            
            alertView.attachedView.mm_dimBackgroundBlurEnabled = NO;
            
            alertView.attachedView.mm_dimBackgroundBlurEffectStyle = UIBlurEffectStyleDark;
            
            [alertView show];
            
            
            
        }else  if ([[user valueForKey:@"approve"] isEqualToString:@"2"]) {///未认证
            MMPopupItemHandler block = ^(NSInteger index){
                if (index == 0) {
                    
                    ShopCertificationViewController *VC = [ShopCertificationViewController new];
                    VC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:VC animated:YES];
                }
            };
            NSArray *items = @[MMItemMake(@"去认证", MMItemTypeNormal, block)];
            MMMyCustomView *alertView =  [[MMMyCustomView alloc] initWithTitle:@"认证提示" detail:@"您还未通过商户认证，请先提交认证申请!" items:items];
            
            alertView.attachedView.mm_dimBackgroundBlurEnabled = NO;
            
            alertView.attachedView.mm_dimBackgroundBlurEffectStyle = UIBlurEffectStyleDark;
            
            [alertView show];
            
            
        }
        
    }
    
    
    
}



//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(115*kScale, 167*kScale);
}


#pragma mark =============== 加入购物车点击事件


-(void)cartBtnAction:(UIButton*)btn{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if ([user valueForKey:@"isLoginState"]) {
        [GlobalHelper shareInstance].isLoginState = [user valueForKey:@"isLoginState"];
    }
    if ([[GlobalHelper shareInstance].isLoginState isEqualToString:@"1"])
    {
        
        if ([self.isShowShareString isEqualToString:@"0"]) {///c端,
            
            //---
            NSIndexPath *myIndex=[mainCollectionView indexPathForCell:(SearchCollectionViewCell*)[btn superview]];
            SearchCollectionViewCell *cell1 = [mainCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:btn.tag inSection:myIndex.section]];
            //后期可能会有此需求(商品首页回显加入购物车数量)下面一行需要删掉
            // [cell1.cartBtn removeFromSuperview];
            
            if (self.dataMarray.count != 0)
            {
                HomePageModel *model = self.dataMarray[myIndex.row];
                
                [self addCartPostDataWithProductId:model.id homePageModel:model NSIndexPath:myIndex cell:cell1 isFirstClick:YES tableView:self.baseSearchTableView];
                
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:myIndex.row inSection:myIndex.section];
                // [self.myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                
            }

        }else{
            
            if ([[user valueForKey:@"approve"] isEqualToString:@"0"]) {///认证未通过
                MMPopupItemHandler block = ^(NSInteger index){
                    if (index == 0) {
                        NSString *str = [NSString stringWithFormat:@"tel:%@",@"4001106111"];
                        dispatch_async(dispatch_get_main_queue(), ^(){
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                        });
                    }
                };
                NSArray *items = @[MMItemMake(@"联系客服", MMItemTypeNormal, block) , MMItemMake(@"再等等", MMItemTypeNormal, block)];
                MMMyCustomView *alertView =  [[MMMyCustomView alloc] initWithTitle:@"认证提示" detail:@"您的认证申请还未通过，请耐心等待！\n客服热线：4001106111" items:items];
                
                alertView.attachedView.mm_dimBackgroundBlurEnabled = NO;
                
                alertView.attachedView.mm_dimBackgroundBlurEffectStyle = UIBlurEffectStyleDark;
                
                [alertView show];
                
                
                
            }else  if ([[user valueForKey:@"approve"] isEqualToString:@"2"]) {///未认证
                MMPopupItemHandler block = ^(NSInteger index){
                    if (index == 0) {
                        
                        ShopCertificationViewController *VC = [ShopCertificationViewController new];
                        VC.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:VC animated:YES];
                    }
                };
                NSArray *items = @[MMItemMake(@"去认证", MMItemTypeNormal, block)];
                MMMyCustomView *alertView =  [[MMMyCustomView alloc] initWithTitle:@"认证提示" detail:@"您还未通过商户认证，请先提交认证申请!" items:items];
                
                alertView.attachedView.mm_dimBackgroundBlurEnabled = NO;
                
                alertView.attachedView.mm_dimBackgroundBlurEffectStyle = UIBlurEffectStyleDark;
                
                [alertView show];
                
                
            }else if ([[user valueForKey:@"approve"] isEqualToString:@"1"]){
                
                
                /////
                
                //---
                NSIndexPath *myIndex=[mainCollectionView indexPathForCell:(SearchCollectionViewCell*)[btn superview]];
                SearchCollectionViewCell *cell1 = [mainCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:btn.tag inSection:myIndex.section]];
                //后期可能会有此需求(商品首页回显加入购物车数量)下面一行需要删掉
                // [cell1.cartBtn removeFromSuperview];
                
                if (self.dataMarray.count != 0)
                {
                    HomePageModel *model = self.dataMarray[myIndex.row];
                    
                    [self addCartPostDataWithProductId:model.id homePageModel:model NSIndexPath:myIndex cell:cell1 isFirstClick:YES tableView:self.baseSearchTableView];
                    
                    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:myIndex.row inSection:myIndex.section];
                    // [self.myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                    
                }

                
                
            }
            
            
            
        }
        
        
        
        
        
    }else
    {
        LoginViewController *VC = [LoginViewController new];
        VC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:VC animated:YES];
        
        
    }
}




-(void)addCartPostDataWithProductId:(NSInteger)productId homePageModel:(HomePageModel*)model NSIndexPath:(NSIndexPath*)indexPath cell:(SearchCollectionViewCell*)weakCell isFirstClick:(BOOL)isFirst tableView:(UITableView*)tableView{
    //[SVProgressHUD show];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *ticket = [user valueForKey:@"ticket"];
    NSString *secret = @"UHnyKzP5sNmh2EV0Dflgl4VfzbaWc4crQ7JElfw1cuNCbcJUau";
    NSString *nonce = [self ret32bitString];//随机数
    NSString *curTime = [self dateTransformToTimeSp];
    NSString *checkSum = [self sha1:[NSString stringWithFormat:@"%@%@%@" ,secret ,  nonce ,curTime]];
    
    [dic setValue:secret forKey:@"secret"];
    [dic setValue:nonce forKey:@"nonce"];
    [dic setValue:curTime forKey:@"curTime"];
    [dic setValue:checkSum forKey:@"checkSum"];
    [dic setValue:ticket forKey:@"ticket"];
    [dic setValue:mTypeIOS forKey:@"mtype"];
    
    [dic setValue:[user valueForKey:@"appVersionNumber"] forKey:@"appVersionNumber"];
    [dic setValue:[user valueForKey:@"user"] forKey:@"user"];
#pragma mark---------------------------------需要更改productID--------------------------------
    
    //[dic setObject:[NSString stringWithFormat:@"%ld" ,productId] forKey:@"productId"];
    [dic setValue:[NSString stringWithFormat:@"%ld" ,(long)productId] forKey:@"commodityId"];
    
    [dic setObject:@"1" forKey:@"quatity"];
    if ([[user valueForKey:@"approve"] isEqualToString:@"0"] || [[user valueForKey:@"approve"] isEqualToString:@"2"]) {
        
        [dic setValue:@"PERSON" forKey:@"showType"];
        
    }else if ([[user valueForKey:@"approve"] isEqualToString:@"1"]){
        
        [dic setValue:@"SOGO" forKey:@"showType"];
        
    }
    DLog(@"加入购物车 ==== %@" , dic);
    [MHNetworkManager  postReqeustWithURL:[NSString stringWithFormat:@"%@/m/auth/cart/add",baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
        //
        //        HomePageModel *modelq = [HomePageModel yy_modelWithJSON:returnData];
        //
        //        if ([modelq isEqual:@"(null)"]) {
        //            DLog(@"sss");
        //        }
        if ([returnData[@"code"]  isEqualToString:@"0404"] || [returnData[@"code"]  isEqualToString:@"04"]) {
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setValue:@"0" forKey:@"isLoginState"];
            LoginViewController *VC = [LoginViewController new];
            VC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:VC animated:YES];
        }
        
        
        
        if ([returnData[@"status"] integerValue] == 200)
        {
            //            SVProgressHUD.minimumDismissTimeInterval = 0.5;
            //            SVProgressHUD.maximumDismissTimeInterval = 1;
            //            [SVProgressHUD showSuccessWithStatus:returnData[@"msg"]];
            //加入购物车动画
            NSInteger count = [weakCell.cartView.numberLabel.text integerValue];
            count++;
            weakCell.cartView.numberLabel.text = [NSString stringWithFormat:@"%ld",(long)count];
            model.number = count ;
            if (isFirst == YES) {
                model.number = 1;
                
            }
            [SVProgressHUD showSuccessWithStatus:@"加入购物车成功"];
//            CGRect rect = [tableView rectForRowAtIndexPath:indexPath];
//            //获取当前cell 相对于self.view 当前的坐标
//            rect.origin.y = rect.origin.y - [tableView contentOffset].y;
//            CGRect imageViewRect = weakCell.mainImv.frame;
//            if (tableView.tag == 100) {///来自分来列表
//                imageViewRect.origin.y = rect.origin.y+imageViewRect.origin.y+kBarHeight+116;
//
//            }else{
//                imageViewRect.origin.y = rect.origin.y+imageViewRect.origin.y;
//            }
//            DLog(@"-------------=== %f  %f" ,rect.origin.y , imageViewRect.origin.y );
//
//            [[PurchaseCarAnimationTool shareTool]startAnimationandView:weakCell.mainImv andRect:imageViewRect andFinisnRect:CGPointMake(ScreenWidth/4*2, ScreenHeight-49) topView:self.view andFinishBlock:^(BOOL finish) {
//
//
//                UIView *tabbarBtn = self.tabBarController.tabBar.subviews[2];
//                [PurchaseCarAnimationTool shakeAnimation:tabbarBtn];
//            }];
            [[GlobalHelper shareInstance].addShoppingCartMarray addObject:model];
            
            if ([[GlobalHelper shareInstance].addShoppingCartMarray containsObject:model]) {
                [[GlobalHelper shareInstance].addShoppingCartMarray removeObject:model];
                [[GlobalHelper shareInstance].addShoppingCartMarray addObject:model];
            }
            
            [GlobalHelper shareInstance].shoppingCartBadgeValue += 1;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"shoppingCart" object:nil userInfo:nil];
            
            
            
        }
        else
        {
            //            model.number = 0;
            
            SVProgressHUD.minimumDismissTimeInterval = 0.5;
            SVProgressHUD.maximumDismissTimeInterval = 2;
            [SVProgressHUD showErrorWithStatus:returnData[@"msg"]];
        }
       // [tableView reloadData];
    } failureBlock:^(NSError *error) {
        
        
    } showHUD:NO];
    
}


///sha1加密方式

- (NSString *) sha1:(NSString *)input
{
    //const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    //NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

//1970获取当前时间转为时间戳
- (NSString *)dateTransformToTimeSp{
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970];
    NSString *timeSp = [NSString stringWithFormat:@"%llu",recordTime];
    return timeSp;
}

///随机数

-(NSString *)ret32bitString

{
    
    char data[32];
    
    for (int x=0;x<32;data[x++] = (char)('A' + (arc4random_uniform(26))));
    
    return [[NSString alloc] initWithBytes:data length:32 encoding:NSUTF8StringEncoding];
    
}



#pragma mark = 热门推荐数据
-(void)requestListData:(NSInteger)currentPage{

    [MHAsiNetworkHandler startMonitoring];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    
    NSString *showType = [GlobalHelper shareInstance].showType;
    
    [MHNetworkManager getRequstWithURL:[NSString stringWithFormat:@"%@/m/search/get_top_ten_commodity?mtype=%@&appVersionNumber=%@&user=%@&showType=%@" , baseUrl ,mTypeIOS ,[user valueForKey:@"appVersionNumber"] , [user valueForKey:@"user"] , showType] params:nil successBlock:^(NSDictionary *returnData) {

        
        if ([[returnData[@"status"] stringValue] isEqualToString:@"200"]) {

            [self.dataMarray removeAllObjects];
            for (NSDictionary *dic in returnData[@"data"]) {
                HomePageModel *model = [HomePageModel yy_modelWithJSON:dic];
                NSMutableArray *mainImvMarray = [NSMutableArray arrayWithArray:[model.mainImage componentsSeparatedByString:@","]];
                if (mainImvMarray.count!=0) {
                    model.mainImage = [mainImvMarray firstObject];
                }
              
                if ([showType isEqualToString:@"PERSON"]) {
                    model.goodsTypes = @"0";
                    self.isShowShareString = @"0";
                }else if ([showType isEqualToString:@"SOGO"]){
                    model.goodsTypes = @"1";
                    self.isShowShareString = @"1";


                }
                
                [self.dataMarray addObject:model];
            }

            [self.baseSearchTableView reloadData];
        }



    } failureBlock:^(NSError *error) {


    } showHUD:NO];


}



//footer的size
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
//{
//    return CGSizeMake(10, 10);
//}

//header的size
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
//{
//    return CGSizeMake(10, 10);
//}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(15, 15, 15, 15);
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 15;
}


//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 15;
}


//通过设置SupplementaryViewOfKind 来设置头部或者底部的view，其中 ReuseIdentifier 的值必须和 注册是填写的一致，本例都为 “reusableView”
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView" forIndexPath:indexPath];
    headerView.backgroundColor =[UIColor grayColor];
    UILabel *label = [[UILabel alloc] initWithFrame:headerView.bounds];
    label.text = @"这是collectionView的头部";
    label.font = [UIFont systemFontOfSize:20];
    [headerView addSubview:label];
    return headerView;
}

//点击item方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
        if (self.dataMarray.count != 0) {
            HomePageDetailsViewController *VC = [HomePageDetailsViewController new];
            VC.hidesBottomBarWhenPushed = YES;
            HomePageModel *model = self.dataMarray[indexPath.item];
            VC.detailsId = [NSString stringWithFormat:@"%ld" ,(long)model.id];
    
            [self.navigationController pushViewController:VC animated:YES];
        }
    
    
    
    
}



#pragma mark - UITableViewDelegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.searchBar.text = cell.textLabel.text;
        
    if ([self.delegate respondsToSelector:@selector(searchViewController:didSelectSearchHistoryAtIndex:searchText:)]) {
        [self.delegate searchViewController:self didSelectSearchHistoryAtIndex:indexPath.row searchText:cell.textLabel.text];
        [self saveSearchCacheAndRefreshView];
    } else {
        [self searchBarSearchButtonClicked:self.searchBar];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.keyboardShowing) {
        // Adjust the content inset of suggestion view
        self.searchSuggestionVC.tableView.contentInset = UIEdgeInsetsMake(-30, 0, 30, 0);
        [self.searchBar resignFirstResponder];
    }
}

@end
