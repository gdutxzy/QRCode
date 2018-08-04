//
//  QRCodePermissions.m
//  QRCodeDemo
//
//  Created by XZY on 2018/7/23.
//  Copyright © 2018年 xiezongyuan. All rights reserved.
//

#import "QRCodePermissions.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

@implementation QRCodePermissions
/// 允许使用摄像头
+ (BOOL)allowCamera{
    BOOL isCameraValid = YES;
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        
    }];
    //ios7之前系统默认拥有权限
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted) {
            isCameraValid = NO;
        }
    }
    return isCameraValid;
}
/// 允许使用相册
+ (BOOL)allowAlbum{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        if ( author == ALAuthorizationStatusDenied || author == ALAuthorizationStatusRestricted ) {
            return NO;
        }
        return YES;
    }
    PHAuthorizationStatus authorStatus = [PHPhotoLibrary authorizationStatus];
    if ( authorStatus == PHAuthorizationStatusDenied || authorStatus == PHAuthorizationStatusRestricted ) {
        return NO;
    }
    return YES;
}
@end
