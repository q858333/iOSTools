//
//  PlayerView.h
//  Tools
//
//  Created by deng on 2022/3/28.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PlayerView : UIControl
@property (nonatomic,strong)AVPlayer *player;//播放器对象
@property (nonatomic,strong)AVPlayerLayer *avLayer;

- (void)start;

@end

NS_ASSUME_NONNULL_END
