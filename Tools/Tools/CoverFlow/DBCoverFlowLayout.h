//
//  DBCoverFlowLayout.h
//  Tools
//
//  Created by DDDD on 2024/9/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, HJCarouselAnim) {
    HJCarouselAnimLinear,
    HJCarouselAnimRotary,
    HJCarouselAnimCarousel,
    HJCarouselAnimCarousel1,
    HJCarouselAnimCoverFlow,
};
@interface DBCoverFlowLayout : UICollectionViewFlowLayout

- (instancetype)initWithAnim:(HJCarouselAnim)anim;

@property (readonly)  HJCarouselAnim carouselAnim;

@property (nonatomic) NSInteger visibleCount;
@end

NS_ASSUME_NONNULL_END
