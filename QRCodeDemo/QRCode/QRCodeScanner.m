//
//  QRCodeScanner.m
//  QRCodeDemo
//
//  Created by XZY on 2018/7/23.
//  Copyright © 2018年 xiezongyuan. All rights reserved.
//

#import "QRCodeScanner.h"
#import <AVFoundation/AVFoundation.h>



/// 最大检测次数
#define kMaxDetectedCount   5

@interface QRCodeScanner ()<AVCaptureMetadataOutputObjectsDelegate, AVCaptureVideoDataOutputSampleBufferDelegate>
/// 父视图
@property (weak, nonatomic) UIView *parentView;
/// 扫描范围
@property (assign, nonatomic) CGRect scanFrame;
/// 完成回调
@property (copy, nonatomic) void (^completionCallBack)(NSString *);


@property (strong, nonatomic) AVCaptureStillImageOutput *stillImageOutput;//拍照

@property (strong, nonatomic) AVCaptureDeviceInput *videoInput;


/// 拍摄会话
@property (strong, nonatomic) AVCaptureSession *session;
/// 预览图层
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;
/// 绘制图层
@property (strong, nonatomic) CALayer *drawLayer;
/// 当前检测计数
@property (assign, nonatomic) NSInteger currentDetectedCount;

@property (assign, nonatomic) float lastBrightnessValue;
@end

@implementation QRCodeScanner
+ (NSString *)stringFromQRCodeImage:(UIImage *)image{
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy: CIDetectorAccuracyHigh}];
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    NSArray *features = [detector featuresInImage:ciImage];
    NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:features.count];
    for (CIQRCodeFeature *feature in features) {
        [arrayM addObject:feature.messageString];
    }
    return arrayM.lastObject;
}



