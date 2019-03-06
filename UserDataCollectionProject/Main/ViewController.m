//
//  ViewController.m
//  UserDataCollectionProject
//
//  Created by kys-24 on 2019/3/5.
//  Copyright © 2019 kys-cym. All rights reserved.
//

#import "ViewController.h"
#import <Masonry.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setUI];
}

- (void)setUI{
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"—————  本人操作  —————";
    titleLabel.textColor = TextColor;
    titleLabel.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(@62);
    }];
    
    UIView *cardView = [UIView new];
    cardView.backgroundColor = [UIColor whiteColor];
    cardView.layer.cornerRadius = 15;
    cardView.layer.shadowColor = [UIColor grayColor].CGColor;
    cardView.layer.shadowOffset = CGSizeMake(0, 0);
    cardView.layer.shadowOpacity = 0.5;
    cardView.layer.shadowRadius = 5;
    [self.view addSubview:cardView];
    [cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(25);
        make.left.equalTo(@45);
        make.right.equalTo(@-45);
        make.bottom.equalTo(@-160);
    }];
    
    UIButton *dataBtn = [UIButton new];
    dataBtn.backgroundColor = RGB(241, 240, 240);
    dataBtn.layer.cornerRadius = 10;
    [dataBtn setImage:[UIImage imageNamed:@"data_icon"] forState:UIControlStateNormal];
    [cardView addSubview:dataBtn];
    [dataBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@62);
        make.left.equalTo(@54);
        make.right.equalTo(@-54);
    }];
    
    UIButton *faceBtn = [UIButton new];
    faceBtn.backgroundColor = RGB(241, 240, 240);
    faceBtn.layer.cornerRadius = 10;
    [faceBtn setImage:[UIImage imageNamed:@"facedata_icon"] forState:UIControlStateNormal];
    [cardView addSubview:faceBtn];
    [faceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@54);
        make.right.equalTo(@-54);
        make.top.equalTo(dataBtn.mas_bottom).offset(48);
    }];
    
    UIButton *uploadBtn = [UIButton new];
    uploadBtn.layer.cornerRadius = 16;
    uploadBtn.backgroundColor = RGB(129, 209, 50);
    uploadBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [uploadBtn setTitle:@"数据上传" forState:UIControlStateNormal];
    [uploadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cardView addSubview:uploadBtn];
    [uploadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@-33);
        make.left.equalTo(@59);
        make.right.equalTo(@-59);
        make.height.equalTo(@33);
    }];
}

@end
