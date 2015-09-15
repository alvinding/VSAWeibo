//
//  VSAEmotionPopView.h
//  VSAWebo
//
//  Created by alvin on 15/9/15.
//  Copyright (c) 2015年 alvin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VSAEmotion, VSAEmotionButton;

@interface VSAEmotionPopView : UIView
+ (instancetype)popView;
- (void)showFrom:(VSAEmotionButton *)btn;
//@property (nonatomic, strong) VSAEmotion *emotion;
@end
