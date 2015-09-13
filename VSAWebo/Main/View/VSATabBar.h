//
//  VSATabBar.h
//  VSAWebo
//
//  Created by alvin on 15/8/13.
//  Copyright (c) 2015年 alvin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VSATabBar;

@protocol VSATabBarDelegate <UITabBarDelegate>

@optional
-(void)tabBarDidClickPlusButton:(UITabBar *)tabBar;

@end

@interface VSATabBar : UITabBar
@property (nonatomic, assign) id<VSATabBarDelegate> delegate;
@end
