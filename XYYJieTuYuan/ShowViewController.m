//
//  ShowViewController.m
//  XYYJieTuYuan
//
//  Created by 摇果 on 2017/9/1.
//  Copyright © 2017年 摇果. All rights reserved.
//

#import "ShowViewController.h"
#import "ViewController.h"

#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
@interface ShowViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"头像";
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, 240, 240)];
    _imageView.center = CGPointMake(ScreenWidth/2.0, ScreenHeight/2.0);
    _imageView.layer.masksToBounds = YES;
    _imageView.layer.cornerRadius = 120.0;
    _imageView.layer.borderWidth = 5.0;
    _imageView.layer.borderColor = [UIColor yellowColor].CGColor;
    _imageView.userInteractionEnabled = YES;
    _imageView.image = [UIImage imageNamed:@"WechatIMG1.png"];
    [self.view addSubview:_imageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openImageViewController)];
    [_imageView addGestureRecognizer:tap];
    
}

#pragma mark - 打开相册
- (void)openImageViewController {
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    [imagePickerController.navigationBar setTintColor:[UIColor blackColor]];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerController animated:YES completion:^{
        
    }];
}
#pragma mark - 相册、相机回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    ViewController *vc = [[ViewController alloc] init];
    vc.image = image;
    vc.returnImage = ^(UIImage *image) {
        _imageView.image = image;
    };
    [self.navigationController pushViewController:vc animated:YES];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
