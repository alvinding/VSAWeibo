//
//  AppDelegate.m
//  VSAWebo
//
//  Created by alvin on 15/8/9.
//  Copyright (c) 2015年 alvin. All rights reserved.
//

#import "AppDelegate.h"
#import "VSAMainController.h"
#import "VSANewFeatureController.h"
#import "VSAOAuthController.h"
#import "VSAAccount.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //设置UIWindow
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    
    //根据userDefaults存储的version设置rootVC
    NSString *versionKey = @"CFBundleVersion";
    NSString *formerVersion = [[NSUserDefaults standardUserDefaults] valueForKey:versionKey];
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] valueForKey:versionKey];

    //测试程序在虚拟机上的路径
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//    NSString *cachesDirectory = [paths lastObject];

    //拿到Documents路径
    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *accountPath = [documents stringByAppendingPathComponent:@"account.archive"];
    VSAAccount *account = [NSKeyedUnarchiver unarchiveObjectWithFile:accountPath];
    
    if (account) {
        //如果formerVersion储存的和当前info.plist里的不同，就显示new feature;
        if ([formerVersion isEqualToString:currentVersion]) {
            VSAMainController *mainVC = [[VSAMainController alloc] init];
            [self.window setRootViewController:mainVC];
//            VSANewFeatureController *newFeatureVC = [[VSANewFeatureController alloc] init];
//            [self.window setRootViewController:newFeatureVC];
        } else {
            VSANewFeatureController *newFeatureVC = [[VSANewFeatureController alloc] init];
            [self.window setRootViewController:newFeatureVC];
        }
        
        //将currentVersion 保存到userDefaults当中
        [[NSUserDefaults standardUserDefaults] setValue:currentVersion forKey:versionKey];
        [[NSUserDefaults standardUserDefaults] synchronize];

    } else {
        //测试OAuth页面
        VSAOAuthController *authVC = [[VSAOAuthController alloc] init];
        [self.window setRootViewController:authVC];
    }
    
    
 
    //显示窗口
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
