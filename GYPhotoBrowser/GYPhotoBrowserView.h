//
//  GYPhotoBrowserView.h
//  GYPhotoBrowser
//
//  Created by 高言 on 16/3/21.
//  Copyright © 2016年 高言. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYPhotoCell.h"

@interface GYPhotoBrowserView : UIView

// 所有图片的模型 @[GYPhotoModel,...]
@property (nonatomic , strong) NSMutableArray *photos;

/** 从哪张图片开始 */
@property (nonatomic,assign) NSInteger startIndex;

/** 显示图片浏览器 */
- (void)show;

@end
