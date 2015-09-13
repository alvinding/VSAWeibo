//
//  VSAOAuthController.m
//  VSAWebo
//
//  Created by alvin on 15/8/17.
//  Copyright (c) 2015年 alvin. All rights reserved.
//

#import "VSAOAuthController.h"
#import "AFNetworking.h"
#import "VSAAccount.h"
#import "VSAMainController.h"
#import "VSANewFeatureController.h"

@interface VSAOAuthController () <UIWebViewDelegate>

@end

@implementation VSAOAuthController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //使用WebView显示授权页面
    UIWebView *webView = [[UIWebView alloc] init];
    webView.frame = self.view.bounds;
    webView.delegate = self;
    [self.view addSubview:webView];
    
    NSURL *url = [NSURL URLWithString:@"https://api.weibo.com/oauth2/authorize?client_id=2469926162&redirect_uri=http://www.baidu.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *url = request.URL.absoluteString;
    
    NSRange range = [url rangeOfString:@"code="];
    if (range.length != 0) {
        int fromIndex = range.location + range.length;
        NSString *code = [url substringFromIndex:fromIndex];
        
        [self accessTokenWithCode:code];
        //返回NO， 不跳转到redirect_uri
        return NO;
    }
    
    return YES;
}

- (void)accessTokenWithCode:(NSString *)code {
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    //serializer手动添加了一个支持的格式
//    mgr.responseSerializer = [AFJSONRequestSerializer serializer];
    
    //拼接参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"client_id"] = @"2469926162";
    params[@"client_secret"] = @"910a46e2e1f4ec4c5f60fc211609d400";
    params[@"grant_type"] = @"authorization_code";
    params[@"redirect_uri"] = @"http://www.baidu.com";
    params[@"code"] = code;
    
    //新浪官方api ： http://open.weibo.com/wiki/Oauth2/access_token
    [mgr POST:@"https://api.weibo.com/oauth2/access_token" parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        NSLog(@"成功 + %@", responseObject);
        //拿到Documents路径
        NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
/**
        NSString *account = [documents stringByAppendingPathComponent:@"account.plist"];
        //直接将返回的dictionary保存到documents路径
        [responseObject writeToFile:account atomically:YES];
   */
        NSString *accountPath = [documents stringByAppendingPathComponent:@"account.archive"];
        //转model
        VSAAccount *account = [VSAAccount accountWithDict:responseObject];
        //使用归档，需要model重写两个方法，遵守NSCoding
        [NSKeyedArchiver archiveRootObject:account toFile:accountPath];
        
        //成功授权，登陆，跳转到weibo页面
        //根据userDefaults存储的version设置rootVC
        NSString *versionKey = @"CFBundleVersion";
        NSString *formerVersion = [[NSUserDefaults standardUserDefaults] valueForKey:versionKey];
        NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] valueForKey:versionKey];
        //如果formerVersion储存的和当前info.plist里的不同，就显示new feature;
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        
        if ([formerVersion isEqualToString:currentVersion]) {
            VSAMainController *mainVC = [[VSAMainController alloc] init];
            [window setRootViewController:mainVC];
        } else {
            VSANewFeatureController *newFeatureVC = [[VSANewFeatureController alloc] init];
            [window setRootViewController:newFeatureVC];
        }
        
        //将currentVersion 保存到userDefaults当中
        [[NSUserDefaults standardUserDefaults] setValue:currentVersion forKey:versionKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"失败 + %@", error);
    }];

           
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
