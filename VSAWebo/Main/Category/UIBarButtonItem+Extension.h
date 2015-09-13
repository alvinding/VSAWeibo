//
//  UIBarButtonItem+Extension.h
//  VSAWebo
//
//  Created by alvin on 15/8/11.
//  Copyright (c) 2015年 alvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)
+(UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highlightImage:(NSString *)highlightImage;
@end
