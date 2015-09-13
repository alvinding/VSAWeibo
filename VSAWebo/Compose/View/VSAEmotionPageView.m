//
//  VSAEmotionPageView.m
//  VSAWebo
//
//  Created by alvin on 15/9/9.
//  Copyright (c) 2015年 alvin. All rights reserved.
//


#import "VSAEmotionPageView.h"
#import "VSAEmotion.h"

@implementation VSAEmotionPageView

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
        UIButton *btn = [[UIButton alloc] init];
        
        if (emotion.png) {
            [btn setImage:[UIImage imageNamed:emotion.png] forState:UIControlStateNormal];
        } else if (emotion.code) {
            [btn setTitle:emotion.code.emoji forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:32];
        }
        
        [self addSubview:btn];
    }
    
    //添加删除按钮
    UIButton *delBtn = [[UIButton alloc] init];
    [delBtn setImage:[UIImage imageNamed:@"compose_emotion_delete"] forState:UIControlStateNormal];
    [self addSubview:delBtn];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat padding = 20;
    CGFloat width = (self.width - padding * 2) / VSAEmotionMaxCols;
    CGFloat height = (self.height - padding) / VSAEmotionMaxRows;
    
    for (int i = 0; i < self.subviews.count; i++) {
        UIButton *btn = self.subviews[i];
        NSUInteger row = i / VSAEmotionMaxCols;
        NSUInteger column = i % VSAEmotionMaxCols;        
        CGFloat x = column * width + padding;
        CGFloat y = row * height + padding;
        
        if (i == self.subviews.count - 1) {
            x = (VSAEmotionMaxCols - 1) * width + padding;
            y = (VSAEmotionMaxRows - 1) * height + padding;
        }
        btn.width = width;
        btn.height = height;
        btn.x = x;
        btn.y = y;
    }
    
    
}

@end
