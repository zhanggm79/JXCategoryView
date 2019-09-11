//
//  LoadDataListCollectionViewController.m
//  JXCategoryView
//
//  Created by jiaxin on 2019/2/26.
//  Copyright © 2019 jiaxin. All rights reserved.
//

#import "LoadDataListCollectionViewController.h"
#import "JXCategoryView.h"
#import "JXCategoryListCollectionContainerView.h"
#import "LoadDataListCollectionListViewController.h"

@interface LoadDataListCollectionViewController () <JXCategoryViewDelegate, JXCategoryListCollectionContainerViewDataSource>
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) JXCategoryListCollectionContainerView *listContainerView;
@property (nonatomic, strong) NSArray <NSString *> *titles;
@end

@implementation LoadDataListCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    self.titles = [self getRandomTitles];
    self.categoryView = [[JXCategoryTitleView alloc] init];

    self.categoryView.titles = self.titles;
    self.categoryView.delegate = self;
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    self.categoryView.indicators = @[lineView];
    [self.view addSubview:self.categoryView];

    self.listContainerView = [[JXCategoryListCollectionContainerView alloc] initWithDataSource:self];
    [self.view addSubview:self.listContainerView];

    self.categoryView.contentScrollView = self.listContainerView.collectionView;
}

//!!!!!!!!!!!!!!!!!!!如果你的列表是UIViewController，且你的列表依赖ViewWillAppear等生命周期方法，请添加下面的方法。避免生命周期方法重复调用!!!!!!!!!!!!!!!!!!!!!!!!
- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    self.categoryView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 50);
    self.listContainerView.frame = CGRectMake(0, 50, self.view.bounds.size.width, self.view.bounds.size.height - 50);
}

/**
 重载数据源：比如从服务器获取新的数据、否则用户对分类进行了排序等
 */
- (void)reloadData {
    self.titles = [self getRandomTitles];

    //重载之后默认回到0，你也可以指定一个index
    self.categoryView.defaultSelectedIndex = 0;
    self.categoryView.titles = self.titles;
    [self.categoryView reloadData];

    self.listContainerView.defaultSelectedIndex = 0;
    [self.listContainerView reloadData];
}

#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    [self.listContainerView didClickSelectedItemAtIndex:index];
}

- (void)categoryView:(JXCategoryBaseView *)categoryView scrollingFromLeftIndex:(NSInteger)leftIndex toRightIndex:(NSInteger)rightIndex ratio:(CGFloat)ratio {
    [self.listContainerView scrollingFromLeftIndex:leftIndex toRightIndex:rightIndex ratio:ratio selectedIndex:categoryView.selectedIndex];
}

#pragma mark - JXCategoryListCollectionContainerViewDataSource

- (id<JXCategoryListCollectionContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    LoadDataListCollectionListViewController *listVC = [[LoadDataListCollectionListViewController alloc] init];
    listVC.naviController = self.navigationController;
    listVC.title = self.titles[index];
    return listVC;
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.titles.count;
}

@end
