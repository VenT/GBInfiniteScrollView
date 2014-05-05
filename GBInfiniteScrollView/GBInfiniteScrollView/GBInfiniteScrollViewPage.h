//
//  GBInfiniteScrollViewPage.h
//  GBInfiniteScrollView
//
//  Created by Gerardo Blanco García on 02/12/13.
//  Copyright (c) 2013 Gerardo Blanco García. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GBInfiniteScrollViewPageStyle) {
    GBInfiniteScrollViewPageStyleCustom,
    GBInfiniteScrollViewPageStyleText,
    GBInfiniteScrollViewPageStyleImage
};

@interface GBInfiniteScrollViewPage : UIView <UIScrollViewDelegate>

- (id)initWithStyle:(GBInfiniteScrollViewPageStyle)style;

- (id)initWithFrame:(CGRect)frame style:(GBInfiniteScrollViewPageStyle)style;

@property (nonatomic, strong, readonly) UIScrollView *contentView;

@property (nonatomic, strong, readonly) UILabel *textLabel;

@property (nonatomic, strong, readonly) UIImageView *imageView;

@property (nonatomic, strong) UIView *customView;

@property (nonatomic) BOOL zoomEnabled;

- (void)prepareForReuse;

- (void)setMinimumZoomScale:(CGFloat)minimumZoomScale andMaximumZoomScale:(CGFloat)maximumZoomScale;

@end
