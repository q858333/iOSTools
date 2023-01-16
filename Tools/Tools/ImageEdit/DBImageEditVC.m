//
//  DBImageEditVC.m
//  Tools
//
//  Created by dengbinOld on 2023/1/16.
//

#import "DBImageEditVC.h"
#import <YYKit/YYKit.h>
#import "Masonry.h"

#define kCoverScale 1
@interface DBImageEditVC ()
@property (nonatomic, assign) CGSize coverSize;//裁切的大小
@property (nonatomic, assign) CGRect coverRect;//裁切的位置

@property (nonatomic, strong) UIScrollView *scrollView;//


@property (nonatomic, strong) UIImageView *originImgView;//原始图片

@property (nonatomic, strong) UIView *maskView;
@end

@implementation DBImageEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"EditVC --- %@--%@",NSStringFromCGSize(self.originImg.size),self.navigationController.viewControllers);
    self.originImg = [UIImage imageNamed:@"beam_topview_exchange_index"];
    
    self.view.backgroundColor = [UIColor blackColor];
    [self configView];
}

- (void)configView{
    
    if(!self.originImg){
//        [LiveMeCommon showToast:LM_LANG_STRING_GET(@"liveroom_report_upload_fail")];
        return;
    }
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    CGFloat coverWH = kScreenWidth - 120; // 白色剪切框的宽高
       
    self.coverSize = CGSizeMake(coverWH, coverWH*kCoverScale);
       
    CGFloat imageHeght = self.coverSize.height;

     
    CGFloat imageWidth = imageHeght * self.originImg.size.width/self.originImg.size.height;

       //如果图片宽大于裁切区域需要滑动
       CGFloat space = 0;
       if(imageWidth > self.coverSize.width){
           space = imageWidth - self.coverSize.width;
       }
       

    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.minimumZoomScale = 1.0;
    self.scrollView.maximumZoomScale = 10.0;
    self.scrollView.delegate = self;
    // 大背景滑动视图, 承载图片
    self.scrollView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [self.view addSubview:self.scrollView];
    
    if (@available(iOS 11.0,*)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
      }
    
        
    self.scrollView.contentSize = CGSizeMake(kScreenWidth + space, kScreenHeight);
    self.scrollView.contentOffset = CGPointMake((self.scrollView.contentSize.width-self.scrollView.width)/2, 0);

    // 等待裁切的图片
    self.originImgView = [[UIImageView alloc] init];
    self.originImgView.contentMode = UIViewContentModeScaleAspectFill;
    self.originImgView.image = self.originImg;
    self.originImgView.frame = CGRectMake(0, 0, imageWidth,imageHeght);
    self.originImgView.center = CGPointMake(self.scrollView.contentSize.width/2, self.scrollView.contentSize.height/2);
    [self.scrollView addSubview:self.originImgView];
       

    //创建一个View
    UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.width , self.scrollView.height)];
    maskView.userInteractionEnabled = NO;
    maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    [self.view addSubview:maskView];
    self.maskView = maskView;
    
 
    UIBezierPath *bpath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.scrollView.width, self.scrollView.height) cornerRadius:0];
  
    self.coverRect = CGRectMake(self.scrollView.centerX-self.coverSize.width/2.0, self.scrollView.centerY-self.coverSize.height/2.0, self.coverSize.width, self.coverSize.height);
    
    UIView *lineView = [[UIView alloc] initWithFrame:self.coverRect];
    lineView.layer.borderColor = [UIColor whiteColor].CGColor;
    lineView.userInteractionEnabled = NO;
    lineView.layer.borderWidth = 1;
    [self.view addSubview:lineView];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.coverRect];
    [bpath appendPath:[path bezierPathByReversingPath]];
    
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
     shapeLayer.path = bpath.CGPath;


     //添加图层蒙板
     maskView.layer.mask = shapeLayer;
//    [maskView.layer addSublayer:shapeLayer];

    
    // 底部视图
    CGFloat bottomHeight = 60; //+ [LiveMeCommon tabbarBottomOffset];
    UIView *bottomView = [self bulidBottomViewWithFrame:CGRectMake(0, kScreenHeight - bottomHeight, kScreenWidth, bottomHeight)];
    bottomView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    [self.view addSubview:bottomView];

}



/// 底部视图
- (UIView *)bulidBottomViewWithFrame:(CGRect)frame{
    
    UIView *bgView = [[UIView alloc] initWithFrame:frame];

    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancleButton addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:cancleButton];
    [cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bgView.mas_top);
        make.height.mas_equalTo(60);
        make.left.mas_equalTo(15);
        
    }];
    
    
    
    UIButton *finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    finishButton.backgroundColor = [UIColor clearColor];
    [finishButton setTitle:@"确定" forState:UIControlStateNormal];
    [finishButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [finishButton addTarget:self action:@selector(finishAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:finishButton];
    [finishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bgView.mas_top);
        make.height.mas_equalTo(60);
        make.right.mas_equalTo(-15);
    }];
    
    return bgView;
}
/// 完成事件
- (void)finishAction{
    CGRect rect = [self.maskView convertRect:self.coverRect toView:self.originImgView];
    UIImage *image = [self makeImageWithView:self.originImgView coverRect:rect];
    if (self.editFinashBlk) {
        self.editFinashBlk(image);
    } else {
        self.originImgView.image = image;

    }
    
}


- (void)cancleAction{
    if(self.cancelEditBlk){
        self.cancelEditBlk();
    }
    
}
#pragma mark - 方法
- (UIImage *)makeImageWithView:(UIView *)view coverRect:(CGRect)coverRect{
    
    /*
     下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。
     第三个参数就是屏幕密度了，关键就是第三个参数 [UIScreen mainScreen].scale。
     */
    CGFloat scale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // 按比例扩大剪切区域
    CGRect tempRect = CGRectMake(CGRectGetMinX(coverRect) * scale, CGRectGetMinY(coverRect) * scale, CGRectGetWidth(coverRect) * scale, CGRectGetHeight(coverRect) * scale );
    //将UIImage转换成CGImageRef
    CGImageRef sourceImageRef = [image CGImage];
    //按照给定的矩形区域进行剪裁
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, tempRect);
    //将CGImageRef转换成UIImage
    image = [UIImage imageWithCGImage:newImageRef];

    return image;
}
- (BOOL)shouldAutorotate {
    
    return YES;
}
    
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return  UIInterfaceOrientationMaskPortrait;
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    return self.originImgView;
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
        
    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width+120, self.scrollView.contentSize.height+(kScreenHeight-self.coverSize.height));
    
}


@end
