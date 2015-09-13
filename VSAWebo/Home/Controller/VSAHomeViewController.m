//
//  VSAHomeViewController.m
//  VSAWebo
//
//  Created by alvin on 15/8/9.
//  Copyright (c) 2015年 alvin. All rights reserved.
//

#import "VSAHomeViewController.h"
#import "VSADropdownMenu.h"
#import "VSADropdownContentController.h"
#import "AFNetworking.h"
#import "VSAAccountTool.h"
#import "UIImageView+WebCache.h"
#import "VSAStatus.h"
#import "VSAUser.h"
#import "VSAStatusFrame.h"
#import "VSAStatusCell.h"

@interface VSAHomeViewController () <VSADropdownMenuDelegate>
@property (nonatomic, strong) UIImageView *dropDownView;
@property (nonatomic, strong) UIButton *titleButton;
//@property (nonatomic, strong) NSArray *statuses;
/**
 *  微博数组，VSAStatus数组
 */
@property (nonatomic, strong) NSMutableArray *statuses;
@property (nonatomic, strong) NSMutableArray *statusFrames;
@end

@implementation VSAHomeViewController

- (NSMutableArray *)statuses {
    if (!_statuses) {
        self.statuses = [NSMutableArray array];
    }
    return _statuses;
}

- (NSMutableArray *)statusFramesWithStatuses: (NSMutableArray *)statuses {
    NSMutableArray *models = [NSMutableArray array];
    for (VSAStatus *status in statuses) {
        VSAStatusFrame *statusFrame = [[VSAStatusFrame alloc] init];
        statusFrame.status = status;
        [models addObject:statusFrame];
    }
    
    return models;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*设置左右barButtonItem */
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(leftButtonClick) image:@"navigationbar_friendsearch" highlightImage:@"navigationbar_friendsearch_highlighted"];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(rightButtonClick) image:@"navigationbar_pop" highlightImage:@"navigationbar_pop_highlighted"];
    
    /*创建可点击的titleView*/
    UIButton *titleButton = [[UIButton alloc] init];
    titleButton.width = 150;
    titleButton.height = 30;
    
    //设置title， 图片
    [titleButton setTitle:@"主页" forState:UIControlStateNormal];
    [titleButton setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
    [titleButton setImage:[UIImage imageNamed:@"navigationbar_arrow_up"] forState:UIControlStateSelected];
    [titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [titleButton setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    titleButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
    titleButton.imageEdgeInsets = UIEdgeInsetsMake(0, 80, 0, 0);
    [titleButton addTarget:self action:@selector(titleButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.titleView = titleButton;
    self.titleButton = titleButton;
    
    //加载微博数据
//    [self loadStatuses];
    
    //添加刷新控件
    [self setRefresh];
    
    //获取未读微博数
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(setUnreadCount) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)setUnreadCount {
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    //请求参数
    VSAAccount *account = [VSAAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    params[@"uid"] = account.uid;
    
    //发送请求
    [mgr GET:@"https://rm.api.weibo.com/2/remind/unread_count.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //拿到返回的未读微博数，返回的是NSNumber, 这里使用description转成NSString
        NSString *status = [responseObject[@"status"] description];
        if ([status isEqualToString:@"0"]) {
            self.tabBarItem.badgeValue = nil;
            //设置桌面图标的右上角标
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        } else {
            self.tabBarItem.badgeValue = status;
            [UIApplication sharedApplication].applicationIconBadgeNumber = status.intValue;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败--%@", error);
    }];
}

- (void)setRefresh {
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshStateChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:refreshControl];
    
    //进来就刷新
    [refreshControl beginRefreshing];
    [self refreshStateChange:refreshControl];
}

- (void)refreshStateChange: (UIRefreshControl *)control {
    NSLog(@"refresh state value changed");
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    VSAAccount *account = [VSAAccountTool account];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    
    VSAStatus *latestStatus = [self.statuses firstObject];
    if (latestStatus) {
        params[@"since_id"] = latestStatus.idstr;
    }
    
    [mgr GET:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"获取微博成功 %@", responseObject);
        //先获取字典数组
        NSArray *dictArray = (NSArray *)responseObject[@"statuses"];
        /**
        NSMutableArray *newStatuses = [NSMutableArray array];
        //将字典数组转换成VSAStatus模型
        for (NSDictionary *dict in dictArray) {
            VSAStatus *status = [VSAStatus statusWithDict:dict];
            [newStatuses addObject:status];
        }
         */
        NSArray *newStatuses = [VSAStatus objectArrayWithKeyValuesArray:dictArray];
        
        //将新数据添加到数组
        NSRange range = NSMakeRange(0, newStatuses.count);
        NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndexesInRange:range];
        [self.statuses insertObjects:newStatuses atIndexes:indexSet];
        
        //转化成VSAStatusFrame数组
        self.statusFrames = [self statusFramesWithStatuses:self.statuses];
        
        //加载结束后，重新加载到tableView的cell中显示
        [self.tableView reloadData];
        
        //结束刷新
        [control endRefreshing];
        
        //显示更新了多少条微博
        [self showUpdatedState: newStatuses.count];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"获取微博失败 %@", error);
        [control endRefreshing];
    }];
}

