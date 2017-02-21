//
//  XRichTextInputView.m
//  XRichText
//
//  Created by xlx on 17/2/21.
//  Copyright © 2017年 xlx. All rights reserved.
//

#import "XRichTextInputView.h"
#import "XRichCollectionView.h"
#import "XRichCollectionViewFlowLayout.h"

@implementation XRichTextInputView
{
    CGFloat viewWidth;  //View的宽度
    CGFloat viewHeight; //View的高度
    XRichBottomView *_bottomView;
    XRichCollectionView *_collectionView;
    XRichCollectionViewFlowLayout *_layout;
    NSArray *_heightArr;        //保存所有高度信息
}
-(void)dealloc{
    NSLog(@"XRichTextInputView release");
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
    _collectionView = [[XRichCollectionView alloc]initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight-44) collectionViewLayout:self.layout];
    [self initHeightArr];
    [self addSubview:_collectionView];
}


-(UICollectionViewLayout *)layout{
    if(!_layout){
        __weak XRichTextInputView *wself = self;
        _layout = [[XRichCollectionViewFlowLayout alloc]initWithItemsHeightBlock:^CGFloat(NSIndexPath *index) {
            if (index.item>_heightArr.count-1 || _heightArr.count == 0) {       //当添加图片以后重新计算高度
                [wself initHeightArr];
            }
            return [_heightArr[index.item] floatValue];
        }];
        
    }
    return _layout;
}
-(void)initHeightArr{
    NSMutableArray *arr = [NSMutableArray array];
    CGFloat width = (viewWidth-colMargin*2)/colCount;
    for (NSDictionary *dict in _collectionView.dataArray) {
        NSNumber *imageHeight = dict[@"height"];
        NSNumber *imageWidth = dict[@"width"];
        CGFloat heightValue = width * imageHeight.floatValue/imageWidth.floatValue;
        [arr addObject:@(heightValue)];
    }
    _heightArr = [arr copy];
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
@end
