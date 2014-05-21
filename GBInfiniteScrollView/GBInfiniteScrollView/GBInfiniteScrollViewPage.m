//
//  GBInfiniteScrollViewPage.m
//  GBInfiniteScrollView
//
//  Created by Gerardo Blanco García on 02/12/13.
//  Copyright (c) 2013 Gerardo Blanco García. All rights reserved.
//

#import "GBInfiniteScrollViewPage.h"

CGFloat const GBInfiniteScrollViewPageMargin = 16.0f;

@interface GBInfiniteScrollViewPage ()

@property (nonatomic) GBInfiniteScrollViewPageStyle style;

@property (nonatomic, strong, readwrite) UIScrollView *contentView;

@property (nonatomic, strong, readwrite) UILabel *textLabel;

@property (nonatomic, strong, readwrite) UIImageView *imageView;

@end

@implementation GBInfiniteScrollViewPage

- (CGFloat)zoomScale
{
    return self.contentView.zoomScale;
}

- (void)setZoomScale:(CGFloat)zoomScale
{
    self.contentView.zoomScale = zoomScale;
}

#pragma mark - Setup

- (id)initWithStyle:(GBInfiniteScrollViewPageStyle)style
{
    self = [self initWithFrame:[UIScreen mainScreen].applicationFrame];
    
    if (self) {
        self.style = style;
        [self setup];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame style:(GBInfiniteScrollViewPageStyle)style
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.style = style;
        [self setup];
    }
    
    return self;
}

- (void)setCustomView:(UIView *)customView
{
    if (_customView) {
        [_customView removeFromSuperview];
    }
    
    _customView = customView;
    
    if (_customView && (self.style == GBInfiniteScrollViewPageStyleCustom)) {
        [self setupCustomView];
    }
}

#pragma mark - Layout
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize neededSize = self.superview.frame.size;
    
    [self setSize:neededSize ofViewFrame:self];
    [self setSize:neededSize ofViewFrame:self.contentView];
    
    for (UIView *subview in self.contentView.subviews)
        [self setSize:neededSize ofViewFrame:subview];
        
    self.contentView.contentSize = neededSize;
}

- (void)setSize:(CGSize)size ofViewFrame:(UIView *)view
{
    CGRect frame = view.frame;
    frame.size = size;
    frame.origin.y = 0;
    
    view.frame = frame;
}

#pragma mark - Setup

- (void)setup
{
    [self setupContentView];
    
    if (self.style == GBInfiniteScrollViewPageStyleText) {
        [self setupTextLabel];
    } else if (self.style == GBInfiniteScrollViewPageStyleImage) {
        [self setupImageView];
    }
}

- (void)setupContentView
{
    if (!_contentView) {
        _contentView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _contentView.backgroundColor = [UIColor clearColor];
        _contentView.clipsToBounds = YES;
        _contentView.userInteractionEnabled = YES;
        _contentView.exclusiveTouch = YES;
        _contentView.delegate = self;
        
        [self addSubview:_contentView];
    }
}

- (void)setupTextLabel
{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] initWithFrame:self.bounds];
        
        _textLabel.backgroundColor = [UIColor clearColor];
        
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
            _textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        }
        
        _textLabel.textAlignment = NSTextAlignmentCenter;
        
        [_contentView addSubview:_textLabel];
    }
}

- (void)setupImageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        
        [_contentView addSubview:_imageView];
    }
}

- (void)setupCustomView
{
    if (_customView) {
        [_contentView addSubview:_customView];
    }
}

- (void)setupDefaultZoomValues
{
    _contentView.minimumZoomScale = 1.0f;
    _contentView.maximumZoomScale = 2.0f;
}

#pragma mark - Zoom

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return [_contentView.subviews firstObject];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self setScrollEnabledParentScroll:NO];
    [self resetZoomIfNeeded];
}

- (void)resetZoomIfNeeded
{
    if (_contentView.zoomScale == 1.0f)
    {
        _contentView.contentSize = _contentView.frame.size;
        [self setScrollEnabledParentScroll:YES];
    }
}

- (void)setScrollEnabledParentScroll:(BOOL)scrollEnabled
{
    UIScrollView *parentScroll = (UIScrollView *)self.superview;
    parentScroll.scrollEnabled = scrollEnabled;
}

- (void)setZoomEnabled:(BOOL)zoomEnabled
{
    _zoomEnabled = zoomEnabled;
    
    if (zoomEnabled)
        [self setupDefaultZoomValues];
    else
    {
        _contentView.minimumZoomScale = 1.0f;
        _contentView.maximumZoomScale = 1.0f;
    }
}

- (void)setMinimumZoomScale:(CGFloat)minimumZoomScale andMaximumZoomScale:(CGFloat)maximumZoomScale
{
    if (maximumZoomScale < minimumZoomScale || minimumZoomScale < 1.0f)
    {
        self.zoomEnabled = NO;
        
        return;
    }
    
    _contentView.minimumZoomScale = minimumZoomScale;
    _contentView.maximumZoomScale = maximumZoomScale;
}

#pragma mark - Reuse

- (void)prepareForReuse
{
    self.contentView.zoomScale = 1.0f;
    [self resetZoomIfNeeded];
    
    for (UIView *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    self.textLabel = nil;
    self.imageView = nil;
    self.customView = nil;
    
    [self setup];
}

@end
