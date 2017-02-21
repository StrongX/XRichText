//
//  XRichTextImageCell.h
//  XRichText
//
//  Created by xlx on 17/2/21.
//  Copyright © 2017年 xlx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XRichTextImageCell : UICollectionViewCell

@property (nonatomic, strong) NSDictionary *dataSource;

@property (nonatomic, strong) UIImageView *imageView;


-(void)initImageView; //构造图片
@end
