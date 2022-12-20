//
//  DBRouletteVC.m
//  Tools
//
//  Created by deng on 2022/12/20.
//

#import "DBRouletteVC.h"
#import "LMVoiceRoomNewRouletteContentView.h"
#import <Masonry/Masonry.h>

@interface DBRouletteVC ()
@property (nonatomic, strong) LMVoiceRoomNewRouletteContentView *roulrtteView;
@end

@implementation DBRouletteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    LMVoiceRoomNewRouletteContentView *view = [[LMVoiceRoomNewRouletteContentView alloc] init];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(@0);
        make.width.height.equalTo(@(CGRectGetWidth(self.view.bounds)));
    }];
    [view reloadData];
    self.roulrtteView = view;
    
    UIButton *startBtn = [[UIButton alloc] init];
    [startBtn setTitle:@"开始" forState:UIControlStateNormal];
    [startBtn addTarget:self action:@selector(startBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startBtn];
    [startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(view.mas_top);
        make.centerX.equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    // Do any additional setup after loading the view.
}
- (void)startBtnClick {
    [self.roulrtteView startAnimation];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
