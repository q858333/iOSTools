//
//  ViewController.m
//  ThreeDTest
//
//  Created by db on 2026/10/29.
//

#import "DBThreeDVC.h"
#import "RealityKitViewController.h"
#import "SceneKitViewController.h"

@implementation DBThreeDVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"3D 模型演示";
    self.view.backgroundColor = UIColor.systemBackgroundColor;

    UILabel *description = [[UILabel alloc] init];
    description.text = @"选择渲染方案\n同一个 Duck.glb · 200 × 200 模型视图";
    description.font = [UIFont systemFontOfSize:17];
    description.textColor = UIColor.secondaryLabelColor;
    description.numberOfLines = 0;
    description.textAlignment = NSTextAlignmentCenter;

    UIButton *realityButton = [UIButton buttonWithType:UIButtonTypeSystem];
    UIButtonConfiguration *realityConfiguration = [UIButtonConfiguration filledButtonConfiguration];
    realityConfiguration.title = @"RealityKit 演示";
    realityButton.configuration = realityConfiguration;
    [realityButton addTarget:self action:@selector(openRealityKit) forControlEvents:UIControlEventTouchUpInside];

    UIButton *sceneButton = [UIButton buttonWithType:UIButtonTypeSystem];
    UIButtonConfiguration *sceneConfiguration = [UIButtonConfiguration tintedButtonConfiguration];
    sceneConfiguration.title = @"SceneKit 演示";
    sceneButton.configuration = sceneConfiguration;
    [sceneButton addTarget:self action:@selector(openSceneKit) forControlEvents:UIControlEventTouchUpInside];

    UIStackView *entries = [[UIStackView alloc] initWithArrangedSubviews:@[description, realityButton, sceneButton]];
    entries.axis = UILayoutConstraintAxisVertical;
    entries.spacing = 20;
    entries.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:entries];

    UILayoutGuide *safe = self.view.safeAreaLayoutGuide;
    [NSLayoutConstraint activateConstraints:@[
        [entries.topAnchor constraintEqualToAnchor:safe.topAnchor constant:40],
        [entries.leadingAnchor constraintEqualToAnchor:safe.leadingAnchor constant:24],
        [entries.trailingAnchor constraintEqualToAnchor:safe.trailingAnchor constant:-24],
        [realityButton.heightAnchor constraintEqualToConstant:56],
        [sceneButton.heightAnchor constraintEqualToConstant:56]
    ]];
}

- (void)openRealityKit {
    [self.navigationController pushViewController:[[RealityKitViewController alloc] init] animated:YES];
}

- (void)openSceneKit {
    [self.navigationController pushViewController:[[SceneKitViewController alloc] init] animated:YES];
}

@end
