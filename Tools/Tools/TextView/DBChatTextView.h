//
//  DBChatTextView.h
//  Tools
//
//  Created by dengbinOld on 2023/3/14.
//

#import <UIKit/UIKit.h>
#import "DBTextView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DBChatTextView : UIView
@property (nonatomic, assign) UIEdgeInsets insets;
@property (nonatomic, assign) NSInteger defaultHeight;
@property (nonatomic, strong) DBTextView *textView;
/// 最大行数（默认4）
@property (nonatomic, assign) NSInteger maxLine;

@property (nonatomic, copy) NSString *placeHolder;

/// 高度变化 onTextDidChangedBlock
@property (nonatomic, copy) void (^onTextDidChangedBlock)(CGFloat height);
/// 换行按钮点击
@property (nonatomic, copy) void (^onEnterClickBlk)();

- (void)clearText;
@end

NS_ASSUME_NONNULL_END
