//
//  LMLightLabel.m
//  LiveMeChatUI
//
//  Created by deng on 2021/6/21.
//  Copyright © 2021 handy. All rights reserved.
//

#import "LMLightLabel.h"

@interface LMLightLabel ()

@property (nonatomic, strong) UILabel *maskLabel;


@end

@implementation LMLightLabel
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        UILabel *maskLabel = [[UILabel alloc] init];
        [self insertSubview:maskLabel atIndex:0];
        maskLabel.textColor = [UIColor clearColor];
        self.maskLabel = maskLabel;
        self.textColor = [UIColor clearColor];
        
    }
    return self;
}
- (void)setFont:(UIFont *)font{
    [super setFont:font];
    self.maskLabel.font = [UIFont systemFontOfSize:22];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.gradientLayer.frame = CGRectMake(0, 0, ceilf(CGRectGetWidth(self.frame)), ceilf(CGRectGetHeight(self.frame)));
    self.maskLabel.frame = self.gradientLayer.frame;
}
    
    


- (void)updateGradientLayerColor:(NSArray *)colors{
    self.gradientLayer.colors = colors;
    self.maskLabel.textColor = [UIColor blackColor];

}

- (CAGradientLayer *)gradientLayer{
    if(!_gradientLayer){
        _gradientLayer = [CAGradientLayer layer];
        [self.layer addSublayer:_gradientLayer];
        _gradientLayer.startPoint = CGPointMake(0.5, 0);
        _gradientLayer.endPoint = CGPointMake(0.5, 1);;
        _gradientLayer.mask = self.maskLabel.layer;
    }
    
    return _gradientLayer;
}


- (void)setText:(NSString *)text{
    [super setText:text];
    self.maskLabel.text = text;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment{
    [super setTextAlignment:textAlignment];
    self.maskLabel.textAlignment = textAlignment;
}
@end
