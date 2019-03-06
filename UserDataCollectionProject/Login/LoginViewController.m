//
//  LoginViewController.m
//  UserDataCollectionProject
//
//  Created by kys-24 on 2019/3/2.
//  Copyright © 2019 kys-24. All rights reserved.
//
#import "FaceContrastTool.h"
#import "IPhoneMsgTool.h"
#import "LoginView.h"
#import "LoginViewController.h"
#import "RegistViewController.h"
#import "ScanFacesViewController.h"
#import "ShowTermsViewController.h"

@interface LoginViewController ()

@property(nonatomic,strong)LoginView *loginView;


@end

@implementation LoginViewController
{
    BOOL _isThrough;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    _isThrough = NO;
    _loginView = [[LoginView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_loginView];
    [self clickLoginViewBtnFunc];
}

- (void)clickLoginViewBtnFunc
{
    __weak typeof(self) weakSelf = self;
    _loginView.btnBlock = ^(NSString * _Nonnull str) {
        if ([str isEqualToString:@"show"]) {
            // 跳转到展示条款界面
            ShowTermsViewController *ctr = [ShowTermsViewController new];
            [weakSelf presentViewController:ctr animated:YES completion:nil];
        }
        if ([str isEqualToString:@"face"]) {
            if ([FaceContrastTool showUserPicture] == nil) {
                // 无数据时的提示
            }else{
                // 跳转到拍照界面拍照后将人脸对比
                ScanFacesViewController *ctr = [ScanFacesViewController new];
                ctr.scanFaceType = ScanFaceTypeLogin;
                [weakSelf presentViewController:ctr animated:YES completion:nil];
                ctr.imageBlock = ^(UIImage * _Nonnull image) {
                    [FaceContrastTool faceAlignmentWith:image];
#warning 对比通过就将 _isThrough = YES;
                };
            }
        }
        if ([str isEqualToString:@"login"]) {
            // 登录事件
           weakSelf.loginView.dataBlock = ^(NSDictionary * _Nonnull dict) {
                // 判断数据并处理
               if ([weakSelf mustJudgedBeforeLoginWith:dict]) {
                   // 登录
               }
            };
        }
        if ([str isEqualToString:@"regist"]) {
            // 跳转到注册
            RegistViewController *ctr = [RegistViewController new];
            [weakSelf presentViewController:ctr animated:YES completion:nil];
        }
    };
}
- (BOOL)mustJudgedBeforeLoginWith:(NSDictionary *)dict{
#warning 写弹窗
    if (![IPhoneMsgTool isValidPhone:dict[@"pn"]]) {
        return NO;
    }else if ([dict[@"isSure"] isEqualToString:@"NO"]){
        return NO;
    }else if (!_isThrough){
        return NO;
    }else{
        return YES;
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
