//
//  GYPhotoBrowserView.m
//  GYPhotoBrowser
//
//  Created by 高言 on 16/3/21.
//  Copyright © 2016年 高言. All rights reserved.
//

#import "GYPhotoBrowserView.h"
#import "UIImageView+WebCache.h"

@interface GYPhotoBrowserView() <UICollectionViewDataSource,UICollectionViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic , weak) UICollectionView *collectionView;
@property (nonatomic , weak) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic , weak) UILabel *indexLabel;
@property (nonatomic , assign) NSInteger currentIndex;
@property (nonatomic , strong) NSIndexPath *indexPath;
@end

@implementation GYPhotoBrowserView

static NSString * const cellId = @"photoCell";

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
        
    }
    return self;
}
- (void)setupViews
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(GYPhotoBrowserViewScreenW, GYPhotoBrowserViewScreenH);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 0;
    self.flowLayout = flowLayout;
    
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0,GYPhotoBrowserViewScreenW, GYPhotoBrowserViewScreenH) collectionViewLayout:flowLayout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.pagingEnabled = YES;
    collectionView.minimumZoomScale = 1.0;
    collectionView.maximumZoomScale = 1.5;
    [collectionView registerClass:[GYPhotoCell class] forCellWithReuseIdentifier:cellId];
    [self addSubview:collectionView];
    self.collectionView = collectionView;
    
    
    UILabel *indexLabel = [[UILabel alloc] initWithFrame:CGRectMake((GYPhotoBrowserViewScreenW - 200) * 0.5,
                                                                    35,
                                                                    180, 60)];
    indexLabel.font = [UIFont boldSystemFontOfSize:20];
    indexLabel.textColor = [UIColor whiteColor];
    indexLabel.textAlignment = NSTextAlignmentCenter;
    indexLabel.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.3];
    indexLabel.layer.cornerRadius = 30;
    indexLabel.layer.masksToBounds = YES;
    [self addSubview:indexLabel];
    self.indexLabel = indexLabel;
}


- (void)setPhotos:(NSMutableArray *)photos
{
    _photos = photos;
    self.indexLabel.text = [NSString stringWithFormat:@"%d     /     %ld",0,photos.count];
}

- (void)setStartIndex:(NSInteger)startIndex
{
    _startIndex = startIndex;
    
    self.indexLabel.text = [NSString stringWithFormat:@"%ld     /     %ld",startIndex,self.photos.count];
    NSInteger targetIndex = (startIndex - 1) < 0 ? 0 : (startIndex - 1);
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:targetIndex inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GYPhotoCell *photoCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    photoCell.photoModel = self.photos[indexPath.row];
    __weak typeof(self) weakSelf = self;
    photoCell.ClickBlock = ^{
        [weakSelf dismissWith:indexPath.row];
    };
    return photoCell;
}

- (void)show
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    keyWindow.userInteractionEnabled = NO;
    
    GYPhotoModel *model = self.photos[(self.startIndex - 1) < 0 ? 0 : (self.startIndex - 1)];
    UIImageView *tempPhoto = [[UIImageView alloc] init];
    [tempPhoto sd_setImageWithURL:[NSURL URLWithString:model.imageName] placeholderImage:[UIImage imageNamed:model.imageName]];
    tempPhoto.frame = model.fromRect;
    [keyWindow addSubview:tempPhoto];
    [UIView animateWithDuration:GYAnimDuration animations:^{
        tempPhoto.frame = model.toRect;
    } completion:^(BOOL finished) {
        [tempPhoto removeFromSuperview];
        keyWindow.userInteractionEnabled = YES;
        [keyWindow addSubview:self];
    }];
    
    CATransition *anim = [CATransition animation];
    anim.type = @"fade";
    anim.duration = GYAnimDuration;
    [keyWindow.layer addAnimation:anim forKey:nil];
    
}

- (void)dismissWith:(NSInteger)index
{
    GYPhotoModel *model = self.photos[index];
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    keyWindow.userInteractionEnabled = NO;
    UIImageView *tempImageView = [[UIImageView alloc] init];
    [tempImageView sd_setImageWithURL:[NSURL URLWithString:model.imageName] placeholderImage:[UIImage imageNamed:model.imageName]];
    tempImageView.frame = model.toRect;
    [keyWindow addSubview:tempImageView];
    
    [UIView animateWithDuration:GYAnimDuration animations:^{
        tempImageView.frame = model.fromRect;
    } completion:^(BOOL finished) {
        [tempImageView removeFromSuperview];
        keyWindow.userInteractionEnabled = YES;
    }];
    
    [self removeFromSuperview];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger currentIndex = scrollView.contentOffset.x / GYPhotoBrowserViewScreenW + 0.5;
    self.indexLabel.text = [NSString stringWithFormat:@"%ld     /     %ld",currentIndex + 1,self.photos.count];
    self.currentIndex = currentIndex;
    self.indexPath = [NSIndexPath indexPathForItem:self.currentIndex inSection:0];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.flowLayout.itemSize = CGSizeMake(GYPhotoBrowserViewScreenW, GYPhotoBrowserViewScreenH);
    self.frame = CGRectMake(0, 0, GYPhotoBrowserViewScreenW, GYPhotoBrowserViewScreenH);
    self.collectionView.frame = self.frame;
    self.indexLabel.frame = CGRectMake((GYPhotoBrowserViewScreenW - 200) * 0.5,
                                       35,
                                       180, 60);
    [self.collectionView reloadData];
    [self.collectionView scrollToItemAtIndexPath:self.indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
}

@end
