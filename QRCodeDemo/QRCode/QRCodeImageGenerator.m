//
//  QRCodeImageGenerator.m
//  QRCodeDemo
//
//  Created by XZY on 2018/7/18.
//  Copyright © 2018年 xiezongyuan. All rights reserved.
//

#import "QRCodeImageGenerator.h"
#import <AVFoundation/AVFoundation.h>

@implementation QRCodeImageGenerator
+ (CIImage *)QRCodeImageWithString:(NSString *)string{
    if (string.length == 0) {
        string = @"";
    }
    NSData * stringData = [string dataUsingEncoding:NSUTF8StringEncoding];
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setDefaults];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    return qrFilter.outputImage;
}

+ (CIImage *)image:(CIImage *)image ConvertPointColor:(UIColor *)pointColor backgroudColor:(UIColor *)bgColor{
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"
                                       keysAndValues:
                             @"inputImage",image,
                             @"inputColor0",[CIColor colorWithCGColor:pointColor.CGColor],
                             @"inputColor1",[CIColor colorWithCGColor:bgColor.CGColor],
                             nil];
    return colorFilter.outputImage;
}


+ (UIImage *)imageFromCIImage:(CIImage *)ciimage withSize:(CGSize)size{
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:ciimage fromRect:ciimage.extent];
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //背景内置颜色质量等级
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    //反转画布，翻转一下图片 不然生成的QRCode就是上下颠倒
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    UIImage *codeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRelease(cgImage);
    return codeImage;
}
@end
