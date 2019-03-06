//
//  ShowTermsViewController.m
//  UserDataCollectionProject
//
//  Created by kys-24 on 2019/3/4.
//  Copyright © 2019 kys-24. All rights reserved.
//

#import "ShowTermsViewController.h"

@interface ShowTermsViewController ()

@end

@implementation ShowTermsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *lab = [UILabel new];
    lab.frame = CGRectMake(50, 200, 200, 50);
    lab.text = @"这里显示条款";
    [self.view addSubview:lab];
    
    UIButton *btn = [UIButton new];
    btn.frame = CGRectMake(0, 100, 50, 50);
    btn.backgroundColor = [UIColor cyanColor];
    [btn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
- (void)back:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
