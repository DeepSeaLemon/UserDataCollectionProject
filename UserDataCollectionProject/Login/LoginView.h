//
//  LoginView.h
//  UserDataCollectionProject
//
//  Created by kys-24 on 2019/3/4.
//  Copyright © 2019 kys-24. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^LoginViewBlock) (NSString *str);

typedef void (^LoginDataBlock) (NSDictionary *dict);

@interface LoginView : UIView

@property (nonatomic,copy)LoginViewBlock btnBlock;

@property (nonatomic,copy)LoginDataBlock dataBlock;

@end

NS_ASSUME_NONNULL_END
