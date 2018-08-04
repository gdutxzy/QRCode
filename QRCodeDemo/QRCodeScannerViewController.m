//
//  QRCodeScannerViewController.m
//  QRCodeDemo
//
//  Created by XZY on 2018/7/24.
//  Copyright © 2018年 xiezongyuan. All rights reserved.
//

#import "QRCodeScannerViewController.h"
#import "QRCodeScanner.h"
#import "QRCodePermissions.h"

@interface QRCodeScannerViewController ()
@property (strong,nonatomic) QRCodeScanner * scanner;
@property (weak, nonatomic) IBOutlet UIView *scannerView;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end

@implementation QRCodeScannerViewController
- (IBAction)startScanAction:(UIButton *)sender {
    [self.scanner startScan];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (![QRCodePermissions allowCamera]) {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"扫描二维码需要相机授权" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:({
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            action;
        })];
        [alert addAction:({
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }];
            action;
        })];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    [self.scannerView layoutIfNeeded];
    __weak typeof(self) weakself = self;
    self.scanner = [QRCodeScanner scanerWithView:self.scannerView scanFrame:self.scannerView.bounds completion:^(NSString *stringValue) {
        NSLog(@">>>>>>>>QRCode:%@",stringValue);
        self.textLabel.text = stringValue;
        [self.scanner stopScan];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
