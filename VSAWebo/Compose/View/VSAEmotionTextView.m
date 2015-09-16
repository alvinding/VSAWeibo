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
        
        //拼接当前显示的文字
        NSMutableAttributedString *aString = [[NSMutableAttributedString alloc] init];
        [aString appendAttributedString:self.attributedText];
        
        NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
        attachment.image = [UIImage imageNamed:emotion.png];
        //拼接图片attach
        NSAttributedString *attributed = [NSAttributedString attributedStringWithAttachment:attachment];
        
        //光标位置插入表情
        NSUInteger location = self.selectedRange.location;
        [aString insertAttributedString:attributed atIndex:location];
        
        //设置大小
        CGFloat fontHeight = self.font.lineHeight;
        attachment.bounds = CGRectMake(0, -4, fontHeight, fontHeight);
        [aString addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, aString.length)];
        self.attributedText = aString;
        
        //重置光标位置为插入表情的后面
        self.selectedRange = NSMakeRange(location + 1, 0);
    }
}

@end
