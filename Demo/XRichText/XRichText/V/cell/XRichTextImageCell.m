//
//  XRichTextImageCell.m
//  XRichText
//
//  Created by xlx on 17/2/21.
//  Copyright © 2017年 xlx. All rights reserved.
//

#import "XRichTextImageCell.h"

@implementation XRichTextImageCell
{
    UIImageView *_cutImage;
}
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    [self initUI];
    return self;
}
-(void)initUI{
    self.backgroundColor = [UIColor whiteColor];
    _cutImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,self.frame.size.width,self.frame.size.height)];
    // 调用方法 返回的iamge就是虚线
    _cutImage.image = [self drawLineByImageView:_cutImage];
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
    if ([_dataSource[@"cut"] isEqualToString:@"1"]) {
        [self.contentView addSubview:_cutImage];
    }else{
        [_cutImage removeFromSuperview];
    }
}
-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
}
-(BOOL)canBecomeFirstResponder{
    return true;
}

// 返回虚线image的方法
- (UIImage *)drawLineByImageView:(UIImageView *)imageView{
    UIGraphicsBeginImageContext(imageView.frame.size); //开始画线 划线的frame
    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    //设置线条终点形状
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    // 5是每个虚线的长度 1是高度
    CGFloat lengths[] = {5,1};
    CGContextRef line = UIGraphicsGetCurrentContext();
    // 设置颜色
    CGContextSetStrokeColorWithColor(line, [UIColor blackColor].CGColor);
    CGContextSetLineDash(line, 0, lengths, 2); //画虚线
    CGContextMoveToPoint(line, 0.0, 2.0); //开始画线
    CGContextAddLineToPoint(line, self.frame.size.width, 2.0);
    
    CGContextStrokePath(line);
    // UIGraphicsGetImageFromCurrentImageContext()返回的就是image
    return UIGraphicsGetImageFromCurrentImageContext();
}

@end



