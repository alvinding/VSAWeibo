//
//  VSAAccount.m
//  VSAWebo
//
//  Created by alvin on 15/8/17.
//  Copyright (c) 2015年 alvin. All rights reserved.
//

#import "VSAAccount.h"

@implementation VSAAccount
+ (instancetype)accountWithDict:(NSDictionary *)dict {
    VSAAccount *account = [[self alloc] init];
    account.access_token = dict[@"access_token"];
    account.expires_in = dict[@"expires_in"];
    account.uid = dict[@"uid"];
    
    return account;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_access_token forKey:@"access_token"];
    [encoder encodeObject:_expires_in forKey:@"expires_in"];
    [encoder encodeObject:_uid forKey:@"uid"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _access_token = [aDecoder decodeObjectForKey:@"access_token"];
        _expires_in = [aDecoder decodeObjectForKey:@"expires_in"];
        _uid = [aDecoder decodeObjectForKey:@"uid"];
    }
    
    return self;
}
@end
