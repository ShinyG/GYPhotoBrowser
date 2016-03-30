//
//  GYPhotoProgressView.h
//  GYPhotoBrowser
//
//  Created by 高言 on 16/3/22.
//  Copyright © 2016年 高言. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GYPhotoProgressView;

typedef void(^FinishedBlock)(GYPhotoProgressView *progressView);

@interface GYPhotoProgressView : UIView

/** 设置进度 */
@property (nonatomic,assign) CGFloat progress;
/** label字体大小 */
@property (nonatomic,assign) CGFloat textFontSize;
/** label字体颜色 */
@property (nonatomic,strong) UIColor *textColor;
/** 圈圈宽度 */
@property (nonatomic,assign) CGFloat lineWidth;
/** 圈圈颜色 */
@property (nonatomic,strong) UIColor *circleColor;
/** 禁止下载完毕动画 */
@property (nonatomic,assign) BOOL doAnim;

/** progress满时回调 */
- (void)setFinishedBlock:(FinishedBlock)finishedBlock;

@end
