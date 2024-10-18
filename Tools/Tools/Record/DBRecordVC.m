//
//  DBRecordVC.m
//  Tools
//
//  Created by DDDD on 2024/9/24.
//

#import "DBRecordVC.h"
#import "lame.h"
#import <AVFoundation/AVFoundation.h>
#import "DBAudioPlayer.h"
#import <AVKit/AVKit.h>

@interface DBRecordVC ()
@property(nonatomic, strong) AVAudioRecorder *recorder;
@property(nonatomic, strong) NSURL *recordFileURL;
@property(nonatomic, strong) DBAudioPlayer *audioPlayer;
@property (nonatomic, strong) AVAudioPlayer *player;

@end

@implementation DBRecordVC
- (void)playData:(NSData*)data {

// WAV 音频文件的 URL
NSURL *audioURL = [NSURL URLWithString:@"http://esxf.esxscloud.com/AudioCall/20240926/2f1def727fb3058d4ace4db12fa0c992.wav"];

// 创建 AVPlayer 对象
AVPlayer *player = [AVPlayer playerWithURL:audioURL];

// 创建 AVPlayerLayer 对象
AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
playerLayer.frame = self.view.bounds; // 设置播放器图层的大小和位置
    playerLayer.backgroundColor = [UIColor clearColor].CGColor;
// 将 AVPlayerLayer 添加到视图的层级中
[self.view.layer addSublayer:playerLayer];

// 开始播放音频
[player play];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // 使用 GCD 在后台队列中执行下载任务
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *audioData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://esxf.esxscloud.com/AudioCall/20240926/2f1def727fb3058d4ace4db12fa0c992.wav"]];
        if (audioData) {
            // 下载完成后，在主线程中处理音频数据
            dispatch_async(dispatch_get_main_queue(), ^{
                [self playData:audioData];
            });
        } else {
            NSLog(@"Error downloading audio");
        }
    });

    
    return;
    self.audioPlayer = [[DBAudioPlayer alloc] init];
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session requestRecordPermission:^(BOOL granted) {
        
    }];
        NSError *error = nil;
        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
        [session setActive:YES error:&error];
    
    NSDictionary *recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    //采样率  8000/11025/22050/44100/96000（影响音频的质量）
                                    [NSNumber numberWithFloat: 44100],AVSampleRateKey,
                                    // 音频格式
                                    [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
//                                   //采样位数  8、16、24、32 默认为16
                                    [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                                    // 音频通道数 1 或 2
                                    [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,
                                   
                                    nil];
    //[[NSBundle mainBundle] pathForResource:@"333.wav" ofType:nil];//
    NSString *path = [[self filePath] stringByAppendingPathComponent:@"333.wav"];
    NSLog(@"%@",path);

    NSFileManager* fileManager=[NSFileManager defaultManager];
    if([fileManager removeItemAtPath:path error:nil])
    {
        NSLog(@"删除");
    }

    self.recordFileURL = [NSURL URLWithString:path];
    self.recorder = [[AVAudioRecorder alloc] initWithURL:self.recordFileURL settings:recordSetting error:&error];
    self.recorder.meteringEnabled = YES;
    [self.recorder prepareToRecord];

    UIButton *startBtn = [[UIButton alloc] init];
    startBtn.frame = CGRectMake(100, 100, 100, 100);
    [self.view addSubview:startBtn];
    [startBtn setTitle:@"开始" forState:UIControlStateNormal];
    [startBtn addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
    
    {
        UIButton *startBtn = [[UIButton alloc] init];
        startBtn.frame = CGRectMake(100, 300, 100, 100);
        [self.view addSubview:startBtn];
        [startBtn setTitle:@"结束" forState:UIControlStateNormal];
        [startBtn addTarget:self action:@selector(stop) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)start {
    [self.recorder record];
    NSLog(@"开始");

//    [self.recorder updateMeters];
}

- (BOOL)stop
{
    if (self.recorder && [self.recorder isRecording])
    {
        NSLog(@"结束");
        [self.recorder stop];
//        [self.recorder deleteRecording];
    }
    
    
    [self.audioPlayer playAudioWithUrl:[NSURL fileURLWithPath:self.recordFileURL.absoluteString]];
//    NSString *path = [[self filePath] stringByAppendingPathComponent:@"333.mp3"];
//
//    BOOL result = [self convertMp3from:self.recordFileURL.absoluteString topath:path];
//    NSLog(@"1111 %d",result);
    return NO;
}

- (BOOL) convertMp3from:(NSString *)wavpath topath:(NSString *)mp3path
{
    NSString *filePath =wavpath ;
    
    NSString *mp3FilePath = mp3path;
    
    BOOL isSuccess = NO;
    if (filePath == nil  || mp3FilePath == nil){
        return isSuccess;
    }
    
    NSFileManager* fileManager=[NSFileManager defaultManager];
    if([fileManager removeItemAtPath:mp3FilePath error:nil])
    {
        NSLog(@"删除");
    }
    
    @try {
        int read, write;
        
        FILE *pcm = fopen([filePath cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
        if (pcm) {
            fseek(pcm, 4*1024, SEEK_CUR);
            FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置
            
            const int PCM_SIZE = 8192;
            const int MP3_SIZE = 8192;
            short int pcm_buffer[PCM_SIZE*2];
            unsigned char mp3_buffer[MP3_SIZE];
            
            lame_t lame = lame_init();
            lame_set_in_samplerate(lame, 8000.0);
            lame_set_num_channels(lame, 2);//通道
            lame_set_quality(lame, 1);//质量
            //lame_set_VBR(lame, vbr_default);
            lame_set_brate(lame, 16);
            lame_set_mode(lame, 3);
            lame_init_params(lame);
            
            do {
                read = (int)fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
                if (read == 0)
                    write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
                else
                    write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
                
                fwrite(mp3_buffer, write, 1, mp3);
                
            } while (read != 0);
            
            lame_close(lame);
            fclose(mp3);
            fclose(pcm);
            isSuccess = YES;
        }
        //skip file header
    }
    @catch (NSException *exception) {
        NSLog(@"error");
    }
    @finally {
//        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
//            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
//        }
        return isSuccess;
    }
    
}

- (NSString *)filePath {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES) objectAtIndex:0];//AnchorMusic
}

-(void)checkRecordPermission{
    AVAudioSession* session = [AVAudioSession sharedInstance];
    AVAudioSessionRecordPermission recordPermission = [session recordPermission];
    if( recordPermission == AVAudioSessionRecordPermissionUndetermined )
    {
        NSLog(@"record permission:%d", recordPermission );
        if( [session respondsToSelector:@selector( requestRecordPermission:)])
        {
            [session requestRecordPermission:^(BOOL granted) {
                if( granted )
                {
                    NSLog(@"get record permission");
                }
                else{
                    NSLog(@"not permit record");
                }
            }];
        }
    }
    else{
        if( recordPermission == AVAudioSessionRecordPermissionGranted )
        {
            NSLog(@"already get record permission");
        }
        else{
            NSLog(@"already denied record permission ,please set in settings");
        }
    }
}
@end
