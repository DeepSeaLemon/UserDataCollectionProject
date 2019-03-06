//
//  CustomKeyboardView.m
//  自定义键盘
//
//  Created by kys-24 on 2019/2/25.
//  Copyright © 2019 kys-24. All rights reserved.
//
#define SCREEN_RECT ([UIScreen mainScreen].bounds)
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#import <CoreMotion/CoreMotion.h>
#import "Masonry.h"
#import "CustomKeyboardView.h"

@implementation CustomKeyboardView
{
    NSMutableArray *signClickTimeArray; // 单个按钮的点击事件，顺序为：按下、松开x6组，共12个数据
    CMMotionManager *mgr;
    UIButton *btn;
}
- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH,(SCREEN_WIDTH-20)*3/4)];
    if (self) {
        self.backgroundColor = UIColor.lightGrayColor;
        mgr = [[CMMotionManager alloc]init];
        // 初始化变量
        signClickTimeArray = [NSMutableArray arrayWithCapacity:12];
        // 计算宽高
        CGFloat BTN_WIDTH = (SCREEN_WIDTH-20)/3;
        CGFloat BTN_HEIGHT = (SCREEN_WIDTH-20)*9/64;
        CGFloat BLANK_HEIGHT = self.frame.size.height - BTN_HEIGHT*4 - 25;
        // 标题（提示语）
        UILabel *titleLab = [UILabel new];
        titleLab.frame = CGRectMake( 0, 0, SCREEN_WIDTH, BLANK_HEIGHT-5);
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.text = @"自定义数据采集键盘";
        titleLab.textColor = [UIColor whiteColor];
        [self addSubview:titleLab];
        // 分割线
        UILabel *lineLab = [UILabel new];
        lineLab.frame = CGRectMake(0, BLANK_HEIGHT-4, SCREEN_WIDTH, 1);
        lineLab.backgroundColor = [UIColor whiteColor];
        [self addSubview:lineLab];
        // 设置按钮标题数组
        NSArray *titles = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"删除",@"0",@"确定"];
        //添加数字按钮
        for (NSInteger index = 0; index < 12; ++index) {
            CGFloat BTN_X = 5*((index % 3)+1)+BTN_WIDTH*(index % 3);
            CGFloat BTN_Y = BLANK_HEIGHT+5*((index/3)+1)+BTN_HEIGHT*(index/3);
            btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(BTN_X, BTN_Y, BTN_WIDTH, BTN_HEIGHT);
            // 松开按钮
            [btn addTarget:self action:@selector(buttonTouchUp:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
            // 按下按钮
            [btn addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
            [btn setTitle:titles[index] forState:UIControlStateNormal];
            [btn setBackgroundImage:[self imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateHighlighted];
            [btn setBackgroundImage:[self imageWithColor:[UIColor grayColor]] forState:UIControlStateNormal];
            btn.layer.cornerRadius = 10.0;
            btn.layer.masksToBounds = YES;
            [self addSubview:btn];
        }
    }
    return self;
}
//  颜色转换为背景图片
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
- (void)buttonTouchDown:(UIButton *) sender{
    if (self.delegate) {
        [self.delegate keyboardItemDidClicked:sender.titleLabel.text];
        if (signClickTimeArray.count<12 && sender.titleLabel.text.length<2) {
            // NSLog(@"按下时间戳：%@",[self getNowTimeTimestamp]);
            [signClickTimeArray addObject: [self getNowTimeTimestamp]];
            [self getAccelerometerData];
            CGRect frame = [sender convertRect:sender.bounds toView:self];
            NSLog(@"%f,%f",frame.origin.x,frame.origin.y);
        }
    }
}
- (void)buttonTouchUp:(UIButton *)sender{
    if (signClickTimeArray.count<12 && sender.titleLabel.text.length<2) {
        // NSLog(@"松开时间戳：%@",[self getNowTimeTimestamp]);
        [signClickTimeArray addObject: [self getNowTimeTimestamp]];
    }
    if ([sender.titleLabel.text isEqualToString:@"确定"]) {
        // 确定事件
        if (signClickTimeArray.count == 12 && self.delegate) {
            [self.delegate getSignClickTime: signClickTimeArray];
            [mgr stopDeviceMotionUpdates];
            [mgr stopAccelerometerUpdates];
        }
    }
    if ([sender.titleLabel.text isEqualToString:@"删除"]) {
        // 删除事件
        [signClickTimeArray removeLastObject];
        [signClickTimeArray removeLastObject];
    }
}
- (void)getAccelerometerData{
    if (!mgr.isAccelerometerAvailable) {
        NSLog(@"加速计不可用");
        return;
    }else{
        // 开始采样
        [mgr startAccelerometerUpdates];
        CMAcceleration acceleration = mgr.accelerometerData.acceleration;
        NSLog(@"加速计信息：x:%f y:%f z:%f", acceleration.x, acceleration.y, acceleration.z);
    }
    if (!mgr.isDeviceMotionAvailable) {
        NSLog(@"陀螺仪不可用");
        return;
    }else{
        [mgr startDeviceMotionUpdates];
        CMRotationRate rotationRate = mgr.deviceMotion.rotationRate;
        NSLog(@"陀螺仪信息-旋转速度：x:%f y:%f z:%f", rotationRate.x, rotationRate.y, rotationRate.z);
        double gravityX = mgr.deviceMotion.gravity.x;
        double gravityY = mgr.deviceMotion.gravity.y;
        double gravityZ = mgr.deviceMotion.gravity.z;
        //获取手机的倾斜角度：
        double zTheta = atan2(gravityZ,sqrtf(gravityX*gravityX+gravityY*gravityY))/M_PI*180.0;
        double xyTheta = atan2(gravityX,gravityY)/M_PI*180.0;
        NSLog(@"手机与水平面的夹角:%f，手机绕自身旋转的角度:%f",zTheta,xyTheta);
    }
}
- (void)layoutSubviews{
    [super layoutSubviews];
}
//获取当前时间戳  （以微秒μs为单位）
- (NSNumber *)getNowTimeTimestamp{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss:SSS"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate *datenow = [NSDate date];//现在时间
    NSTimeInterval interval = [datenow timeIntervalSince1970];
    long long totalMilliseconds = interval*1000*1000 ;
    NSNumber *num = [NSNumber numberWithLongLong:totalMilliseconds];
    return num;
}

@end
