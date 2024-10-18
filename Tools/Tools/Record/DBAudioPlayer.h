//
//  DBAudioPlayer.h
//  Tools
//
//  Created by DDDD on 2024/9/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBAudioPlayer : NSObject
- (void)playAudioWithUrl:(NSURL *)url;
- (void)stopPlayAudio;

@end

NS_ASSUME_NONNULL_END
