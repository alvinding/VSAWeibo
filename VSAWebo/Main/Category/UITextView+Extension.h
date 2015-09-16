//
//  UITextView+Extension.h
//  VSAWebo
//
//  Created by alvin on 15/9/16.
//  Copyright (c) 2015年 alvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (Extension)
- (void)insertAttributedText:(NSAttributedString *)text;
- (void)insertAttributedText:(NSAttributedString *)text settingFontBlock:(void (^)(NSMutableAttributedString *attributedString))settingBlock;
@end
