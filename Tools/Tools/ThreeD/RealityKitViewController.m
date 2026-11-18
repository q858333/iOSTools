//
//  RealityKitViewController.m
//  ThreeDTest
//
//  Created by db on 2026/10/29.
//

#import "RealityKitViewController.h"
#import "Tools-Swift.h"

@interface RealityKitViewController ()
@property (nonatomic, strong) RealityModelView *modelView;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) CAGradientLayer *backgroundLayer;
@end

@implementation RealityKitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"RealityKit";
    self.view.backgroundColor = [UIColor redColor];

//    self.backgroundLayer = [CAGradientLayer layer];
//    self.backgroundLayer.colors = @[
//        (id)[UIColor colorWithRed:0.89 green:0.96 blue:1 alpha:1].CGColor,
//        (id)[UIColor colorWithRed:0.96 green:0.92 blue:0.84 alpha:1].CGColor
//    ];
//    [self.view.layer insertSublayer:self.backgroundLayer atIndex:0];

    UILabel *title = [[UILabel alloc] init];
    title.text = @"小鸭 · 3D 模型";
    title.font = [UIFont boldSystemFontOfSize:28];
    title.textColor = [UIColor colorWithWhite:0.12 alpha:1];
    title.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:title];

    self.statusLabel = [[UILabel alloc] init];
    self.statusLabel.text = @"正在加载 Duck.glb…";
    self.statusLabel.font = [UIFont systemFontOfSize:14];
    self.statusLabel.textColor = [UIColor colorWithWhite:0.35 alpha:1];
    self.statusLabel.numberOfLines = 0;
    self.statusLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.statusLabel];

    self.modelView = [[RealityModelView alloc] initWithFrame:CGRectZero];
    self.modelView.translatesAutoresizingMaskIntoConstraints = NO;
    self.modelView.backgroundColor = UIColor.clearColor;
    self.modelView.opaque = NO;
    self.modelView.clipsToBounds = YES;
    self.modelView.accessibilityLabel = @"小鸭三维模型，可拖动旋转和双指缩放";
    [self.view addSubview:self.modelView];

    UILabel *hint = [[UILabel alloc] init];
    hint.text = @"拖动旋转 · 双指缩放\n透明背景，可叠加到直播画面";
    hint.font = [UIFont systemFontOfSize:15];
    hint.textColor = [UIColor colorWithWhite:0.35 alpha:1];
    hint.numberOfLines = 0;
    hint.textAlignment = NSTextAlignmentCenter;
    hint.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:hint];

    UIButton *reset = [UIButton buttonWithType:UIButtonTypeSystem];
    [reset setTitle:@"重置视角" forState:UIControlStateNormal];
    reset.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    reset.backgroundColor = [UIColor colorWithWhite:1 alpha:0.75];
    reset.layer.cornerRadius = 22;
    reset.translatesAutoresizingMaskIntoConstraints = NO;
    [reset addTarget:self action:@selector(resetCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reset];

    UILayoutGuide *safe = self.view.safeAreaLayoutGuide;
    [NSLayoutConstraint activateConstraints:@[
        [title.topAnchor constraintEqualToAnchor:safe.topAnchor constant:20],
        [title.leadingAnchor constraintEqualToAnchor:safe.leadingAnchor constant:24],
        [title.trailingAnchor constraintLessThanOrEqualToAnchor:safe.trailingAnchor constant:-24],
        [self.statusLabel.topAnchor constraintEqualToAnchor:title.bottomAnchor constant:8],
        [self.statusLabel.leadingAnchor constraintEqualToAnchor:title.leadingAnchor],
        [self.statusLabel.trailingAnchor constraintEqualToAnchor:safe.trailingAnchor constant:-24],
        [self.modelView.topAnchor constraintEqualToAnchor:self.statusLabel.bottomAnchor constant:8],
        [self.modelView.centerXAnchor constraintEqualToAnchor:safe.centerXAnchor],
        [self.modelView.widthAnchor constraintEqualToConstant:200],
        [self.modelView.heightAnchor constraintEqualToConstant:200],
        [hint.leadingAnchor constraintEqualToAnchor:safe.leadingAnchor constant:16],
        [hint.trailingAnchor constraintEqualToAnchor:safe.trailingAnchor constant:-16],
        [hint.bottomAnchor constraintEqualToAnchor:reset.topAnchor constant:-16],
        [reset.centerXAnchor constraintEqualToAnchor:safe.centerXAnchor],
        [reset.widthAnchor constraintEqualToConstant:150],
        [reset.heightAnchor constraintEqualToConstant:44],
        [reset.bottomAnchor constraintEqualToAnchor:safe.bottomAnchor constant:-20]
    ]];
    [self loadModel];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.backgroundLayer.frame = self.view.bounds;
}

- (void)loadModel {
    NSURL *url = [NSBundle.mainBundle URLForResource:@"Duck" withExtension:@"glb"];
    if (!url) {
        self.statusLabel.text = @"找不到 Duck.glb，请检查模型资源是否加入 Target。";
        return;
    }
    __weak typeof(self) weakSelf = self;
    [self.modelView loadModelWithURL:url completion:^(NSError *error) {
        typeof(self) self = weakSelf;
        if (!self) { return; }
        if (error) {
            self.statusLabel.text = [NSString stringWithFormat:@"加载失败：%@", error.localizedDescription];
        } else {
            self.statusLabel.text = @"Duck.glb · RealityKit · Khronos 示例模型";
        }
    }];
}

- (void)resetCamera {
    [self.modelView resetCamera];
}

@end
