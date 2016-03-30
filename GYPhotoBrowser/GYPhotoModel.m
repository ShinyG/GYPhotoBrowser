//
//  GYPhotoModel.m
//  GYPhotoBrowser
//
//  Created by 高言 on 16/3/21.
//  Copyright © 2016年 高言. All rights reserved.
//

#import "GYPhotoModel.h"

@interface GYPhotoModel()

@property (nonatomic , strong) UIView *fromView;

@end


@implementation GYPhotoModel

- (instancetype)initWithImageName:(NSString *)imageName fromRect:(CGRect)fromRect originalW:(CGFloat)originalW originalH:(CGFloat)originalH
{
    if (self = [super init]) {
        self.imageName = imageName;
        self.fromRect = fromRect;
        self.originalW = originalW;
        self.originalH = originalH;
    }
    
    return self;
}

+ (instancetype)photoModelWithImageName:(NSString *)imageName fromRect:(CGRect)fromRect originalW:(CGFloat)originalW originalH:(CGFloat)originalH
{
    GYPhotoModel *photoModel = [[self alloc] initWithImageName:imageName fromRect:fromRect originalW:originalW originalH:originalH];
    // 如果原图的宽度小于屏幕宽度，则显示原宽度，否则缩小至屏幕宽度
    CGFloat willShowW = originalW < GYPhotoBrowserViewScreenW ? originalW : GYPhotoBrowserViewScreenW;
    // 按原图的宽高比缩放，得到将要展示的高度
    CGFloat willShowH = willShowW * originalH / originalW;
    CGRect toRect = CGRectMake(0,(willShowH < GYPhotoBrowserViewScreenH ? (GYPhotoBrowserViewScreenH - willShowH) * 0.5 : 0),
                               willShowW, willShowH);
    photoModel->_toRect = toRect;
    return photoModel;
}

+ (instancetype)photoModelWithImageName:(NSString *)imageName fromView:(UIView *)fromView originalW:(CGFloat)originalW originalH:(CGFloat)originalH
{
    GYPhotoModel *photoModel = [[self alloc] initWithImageName:imageName fromRect:fromView.frame originalW:originalW originalH:originalH];
    // 如果原图的宽度小于屏幕宽度，则显示原宽度，否则缩小至屏幕宽度
    CGFloat willShowW = originalW < GYPhotoBrowserViewScreenW ? originalW : GYPhotoBrowserViewScreenW;
    // 按原图的宽高比缩放，得到将要展示的高度
    CGFloat willShowH = willShowW * originalH / originalW;
    CGRect toRect = CGRectMake((GYPhotoBrowserViewScreenW - willShowW) * 0.5,(willShowH < GYPhotoBrowserViewScreenH ? (GYPhotoBrowserViewScreenH - willShowH) * 0.5 : 0),
                               willShowW, willShowH);
    photoModel->_toRect = toRect;
    
    
    photoModel.fromView = fromView;
    [[NSNotificationCenter defaultCenter] addObserver:photoModel selector:@selector(orientChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    return photoModel;
}

- (void)orientChange:(NSNotification *)noti
{
    self.fromRect = self.fromView.frame;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
