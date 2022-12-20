//
//  LoopScrollVC.m
//  Tools
//
//  Created by deng on 2022/3/28.
//

#import "LoopScrollVC.h"
#import <YYKit/YYKit.h>
#import "LoopScrollItemView.h"
#import "PlayerVC.h"
#import "PlayerView.h"

@interface LoopScrollVC ()
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) LoopScrollItemView *leftView;
@property (nonatomic, strong) LoopScrollItemView *midView;
@property (nonatomic, strong) LoopScrollItemView *rightView;

@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) NSArray *dataList;


@property (nonatomic, strong) PlayerView *player;

@end

@implementation LoopScrollVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 100, kScreenWidth, 100)];
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    [self fixiOS11:scrollView];
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    self.scrollView.contentSize = CGSizeMake(kScreenWidth*3, 100);
    
    
//    self.leftView = [[LoopScrollItemView alloc] init];
//    self.leftView.frame = CGRectMake(0, 0, kScreenWidth, 100);
//    [scrollView addSubview:self.leftView];
//
//    self.midView = [[LoopScrollItemView alloc] init];
//    self.midView.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, 100);
//    [scrollView addSubview:self.midView];
//
//
//    self.rightView = [[LoopScrollItemView alloc] init];
//    self.rightView.frame = CGRectMake(kScreenWidth*2, 0, kScreenWidth, 100);
//    [scrollView addSubview:self.rightView];
    

    self.dataList = @[@"1",@"2",@"3"];
    
    
    PlayerView *player = [[PlayerView alloc] init];
    
    [self.scrollView  addSubview:player];
    player.frame = CGRectMake(0, 0, kScreenWidth, 100);
    [player start];
    self.player = player;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.player removeFromSuperview];
//        [self.view addSubview:player];
//        player.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        PlayerVC *playervc = [[PlayerVC alloc] init];
        playervc.player = self.player;
        [self presentViewController:playervc animated:YES completion:nil];
    });
}

- (void)fixiOS11:(UIScrollView *)scrollview{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0) {
        if (@available(iOS 11.0, *)){
            scrollview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        if ([scrollview isKindOfClass:[UITableView class]]) {
            UITableView * table = (UITableView*)self;
            table.estimatedRowHeight = 0;
            table.estimatedSectionHeaderHeight = 0;
            table.estimatedSectionFooterHeight = 0;
        }
    }
}

-(void)showNextPoster
{
    self.currentPage++;
    if (self.currentPage >= self.dataList.count) {
        self.currentPage = 0;
    }
    
    [self showPosterAtIndex:self.currentPage];
}

-(void)showPrePoster
{
    self.currentPage--;
    if (self.currentPage < 0) {
        self.currentPage = self.dataList.count - 1;
    }
    
    [self showPosterAtIndex:self.currentPage];
}

- (void)showPosterAtIndex:(NSInteger)index
{
    NSArray *infos =self.dataList;
    if ([infos count] == 0) {
        return;
    }
    
    NSInteger leftindex,curidnex,rightindex;
    index = (index >= infos.count)?(infos.count-1):index;
    curidnex = index <= 0?0:index;
    leftindex = curidnex-1;
    leftindex = leftindex < 0 ?(infos.count-1):leftindex;
    rightindex = curidnex+1;
    rightindex = rightindex >= infos.count?0:rightindex;

    self.currentPage = curidnex;

    
    
    NSString *model = [infos objectAtIndex:leftindex];

    [self.leftView updateUIWithText:model];

    model = [infos objectAtIndex:index];

    [self.midView updateUIWithText:model];
    
    model = [infos objectAtIndex:rightindex];;
    [self.rightView updateUIWithText:model];
    
    
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    [self.midView pause];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if(scrollView == self.scrollView){
        
        if (self.dataList.count == 1 || self.dataList.count == 0) {
                return;
        }
              
        float curOffsetPage = scrollView.contentOffset.x/CGRectGetWidth(self.scrollView.frame);
              
          if (curOffsetPage >= 0.5 && curOffsetPage <1.5) {
              [self showPosterAtIndex:self.currentPage];
          }else if(curOffsetPage < 0.5){
              [self showPrePoster];
          }else if (curOffsetPage >=1.5) {
            [self showNextPoster];
          }
              
        scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.frame), 0);
        
        
//        [self reloadDataWithPage:self.currentPage];
        
    }
    
}

@end
