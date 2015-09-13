//
//  VSAStatus.m
//  VSAWebo
//
//  Created by alvin on 15/8/27.
//  Copyright (c) 2015年 alvin. All rights reserved.
//

#import "VSAStatus.h"
#import "VSAUser.h"
#import "MJExtension.h"
#import "VSAPhoto.h"

@implementation VSAStatus

//+(instancetype)statusWithDict:(NSDictionary *)dict {
//    VSAStatus *status = [[self alloc] init];
//    status.idstr = dict[@"idstr"];
//    status.text = dict[@"text"];
//    status.user = [VSAUser userWithDict:dict[@"user"]];
//    
//    return status;
//}

+ (NSDictionary *)objectClassInArray {
    return @{@"pic_urls" : [VSAPhoto class]};
}
@end
