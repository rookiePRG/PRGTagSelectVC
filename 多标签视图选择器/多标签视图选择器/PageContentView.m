//
//  PageContentView.m
//  多标签视图选择器
//
//  Created by change_pan on 2018/4/20.
//  Copyright © 2018年 kocla. All rights reserved.
//

#import "PageContentView.h"

static NSString * const contentCellID = @"contentCellID";

@interface PageContentView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) NSArray *childVCs;
@property (nonatomic, weak) UIViewController *parentVC;
@property (nonatomic, strong) UICollectionView * collectionView;

@end


@implementation PageContentView
{
    CGFloat _beginOffsetx;
    BOOL _isForbidScrollDelegate;
}

#pragma mark - lazy

-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        //创建layout
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = self.bounds.size;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        //创建collectionView
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.bounces = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:contentCellID];
        
        
    }
    return _collectionView;
}


-(instancetype)initWithFrame:(CGRect)frame childVCs:(NSArray *)childVCs parentVC:(UIViewController *)parentVC
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _childVCs = childVCs;
        _parentVC = parentVC;
        [self setupUI];
        
    }
    return self;
}

//设置UI界面
-(void)setupUI{
    
    for (UIViewController *vc in _childVCs) {
        [self.parentVC addChildViewController:vc];
    }
    
    self.collectionView.frame = self.bounds;
    [self addSubview:self.collectionView];
    
}

-(void)setCurrentIndex:(NSInteger)currentIndex
{
    _isForbidScrollDelegate = YES;
    CGFloat offsetX = currentIndex * _collectionView.frame.size.width;
    [_collectionView setContentOffset:CGPointMake(offsetX, 0) animated:NO];
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.childVCs.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:contentCellID forIndexPath:indexPath];
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    UIViewController *vc = self.childVCs[indexPath.item];
    vc.view.frame = cell.contentView.frame;
    [cell.contentView addSubview:vc.view];
    return cell;
}

#pragma mark -UICollectionViewDelegate

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _isForbidScrollDelegate = NO;
    _beginOffsetx = scrollView.contentOffset.x;
    NSLog(@"--------%f",_beginOffsetx);
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_isForbidScrollDelegate) {
        return;
    }
    
    CGFloat progress = 0;//滑动比例
    NSInteger currentIndex = 0; //当前
    NSInteger targetIndex = 0; //目标
    CGFloat contentOffsetX = scrollView.contentOffset.x;
    CGFloat scrollViewW = scrollView.frame.size.width;
    if (contentOffsetX > _beginOffsetx) {//右滑
        progress = contentOffsetX/scrollViewW - (NSInteger)(contentOffsetX/scrollViewW);
        currentIndex = (NSInteger)(contentOffsetX/scrollViewW);
        targetIndex = currentIndex + 1;
        if (targetIndex >= _childVCs.count) {
            targetIndex = _childVCs.count - 1;
        }
        
        if (contentOffsetX - _beginOffsetx == scrollViewW) {
            progress = 1;
            targetIndex = currentIndex;
        }
    }
    else{//左滑
        progress = 1 -(contentOffsetX/scrollViewW - (NSInteger)(contentOffsetX/scrollViewW));
        targetIndex = (NSInteger)(contentOffsetX/scrollViewW);
        currentIndex = targetIndex + 1;
        if (currentIndex >= _childVCs.count) {
            currentIndex = _childVCs.count - 1;
        }
    }

    if (_delegate && [_delegate respondsToSelector:@selector(pageConetentView:progress:currentIndex:targetIndex:)]) {
        [_delegate pageConetentView:self progress:progress currentIndex:currentIndex targetIndex:targetIndex];
    }
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat currentOffsetX = scrollView.contentOffset.x;
    CGFloat scrollViewW = scrollView.frame.size.width;
    CGFloat targetIndex= currentOffsetX/scrollViewW; //当前选择
    if (_delegate && [_delegate respondsToSelector:@selector(pageConetentView:targetIndex:)]) {
        [_delegate pageConetentView:self targetIndex:targetIndex];
    }
}



@end
