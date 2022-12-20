//
//  PlayerView.m
//  Tools
//
//  Created by deng on 2022/3/28.
//

#import "PlayerView.h"
@interface PlayerView ()
@property (nonatomic, assign) BOOL isStart;
 @end

@implementation PlayerView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.player = [[AVPlayer alloc] init];

        AVPlayerLayer *avLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        avLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        avLayer.backgroundColor = [UIColor clearColor].CGColor;
        [self.layer addSublayer:avLayer];
        self.avLayer = avLayer;
        [self addTarget:self action:@selector(viewClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}
- (void)start {
    self.isStart = YES;
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:@"https://fmapp-1301933638.cos.ap-shanghai.myqcloud.com/video/video1648037285531.mp4"]];
    [self.player replaceCurrentItemWithPlayerItem:playerItem];
    [self.player play];
}


- (void)viewClick {
    if(self.isStart) {
        [self.player pause];
    }else {
        [self.player play];
    }
    self.isStart = !self.isStart;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.avLayer.bounds = self.bounds;
}
@end


