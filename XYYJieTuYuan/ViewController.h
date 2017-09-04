//
//  ViewController.h
//  XYYJieTuYuan
//
//  Created by 摇果 on 2017/9/1.
//  Copyright © 2017年 摇果. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ReturnImage)(UIImage *image);
@interface ViewController : UIViewController

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, copy) ReturnImage returnImage;

@end

