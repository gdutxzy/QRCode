//
//  QRCodeShortcutFuntion.h
//  QRCodeDemo
//
//  Created by XZY on 2018/7/19.
//  Copyright © 2018年 xiezongyuan. All rights reserved.
//

#ifndef QRCodeShortcutFuntion_h
#define QRCodeShortcutFuntion_h

CG_INLINE UIColor * UIColorWithStr(NSString *hexColor) {
    if(!hexColor || [hexColor isEqualToString:@""] || [hexColor length] < 7){
        if (hexColor.length != 4) {
            return [UIColor whiteColor];
        }
    }
    
    if (hexColor.length == 4) {
        hexColor = [NSString stringWithFormat:@"#%c%c%c%c%c%c",[hexColor characterAtIndex:1],[hexColor characterAtIndex:1],[hexColor characterAtIndex:2],[hexColor characterAtIndex:2],[hexColor characterAtIndex:3],[hexColor characterAtIndex:3]];
    }
    
    unsigned int red,green,blue;
    NSRange range;
    range.length = 2;
    
    range.location = 1;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
    
    range.location = 3;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
    
    range.location = 5;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green / 255.0f) blue:(float)(blue / 255.0f) alpha:1.0f];
}

#endif /* QRCodeShortcutFuntion_h */
