//
//  VSAEmotionTabBar.h
//  VSAWebo
//
//  Created by alvin on 15/9/8.
//  Copyright (c) 2015年 alvin. All rights reserved.
//  EmotionKeyboard底部tabBar

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, VSAEmotionTabBarButtonType) {
    VSAEmotionTabBarButtonTypeRecent,
    VSAEmotionTabBarButtonTypeDefault,
    VSAEmotionTabBarButtonTypeEmoji,
    VSAEmotionTabBarButtonTypeLang
};
@class VSAEmotionTabBar;

@protocol VSAEmotionTabBarDelegate <NSObject>

@optional
- (void)tabBarDidClickButton:(VSAEmotionTabBar *)tabBar button:(VSAEmotionTabBarButtonType)type;

@end

@interface VSAEmotionTabBar : UIView
@property (nonatomic, weak) id<VSAEmotionTabBarDelegate> delegate;
@end
