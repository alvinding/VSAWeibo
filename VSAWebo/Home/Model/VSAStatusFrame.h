//
//  VSAStatusFrame.h
//  VSAWebo
//
//  Created by alvin on 15/8/28.
//  Copyright (c) 2015年 alvin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class VSAStatus;

@interface VSAStatusFrame : NSObject
@property (nonatomic, assign) CGRect userImageFrame;
@property (nonatomic, assign) CGRect userNameFrame;
@property (nonatomic, assign) CGRect verifiedFrame;
@property (nonatomic, assign) CGRect createDateFrame;
@property (nonatomic, assign) CGRect sourceFrame;
@property (nonatomic, assign) CGRect textFrame;
@property (nonatomic, assign) CGRect profileImageFrame;
@property (nonatomic, assign) CGRect retweetedFrame;
@property (nonatomic, assign) CGRect retweetedContentFrame;
@property (nonatomic, assign) CGRect retweetedImageFrame;
@property (nonatomic, strong) VSAStatus *status;
/**
 *  cell的高度
 */
@property (nonatomic, assign) CGFloat cellHeight;
@end
