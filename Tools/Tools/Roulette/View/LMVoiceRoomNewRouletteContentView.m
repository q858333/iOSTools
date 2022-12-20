//
//  LMVoiceRoomNewRouletteContentView.m
//  LMVoiceRoom
//
//  Created by deng on 2022/7/28.
//

#import "LMVoiceRoomNewRouletteContentView.h"
#import "LMCustomRouletteView.h"
#import <Masonry/Masonry.h>
#import <YYKit/YYKit.h>

#define LM_HEX_COLOR_ALPHA(hex, a) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 \
                       green:((float)((hex & 0xFF00) >> 8)) / 255.0 \
                        blue:((float)(hex & 0xFF)) / 255.0 alpha:a] \

#define LM_HEX_COLOR(hex) LM_HEX_COLOR_ALPHA(hex, 1.0)
@interface LMVoiceRoomNewRouletteContentView ()
@property (nonatomic, strong) LMCustomRouletteView *rouletteView;
@property (nonatomic, strong) NSArray *colorList;

@end
@implementation LMVoiceRoomNewRouletteContentView
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.colorList = @[LM_HEX_COLOR(0x8D64FF),
                           LM_HEX_COLOR(0x449FFF),
                           LM_HEX_COLOR(0x2DC8FA),
                           LM_HEX_COLOR(0x0DC8A7),
                           LM_HEX_COLOR(0x98D038),
                           LM_HEX_COLOR(0xFFBB40),
                           LM_HEX_COLOR(0xFF8647),
                           LM_HEX_COLOR(0xFC5C5E),
                           LM_HEX_COLOR(0xFD6BB9)];
        [self configView];
    }
    return self;
}

- (void)configView {
    LMCustomRouletteView *view = [[LMCustomRouletteView alloc] init];
    view.delegate = self;
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
    self.rouletteView = view;
}

- (void)reloadData {
    [self layoutIfNeeded];
    [self.rouletteView reloadData];
}
- (void)startAnimation {
    NSInteger index = random()%self.colorList.count;
    [self.rouletteView startAnimation:index];

}


#pragma mark - LMCustomRouletteViewDelegate
- (NSInteger)itemSectorDegrees:(NSInteger)index {

    return 360.0/self.colorList.count;

}
- (NSInteger)itemCount {
    return self.colorList.count;
}
- (CGSize)itemViewSizeForIndex:(NSInteger)index {
    return CGSizeMake(50, self.rouletteView.height/2);
}

- (UIView *)itemViewForIndex:(NSInteger)index {
    UIView *view = [[UIView alloc] init];
    UILabel *title = [[UILabel alloc] init];
    title.text = [NSString stringWithFormat:@"%zd",index];
    [view addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(@0);
    }];

    return view;
}

- (UIColor *)itemSectorBackgroundForIndex:(NSInteger)index {
    
    UIColor *color = [self.colorList objectAtIndex:index];
    
    return color;
}
@end
