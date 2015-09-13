//
//  VSAAccountTool.m
//  VSAWebo
//
//  Created by alvin on 15/8/18.
//  Copyright (c) 2015年 alvin. All rights reserved.
//

//保存账号的路径
#define VSAAccountPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.archive"]

#import "VSAAccountTool.h"

@implementation VSAAccountTool

+ (void)saveAccount:(VSAAccount *)account {
    [NSKeyedArchiver archiveRootObject:account toFile:VSAAccountPath];
}

+ (VSAAccount *)account {
    VSAAccount *account = [NSKeyedUnarchiver unarchiveObjectWithFile:VSAAccountPath];
    
    //暂时先考虑过期的问题
    return account;
}
@end
