//
//  GYPhotoModel.h
//  GYPhotoBrowser
//
//  Created by 高言 on 16/3/21.
//  Copyright © 2016年 高言. All rights reserved.
//

#import <UIKit/UIKit.h>

#define GYPhotoBrowserViewScreenW [UIScreen mainScreen].bounds.size.width
#define GYPhotoBrowserViewScreenH [UIScreen mainScreen].bounds.size.height

@interface GYPhotoModel : NSObject

/** 图片 */
@property (nonatomic , strong) NSString *imageName;
/** 原始frame */
@property (nonatomic , assign) CGRect fromRect;
/** 显示frame */
@property (nonatomic , assign , readonly) CGRect toRect;

//原始图片宽高
@property (nonatomic , assign) CGFloat originalW;
@property (nonatomic , assign) CGFloat originalH;

+ (instancetype)photoModelWithImageName:(NSString *)imageName fromRect:(CGRect)fromRect originalW:(CGFloat)originalW originalH:(CGFloat)originalH;

+ (instancetype)photoModelWithImageName:(NSString *)imageName fromView:(UIView *)fromRect originalW:(CGFloat)originalW originalH:(CGFloat)originalH;

@end
