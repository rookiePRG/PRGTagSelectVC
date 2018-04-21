//
//  PageContentView.h
//  多标签视图选择器
//
//  Created by change_pan on 2018/4/20.
//  Copyright © 2018年 kocla. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PageContentView;

@protocol PageContentViewDelegate <NSObject>

//滑块偏移
-(void)pageConetentView:(PageContentView *)contentView progress:(CGFloat)progress currentIndex:(NSInteger)currentIndenx targetIndex:(NSInteger)targetIndex;

//按钮偏移
-(void)pageConetentView:(PageContentView *)contentView targetIndex:(NSInteger)targetIndex;

@end

@interface PageContentView : UIView

-(instancetype)initWithFrame:(CGRect)frame childVCs:(NSArray *)childVCs parentVC:(UIViewController *)parentVC;

-(void)setCurrentIndex:(NSInteger)currentIndex;

@property (nonatomic, weak) id <PageContentViewDelegate> delegate;

@end
