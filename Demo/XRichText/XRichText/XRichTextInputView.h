//
//  XRichTextInputView.h
//  XRichText
//
//  Created by xlx on 17/2/21.
//  Copyright © 2017年 xlx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XRichBottomView.h"

@protocol XRichTextInputViewDelegate <NSObject>

-(void)XRichchoiceImage;  //选择图片

-(void)XRichchoiceText;    //选择文本
@end

@interface XRichTextInputView : UIView<XRichBottomViewDelegate>

// 禁止使用initWithFrame以外的方法进行初始化
-(instancetype) init __attribute__((unavailable("init not available, initWithFrame instead")));
+(instancetype) new __attribute__((unavailable("new not available, initWithFrame instead")));


@property (nonatomic, weak) id<XRichTextInputViewDelegate> delegate;

/*
 * 添加图片
 */
-(void)addImage:(UIImage *)image;

@end
