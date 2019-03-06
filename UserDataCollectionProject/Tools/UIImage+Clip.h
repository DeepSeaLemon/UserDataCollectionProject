//
//  UIImage+Clip.h
//  ImageDemo
//
//  Created by 曹宇明 on 2018/7/17.
//  Copyright © 2018年 default. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface UIImage (Clip)

/**
 按照size改变图片 图片可能会被拉伸

 @param size 需要的size
 @return 修改后的UIImage
 */
- (UIImage *)thumWithSize:(CGSize)size;

/**
 图片的旋转

 @param orientation 旋转的类型
 @return 旋转后的图片
 */
- (UIImage *)rotateWithOrientation:(UIImageOrientation)orientation;

@end
