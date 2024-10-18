//
//  DBCoverFlowVC.m
//  Tools
//
//  Created by DDDD on 2024/9/2.
//

#import "DBCoverFlowVC.h"
#import "DBCoverFlowLayout.h"
#import <YYKit/YYKit.h>

@interface DBCoverFlowVC ()

@end

@implementation DBCoverFlowVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    DBCoverFlowLayout *layout = [[DBCoverFlowLayout alloc] initWithAnim:HJCarouselAnimLinear];
    layout.itemSize = CGSizeMake(250, 250);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CellIdentifier"];
    [self.view addSubview:collectionView];
    return;
    UIScrollView *scrollview = [[UIScrollView alloc] init];
    [self.view addSubview:scrollview];
    scrollview.pagingEnabled = YES;
    scrollview.frame = self.view.bounds;
    scrollview.contentSize = CGSizeMake((kScreenWidth-40)*2 + 50, 300);
    scrollview.delegate = self;
    
    UIView *redView = [[UIView alloc] init];
    redView.backgroundColor = [UIColor redColor];
    [scrollview addSubview:redView];
    redView.frame = CGRectMake(20, 200, kScreenWidth-40, 300);

    
    UIView *greenView = [[UIView alloc] init];
    greenView.backgroundColor = [UIColor greenColor];
    [scrollview addSubview:greenView];
    greenView.frame = CGRectMake(CGRectGetMaxX(redView.frame) + 10, 200, kScreenWidth-40, 300);
    
    // 缩放视图
    redView.layer.anchorPoint = CGPointMake(0, 0.5);
    redView.transform = CGAffineTransformScale(redView.transform, 0.8, 0.8); // 缩放因子为1.5



}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
}

// 实现数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4; // 返回集合视图中项目的数量
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    // 配置单元格
    // 可以根据 indexPath 从数据源中获取相应的数据来填充单元格
    if(indexPath.row == 0) {
        cell.backgroundColor = [UIColor redColor];
    } else if (indexPath.row == 1) {
        cell.backgroundColor = [UIColor greenColor];
    }
    return cell;
}

// 实现委托方法（例如处理单元格选择）
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // 处理单元格选择事件
}
@end
