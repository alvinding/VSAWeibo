//
//  VSAStatusCell.h
//  VSAWebo
//
//  Created by alvin on 15/8/28.
//  Copyright (c) 2015年 alvin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VSAStatusFrame;

@interface VSAStatusCell : UITableViewCell
@property (nonatomic, weak) UIImageView *userImageView;
@property (nonatomic, weak) UILabel *userLabel;
@property (nonatomic, weak) UIImageView *verifiedImageView;
@property (nonatomic, weak) UILabel *createDate;
@property (nonatomic, weak) UILabel *source;
@property (nonatomic, weak) UILabel *text;
@property (nonatomic, weak) UIImageView *profileImageView;
@property (nonatomic, weak) UIButton *retweetedView;
@property (nonatomic, weak) UILabel *retweetedContent;
@property (nonatomic, weak) UIImageView *retweetedImage;

@property (nonatomic, strong) VSAStatusFrame *statusFrame;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
