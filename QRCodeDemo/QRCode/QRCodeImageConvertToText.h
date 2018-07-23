//
//  QRCodeImageConvertToText.h
//  QRCodeDemo
//
//  Created by XZY on 2018/7/19.
//  Copyright © 2018年 xiezongyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QRCodeImageConvertToText : NSObject

/**
读取二维码图片的内容
 @param image 二维码图片
 @return 结果
 */
+ (NSString *)stringFromQRImage:(UIImage *)image;
@end
