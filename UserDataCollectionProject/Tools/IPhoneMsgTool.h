//
//  IPhoneMsgTool.h
//  自定义键盘
//
//  Created by kys-cym on 2019/2/26.
//  Copyright © 2019 kys-24. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "sys/utsname.h"


@interface IPhoneMsgTool : NSObject

/**
 判断手机号码

 @param phone 手机号
 @return 是否
 */
+ (BOOL)isValidPhone:(NSString *)phone;

/**
 获取手机型号

 @return 手机型号
 */
+ (NSString *)getIPhoneDeviceModel;

/**
 获取手机系统版本

 @return 手机系统版本
 */
+ (NSString *)getIPhoneVersion;

/**
 获取UUID

 @return UUID
 */
+ (NSString *)getIPhoneUUID;

/**
 计算按键时间

 @param timeData 时间元数据
 @return 点按时间
 */
+ (NSDictionary *)processingTimeData:(NSMutableArray *)timeData;
@end


