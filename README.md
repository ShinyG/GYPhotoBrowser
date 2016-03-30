# GYPhotoBrowser
* 图片浏览器，适配横竖屏，集成简单

#GYPhotoBrowser的使用
* 由于用到第三方SDWebImage，使用时将SDWebImage的依赖改为自己项目中的，主头文件为:#import "GYPhotoBrowser.h"

![example](https://raw.githubusercontent.com/ShinyG/GYPhotoPicker/master/gif/GYPhotoBrowser.gif)

# Example
```objc    
    NSMutableArray *photoModels = @[].mutableCopy;
    int tag = 1;
    for (NSString *imageName in self.photos) {
        GYPhotoModel *model = [GYPhotoModel photoModelWithImageName:imageName fromView:[self.view viewWithTag:tag++] originalW:400 originalH:480 + arc4random_uniform(300)];
        [photoModels addObject:model];
    }
    GYPhotoBrowserView *photoBrowser = [[GYPhotoBrowserView alloc] init];
    photoBrowser.photos = photoModels.copy;
    photoBrowser.startIndex = sender.tag;
    [photoBrowser show];
```