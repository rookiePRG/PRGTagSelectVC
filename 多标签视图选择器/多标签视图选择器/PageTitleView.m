//
//  PageTitleView.m
//  多标签视图选择器
//
//  Created by change_pan on 2018/4/20.
//  Copyright © 2018年 kocla. All rights reserved.
//

#import "PageTitleView.h"
#import "Common.h"
#define kScrollLineH 2

@interface PageTitleView ()
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) UIView *scrollLine;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *btns;

@end

@implementation PageTitleView
{
    UIButton *_selectBtn;
}

#pragma mark - lazy

-(NSMutableArray *)btns
{
    if (!_btns) {
        _btns = [NSMutableArray array];
    }
    return _btns;
}

-(UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.scrollsToTop = NO;
        _scrollView.bounces = NO;
        
    }
    return _scrollView;
}

-(UIView *)scrollLine
{
    if (!_scrollLine) {
        _scrollLine = [[UIView alloc] init];
        _scrollLine.backgroundColor = [UIColor orangeColor];
    }
    return _scrollLine;
}


-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles
{
    self = [super initWithFrame:frame];
    if (self) {
        _titles = titles;
        [self setupUI];
    }
    return self;
}

//设置UI界面
-(void)setupUI {
    
    [self addSubview:self.scrollView];
    
    [self setupBtns];
    
    [self setupBottomLineAndScrollLine];
    
    
}

//添加按钮
-(void)setupBtns {
    CGFloat btnW = kScreenW/_titles.count;
    CGFloat btnH = self.bounds.size.height - kScrollLineH;
    CGFloat btnY = 0;
    for (int i = 0; i < _titles.count; i ++) {
        CGFloat btnX = i * btnW;
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(btnX, btnY, btnW, btnH)];
        [btn setTitle:_titles[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        btn.tag = i;
        if (i == 0) {
            btn.selected = YES;
            _selectBtn = btn;
        }
        
        [_scrollView addSubview:btn];
        [self.btns addObject:btn];
        
        [btn addTarget:self action:@selector(btn_click:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    _scrollView.contentSize = CGSizeMake(kScreenW, 0);
    
}

//添加底部线条和滑块
-(void)setupBottomLineAndScrollLine {
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-0.5, kScreenW, 0.5)];
    bottomLine.backgroundColor = [UIColor grayColor];
    [self addSubview:bottomLine];
    
    self.scrollLine.frame = CGRectMake(_selectBtn.frame.origin.x, self.bounds.size.height - kScrollLineH, _selectBtn.bounds.size.width, kScrollLineH);
    [_scrollView addSubview:self.scrollLine];
    
    
}

//按钮点击事件
-(void)btn_click:(UIButton *)sender
{
    _selectBtn.selected = NO;
    sender.selected = YES;
    _selectBtn = sender;
    [UIView animateWithDuration:0.15 animations:^{
        CGRect frame = self.scrollLine.frame;
        frame.origin.x = sender.frame.origin.x;
        self.scrollLine.frame = frame;
        
    }];
    
    if (_delegate && [_delegate respondsToSelector:@selector(pageTitleView:selectIndex:)]) {
        
        [_delegate pageTitleView:self selectIndex:_selectBtn.tag];
    }
}

-(void)setScrollLineWithProgress:(CGFloat)progress currentIndex:(NSInteger)currentIndenx targetIndex:(NSInteger)targetIndex
{
    UIButton *currentBtn = _btns[currentIndenx];
    UIButton *targetBtn = _btns[targetIndex];
    
    CGFloat moveTotalX = targetBtn.frame.origin.x - currentBtn.frame.origin.x;
    CGFloat moveX = progress * moveTotalX;
    CGRect frame = self.scrollLine.frame;
    frame.origin.x = currentBtn.frame.origin.x + moveX;
    self.scrollLine.frame = frame;
}

-(void)setBtnSelectIndex:(NSInteger)selectIndex
{
    _selectBtn.selected = NO;
    UIButton *currentBtn = _btns[selectIndex];
    currentBtn.selected = YES;
    _selectBtn = currentBtn;
}

@end
