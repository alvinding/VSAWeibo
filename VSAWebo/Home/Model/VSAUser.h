//
//  VSAUser.h
//  VSAWebo
//
//  Created by alvin on 15/8/27.
//  Copyright (c) 2015年 alvin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VSAUser : NSObject
/**
 *  user idstr
 */
@property (nonatomic, copy) NSString *idstr;
/**
 *  user name
 */
@property (nonatomic, copy) NSString *name;
/**
 *  是否为加V用户
 */
@property (nonatomic, assign) BOOL verified;
/**
 *  认证原因
 */
@property (nonatomic, copy) NSString *verified_reason;
/**
 *  user profile_image_url
 */
@property (nonatomic, copy) NSString *profile_image_url;

//+(instancetype)userWithDict: (NSDictionary *)dict;
@end
