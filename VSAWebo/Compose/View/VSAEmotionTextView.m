//
//  VSAEmotionTextView.m
//  VSAWebo
//
//  Created by alvin on 15/9/16.
//  Copyright (c) 2015年 alvin. All rights reserved.
//

#import "VSAEmotionTextView.h"
#import "VSAEmotion.h"

@implementation VSAEmotionTextView

- (void)insertEmotion:(VSAEmotion *)emotion {
    if (emotion.code) {
        [self insertText:emotion.code.emoji];
    } else if (emotion.png) {
        //        [self.textView insertText:emotion.chs]; //实际上发送微博要的是emotion.chs [哈哈]
        
        //图片attach
        NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
        attachment.image = [UIImage imageNamed:emotion.png];
        CGFloat fontHeight = self.font.lineHeight;
        attachment.bounds = CGRectMake(0, -4, fontHeight, fontHeight);
        NSAttributedString *attributed = [NSAttributedString attributedStringWithAttachment:attachment];
        
        [self insertAttributedText:attributed settingFontBlock:^(NSMutableAttributedString *attributedString) {
            //拿到所有内容，设置大小
            [attributedString addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, attributedString.length)];
        }];
    }
}

//1.声明一个block变量
/**
 void (^settingFontBlock)(NSMutableAttributedString *) = ^(NSMutableAttributedString *attributedString) {
 [attributedString addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, attributedString.length)];
 };
 [self insertAttributedText:attributed settingFontBlock:settingFontBlock];
 */

@end
