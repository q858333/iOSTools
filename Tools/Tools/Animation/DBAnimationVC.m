//
//  DBAnimationVC.m
//  Tools
//
//  Created by dengbinOld on 2023/6/21.
//

#import "DBAnimationVC.h"
#import <YYKit/YYKit.h>
#import "YYAnimatedImageView.h"
#import "DBTextView.h"
#import "DBTableViewCell.h"
@interface DBAnimationVC ()
@property (nonatomic, strong) DBTextView *textView;

@end

@implementation DBAnimationVC
- (void)dealloc {
    NSLog(@"DBAnimationVC dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
        
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    
    [tableView registerClass:[DBTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:tableView];
    if (@available(iOS 11.0, *)){
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    
    UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [startBtn setTitle:@"开始" forState:UIControlStateNormal];
    startBtn.backgroundColor = [UIColor whiteColor];
    [startBtn addTarget:self action:@selector(startBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startBtn];
    startBtn.center = CGPointMake(50, kScreenHeight/2);
    startBtn.bounds = CGRectMake(0, 0, 100, 50);
    startBtn.tag = 100;
    @weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(self);
        NSLog(@"1111");
        [self makeparabolaAnimation];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"2222");
            [self makeparabolaAnimation];
        });
    });
    

}

- (void)startBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];

//    [self makeparabolaAnimation];
}

-(void)makeparabolaAnimation{
    UIImageView *babyView = [self.view viewWithTag:100];
    // 抛物线关键帧动画
//    CAKeyframeAnimation *keyframeAnimation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
//    CGMutablePathRef path = CGPathCreateMutable();
//    CGPathMoveToPoint(path, NULL, babyView.layer.position.x, babyView.layer.position.y);//移动到起始点
//
//    //(参数3,参数4)最高点;(参数5,参数6)掉落最低点
//    CGPathAddQuadCurveToPoint(path, NULL, babyView.right+200, babyView.top-400, babyView.right+200, babyView.top);
//    keyframeAnimation.path = path;
//    CGPathRelease(path);
//    keyframeAnimation.duration = 1.0f;
//    [babyView.layer addAnimation:keyframeAnimation forKey:@"KCKeyframeAnimation_Position"];
    
//     抛物线关键帧动画
//    CAKeyframeAnimation *keyframeAnimation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
//    CGMutablePathRef path = CGPathCreateMutable();
//    CGPathMoveToPoint(path, NULL, babyView.layer.position.x, babyView.layer.position.y);//移动到起始点
//    //(参数3,参数4)最高点;(参数5,参数6)掉落最低点
//    CGPathAddQuadCurveToPoint(path, NULL, babyView.right+200, babyView.top-400, babyView.right+200, babyView.top);
//    keyframeAnimation.path = path;
//    CGPathRelease(path);
//    keyframeAnimation.duration = 1.0f;
//    keyframeAnimation.delegate = self;
//    keyframeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
//    CABasicAnimation *animation = [CABasicAnimation animation];
//    animation.keyPath = @"transform";
//    animation.duration = 1.0;
//    animation.toValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI, 0, 0, 1)];
//    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
//    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
//    groupAnimation.animations = @[keyframeAnimation, animation];
//    groupAnimation.duration = 1.0;
////    groupAnimation.delegate = self;
//    groupAnimation.removedOnCompletion = NO;//动画结束不返回原位置
//    groupAnimation.fillMode = kCAFillModeForwards;
//    [babyView.layer addAnimation:groupAnimation forKey:nil];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    DBTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.inviteCallback = ^(NSString * _Nonnull uid) {
//        [self makeparabolaAnimation];
    };
    return cell;
}

@end
