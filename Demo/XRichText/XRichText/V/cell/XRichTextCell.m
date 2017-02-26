//
//  XRichTextCell.m
//  XRichText
//
//  Created by xlx on 17/2/22.
//  Copyright © 2017年 xlx. All rights reserved.
//

#import "XRichTextCell.h"

@implementation XRichTextCell


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
    _textView = [[UITextView alloc]init];
    _textView.translatesAutoresizingMaskIntoConstraints = false;
    _textView.delegate = self;
   // _textView.layer.borderColor = [[UIColor grayColor] CGColor];
   // _textView.layer.borderWidth = .5;
   // _textView.layer.cornerRadius = 10;
   // _textView.layer.masksToBounds = true;
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
}
-(void)setDataSource:(NSMutableDictionary *)dataSource{
    _dataSource = dataSource;
    _textView.text = dataSource[@"text"];
    _textView.editable = false;
    _textView.scrollEnabled = false;
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
        self.frame = selfFrame;
        [_delegate textHeightChange];
    }
}
-(BOOL)canBecomeFirstResponder{
    return true;
}

@end
