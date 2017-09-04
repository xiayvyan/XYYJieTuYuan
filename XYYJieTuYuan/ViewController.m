//
//  ViewController.m
//  XYYJieTuYuan
//
//  Created by 摇果 on 2017/9/1.
//  Copyright © 2017年 摇果. All rights reserved.
//

#import "ViewController.h"
#import "ScreenshotView.h"

@interface ViewController ()
{
    BOOL _isHidden;
}
@property (nonatomic, strong) ScreenshotView *shotView;

@end

@implementation ViewController
#pragma mark - 导航栏的显隐
- (void)isHidden {
    _isHidden = !_isHidden;
    [self.navigationController setNavigationBarHidden:_isHidden animated:YES];
}

- (void)jiequ {
    UIImage *image = [_shotView screenShot];
    if (self.returnImage && image) {
        self.returnImage(image);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"截图";
    UIBarButtonItem *itme1 = [[UIBarButtonItem alloc] initWithTitle:@"截取" style:UIBarButtonItemStyleDone target:self action:@selector(jiequ)];
    self.navigationItem.rightBarButtonItem = itme1;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _shotView = [[ScreenshotView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_shotView];
    [_shotView loadImage:self.image];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(isHidden)];
    [self.view addGestureRecognizer:tap];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
