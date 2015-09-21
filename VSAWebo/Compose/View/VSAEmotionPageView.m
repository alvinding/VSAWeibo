//
//  VSAEmotionPageView.m
//  VSAWebo
//
//  Created by alvin on 15/9/9.
//  Copyright (c) 2015年 alvin. All rights reserved.
//


#import "VSAEmotionPageView.h"
#import "VSAEmotion.h"
#import "VSAEmotionPopView.h"
#import "VSAEmotionButton.h"

@interface VSAEmotionPageView ()
@property (nonatomic, strong) UIButton *delButton;
@property (nonatomic, strong) VSAEmotionPopView *popView;
@end

@implementation VSAEmotionPageView

#pragma mark - 懒加载
-(VSAEmotionPopView *)popView {
    if (!_popView) {
        _popView = [VSAEmotionPopView popView];
    }
    
    return _popView;
}

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

    }
    
    return self;
}

- (void)setEmotions:(NSArray *)emotions {
    _emotions = emotions;
    
    for (int i = 0; i < emotions.count; i++) {
        VSAEmotion *emotion  = emotions[i];
        VSAEmotionButton *btn = [[VSAEmotionButton alloc] init];
        btn.emotion = emotion;
        [self addSubview:btn];
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    //添加删除按钮
    UIButton *delBtn = [[UIButton alloc] init];
    [delBtn setImage:[UIImage imageNamed:@"compose_emotion_delete"] forState:UIControlStateNormal];
    [delBtn addTarget:self action:@selector(delBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:delBtn];
    self.delButton = delBtn;
    
    //添加长按手势
    [self addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressPageView:)]];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat padding = 20;
    NSUInteger count = self.emotions.count;
    CGFloat width = (self.width - padding * 2) / VSAEmotionMaxCols;
    CGFloat height = (self.height - padding) / VSAEmotionMaxRows;
    
    for (int i = 0; i < count; i++) {
        UIButton *btn = self.subviews[i];
        NSUInteger row = i / VSAEmotionMaxCols;
        NSUInteger column = i % VSAEmotionMaxCols;        
        CGFloat x = column * width + padding;
        CGFloat y = row * height + padding;
        
//        if (i == self.subviews.count - 1) {
//            x = (VSAEmotionMaxCols - 1) * width + padding;
//            y = (VSAEmotionMaxRows - 1) * height + padding;
//        }
        btn.width = width;
        btn.height = height;
        btn.x = x;
        btn.y = y;
    }
    
    //设置delButton位置
    self.delButton.width = width;
    self.delButton.height = height;
    self.delButton.x = self.width - width - padding;
    self.delButton.y = self.height - height;
}

#pragma mark - 监听事件
- (void)btnClick:(VSAEmotionButton *)btn {
//    [self addSubview:self.popView];
    [self.popView showFrom:btn];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.popView removeFromSuperview];
    });
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[VSASelectedEmotionButtonKey] = btn.emotion;
    
    //通知，让controller 接收到，因为textView在controll中
    [[NSNotificationCenter defaultCenter] postNotificationName:VSAEmotionButtonDidSelectNotification object:nil userInfo:userInfo];
    
}

- (void)delBtnClick:(UIButton *)btn {
    [[NSNotificationCenter defaultCenter] postNotificationName:VSADeleteButtonDidSelectNotification object:nil];
}

- (void)longPressPageView:(UILongPressGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:recognizer.view];
    VSAEmotionButton *button = [self emotionButtonWithLocation:location];
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan: {
            [self.popView showFrom:button];
            break;
        }
        case UIGestureRecognizerStateChanged: {
            [self.popView showFrom:button];
            break;
        }
        case UIGestureRecognizerStateEnded: {
            [self.popView removeFromSuperview];
            
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            userInfo[VSASelectedEmotionButtonKey] = button.emotion;
            
            //通知，让controller 接收到，因为textView在controll中
            [[NSNotificationCenter defaultCenter] postNotificationName:VSAEmotionButtonDidSelectNotification object:nil userInfo:userInfo];
            break;
        }
        case UIGestureRecognizerStateCancelled: {
            
            break;
        }
        default:
            break;
    }
}

- (VSAEmotionButton *)emotionButtonWithLocation:(CGPoint)location {
    NSUInteger count = self.emotions.count;
    for (int i = 0; i < count; i++) {
        VSAEmotionButton *button = self.subviews[i];
        if (CGRectContainsPoint(button.frame, location)) {
            return button;
        }
    }
    
    return nil;
}

@end
