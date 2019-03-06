//
//  CustomKeyboardView.h
//  自定义键盘
//
//  Created by kys-24 on 2019/2/25.
//  Copyright © 2019 kys-24. All rights reserved.
//

#import <UIKit/UIKit.h>

// 数据回传代理
@protocol CustomKeyboardDelegate

@required
- (void)keyboardItemDidClicked:(NSString *)item;

@optional
- (void)getSignClickTime:(NSMutableArray *)dataArray;

@end

@interface CustomKeyboardView : UIView

@property(nonatomic, weak) id <CustomKeyboardDelegate> delegate;


@end

