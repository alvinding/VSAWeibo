//
//  VSAStatusFrame.m
//  VSAWebo
//
//  Created by alvin on 15/8/28.
//  Copyright (c) 2015年 alvin. All rights reserved.
//

#import "VSAStatusFrame.h"
#import "VSAStatus.h"
#import "VSAUser.h"
#define VSANameFont [UIFont systemFontOfSize:15]
#define VSATextFont [UIFont systemFontOfSize:16]

@implementation VSAStatusFrame

- (void)setStatus:(VSAStatus *)status {
    _status = status;
    
    CGFloat padding = 10;
    
    self.userImageFrame = CGRectMake(padding, padding, 30, 30);
    
    CGFloat userNameLabelX = CGRectGetMaxX(self.userImageFrame) + padding;
//    CGSize userNameSize = [self sizeWithString:_status.user.name font:VSANameFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGSize userNameSize = [self sizeWithText:_status.user.name font:VSANameFont maxW:MAXFLOAT];
    CGFloat userNameLabelY = padding + (30 - userNameSize.height) * 0.5;
    self.userNameFrame = CGRectMake(userNameLabelX, userNameLabelY, userNameSize.width, userNameSize.height);
    
    /** 设置加V图标Frame */
    CGFloat verifiedX = CGRectGetMaxX(self.userNameFrame) + padding;
    CGFloat verifiedY = userNameLabelY;
    CGFloat verifiedWH = 15;
    self.verifiedFrame = CGRectMake(verifiedX, verifiedY, verifiedWH, verifiedWH);
    
    //设置text的frame
    CGFloat textLabelX = padding;
    CGFloat textLabelY = CGRectGetMaxY(self.userImageFrame) + padding;
//    CGSize textSize = [self sizeWithString:_status.text font:VSATextFont maxSize:CGSizeMake(300, MAXFLOAT)];
    CGSize textSize = [self sizeWithText:_status.text font:VSATextFont maxW:355];
    self.textFrame = CGRectMake(textLabelX, textLabelY, textSize.width, textSize.height);
    
    /** 设置缩略图的Frame */
    CGFloat originalH = 0;
    if (_status.pic_urls.count) {
        CGFloat photoWH = 100;
        CGFloat photoX = padding;
        CGFloat photoY = CGRectGetMaxY(self.textFrame) + padding;
        self.profileImageFrame = CGRectMake(photoX, photoY, photoWH, photoWH);
        
        //设置cell高度
        self.cellHeight = CGRectGetMaxY(self.profileImageFrame) + padding;
    } else {
        //设置cell高度
        self.cellHeight = CGRectGetMaxY(self.textFrame) + padding;
    }
    
    //设置转发内容的Frame
    if(_status.retweeted_status) {
        VSAStatus *retweetedStatus = _status.retweeted_status;
        NSString *content = [NSString stringWithFormat:@"%@ : %@", retweetedStatus.user.name, retweetedStatus.text];
        CGSize contentSize = [self sizeWithText:content font:VSATextFont maxW:355];
        self.retweetedContentFrame = CGRectMake(0, 0, contentSize.width, contentSize.height);
        
        CGFloat imageWH = 100;
        CGFloat imageX = padding;
        CGFloat imageY = CGRectGetMaxY(self.retweetedContentFrame) + padding;
        self.retweetedImageFrame = CGRectMake(imageX, imageY, imageWH, imageWH);
        
        CGFloat reTweetY = self.cellHeight + padding;
        CGFloat reTweetW = [UIScreen mainScreen].bounds.size.width - padding * 2;
        CGFloat reTweetH = contentSize.height + padding + imageWH;
        self.retweetedFrame = CGRectMake(padding, reTweetY, reTweetW, reTweetH);
        
        self.cellHeight = CGRectGetMaxY(self.retweetedFrame) + padding;
    } else {
        
    }
}

/**
   *  计算文本的宽高
   *
   *  @param str     需要计算的文本
   *  @param font    文本显示的字体
   *  @param maxSize 文本显示的范围
   *
   *  @return 文本占用的真实宽高
*/
 - (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize
 {
         NSDictionary *dict = @{NSFontAttributeName : font};
         // 如果将来计算的文字的范围超出了指定的范围,返回的就是指定的范围
         // 如果将来计算的文字的范围小于指定的范围, 返回的就是真实的范围
         CGSize size =  [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
         return size;
 }

- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxW:(CGFloat)maxW
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font
{
    return [self sizeWithText:text font:font maxW:MAXFLOAT];
}
@end
