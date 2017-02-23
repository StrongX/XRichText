//
//  inputViewController.m
//  XRichText
//
//  Created by xlx on 17/2/21.
//  Copyright © 2017年 xlx. All rights reserved.
//



#import "inputViewController.h"
#import "XRichTextInputView.h"
@interface inputViewController ()<XRichTextInputViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation inputViewController
{
    XRichTextInputView *_richTextView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
    
}
- (void)initUI{
    self.view.backgroundColor = [UIColor  whiteColor];
    _richTextView = [[XRichTextInputView alloc] initWithFrame:(CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64))];
    [self.view addSubview:_richTextView];
    _richTextView.delegate = self;
}

-(void)XRichchoiceImage{  //选择图片
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择图片" message:@"你可以从相册选择或者相机" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectImageFromPhoto:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    [alert addAction:action1];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectImageFromPhoto:UIImagePickerControllerSourceTypeCamera];
    }];
    [alert addAction:action2];
    [self presentViewController:alert animated:true completion:^{
        
    }];

}
-(void)XRichchoiceText{    //选择文本
    [_richTextView addText:@""];
}
/*
 * 从相机或者相机选择图片
 */
-(void)selectImageFromPhoto:(UIImagePickerControllerSourceType)type{
    UIImagePickerController *picker = [UIImagePickerController new];
    picker.sourceType = type;
    picker.delegate = self;
    [self presentViewController:picker animated:true completion:^{
        
    }];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0){
    [_richTextView addImage:image];
    [_richTextView addImage:image];
    [_richTextView addImage:image];

    [picker dismissViewControllerAnimated:true completion:^{
        
    }];
    
}
@end
