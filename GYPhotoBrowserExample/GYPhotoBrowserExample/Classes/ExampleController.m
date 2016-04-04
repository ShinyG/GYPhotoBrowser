//
//  ExampleController.m
//  GYPhotoBrowserExample
//
//  Created by 高言 on 16/3/30.
//  Copyright © 2016年 高言. All rights reserved.
//

#import "ExampleController.h"
#import "GYPhotoBrowserView.h"

@interface ExampleController ()
@property (nonatomic , strong) NSMutableArray *photos;

@end

@implementation ExampleController

- (NSMutableArray *)photos {
    if (!_photos) {
        _photos = @[@"pic0",@"pic1",@"pic2",
                    @"pic3",@"pic4",@"pic5",
                    @"pic6",@"pic7",@"pic8"].mutableCopy;
        
    }
    
    return _photos;
}

- (IBAction)clickBtn:(UIButton *)sender {
    NSMutableArray *photoModels = @[].mutableCopy;
    int tag = 1;
    for (NSString *imageName in self.photos) {
        GYPhotoModel *model = [GYPhotoModel photoModelWithImageName:imageName fromView:[self.view viewWithTag:tag++] originalW:GYPhotoBrowserViewScreenW originalH:480 + arc4random_uniform(300)];
        [photoModels addObject:model];
    }
    
    GYPhotoBrowserView *photoBrowser = [[GYPhotoBrowserView alloc] init];
    photoBrowser.photos = photoModels.copy;
    photoBrowser.startIndex = sender.tag;
    [photoBrowser show];
}

@end
