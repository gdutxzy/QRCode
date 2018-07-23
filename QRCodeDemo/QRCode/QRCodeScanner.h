//
//  QRCodeScanner.h
//  QRCodeDemo
//
//  Created by XZY on 2018/7/23.
//  Copyright © 2018年 xiezongyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QRCodeScanner : NSObject
/**
 读取二维码图片的内容
 @param image 二维码图片
 @return 结果
 */
+ (NSString *)stringFromQRCodeImage:(UIImage *)image;



/**
 生成摄像头扫描器
 @param view 显示摄像头内容的视图
 @param scanFrame 扫描范围
 @param completion 扫描结果
 @return 扫描器
 */
+ (instancetype)scanerWithView:(UIView *)view scanFrame:(CGRect)scanFrame completion:(void (^)(NSString *stringValue))completion;
/// 开始扫描
- (void)startScan;
/// 停止扫描
- (void)stopScan;

/**
 光感回调
 status
 */
@property (nonatomic, copy) void (^switchTorchStateBlock) (BOOL status, BOOL action);

@end
