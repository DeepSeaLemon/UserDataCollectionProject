//
//  RegistViewController.m
//  UserDataCollectionProject
//
//  Created by kys-24 on 2019/3/2.
//  Copyright © 2019 kys-24. All rights reserved.
//

#import "RegistView.h"
#import "RegistViewController.h"
#import "ScanFacesViewController.h"
#import "FaceContrastTool.h"
#import "ShowTermsViewController.h"
#import "IPhoneMsgTool.h"

@interface RegistViewController ()

@property (nonatomic,strong) RegistView *registView;

@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view
    
    _registView = [[RegistView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_registView];
    [self clickRegistViewBtnFunc];
}

- (void)clickRegistViewBtnFunc{
    __weak typeof(self)weakSelf = self;
    _registView.btnBlock = ^(NSString * _Nonnull str) {
        if ([str isEqualToString:@"back"]) {
            // 返回事件
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }
        if ([str isEqualToString:@"show"]) {
            // 展示条款
            ShowTermsViewController *ctr = [ShowTermsViewController new];
            [weakSelf presentViewController:ctr animated:YES completion:nil];
        }
        if ([str isEqualToString:@"face"]) {
            ScanFacesViewController *ctr = [ScanFacesViewController new];
            ctr.scanFaceType = ScanFaceTypeRegist;
            [weakSelf presentViewController:ctr animated:YES completion:nil];
        }
        if ([str isEqualToString:@"regist"]) {// 注册事件
            weakSelf.registView.dataBlock = ^(NSDictionary * _Nonnull dict) {
                if ([weakSelf mustJudgedBeforeRegistWith:dict]) {
                    // 向服务器注册
#warning 向服务器注册
                }
            };
        }
    };
}

/**
 判断手机号
 判断两个密码是否相同
 判断是否有人脸数据
 判断是否确认条款

 @param dict 注册数据
 @return 判断
 */
- (BOOL)mustJudgedBeforeRegistWith:(NSDictionary *)dict{
#warning 注意弹窗提示
    if (![IPhoneMsgTool isValidPhone:dict[@"pn"]]) {
        return NO;
    }else if (![dict[@"pwd"] isEqualToString:dict[@"pwda"]]){
        return NO;
    }else if (![FaceContrastTool showUserPicture]){
        return NO;
    }else if ([dict[@"isSure"] isEqualToString:@"NO"]){
        return NO;
    }else{
        return YES;
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
