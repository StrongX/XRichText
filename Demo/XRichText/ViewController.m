//
//  ViewController.m
//  XRichText
//
//  Created by xlx on 17/2/21.
//  Copyright © 2017年 xlx. All rights reserved.
//

#import "ViewController.h"
#import "outputViewController.h"
#import "inputViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)showInputViewController:(id)sender {
    inputViewController *vc = [inputViewController new];
    [self.navigationController pushViewController:vc animated:true];
}
- (IBAction)showOutputViewController:(id)sender {
    outputViewController *vc = [outputViewController new];
    [self.navigationController pushViewController:vc animated:true];
}


@end
