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
+ (NSString *)convertToTextWithImage:(UIImage *)image;
@end
