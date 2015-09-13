//
//  VSATest1ViewController.m
//  VSAWebo
//
//  Created by alvin on 15/8/10.
//  Copyright (c) 2015年 alvin. All rights reserved.
//

#import "VSATest1ViewController.h"
#import "VSATest2ViewController.h"

@interface VSATest1ViewController ()

@end

@implementation VSATest1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    VSATest2ViewController *test2VC = [[VSATest2ViewController alloc] init];
    [self.navigationController pushViewController:test2VC animated:YES];
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
