//
//  VSATest2ViewController.m
//  VSAWebo
//
//  Created by alvin on 15/8/10.
//  Copyright (c) 2015年 alvin. All rights reserved.
//

#import "VSATest2ViewController.h"

@interface VSATest2ViewController ()

@end

@implementation VSATest2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //在navigationController重写的push方法里面设置的rightBarButtonItem,是先执行的，下面这一句时候执行的，可以把之前的覆盖。显示任意内容。
    self.navigationItem.rightBarButtonItem = nil;
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
