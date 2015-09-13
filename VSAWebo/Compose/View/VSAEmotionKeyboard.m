//
//  VSAEmotionKeyboard.m
//  VSAWebo
//
//  Created by alvin on 15/9/8.
//  Copyright (c) 2015年 alvin. All rights reserved.
//

#import "VSAEmotionKeyboard.h"
#import "VSAEmotionCollection.h"
#import "VSAEmotionTabBar.h"
#import "VSAEmotion.h"
#import "MJExtension.h"

@interface VSAEmotionKeyboard () <VSAEmotionTabBarDelegate>
@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, strong) VSAEmotionCollection *recentCollection;
@property (nonatomic, strong) VSAEmotionCollection *defaultCollection;
@property (nonatomic, strong) VSAEmotionCollection *emojiCollection;
@property (nonatomic, strong) VSAEmotionCollection *lxhCollection;
@property (nonatomic, strong) VSAEmotionTabBar *tabBar;
@end

@implementation VSAEmotionKeyboard

#pragma mark - 懒加载
- (VSAEmotionCollection *)recentCollection {
    if (!_recentCollection) {
        self.recentCollection = [[VSAEmotionCollection alloc] init];
//        self.recentCollection.backgroundColor = VSARandomColor;
    }
    
    return _recentCollection;
}

- (VSAEmotionCollection *)defaultCollection {
    if (!_defaultCollection) {
        self.defaultCollection = [[VSAEmotionCollection alloc] init];
//        self.defaultCollection.backgroundColor = VSARandomColor;
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/default/info.plist" ofType:nil];
        self.defaultCollection.emotions = [VSAEmotion objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
    }
    
    return _defaultCollection;
}

- (VSAEmotionCollection *)emojiCollection {
    if (!_emojiCollection) {
        self.emojiCollection = [[VSAEmotionCollection alloc] init];
//        self.emojiCollection.backgroundColor = VSARandomColor;
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/emoji/info.plist" ofType:nil];
        self.emojiCollection.emotions = [VSAEmotion objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
    }
    
    return _emojiCollection;
}

- (VSAEmotionCollection *)lxhCollection {
    if (!_lxhCollection) {
        self.lxhCollection = [[VSAEmotionCollection alloc] init];
//        self.lxhCollection.backgroundColor = VSARandomColor;
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/lxh/info.plist" ofType:nil];
        self.lxhCollection.emotions = [VSAEmotion objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]] ;
    }
    
    return _lxhCollection;
}

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        //1. contentView
        UIView *contentView = [[UIView alloc] init];
        [self addSubview:contentView];
        self.contentView = contentView;
        //2. tabBar
        VSAEmotionTabBar *tabBar = [[VSAEmotionTabBar alloc] init];
        self.tabBar = tabBar;
        tabBar.delegate = self;
        //        tabBar.backgroundColor = VSARandomColor;
        [self addSubview:tabBar];
//        
//        VSAEmotionCollection *collection = [[VSAEmotionCollection alloc] init];
//        self.collection = collection;
//        collection.backgroundColor = VSARandomColor;
//        [self addSubview:collection];
    }
    
    return self;
}

- (void)layoutSubviews {
    CGFloat tabBarW = self.width;
    CGFloat tabBarH = 37;
    CGFloat tabBarX = 0;
    CGFloat tabBarY = self.height - tabBarH;
    self.tabBar.frame = CGRectMake(tabBarX, tabBarY, tabBarW, tabBarH);
    
    //contentView
    CGFloat contentW = self.width;
    CGFloat contentH = tabBarY;
    CGFloat contentX = 0;
    CGFloat contentY = 0;
    self.contentView.frame = CGRectMake(contentX, contentY, contentW, contentH);
    
    //contentView子控件的frame
    VSAEmotionCollection *child = [self.contentView.subviews lastObject];
    child.frame = self.contentView.bounds;
}

#pragma mark - VSAEmotionTabBarDelegate
- (void)tabBarDidClickButton:(VSAEmotionTabBar *)tabBar button:(VSAEmotionTabBarButtonType)type {
    
    //清空contentView中子控件
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    switch (type) {
        case VSAEmotionTabBarButtonTypeRecent:{
            [self.contentView addSubview:self.recentCollection];
            break;
        }
        case VSAEmotionTabBarButtonTypeDefault:{
            [self.contentView addSubview:self.defaultCollection];
            break;
        }
        case VSAEmotionTabBarButtonTypeEmoji: {
            [self.contentView addSubview:self.emojiCollection];
            break;
        }
        case VSAEmotionTabBarButtonTypeLang: {
            [self.contentView addSubview:self.lxhCollection];
            break;
        }
        default:
            break;
    }
    
    //刷新控件布局
    [self setNeedsLayout];
}

@end
