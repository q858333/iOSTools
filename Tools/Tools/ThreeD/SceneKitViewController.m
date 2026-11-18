//
//  SceneKitViewController.m
//  ThreeDTest
//
//  Created by db on 2026/10/29.
//

#import "SceneKitViewController.h"
#import <SceneKit/SceneKit.h>
#import <GLTFKit2/GLTFKit2.h>
#import <math.h>

@interface SceneKitViewController ()
@property (nonatomic, strong) SCNView *modelView;
@property (nonatomic, strong) SCNNode *cameraNode;
@property (nonatomic, strong) UILabel *statusLabel;
@end

@implementation SceneKitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"SceneKit";
    self.view.backgroundColor = [UIColor redColor];


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

    self.modelView = [[SCNView alloc] initWithFrame:CGRectZero];
    self.modelView.translatesAutoresizingMaskIntoConstraints = NO;
    self.modelView.backgroundColor = UIColor.clearColor;
    self.modelView.opaque = NO;
    self.modelView.clipsToBounds = YES;
    self.modelView.allowsCameraControl = YES;
    self.modelView.defaultCameraController.inertiaEnabled = YES;
    self.modelView.antialiasingMode = SCNAntialiasingModeMultisampling4X;
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

- (void)loadModel {
    NSURL *url = [NSBundle.mainBundle URLForResource:@"Duck" withExtension:@"glb"];
    if (!url) {
        self.statusLabel.text = @"找不到 Duck.glb，请检查模型资源是否加入 Target。";
        return;
    }
    __weak typeof(self) weakSelf = self;
    [GLTFAsset loadAssetWithURL:url options:@{} handler:^(float progress, GLTFAssetStatus status,
                                                         GLTFAsset *asset, NSError *error, BOOL *stop) {
        if (status != GLTFAssetStatusComplete && status != GLTFAssetStatusError) { return; }
        dispatch_async(dispatch_get_main_queue(), ^{
            typeof(self) self = weakSelf;
            if (!self) { return; }
            if (error || !asset) {
                self.statusLabel.text = [NSString stringWithFormat:@"加载失败：%@", error.localizedDescription ?: @"模型无效"];
                return;
            }
            [self displayAsset:asset];
        });
    }];
}

- (void)displayAsset:(GLTFAsset *)asset {
    SCNScene *scene = [SCNScene sceneWithGLTFAsset:asset];
    scene.background.contents = UIColor.clearColor;
    SCNNode *model = [SCNNode node];
    for (SCNNode *node in [scene.rootNode.childNodes copy]) {
        [model addChildNode:node];
    }
    [scene.rootNode addChildNode:model];
    // 使用页面固定相机，避免导入的相机影响模型展示。
    [model enumerateChildNodesUsingBlock:^(SCNNode *node, BOOL *stop) {
        node.camera = nil;
    }];

    SCNVector3 minimum, maximum;
    if ([model getBoundingBoxMin:&minimum max:&maximum]) {
        float extent = fmaxf(maximum.x - minimum.x, fmaxf(maximum.y - minimum.y, maximum.z - minimum.z));
        if (extent > 0) {
            float scale = 2.0f / extent;
            model.scale = SCNVector3Make(scale, scale, scale);
            model.position = SCNVector3Make(-(minimum.x + maximum.x) * 0.5f * scale,
                                           -(minimum.y + maximum.y) * 0.5f * scale,
                                           -(minimum.z + maximum.z) * 0.5f * scale);
        }
    }

    self.cameraNode = [SCNNode node];
    self.cameraNode.camera = [SCNCamera camera];
    self.cameraNode.camera.zNear = 0.01;
    self.cameraNode.camera.zFar = 100;
    self.cameraNode.camera.fieldOfView = 45;
    [scene.rootNode addChildNode:self.cameraNode];

    SCNNode *keyLight = [SCNNode node];
    keyLight.light = [SCNLight light];
    keyLight.light.type = SCNLightTypeOmni;
    keyLight.light.intensity = 1100;
    keyLight.position = SCNVector3Make(3, 4, 5);
    [scene.rootNode addChildNode:keyLight];

    SCNNode *ambient = [SCNNode node];
    ambient.light = [SCNLight light];
    ambient.light.type = SCNLightTypeAmbient;
    ambient.light.intensity = 450;
    [scene.rootNode addChildNode:ambient];

    self.modelView.scene = scene;
    [self resetCamera];
    self.statusLabel.text = @"Duck.glb · SceneKit · Khronos 示例模型";
}

- (void)resetCamera {
    if (!self.cameraNode) { return; }
    [self.modelView.defaultCameraController stopInertia];
    self.cameraNode.position = SCNVector3Make(0, 0.4, 4.2);
    [self.cameraNode lookAt:SCNVector3Make(0, 0, 0)];
    self.modelView.pointOfView = self.cameraNode;
    self.modelView.defaultCameraController.pointOfView = self.cameraNode;
    self.modelView.defaultCameraController.target = SCNVector3Make(0, 0, 0);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.modelView.defaultCameraController stopInertia];
}

@end
