//
//  PageTitleView.h
//  多标签视图选择器
//
//  Created by change_pan on 2018/4/20.
//  Copyright © 2018年 kocla. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PageTitleView;

@protocol PageTitleViewDelegate <NSObject>

@optional
-(void)pageTitleView:(PageTitleView *)view selectIndex:(NSInteger)selectIndex;

@end

@interface PageTitleView : UIView
-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray* )titles;
-(void)setScrollLineWithProgress:(CGFloat)progress currentIndex:(NSInteger)currentIndenx targetIndex:(NSInteger)targetIndex;
-(void)setBtnSelectIndex:(NSInteger)selectIndex;
@property (nonatomic, weak) id <PageTitleViewDelegate> delegate;

@end
