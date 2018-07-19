//
//  QRCodeImageGenerator.h
//  QRCodeDemo
//
//  Created by XZY on 2018/7/18.
//  Copyright © 2018年 xiezongyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QRCodeImageGenerator : NSObject
/// 生成二维码图片
+ (CIImage *)QRCodeImageWithString:(NSString *)string;

/**
 给二维码上色
 @param pointColor 点阵颜色
 @param bgColor 背景颜色
 @return 转换后的CIImage
 */
+ (CIImage *)CIImage:(CIImage *)image ConvertPointColor:(UIColor *)pointColor backgroudColor:(UIColor *)bgColor;


/// 将CIImage转换成指定大小的UIImage
+ (UIImage *)UIImageFromCIImage:(CIImage *)ciimage withSize:(CGSize)size;
@end
