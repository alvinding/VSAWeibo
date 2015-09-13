//
//  VSATextView.m
//  VSAWebo
//
//  Created by alvin on 15/9/1.
//  Copyright (c) 2015年 alvin. All rights reserved.
//

#import "VSATextView.h"

@implementation VSATextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.alwaysBounceVertical = YES;
        
        UILabel *label = [[UILabel alloc] init];
//        label.frame = CGRectMake(5, 8, 100, 50);
//        label.text = self.placeholder;
        self.placeholderLabel = label;
        
        [self addSubview:label];
        //通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)textDidChange {
    [self setNeedsDisplay];
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    //如果有输入文字了，就直接返回，不画了
    if (self.hasText) {
        self.placeholderLabel.text = nil;
        return;
    }
    
    CGSize size = [self sizeWithText:self.placeholder font:self.font maxW:100];
    self.placeholderLabel.frame = CGRectMake(6, 8, size.width, size.height);
    self.placeholderLabel.text = self.placeholder;
    self.placeholderLabel.font = self.font;
    self.placeholderLabel.textColor = [UIColor grayColor];
    /*
    //文字属性
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = self.font;
    attrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    CGFloat x = 5;
    CGFloat y = 8;
    CGFloat w = rect.size.width - 2 * x;
    CGFloat h = rect.size.height - 2 * y;
    CGRect placeholderRect = CGRectMake(x, y, w, h);
    
    //在制定的rect区域，使用指定的属性画出文字
    [self.placeholder drawInRect:placeholderRect withAttributes:attrs];
     */
}

- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxW:(CGFloat)maxW
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
@end
