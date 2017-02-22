//
//  XRichBottomView.m
//  XRichText
//
//  Created by xlx on 17/2/21.
//  Copyright © 2017年 xlx. All rights reserved.
//

#import "XRichBottomView.h"

@implementation XRichBottomView
{
    UIButton *_insertImage;
    UIButton *_insertText;
    CGFloat _bottom_width;
}
+(instancetype)getShareInstanceWidth:(CGFloat)width Y:(CGFloat)Y{
    static dispatch_once_t onceToken;
    static XRichBottomView *_bottom;

    dispatch_once(&onceToken, ^{
        _bottom = [[XRichBottomView alloc]initWithFrame:CGRectMake(0, Y, width, 44)];
        [_bottom initUI];
    });
    return _bottom;
}

-(void)initUI{
    _bottom_width = self.frame.size.width;
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderWidth = 1;
    self.layer.borderColor = [[UIColor grayColor] CGColor];
    
    _insertImage = [[UIButton alloc]initWithFrame:CGRectMake((_bottom_width-100)/2, 6, 30, 30)];
    _insertText = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_insertImage.frame)+40, 6, 30, 30)];
    [self addSubview:_insertImage];
    [self addSubview:_insertText];
    [_insertImage setImage:[UIImage imageNamed:@"post01_icon_b"] forState:0];
    [_insertText setImage:[UIImage imageNamed:@"post01_icon_c"] forState:0];
    
    [_insertImage addTarget:self action:@selector(XRichchoiceImage) forControlEvents:1<<6];
    [_insertText addTarget:self action:@selector(XRichchoiceText) forControlEvents:1<<6];
}
-(void)XRichchoiceImage{  //选择图片
    [_delegate XRichchoiceImage];
}
-(void)XRichchoiceText{    //选择文本
    [_delegate XRichchoiceText];
}
@end
