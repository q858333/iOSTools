//
//  DBScrollListView.m
//  Tools
//
//  Created by deng on 2021/11/16.
//

#import "DBScrollListView.h"
#import "Masonry.h"
#import <YYKit/YYKit.h>
@interface DBScrollListView ()<UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) CGFloat scrollViewOffsetY;
@property (nonatomic, assign) BOOL isBottom;

@end
@implementation DBScrollListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configView];
    }
    return self;
}
- (void)configView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.bounds];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self addSubview:tableView];
    self.tableView = tableView;
    
    UIPanGestureRecognizer * panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    panGestureRecognizer.delegate = self;
    [self addGestureRecognizer:panGestureRecognizer];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
 
    return YES;
}

#pragma - mark UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSInteger row = indexPath.row;
    
    cell.textLabel.text = [NSString stringWithFormat:@"%zd",row];
    
    return cell;
}



#pragma - mark ScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat currentOffsetY = self.tableView.contentOffset.y;
    self.scrollViewOffsetY = currentOffsetY;
    if (self.top>self.upTopOffset) {
        [scrollView setContentOffset:CGPointMake(0, 0)];
    }
    
}

- (void)panAction:(UIGestureRecognizer *)gr
{
    
    if(![gr isKindOfClass:[UIPanGestureRecognizer class]]){
        return;
    }
    UIPanGestureRecognizer *pan =(UIPanGestureRecognizer *) gr;
    // scrollViewOffsetY是tableview的偏移量，当tableview的偏移量大于0时则不去处理视图滑动的事件
    if (self.scrollViewOffsetY>0) {
        // 将视频偏移量重置为0
        [pan setTranslation:CGPointMake(0, 0) inView:self];

        return;
    }
    
    if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled) {
        CGPoint velocity = [pan velocityInView:self];
        CGFloat speed = 350;

        /// 速度
        if (velocity.y < -speed) {
            [self goTop];
            [pan setTranslation:CGPointMake(0, 0) inView:self];
            return;
        }else if (velocity.y > speed){
            if(self.isBottom){
                [self hidenListAndJump];
            }else{
                [self goBottom];
            }
            [pan setTranslation:CGPointMake(0, 0) inView:self];
            return;
        }
        
        
        // 获取视图偏移量
        if (self.top > kScreenHeight/2 && self.top < self.downTopOffset) {
            [self goBottom];
        }else if (self.top>self.downTopOffset){
            if(self.top>self.downTopOffset+50){
                [self hidenListAndJump];
            }else{
                [self goBottom];
            }
            
            
            
        }else{
            [self goTop];
        }
        
    } else if(pan.state  == UIGestureRecognizerStateChanged){
        CGPoint point = [pan translationInView:self];
        
        
        self.top += point.y;
        if (self.top < self.upTopOffset) {
            self.top = self.upTopOffset;
        }
        
        // self.bottomH是视图在底部时距离顶部的距离
        //        if (self.top > self.bottomH) {
        //            self.top = self.bottomH;
        //        }
    }
    
    
    [pan setTranslation:CGPointMake(0, 0) inView:self];

   
}

- (void)hidenListAndJump{
    [UIView animateWithDuration:0.3 animations:^{
        self.top = kScreenHeight;
    }completion:^(BOOL finished) {
        self.top = self.downTopOffset;
        
#warning 这里可以进行跳转操作
    }];
}
- (void)goTop {
    self.isBottom = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.top = self.upTopOffset;
    }completion:^(BOOL finished) {
        self.tableView.scrollEnabled = YES;

    }];
}

- (void)goBottom {
    self.isBottom = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.top = self.downTopOffset;
    }completion:^(BOOL finished) {
        self.tableView.scrollEnabled = NO;
    }];
}

@end
