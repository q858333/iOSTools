//
//  DBTableViewCell.h
//  Tools
//
//  Created by dengbinOld on 2023/7/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBTableViewCell : UITableViewCell
@property (nonatomic, copy) void (^inviteCallback)(NSString *uid);

@end

NS_ASSUME_NONNULL_END
