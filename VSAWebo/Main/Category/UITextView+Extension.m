//
//  UITextView+Extension.m
//  VSAWebo
//
//  Created by alvin on 15/9/16.
//  Copyright (c) 2015年 alvin. All rights reserved.
//

#import "UITextView+Extension.h"

@implementation UITextView (Extension)
- (void)insertAttributedText:(NSAttributedString *)text {
    //拼接当前显示的文字
    NSMutableAttributedString *aString = [[NSMutableAttributedString alloc] init];
    [aString appendAttributedString:self.attributedText];
    
    //光标位置插入表情
    NSUInteger location = self.selectedRange.location;
    [aString insertAttributedString:text atIndex:location];
    
    self.attributedText = aString;
    
    //重置光标位置为插入表情的后面
    self.selectedRange = NSMakeRange(location + 1, 0);
}
@end
