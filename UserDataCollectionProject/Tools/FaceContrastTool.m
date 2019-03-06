//
//  FaceContrastTool.m
//  人脸识别测试
//
//  Created by kys-cym on 2019/2/27.
//  Copyright © 2019 kys-24. All rights reserved.
//

#import "FaceContrastTool.h"

@implementation FaceContrastTool

+ (UIImage *)showUserPicture{
    NSData *data = [NSData dataWithContentsOfFile:[self getUserPicterPath]];
    return [UIImage imageWithData:data];
}

+ (void)saveUserPicture:(UIImage *)image{
    
    [UIImagePNGRepresentation(image) writeToFile:[self getUserPicterPath] atomically:YES];
}

+ (void)deleteUserPicture{
    NSFileManager *fileManage = [NSFileManager defaultManager];
    if ([fileManage fileExistsAtPath:[self getUserPicterPath]]) {
        NSLog(@"文件存在");
        BOOL isSuccess = [fileManage removeItemAtPath:[self getUserPicterPath] error:nil];
        NSLog(@"%@",isSuccess ? @"删除成功" : @"删除失败");
    }else{
        NSLog(@"文件不存在");
    }
}

+ (void)faceAlignmentWith:(UIImage *)image{
    // 先请求百度鉴权  再以鉴权为参数请求人脸对比
    // 获取本地图片
    NSData *data1 = UIImageJPEGRepresentation([self showUserPicture],0.5f);
    // 获取拍照图片
    NSData *data2 = UIImageJPEGRepresentation(image,0.5f);
    // 转化为Base64
    NSString *str1 = [data1 base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSString *str2 = [data2 base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    // 拼接Url
    NSString *urlString = [NSString stringWithFormat:@"%@&client_id=%@&client_secret=%@",baidu_access_token_api,baidu_appkey,baidu_secretkey];
    // 设置连接
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    // 开始请求
    [manager POST:urlString parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 数据解析
        NSDictionary *root = (NSDictionary *)responseObject;
        // 拼接Url
        NSString *url = [NSString stringWithFormat:@"%@%@",baidu_face_api,root[@"access_token"]];
        // 配置请求头
        [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        // 添加请求体
        NSArray *images = @[@{@"image":str1,@"image_type": @"BASE64"},@{@"image":str2,@"image_type": @"BASE64"}];
        // 开始请求
        [manager POST:url parameters:images progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            // 解析数据
            NSDictionary *faceData = (NSDictionary *)responseObject;
            NSDictionary *result = faceData[@"result"];
            // 回调出去
            NSLog(@"%@",result[@"score"]);
#warning 写回调掉出去   还要写HUD
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error.description);
        }];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.description);
    }];
}

+ (NSString *)getUserPicterPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"userPicture.png"];
    return filePath;
}
@end
