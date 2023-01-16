//
//  DBImageEditVC.h
//  Tools
//
//  Created by dengbinOld on 2023/1/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBImageEditVC : UIViewController
/// 要裁切的图片
@property (nonatomic, strong) UIImage *originImg;

/// 裁切完成的图片
@property (nonatomic, copy) void (^editFinashBlk)(UIImage *img);
/// 取消
@property (nonatomic, copy) void (^cancelEditBlk)();

@end

NS_ASSUME_NONNULL_END
