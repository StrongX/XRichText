//
//  XRichTextCell.h
//  XRichText
//
//  Created by xlx on 17/2/22.
//  Copyright © 2017年 xlx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XRichTextCellDelegate <NSObject>

-(void)textHeightChange;

@end

@interface XRichTextCell : UICollectionViewCell<UITextViewDelegate>

@property (nonatomic, strong) NSMutableDictionary *dataSource;

@property (nonatomic, strong) UITextView *textView;

@property (nonatomic ,strong) void(^refreshBlock)();

@property (nonatomic, strong) id<XRichTextCellDelegate>delegate;

@property (nonatomic, strong)  UIImageView *lineView;

@end

