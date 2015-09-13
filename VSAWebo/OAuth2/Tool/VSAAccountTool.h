//
//  VSAAccountTool.h
//  VSAWebo
//
//  Created by alvin on 15/8/18.
//  Copyright (c) 2015年 alvin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VSAAccount.h"

@interface VSAAccountTool : NSObject
+ (void)saveAccount:(VSAAccount *)account;
+ (VSAAccount *)account;
@end
