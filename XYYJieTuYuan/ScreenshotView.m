//
//  ScreenshotView.m
//  XYYJieTuYuan
//
//  Created by 摇果 on 2017/9/1.
//  Copyright © 2017年 摇果. All rights reserved.
//

#import "ScreenshotView.h"

#define Radius 120.0
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
@interface ScreenshotView ()<UIScrollViewDelegate>
{

    CGPoint _setOff;
    CGFloat _contentW;
    CGFloat _contentH;
}
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ScreenshotView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubviews];
        [self drawRect:frame];
    }
    return self;
}

- (void)createSubviews {
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _scrollView.backgroundColor = [UIColor blackColor];
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _imageView.userInteractionEnabled = YES;
    [_scrollView addSubview:_imageView];
}
#pragma mark - 获取图片
- (void)loadImage:(UIImage *)image {
    
    _imageView.image = [self fixOrientation:image];
    [self finishChooseImage:image];
}
#pragma mark - 截取图片
- (UIImage *)screenShot {
    
    UIImage *image = _imageView.image;
    CGPoint point = _scrollView.contentOffset;
    CGFloat x = point.x-_setOff.x;
    CGFloat y = point.y-_setOff.y;
    CGFloat bili = image.size.width/_imageView.frame.size.width;
    CGFloat cX = image.size.width/2.0;
    CGFloat cY = image.size.height/2.0;
    CGFloat oX = cX-Radius*bili+x*bili;
    CGFloat oY = cY-Radius*bili+y*bili;
    CGRect rect = CGRectMake(oX, oY, 2*Radius*bili, 2*Radius*bili);

    UIImage *newImage = [self clipWithImageRect:rect clipImage:image];
    return newImage;
}

#pragma mark - 截图绘制
- (UIImage *)clipWithImageRect:(CGRect)clipRect clipImage:(UIImage *)clipImage {
    
    CGRect cropFrame = clipRect;
    CGImageRef imgRef = CGImageCreateWithImageInRect(clipImage.CGImage, cropFrame);
    CGFloat deviceScale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(cropFrame.size, 0, deviceScale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, cropFrame.size.height);
    CGContextScaleCTM(context, 1, -1);
    CGContextDrawImage(context, CGRectMake(0, 0, cropFrame.size.width, cropFrame.size.height), imgRef);
    UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
    CGImageRelease(imgRef);
    UIGraphicsEndImageContext();
    return newImg;
}

#pragma mark - 计算图片展示时的尺寸
- (void)finishChooseImage:(UIImage *)image {
    
    CGFloat bili = ScreenWidth/image.size.width;
    CGFloat height =  image.size.height*bili;
    if (height > 2*Radius) {
        CGRect rect = _imageView.frame;
        rect.size = CGSizeMake(ScreenWidth, height);
        _imageView.frame = rect;
        _contentW = _imageView.frame.size.width+(ScreenWidth-2*Radius);
        _contentH = _imageView.frame.size.height+(ScreenHeight-2*Radius);
        _scrollView.contentSize = CGSizeMake(_contentW, _contentH);
        _imageView.center = CGPointMake(_contentW/2.0, _contentH/2.0);
        _scrollView.contentOffset = CGPointMake((_contentW-ScreenWidth)/2.0, (_contentH-ScreenHeight)/2.0);
        _setOff = _scrollView.contentOffset;
        CGFloat min;
        if (image.size.width > image.size.height) {
            min = height;
        }else{
            min = ScreenWidth;
        }
        CGFloat scaleMin = 240/min;
        _scrollView.maximumZoomScale = 1.5;
        _scrollView.minimumZoomScale = scaleMin;
    }else{
        CGFloat b = 2*Radius/image.size.height;
        CGFloat w = image.size.width*b;
        CGRect rect = _imageView.frame;
        rect.size = CGSizeMake(w, 2*Radius);
        _imageView.frame = rect;
        _contentW = w+(ScreenWidth-2*Radius);
        _contentH = ScreenHeight;
        _scrollView.contentSize = CGSizeMake(_contentW, _contentH);
        _imageView.center = CGPointMake(_contentW/2.0, _contentH/2.0);
        _scrollView.contentOffset = CGPointMake((_contentW-ScreenWidth)/2.0, (_contentH-ScreenHeight)/2.0);
        _setOff = _scrollView.contentOffset;
        _scrollView.maximumZoomScale = 1.5;
        _scrollView.minimumZoomScale = 1.0;
    }
}

#pragma mark - UIScrollViewDelegate(缩放)
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return _imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    UIImage *image = _imageView.image;
    CGFloat w = _imageView.frame.size.width;
    CGFloat b = w/image.size.width;
    CGFloat h = image.size.height*b;
    _contentW = w+(ScreenWidth-2*Radius);
    _contentH = h+(ScreenHeight-2*Radius);
    _scrollView.contentSize = CGSizeMake(_contentW, _contentH);
    _imageView.center = CGPointMake(_contentW/2.0, _contentH/2.0);
    
    _setOff = CGPointMake((_contentW-ScreenWidth)/2.0, (_contentH-ScreenHeight)/2.0);
}

#pragma mark - 绘制Layer层
- (void)drawRect:(CGRect)rect {
    CGFloat x = rect.size.width/2.0;
    CGFloat y = rect.size.height/2.0;
    //背景
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:0];
    //画圆
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(x, y) radius:Radius startAngle:0 endAngle:M_PI*2 clockwise:YES];
    [path appendPath:bezierPath];
    [path setUsesEvenOddFillRule:YES];
    //填充背景
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.path = path.CGPath;
    fillLayer.fillRule = kCAFillRuleEvenOdd;//中间镂空的关键点 填充规则
    fillLayer.fillColor = [UIColor blackColor].CGColor;
    fillLayer.opacity = 0.3;
    [self.layer addSublayer:fillLayer];
    //添加边框及中间镂空
    CAShapeLayer *solidLine =  [CAShapeLayer layer];
    CGMutablePathRef solidPath =  CGPathCreateMutable();
    solidLine.lineWidth = 2.0f ;
    solidLine.strokeColor = [UIColor whiteColor].CGColor;
    solidLine.fillColor = [UIColor clearColor].CGColor;
    CGPathAddEllipseInRect(solidPath, nil, CGRectMake(x-Radius-1,  y-Radius-1, 2*(Radius+1), 2*(Radius+1)));
    solidLine.path = solidPath;
    CGPathRelease(solidPath);
    [self.layer addSublayer:solidLine];
}

#pragma mark - 图片坐标系转换（相机图片坐标）
- (UIImage *)fixOrientation:(UIImage *)aImage {
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
