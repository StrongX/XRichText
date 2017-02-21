//
//  XRichTextImageCell.m
//  XRichText
//
//  Created by xlx on 17/2/21.
//  Copyright © 2017年 xlx. All rights reserved.
//

#import "XRichTextImageCell.h"

@implementation XRichTextImageCell
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    [self initUI];
    return self;
}
-(void)initUI{
    self.backgroundColor = [UIColor whiteColor];
    
}
-(void)initImageView{
    if (_imageView) {
        [_imageView removeFromSuperview];
    }
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self.contentView addSubview:_imageView];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.layer.masksToBounds = true;
}
-(void)setDataSource:(NSDictionary *)dataSource{
    _dataSource = dataSource;
    _imageView.image = dataSource[@"image"];
}

@end
