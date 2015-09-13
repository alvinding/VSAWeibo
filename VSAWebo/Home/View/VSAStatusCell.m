//
//  VSAStatusCell.m
//  VSAWebo
//
//  Created by alvin on 15/8/28.
//  Copyright (c) 2015年 alvin. All rights reserved.
//

#import "VSAStatusCell.h"
#import "VSAStatusFrame.h"
#import "VSAStatus.h"
#import "VSAUser.h"
#import "VSAPhoto.h"
#import "UIImageView+WebCache.h"

#define VSANameFont [UIFont systemFontOfSize:15]
#define VSATextFont [UIFont systemFontOfSize:16]

@implementation VSAStatusCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"status";
    VSAStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[VSAStatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        UIImageView *userImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:userImageView];
        self.userImageView = userImageView;
        
        UILabel *userLabel = [[UILabel alloc] init];
        userLabel.font = VSANameFont;
        [self.contentView addSubview:userLabel];
        self.userLabel = userLabel;
        
        UIImageView *verifiedImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:verifiedImageView];
        self.verifiedImageView = verifiedImageView;
        
        UILabel *createDate = [[UILabel alloc] init];
        [self.contentView addSubview:createDate];
        self.createDate = createDate;
        
        UILabel *source = [[UILabel alloc] init];
        [self.contentView addSubview:source];
        self.source = source;
        
        UILabel *text = [[UILabel alloc] init];
        text.font = VSATextFont;
        text.numberOfLines = 0;
        [self.contentView addSubview:text];
        self.text = text;
        
        UIImageView *profileImage = [[UIImageView alloc] init];
        [self.contentView addSubview:profileImage];
        self.profileImageView = profileImage;
        
        UIButton *retweetedView = [[UIButton alloc] init];
        [retweetedView setBackgroundImage:[UIImage imageNamed:@"timeline_retweet_background"] forState:UIControlStateNormal];
        [retweetedView setBackgroundImage:[UIImage imageNamed:@"timeline_retweet_background_highlighted"] forState:UIControlStateHighlighted];
        [self.contentView addSubview:retweetedView];
        self.retweetedView = retweetedView;
        
        UILabel *retweetedContent = [[UILabel alloc] init];
        retweetedContent.font = VSATextFont;
        retweetedContent.numberOfLines = 0;
        [self.retweetedView addSubview:retweetedContent];
        self.retweetedContent = retweetedContent;
        
        UIImageView *retweetedImage = [[UIImageView alloc] init];
        [self.retweetedView addSubview:retweetedImage];
        self.retweetedImage = retweetedImage;
    }
    
    return self;
}

- (void)setStatusFrame:(VSAStatusFrame *)statusFrame {
    _statusFrame = statusFrame;
    
    //给子控件赋值
    [self settingData];
    //设置子控件frame
    [self settingFrame];
}

- (void)settingData {
    VSAStatus *status = self.statusFrame.status;
    VSAUser *user = status.user;
    
    self.userLabel.text = status.user.name;
    
    if (user.verified) {
        [self.verifiedImageView setImage:[UIImage imageNamed:@"avatar_enterprise_vip"]];
    }
    self.text.text = status.text;
    if (status.pic_urls.count) {
        /** 只显示第一张图 */
        VSAPhoto *photo = [status.pic_urls firstObject];
        [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:photo.thumbnail_pic] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
        self.profileImageView.hidden = NO;
    } else {
        self.profileImageView.hidden = YES;
    }
    
    VSAStatus *retweetedStatus = status.retweeted_status;
    if (retweetedStatus) {
        self.retweetedContent.text = [NSString stringWithFormat:@"%@ : %@", retweetedStatus.user.name, retweetedStatus.text];
        if (retweetedStatus.pic_urls.count) {
            VSAPhoto *photo = [retweetedStatus.pic_urls firstObject];
            [self.retweetedImage sd_setImageWithURL:[NSURL URLWithString:photo.thumbnail_pic] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
            self.retweetedImage.hidden = NO;
        } else {
            self.retweetedImage.hidden = YES;
        }
        self.retweetedView.hidden = NO;
    } else {
        self.retweetedView.hidden = YES;
    }
}

- (void)settingFrame {
    VSAStatus *status = self.statusFrame.status;
    VSAUser *user = status.user;
    
    self.userImageView.frame = self.statusFrame.userImageFrame;
    [self.userImageView sd_setImageWithURL:[NSURL URLWithString:user.profile_image_url] placeholderImage:[UIImage imageNamed:@"avatar_default_small"]];
    self.userLabel.frame = self.statusFrame.userNameFrame;
    
    if (user.verified) {
        self.verifiedImageView.frame = self.statusFrame.verifiedFrame;
    }
    self.text.frame = self.statusFrame.textFrame;
    
    if (status.pic_urls.count) {
        self.profileImageView.frame = self.statusFrame.profileImageFrame;
    }
    
    VSAStatus *retweetedStatus = status.retweeted_status;
    if (retweetedStatus) {
        self.retweetedView.frame = self.statusFrame.retweetedFrame;
        self.retweetedContent.frame = self.statusFrame.retweetedContentFrame;
        if (retweetedStatus.pic_urls.count) {
            self.retweetedImage.frame = self.statusFrame.retweetedImageFrame;
        }
    }
}

@end
