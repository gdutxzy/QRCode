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



@interface QRCodeGeneratorViewController ()
@property (weak, nonatomic) IBOutlet UITextField *targetStringTextField;
@property (weak, nonatomic) IBOutlet UITextField *pointColorTextField;
@property (weak, nonatomic) IBOutlet UITextField *bgColorTextField;
@property (weak, nonatomic) IBOutlet UIImageView *QRCodeImageView;

@end

@implementation QRCodeGeneratorViewController
- (IBAction)saveAlbum:(UIButton *)sender {
    UIImageWriteToSavedPhotosAlbum(self.QRCodeImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
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
    image = [QRCodeImageGenerator CIImage:image ConvertPointColor:pointColor backgroudColor:bgcolor];
    self.QRCodeImageView.image = [QRCodeImageGenerator UIImageFromCIImage:image withSize:self.QRCodeImageView.bounds.size];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
