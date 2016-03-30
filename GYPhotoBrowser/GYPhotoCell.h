//
//  GYPhotoCell.h
//  GYPhotoBrowser
//
//  Created by 高言 on 16/3/21.
//  Copyright © 2016年 高言. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYPhotoModel.h"

#define GYAnimDuration 0.5

@interface GYPhotoCell : UICollectionViewCell

@property (nonatomic , strong) GYPhotoModel *photoModel;
@property (nonatomic , copy) void(^ClickBlock)();

@end
