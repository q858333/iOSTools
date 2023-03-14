//
//  DBTextView.h
//  Tools
//
//  Created by dengbinOld on 2023/3/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/**
 * @brief 对有长度限制的字符串截断方式
 */
typedef NS_ENUM(NSUInteger, LMTextLimitTruncMode) {
    kLMTextLimitTruncModeByComposedCharacterSequences,  //按照组合字符序列截断，默认使用这种方式截断字符
    kLMTextLimitTruncModeByLessCharacter,               //按照最少字符截断，对于emoji字符，不会产品乱码，但有可能不足字符限制长度
    kLMTextLimitTruncModeByCharacter,                   //按照字符截断，对于emoji字符，可能会产生乱码
};

@interface DBTextView : UITextView
/// 超出长度限制的文本截断方式
@property (nonatomic, assign) LMTextLimitTruncMode textTruncMode;
/// 最大限制输入文本长度值，默认为0，不限制
@property (nonatomic, assign) NSInteger maxLimitTextLength;
/// 占位文案
@property (nonatomic, copy) NSString * placeholderText;
/// 占位文案颜色
@property (nonatomic, strong) UIColor * placeholderTextColor;
/// 达到最大文本长度限制回调
@property (nonatomic, copy) void(^onReachedLimitBlock)(void);
/// 文案改变回调
@property (nonatomic, copy) void(^onTextDidChangedBlock)(void);
/// 换行按钮点击
@property (nonatomic, copy) void (^onEnterClickBlk)();


@end

NS_ASSUME_NONNULL_END
