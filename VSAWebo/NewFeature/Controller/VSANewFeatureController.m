//
//  VSANewFeatureController.m
//  VSAWebo
//
//  Created by alvin on 15/8/15.
//  Copyright (c) 2015年 alvin. All rights reserved.
//

#import "VSANewFeatureController.h"
#import "VSAMainController.h"
#define VSAImageCount 4

@interface VSANewFeatureController () <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIImageView *lastPage;
@property (nonatomic, strong) UIButton *openButton;
@end

@implementation VSANewFeatureController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加ScrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    
    scrollView.frame = self.view.frame;
    scrollView.contentSize = CGSizeMake(VSAImageCount * scrollView.width, 0);
    self.scrollView = scrollView;
    scrollView.bounces = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];

    
    //添加图片
    CGFloat imageW = self.scrollView.width;
    CGFloat imageH = self.scrollView.height;
    for (int i = 0; i < VSAImageCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        NSString *imageName = [NSString stringWithFormat:@"new_feature_%d", i + 1];
        imageView.image = [UIImage imageNamed:imageName];
        imageView.width = imageW;
        imageView.height = imageH;
        imageView.y = 0;
        imageView.x = i * imageW;
        [self.scrollView addSubview:imageView];
        
        //设置最后一张图片中的按钮
        if (i == 3) {
            imageView.userInteractionEnabled = YES;
            
            UIButton *openButton = [[UIButton alloc] init];
            [openButton setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button"] forState:UIControlStateNormal];
            [openButton setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button_highlighted"] forState:UIControlStateHighlighted];
            [openButton setTitle:@"开启微博" forState:UIControlStateNormal];
            //            openButton.centerX = imageView.width * 0.5;
            openButton.size = openButton.currentBackgroundImage.size;
            openButton.x = (imageView.width - openButton.width) * 0.5;
//            [openButton setCenter:CGPointMake(50, imageView.height - 150)];
            openButton.centerY = imageView.height - 150;
            CGPoint point = openButton.center;
            CGRect rect = openButton.frame;
            openButton.backgroundColor = [UIColor redColor];
            [imageView addSubview:openButton];
            [openButton addTarget:self action:@selector(openClick) forControlEvents:UIControlEventTouchUpInside];
            self.openButton = openButton;
        }
    }
    
    //添加PageControl
    UIPageControl *pageControl = [UIPageControl new];
    pageControl.numberOfPages = VSAImageCount;
    pageControl.currentPageIndicatorTintColor = VSAColor(235, 45, 23);
    pageControl.pageIndicatorTintColor = VSAColor(180, 180, 180);
    pageControl.centerX = self.scrollView.width * 0.5;
    pageControl.centerY = self.scrollView.height - 50;
    [self.view addSubview:pageControl];
    self.pageControl = pageControl;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)openClick {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    VSAMainController *mainVC = [[VSAMainController alloc] init];
    [window setRootViewController:mainVC];
}

#pragma mark - UISCrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    double offSetX = self.scrollView.contentOffset.x / self.scrollView.width;
    
    int currentPage = (int)(offSetX + 0.5);
    self.pageControl.currentPage = currentPage;
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
