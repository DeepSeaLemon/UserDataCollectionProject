//
//  ScanFacesViewController.h
//  人脸识别测试
//
//  Created by kys-24 on 2019/3/1.
//  Copyright © 2019 kys-24. All rights reserved.
//

#import <UIKit/UIKit.h>

//  定义枚举类型-扫描的用途类型 0.登录 1.注册    用于执行不同的操作判断
typedef enum ScanFaceType {
    ScanFaceTypeLogin = 0,
    ScanFaceTypeRegist
} ScanFaceType;

// 图片闭包
typedef void (^ScanFacesBlock)(UIImage *image);

@interface ScanFacesViewController : UIViewController
// 图片闭包实例
@property(nonatomic,copy) ScanFacesBlock imageBlock;
// 扫描的用途类型实例
@property(nonatomic,assign)ScanFaceType scanFaceType;

@end

