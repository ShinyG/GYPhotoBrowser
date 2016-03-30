//
//  GYPhotoCell.m
//  GYPhotoBrowser
//
//  Created by 高言 on 16/3/21.
//  Copyright © 2016年 高言. All rights reserved.
//

#import "GYPhotoCell.h"
#import "UIImageView+WebCache.h"
#import "GYPhotoProgressView.h"

@interface GYPhotoCell() <UIScrollViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic , strong) UIScrollView *scrollView;
@property (nonatomic , strong) UIImageView *photo;
@property (nonatomic , strong) GYPhotoProgressView *progressView;
@end

@implementation GYPhotoCell

- (GYPhotoProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[GYPhotoProgressView alloc] init];
    }
    
    return _progressView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(GYPhotoBrowserViewScreenW, GYPhotoBrowserViewScreenH);
        _scrollView.frame = CGRectMake(0, 0, GYPhotoBrowserViewScreenW, GYPhotoBrowserViewScreenH);
        _scrollView.maximumZoomScale = 2.0;
        _scrollView.minimumZoomScale = 0.8;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [_scrollView addGestureRecognizer:tap];
    }
    
    return _scrollView;
}

- (UIImageView *)photo {
    if (!_photo) {
        _photo = [[UIImageView alloc] init];
    }
    
    return _photo;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setPhotoModel:(GYPhotoModel *)photoModel
{
    _photoModel = photoModel;
    
    self.scrollView.zoomScale = 1.0;
    
    [self.photo sd_setImageWithURL:[NSURL URLWithString:photoModel.imageName]placeholderImage:[UIImage imageNamed:photoModel.imageName] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    self.progressView.frame = CGRectMake(0, 0, 100, 100);
    self.progressView.center = self.contentView.center;
    
    self.progressView.hidden = NO;
    [self.photo sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:photoModel.imageName] placeholderImage:[UIImage imageNamed:photoModel.imageName] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        if (expectedSize != 0) {
            self.progressView.progress = receivedSize * 1.0 / expectedSize;
        }
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.progressView.hidden = YES;
    }];
    
    self.photo.frame = photoModel.toRect;
    self.photo.center = self.contentView.center;
    self.scrollView.contentSize = photoModel.toRect.size;
}

- (void)setupViews
{
    [self.contentView addSubview:self.scrollView];
    [self.scrollView addSubview:self.photo];
    [self.contentView addSubview:self.progressView];
}

- (void)tap:(UITapGestureRecognizer *)tap
{
    if (self.ClickBlock) {
        self.ClickBlock();
    }
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
//    if (scrollView.contentSize.width > GYPhotoBrowserViewScreenW && scrollView.contentSize.height > GYPhotoBrowserViewScreenH) {
//        self.photo.center = CGPointMake(scrollView.contentSize.width*0.5, scrollView.contentSize.height*0.5);
//    } else {
//        self.photo.center = CGPointMake(GYPhotoBrowserViewScreenW*0.5, GYPhotoBrowserViewScreenH*0.5);
//    }
    
    
    if (scrollView.contentSize.width > GYPhotoBrowserViewScreenW && scrollView.contentSize.height > GYPhotoBrowserViewScreenH) {
        self.photo.center = CGPointMake(scrollView.contentSize.width*0.5,  scrollView.contentSize.height*0.5);
    } else if (scrollView.contentSize.width > GYPhotoBrowserViewScreenW && scrollView.contentSize.height < GYPhotoBrowserViewScreenH) {
        self.photo.center = CGPointMake(scrollView.contentSize.width*0.5,  scrollView.bounds.size.height*0.5);
    } else if (scrollView.contentSize.width < GYPhotoBrowserViewScreenW && scrollView.contentSize.height > GYPhotoBrowserViewScreenH) {
        self.photo.center = CGPointMake(scrollView.bounds.size.width*0.5,  scrollView.contentSize.height*0.5);
    } else {
        self.photo.center = scrollView.center;
    }
    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.photo;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.scrollView.frame = CGRectMake(0, 0, GYPhotoBrowserViewScreenW, GYPhotoBrowserViewScreenH);
    self.scrollView.contentSize = CGSizeMake(GYPhotoBrowserViewScreenW, GYPhotoBrowserViewScreenH);
    self.photo.frame = self.photoModel.toRect;
    self.photo.center = self.contentView.center;
}

@end
