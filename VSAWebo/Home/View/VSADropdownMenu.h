//
//  VSADropdownMenu.h
//  VSAWebo
//
//  Created by alvin on 15/8/13.
//  Copyright (c) 2015年 alvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VSADropdownMenu;

@protocol VSADropdownMenuDelegate <NSObject>

@optional
- (void)dropdownMenuDidDismiss:(VSADropdownMenu *)dropdownMenu;
- (void)dropdownMenuDidShow:(VSADropdownMenu *)dropdownMenu;
@end

@interface VSADropdownMenu : UIView

@property (nonatomic, strong) UIView *content;
@property (nonatomic, strong) UIViewController *contentVC;
@property (nonatomic, weak) id<VSADropdownMenuDelegate> delegate;

+ (instancetype)dropdownMenu;
- (void)showFrom:(UIView *)from;
//点击view时，用来移除View
- (void)dismiss;
@end
