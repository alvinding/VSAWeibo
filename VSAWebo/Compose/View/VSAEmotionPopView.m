//
//  VSAEmotionPopView.m
//  VSAWebo
//
//  Created by alvin on 15/9/15.
//  Copyright (c) 2015年 alvin. All rights reserved.
//

#import "VSAEmotionPopView.h"
#import "VSAEmotionButton.h"
#import "VSAEmotion.h"

@interface VSAEmotionPopView ()
@property (weak, nonatomic) IBOutlet VSAEmotionButton *emotionBtn;

@end

@implementation VSAEmotionPopView

+ (instancetype)popView {
    VSAEmotionPopView *popView = [[[NSBundle mainBundle] loadNibNamed:@"VSAEmotionPopView" owner:nil options:nil] lastObject];
    return popView;
}

- (void)showFrom:(VSAEmotionButton *)btn {
    if (!btn) {
        return;
    }
    self.emotionBtn.emotion = btn.emotion;
    
    //获取最上面的window
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    [window addSubview:self];
    
    CGRect btnFrame = [btn convertRect:btn.bounds toView:nil];
    CGFloat y = CGRectGetMidY(btnFrame) - self.height;
    CGFloat x = CGRectGetMidX(btnFrame);
    self.y = y;
    self.centerX = x;
}

@end
