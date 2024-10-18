//
//  DBAudioPlayer.m
//  Tools
//
//  Created by DDDD on 2024/9/25.
//

#import "DBAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface DBAudioPlayer ()
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@end
@implementation DBAudioPlayer

- (void)playAudioWithUrl:(NSURL *)url{

    NSError *error = nil;
// file:///var/mobile/Containers/Data/Application/25EFD28D-2CD7-422C-BE76-7AB8E6F45EEF/Library/Caches//userCache/450b16bc4607f650270bfa59aa74a137/chat/audio/UYIKZOODVJ20240925112123.wav
    
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    NSLog(@"playAudioWithUrl %@,error:%@",url,error);
    self.audioPlayer.delegate = self;
    self.audioPlayer.volume = 1;
    
    [self.audioPlayer prepareToPlay];
    [self.audioPlayer play];
}


- (void)stopPlayAudio{
    if (self.audioPlayer && [self.audioPlayer isPlaying]) {
        [self.audioPlayer stop];
        self.audioPlayer = nil;
    }
}

- (BOOL)isPlaying{
    return self.audioPlayer.isPlaying;
}


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    NSLog(@"audioPlayerDidFinishPlaying %d",flag);
}
@end
