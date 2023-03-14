//
//  DBChatTextView.m
//  Tools
//
//  Created by dengbinOld on 2023/3/14.
//

#import "DBChatTextView.h"
#import <YYKit/YYKit.h>

@implementation DBChatTextView
- (instancetype)init {
    self = [super init];
    if (self) {
//        if(1) {
//            self.insets = UIEdgeInsetsMake(5, 0, 0, 5);
//        } else {
            self.insets = UIEdgeInsetsMake(5, 5, 0, 0);
//        }
        self.maxLine = 4;
        self.defaultHeight = 48;
        [self configView];
    }
    return self;
}

- (void)configView {
    DBTextView *textView = [[DBTextView alloc] init];
    textView.font = [UIFont systemFontOfSize:16];
    textView.textColor = [UIColor blackColor];
    @weakify(self);
    textView.onTextDidChangedBlock = ^{
        @strongify(self);
        [self changeTextViewHeightIfNeed];
    };
    textView.onEnterClickBlk = ^ {
        @strongify(self);
        if(self.onEnterClickBlk) {
            self.onEnterClickBlk();
        }
        
    };

    textView.placeholderTextColor = [UIColor blackColor];
//    textView.backgroundColor = [ColorUtils colorFrom:@"FAFAFA"];
    textView.returnKeyType = UIReturnKeySend;
    [self addSubview:textView];
    textView.delegate = self;

   
    self.textView = textView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textView.frame = CGRectMake(self.insets.left, self.insets.top, self.width-self.insets.left-self.insets.right, self.height-self.insets.bottom-self.insets.top);
}


- (void)changeTextViewHeightIfNeed {
    

    CGSize size = [self.textView sizeThatFits:CGSizeMake(self.textView.width, MAXFLOAT)];
    size.height = MAX(size.height+self.insets.top+self.insets.bottom,self.defaultHeight);
    
    UIEdgeInsets textInset = self.textView.textContainerInset;
    CGFloat  height = MIN(size.height, self.textView.font.lineHeight * self.maxLine + self.insets.top + self.insets.bottom + textInset.top + textInset.bottom -  self.textView.font.lineHeight );

    if(self.onTextDidChangedBlock) {
        self.onTextDidChangedBlock (height);
    }

}

- (void)setPlaceHolder:(NSString *)placeHolder {
    _placeHolder = placeHolder;
    self.textView.placeholderText = placeHolder;
}


- (void)clearText {
    self.textView.text =@"";
    self.textView.attributedText = nil;
    if(self.onTextDidChangedBlock) {
        self.onTextDidChangedBlock (self.defaultHeight);
    }
}

- (void)setInsets:(UIEdgeInsets)insets {
    _insets = insets;
    if(self.textView && self.superview) {
        [self.inputView setNeedsLayout];
    }
}


@end
