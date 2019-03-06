//
//  FaceContrastTool.h
//  人脸识别测试
//
//  Created by kys-cym on 2019/2/27.
//  Copyright © 2019 kys-24. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AFNetworking.h>

@interface FaceContrastTool : NSObject

// 取出用户保存的图片
+ (UIImage *)showUserPicture;
// 保存用户图片
+ (void)saveUserPicture:(UIImage *)image;
// 删除用户图片
+ (void)deleteUserPicture;
// 用图片与用户人脸进行比对
+ (void)faceAlignmentWith:(UIImage *)image;

@end

