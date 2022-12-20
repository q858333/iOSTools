//
//  LMCustomRouletteView.h
//  LMVoiceRoom
//
//  Created by deng on 2022/7/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DBTurnTableViewDelegate <NSObject>

@required
/// 扇形个数
- (NSInteger)itemCount;
/// 扇形角度
- (NSInteger)itemSectorDegrees:(NSInteger)index;
/// 扇形背景
- (UIColor *)itemSectorBackgroundForIndex:(NSInteger)index;
@optional

/// 扇形内view
- (UIView *)itemViewForIndex:(NSInteger)index;
/// 扇形内view大小
- (CGSize)itemViewSizeForIndex:(NSInteger)index;

@end

@interface LMCustomRouletteView : UIView
/// 扇形开始偏移角度（默认从0度开始）
@property (nonatomic, assign) CGFloat offsetDegrees;
@property (nonatomic, weak)id delegate;

/// 重载数据
- (void)reloadData;

/// 开始旋转
/// @param endIndex 结束的位置
- (void)startAnimation:(NSInteger)endIndex;
@end

NS_ASSUME_NONNULL_END
