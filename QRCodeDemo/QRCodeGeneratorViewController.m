//
//  QRCodeGeneratorViewController.m
//  QRCodeDemo
//
//  Created by XZY on 2018/7/19.
//  Copyright © 2018年 xiezongyuan. All rights reserved.
//

#import "QRCodeGeneratorViewController.h"
#import "QRCodeImageGenerator.h"
#import "QRCodeShortcutFuntion.h"
#import "QRCodePermissions.h"


@interface QRCodeGeneratorViewController ()
@property (weak, nonatomic) IBOutlet UITextField *targetStringTextField;
@property (weak, nonatomic) IBOutlet UITextField *pointColorTextField;
@property (weak, nonatomic) IBOutlet UITextField *bgColorTextField;
@property (weak, nonatomic) IBOutlet UIImageView *QRCodeImageView;

@end

@implementation QRCodeGeneratorViewController
- (IBAction)saveAlbum:(UIButton *)sender {
    if ([QRCodePermissions allowAlbum]) {
            UIImageWriteToSavedPhotosAlbum(self.QRCodeImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }else{
        
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"保存图片至相册需要相册授权" preferredStyle:UIAlertControllerStyleAlert];
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
    }

}
//保存图片备用
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    NSLog(@"%@",msg);
}

- (void)textFieldDidChange:(UITextField *)textfield{
    [self showQRCodeImage];
}

- (void)showQRCodeImage{
    CIImage * image  = [QRCodeImageGenerator QRCodeImageWithString:self.targetStringTextField.text];
    UIColor * pointColor = nil;
    UIColor * bgcolor = nil;
    if (self.pointColorTextField.text.length == 0) {
        pointColor = [UIColor blackColor];
    }else{
        pointColor = UIColorWithStr(self.pointColorTextField.text);
    }
    if (self.bgColorTextField.text.length != 0) {
        bgcolor = UIColorWithStr(self.bgColorTextField.text);
    }
    image = [QRCodeImageGenerator image:image ConvertPointColor:pointColor backgroudColor:bgcolor];
    self.QRCodeImageView.image = [QRCodeImageGenerator imageFromCIImage:image withSize:self.QRCodeImageView.bounds.size];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.targetStringTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.pointColorTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.bgColorTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
