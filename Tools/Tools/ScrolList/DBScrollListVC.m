//
//  DBScrollListVC.m
//  Tools
//
//  Created by deng on 2021/11/16.
//

#import "DBScrollListVC.h"
#import "DBScrollListView.h"
#import <CoreHaptics/CoreHaptics.h>

@interface DBScrollListVC ()
@end

@implementation DBScrollListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    CGFloat viewHeight = CGRectGetHeight(self.view.frame);
    
    CGFloat topOffset = 110;
    CGFloat bottomOffset = viewHeight-190;

    DBScrollListView *view = [[DBScrollListView alloc] initWithFrame:CGRectMake(0, bottomOffset, CGRectGetWidth(self.view.frame), viewHeight-topOffset)];
    view.upTopOffset = topOffset;
    view.downTopOffset = bottomOffset;
    [self.view addSubview:view];
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
