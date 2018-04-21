//
//  MainViewController.m
//  多标签视图选择器
//
//  Created by change_pan on 2018/4/20.
//  Copyright © 2018年 kocla. All rights reserved.
//

#import "MainViewController.h"
#import "PageTitleView.h"
#import "Common.h"
#import "PageContentView.h"


@interface MainViewController ()<PageTitleViewDelegate,PageContentViewDelegate>

@property (nonatomic, strong) PageTitleView *titleView;
@property (nonatomic, strong) PageContentView *contentView;
@end

@implementation MainViewController

#pragma mark - lazy

-(PageTitleView *)titleView
{
    if (!_titleView) {
        NSArray *titles = @[@"测试1", @"测试2", @"测试3", @"测试4"];
        _titleView = [[PageTitleView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, 40) titles:titles];
        _titleView.delegate = self;
    }
    return _titleView;
}

-(PageContentView *)contentView
{
    if (!_contentView) {
        NSMutableArray *childVCs = [NSMutableArray array];
        for (int i = 0; i < 4; i ++) {
            UIViewController *VC = [[UIViewController alloc] init];
            VC.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
            [childVCs addObject:VC];
        }
        _contentView = [[PageContentView alloc] initWithFrame:CGRectMake(0, 104, kScreenW, kScreenH-104) childVCs:[childVCs copy] parentVC:self];
        _contentView.delegate = self;
    }
    
    return _contentView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
    self.view.backgroundColor = [UIColor grayColor];
    [self setupUI];
    
}


//设置UI界面
-(void)setupUI {
    
    self.titleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.titleView];
    
    self.contentView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.contentView];
    
}

#pragma mark - PageTitleViewDelegate
-(void)pageTitleView:(PageTitleView *)view selectIndex:(NSInteger)selectIndex
{
    [self.contentView setCurrentIndex:selectIndex];
}

#pragma mark - PageContentViewDelegate
-(void)pageConetentView:(PageContentView *)contentView progress:(CGFloat)progress currentIndex:(NSInteger)currentIndenx targetIndex:(NSInteger)targetIndex
{
    [self.titleView setScrollLineWithProgress:progress currentIndex:currentIndenx targetIndex:targetIndex];
}

-(void)pageConetentView:(PageContentView *)contentView targetIndex:(NSInteger)targetIndex
{
    [self.titleView setBtnSelectIndex:targetIndex];
}



@end
