//
//  LMCustomRouletteView.m
//  LMVoiceRoom
//
//  Created by deng on 2022/7/28.
//

#import "LMCustomRouletteView.h"
#import <YYKit/YYKit.h>
@interface LMCustomRouletteView ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *userView;
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) NSMutableArray *degreesList;

@end

@implementation LMCustomRouletteView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.degreesList = [[NSMutableArray alloc] init];
        
    }
    return self;
}


- (void)reloadData {
    
  
    NSInteger count = [self.delegate itemCount];
    if(count == 0) {
        return;
    }
    [self.degreesList removeAllObjects];
    
    if(_bgView){
        [_bgView removeFromSuperview];
        _bgView = nil;
    }
    
    if(_userView){
        [_userView removeFromSuperview];
        _userView = nil;
    }
    
    CGFloat offsetDegrees = -90+self.offsetDegrees;
    //扇形开始点在90度，减90未了从0开始
    CGFloat startDegrees = offsetDegrees;

    for (int i = 0; i<count; i++) {
        //startDegrees=[self degreesToRadian:v_degrees*i+self.offsetDegrees];
        CGFloat addDegrees = [self.delegate itemSectorDegrees:i];
        CGFloat endDegrees = startDegrees + addDegrees;
                
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bgView.width/2, self.bgView.height/2) radius:self.bgView.width / 2 startAngle:[self degreesToRadian:startDegrees] endAngle:[self degreesToRadian:endDegrees] clockwise:YES];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.path = path.CGPath;
        maskLayer.fillColor = [UIColor clearColor].CGColor;
        maskLayer.lineWidth = self.bgView.width;
        
        [self.bgView.layer addSublayer:maskLayer];
        maskLayer.strokeColor = [self.delegate itemSectorBackgroundForIndex:i].CGColor;
        
        /// 善行中心角度
        [self.degreesList addObject:@([self degreesToRadian:startDegrees+addDegrees/2-offsetDegrees+self.offsetDegrees])];
        
        CGSize viewSize = CGSizeZero;
        if([self.delegate respondsToSelector:@selector(itemViewSizeForIndex:)]) {
            viewSize = [self.delegate itemViewSizeForIndex:i];
        }
        
        if(CGSizeEqualToSize(viewSize, CGSizeZero)) {
            startDegrees = endDegrees;
            continue;
        }

        UIView *itemView = nil;
        if([self.delegate respondsToSelector:@selector(itemViewForIndex:)]) {
            itemView = [self.delegate itemViewForIndex:i];
        }
        if(!itemView) {
            startDegrees = endDegrees;
            continue;
        }
        
        [self.userView addSubview:itemView];
        itemView.frame = CGRectMake((CGRectGetWidth(self.userView.frame)-viewSize.width)/2, (CGRectGetHeight(self.userView.frame)-viewSize.height)/2, viewSize.width, viewSize.height);
        itemView.layer.anchorPoint = CGPointMake(0.5, 1);

        //view中心跟扇形开始差90度
        CGFloat viewDegree = [self degreesToRadian:(startDegrees + addDegrees/2 + 90)];
        
        itemView.transform = CGAffineTransformMakeRotation(viewDegree);
                
        startDegrees = endDegrees;

    }
    
    UIView *red =[[UIView alloc] init];
    [self addSubview:red];
    red.backgroundColor = [UIColor blackColor];
    red.frame = CGRectMake(self.width/2 -5, 0, 10, 30);
}

- (void)startAnimation:(NSInteger)endIndex{
    if(endIndex >= self.degreesList.count) {
        NSAssert(NO, @"endIndex error");
        return;
    }
    
    NSNumber *value = [self.degreesList objectAtIndex:endIndex];


    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];

    NSNumber *toValue = @([self degreesToRadian:360*5]- value.floatValue);

    animation.fromValue = @([self degreesToRadian:0]);
    animation.toValue = toValue;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];

    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = 1;
    group.fillMode = kCAFillModeForwards;
    group.repeatCount = 1;
    group.removedOnCompletion = NO;
    group.animations = @[animation];
    
    [self.contentView.layer addAnimation:group forKey:@"singleTurnAnimation"];
   
}

/// 角度转弧度
- (CGFloat)degreesToRadian:(CGFloat)degrees {
    return degrees * M_PI / 180;
}

#pragma mark - lazy load

- (UIView *)userView {
    if(!_userView) {
        UIView *userView = [[UIView alloc] init];
        [self.contentView addSubview:userView];
        userView.frame = self.contentView.bounds;
        _userView = userView;

    }
    return _userView;
}

- (UIView *)bgView {
    if(!_bgView) {
        UIView *bgView = [[UIView alloc] init];
        [self.contentView insertSubview:bgView atIndex:0];
        bgView.frame = self.contentView.bounds;
        _bgView = bgView;

    }
    return _bgView;
}

- (UIView *)contentView {
    if(!_contentView) {
        UIView *contentView = [[UIView alloc] init];
        [self addSubview:contentView];
        contentView.frame = self.bounds;
        contentView.layer.cornerRadius = self.width/2;
        contentView.clipsToBounds = YES;
        _contentView = contentView;

    }
    return _contentView;
}

@end