+(instancetype)scanerWithView:(UIView *)view scanFrame:(CGRect)scanFrame completion:(void (^)(NSString *))completion{
    QRCodeScanner * scanner = [[QRCodeScanner alloc] init];
    if (scanner) {
        scanner.parentView = view;
        scanner.scanFrame = scanFrame;
        scanner.completionCallBack = completion;
        
        [scanner setupSession];
    }
    return scanner;
}
/// 设置扫描会话
- (void)setupSession {
    
    // 1> 输入设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    self.videoInput = videoInput;
    
    if (videoInput == nil) {
        NSLog(@"创建输入设备失败");
        return;
    }
    
    // 2> 数据输出
    AVCaptureMetadataOutput *dataOutput = [[AVCaptureMetadataOutput alloc] init];
    
    //设置光感代理输出
    AVCaptureVideoDataOutput *respondOutput = [[AVCaptureVideoDataOutput alloc] init];
    [respondOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    
    // 3> 拍摄会话 - 判断能够添加设备
    self.session = [[AVCaptureSession alloc] init];
    if (![self.session canAddInput:videoInput]) {
        NSLog(@"无法添加输入设备");
        self.session = nil;
        return;
    }
    if (![self.session canAddOutput:dataOutput]) {
        NSLog(@"无法添加输入设备");
        self.session = nil;
        return;
    }
    //高质量采集率
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    
    AVCaptureStillImageOutput *stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    AVVideoCodecJPEG, AVVideoCodecKey,
                                    nil];
    [stillImageOutput setOutputSettings:outputSettings];
    self.stillImageOutput = stillImageOutput;
    // 控制 扫描结果
    // 4> 添加输入／输出设备
    if ([self.session canAddInput:videoInput]) [self.session addInput:videoInput];
    if ([self.session canAddOutput:dataOutput]) [self.session addOutput:dataOutput];
    if ([self.session canAddOutput:respondOutput]) [self.session addOutput:respondOutput];
    if ([self.session canAddOutput:_stillImageOutput]) [self.session addOutput:_stillImageOutput];
    
    // 5> 设置扫描类型
    dataOutput.metadataObjectTypes = dataOutput.availableMetadataObjectTypes;
    [dataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //@[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    // 6> 设置预览图层会话
    [self setupLayers];
}

/// 设置绘制图层和预览图层
- (void)setupLayers {
    
    if (self.parentView == nil) {
        NSLog(@"父视图不存在");
        return;
    }
    
    if (self.session == nil) {
        NSLog(@"拍摄会话不存在");
        return;
    }
    
    // 绘制图层
    self.drawLayer = [CALayer layer];
    
    self.drawLayer.frame = self.parentView.bounds;
    
    [self.parentView.layer insertSublayer:self.drawLayer atIndex:0];
    
    // 预览图层
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.previewLayer.frame = self.parentView.bounds;
    
    [self.parentView.layer insertSublayer:self.previewLayer atIndex:0];
}
/// 绘制条码形状
///
/// @param dataObject 识别到的数据对象
- (void)drawCornersShape:(AVMetadataMachineReadableCodeObject *)dataObject {
    
    if (dataObject.corners.count == 0) {
        return;
    }
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    
    layer.lineWidth = 1.8;
    layer.strokeColor = [UIColor orangeColor].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.path = [self cornersPath:dataObject.corners];
    
    [self.drawLayer addSublayer:layer];
}

/**
 使用 corners 数组生成绘制路径
 @param corners corners 数组
 @return 绘制路径
 */
- (CGPathRef)cornersPath:(NSArray *)corners {
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint point = CGPointZero;
    
    // 1. 移动到第一个点
    NSInteger index = 0;
    CGPointMakeWithDictionaryRepresentation((CFDictionaryRef)corners[index++], &point);
    [path moveToPoint:point];
    
    // 2. 遍历剩余的点
    while (index < corners.count) {
        CGPointMakeWithDictionaryRepresentation((CFDictionaryRef)corners[index++], &point);
        [path addLineToPoint:point];
    }
    
    // 3. 关闭路径
    [path closePath];
    
    return path.CGPath;
}
/// 清空绘制图层
- (void)clearDrawLayer {
    if (self.drawLayer.sublayers.count == 0) {
        return;
    }
    [self.drawLayer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
}


#pragma mark - 光感回调
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    CFDictionaryRef metadataDict = CMCopyDictionaryOfAttachments(NULL,sampleBuffer, kCMAttachmentMode_ShouldPropagate);
    NSDictionary *metadata = [[NSMutableDictionary alloc] initWithDictionary:(__bridge NSDictionary*)metadataDict];
    CFRelease(metadataDict);
    NSDictionary *exifMetadata = [[metadata objectForKey:(NSString *)kCGImagePropertyExifDictionary] mutableCopy];
    // 该值在 -5~12 之间
    float brightnessValue = [[exifMetadata objectForKey:(NSString *)kCGImagePropertyExifBrightnessValue] floatValue];
    if ((_lastBrightnessValue>0 && brightnessValue>0) ||
        (_lastBrightnessValue<=0 && brightnessValue<=0)) {
        return;
    }
    _lastBrightnessValue = brightnessValue;
    
    self.switchTorchStateBlock ? self.switchTorchStateBlock(brightnessValue<=0, YES) : nil;
    
}
#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    [self clearDrawLayer];
    
    for (id obj in metadataObjects) {
        // 判断检测到的对象类型
        if (![obj isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
            return;
        }
        // 转换对象坐标
        AVMetadataMachineReadableCodeObject *dataObject = (AVMetadataMachineReadableCodeObject *)[self.previewLayer transformedMetadataObjectForMetadataObject:obj];
        
        // 判断扫描范围
        if (!CGRectContainsRect(self.scanFrame, dataObject.bounds)) {
            continue;
        }
        
        if (self.currentDetectedCount++ < kMaxDetectedCount) {
            // 绘制边角
            [self drawCornersShape:dataObject];
        } else {
            [self stopScan];
            
            self.switchTorchStateBlock ? self.switchTorchStateBlock(NO, NO) : nil;
            // 完成回调
            if (self.completionCallBack != nil) {
                self.completionCallBack(dataObject.stringValue);
            }
            break;
        }
    }
}


/// 开始扫描
- (void)startScan {
    if ([self.session isRunning]) {
        return;
    }
    self.currentDetectedCount = 0;
    [self.session startRunning];
}

- (void)stopScan {
    if (![self.session isRunning]) {
        return;
    }
    [self.session stopRunning];
}
@end
