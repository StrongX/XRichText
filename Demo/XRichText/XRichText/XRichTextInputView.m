//
//  XRichTextInputView.m
//  XRichText
//
//  Created by xlx on 17/2/21.
//  Copyright © 2017年 xlx. All rights reserved.
//

#import "XRichTextInputView.h"
#import "XCollectionViewFlowLayout.h"

@implementation XRichTextInputView
{
    CGFloat viewWidth;  //View的宽度
    CGFloat viewHeight; //View的高度
    XRichBottomView *_bottomView;
    XRichCollectionView *_collectionView;
    XCollectionViewFlowLayout *_layout;
    NSArray *_heightArr;  //保存所有cell高度信息
}
-(void)dealloc{
    NSLog(@"XRichTextInputView release");
}
+(instancetype)shareInstance:(CGRect)rect{
    XRichTextInputView *inputView = [[XRichTextInputView alloc]initWithFrame:rect];
    return inputView;
}
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    viewWidth = frame.size.width;
    viewHeight = frame.size.height;
    [self initUI];
    return self;
}

-(void)initUI{
    _bottomView = [XRichBottomView getShareInstanceWidth:viewWidth Y:viewHeight-44];
    _bottomView.delegate = self;
    [self addSubview:_bottomView];
    _layout = [XCollectionViewFlowLayout new];
    _layout.columnCount = 1;
    _layout.offset = 15;
    
    _collectionView = [[XRichCollectionView alloc]initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight-44) collectionViewLayout:_layout];
    _collectionView.collectionDelegate = self;
    [self addSubview:_collectionView];
}
/*
 * 选择图片响应动作
 */
-(void)XRichchoiceImage{
    [_delegate XRichchoiceImage];
}
/*
 * 选择文本响应动作
 */
-(void)XRichchoiceText{
    [_delegate XRichchoiceText];
}

/*
 * 添加图片
 */
-(void)addImage:(UIImage *)image{
    [_collectionView addImage:image];
}
/*
 * 添加文字
 */
-(void)addText:(NSString *)text{
    [_collectionView addText:text];
}
/*
 * 替换图片
 */
-(void)replaceImage:(UIImage *)image indexPaht:(NSIndexPath *)indexPath{
    [_collectionView replaceImage:image indexPaht:indexPath];
}
#pragma mark - XRichCollectionViewDelegate
-(void)textHeightChange{

}

-(NSInteger)returnTheItemSelected:(CGFloat)y{
    CGFloat offset = y;
    CGFloat nowY = 0;
    for (int i = 0; i<_heightArr.count; i++) {
        if (nowY<offset && nowY+((NSNumber *)_heightArr[i]).floatValue>offset) {
            return i;
        }
        nowY+=((NSNumber *)_heightArr[i]).floatValue;
    }
    return 0;
}
-(void)replaceImage:(NSIndexPath *)indexPath{
    [_delegate replaceImage:indexPath];
}
@end
