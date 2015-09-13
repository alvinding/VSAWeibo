//
//  VSAStatus.h
//  VSAWebo
//
//  Created by alvin on 15/8/27.
//  Copyright (c) 2015年 alvin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@class VSAUser;
@class VSAStatus;

@interface VSAStatus : NSObject
/**
 *  字符串类型的微博id
 */
@property (nonatomic, copy) NSString *idstr;
/**
 *  微博内容
 */
@property (nonatomic, copy) NSString *text;
/**
 *  创建微博时间
 */
@property (nonatomic, copy) NSString *created_at;
/**
 *  微博来源
 */
@property (nonatomic, copy) NSString *source;
/**
 *  微博user
 */
@property (nonatomic, strong) VSAUser *user;
/**
 *  缩略图地址
 */
@property (nonatomic, strong) VSAStatus *retweeted_status;
@property (nonatomic, copy) NSString *thumbnail_pic;
@property (nonatomic, strong) NSArray *pic_urls;

//+(instancetype)statusWithDict: (NSDictionary *)dict;
@end
