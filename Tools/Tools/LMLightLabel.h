//
//  LMLightLabel.h
//  LiveMeChatUI
//
//  Created by deng on 2021/6/21.
//  Copyright © 2021 handy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LMLightLabel : UILabel
@property (nonatomic, strong) CAGradientLayer *gradientLayer;

- (void)updateGradientLayerColor:(NSArray *)colors;
@end

NS_ASSUME_NONNULL_END
