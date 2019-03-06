//
//  RegistView.m
//  UserDataCollectionProject
//
//  Created by kys-24 on 2019/3/4.
//  Copyright © 2019 kys-24. All rights reserved.
//

#import "RegistView.h"
#import <Masonry.h>

@implementation RegistView
{
    UITextField *_pnTF; // 电话号码输入
    UITextField *_pwdTF; // 密码输入
    UITextField *_pwdAgainTF; // 密码再次输入
    BOOL _isSure;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        _isSure = NO;
        [self setUI];
    }
    return self;
}

#pragma mark - UI
- (void)setUI{
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"—————  注册  —————";
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
    _pwdTF.keyboardType = UIKeyboardTypeNumberPad;
    [cardView addSubview:_pwdTF];
    [_pwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.right.equalTo(@-20);
        make.top.equalTo(self->_pnTF.mas_bottom).offset(24);
        make.height.equalTo(@32);
    }];
    
    _pwdAgainTF = [UITextField new];
    _pwdAgainTF.backgroundColor = RGB(241, 240, 240);
    _pwdAgainTF.layer.cornerRadius = 5;
    _pwdAgainTF.placeholder = @"    确认六位数密码";
    _pwdAgainTF.keyboardType = UIKeyboardTypeNumberPad;
    [cardView addSubview:_pwdAgainTF];
    [_pwdAgainTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.right.equalTo(@-20);
        make.top.equalTo(self->_pwdTF.mas_bottom).offset(24);
        make.height.equalTo(@32);
    }];
    
    UIButton *faceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    faceBtn.backgroundColor = [UIColor whiteColor];
    UIImage *icon = [UIImage imageNamed:@"face_icon"];
    [faceBtn setImage:icon forState:UIControlStateNormal];
    [cardView addSubview:faceBtn];
    [faceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@68);
        make.top.equalTo(self->_pwdAgainTF.mas_bottom).offset(37);
        make.width.height.equalTo(@39);
    }];
    [faceBtn addTarget:self action:@selector(clickFaceBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *faceRightBtn = [UIButton new];
    faceRightBtn.backgroundColor = [UIColor whiteColor];
    [faceRightBtn setTitle:@"添加人脸数据" forState:UIControlStateNormal];
    [faceRightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [faceRightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    faceRightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [cardView addSubview:faceRightBtn];
    [faceRightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(faceBtn.mas_right).offset(14);
        make.top.equalTo(self->_pwdAgainTF.mas_bottom).offset(46);
        make.height.equalTo(@20);
        make.width.equalTo(@100);
    }];
    [faceRightBtn addTarget:self action:@selector(clickFaceBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *confirmBtn = [UIButton new];
    confirmBtn.layer.cornerRadius = 10;
    confirmBtn.layer.masksToBounds = YES;
    [confirmBtn.layer setBorderColor:[UIColor grayColor].CGColor];
    [confirmBtn.layer setBorderWidth:2.5];
    [cardView addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@67);
        make.top.equalTo(faceBtn.mas_bottom).offset(37);
        make.width.height.equalTo(@20);
    }];
    [confirmBtn addTarget:self action:@selector(clickConfirmBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *termsBtn = [UIButton new];
    termsBtn.backgroundColor = [UIColor whiteColor];
    [termsBtn setTitle:@"我已阅读相关条款" forState:UIControlStateNormal];
    [termsBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [termsBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    termsBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [cardView addSubview:termsBtn];
    [termsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(confirmBtn.mas_right);
        make.top.equalTo(faceBtn.mas_bottom).offset(37);
        make.height.equalTo(@20);
        make.width.equalTo(@140);
    }];
    [termsBtn addTarget:self action:@selector(clickShowBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *registBtn = [UIButton new];
    registBtn.layer.cornerRadius = 16;
    registBtn.backgroundColor = RGB(117, 171, 228);
    registBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [registBtn setTitle:@"确认" forState:UIControlStateNormal];
    [registBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cardView addSubview:registBtn];
    [registBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@-33);
        make.left.equalTo(@59);
        make.right.equalTo(@-59);
        make.height.equalTo(@33);
    }];
    [registBtn addTarget:self action:@selector(clickRegistBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *backBtn = [UIButton new];
    backBtn.layer.cornerRadius = 28.5;
    [backBtn setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    [self addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.height.equalTo(@57);
        make.bottom.equalTo(@-60);
    }];
    [backBtn addTarget:self action:@selector(clickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)clickBackBtn:(UIButton *)sender{
    !_btnBlock?:_btnBlock(@"back");
}
- (void)clickFaceBtn:(UIButton *)sender{
    !_btnBlock?:_btnBlock(@"face");
}
- (void)clickConfirmBtn:(UIButton *)sender{
    if (_isSure) {
        sender.backgroundColor = [UIColor whiteColor];
        _isSure = NO;
    }else{
        sender.backgroundColor = RGB(117, 171, 228);
        _isSure = YES;
    }
}
- (void)clickShowBtn:(UIButton *)sender{
    !_btnBlock?:_btnBlock(@"show");
}
- (void)clickRegistBtn:(UIButton *)sender{
    !_btnBlock?:_btnBlock(@"regist");
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:4];
    [dict setObject:_pnTF.text forKey:@"pn"];
    [dict setObject:_pwdTF forKey:@"pwd"];
    [dict setObject:_pwdAgainTF forKey:@"pwda"];
    _isSure?[dict setObject:@"YES" forKey:@"isSure"]:[dict setObject:@"NO" forKey:@"isSure"];
    !_dataBlock?:_dataBlock(dict);
}

@end
