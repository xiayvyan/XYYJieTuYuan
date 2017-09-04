//
//  ScreenshotView.h
//  XYYJieTuYuan
//
//  Created by 摇果 on 2017/9/1.
//  Copyright © 2017年 摇果. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScreenshotView : UIView

// 获取图片
- (void)loadImage:(UIImage *)image;
//截取图片
- (UIImage *)screenShot;

@end
