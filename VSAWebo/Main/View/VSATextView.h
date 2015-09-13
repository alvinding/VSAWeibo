//
//  VSATextView.h
//  VSAWebo
//
//  Created by alvin on 15/9/1.
//  Copyright (c) 2015年 alvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VSATextView : UITextView 
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, weak) UILabel *placeholderLabel;
@end
