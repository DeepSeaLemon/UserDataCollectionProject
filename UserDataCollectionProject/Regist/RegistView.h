//
//  RegistView.h
//  UserDataCollectionProject
//
//  Created by kys-24 on 2019/3/4.
//  Copyright © 2019 kys-24. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^RegistViewBlock)(NSString *str);
typedef void (^RegistDataBlock)(NSDictionary *dict);

@interface RegistView : UIView

@property (nonatomic,copy)RegistViewBlock btnBlock;
@property (nonatomic,copy)RegistDataBlock dataBlock;

@end

NS_ASSUME_NONNULL_END
