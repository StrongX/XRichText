//
//  XRichCollectionView.h
//  XRichText
//
//  Created by xlx on 17/2/21.
//  Copyright © 2017年 xlx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XRichCollectionView : UICollectionView<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong) NSMutableArray *dataArray;

/*
 * 添加图片
 */
-(void)addImage:(UIImage *)image;

@end


@interface UIImage(Extension)


/**
 *  压缩图片
 *
 *  @return 返回压缩后的图片
 */
-(UIImage *)imageCompress:(CGFloat)targetWidth;
@end
