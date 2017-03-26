//
//  XRichTextCell.m
//  XRichText
//
//  Created by xlx on 17/2/22.
//  Copyright © 2017年 xlx. All rights reserved.
//

#import "XRichTextCell.h"

@implementation XRichTextCell
{

}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    [self initUI];
    return self;
}
/*
 * 初始化UI
 */
-(void)initUI{
    if (_textView) {
        [_textView removeFromSuperview];
    }
    if (_lineView) {
        [_lineView removeFromSuperview];
    }
    _lineView = [[UIImageView alloc] init];
    _lineView.image = [self drawLineByImageView:_lineView];
    _lineView.backgroundColor = [UIColor whiteColor];
    _lineView.translatesAutoresizingMaskIntoConstraints = false;
    [self.contentView addSubview:_lineView];

    _textView = [[UITextView alloc]init];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.font = [UIFont systemFontOfSize:17];
    _textView.translatesAutoresizingMaskIntoConstraints = false;
    _textView.delegate = self;
    _textView.userInteractionEnabled = false;
    [self.contentView addSubview:_textView];
    _textView.contentMode = UIViewContentModeScaleAspectFill;
    _textView.layer.masksToBounds = true;

    
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:_textView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    [self.contentView addConstraint:leftConstraint];
    
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:_textView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    [self.contentView addConstraint:rightConstraint];
    
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:_textView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    [self.contentView addConstraint:topConstraint];
    
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:_textView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    [self.contentView addConstraint:bottomConstraint];
    
    
    NSLayoutConstraint *lineViewleftConstraint = [NSLayoutConstraint constraintWithItem:_lineView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    [self.contentView addConstraint:lineViewleftConstraint];
    
    NSLayoutConstraint *lineViewrightConstraint = [NSLayoutConstraint constraintWithItem:_lineView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    [self.contentView addConstraint:lineViewrightConstraint];
    
    NSLayoutConstraint *lineViewtopConstraint = [NSLayoutConstraint constraintWithItem:_lineView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    [self.contentView addConstraint:lineViewtopConstraint];
    
    NSLayoutConstraint *lineViewbottomConstraint = [NSLayoutConstraint constraintWithItem:_lineView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    [self.contentView addConstraint:lineViewbottomConstraint];
}
-(void)setDataSource:(NSMutableDictionary *)dataSource{
    _dataSource = dataSource;
    _lineView.image = [self drawLineByImageView:_lineView];
    _textView.text = dataSource[@"text"];
    if ([_dataSource[@"edit"] isEqualToString:@"1"]) {
       // _lineView.hidden = false;
      //  _textView.userInteractionEnabled = true;
        [_textView becomeFirstResponder];
    }else{
      //  _textView.userInteractionEnabled = false;
       // _lineView.hidden = true;
        [_textView resignFirstResponder];
    }
}
#pragma mark - TextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    NSString *text = textView.text;
    _dataSource[@"text"] = text;
    if (_textView.contentSize.height>((NSNumber *)_dataSource[@"height"]).floatValue) {
        _dataSource[@"height"] = @(_textView.contentSize.height);
        CGFloat wid = SCREEN_WIDTH - 30;
        CGRect selfFrame = self.frame;
        selfFrame.size = CGSizeMake(wid, @(_textView.contentSize.height).floatValue);
      //  self.frame = selfFrame;
        _lineView.image = [self drawLineByImageView:_lineView];
        [_delegate textHeightChange];
    }
}
-(BOOL)canBecomeFirstResponder{
    return true;
}
// 返回虚线image的方法
- (UIImage *)drawLineByImageView:(UIImageView *)imageView{
    UIGraphicsBeginImageContext(self.bounds.size); //开始画线 划线的frame
//    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    //设置线条终点形状
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    // 5是每个虚线的长度 1是高度
    CGFloat lengths[] = {5,0.5};
    CGContextRef line = UIGraphicsGetCurrentContext();
    // 设置颜色
    CGContextSetStrokeColorWithColor(line, [UIColor blackColor].CGColor);
    CGContextSetLineDash(line, 0, lengths, 2); //画虚线
    CGContextMoveToPoint(line, 0.0, 0); //开始画线
    CGContextAddLineToPoint(line, self.frame.size.width, 0);
    CGContextAddLineToPoint(line, self.frame.size.width, self.frame.size.height);
    CGContextAddLineToPoint(line, 0, self.frame.size.height);
    CGContextAddLineToPoint(line, 0, 0);

    CGContextStrokePath(line);
    // UIGraphicsGetImageFromCurrentImageContext()返回的就是image
    return UIGraphicsGetImageFromCurrentImageContext();
}

@end