- (void)loadStatuses {
    //api: https://api.weibo.com/2/statuses/friends_timeline.json
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    VSAAccount *account = [VSAAccountTool account];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
//    params[@"count"] = @10;
    
    [mgr GET:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"获取微博成功 %@", responseObject);
        //先获取字典数组
        NSArray *dictArray = (NSArray *)responseObject[@"statuses"];
        /*
        //将字典数组转换成VSAStatus模型
        for (NSDictionary *dict in dictArray) {
            VSAStatus *status = [VSAStatus statusWithDict:dict];
            [self.statuses addObject:status];
        }
         */
        NSLog(@"%@", dictArray);
        self.statuses = [VSAStatus objectArrayWithKeyValuesArray:dictArray];
        
        self.statusFrames = [self statusFramesWithStatuses:self.statuses];
        
        //加载结束后，重新加载到tableView的cell中显示
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"获取微博失败 %@", error);
    }];
}

- (void)showUpdatedState: (CGFloat)count {
    //将tabBarItem显示的数字清空
    self.tabBarItem.badgeValue = nil;
    //1. 创建一个label用来显示提示信息
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timeline_new_status_background"]];
    label.width = [UIScreen mainScreen].bounds.size.width;
    label.height = 45;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    
    if (count) {
        label.text = [NSString stringWithFormat:@"更新了%d条数据", (int)count];
    } else {
        label.text = [NSString stringWithFormat:@"没有新数据，稍后再试"];
    }
    
    //2. 设置初始位置
    label.y = 64 - label.height;
    [self.navigationController.view insertSubview:label belowSubview:self.navigationController.navigationBar];
    
    //3. 设置动画，用1秒时间向下移动label.height的距离，显示出来
    CGFloat interval = 1.0;
    [UIView animateWithDuration:interval animations:^{
        label.transform = CGAffineTransformMakeTranslation(0, label.height);
    } completion:^(BOOL finished) {
        //停1秒，让用户看清楚
        [NSThread sleepForTimeInterval:1.0];
        //再使用1秒的时间，回到初始位置
        CGFloat delay = 1.0;
        [UIView animateWithDuration:interval delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
            label.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [label removeFromSuperview];
        }];
    }];
}

- (void)titleButtonClick {
    NSLog(@"title Button click");
    
    //创建dropdownMenu
    VSADropdownMenu *menu = [VSADropdownMenu dropdownMenu];
    menu.delegate = self;
    
    VSADropdownContentController *dropdownContentVC = [[VSADropdownContentController alloc] init];
    //注意顺序，要先设置宽高，在设置contentVC
    dropdownContentVC.view.width = 170;
    dropdownContentVC.view.height = 180;
    menu.contentVC = dropdownContentVC;
//    menu.contentVC.view.width = 170;
//    menu.contentVC.view.height = 180;
    
    [menu showFrom:self.titleButton];
    
/*
    // 这样获得的窗口，是目前显示在屏幕最上面的窗口
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    
    //添加一个cover, 用来获取点击事件
    UIButton *cover = [[UIButton alloc] init];
    cover.frame = window.bounds;
    cover.backgroundColor = [UIColor greenColor];
    [cover addTarget:self action:@selector(coverClick:) forControlEvents:UIControlEventTouchUpInside];
    [window addSubview:cover];
    
    //添加dropDown view
    UIImageView *dropView = [[UIImageView alloc] init];
    dropView.width = 217;
    dropView.height = 200;
    dropView.x = (window.bounds.size.width - dropView.width) / 2;
    dropView.y = 40;
    dropView.image = [UIImage imageNamed:@"popover_background"];
//    dropView.contentMode = UIViewContentModeCenter;
    self.dropDownView = dropView;
    [window addSubview:dropView];
 */
}

- (void)coverClick:(UIButton *)sender {
    [sender removeFromSuperview];
//    [self.dropDownView removeFromSuperview];
}

- (void)leftButtonClick {
    NSLog(@"home left button click");
}

- (void)rightButtonClick {
    NSLog(@"home right button click");
}

#pragma mark - VSADropdownMenuDelegate

- (void)dropdownMenuDidDismiss:(VSADropdownMenu *)dropdownMenu {
    self.titleButton.selected = NO;
}

- (void)dropdownMenuDidShow:(VSADropdownMenu *)dropdownMenu {
    self.titleButton.selected = YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.statusFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
    //这使用了static，还有reusableCell
    static NSString *identifier = @"status";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    //对应要显示的那条微博
    VSAStatus *status = self.statuses[indexPath.row];
    //使用模型，不用字典取值
    cell.textLabel.text = status.user.name;
    cell.detailTextLabel.text = status.text;
    
    //返回的数据中有三种图片，这里使用缩略图， 使用了SDWebImage第三方库
    NSString *imageUrl = status.user.profile_image_url;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"avatar_default_small"]];
    */
    
    VSAStatusCell *cell = [VSAStatusCell cellWithTableView:tableView];
    cell.statusFrame = self.statusFrames[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    VSAStatusFrame *statusFrame =  self.statusFrames[indexPath.row];
    return statusFrame.cellHeight;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
