//
//  QRCodePermissions.h
//  QRCodeDemo
//
//  Created by XZY on 2018/7/23.
//  Copyright © 2018年 xiezongyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QRCodePermissions : NSObject
/// 允许使用摄像头
+ (BOOL)allowCamera;
/// 允许使用相册
+ (BOOL)allowAlbum;
@end
