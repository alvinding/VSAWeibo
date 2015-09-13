//
//  VSASearchBar.m
//  VSAWebo
//
//  Created by alvin on 15/8/12.
//  Copyright (c) 2015年 alvin. All rights reserved.
//

#import "VSASearchBar.h"

@implementation VSASearchBar
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.background = [UIImage imageNamed:@"searchbar_textfield_background"];
        self.placeholder = @"请输入搜索条件";
        self.font = [UIFont systemFontOfSize:13];
        
        UIImageView *searchIcon = [[UIImageView alloc] init];
        UIImage *image = [UIImage imageNamed:@"searchbar_textfield_search_icon"];
        searchIcon.image = image;
        searchIcon.width = 30;
        searchIcon.height = 30;
        searchIcon.contentMode = UIViewContentModeCenter;
        self.leftView = searchIcon;
        self.leftViewMode = UITextFieldViewModeAlways;
    }
    return self;
}

+ (instancetype)searchBar {
    return [[self alloc] init];
}
@end
