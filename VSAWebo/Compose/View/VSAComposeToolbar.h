//
//  VSAComposeToolbar.h
//  VSAWebo
//
//  Created by alvin on 15/9/5.
//  Copyright (c) 2015年 alvin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, VSAComposeToolbarButtonType) {
    VSAComposeToolbarButtonTypePicture,
    VSAComposeToolbarButtonTypeTrend,
    VSAComposeToolbarButtonTypeMention,
    VSAComposeToolbarButtonTypeEmotion,
    VSAComposeToolbarButtonTypeCamera
};

@class VSAComposeToolbar;

@protocol VSAComposeToolbarDelegate <NSObject>
@optional
- (void)composeToolbar:(VSAComposeToolbar *)composeToolbar didClickButton:(VSAComposeToolbarButtonType)buttonType;
@end

@interface VSAComposeToolbar : UIView
@property (nonatomic, weak) id<VSAComposeToolbarDelegate> delegate;
@property (nonatomic, assign) BOOL showKeyboard;
@end
