//
//  QRCodoAlbumViewController.m
//  QRCodeDemo
//
//  Created by XZY on 2018/7/19.
//  Copyright © 2018年 xiezongyuan. All rights reserved.
//

#import "QRCodoAlbumViewController.h"
#import "QRCodeImageConvertToText.h"

@interface QRCodoAlbumViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *qrcodeResult;

@end

@implementation QRCodoAlbumViewController
- (IBAction)openAlbum:(UIButton *)sender {
    UIImagePickerController * vc = [[UIImagePickerController alloc] init];
    vc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSString * result = [QRCodeImageConvertToText stringFromQRImage:image];
    self.qrcodeResult.text = result;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];

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
