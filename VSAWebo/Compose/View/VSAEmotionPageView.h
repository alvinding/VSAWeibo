//
//  VSAEmotionPageView.h
//  VSAWebo
//
//  Created by alvin on 15/9/9.
//  Copyright (c) 2015年 alvin. All rights reserved.
//

#define VSAEmotionMaxCols 7
#define VSAEmotionMaxRows 3
#define VSAEmotionPageSize (VSAEmotionMaxCols * VSAEmotionMaxRows - 1)

#import <UIKit/UIKit.h>

@interface VSAEmotionPageView : UIView
@property (nonatomic, strong) NSArray *emotions;
@end
