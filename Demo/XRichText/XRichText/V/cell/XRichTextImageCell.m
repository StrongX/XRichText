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
    [self initImageView];
    
}
-(void)initImageView{
    if (_imageView) {
        [_imageView removeFromSuperview];
    }
    _imageView = [[UIImageView alloc]init];
    _imageView.translatesAutoresizingMaskIntoConstraints = false;
    [self.contentView addSubview:_imageView];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.layer.masksToBounds = true;
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    [self.contentView addConstraint:leftConstraint];
   
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    [self.contentView addConstraint:rightConstraint];
    
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    [self.contentView addConstraint:topConstraint];
    
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    [self.contentView addConstraint:bottomConstraint];
    
}
-(void)setDataSource:(NSDictionary *)dataSource{
    _dataSource = dataSource;
    _imageView.image = dataSource[@"image"];
}
-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
}
-(BOOL)canBecomeFirstResponder{
    return true;
}



@end



