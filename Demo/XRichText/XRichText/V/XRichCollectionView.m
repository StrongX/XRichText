//
//  XRichCollectionView.m
//  XRichText
//
//  Created by xlx on 17/2/21.
//  Copyright © 2017年 xlx. All rights reserved.
//

#import "XRichCollectionView.h"
#import "XRichTextImageCell.h"
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
    self.delegate = self;
    self.dataSource = self;
}

/*
 * 添加图片
 */
-(void)addImage:(UIImage *)image{
    image = [image imageCompress:1000];
    NSDictionary *data = @{@"flag":@"1",@"height":@(image.size.height),@"width":@(image.size.width),@"image":image};
    [_dataArray addObject:data];
    [self reloadData];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArray.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *data = _dataArray[indexPath.row];
    XRichTextImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ImageCellIdentify forIndexPath:indexPath];
    [cell initImageView];
    cell.dataSource = data;
    return cell;
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
