//
//  PlayerVC.m
//  Tools
//
//  Created by deng on 2022/3/28.
//

#import "PlayerVC.h"

@interface PlayerVC ()

@end

@implementation PlayerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view  addSubview:self.player];
    self.player.frame = self.view.bounds;
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
