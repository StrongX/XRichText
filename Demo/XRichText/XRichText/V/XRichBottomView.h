//
//  XRichBottomView.h
//  XRichText
//
//  Created by xlx on 17/2/21.
//  Copyright © 2017年 xlx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XRichBottomViewDelegate <NSObject>

-(void)XRichchoiceImage;  //选择图片

-(void)XRichchoiceText;    //选择文本

@end

@interface XRichBottomView : UIView

// 禁止使用initWithFrame以外的方法进行初始化
-(instancetype) alloc __attribute__((unavailable("init not available, getShareInstance instead")));
-(instancetype) init __attribute__((unavailable("init not available, getShareInstance instead")));
-(instancetype) new __attribute__((unavailable("init not available, getShareInstance instead")));


+(instancetype)getShareInstanceWidth:(CGFloat)width Y:(CGFloat)Y;

@property (nonatomic, weak) id<XRichBottomViewDelegate> delegate;

@end
