//
//  ViewController.m
//  QRCode
//
//  Created by XZY on 2018/7/18.
//  Copyright © 2018年 xiezongyuan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)unwindSegue:(UIStoryboardSegue *)sender{
    NSLog(@"unwindSegue %@", sender);
}




@end
