//
//  NZCollectionViewFlowLayout.m
//  CollectionViewLyout
//
//  Created by 聂政 on 2019/6/17.
//  Copyright © 2019 聂政. All rights reserved.
//

#import "NZCollectionViewFlowLayout.h"

@implementation NZCollectionViewFlowLayout
- (NSArray *) layoutAttributesForElementsInRect:(CGRect)rect {
    // 获取系统帮我们计算好的Attributes
    NSArray *answer = [super layoutAttributesForElementsInRect:rect];
    
    // 遍历结果
    for(int i = 0; i < [answer count]; ++i) {
        
        if (i == 0) {
            UICollectionViewLayoutAttributes *currentLayoutAttributes = answer[i];
            CGRect frame = currentLayoutAttributes.frame;
            ///第一行只有一个cell、cell在最左边
            if (currentLayoutAttributes.frame.origin.x > 0) {
                frame.origin.x = 0;
            }
            //满足则给当前cell的frame属性赋值（不满足的cell会根据系统布局换行）
            currentLayoutAttributes.frame = frame;
        }else{
            // 获取cell的Attribute，根据上一个cell获取最大的x，定义为origin
            UICollectionViewLayoutAttributes *currentLayoutAttributes = answer[i];
            UICollectionViewLayoutAttributes *prevLayoutAttributes = answer[i - 1];
            NSInteger origin = CGRectGetMaxX(prevLayoutAttributes.frame);
            
            // 设置cell最大间距
            NSInteger maximumSpacing = 10;
            
            // 若当前cell和precell在同一行：①判断当前的cell加间距后的最大宽度是否小于ContentSize的宽度，②判断当前cell的x是否大于precell的x（否则cell会出现重叠）
            CGRect frame = currentLayoutAttributes.frame;
            ///当前cell换行，cell在最左边，第一行只有一个cell、cell在最左边
            if (currentLayoutAttributes.frame.origin.y > prevLayoutAttributes.frame.origin.y) {
                frame.origin.x = 0;
            }else{
                frame.origin.x = origin + maximumSpacing;
            }
            //满足则给当前cell的frame属性赋值（不满足的cell会根据系统布局换行）
            currentLayoutAttributes.frame = frame;
        }
    }
    return answer;
}

@end
