//
//  XRichCollectionView.h
//  XRichText
//
//  Created by xlx on 17/2/21.
//  Copyright © 2017年 xlx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKeyBoard.h"
#import "XRichTextImageCell.h"
#import "XRichTextCell.h"
#import "XCollectionViewFlowLayout.h"

@protocol XRichCollectionViewDelegate <NSObject>

-(void)textHeightChange;
-(NSInteger)returnTheItemSelected:(CGFloat)y;
-(void)replaceImage:(NSIndexPath *)indexPath;
@end

@interface XRichCollectionView : UICollectionView<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,KeyBoardDlegate,XRichTextCellDelegate,XCollectionViewFlowLayoutDataSource,XCollectionViewFlowLayoutDelegate>

@property(nonatomic,strong) NSMutableArray *dataArray;


/*
 * 添加图片
 */
-(void)addImage:(UIImage *)image;
/*
 * 添加文字
 */
-(void)addText:(NSString *)text;
/*
 * 替换图片
 */
-(void)replaceImage:(UIImage *)image indexPaht:(NSIndexPath *)indexPath;

@property (nonatomic, strong) id<XRichCollectionViewDelegate> collectionDelegate;

@end


@interface UIImage(Extension)


/**
 *  压缩图片
 *
 *  @return 返回压缩后的图片
 */
-(UIImage *)imageCompress:(CGFloat)targetWidth;
@end
