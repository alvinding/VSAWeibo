//
//  VSAComposePhoto.m
//  VSAWebo
//
//  Created by alvin on 15/9/8.
//  Copyright (c) 2015年 alvin. All rights reserved.
//

#import "VSAComposePhoto.h"

@interface VSAComposePhoto ()
@end

@implementation VSAComposePhoto

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat x = 10;
        CGFloat y = 200;
        CGFloat frameWH = 80;
        self.frame = CGRectMake(x, y, frameWH, frameWH);        

    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
