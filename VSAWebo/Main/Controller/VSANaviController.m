//
//  VSANaviController.m
//  VSAWebo
//
//  Created by alvin on 15/8/10.
//  Copyright (c) 2015年 alvin. All rights reserved.
//

#import "VSANaviController.h"
#import "UIView+Extension.h"

@interface VSANaviController () <UIActionSheetDelegate>

@end

@implementation VSANaviController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        [self setNaviBarItemsWithVC:viewController];
    }
    [super pushViewController:viewController animated:animated];
}

- (void)setNaviBarItemsWithVC:(UIViewController *)viewController {
    viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(backClick) image:@"navigationbar_back" highlightImage:@"navigationbar_back_highlighted"];

    viewController.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(moreClick:) image:@"navigationbar_more" highlightImage:@"navigationbar_more_highlighted"];
}

//- (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highlightImage:(NSString *)highlightImage {
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
//    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
//    [btn setBackgroundImage:[UIImage imageNamed:highlightImage] forState:UIControlStateHighlighted];
//    btn.size = btn.currentBackgroundImage.size;
//    
//    return [[UIBarButtonItem alloc] initWithCustomView:btn];
//}

- (void)backClick {
    [self popViewControllerAnimated:YES];
}

- (void)moreClick:(id)sender {
    //回到主页面
//    [self popToRootViewControllerAnimated:YES];
    
    //显示菜单，UIActionSheet
    UIActionSheet *actionSheet;
    actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"刷新", @"用手机浏览器打开", @"返回首页", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showFromRect:[(UIButton *)sender frame]  inView:self.view animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
            break;
        case 2:
            [self popToRootViewControllerAnimated:YES];
            break;
        case 3:
            break;
            
        default:
            break;
    }
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
