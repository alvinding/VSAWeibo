//
//  VSAEmotionButton.m
//  VSAWebo
//
//  Created by alvin on 15/9/15.
//  Copyright (c) 2015年 alvin. All rights reserved.
//

#import "VSAEmotionButton.h"
#import "VSAEmotion.h"

@implementation VSAEmotionButton

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    
    return self;
}

- (void)setup {
    self.titleLabel.font = [UIFont systemFontOfSize:32];
}

-(void)setEmotion:(VSAEmotion *)emotion {
    _emotion = emotion;
    
    if (_emotion.png) {
        [self setImage:[UIImage imageNamed:emotion.png] forState:UIControlStateNormal];
    } else if (_emotion.code) {
        [self setTitle:emotion.code.emoji forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:32];
    }
}

@end
