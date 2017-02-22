//
//  XRichCollectionView.m
//  XRichText
//
//  Created by xlx on 17/2/21.
//  Copyright © 2017年 xlx. All rights reserved.
//

#import "XRichCollectionView.h"

static NSString *ImageCellIdentify = @"ImageCellIdentify";
static NSString *TextCellIdentify = @"TextCellIdentify";

@implementation XRichCollectionView

-(id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    [self initUI];
    return self;
}
-(void)initUI{
    _dataArray = [@[] mutableCopy];
    self.backgroundColor = [UIColor whiteColor];
    [self registerClass:[XRichTextImageCell class] forCellWithReuseIdentifier:ImageCellIdentify];
    [self registerClass:[XRichTextCell class] forCellWithReuseIdentifier:TextCellIdentify];
    self.delegate = self;
    self.dataSource = self;
    [XKeyBoard registerKeyBoardHide:self];
    [XKeyBoard registerKeyBoardShow:self];
}

/*
 * 添加图片
 */
-(void)addImage:(UIImage *)image{
    image = [image imageCompress:1000];
    NSMutableDictionary *data = [@{@"flag":@"1",@"height":@(image.size.height),@"width":@(image.size.width),@"image":image} mutableCopy];
    [_dataArray addObject:data];
    [self reloadData];
}
/*
 * 添加文字
 */
-(void)addText:(NSString *)text{
    NSMutableDictionary *data = [@{@"flag":@"2",@"height":@(60),@"text":text} mutableCopy];
    [_dataArray addObject:data];
    [self reloadData];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArray.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *data = _dataArray[indexPath.row];
    if ([data[@"flag"] isEqualToString:@"1"]) {   //表明是图片
        XRichTextImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ImageCellIdentify forIndexPath:indexPath];
        cell.dataSource = data;
        return cell;
    }else{
        __weak XRichCollectionView *wself = self;
        XRichTextCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TextCellIdentify forIndexPath:indexPath];
        cell.dataSource = data;
        cell.delegate = self;
        cell.refreshBlock = ^{
            [wself reloadData];
        };
        return cell;
    }
    
}

#pragma  mark - KeyBoardDlegate

-(void)keyboardWillHideNotification:(NSNotification *)notification{
    double keyboardDuration = [XKeyBoard returnKeyBoardDuration:notification];
    
    [UIView animateWithDuration:keyboardDuration animations:^{
        [self setContentInset:UIEdgeInsetsZero];
    }];
}
-(void)keyboardWillShowNotification:(NSNotification *)notification{
    
    CGRect keyboardWindow = [XKeyBoard returnKeyBoardWindow:notification];
    double keyboardDuration = [XKeyBoard returnKeyBoardDuration:notification];
    [UIView animateWithDuration:keyboardDuration animations:^{
        [self setContentInset:UIEdgeInsetsMake(0, 0, keyboardWindow.size.height, 0)];
        
    }];
}

#pragma mark - XRichTextCellDelegate
-(void)textHeightChange{
    [_collectionDelegate textHeightChange];
}
@end









@implementation UIImage(Extension)
/**
 *  压缩图片
 *
 *  @return 返回压缩后的图片
 */
-(UIImage *) imageCompress:(CGFloat)targetWidth
{
    CGFloat width = self.size.width;
    CGFloat height = self.size.height;
    CGFloat targetHeight = (targetWidth / width) * height;
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [self drawInRect:CGRectMake(0,0,targetWidth,  targetHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


@end
