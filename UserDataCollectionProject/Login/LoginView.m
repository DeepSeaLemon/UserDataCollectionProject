//
//  LoginView.m
//  UserDataCollectionProject
//
//  Created by kys-24 on 2019/3/4.
//  Copyright © 2019 kys-24. All rights reserved.
//

#import "LoginView.h"
#import <Masonry.h>
#import "CustomKeyboardView.h"
@implementation LoginView
{
    BOOL _isSure;
    UITextField *_pnTF; // 电话号码输入
    UITextField *_pwdTF; // 密码输入
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _isSure = NO;
        [self setUI];
    }
    return self;
}
#pragma mark - UI
- (void)setUI{
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"—————  登录  —————";
    titleLabel.textColor = TextColor;
    titleLabel.font = [UIFont systemFontOfSize:20];
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(@62);
    }];
    
    UIView *cardView = [UIView new];
    cardView.backgroundColor = [UIColor whiteColor];
    cardView.layer.cornerRadius = 15;
    cardView.layer.shadowColor = [UIColor grayColor].CGColor;
    cardView.layer.shadowOffset = CGSizeMake(0, 0);
    cardView.layer.shadowOpacity = 0.5;
    cardView.layer.shadowRadius = 5;
    [self addSubview:cardView];
    [cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(25);
        make.left.equalTo(@45);
        make.right.equalTo(@-45);
        make.bottom.equalTo(@-160);
    }];
    
    _pnTF = [UITextField new];
    _pnTF.backgroundColor = RGB(241, 240, 240);
    _pnTF.layer.cornerRadius = 5;
    _pnTF.placeholder = @"    输入手机号";
    _pnTF.keyboardType = UIKeyboardTypeNumberPad;
    [cardView addSubview:_pnTF];
    [_pnTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.right.equalTo(@-20);
        make.top.equalTo(@43);
        make.height.equalTo(@32);
    }];
    
    _pwdTF = [UITextField new];
    _pwdTF.backgroundColor = RGB(241, 240, 240);
    _pwdTF.layer.cornerRadius = 5;
    _pwdTF.placeholder = @"    输入六位数密码";
    [cardView addSubview:_pwdTF];
    [_pwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.right.equalTo(@-20);
        make.top.equalTo(self->_pnTF.mas_bottom).offset(24);
        make.height.equalTo(@32);
    }];
    
    UIButton    *confirmBtn = [UIButton new];
    confirmBtn.layer.cornerRadius = 10;
    confirmBtn.layer.masksToBounds = YES;
    [confirmBtn.layer setBorderColor:[UIColor grayColor].CGColor];
    [confirmBtn.layer setBorderWidth:2.5];
    [cardView addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@67);
        make.top.equalTo(self->_pwdTF.mas_bottom).offset(34);
        make.width.height.equalTo(@20);
    }];
    [confirmBtn addTarget:self action:@selector(sureTerms:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *termsBtn = [UIButton new];
    termsBtn.backgroundColor = [UIColor whiteColor];
    [termsBtn setTitle:@"我已阅读相关条款" forState:UIControlStateNormal];
    [termsBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [termsBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    termsBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [cardView addSubview:termsBtn];
    [termsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(confirmBtn.mas_right);
        make.top.equalTo(self->_pwdTF.mas_bottom).offset(34);
        make.height.equalTo(@20);
        make.width.equalTo(@130);
    }];
    [termsBtn addTarget:self action:@selector(showTerms:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *faceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    faceBtn.backgroundColor = [UIColor whiteColor];
    UIImage *icon = [UIImage imageNamed:@"face_icon"];
    [faceBtn setImage:icon forState:UIControlStateNormal];
    [cardView addSubview:faceBtn];
    [faceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@78);
        make.top.equalTo(termsBtn.mas_bottom).offset(36);
        make.width.height.equalTo(@39);
    }];
    [faceBtn addTarget:self action:@selector(clickFaceBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *faceRightBtn = [UIButton new];
    faceRightBtn.backgroundColor = [UIColor whiteColor];
    [faceRightBtn setTitle:@"人脸数据" forState:UIControlStateNormal];
    [faceRightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [faceRightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    faceRightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [cardView addSubview:faceRightBtn];
    [faceRightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(faceBtn.mas_right).offset(14);
        make.top.equalTo(termsBtn.mas_bottom).offset(46);
        make.height.equalTo(@20);
        make.width.equalTo(@70);
    }];
    [faceRightBtn addTarget:self action:@selector(clickFaceBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *loginBtn = [UIButton new];
    loginBtn.layer.cornerRadius = 16;
    loginBtn.backgroundColor = RGB(117, 171, 228);
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [loginBtn setTitle:@"确认" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cardView addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(faceBtn.mas_bottom).offset(33);
        make.left.equalTo(@59);
        make.right.equalTo(@-59);
        make.height.equalTo(@33);
    }];
    [loginBtn addTarget:self action:@selector(clickLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *registBtn = [UIButton new];
    registBtn.backgroundColor = [UIColor whiteColor];
    [registBtn setTitle:@"点击注册>" forState:UIControlStateNormal];
    [registBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [registBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    registBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [cardView addSubview:registBtn];
    [registBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@110);
        make.right.equalTo(@-100);
        make.bottom.equalTo(@-28);
        make.height.equalTo(@25);
    }];
    [registBtn addTarget:self action:@selector(clickRegistBtn:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - clickBtnFunc
/**
 注册事件->跳转到注册界面
 
 @param sender 注册按钮
 */
- (void)clickRegistBtn:(UIButton *)sender{
    !_btnBlock? : _btnBlock(@"regist");
}

/**
 登录事件
 
 @param sender 登录按钮
 */
- (void)clickLoginBtn:(UIButton *)sender{
    !_btnBlock? : _btnBlock(@"login");
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:3];
    [dict setObject:_pnTF.text forKey:@"pn"];
    [dict setObject:_pwdTF.text forKey:@"pwd"];
    _isSure?[dict setObject:@"YES" forKey:@"isSure"]:[dict setObject:@"NO" forKey:@"isSure"];
    !_dataBlock? : _dataBlock(dict);
}

/**
 进入拍照界面
 
 @param sender 拍照按钮
 */
- (void)clickFaceBtn:(UIButton *)sender{
   !_btnBlock? : _btnBlock(@"face");
}

/**
 确认条款->返回一个Bool用于确认
 
 @param sender 确认条款按钮
 */
- (void)sureTerms:(UIButton *)sender{
    if (_isSure) {
        sender.backgroundColor = [UIColor whiteColor];
        _isSure = NO;
    }else{
        sender.backgroundColor = RGB(117, 171, 228);
        _isSure = YES;
    }
}

/**
 展示条款->跳转到展示条款的界面
 
 @param sender 展示条款按钮
 */
- (void)showTerms:(UIButton *)sender{
    !_btnBlock? : _btnBlock(@"show");
}

@end

