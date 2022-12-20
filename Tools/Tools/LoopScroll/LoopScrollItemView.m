//
//  LoopScrollItemView.m
//  Tools
//
//  Created by deng on 2022/3/28.
//

#import "LoopScrollItemView.h"

@interface LoopScrollItemView ()

@end

@implementation LoopScrollItemView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        UILabel *l = [[UILabel alloc] init];
        [self addSubview:l];
        l.frame = CGRectMake(0, 0, 200, 100);
        label = l;
    }
    return self;
}

- (void)updateUIWithText:(NSString *)text {
    label.text = text;
  
}
@end
