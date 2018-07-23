//
//  QRCodeImageConvertToText.m
//  QRCodeDemo
//
//  Created by XZY on 2018/7/19.
//  Copyright © 2018年 xiezongyuan. All rights reserved.
//

#import "QRCodeImageConvertToText.h"

@implementation QRCodeImageConvertToText
+ (NSString *)stringFromQRImage:(UIImage *)image{
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy: CIDetectorAccuracyHigh}];
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    NSArray *features = [detector featuresInImage:ciImage];
    NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:features.count];
    for (CIQRCodeFeature *feature in features) {
        [arrayM addObject:feature.messageString];
    }
    return arrayM.lastObject;
}
@end
