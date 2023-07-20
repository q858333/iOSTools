//
//  ViewController.m
//  Tools
//
//  Created by dengbin on 2021/1/31.
//

#import "ViewController.h"
#import "LMLightLabel.h"
@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray *list;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
        
    self.list = @[@{@"title":@"模仿高德首页列表滑动效果",@"class":@"DBScrollListVC"},
                  @{@"title":@"无限循环",@"class":@"LoopScrollVC"},
                  @{@"title":@"转盘、饼状图",@"class":@"DBRouletteVC"},
                  @{@"title":@"图片裁切",@"class":@"DBImageEditVC"},
                  @{@"title":@"输入框",@"class":@"DBImageEditVC"},
                  @{@"title":@"动画",@"class":@"DBAnimationVC"},
                  @{@"title":@"线程、队列",@"class":@"DBThreadQueueVC"},
                  
    ];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:tableView];
    if (@available(iOS 11.0, *)){
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    LMLightLabel *comboLabel = [[LMLightLabel alloc] init];
    [self.view addSubview:comboLabel];
    comboLabel.font = [UIFont systemFontOfSize:20];
    comboLabel.textAlignment = NSTextAlignmentCenter;
    comboLabel.frame = CGRectMake(0, 50, 200, 100);
    comboLabel.font = [UIFont systemFontOfSize:30];
    comboLabel.gradientLayer.startPoint = CGPointMake(0.5, 0);
    comboLabel.gradientLayer.endPoint = CGPointMake(0.5, 1);
    comboLabel.text= @"123123";
    [comboLabel updateGradientLayerColor:@[(id)[UIColor redColor].CGColor, (id)[UIColor blueColor].CGColor]];

    
    // 创建 UILabel
//       UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 100, 100, 100)];
//       label.textAlignment = NSTextAlignmentCenter;
////    label.text = @"Hello World";
//       // 创建渐变图层
//       CAGradientLayer *gradientLayer = [CAGradientLayer layer];
//       gradientLayer.frame = label.bounds;
//       gradientLayer.colors = @[(__bridge id)[UIColor redColor].CGColor, (__bridge id)[UIColor blueColor].CGColor];
//       gradientLayer.startPoint = CGPointMake(0.0, 0.5);
//       gradientLayer.endPoint = CGPointMake(1.0, 0.5);
//
//    NSString *text = @"Hello World";
//     NSDictionary *attributes = @{
//         NSForegroundColorAttributeName: [UIColor whiteColor],
//         NSStrokeColorAttributeName: [UIColor blackColor],
//         NSStrokeWidthAttributeName: @-2.0
//     };
//     NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text attributes:attributes];
//
//
////       // 创建 CATextLayer
//       CATextLayer *textLayer = [CATextLayer layer];
//       textLayer.frame = label.bounds;
//    textLayer.string = attributedText;
//       textLayer.alignmentMode = kCAAlignmentCenter;
//       textLayer.foregroundColor = [UIColor greenColor].CGColor;
//       textLayer.font = (__bridge CFTypeRef _Nullable)(label.font.fontName);
//       textLayer.fontSize = label.font.pointSize;
//
//       // 将渐变图层添加为文本图层的遮罩图层
//       gradientLayer.mask = textLayer;
//        label.layer.mask = gradientLayer;
//       // 将渐变图层添加到视图中
//       [label.layer addSublayer:gradientLayer];
//
//       // 将 UILabel 添加到视图中
//       [self.view addSubview:label];
    
}

#pragma - mark UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.list.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary * dic = [self.list objectAtIndex:indexPath.row];
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = dic[@"title"];
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    NSDictionary * dic = [self.list objectAtIndex:indexPath.row];
    Class class = NSClassFromString(dic[@"class"]);
    UIViewController *vc = [[class alloc] init];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
    
    
}


@end
