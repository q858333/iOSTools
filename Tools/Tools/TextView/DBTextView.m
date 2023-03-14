//
//  DBTextView.m
//  Tools
//
//  Created by dengbinOld on 2023/3/14.
//

#import "DBTextView.h"
#import <YYKit/YYKit.h>
@interface DBTextViewFilter : NSObject <UITextViewDelegate>
@property (nonatomic, weak) id owner;
@end

@implementation DBTextViewFilter
- (instancetype)initWithOwner:(id)owner
{
    self = [super init];
    if (self) {
        _owner = owner;
    }
    return self;
}

#pragma mark UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (_owner && [_owner respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]) {
        return [_owner textView:textView shouldChangeTextInRange:range replacementText:text];
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (_owner && [_owner respondsToSelector:@selector(textViewDidChange:)]) {
        return [_owner textViewDidChange:textView];
    }
}
@end

@interface DBTextView () <UITextViewDelegate>
@property (nonatomic, strong) DBTextViewFilter * textViewFilter;
@property(nullable, nonatomic, strong) YYWeakProxy * textInputProxy;
@property (nonatomic, assign) UIEdgeInsets placeHolderInsets;       //占位文案内容显示边框
@end

@implementation DBTextView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //设置默认字体
        self.font = [UIFont systemFontOfSize:15];
        //设置默认字体颜色
        self.placeholderTextColor = [UIColor grayColor];
        self.placeHolderInsets = UIEdgeInsetsMake(8, 6, 8, 6);
        
        if (@available(iOS 16.0, *)) {
            self.autocorrectionType = UITextAutocorrectionTypeNo;
            self.spellCheckingType = UITextSpellCheckingTypeNo;
        }
    }
    return self;
}

#pragma mark - Process PlaceHolder
- (void)setPlaceholderText:(NSString *)placeHolder {
    _placeholderText = [placeHolder copy];
    
    if (!_textInputProxy) {
        [super setDelegate:self.textViewFilter];
    }
    
    [self setNeedsDisplay];
}

- (void)setPlaceholderTextColor:(UIColor *)placeHolderColor {
    _placeholderTextColor = placeHolderColor;
    [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self setNeedsDisplay];
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    //如果有输入文本，不需要显示占位文案，直接返回
    if (self.text.length > 0) {
        return;
    }
    
    //设置占位文案字体和字体颜色
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = self.font;
    attrs[NSForegroundColorAttributeName] = self.placeholderTextColor;
    
    //计算相应的边框，画出，用于放置文字
    rect.origin.x = self.placeHolderInsets.left;
    rect.origin.y = self.placeHolderInsets.top;
    rect.size.width -= (self.placeHolderInsets.left + self.placeHolderInsets.right);
    [self.placeholderText drawInRect:rect withAttributes:attrs];
}

#pragma mark - Process Max Limit Text
- (void)setMaxLimitTextLength:(NSInteger)maxLimitTextLength
{
    _maxLimitTextLength = maxLimitTextLength;
    
    if (!_textInputProxy) {
        [super setDelegate:self.textViewFilter];
    }
}

- (DBTextViewFilter *)textViewFilter
{
    if (!_textViewFilter) {
        _textViewFilter = [[DBTextViewFilter alloc] initWithOwner:self];
    }
    return _textViewFilter;
}
#pragma mark UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView.text.length < range.location + range.length) {
        return NO;
    }
    if([text isEqualToString:@"\n"] && self.onEnterClickBlk) {
        self.onEnterClickBlk();
        return NO;
    }
    
    if (![self isInputTextHighlight] && self.maxLimitTextLength > 0) {
        if (text.length == 0) {       //达到最大字数限制,也必须允许可以删除字符串
            return YES;
        }
        
        if (textView.text.length >= self.maxLimitTextLength) {  //达到最大字数限制，不允许继续输入
            [self onTextDidChanged];
            [self onReachedLimit];
            return NO;
        }

        //变更后的文本
        NSString * toBeString = [textView.text stringByReplacingCharactersInRange:range withString:text];
        if (toBeString.length > self.maxLimitTextLength) { //超过达到最大字数限制，不允许继续输入
            textView.text = [self limitTruncatedText:toBeString];
            
            //Changed
            [self onTextDidChanged];
            [self onReachedLimit];
        }
    }
    
    if (_textInputProxy.target && [_textInputProxy.target respondsToSelector:@selector(textView: shouldChangeTextInRange:replacementText:)]) {
        return [_textInputProxy.target textView:textView shouldChangeTextInRange:range replacementText:text];
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self setNeedsDisplay];
    
    if (![self isInputTextHighlight] && self.maxLimitTextLength > 0) {
        if (textView.text.length > self.maxLimitTextLength) { //超过达到最大字数限制，不允许继续输入
            NSString * toBeString = textView.text;     //变更后的文本
            textView.text = [self limitTruncatedText:toBeString];
            [self onReachedLimit];
        }
        
        //Changed
        [self onTextDidChanged];
    }
    
    if (_textInputProxy.target && [_textInputProxy.target respondsToSelector:@selector(textViewDidChange:)]) {
        return [_textInputProxy.target textViewDidChange:textView];
    }
}

//判断输入文本是否高亮，处理字符限制时，中文拼音字符串和中文字符数不一定相等，例如如拼音'zhongwen'对应字符'中文'
//高亮的时候，最终输入的文本还没确定下来，所以不做字符限制处理
- (BOOL)isInputTextHighlight
{
    NSString *lang = self.textInputMode.primaryLanguage; // 键盘输入模式
    
    if (![lang isEqualToString:@"en-US"]) {     //简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [self markedTextRange];
        UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];   //获取高亮部分
        
        if (!position) {    //没有高亮选择的字，则对已输入的文字进行字数统计和限制
            return NO;
        } else {    //有高亮选择的字符串，则暂不对文字进行统计和限制
            return YES;
        }
    }
    return NO;
}

/**
 * @brief 若超过长度限制时，返回截断后的字符串
 */
- (NSString *)limitTruncatedText:(NSString *)toBeString
{
    NSString * rtv = toBeString;
    
    if (toBeString.length > self.maxLimitTextLength) {  //超过字符长度限制，截断字符串
        if (self.textTruncMode == kLMTextLimitTruncModeByCharacter) {
            rtv = [toBeString substringToIndex:self.maxLimitTextLength];
        } else if (self.textTruncMode == kLMTextLimitTruncModeByLessCharacter){
            NSRange range = [toBeString rangeOfComposedCharacterSequenceAtIndex:self.maxLimitTextLength];
            NSRange toBeRange = NSMakeRange(0, range.location);
            rtv = [toBeString substringWithRange:toBeRange];
        } else {
            NSRange toBeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, self.maxLimitTextLength)];
            rtv = [toBeString substringWithRange:toBeRange];
        }
    }
    
    return rtv;
}

- (void)onTextDidChanged
{
    if (self.onTextDidChangedBlock) {
        self.onTextDidChangedBlock();
    }
}

- (void)onReachedLimit {
    if (self.onReachedLimitBlock) {
        self.onReachedLimitBlock();
    }
}

#pragma mark Override Super Method
- (void)setDelegate:(id<UITextViewDelegate>)delegate
{
    if (!delegate) {
        [super setDelegate:nil];
    } else {
        _textInputProxy = [[YYWeakProxy alloc] initWithTarget:delegate];
        [super setDelegate:(id<UITextViewDelegate>)_textInputProxy];
    }
}

/// 禁用三手指手势undo
- (UIEditingInteractionConfiguration)editingInteractionConfiguration {
    return UIEditingInteractionConfigurationNone;
}
@end
