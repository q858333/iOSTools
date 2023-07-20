//
//  DBThreadQueueVC.m
//  Tools
//
//  Created by dengbinOld on 2023/7/20.
// https://www.cnblogs.com/sundaysgarden/articles/9597358.html
 
#import "DBThreadQueueVC.h"

@interface DBThreadQueueVC ()
@property (nonatomic ,strong) dispatch_queue_t serialQueue ;
@end

@implementation DBThreadQueueVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.serialQueue = dispatch_queue_create("com.ks.serialQueue", NULL); // 串行
//    self.serialQueue = dispatch_queue_create("com.ks.concurrentQueue", DISPATCH_QUEUE_CONCURRENT); 并发

    [self KSserialQueueAsync];
}
- (void)KSserialQueueAsync {
    NSLog(@"test start");
    
    
    dispatch_sync(self.serialQueue, ^{
        for (int i = 0; i < 2; i++) {
            NSLog(@"block1 %@", [NSThread currentThread]);
            if(1 == i) {
                [self KSserialQueueAsync];
            }
            
        }
    });

    
    NSLog(@"test over");
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
